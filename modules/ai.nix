{ pkgs, ... }:

{
  # Local LLM inference. The `llama-cpp` package installs its binary as
  # `llama` (mainProgram), so no alias is needed.
  home.packages = [ pkgs.llama-cpp ];
}