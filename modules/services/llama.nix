{
  hostPlatform,
  lib,
  pkgs,
  ...
}: let
  isDarwin = lib.hasSuffix "-darwin" hostPlatform;
  isLinux = lib.hasSuffix "-linux" hostPlatform;

  stateDir = "/var/lib/llama-cpp";
  modelName = "Qwen3-ASR-0.6B-Q8_0";
  modelDir = "${stateDir}/models/${modelName}";
  modelFile = "${modelDir}/${modelName}.gguf";
  mmprojFile = "${modelDir}/mmproj-${modelName}.gguf";

  settings = {
    host = "127.0.0.1";
    port = 9931;
    model = modelFile;
    mmproj = mmprojFile;
    n-gpu-layers = 99;
    ctx-size = 4096;
    parallel = 1;
    no-ui = true;
  };

  cliArgs =
    lib.cli.toCommandLine (optionName: {
      option =
        if lib.hasPrefix "-" optionName
        then optionName
        else if builtins.stringLength optionName > 1
        then "--${optionName}"
        else "-${optionName}";
      sep = null;
      explicitBool = false;
      formatArg = lib.generators.mkValueStringDefault {};
    })
    settings;
in
  {
    nixpkgs.overlays = [
      (_final: prev: {
        llama-cpp = prev.llama-cpp.overrideAttrs (finalAttrs: previousAttrs: {
          version = "11852";
          src = prev.fetchFromGitHub {
            owner = "ggml-org";
            repo = "llama.cpp";
            tag = "b${finalAttrs.version}";
            hash = "sha256-fFso/m/CHo08Y3Dy24urdczKQmfAVb5NqLVzJUhafPM=";
          };
          patches = [];

          nativeBuildInputs =
            builtins.filter
            (drv: drv != prev.nodejs && drv != prev.npmHooks.npmConfigHook)
            previousAttrs.nativeBuildInputs;

          npmDeps = null;
          preConfigure = ''
            prependToVar cmakeFlags "-DLLAMA_BUILD_COMMIT:STRING=$(cat COMMIT)"
          '';
          cmakeFlags =
            (previousAttrs.cmakeFlags or [])
            ++ [
              "-DLLAMA_BUILD_UI=OFF"
              "-DLLAMA_USE_PREBUILT_UI=OFF"
            ];

          disabledTests =
            (previousAttrs.disabledTests or [])
            ++ [
              "test-llama-context-model"
            ];
        });
      })
    ];

    environment.systemPackages = [pkgs.llama-cpp];
  }
  // lib.optionalAttrs isLinux {
    services.llama-cpp = {
      enable = true;
      inherit settings;
    };

    systemd.services.llama-cpp.unitConfig.ConditionPathExists = [
      modelFile
      mmprojFile
    ];
  }
  // lib.optionalAttrs isDarwin {
    launchd.daemons.llama-cpp = {
      script = ''
        test -r "${modelFile}" -a -r "${mmprojFile}" || exit 0
        exec ${lib.escapeShellArgs ([(lib.getExe' pkgs.llama-cpp "llama-server")] ++ cliArgs)}
      '';
      serviceConfig = {
        RunAtLoad = true;
        KeepAlive = true;
        ProcessType = "Interactive";
        ThrottleInterval = 10;
        WorkingDirectory = stateDir;
        StandardOutPath = "/Library/Logs/llama-cpp.log";
        StandardErrorPath = "/Library/Logs/llama-cpp.log";
      };
    };
  }
