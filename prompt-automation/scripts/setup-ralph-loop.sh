#!/usr/bin/env bash
# Setup Ralph Loop for Prompt Automation Plugin
# Based on ralph-wiggum plugin architecture

set -e

RALPH_STATE_FILE=".claude/ralph-task.local.md"

# Function to generate minimal implementation prompt
generate_minimal_prompt() {
  local TASK_NAME="$1"
  local DESIGN_FILE="$2"
  local COMPLETION_PROMISE="$3"

  cat <<EOF
# Implementation Task: $TASK_NAME

Implement the complete plan detailed in **$DESIGN_FILE**.

## Design Document Reference

Read **$DESIGN_FILE** for:
- Complete requirements and architecture
- Detailed implementation tasks breakdown
- All acceptance criteria
- Edge case handling strategies
- Technology stack decisions

## Validation Protocol

**After each logical chunk of work:**
1. Run relevant tests from DESIGN file
2. Verify no regressions introduced
3. Commit changes if tests pass

**Before signaling completion:**
1. **Run full validation suite:**
   - Execute all test commands (check DESIGN file)
   - Run build command (check DESIGN file)
   - Run linting/type-checking (if applicable)
   - Verify coverage meets threshold (if specified)

2. **Verify ALL acceptance criteria met:**
   - Review each criterion in DESIGN file
   - Ensure every checkbox can be checked
   - Validate edge cases are handled

3. **Ensure git status clean:**
   - All changes committed
   - Meaningful commit messages
   - No uncommitted work

4. **Review implementation quality:**
   - Code follows project patterns
   - Tests are comprehensive
   - Documentation is updated

**If ANY validation fails:**
- DO NOT signal completion
- Identify the specific failure
- Fix the issue
- Re-run validation
- Continue until all validations pass

## Completion Signal

Output this ONLY when ALL of the above validations pass:

<promise>$COMPLETION_PROMISE</promise>

## Working Style

- **Reference DESIGN file frequently** - it's your source of truth
- **Work incrementally** - implement in small, testable chunks
- **Test early and often** - catch issues immediately
- **Self-correct** - if validation fails, fix and continue
- **Use TodoWrite** - track progress through implementation phases
- **Commit logically** - group related changes together
- **Never skip validation** - always verify before signaling completion
EOF
}

# Check if a Ralph Loop is already active
if [ -f "$RALPH_STATE_FILE" ]; then
    # Check if it's actually active
    if grep -q "^active: true" "$RALPH_STATE_FILE" 2>/dev/null; then
        # Extract iteration and task name from frontmatter
        FRONTMATTER_CHECK=$(awk '/^---$/{ if (++count == 2) exit } count == 1 && NR > 1' "$RALPH_STATE_FILE")
        CURRENT_ITERATION=$(echo "$FRONTMATTER_CHECK" | grep "^iteration:" | sed 's/iteration: *//' | sed 's/"//g')
        CURRENT_TASK=$(echo "$FRONTMATTER_CHECK" | grep "^taskName:" | sed 's/taskName: *//' | sed 's/"//g')
        echo ""
        echo "❌ Error: A Ralph Loop is already active!"
        echo "   Current task: $CURRENT_TASK"
        echo "   Current iteration: $CURRENT_ITERATION"
        echo ""
        echo "Please cancel the active loop first with: /ralph-task-cancel"
        echo "Or remove the state file: rm $RALPH_STATE_FILE"
        echo ""
        exit 1
    fi
    echo "⚠️  Found inactive loop state file, will overwrite..."
fi

# Parse arguments
PROMPT=""
MAX_ITERATIONS=""
COMPLETION_PROMISE=""
DESIGN_FILE=""

show_help() {
    cat << EOF
Usage: setup-ralph-loop.sh [OPTIONS]

Setup Ralph Loop for autonomous task implementation.

OPTIONS:
    --design-file <path>           Path to DESIGN-<timestamp>.md file (required)
    --max-iterations <n>           Maximum iterations before stopping (default: 25)
    --completion-promise <text>    Text that signals completion (auto-generated if not provided)
    -h, --help                     Show this help message

EXAMPLES:
    # With existing design file
    setup-ralph-loop.sh --design-file DESIGN-20260120-143022.md --max-iterations 30

    # Auto-detect latest design file
    setup-ralph-loop.sh --max-iterations 20

EOF
    exit 0
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --design-file)
            DESIGN_FILE="$2"
            shift 2
            ;;
        --max-iterations)
            MAX_ITERATIONS="$2"
            shift 2
            ;;
        --completion-promise)
            COMPLETION_PROMISE="$2"
            shift 2
            ;;
        -h|--help)
            show_help
            ;;
        *)
            echo "Unknown option: $1"
            show_help
            ;;
    esac
done

# Find DESIGN file if not specified
if [ -z "$DESIGN_FILE" ]; then
    DESIGN_FILE=$(ls -t DESIGN-*.md 2>/dev/null | head -1)
    if [ -z "$DESIGN_FILE" ]; then
        echo "❌ Error: No DESIGN file found. Please run /ralph-task-design first."
        exit 1
    fi
    echo "📄 Auto-detected design file: $DESIGN_FILE"
fi

# Validate DESIGN file exists
if [ ! -f "$DESIGN_FILE" ]; then
    echo "❌ Error: Design file not found: $DESIGN_FILE"
    exit 1
