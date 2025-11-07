{ config, pkgs, ... }:

{
  # Configure sops
  sops = {
    # Default sops file location
    defaultSopsFile = ../../secrets/secrets.yaml;

    # Age key file for decryption (will be at /var/lib/sops-nix/key.txt)
    age.keyFile = "/var/lib/sops-nix/key.txt";

    # SSH keys - these will be decrypted and placed in the specified paths
    secrets = {
      # Personal SSH key
      "ssh/personal_id_ed25519" = {
        owner = "emmetdelaney";
        path = "/home/emmetdelaney/.ssh/id_ed25519";
        mode = "0600";
      };

      # Work SSH key
      "ssh/work_id_ed25519" = {
        owner = "emmetdelaney";
        path = "/home/emmetdelaney/.ssh/work_id_ed25519";
        mode = "0600";
      };

      # Public keys can be stored too (for convenience)
      "ssh/personal_id_ed25519_pub" = {
        owner = "emmetdelaney";
        path = "/home/emmetdelaney/.ssh/id_ed25519.pub";
        mode = "0644";
      };

      "ssh/work_id_ed25519_pub" = {
        owner = "emmetdelaney";
        path = "/home/emmetdelaney/.ssh/work_id_ed25519.pub";
        mode = "0644";
      };
    };
  };

  # Ensure .ssh directory exists with correct permissions
  systemd.tmpfiles.rules = [
    "d /home/emmetdelaney/.ssh 0700 emmetdelaney users -"
  ];
}



