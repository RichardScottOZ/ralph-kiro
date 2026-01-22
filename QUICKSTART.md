# Ralph Wiggum Quick Reference

## 🚀 Quick Start

```bash
# 1. Clone and setup
git clone https://github.com/RichardScottOZ/ralph-kiro.git
cd ralph-kiro

# 2. Create new project
./setup-ralph.sh my-project
cd my-project

# 3. Run the workflow
# Phase 1: Clarify (Choose one)
# Option A: General requirements
kiro-cli chat --agent ralph-clarify

# Option B: Feature specification (Recommended for new features)
kiro-cli chat --agent lisa-plan

# Phase 2: Plan
kiro-cli chat --agent ralph-plan

# Phase 3: Execute
./ralph-execute.sh --max-iterations 50
```

## 📋 Command Reference

### Setup Commands

```bash
# Setup a new project
./setup-ralph.sh <project-name>

# Manual setup
mkdir my-project && cd my-project
git init
mkdir -p .kiro/agents docs/specs src
cp /path/to/ralph-kiro/.kiro/agents/* .kiro/agents/
cp /path/to/ralph-kiro/templates/* .
```

### Phase 1: Clarify (Two Options)

#### Option A: Ralph-Clarify (General)

```bash
# Interactive clarification
kiro-cli chat --agent ralph-clarify

# What happens:
# - Agent asks 40-70 questions
# - You answer each round of questions
# - Results saved to clarify-session.md
```

#### Option B: Lisa (Feature Specification)

```bash
# Interactive specification interview
kiro-cli chat --agent lisa-plan

# In the chat, describe your feature:
# "I want to spec out a user authentication system"

# What happens:
# - Lisa asks probing, non-obvious questions
# - Draft spec updated every 2-3 questions
# - Say "done" or "finalize" to complete
# - Generates: docs/specs/{feature-slug}.md, .json, -progress.txt

# Example questions Lisa might ask:
# - "How should the system handle concurrent login attempts?"
# - "When authentication fails, should we rate-limit further attempts?"
# - "Walk me through what happens when a session expires mid-transaction"
```

**When to use Lisa vs Ralph-Clarify:**
- **Use Lisa**: Building a new feature, need technical spec with user stories
- **Use Ralph-Clarify**: General projects, broader requirements gathering

### Phase 2: Plan

```bash
# From Ralph-Clarify output
kiro-cli chat --agent ralph-plan

# What happens:
# - Reads clarify-session.md
# - Generates PROMPT.md (instructions + guardrails)
# - Generates TODO.md (task checklist)
```

**From Lisa spec:**
If you used Lisa, create PROMPT.md manually:

```markdown
# PROMPT.md

## Project
Implement {feature} as specified in docs/specs/{feature-slug}.md

## Requirements
Read the full specification at docs/specs/{feature-slug}.md

## Instructions
1. Read the spec file for complete requirements
2. Implement one user story at a time from the JSON spec
3. After each story, run verification commands
4. Update the JSON spec's "passes" field to true when complete
5. Continue until all user stories pass

## Completion
When all user stories have "passes": true and tests pass, output: DONE
```

### Phase 3: Execute

```bash
# Safe execution with script
./ralph-execute.sh --max-iterations 50

# Options:
./ralph-execute.sh --max-iterations 30 \
                   --completion-word DONE \
                   --prompt-file PROMPT.md \
                   --log-file execution.log

# Manual execution (basic loop)
# Use --no-interactive with -a/--trust-all-tools for autonomous execution
while :; do 
  cat PROMPT.md | kiro-cli chat --no-interactive -a
done

# Manual execution (safe loop with completion detection)
max_iterations=50
iteration=0
while [ $iteration -lt $max_iterations ]; do
  echo "Iteration $((iteration + 1))/$max_iterations"
  output=$(cat PROMPT.md | kiro-cli chat --no-interactive -a)
  echo "$output"
  if echo "$output" | grep -q "DONE"; then
    echo "✅ Task completed!"
    break
  fi
  iteration=$((iteration + 1))
done
```

## 📝 File Structure

```
my-project/
├── .kiro/
│   └── agents/
│       ├── ralph-clarify.yaml   # Clarify agent config
│       ├── ralph-plan.yaml      # Plan agent config
│       └── lisa-plan.yaml       # Lisa spec interview agent
├── docs/
│   └── specs/                   # Lisa specifications (if using Lisa)
│       ├── {feature}.md         # Markdown spec
│       ├── {feature}.json       # JSON user stories
│       └── {feature}-progress.txt  # Progress tracking
├── clarify-session.md           # Requirements (from ralph-clarify)
├── PROMPT.md                    # Execution instructions (from phase 2)
├── TODO.md                      # Task checklist (from phase 2)
├── ralph-execution.log          # Execution log (from phase 3)
└── src/                         # Your code (created in phase 3)
```

## 🔧 Configuration

### Kiro Agent Settings

Edit `.kiro/agents/ralph-clarify.yaml`:
```yaml
settings:
  temperature: 0.7    # Higher for more creative questions
  max_tokens: 4000    # Increase if responses are cut off
```

Edit `.kiro/agents/ralph-plan.yaml`:
```yaml
settings:
  temperature: 0.5    # Lower for more consistent planning
  max_tokens: 4000
```

### Execution Script Settings

```bash
# Set defaults in ralph-execute.sh
MAX_ITERATIONS=50      # Safety limit
COMPLETION_WORD="DONE" # What signals completion
LOG_FILE="ralph-execution.log"
```

