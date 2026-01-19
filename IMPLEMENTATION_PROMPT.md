# Task: Implement Three Claude Code Plugins

## Context
We have a complete design specification in `THREE_PLUGINS_DESIGN.md` for three Claude Code plugins:
1. **codebase-audit** - Multi-dimensional codebase analysis
2. **prompt-automation** - Ralph Loop task automation
3. **pr-learner** - PR-based learning and improvement suggestions

All architectural decisions have been finalized. This task is pure implementation following the spec.

## Goals
Implement all three plugins with complete functionality:
- All directory structures created
- All plugin.json files configured
- All agent markdown files written
- All command markdown files written
- All skill directories with SKILL.md files
- All hooks configured
- All README files created

## Requirements

### Functional
1. **Directory Structure**: Create exact structures from THREE_PLUGINS_DESIGN.md for all 3 plugins
2. **Plugin Manifests**: Write plugin.json for each plugin with correct paths and metadata
3. **Commands**: Implement all command markdown files with frontmatter and instructions
4. **Agents**: Write all agent markdown files with proper frontmatter (description, capabilities)
5. **Skills**: Create all skill directories with SKILL.md and resources
6. **Hooks**: Configure hooks.json files and stop-loop.sh script
7. **Documentation**: README.md for each plugin

### Technical Standards
- Follow naming conventions: kebab-case files, `/audit-*`, `/ralph-task-*`, `/pr-learn-*` prefixes
- Agent frontmatter: description + capabilities (minimal)
- Skills: SKILL.md + templates/ + examples/ (hybrid approach)
- Hooks: Minimal (SessionStart + Stop for prompt-automation only)

### File Locations
```
codebase-audit/
  ├── .claude-plugin/plugin.json
  ├── commands/ (5 commands)
  ├── agents/ (9 agents)
  ├── skills/ (2 skills)
  ├── hooks/hooks.json
  └── README.md

prompt-automation/
  ├── .claude-plugin/plugin.json
  ├── commands/ (6 commands)
  ├── agents/ (4 agents)
  ├── skills/ (3 skills with templates)
  ├── hooks/hooks.json + stop-loop.sh
  └── README.md

pr-learner/
  ├── .claude-plugin/plugin.json
  ├── commands/ (1 command)
  ├── agents/ (7 agents)
  ├── skills/ (5 skills with templates/examples)
  ├── hooks/hooks.json
  └── README.md
```

## Implementation Phases

### Phase 1: Scaffolding (All Plugins)
1. Create all directory structures
2. Write all plugin.json files
3. Verify directory trees match design spec

**Verification:**
```bash
# Check all directories exist
find codebase-audit prompt-automation pr-learner -type d
# Verify plugin.json files
cat */.claude-plugin/plugin.json | jq .
```

### Phase 2: Codebase Audit Plugin
1. Write 5 command files (audit.md, audit-security.md, audit-quality.md, audit-report.md, audit-status.md)
2. Write 9 agent files with frontmatter
3. Create 2 skill directories with SKILL.md
4. Write hooks/hooks.json
5. Write README.md

**Verification:**
```bash
# Count files
find codebase-audit -name "*.md" | wc -l
# Validate frontmatter
grep -r "^---$" codebase-audit/agents/
```

### Phase 3: Prompt Automation Plugin
1. Write 6 command files
2. Write 4 agent files
3. Create 3 skill directories with 8 task templates
4. Write hooks/hooks.json and stop-loop.sh
5. Make stop-loop.sh executable
6. Write README.md

**Verification:**
```bash
find prompt-automation -name "*.md" | wc -l
test -x prompt-automation/hooks/stop-loop.sh && echo "Executable OK"
```

### Phase 4: PR Learner Plugin
1. Write pr-learn.md command
2. Write 7 agent files
3. Create 5 skill directories with templates and examples
4. Write hooks/hooks.json
5. Write README.md

**Verification:**
```bash
find pr-learner -name "*.md" | wc -l
find pr-learner/skills -type d | wc -l
```

