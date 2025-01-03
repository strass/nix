{lib, config, options, pkgs, ...}:
{
  # Importing other Modules
  imports = [
    # ...
    ./configuration.nix
  ];

  modules = {
    ssh.enable = true;

    desktop = {
      niri.enable = true;
      waybar.enable = true;
    };

    software = {

    };
  }
 
}