fi

# Extract task info from DESIGN file
TASK_NAME=$(grep -m1 "^# " "$DESIGN_FILE" | sed 's/^# //')
[ -z "$TASK_NAME" ] && TASK_NAME="Task"

TASK_TYPE=$(grep -m1 "^\*\*Task Type\*\*:" "$DESIGN_FILE" | sed 's/^\*\*Task Type\*\*: *//')
[ -z "$TASK_TYPE" ] && TASK_TYPE="Unknown"

# Set default max iterations
if [ -z "$MAX_ITERATIONS" ]; then
    MAX_ITERATIONS=25
fi

# Validate max iterations is a positive integer (must be > 0)
if ! [[ "$MAX_ITERATIONS" =~ ^[1-9][0-9]*$ ]]; then
    echo "❌ Error: --max-iterations must be a positive integer (greater than 0)"
    exit 1
fi

# Generate completion promise based on task type if not provided
if [ -z "$COMPLETION_PROMISE" ]; then
    case "$TASK_TYPE" in
        *"Testing"*|*"test"*)
            COMPLETION_PROMISE="TESTS_COMPLETE"
            ;;
        *"Feature"*|*"feature"*)
            COMPLETION_PROMISE="FEATURE_COMPLETE"
            ;;
        *"Bug"*|*"bug"*|*"Fix"*|*"fix"*)
            COMPLETION_PROMISE="BUG_FIXED"
            ;;
        *"Performance"*|*"performance"*|*"Optimization"*)
            COMPLETION_PROMISE="OPTIMIZED"
            ;;
        *"Refactor"*|*"refactor"*)
            COMPLETION_PROMISE="REFACTORED"
            ;;
        *"Security"*|*"security"*)
            COMPLETION_PROMISE="SECURITY_FIXED"
            ;;
        *"Documentation"*|*"documentation"*|*"Docs"*)
            COMPLETION_PROMISE="DOCS_COMPLETE"
            ;;
        *"API"*|*"api"*)
            COMPLETION_PROMISE="API_COMPLETE"
            ;;
        *)
            COMPLETION_PROMISE="TASK_COMPLETE"
            ;;
    esac
    echo "🎯 Auto-generated completion promise: $COMPLETION_PROMISE"
fi

# Lock the DESIGN file (cross-platform sed)
if grep -q "^\*\*Status\*\*: Design Phase" "$DESIGN_FILE" 2>/dev/null; then
    sed 's/^\*\*Status\*\*: Design Phase/**Status**: LOCKED ✅ - Ready for Implementation/' "$DESIGN_FILE" > "$DESIGN_FILE.tmp" && mv "$DESIGN_FILE.tmp" "$DESIGN_FILE"
    echo "🔒 Locked design file"
elif grep -q "^\*\*Status\*\*: LOCKED" "$DESIGN_FILE" 2>/dev/null; then
    echo "✓ Design file already locked"
else
    # Add status line if not present (cross-platform approach)
    awk 'NR==3{print "**Status**: LOCKED ✅ - Ready for Implementation"}1' "$DESIGN_FILE" > "$DESIGN_FILE.tmp" && mv "$DESIGN_FILE.tmp" "$DESIGN_FILE"
    echo "🔒 Added lock status to design file"
fi

# Create .claude directory if it doesn't exist
mkdir -p .claude

# Create ralph state file with YAML frontmatter (quote string values)
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
cat > "$RALPH_STATE_FILE" << EOF
---
active: true
iteration: 0
maxIterations: $MAX_ITERATIONS
completionPromise: "$COMPLETION_PROMISE"
designFile: "$DESIGN_FILE"
taskName: "$TASK_NAME"
taskType: "$TASK_TYPE"
startedAt: "$TIMESTAMP"
---

$(generate_minimal_prompt "$TASK_NAME" "$DESIGN_FILE" "$COMPLETION_PROMISE")
EOF

echo ""
echo "✅ Ralph Loop initialized successfully!"
echo ""
echo "📋 Configuration:"
echo "   Design: $DESIGN_FILE"
echo "   Task: $TASK_NAME"
echo "   Type: $TASK_TYPE"
echo "   Max Iterations: $MAX_ITERATIONS"
echo "   Completion Promise: <promise>$COMPLETION_PROMISE</promise>"
echo "   State File: $RALPH_STATE_FILE"
echo ""
echo "🔄 Loop Status:"
echo "   Iteration: 0 / $MAX_ITERATIONS"
echo "   Status: Starting..."
echo ""
echo "⚠️  IMPORTANT:"
echo "   - This loop will continue until completion promise is output"
echo "   - Use /ralph-task-cancel to stop the loop at any time"
echo "   - The completion promise must be TRUE, not just to escape the loop"
echo ""
echo "🚀 Starting implementation in iteration 1..."
echo ""

# Output the prompt to start the loop
cat << EOF

$(generate_minimal_prompt "$TASK_NAME" "$DESIGN_FILE" "$COMPLETION_PROMISE")

---

**Ralph Loop Initialized:**
- Design: $DESIGN_FILE
- Iteration: 1 / $MAX_ITERATIONS
- Completion Signal: <promise>$COMPLETION_PROMISE</promise>
- State: $RALPH_STATE_FILE

Begin implementation. Work incrementally, validate frequently, and output the completion promise only when ALL acceptance criteria are met and validation passes.
EOF
