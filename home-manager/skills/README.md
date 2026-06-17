# Agent skills

Group skills by source or suite:

```text
<group>/
├── README.md
├── LICENSE
├── <skill-name>.md
└── <another-skill>.md
```

Each `<group>/<skill-name>.md` file is treated as one managed skill and is
projected to `<skill-name>/SKILL.md` in each target directory. For skills that
need supporting files, `<group>/<skill-name>/SKILL.md` is also supported and is
projected as a whole skill directory.

The `agent-skills` Home Manager module symlinks each concrete skill into the
locations used by local coding agents:

- Claude Code: `~/.claude/skills/<name>`
- Codex: `~/.agents/skills/<name>`

Use `agentSkills.extraPackages` for runtime tools required by skill scripts.
Plain markdown-only skills usually need no extra packages.
Use `agentSkills.targetDirs` to expose the same skill source to additional
agents.
