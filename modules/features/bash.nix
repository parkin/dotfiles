{
  lib,
  config,
  ...
}:
{
  options = {
    myHomeManager.bash.enable = lib.mkEnableOption "Enables bash";
  };

  config = lib.mkIf config.myHomeManager.bash.enable {
    programs.bash = {
      enable = true;
      shellAliases = {
        ".." = "cd ..";
        "..." = "cd ../..";
        "...." = "cd ../../..";
        "....." = "cd ../../../..";
        "~" = "cd ~";
        cddot = "cd ${config.myHomeManager.dotfilesPath}";
        # Reload the shell (i.e. invoke as a login shell)
        reload = "exec $SHELL -l";
        # Print each PATH entry on a separate line
        path = "echo -e \${PATH//:/\\n}";
        # Git stuff
        ga = "git add";
        gc = "git commit";
        gcm = "git commit -m";
        gs = "git status";
        gd = "git diff";
        gf = "git fetch";
        gm = "git merge";
        gr = "git rebase";
        gP = "git push";
        gp = "git pull";
        gu = "git unstage";
        gco = "git checkout";
        gb = "git branch";
      };
      # Enable vi mode
      initExtra = ''
        set -o vi
      '';
    };

  };

}
