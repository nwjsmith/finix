{
  xdg.enable = true;

  programs.git = {
    enable = true;
    userName = "Nate Smith";
    userEmail = "nate@theinternate.com";
  };

  programs.neovim = {
    enable = true;
    vimAlias = true;
  };

  programs.gh = {
    enable = true;
    enableGitCredentialHelper = true;
  };

  home.stateVersion = "22.11";
}