## 🎯 Best Practices

### Clarify Phase
- Answer questions thoroughly
- Provide examples when possible
- Don't rush - good requirements save time later
- **Ralph-Clarify**: Say "enough" when ready to move on (aim for 40-70 questions)
- **Lisa**: Say "done" or "finalize" when you've covered enough detail
- Lisa will ask more probing questions - embrace the depth!

### Plan Phase
- Review generated PROMPT.md and TODO.md
- Add project-specific guardrails
- Break down large tasks into smaller ones
- Add HARD STOPS at key milestones
- Ensure tasks are specific and measurable

### Execute Phase
- Always use max iterations limit
- Monitor progress through git commits
- Review TODO.md to track completion
- If stuck, add guardrails and restart
- Keep PROMPT.md updated as you learn

## 🐛 Troubleshooting

### Loop Never Completes
**Problem**: Runs to max iterations without "DONE"

**Solution**: Check PROMPT.md explicitly tells agent to output "DONE"

### Agent Ignores Instructions
**Problem**: Doesn't follow PROMPT.md

**Solutions**:
- Add more specific guardrails
- Break tasks into smaller pieces
- Review last few commits to see what went wrong
- Add "signs" for specific failure patterns

### Kiro CLI Errors
```bash
# Re-authenticate
kiro-cli configure

# Check status
kiro-cli config list

# Update CLI
brew upgrade kiro-cli
# or
curl -fsSL https://cli.kiro.dev/install | bash
```

### Agent Gets Stuck
**Problem**: Fails on same task repeatedly

**Solutions**:
1. Review the error in ralph-execution.log
2. Add specific guardrail to PROMPT.md
3. Break task into subtasks in TODO.md
4. Fix issue manually and resume

## 📊 Monitoring Progress

### Check TODO.md
```bash
# See completed vs remaining tasks
cat TODO.md | grep -c "\[x\]"  # Completed
cat TODO.md | grep -c "\[ \]"  # Remaining
```

### Review Git History
```bash
# See all commits from Ralph
git log --oneline

# See what changed in last commit
git show

# See changes to specific file
git log -p filename
```

### Check Execution Log
```bash
# View recent iterations
tail -f ralph-execution.log

# Count iterations
grep "Iteration" ralph-execution.log | wc -l

# Find errors
grep -i "error" ralph-execution.log
```

## 🎓 When to Use What

### Use Ralph-Clarify When:
- Building a general project or system
- Need flexible requirements gathering
- Want broad coverage of project aspects
- Requirements are unclear or exploratory

### Use Lisa When:
- Building a specific new feature
- Need detailed technical specifications
- Want structured user stories with acceptance criteria
- Ready to hand off to Ralph for implementation
- Want to challenge assumptions (use --first-principles)

### Lisa + Ralph Workflow:
1. **Lisa plans** - Generate comprehensive spec with user stories
2. **Ralph does** - Implement spec autonomously using the loop

**"Lisa plans. Ralph does."**

## 🎓 When to Use Ralph (Execution)

### ✅ Good For
- Large refactoring projects
- Greenfield development with clear requirements
- Test-driven development
- Repetitive implementation tasks
- Learning new frameworks (with good guidance)

### ❌ Not Ideal For
- Exploratory/research tasks
- Complex debugging of unknown issues
- Tasks requiring frequent human judgment
- High-stakes production changes (without review)
- Unclear requirements

## 💡 Tips & Tricks

### Improve Prompt Quality
```markdown
# Bad guardrail
- Write good code

# Good guardrail
- Use async/await for all database operations
- Return proper HTTP status codes (200, 201, 400, 404, 500)
- Validate all request inputs before processing
```

### Break Down Tasks
```markdown
# Bad task
- [ ] Add authentication

# Good tasks
- [ ] Install passport.js and express-session
- [ ] Create User model with password hashing
- [ ] Implement POST /auth/register endpoint
- [ ] Implement POST /auth/login endpoint with JWT
- [ ] Add auth middleware to protect routes
```

### Add Effective HARD STOPs
```markdown
# After core setup
- [ ] Initialize project with package.json
- [ ] Install all dependencies
- [ ] Create basic folder structure
- [ ] **HARD STOP** - Verify setup is correct

# After MVP
- [ ] Implement basic CRUD operations
- [ ] Add simple tests
- [ ] **HARD STOP** - Manual test all endpoints

# Before nice-to-haves
- [ ] Complete all error handling
- [ ] Achieve 80% test coverage
- [ ] **HARD STOP** - Review before polish phase
```

## 📚 Learn More

- **Original Ralph Concept**: https://ghuntley.com/ralph/
- **Original Gist**: https://gist.github.com/Mburdo/ce99c9b08601aaf771efaabf1260d4c0
- **Lisa Plugin (Original)**: https://github.com/blencorp/lisa
- **Kiro CLI Docs**: https://kiro.dev/docs/cli/
- **This Repository**: https://github.com/RichardScottOZ/ralph-kiro
- **Lisa Workflow Example**: See `examples/lisa-workflow-example.md`

## 🤝 Getting Help

1. Check this quick reference
2. Read the full README.md
3. Review the examples/ directory
4. Check ralph-execution.log for errors
5. Open an issue on GitHub

---

**Remember**: Ralph works through iteration. Each failure teaches you what guardrails to add. Trust the process! 🤖
