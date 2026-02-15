#!/bin/bash

# Ralph Wiggum Setup Script for Kiro CLI
# This script sets up a new project with the Ralph Wiggum workflow

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Check for help flag
if [ "$1" = "--help" ] || [ "$1" = "-h" ]; then
    echo "Ralph Wiggum Setup Script"
    echo ""
    echo "Usage: ./setup-ralph.sh <project-name>"
    echo ""
    echo "This script sets up a new project with the Ralph Wiggum workflow for Kiro CLI."
    echo ""
    echo "Example:"
    echo "  ./setup-ralph.sh my-awesome-project"
    echo ""
    echo "The script will:"
    echo "  - Create a new directory for your project"
    echo "  - Initialize a git repository"
    echo "  - Copy Kiro agent configurations"
    echo "  - Copy template files (PROMPT.md, TODO.md, clarify-session.md)"
    echo "  - Create a project README"
    echo "  - Make an initial git commit"
    exit 0
fi

# Check if project name is provided
if [ -z "$1" ]; then
    echo -e "${RED}Error: Project name required${NC}"
    echo "Usage: ./setup-ralph.sh <project-name>"
    echo "Use --help for more information"
    exit 1
fi

PROJECT_NAME="$1"
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo -e "${BLUE}🤖 Setting up Ralph Wiggum workflow for: ${GREEN}$PROJECT_NAME${NC}"
echo ""

# Create project directory
if [ -d "$PROJECT_NAME" ]; then
    echo -e "${RED}Error: Directory '$PROJECT_NAME' already exists${NC}"
    exit 1
fi

echo -e "${YELLOW}Creating project directory...${NC}"
mkdir -p "$PROJECT_NAME"
cd "$PROJECT_NAME"

# Initialize git
echo -e "${YELLOW}Initializing git repository...${NC}"
git init

# Create directory structure
echo -e "${YELLOW}Creating directory structure...${NC}"
mkdir -p .kiro/agents
mkdir -p docs/specs
mkdir -p src

# Copy agent configurations
echo -e "${YELLOW}Copying Kiro agent configurations...${NC}"
if [ -d "$SCRIPT_DIR/.kiro/agents" ]; then
    cp -r "$SCRIPT_DIR/.kiro/agents/"* .kiro/agents/
else
    echo -e "${RED}Warning: Agent configurations not found at $SCRIPT_DIR/.kiro/agents${NC}"
    echo -e "${YELLOW}You may need to copy them manually.${NC}"
fi

# Copy template files
echo -e "${YELLOW}Copying template files...${NC}"
if [ -d "$SCRIPT_DIR/templates" ]; then
    cp "$SCRIPT_DIR/templates/PROMPT.md" .
    cp "$SCRIPT_DIR/templates/TODO.md" .
    cp "$SCRIPT_DIR/templates/clarify-session.md" .
else
    echo -e "${RED}Warning: Templates not found at $SCRIPT_DIR/templates${NC}"
    echo -e "${YELLOW}Creating basic templates...${NC}"
    
    # Create basic PROMPT.md
    cat > PROMPT.md << 'EOF'
# PROMPT.md

## Project
[Describe your project]

## Instructions

1. Read TODO.md for current tasks
2. Pick the highest priority incomplete task
3. Implement it completely
4. Mark it done in TODO.md
5. Commit your changes
6. Continue to next task

When all tasks are complete, output: DONE
EOF

    # Create basic TODO.md
    cat > TODO.md << 'EOF'
# TODO

## Tasks
- [ ] Task 1
- [ ] Task 2
- [ ] Task 3

---
## Completed
EOF

    # Create basic clarify-session.md
    cat > clarify-session.md << 'EOF'
# Discovery Session

## Requirements
- [Add your requirements here]

## Notes
- [Add notes from clarification]
EOF
fi

# Create a basic README
echo -e "${YELLOW}Creating project README...${NC}"
cat > README.md << EOF
# $PROJECT_NAME

This project uses the Ralph Wiggum workflow for autonomous AI development.

## Setup

This project was initialized with the Ralph Wiggum workflow for Kiro CLI.

