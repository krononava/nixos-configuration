{ pkgs, ... }:

{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.lenix = {
    isNormalUser = true;
    description = "lenix";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      firefox
      vscode
      obsidian
      git
      nixos-generators
      pdfarranger
    ];
  };
}