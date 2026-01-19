#!/bin/bash

# Claude Code Plugin Validation Script
# Tests all plugins for structure, completeness, and consistency
#
# Requirements:
#   - jq (for JSON validation)
#   - Install: brew install jq (macOS) or apt install jq (Linux)

# Note: Not using set -e because test functions intentionally return non-zero
# on failures. We track errors via ERRORS counter instead.

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

ERRORS=0
WARNINGS=0

# Get script directory for absolute paths
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Check required dependencies
echo "🔍 Claude Code Plugin Validation"
echo "================================"
echo ""

REQUIRED_COMMANDS=("jq" "find" "grep" "head" "wc" "tr" "basename")
MISSING_COMMANDS=()

for cmd in "${REQUIRED_COMMANDS[@]}"; do
    if ! command -v "$cmd" &>/dev/null; then
        MISSING_COMMANDS+=("$cmd")
    fi
done

if [ ${#MISSING_COMMANDS[@]} -gt 0 ]; then
    echo -e "${RED}Error: Missing required commands: ${MISSING_COMMANDS[*]}${NC}"
    echo ""
    echo "Installation instructions:"
    echo "  macOS: brew install ${MISSING_COMMANDS[*]}"
    echo "  Ubuntu/Debian: sudo apt-get install ${MISSING_COMMANDS[*]}"
    echo "  Other: Please install these commands using your system's package manager"
    exit 1
fi

# Test if a file exists and is readable
test_file_exists() {
    local file=$1
    local description=$2

    if [ ! -e "$file" ]; then
        echo -e "${RED}✗${NC} $description: $file not found"
        ERRORS=$((ERRORS + 1))
        return 1
    elif [ -d "$file" ]; then
        echo -e "${RED}✗${NC} $description: $file is a directory (expected a file)"
        ERRORS=$((ERRORS + 1))
        return 1
    elif [ ! -f "$file" ]; then
        echo -e "${RED}✗${NC} $description: $file exists but is not a regular file (broken symlink?)"
        ERRORS=$((ERRORS + 1))
        return 1
    elif [ ! -r "$file" ]; then
        echo -e "${RED}✗${NC} $description: $file exists but is not readable"
        echo "  Try: chmod +r \"$file\""
        ERRORS=$((ERRORS + 1))
        return 1
    else
        echo -e "${GREEN}✓${NC} $description"
        return 0
    fi
}

# Test if a directory exists and is accessible
test_dir_exists() {
    local dir=$1
    local description=$2

    if [ ! -e "$dir" ]; then
        echo -e "${RED}✗${NC} $description: $dir not found"
        ERRORS=$((ERRORS + 1))
        return 1
    elif [ -f "$dir" ]; then
        echo -e "${RED}✗${NC} $description: $dir is a file (expected a directory)"
        ERRORS=$((ERRORS + 1))
        return 1
    elif [ ! -d "$dir" ]; then
        echo -e "${RED}✗${NC} $description: $dir exists but is not a directory"
        ERRORS=$((ERRORS + 1))
        return 1
    elif [ ! -r "$dir" ] || [ ! -x "$dir" ]; then
        echo -e "${RED}✗${NC} $description: $dir exists but is not readable/accessible"
        echo "  Try: chmod +rx \"$dir\""
        ERRORS=$((ERRORS + 1))
        return 1
    else
        echo -e "${GREEN}✓${NC} $description"
        return 0
    fi
}

# Test JSON file is valid
test_json_valid() {
    local file=$1
    local description=$2
    local jq_output

    # Capture jq output to show users what's wrong
    if jq_output=$(jq empty "$file" 2>&1); then
        echo -e "${GREEN}✓${NC} $description"
        return 0
    else
        echo -e "${RED}✗${NC} $description: Invalid JSON in $file"
        echo "  jq error: $jq_output"
        ERRORS=$((ERRORS + 1))
        return 1
    fi
}

# Test markdown file has frontmatter
test_has_frontmatter() {
    local file=$1
    local description=$2

    # Check file is readable
    if [ ! -r "$file" ]; then
        echo -e "${RED}✗${NC} $description: Cannot read $file"
        ERRORS=$((ERRORS + 1))
        return 1
    fi

    # Check file is not empty
    if [ ! -s "$file" ]; then
        echo -e "${RED}✗${NC} $description: File is empty"
        ERRORS=$((ERRORS + 1))
        return 1
    fi

    # Check for frontmatter
    local first_line
    if ! first_line=$(head -n 1 "$file" 2>&1); then
        echo -e "${RED}✗${NC} $description: Failed to read file - $first_line"
        ERRORS=$((ERRORS + 1))
        return 1
    fi

    if echo "$first_line" | grep -q "^---"; then
        echo -e "${GREEN}✓${NC} $description"
        return 0
    else
        echo -e "${YELLOW}⚠${NC} $description: No frontmatter found (file should start with '---')"
        WARNINGS=$((WARNINGS + 1))
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
        local agent_files=("$plugin_dir/agents"/*.md)

        # Check if glob matched anything
        if [ ! -e "${agent_files[0]}" ]; then
            echo -e "${YELLOW}⚠${NC} No agent files found in $plugin_dir/agents"
            WARNINGS=$((WARNINGS + 1))
        else
            local agent_count=${#agent_files[@]}
            echo -e "${GREEN}✓${NC} Found $agent_count agent(s)"

            # Check each agent has frontmatter
            for agent in "${agent_files[@]}"; do
                if [ -f "$agent" ]; then
                    test_has_frontmatter "$agent" "$(basename "$agent") has frontmatter"
                else
                    echo -e "${RED}✗${NC} Agent file disappeared during validation: $agent"
                    ERRORS=$((ERRORS + 1))
                fi
            done
        fi
    fi

    # Count and validate commands
    if [ -d "$plugin_dir/commands" ]; then
        local command_output
        local command_exit_code=0

        # Capture find output and check for errors
        if command_output=$(find "$plugin_dir/commands" -name "*.md" 2>&1); then
            local command_count=$(echo "$command_output" | grep -c "\.md$" || echo "0")
            echo -e "${GREEN}✓${NC} Found $command_count command(s)"
        else
            echo -e "${RED}✗${NC} Failed to scan commands directory: $command_output"
            ERRORS=$((ERRORS + 1))
        fi
    fi

    # Count and validate skills
    if [ -d "$plugin_dir/skills" ]; then
        local skill_dirs=("$plugin_dir/skills"/*/)

        # Check if glob matched anything
        if [ ! -d "${skill_dirs[0]}" ]; then
            echo -e "${YELLOW}⚠${NC} No skill directories found in $plugin_dir/skills"
            WARNINGS=$((WARNINGS + 1))
        else
            local skill_count=${#skill_dirs[@]}
            echo -e "${GREEN}✓${NC} Found $skill_count skill(s)"

            # Check each skill has SKILL.md
            for skill_dir in "${skill_dirs[@]}"; do
                if [ -d "$skill_dir" ]; then
                    local skill_name=$(basename "$skill_dir")
                    test_file_exists "$skill_dir/SKILL.md" "$skill_name has SKILL.md"
                fi
            done
        fi
    fi
}

# Validate all three plugins using absolute paths
validate_plugin "codebase-audit" "$SCRIPT_DIR/codebase-audit"
validate_plugin "prompt-automation" "$SCRIPT_DIR/prompt-automation"
validate_plugin "pr-learner" "$SCRIPT_DIR/pr-learner"

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
