{ pkgs, ... }:

{
  # Node.js runtime, used to run @deepseek-ai/dsh (DeepSeek Harness).
  #
  # dsh is not packaged in nixpkgs, so it is installed imperatively into a
  # writable prefix (npm cannot write to /nix/store):
  #
  #   npm config set prefix ~/.local
  #   npm install -g @deepseek-ai/dsh
  #
  # The binary lands in ~/.local/bin, which config/zsh/.zshenv adds to PATH.
  # Alternatively run it without installing: npx @deepseek-ai/dsh@latest
  #
  # Keep a generation containing node in place: the installed binary's shebang
  # points at the nix-store node, so a full GC of it would break the command.
  home.packages = [ pkgs.nodejs_22 ];
}