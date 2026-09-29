{ config, pkgs, ... }:

let
  # Catppuccin Mocha, matching the colour scheme already used by the
  # external wezterm config (config/wezterm/wezterm.lua).
  #
  # The upstream nixpkgs packages do NOT ship these themes, so we pull them
  # from pkgs.catppuccin, which aggregates upstream theme repos:
  #   - bat 0.26.1 upstream keeps its themes in a git submodule that
  #     nixpkgs does not fetch, so `bat --list-themes` has no Catppuccin.
  #   - btop 1.4.7 ships 42 themes, none of them Catppuccin.
  catppuccin = variant: themeList: pkgs.catppuccin.override { inherit variant themeList; };
in
{
  # Tools the external zsh dotfiles call directly. `config/zsh/*.zsh` shells
  # out to these, so they must be present for the repo config to work:
  #   aliases.zsh -> eza, bat, ripgrep, lf
  #   fzf.zsh     -> fzf, fd, bat
  #   prompt.zsh  -> starship
  #   .zshrc      -> zoxide
  home.packages = with pkgs; [
    fzf
    eza
    fd
    ripgrep
    zoxide
    starship
    lf
  ];

  # NOTE: shell integration for all of the above is owned by the external
  # dotfiles in config/zsh/, which are symlinked into place by
  # modules/zsh.nix. Enabling home-manager's own programs.fzf /
  # programs.zoxide / programs.starship would inject a second, competing
  # set of init lines and session variables into the same shell.

  # `bat` config, plus the theme nixpkgs omits.
  programs.bat = {
    enable = true;
    config = {
      theme = "Catppuccin Mocha"; # matched against the .tmTheme's internal name
      style = "plain,numbers";
      pager = "less -FR";
    };
    themes.catppuccin-mocha = {
      src = catppuccin "mocha" [ "bat" ];
      file = "bat/Catppuccin Mocha.tmTheme";
    };
  };

  # `btop` config. The theme is installed via xdg.configFile rather than
  # programs.btop.themes: that option tests `builtins.isPath` / `isStorePath`,
  # and a store *subpath* is neither, so it would write the literal path text
  # into the theme file instead of the theme itself.
  programs.btop = {
    enable = true;
    settings = {
      color_theme = "catppuccin_mocha"; # btop keys themes by filename
      theme_background = false; # keep the terminal's transparency
    };
  };

  xdg.configFile."btop/themes/catppuccin_mocha.theme".source =
    "${catppuccin "mocha" [ "btop" ]}/btop/catppuccin_mocha.theme";
}