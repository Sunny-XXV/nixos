{
  services.llama-cpp.enable = true;
  services.llama-cpp = {
    host = "100.100.140.8";
    port = 6868;
    openFirewall = true;
  };
  services.llama-cpp = {
    model = "/var/lib/models/Qwen3.5-35B-A3B-GGUF/Qwen3.5-35B-A3B-Q4_K_M.gguf";
    extraFlags = ["--fit" "on" "-c" "65536" "-fa" "on" "-t" "11" "--no-mmap" "--jinja" "-ctk" "q8_0" "-ctv" "q8_0"];
  };
}
