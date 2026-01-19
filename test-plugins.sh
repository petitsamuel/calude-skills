#!/bin/bash

# Claude Code Plugin Validation Script
# Tests all plugins for structure, completeness, and consistency

set -e

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

ERRORS=0
WARNINGS=0

echo "🔍 Claude Code Plugin Validation"
echo "================================"
echo ""

# Test if a file exists
test_file_exists() {
    local file=$1
    local description=$2
    if [ -f "$file" ]; then
        echo -e "${GREEN}✓${NC} $description"
        return 0
    else
        echo -e "${RED}✗${NC} $description: $file not found"
        ((ERRORS++))
        return 1
    fi
}

# Test if a directory exists
test_dir_exists() {
    local dir=$1
    local description=$2
    if [ -d "$dir" ]; then
        echo -e "${GREEN}✓${NC} $description"
        return 0
    else
        echo -e "${RED}✗${NC} $description: $dir not found"
        ((ERRORS++))
        return 1
    fi
}

# Test JSON file is valid
test_json_valid() {
    local file=$1
    local description=$2
    if jq empty "$file" 2>/dev/null; then
        echo -e "${GREEN}✓${NC} $description"
        return 0
    else
        echo -e "${RED}✗${NC} $description: Invalid JSON"
        ((ERRORS++))
        return 1
    fi
}

# Test markdown file has frontmatter
test_has_frontmatter() {
    local file=$1
    local description=$2
    if head -1 "$file" | grep -q "^---"; then
        echo -e "${GREEN}✓${NC} $description"
        return 0
    else
        echo -e "${YELLOW}⚠${NC} $description: No frontmatter found"
        ((WARNINGS++))
        return 1
    fi
}

# Validate a plugin
validate_plugin() {
    local plugin_name=$1
    local plugin_dir=$2

    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "Testing: $plugin_name"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""

    # Test directory structure
    test_dir_exists "$plugin_dir" "Plugin directory"
    test_dir_exists "$plugin_dir/.claude-plugin" "Plugin config directory"
    test_dir_exists "$plugin_dir/agents" "Agents directory"
    test_dir_exists "$plugin_dir/commands" "Commands directory"
    test_dir_exists "$plugin_dir/skills" "Skills directory"
    test_dir_exists "$plugin_dir/hooks" "Hooks directory"

    # Test required files
    test_file_exists "$plugin_dir/.claude-plugin/plugin.json" "plugin.json exists"
    test_file_exists "$plugin_dir/README.md" "README.md exists"
    test_file_exists "$plugin_dir/hooks/hooks.json" "hooks.json exists"

    # Test JSON validity
    if [ -f "$plugin_dir/.claude-plugin/plugin.json" ]; then
        test_json_valid "$plugin_dir/.claude-plugin/plugin.json" "plugin.json is valid"
    fi

    if [ -f "$plugin_dir/hooks/hooks.json" ]; then
        test_json_valid "$plugin_dir/hooks/hooks.json" "hooks.json is valid"
    fi

    # Count and validate agents
    if [ -d "$plugin_dir/agents" ]; then
        local agent_count=$(find "$plugin_dir/agents" -name "*.md" | wc -l | tr -d ' ')
        echo -e "${GREEN}✓${NC} Found $agent_count agent(s)"

        # Check each agent has frontmatter
        for agent in "$plugin_dir/agents"/*.md; do
            if [ -f "$agent" ]; then
                test_has_frontmatter "$agent" "$(basename "$agent") has frontmatter"
            fi
        done
    fi

    # Count and validate commands
    if [ -d "$plugin_dir/commands" ]; then
        local command_count=$(find "$plugin_dir/commands" -name "*.md" | wc -l | tr -d ' ')
        echo -e "${GREEN}✓${NC} Found $command_count command(s)"
    fi

    # Count and validate skills
    if [ -d "$plugin_dir/skills" ]; then
        local skill_count=$(find "$plugin_dir/skills" -type d -depth 1 | wc -l | tr -d ' ')
        echo -e "${GREEN}✓${NC} Found $skill_count skill(s)"

        # Check each skill has SKILL.md
        for skill_dir in "$plugin_dir/skills"/*/; do
            if [ -d "$skill_dir" ]; then
                local skill_name=$(basename "$skill_dir")
                test_file_exists "$skill_dir/SKILL.md" "$skill_name has SKILL.md"
            fi
        done
    fi
}

# Validate all three plugins
validate_plugin "codebase-audit" "./codebase-audit"
validate_plugin "prompt-automation" "./prompt-automation"
validate_plugin "pr-learner" "./pr-learner"

# Summary
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Test Summary"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

if [ $ERRORS -eq 0 ] && [ $WARNINGS -eq 0 ]; then
    echo -e "${GREEN}✅ All tests passed!${NC}"
    exit 0
elif [ $ERRORS -eq 0 ]; then
    echo -e "${YELLOW}⚠ Tests passed with $WARNINGS warning(s)${NC}"
    exit 0
else
    echo -e "${RED}❌ Tests failed with $ERRORS error(s) and $WARNINGS warning(s)${NC}"
    exit 1
fi
