{ pkgs, ... }:

{
   programs.git = {
      enable = true;
      settings.user.name = "0x6867";
      settings.user.email = "1156977+0x6867@users.noreply.github.com";
   };


   programs.gh =  {
     enable = true;
     gitCredentialHelper = {
       enable = true;
    };
   };
}
