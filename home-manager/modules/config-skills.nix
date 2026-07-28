{
  config,
  lib,
  ...
}: let
  cfg = config.agentSkills;
  hmRoot = "${config.home.homeDirectory}/.config/nixos/home-manager";
  skillsDir = ../skills;
  skillsRoot = "${hmRoot}/skills";

  entries = builtins.readDir skillsDir;
  groupNames =
    lib.filter
    (name: entries.${name} == "directory")
    (builtins.attrNames entries);

  stripMd = name: lib.removeSuffix ".md" name;

  skillEntries =
    lib.concatMap
    (group: let
      groupDir = skillsDir + "/${group}";
      groupRoot = "${skillsRoot}/${group}";
      groupEntries = builtins.readDir groupDir;

      markdownSkills =
        lib.filter
        (
          name:
            groupEntries.${name}
            == "regular"
            && lib.hasSuffix ".md" name
            && name != "README.md"
        )
        (builtins.attrNames groupEntries);

      directorySkills =
        lib.filter
        (name: groupEntries.${name} == "directory" && builtins.pathExists (groupDir + "/${name}/SKILL.md"))
        (builtins.attrNames groupEntries);
    in
      (map (fileName: {
          name = stripMd fileName;
          source = "${groupRoot}/${fileName}";
          target = "file";
        })
        markdownSkills)
      ++ (map (name: {
          inherit name;
          source = "${groupRoot}/${name}";
          target = "directory";
        })
        directorySkills))
    groupNames;

  skillNames = map (skill: skill.name) skillEntries;
  duplicateSkillNames =
    lib.filter
    (name: (lib.count (candidate: candidate == name) skillNames) > 1)
    (lib.unique skillNames);

  mkSkillLinks = targetDir:
    builtins.listToAttrs
    (map (skill:
      lib.nameValuePair
      (
        if skill.target == "directory"
        then "${targetDir}/${skill.name}"
        else "${targetDir}/${skill.name}/SKILL.md"
      )
      {
        source = config.lib.file.mkOutOfStoreSymlink skill.source;
      })
    skillEntries);
in {
  options.agentSkills = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to expose home-manager/skills to local coding agents.";
    };

    targetDirs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [
        ".claude/skills"
        ".agents/skills"
      ];
      description = ''
        Home-relative directories where managed skills are exposed.
        Claude Code reads ~/.claude/skills; Codex reads ~/.agents/skills.
      '';
    };

    extraPackages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [];
      description = "Runtime packages required by scripts bundled with managed skills.";
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = duplicateSkillNames == [];
        message = "Duplicate agent skill names: ${lib.concatStringsSep ", " duplicateSkillNames}";
      }
    ];

    home.file = lib.mkMerge (map mkSkillLinks cfg.targetDirs);

    home.packages = cfg.extraPackages;
  };
}
