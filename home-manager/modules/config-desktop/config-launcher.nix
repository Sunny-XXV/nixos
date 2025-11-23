{pkgs, ...}: let
  launcher = pkgs.writeShellApplication {
    name = "launcher";
    runtimeInputs = with pkgs; [
      fd
      ripgrep
      fzf
      cliphist
      wl-clipboard
      gawk
      gnused
      coreutils
    ];

    text = ''
      # ================= Config =================
      IFS=':' read -ra DIRS <<< "''${XDG_DATA_DIRS:-}"
      SEARCH_PATHS=()

      for dir in "''${DIRS[@]}"; do
        [[ -d "$dir/applications" ]] && SEARCH_PATHS+=("$dir/applications")
      done
      [[ -d "$HOME/.local/share/applications" ]] && SEARCH_PATHS+=("$HOME/.local/share/applications")


      # ================= Func =================
      gen_apps() {
        if [ ''${#SEARCH_PATHS[@]} -eq 0 ]; then return; fi

        # shellcheck disable=SC2016
        fd --type f --follow --extension desktop . "''${SEARCH_PATHS[@]}" --exec sh -c '
          name=$(rg --no-filename -m1 "^Name=" "$1" | cut -d= -f2-)
          exec=$(rg --no-filename -m1 "^Exec=" "$1" | cut -d= -f2-)

          if [[ -n "$name" && -n "$exec" ]] && ! rg -q "NoDisplay=true" "$1"; then
            printf "󰣆 %s\tapp\t%s\n" "$name" "$exec"
          fi
        ' sh {}
      }

      gen_clip() {
        if command -v cliphist >/dev/null; then
          cliphist list | head -n 100 | \
          awk -F'\t' '{ gsub(/\n/, " ", $2); print " " substr($2,1,50) "\tclip\t" $1 }'
        fi
      }


      # ================= Main Logic =================
      selected=$( (gen_clip; gen_apps) | \
        fzf --delimiter='\t' --with-nth=1 --header="Run or Paste >" --no-sort )

      if [[ -z "$selected" ]]; then exit 0; fi

      type=$(echo "$selected" | awk -F'\t' '{print $2}')
      data=$(echo "$selected" | awk -F'\t' '{print $3}')

      case "$type" in
        app)
          cmd=$(echo "$data" | sed -E 's/ %[a-zA-Z]//g' | sed -e 's/^"//' -e 's/"$//')
          # shellcheck disable=SC2086
          setsid nohup $cmd >/dev/null 2>&1 &
          ;;
        clip)
          echo "$data" | cliphist decode | wl-copy
          ;;
      esac
    '';
  };
in {
  home.packages = [launcher];
}
