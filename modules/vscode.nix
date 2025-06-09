{
  services.vscode-server = {
    enable = true;
    enableFHS = true;
  };

  # programs.vscode = {
  #   enable = true;
  #   mutableExtensionsDir = true;

  #   profiles.default = {
  #     enableUpdateCheck = false;
  #     enableExtensionUpdateCheck = false;

  #     extensions = with pkgs.vscode-marketplace; [
  #       mkhl.direnv
  #       jnoortheen.nix-ide
  #       #...
  #     ];

  #     userSettings = {
  #       # ...
  #     };
  #   };
  # };
}
