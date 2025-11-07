# Secrets Management with sops-nix

This directory contains encrypted secrets managed by [sops-nix](https://github.com/Mic92/sops-nix).

## Quick Setup Guide

### 1. Install sops and age on your host system

```bash
# Use the development shell (includes sops and age)
cd /Users/emmetdelaney/personal-code/nix-config
nix develop

# Or on NixOS, install temporarily
nix-shell -p sops age
```

### 2. Generate an age key for your host

```bash
# Create the directory
sudo mkdir -p /var/lib/sops-nix

# Generate the age key
sudo nix-shell -p age --run "age-keygen -o /var/lib/sops-nix/key.txt"

# Set correct permissions
sudo chmod 600 /var/lib/sops-nix/key.txt
```

### 3. Get your public age key

```bash
# Extract public key from the private key
sudo age-keygen -y /var/lib/sops-nix/key.txt
# Output: age1xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```

### 4. Update .sops.yaml with your public key

Edit `../.sops.yaml` and replace the placeholder `age1xxxxxx...` with your actual public key.

### 5. Create your secrets file

```bash
# Create initial secrets file
cat > secrets.yaml << 'EOF'
ssh:
  personal_id_ed25519: |
    -----BEGIN OPENSSH PRIVATE KEY-----
    your-private-key-here
    -----END OPENSSH PRIVATE KEY-----
  personal_id_ed25519_pub: ssh-ed25519 AAAA... your-public-key-here
  work_id_ed25519: |
    -----BEGIN OPENSSH PRIVATE KEY-----
    your-work-private-key-here
    -----END OPENSSH PRIVATE KEY-----
  work_id_ed25519_pub: ssh-ed25519 AAAA... your-work-public-key-here
EOF

# Encrypt the file
sops -e -i secrets.yaml

# Verify it's encrypted (should show gibberish)
cat secrets.yaml
```

## Managing Secrets

### Edit existing secrets

```bash
cd /Users/emmetdelaney/personal-code/nix-config/secrets
sops secrets.yaml
```

This will decrypt the file in your editor, let you make changes, and re-encrypt on save.

### Add new secrets

Just edit with sops and add them following the YAML structure:

```yaml
ssh:
  new_key_name: secret-value-here

other_secrets:
  api_key: your-api-key
  password: your-password
```

Then add the secret to `modules/system/secrets.nix` to make it available.

### Rotate keys

If you need to change the encryption key:

```bash
# Generate new key
sudo age-keygen -o /var/lib/sops-nix/key-new.txt

# Update .sops.yaml with the new public key

# Rotate the secrets file
sops updatekeys secrets.yaml
```

## Security Best Practices

1. **Never commit unencrypted secrets** - The `.gitignore` is set up to prevent this
2. **Always use `sops -e -i`** to encrypt files in place
3. **Keep `/var/lib/sops-nix/key.txt` secure** - This is your master decryption key
4. **Back up your age key** to a secure location (password manager, encrypted USB, etc.)
5. **Use different keys per host** if you have multiple machines

## Troubleshooting

### "failed to decrypt" error

- Ensure `/var/lib/sops-nix/key.txt` exists and has the correct key
- Verify `.sops.yaml` contains the correct public key
- Check file permissions: `sudo chmod 600 /var/lib/sops-nix/key.txt`

### Secrets not appearing after rebuild

- Verify the secret path in `modules/system/secrets.nix`
- Check that the secret exists in `secrets.yaml`
- Run: `sudo systemctl status sops-nix` to check for errors

### Want to see decrypted content

```bash
# Temporarily decrypt to stdout
sops -d secrets.yaml

# Or edit (will re-encrypt on save)
sops secrets.yaml
```



