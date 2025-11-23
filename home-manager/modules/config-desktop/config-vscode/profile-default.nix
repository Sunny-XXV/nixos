{
  pkgs,
  inputs,
  ...
}: let
  pkgsExt = pkgs.extend inputs.vscode-extensions.overlays.default;
in {
  programs.vscode.profiles.default.extensions = with pkgsExt.vscode-marketplace; [
    drcika.apc-extension
    fisheva.eva-theme
    jnoortheen.nix-ide
    github.copilot
    github.copilot-chat
    gruntfuggly.todo-tree
    pkief.material-icon-theme
    vscodevim.vim
  ];

  programs.vscode.profiles.default.userSettings = {
    # === Appearance ===
    "window.autoDetectColorScheme" = true;
    "window.commandCenter" = false;
    "window.title" = "\${activeEditorShort}\${separator}\${rootName}";
    "window.titleSeparator" = " / ";
    "material-icon-theme.saturation" = 0.8;
    "material-icon-theme.activeIconPack" = "react";
    "material-icon-theme.folders.theme" = "classic";
    "material-icon-theme.rootFolders.color" = "#26a69a";
    "material-icon-theme.hidesExplorerArrows" = true;
    "material-icon-theme.files.color" = "#42a5f5";
    "workbench.editorLargeFileConfirmation" = 50;
    "workbench.iconTheme" = "material-icon-theme";
    "workbench.colorTheme" = "Eva Light Bold";
    "workbench.preferredLightColorTheme" = "Eva Light Italic Bold";
    "workbench.preferredDarkColorTheme" = "Eva Dark Italic Bold";
    "workbench.startupEditor" = "none";
    "workbench.activityBar.location" = "bottom";
    "workbench.fontAliasing" = "auto";
    "workbench.tree.indent" = 12;
    "workbench.tree.renderIndentGuides" = "always";
    "workbench.list.smoothScrolling" = true;
    "workbench.list.horizontalScrolling" = true;
    "workbench.layoutControl.enabled" = false;
    "workbench.settings.applyToAllProfiles" = [
      "autoDocstring.docstringFormat"
      "chat.modeFilesLocations"
      "editor.fontSize"
      "editor.fontFamily"
      "editor.cursorStyle"
      "editor.renderWhitespace"
      "files.autoSave"
      "files.exclude"
      "editor.formatOnSave"
      "evenBetterToml.formatter.allowedBlankLines"
      "explorer.incrementalNaming"
      "notebook.lineNumbers"
      "python.analysis.typeCheckingMode"
      "todo-tree.highlights.enabled"
      "sql-formatter.uppercase"
      "terminal.integrated.copyOnSelection"
      "terminal.integrated.macOptionIsMeta"
      "terminal.integrated.shellIntegration.enabled"
      "terminal.integrated.shellIntegration.decorationsEnabled"
      "terminal.integrated.shellIntegration.showCommandGuide"
      "vim.easymotion"
      "vim.smartRelativeLine"
      "window.title"
      "workbench.editorLargeFileConfirmation"
      "workbench.fontAliasing"
    ];
    "zenMode.centerLayout" = false;
    "zenMode.hideLineNumbers" = false;
    "explorer.confirmDelete" = false;
    "explorer.confirmDragAndDrop" = false;
    "explorer.incrementalNaming" = "smart";
    "files.exclude" = {
      ".ruff_cache" = true;
      ".stfolder*" = true;
      "**/__pycache__" = true;
    };
    "apc.activityBar" = {};
    "apc.electron" = {
      "backgroundColor" = "#1a1a1a";
      "frame" = false;
      "transparent" = true;
      "titleBarStyle" = "hiddenInset";
      "vibrancy" = "ultra-dark";
      "trafficLightPosition" = {
        "x" = 15;
        "y" = 13;
      };
      "trafficLightPositionRight" = {
        "x" = 15;
        "y" = 13;
      };
    };
    "apc.header" = {
      "compact" = 22;
      "fontSize" = 12;
      "fontWeight" = "bold";
    };
    "apc.menubar.compact" = true;
    "apc.parts.font.family" = {
      "sidebar" = "'JetBrainsMono Nerd Font Mono'";
    };
    "apc.sidebar.titlebar" = {
      "fontSize" = 11;
      "fontWeight" = "bold";
    };
    "apc.stylesheet" = {
      ".tabs-container .tab.active" = {
        "border-radius" = "7px !important";
      };
      ".scrollbar" = {
        "background" = "#21222f !important";
      };
    };
    # === Terminal ===
    "terminal.integrated.copyOnSelection" = true;
    "terminal.integrated.defaultProfile.osx" = "zsh";
    "terminal.integrated.defaultProfile.linux" = "bash";
    "terminal.integrated.enableImages" = true;
    "terminal.integrated.fontFamily" = "'JetBrainsMono Nerd Font Mono'";
    "terminal.integrated.fontSize" = 13;
    "terminal.integrated.persistentSessionScrollback" = 500;
    "terminal.integrated.shellIntegration.decorationsEnabled" = "never";
    "terminal.integrated.shellIntegration.enabled" = false;
    "terminal.integrated.shellIntegration.showCommandGuide" = false;
    # === Editor ===
    "editor.accessibilitySupport" = "off";
    "editor.codeActionsOnSave" = {
      "source.fixAll" = "explicit";
      "source.organizeImports.ruff" = "always";
    };
    "editor.cursorBlinking" = "smooth";
    "editor.cursorSmoothCaretAnimation" = "on";
    "editor.formatOnSave" = true;
    "editor.formatOnType" = true;
    "editor.fontFamily" = "'JetBrainsMono Nerd Font Mono', Monaco, 'Courier New', monospaceMenlo";
    "editor.fontSize" = 13;
    "editor.fontLigatures" = true;
    "editor.guides.highlightActiveIndentation" = false;
    "editor.lineNumbers" = "relative";
    "editor.scrollbar.vertical" = "visible";
    "editor.scrollbar.horizontal" = "visible";
    "editor.scrollbar.verticalScrollbarSize" = 6;
    "editor.scrollbar.horizontalScrollbarSize" = 6;
    "editor.wordWrap" = "on";
    "editor.wrapOnEscapedLineFeeds" = true;
    "explorer.confirmPasteNative" = false;
    "files.autoSave" = "onFocusChange";
    "files.readonlyInclude" = {
      "**/*.log" = true;
    };
    "vim.easymotion" = true;
    "vim.leader" = "<space>";
    "vim.normalModeKeyBindingsNonRecursive" = [
      {
        "before" = ["s"];
        "after" = ["<leader>" "<leader>" "2" "s"];
      }
    ];
    "vim.enableNeovim" = true;
    "vim.smartRelativeLine" = true;
    "vim.useSystemClipboard" = true;
    # === Nix ===
    "nix.enableLanguageServer" = true;
    "nix.serverPath" = "nil";
    "nix.serverSettings" = {
      "nil" = {
        "diagnostics" = {
          "ignored" = [
            "unused_binding"
            "unused_with"
          ];
        };
        "formatting" = {
          "command" = [
            "alejandra"
          ];
        };
      };
    };
    "[nix]" = {
      "editor.formatOnSave" = true;
      "files.autoSave" = "onFocusChange";
      "editor.defaultFormatter" = "jnoortheen.nix-ide";
    };
    # === Python ===
    "python.analysis.autoFormatStrings" = true;
    "python.analysis.completeFunctionParens" = true;
    "python.analysis.inlayHints.callArgumentNames" = "partial";
    "python.analysis.inlayHints.functionReturnTypes" = true;
    "python.analysis.typeCheckingMode" = "standard";
    "python.defaultInterpreterPath" = "python";
    "python.terminal.activateEnvironment" = false;
    "jupyter.notebookFileRoot" = "\${workspaceFolder}";
    "notebook.output.scrolling" = true;
    "notebook.lineNumbers" = "on";
    "[python]" = {
      "diffEditor.ignoreTrimWhitespace" = false;
      "editor.formatOnType" = true;
      "editor.wordBasedSuggestions" = "off";
    };
    "ruff.path" = ["ruff"];
    "ruff.trace.server" = "messages";
    "ruff.interpreter" = ["python"];
    # === Copilot ===
    "inlineChat.accessibleDiffView" = "on";
    "chat.agent.maxRequests" = 100;
    "chat.mcp.gallery.enabled" = true;
    "chat.tools.terminal.autoApprove" = {
      "mkdir" = true;
    };
    "github.copilot.advanced" = {};
    "github.copilot.chat.agent.thinkingTool" = true;
    "github.copilot.chat.codesearch.enabled" = true;
    "github.copilot.chat.customOAIModels" = {};
    "github.copilot.chat.edits.temporalContext.enabled" = true;
    "github.copilot.chat.editor.temporalContext.enabled" = true;
    "github.copilot.chat.generateTests.codeLens" = true;
    "github.copilot.chat.responsesApiReasoningEffort" = "high";
    "github.copilot.chat.scopeSelection" = true;
    "github.copilot.nextEditSuggestions.enabled" = false;
    "github.copilot.selectedCompletionModel" = "gpt-4o-copilot";
    "github.copilot.enable" = {
      "*" = false;
      "plaintext" = false;
      "markdown" = false;
      "scminput" = false;
      "env" = false;
      "python" = true;
      "typescriptreact" = true;
      "typescript" = true;
      "jinja-sql" = true;
    };
    # === Writing ===
    "latex-workshop.formatting.latex" = "latexindent";
    "latex-workshop.latex.autoBuild.run" = "onSave";
    "latex-workshop.latex.recipe.default" = "lastUsed";
    "tinymist.formatterMode" = "typstfmt";
    "tinymist.exportPdf" = "onSave";
    # === File Type Specific ===
    "[log]" = {
      "editor.wordWrap" = "off";
    };
    "[csv]" = {
      "editor.inlayHints.maximumLength" = 0;
    };
    # === Others ===
    "security.promptForRemoteFileProtocolHandling" = false;
    "security.workspace.trust.untrustedFiles" = "open";
    "evenBetterToml.formatter.allowedBlankLines" = 2;
    "rainbow_csv.virtual_alignment_mode" = "always";
    "dataWrangler.grid.defaultColumnWidth" = 160;
    "dataWrangler.panels.displayOnTabFocus" = false;
    "dataWrangler.defaultViewingFilterOptions" = "advanced";
    "dataWrangler.outputRenderer.enabledTypes" = {
      "numpy.ndarray" = true;
      "torch.Tensor" = true;
      "polars.series.series.Series" = true;
    };
    "dataWrangler.experiments.fastCsvParsing" = true;
    "remote.SSH.useLocalServer" = false;
    "git.autofetch" = true;
    "git.autofetchPeriod" = 600;
    "debug.inlineValues" = "off";
  };

  programs.vscode.profiles.default.keybindings = [
    {
      key = "ctrl+h";
      command = "workbench.action.navigateLeft";
      when = "vim.mode != 'Insert'";
    }
    {
      key = "ctrl+j";
      command = "workbench.action.navigateDown";
      when = "vim.mode != 'Insert'";
    }
    {
      key = "ctrl+k";
      command = "workbench.action.navigateUp";
      when = "vim.mode != 'Insert'";
    }
    {
      key = "ctrl+l";
      command = "workbench.action.navigateRight";
      when = "vim.mode != 'Insert'";
    }

    {
      key = "r";
      command = "renameFile";
      when = "filesExplorerFocus && foldersViewVisible && !explorerResourceIsRoot && !explorerResourceReadonly && !inputFocus";
    }
    {
      key = "a";
      command = "explorer.newFile";
      when = "filesExplorerFocus && foldersViewVisible && !explorerResourceIsRoot && !explorerResourceReadonly && !inputFocus";
    }
    {
      key = "d";
      command = "deleteFile";
      when = "filesExplorerFocus && foldersViewVisible && !explorerResourceIsRoot && !explorerResourceReadonly && !inputFocus";
    }
    {
      key = "y";
      command = "filesExplorer.copy";
      when = "filesExplorerFocus && foldersViewVisible && !explorerResourceIsRoot && !explorerResourceReadonly && !inputFocus";
    }
    {
      key = "p";
      command = "filesExplorer.paste";
      when = "filesExplorerFocus && foldersViewVisible && !explorerResourceIsRoot && !explorerResourceReadonly && !inputFocus";
    }
    {
      key = "x";
      command = "filesExplorer.cut";
      when = "filesExplorerFocus && foldersViewVisible && !explorerResourceIsRoot && !explorerResourceReadonly && !inputFocus";
    }
  ];
}
