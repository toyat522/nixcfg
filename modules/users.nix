{ pkgs, ... }:

{
  users.users.toyat = {
    isNormalUser = true;
    description = "Toya Takahashi";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    shell = pkgs.zsh;
  };
}
