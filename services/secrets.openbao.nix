{pkgs, ...}: {
  environment.systemPackages = [
    pkgs.openbao
  ];
}
