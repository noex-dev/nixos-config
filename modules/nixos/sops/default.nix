{ inputs, ... }:

{
  imports = [ inputs.sops-nix.nixosModules.sops ];

  sops = {
    defaultSopsFile = ../../../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";

    age.sshKeyPaths = [ "/persist/etc/ssh/ssh_host_ed25519_key" ];

    secrets.git_ssh_key = {
      owner = "noel";
    };

    secrets.noel_password = {
      neededForUsers = true;
    };
  };
}