## Workflow

### Phase 1: Clarify (Two Options)

#### Option A: Ralph-Clarify - General requirements gathering
\`\`\`bash
kiro-cli chat --agent ralph-clarify
\`\`\`

#### Option B: Lisa - Feature specification interview (Recommended for new features)
\`\`\`bash
kiro-cli chat --agent lisa-plan
# Describe your feature, Lisa will ask probing questions
# Say "done" when ready to finalize
# Output: docs/specs/{feature-slug}.md, .json, -progress.txt
\`\`\`

### Phase 2: Plan
Convert requirements into execution files:

\`\`\`bash
kiro-cli chat --agent ralph-plan
\`\`\`

**OR** if you used Lisa, create PROMPT.md manually to reference the spec.

### Phase 3: Execute
Run the autonomous loop:

\`\`\`bash
# Basic loop
while :; do cat PROMPT.md | kiro-cli chat --no-interactive -a; done

# Safe loop with max iterations (recommended)
max_iterations=50
iteration=0

while [ \$iteration -lt \$max_iterations ]; do
  echo "Iteration \$((iteration + 1))/\$max_iterations"
  output=\$(cat PROMPT.md | kiro-cli chat --no-interactive -a)
  echo "\$output"
  
  if echo "\$output" | grep -q "DONE"; then
    echo "Task completed at iteration \$((iteration + 1))!"
    break
  fi
  
  iteration=\$((iteration + 1))
done
\`\`\`

## Files

- \`PROMPT.md\` - Instructions for the execution phase
- \`TODO.md\` - Task checklist
- \`clarify-session.md\` - Requirements from ralph-clarify phase
- \`docs/specs/\` - Lisa specifications (if using Lisa)
- \`.kiro/agents/\` - Kiro CLI agent configurations
  - \`ralph-clarify.json\` - Requirements gathering agent
  - \`ralph-plan.json\` - Planning agent
  - \`lisa-plan.json\` - Feature specification interview agent

## Agents

**ralph-clarify**: Comprehensive requirements discovery (40-70 questions)  
**lisa-plan**: Interactive specification interview for features (probing questions)  
**ralph-plan**: Convert requirements/specs into execution files

**Tip**: Use Lisa for new features, Ralph-Clarify for general projects.

## Learn More

See the main Ralph Wiggum documentation at:
https://github.com/RichardScottOZ/ralph-kiro
EOF

# Create .gitignore
echo -e "${YELLOW}Creating .gitignore...${NC}"
cat > .gitignore << 'EOF'
# Dependencies
node_modules/
venv/
.venv/
__pycache__/

# IDE
.vscode/
.idea/
*.swp
*.swo
*~

# OS
.DS_Store
Thumbs.db

# Build outputs
dist/
build/
*.pyc
*.pyo

# Logs
*.log
logs/

# Environment
.env
.env.local
EOF

# Initial git commit
echo -e "${YELLOW}Creating initial git commit...${NC}"
git add .
git commit -m "Initial setup with Ralph Wiggum workflow"

# Success message
echo ""
echo -e "${GREEN}✅ Project setup complete!${NC}"
echo ""
echo -e "${BLUE}Next steps:${NC}"
echo -e "  1. ${YELLOW}cd $PROJECT_NAME${NC}"
echo -e "  2. Choose your workflow:"
echo -e "     ${YELLOW}Option A (General):${NC} kiro-cli chat --agent ralph-clarify"
echo -e "     ${YELLOW}Option B (Feature):${NC} kiro-cli chat --agent lisa-plan"
echo -e "  3. ${YELLOW}kiro-cli chat --agent ralph-plan${NC} - Generate execution files"
echo -e "  4. Run the execution loop (see README.md)"
echo ""
echo -e "${BLUE}Project structure:${NC}"
tree -L 2 "$PROJECT_NAME" 2>/dev/null || find "$PROJECT_NAME" -maxdepth 2 -print | sed 's|[^/]*/| |g'
echo ""
echo -e "${GREEN}Happy coding with Ralph & Lisa! 🤖💡${NC}"
