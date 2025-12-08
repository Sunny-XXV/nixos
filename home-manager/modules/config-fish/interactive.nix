{...}: {
  programs.fish = {
    interactiveShellInit = ''
      fish_vi_key_bindings
      set fish_greeting

      fzf_configure_bindings --directory=\cf --history=\cr --git_status=\e\cs --git_log=\e\cl
      set -g fzf_preview_dir_cmd eza --all --color=always
      set -g fzf_fd_opts --hidden --follow --exclude .git --max-depth 5
    '';
  };
}
