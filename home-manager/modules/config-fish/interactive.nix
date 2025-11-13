{...}: {
  programs.fish = {
    interactiveShellInit = ''
      fish_vi_key_bindings
      set fish_greeting
      zoxide init fish | source
      fzf_configure_bindings --directory=\cf
    '';
  };
}
