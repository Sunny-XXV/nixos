{...}: {
  programs.fish.functions = {
    cat = {
      body = ''bat $argv'';
    };

    claude = {
      body = ''
        set --local item_name "claude"
        set --local field_name_1 "ANTHROPIC_AUTH_TOKEN"
        set --local field_name_2 "ANTHROPIC_BASE_URL"

        set --local key_1 (rbw get "$item_name" --field="$field_name_1")
        if test $status -ne 0
          echo "Error: Failed to retrieve "$field_name_1"" >&2
          return 1
        end

        set --local key_2 (rbw get "$item_name" --field="$field_name_2")
        if test $status -ne 0
          echo "Error: Failed to retrieve "$field_name_2"" >&2
          return 1
        end

        set -lx ANTHROPIC_AUTH_TOKEN $key_1
        set -lx ANTHROPIC_BASE_URL $key_2

        command claude $argv
      '';
    };

    tree = {
      body = ''eza -l -T $argv'';
    };

    ff = {
      body = ''fastfetch $argv'';
    };

    ls = {
      body = ''command ls -F --color=auto $argv'';
    };

    fkill = {
      body = ''
        set -l pids (ps -ef | sed 1d | fzf -m | awk '{print $2}')
        if test -n "$pids"
          set -l signal -9
          if test -n "$argv[1]"
            set signal $argv[1]
          end
          echo $pids | xargs kill $signal
        end
      '';
    };

    fo = {
      body = ''
        set -l file (fzf --preview "bat --style=numbers --color=always --line-range :500 {}")
          if test -n "$file"
            set -q EDITOR; or set -l EDITOR vi
            $EDITOR $FILE
          end
      '';
    };
  };
}
