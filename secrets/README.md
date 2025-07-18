# Secrets Management

This directory contains encrypted secrets managed with [SOPS](https://github.com/mozilla/sops) and [age](https://github.com/FiloSottile/age).

## Directory Structure

```
secrets/
├── global/           # Secrets accessible by all systems
├── hosts/           # Host-specific secrets
│   ├── apollo/      # Apollo desktop secrets
│   └── theia/       # Theia server secrets
├── services/        # Service-specific secrets
└── users/          # User-specific secrets
```

## Setup

### 1. Install Required Tools

```bash
# Install age for encryption
nix-shell -p age

# Install sops
nix-shell -p sops
```

### 2. Generate Age Keys

```bash
# Generate a new age key pair
age-keygen -o ~/.config/sops/age/keys.txt

# The public key will be displayed - add it to .sops.yaml
```

### 3. Update .sops.yaml

Replace the placeholder keys in `.sops.yaml` with your actual age public keys:

```yaml
keys:
  - &admin_key age1your_actual_public_key_here
  - &deploy_key age1your_deploy_public_key_here
```

## Usage

### Creating New Secrets

```bash
# Create a new secret file
sops secrets/global/example.yaml

# Edit existing secret
sops secrets/global/example.yaml
```

### Example Secret File Structure

```yaml
# secrets/global/example.yaml
api_keys:
  github_token: "your_github_token"
  openai_api_key: "your_openai_key"

database:
  password: "secure_password"
  connection_string: "postgresql://user:pass@host:5432/db"

certificates:
  ssl_cert: |
    -----BEGIN CERTIFICATE-----
    ...
    -----END CERTIFICATE-----
  ssl_key: |
    -----BEGIN PRIVATE KEY-----
    ...
    -----END PRIVATE KEY-----
```

### Using Secrets in NixOS

```nix
# In your NixOS configuration
{
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  sops = {
    defaultSopsFile = ../secrets/global/example.yaml;
    age.keyFile = "/home/user/.config/sops/age/keys.txt";
    
    secrets = {
      "api_keys/github_token" = {
        owner = "user";
        group = "users";
        mode = "0400";
      };
      "database/password" = {
        owner = "postgres";
        group = "postgres";
        mode = "0400";
      };
    };
  };

  # Use secrets in services
  services.some-service = {
    enable = true;
    passwordFile = config.sops.secrets."database/password".path;
  };
}
```

### Using Secrets in Home Manager

```nix
# In your home-manager configuration
{
  imports = [
    inputs.sops-nix.homeManagerModules.sops
  ];

  sops = {
    defaultSopsFile = ../secrets/users/example.yaml;
    age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
    
    secrets = {
      "ssh/private_key" = {
        path = "${config.home.homeDirectory}/.ssh/id_ed25519";
        mode = "0600";
      };
    };
  };
}
```

## Best Practices

1. **Separate Concerns**: Use different secret files for different purposes
2. **Least Privilege**: Only grant access to secrets that are actually needed
3. **Regular Rotation**: Rotate secrets regularly, especially for production systems
4. **Backup Keys**: Keep secure backups of your age private keys
5. **Version Control**: Never commit unencrypted secrets to version control

## Key Management

### Backup Your Keys

```bash
# Backup your age private key securely
cp ~/.config/sops/age/keys.txt /secure/backup/location/
```

### Adding New Keys

1. Generate new age key pair
2. Add public key to `.sops.yaml`
3. Re-encrypt existing secrets with new key:

```bash
# Re-encrypt all secrets with updated keys
find secrets -name "*.yaml" -exec sops updatekeys {} \;
```

### Revoking Keys

1. Remove the key from `.sops.yaml`
2. Re-encrypt all secrets:

```bash
find secrets -name "*.yaml" -exec sops updatekeys {} \;
```

## Troubleshooting

### Common Issues

1. **Permission Denied**: Ensure age key file has correct permissions (600)
2. **Key Not Found**: Verify the key path in your configuration
3. **Decryption Failed**: Check that your public key is listed in `.sops.yaml`

### Debugging

```bash
# Test decryption
sops -d secrets/global/example.yaml

# Check which keys can decrypt a file
sops -d --extract '["sops"]["age"]' secrets/global/example.yaml
```

## Security Considerations

- Age private keys should never be stored in this repository
- Use different keys for different environments (dev/staging/prod)
- Consider using hardware security modules for production keys
- Regularly audit who has access to which secrets
- Monitor secret access and usage