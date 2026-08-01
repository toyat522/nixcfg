{ pkgs, ... }:

{
  users.users.toyat = {
    isNormalUser = true;
    description = "Toya Takahashi";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
  };
}
