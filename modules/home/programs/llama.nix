{pkgs, ...}: let
  llama-cpp = pkgs.llama-cpp.overrideAttrs (finalAttrs: previousAttrs: {
    version = "11852";
    src = pkgs.fetchFromGitHub {
      owner = "ggml-org";
      repo = "llama.cpp";
      tag = "b${finalAttrs.version}";
      hash = "sha256-bQNg7kbzvGdXFGbkyZBO+iYgSiXCXoncGJqCeVUqPuk=";
    };
    patches = [ ];

    nativeBuildInputs = builtins.filter
      (drv: drv != pkgs.nodejs && drv != pkgs.npmHooks.npmConfigHook)
      previousAttrs.nativeBuildInputs;
    
    npmDeps = null;
    preConfigure = ''
      prependToVar cmakeFlags "-DLLAMA_BUILD_COMMIT:STRING=$(cat COMMIT)"
    '';
    cmakeFlags = (previousAttrs.cmakeFlags or [ ]) ++ [
      "-DLLAMA_BUILD_UI=OFF"
      "-DLLAMA_USE_PREBUILT_UI=OFF"
    ];
    # npmDepsHash = "sha256-2Q7XhaLAArmviOLdQsNbYTfdyDE5pW9lR26cRHEVl9k=";

    disabledTests = (previousAttrs.disabledTests or []) ++ [
      "test-llama-context-model"
    ];
  });
in {
  home.packages = [llama-cpp];
}
