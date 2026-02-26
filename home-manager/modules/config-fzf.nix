{
  programs.fzf = {
    enable = true;
    enableFishIntegration = false;
  };

  programs.fzf.defaultOptions = [
    "--height 40%"
    "--border"
    "--preview 'bat --style=numbers --color=always --line-range :500 {}'"
  ];

  programs.fzf.defaultCommand = ''
    fd --type f --strip-cwd-prefix --hidden --follow --exclude .git
  '';

  programs.fd.enable = true;
  programs.bat.enable = true;
}
