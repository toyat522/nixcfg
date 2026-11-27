{ pkgs, ... }:

{
  users.users.toyat = {
    isNormalUser = true;
    description = "Toya Takahashi";
    extraGroups = [ "networkmanager" "wheel" "docker" "dialout" ];
    shell = pkgs.zsh;
  };
}
