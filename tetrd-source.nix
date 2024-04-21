{config, pkgs, ...}:
{
  environment.systemPackages = {
    (tetrd.overrideAttrs (previousAttrs: {
      src = fetchurl {
        url = "https://download.tetrd.app/files/tetrd.linux_amd64.pkg.tar.xz";
        sha256 = "2sn9IJzusPjOhYuWg+53hlN2EP1kdCYsu+DbcsZjc0w=";
      };
    }))
  }
}
