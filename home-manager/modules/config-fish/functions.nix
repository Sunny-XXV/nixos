{
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

    safe = {
      body = ''
        argparse 'm/mem=' 's/swap=' 'c/cpu=' 'n/name=' 'h/help' -- $argv
        or return

        if set -q _flag_help
          echo "Usage: safe [options] -- <command>"
          echo "Options:"
          echo "  -m, --mem <size>   MemoryMax limit (default: 4G)"
          echo "  -s, --swap <size>  MemorySwapMax limit (default: 0)"
          echo "  -c, --cpu <weight> CPUWeight (1-100, default: 50)"
          echo "  -n, --name <name>  Unit name description"
          return 0
        end

        set -l mem_max 24G
        if set -q _flag_mem; set mem_max $_flag_mem; end

        set -l swap_max 0
        if set -q _flag_swap; set swap_max $_flag_swap; end

        set -l cpu_weight 30
        if set -q _flag_cpu; set cpu_weight $_flag_cpu; end

        set -l unit_name_arg
        if set -q _flag_name; set unit_name_arg "--unit=$_flag_name"; end

        if test (count $argv) -eq 0
          echo "Error: No command specified."
          return 1
        end

        set_color cyan
        echo "Safe Run: Memory=$mem_max | Swap=$swap_max | CPU=$cpu_weight"
        set_color normal

        systemd-run --user --scope $unit_name_arg \
            -p MemoryMax=$mem_max \
            -p MemorySwapMax=$swap_max \
            -p CPUWeight=$cpu_weight \
            -- $argv
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
