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
# Phase 1: Clarify
kiro-cli chat --agent ralph-clarify

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
mkdir -p .kiro/agents src
cp /path/to/ralph-kiro/.kiro/agents/* .kiro/agents/
cp /path/to/ralph-kiro/templates/* .
```

### Phase 1: Clarify

```bash
# Interactive clarification
kiro-cli chat --agent ralph-clarify

# What happens:
# - Agent asks 40-70 questions
# - You answer each round of questions
# - Results saved to clarify-session.md
```

### Phase 2: Plan

```bash
# Generate execution files
kiro-cli chat --agent ralph-plan

# What happens:
# - Reads clarify-session.md
# - Generates PROMPT.md (instructions + guardrails)
# - Generates TODO.md (task checklist)
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
while :; do 
  cat PROMPT.md | kiro-cli chat --mode script
done

# Manual execution (safe loop with completion detection)
max_iterations=50
iteration=0
while [ $iteration -lt $max_iterations ]; do
  echo "Iteration $((iteration + 1))/$max_iterations"
  output=$(cat PROMPT.md | kiro-cli chat --mode script)
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
│       └── ralph-plan.yaml      # Plan agent config
├── clarify-session.md            # Requirements (from phase 1)
├── PROMPT.md                     # Execution instructions (from phase 2)
├── TODO.md                       # Task checklist (from phase 2)
├── ralph-execution.log           # Execution log (from phase 3)
└── src/                          # Your code (created in phase 3)
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
- Say "enough" when you're ready to move on
- Aim for 40-70 questions for comprehensive coverage

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

## 🎓 When to Use Ralph

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

- **Original Concept**: https://ghuntley.com/ralph/
- **Full Gist**: https://gist.github.com/Mburdo/ce99c9b08601aaf771efaabf1260d4c0
- **Kiro CLI Docs**: https://kiro.dev/docs/cli/
- **This Repository**: https://github.com/RichardScottOZ/ralph-kiro

## 🤝 Getting Help

1. Check this quick reference
2. Read the full README.md
3. Review the examples/ directory
4. Check ralph-execution.log for errors
5. Open an issue on GitHub

---

**Remember**: Ralph works through iteration. Each failure teaches you what guardrails to add. Trust the process! 🤖