### Phase 5: Content Quality Check
For each markdown file, ensure:
- Agent files have proper YAML frontmatter
- Commands have usage examples
- Skills have instructions + resources references
- READMEs have clear plugin descriptions

**Self-Test:**
```bash
# Check for empty files
find . -name "*.md" -empty
# Validate YAML frontmatter
for f in */agents/*.md; do head -5 "$f" | grep -q "^---$" || echo "Missing frontmatter: $f"; done
```

### Phase 6: Final Integration
1. Verify all file counts match design
2. Check all references to THREE_PLUGINS_DESIGN.md are accurate
3. Ensure consistency across all three plugins
4. Final README check

## Acceptance Criteria
- [ ] All 3 plugin directory structures created
- [ ] All 3 plugin.json files written and valid JSON
- [ ] Codebase Audit: 5 commands + 9 agents + 2 skills + hooks + README
- [ ] Prompt Automation: 6 commands + 4 agents + 3 skills with 8 templates + hooks + stop-loop.sh + README
- [ ] PR Learner: 1 command + 7 agents + 5 skills with templates/examples + hooks + README
- [ ] All agents have proper frontmatter (description + capabilities)
- [ ] All skills have SKILL.md files
- [ ] stop-loop.sh is executable
- [ ] All commands have usage examples
- [ ] No empty markdown files
- [ ] All file names use kebab-case
- [ ] Command prefixes correct: /audit-*, /ralph-task-*, /pr-learn-*

## Validation Commands
Run after each phase:
```bash
# File count check
echo "Codebase Audit files:"
find codebase-audit -type f | wc -l

echo "Prompt Automation files:"
find prompt-automation -type f | wc -l

echo "PR Learner files:"
find pr-learner -type f | wc -l

# Empty file check
find . -name "*.md" -empty

# Frontmatter check
for f in */agents/*.md */commands/*.md */skills/*/SKILL.md; do
  if [ -f "$f" ]; then
    head -1 "$f" | grep -q "^---$" || echo "Missing frontmatter: $f"
  fi
done

# JSON validity
for f in */.claude-plugin/plugin.json */hooks/hooks.json; do
  if [ -f "$f" ]; then
    jq empty "$f" 2>/dev/null || echo "Invalid JSON: $f"
  fi
done

# Executable check
test -x prompt-automation/hooks/stop-loop.sh || echo "stop-loop.sh not executable"
```

## Completion Conditions
When ALL of the following are true:
1. All acceptance criteria checked
2. All validation commands pass with no errors
3. File counts match design specification
4. No empty files exist
5. All frontmatter valid
6. All JSON files valid
7. stop-loop.sh is executable
8. THREE_PLUGINS_DESIGN.md fully implemented

Output: <promise>PLUGINS_IMPLEMENTED</promise>

## Self-Correction Loop
After each phase:
1. Run verification commands for that phase
2. If errors found, fix immediately before proceeding
3. If stuck on any file, reference THREE_PLUGINS_DESIGN.md for exact spec
4. If validation fails, iterate until passing
5. Only proceed to next phase when current phase fully validated

## Edge Cases & Error Handling
- **Missing directories**: Create them before writing files
- **Invalid YAML**: Check frontmatter syntax matches design spec
- **Empty files**: Ensure all content follows THREE_PLUGINS_DESIGN.md templates
- **Wrong naming**: Fix to kebab-case immediately
- **Missing executable bit**: chmod +x prompt-automation/hooks/stop-loop.sh

## Reference Document
ALL implementation details are in: THREE_PLUGINS_DESIGN.md
- Agent specifications: Section for each plugin
- Command structures: Listed under each plugin's Commands section
- Skill layouts: Detailed in Skills sections
- Frontmatter format: See "Cross-Plugin Conventions"
- Directory structures: Exact trees provided for each plugin

When in doubt, read the relevant section of THREE_PLUGINS_DESIGN.md.
