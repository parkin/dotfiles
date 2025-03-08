{
  lib,
  ...
}:
{
  imports = [
    ./bundles
    ./features
  ];
  options = {

    myHomeManager.dotfilesPath = lib.mkOption {
      description = "Full absolute path to dotfiles directory. Eg /home/parkin/.dotfiles";
      type = lib.types.path;
    };
  };

}
