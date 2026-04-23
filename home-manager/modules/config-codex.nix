{
  programs.codex.enable = true;
  programs.codex.settings = {
    sandbox-mode = "workspace-write";
    background_terminal_max_timeout = 7200;
    personality = "pragmatic";
    network_access = true;
    approval_policy = "on-request";

    agents = {
      max_threads = 12;
      job_max_runtime_seconds = 7200;

      default = {
        description = "General-purpose coder.";
        model = "gpt-5.4-codex";
        model_reasoning_effort = "xhigh";
      };
      worker = {
        description = "Execution-focused role for implementation and fixes.";
        model = "gpt-5.4-codex";
        model_reasoning_effort = "xhigh";
      };
      explorer = {
        description = "Fast codebase explorer for read-heavy tasks.";
        model = "gpt-5.4-codex";
        model_reasoning_effort = "high";
        sandbox_mode = "read-only";
      };
      monitor = {
        description = "Long-running command and task monitoring role.";
        model = "gpt-5.4-codex";
        model_reasoning_effort = "high";
        sandbox_mode = "read-only";
      };
    };

    features = {
      plan_tool = true;
      view_image_tool = true;
      skills = true;
      parallel = true;
      unified_exec = true;
      multi_agent = true;
      steer = true;
    };
  };
}
