# 🤖 Ralph Wiggum Workflow for Kiro CLI

> **A comprehensive guide to autonomous AI development using the Ralph Wiggum technique with Kiro CLI.**

[![Kiro CLI](https://img.shields.io/badge/Kiro-CLI-blue?style=flat-square)](https://kiro.dev/cli/)
[![Autonomous](https://img.shields.io/badge/Mode-Autonomous-success?style=flat-square)](https://ghuntley.com/ralph/)
[![License](https://img.shields.io/badge/License-MIT-blue?style=flat-square)](#)

---

## 📑 Table of Contents

- [What is Ralph Wiggum?](#-what-is-ralph-wiggum)
- [What is Lisa?](#-what-is-lisa)
- [How to Set Up](#-how-to-set-up)
- [The Workflow](#-the-workflow)
- [Phase 1: Clarify (or Lisa)](#-phase-1-clarify-or-lisa)
- [Phase 2: Plan](#-phase-2-plan)
- [Phase 3: Execute](#-phase-3-execute)
- [Templates](#-templates)
- [Quick Start](#-quick-start)
- [Differences from Claude Code](#-differences-from-claude-code)
- [Troubleshooting](#-troubleshooting)
- [Philosophy Recap](#-philosophy-recap)
- [Sources](#-sources)

---

## 🧠 What is Ralph Wiggum?

Ralph Wiggum is an autonomous development technique created by **Geoffrey Huntley**. At its core, it's simple:

```bash
while :; do cat PROMPT.md | kiro-cli chat --no-interactive -a; done
```

A bash loop that repeatedly feeds the same prompt to an AI agent until the task is complete.

### Philosophy

> *"The technique is **deterministically bad in an undeterministic world**."*

- When Ralph fails, you don't blame the tools — **you tune the prompts**
- Failures are predictable and informative
- Success requires faith in eventual consistency
- Each failure teaches you what "signs" (guardrails) to add

### The Playground Metaphor

From Huntley:

> *"Ralph is very good at making playgrounds, but he comes home bruised because he fell off the slide, so one then tunes Ralph by adding a sign next to the slide saying 'SLIDE DOWN, DON'T JUMP, LOOK AROUND,' and Ralph is more likely to look and see the sign."*

Eventually, the prompt has enough guardrails that Ralph works reliably.

---

## 💡 What is Lisa?

**Lisa plans. Ralph does.**

Lisa is an interactive specification interview workflow adapted from [blencorp/lisa](https://github.com/blencorp/lisa) for Kiro CLI. Lisa conducts in-depth feature interviews to generate comprehensive, implementable specifications.

### Why Use Lisa?

Based on the technique by [@trq212](https://twitter.com/trq212):

> *"My favorite way to use Claude Code to build large features is spec based. Start with a minimal spec or prompt and ask Claude to interview you using the AskUserQuestion tool about literally anything: technical implementation, UI & UX, concerns, tradeoffs, etc. Then make a new session to execute the spec."*

### Lisa's Approach

- **Probing Questions**: Instead of basic "what should it do?", Lisa asks "How should X handle Y when Z fails?"
- **Comprehensive Coverage**: Technical implementation, UX, edge cases, trade-offs, and verification
- **Structured Output**: Generates markdown specs, JSON user stories, and progress tracking files
- **Ralph-Ready**: Specs are designed to be consumed by Ralph for autonomous implementation

### When to Use Lisa vs Ralph-Clarify

| Use Lisa When... | Use Ralph-Clarify When... |
|-----------------|---------------------------|
| Building a new feature from scratch | Clarifying requirements for an existing system |
| Need detailed technical specifications | Need a quick requirements gathering session |
| Want structured user stories with acceptance criteria | Want a flexible requirements document |
| Planning to use Ralph for implementation | Planning to implement manually or with custom workflow |

### Lisa Workflow

```
┌──────────────────────────────────────┐
│         LISA SPECIFICATION           │
│                                      │
│  kiro-cli chat --agent lisa-plan     │
│                                      │
│  📋 Interactive interview            │
│  → Probing questions                 │
│  → Draft updated continuously        │
│  → Say "done" to finalize            │
│  → Output: Complete spec             │
└──────────────────────────────────────┘
              │
              ▼
┌──────────────────────────────────────┐
│    Generated Specification Files     │
│                                      │
│  • docs/specs/{feature}.md           │
│  • docs/specs/{feature}.json         │
│  • docs/specs/{feature}-progress.txt │
└──────────────────────────────────────┘
              │
              ▼
┌──────────────────────────────────────┐
│      RALPH IMPLEMENTATION            │
│                                      │
│  Use Ralph to implement the spec     │
│  (See Phase 3: Execute)              │
└──────────────────────────────────────┘
```

See [examples/lisa-workflow-example.md](examples/lisa-workflow-example.md) for a complete walkthrough.

---

## 🔧 How to Set Up

### Prerequisites

| Requirement | Description |
|-------------|-------------|
| **Kiro CLI** | Already installed and authenticated |
| **Git** | For state tracking and memory |

### Step 1: Install Kiro CLI

If you haven't already installed Kiro CLI:

```bash
# macOS & Linux
curl -fsSL https://cli.kiro.dev/install | bash

# Or with Homebrew (macOS)
brew install kiro-cli

# Verify installation
kiro-cli --version
```

> **⚠️ Important Note**: This workflow is an adaptation of the original Ralph Wiggum technique (designed for Claude Code) to work with Kiro CLI. The Kiro CLI agent system and commands may differ from those shown here. You may need to adjust the agent configurations in `.kiro/agents/` to match your Kiro CLI version's capabilities. Refer to [Kiro CLI documentation](https://kiro.dev/docs/cli/) for the latest agent configuration format.

### Step 2: Clone this Repository

```bash
git clone https://github.com/RichardScottOZ/ralph-kiro.git
cd ralph-kiro
```

### Step 3: Set Up a New Project

```bash
# Copy the ralph-kiro setup to your project
./setup-ralph.sh my-project

# Or manually:
mkdir my-project
cd my-project
git init
mkdir -p .kiro/agents
cp -r /path/to/ralph-kiro/.kiro/agents/* .kiro/agents/
cp /path/to/ralph-kiro/templates/* .
```

### Project Structure After Setup

```
my-project/
├── .git/                      # Git repo (required)
├── .kiro/
│   └── agents/
│       ├── ralph-clarify.yaml # Phase 1: Requirements discovery
│       ├── ralph-plan.yaml    # Phase 2: Generate execution files
│       ├── lisa-plan.yaml     # Alternative: Lisa spec interview
│       └── ralph-execute.yaml # Phase 3: Execute tasks
├── PROMPT.md                  # Ralph's instructions (generated by plan)
├── TODO.md                    # Task checklist (generated by plan)
├── clarify-session.md         # Requirements (from ralph-clarify)
├── docs/
│   └── specs/                 # Lisa specifications (if using Lisa)
└── src/                       # Your code (created during execution)
```

---

## 🔄 The Workflow

### Option A: Ralph Workflow (Original)

```
┌──────────────────────────────────────────────────────────────────────────┐
│                           PHASE 1: CLARIFY                               │
│                                                                          │
│   Command: kiro-cli chat --agent ralph-clarify                          │
│                                                                          │
│   📋 40-70 questions via interactive chat                                │
│   → Exhaustive requirements discovery                                    │
│   → Output: clarify-session.md                                           │
└──────────────────────────────────────────────────────────────────────────┘
                                    │
                                    ▼
┌──────────────────────────────────────────────────────────────────────────┐
│                            PHASE 2: PLAN                                 │
│                                                                          │
│   Command: kiro-cli chat --agent ralph-plan                             │
│                                                                          │
│   📝 Convert requirements to actionable tasks                            │
│   → Create PROMPT.md (execution instructions + guardrails)               │
│   → Create TODO.md (prioritized task checklist)                          │
└──────────────────────────────────────────────────────────────────────────┘
                                    │
                                    ▼
┌──────────────────────────────────────────────────────────────────────────────┐
│                          PHASE 3: EXECUTE                                    │
│                                                                              │
│   Command: while :; do cat PROMPT.md | kiro-cli chat --no-interactive -a; done    │
│                                                                              │
│   🔁 Ralph loop until complete                                               │
│   → Pick task → Complete → Mark done → Repeat                                │
│   → Output: Working software                                                 │
└──────────────────────────────────────────────────────────────────────────────┘
```

### Option B: Lisa + Ralph Workflow (Recommended for Features)

```
┌──────────────────────────────────────────────────────────────────────────┐
│                      LISA: SPECIFICATION                                 │
│                                                                          │
│   Command: kiro-cli chat --agent lisa-plan                              │
│                                                                          │
│   📋 In-depth feature interview                                          │
│   → Probing questions about implementation                               │
│   → Draft spec updated continuously                                      │
│   → Output: Complete spec with user stories                              │
└──────────────────────────────────────────────────────────────────────────┘
                                    │
                                    ▼
┌──────────────────────────────────────────────────────────────────────────┐
│                    GENERATED SPECIFICATION                               │
│                                                                          │
│   Files: docs/specs/{feature}.md, .json, -progress.txt                  │
│   → Markdown specification                                               │
│   → JSON user stories                                                    │
│   → Progress tracking file                                               │
└──────────────────────────────────────────────────────────────────────────┘
                                    │
                                    ▼
┌──────────────────────────────────────────────────────────────────────────────┐
│                     RALPH: IMPLEMENTATION                                    │
│                                                                              │
│   Create PROMPT.md referencing the spec                                      │
│   Command: while :; do cat PROMPT.md | kiro-cli chat --no-interactive -a; done    │
│                                                                              │
│   🔁 Ralph implements spec until complete                                    │
│   → Implements user stories                                                  │
│   → Verifies acceptance criteria                                             │
│   → Output: Working software                                                 │
└──────────────────────────────────────────────────────────────────────────────┘
```

---

## 📋 Phase 1: Clarify (or Lisa)

You have two options for the requirements/specification phase:

### Option A: Ralph-Clarify (General Requirements)

The clarify phase uses interactive questioning to gather **40-70 questions** covering all aspects of the project.

#### Why This Matters

> *"The loop pressure overrides the natural tendency to stop asking after 3-5 questions."*

#### Question Categories

| Category | Questions to Cover |
|----------|-------------------|
| **Core Requirements** | What must this do? What's MVP? What's out of scope? |
| **Users & Context** | Who uses this? What's their skill level? What constraints exist? |
| **Technical Choices** | Language? Framework? Database? Dependencies? |
| **Integration Points** | What systems does this connect to? What data flows in/out? |
| **Edge Cases** | What happens when things fail? Boundary conditions? |
| **Quality Attributes** | Performance requirements? Security considerations? |
| **Existing Patterns** | How do similar things work in this codebase? Conventions? |
| **Preferences** | Strong opinions on approach? Tradeoffs? |

#### Running the Clarify Phase

```bash
# Start the clarify agent
kiro-cli chat --agent ralph-clarify

# In the chat, describe your project:
# "I want to build a REST API for task management"

# The agent will ask you 40-70 questions
# Answer them thoroughly
# Results are saved to clarify-session.md
```

#### Output: `clarify-session.md`

```markdown
# Discovery: Task Management API

Started: 2024-01-10

## Questions Asked
1. What authentication method? → JWT
2. What database? → PostgreSQL
3. ...

## Answers Received
- Authentication: JWT with refresh tokens
- Database: PostgreSQL with Prisma ORM
- ...

## Emerging Requirements
- Must support 1000 concurrent users
- API must be RESTful with OpenAPI spec
- All endpoints require authentication except /health
- ...
```

### Option B: Lisa (Feature Specifications)

**Recommended for new features.** Lisa conducts a specification interview with probing questions to generate a complete, implementable spec.

#### Running the Lisa Phase

```bash
# Start the Lisa agent
kiro-cli chat --agent lisa-plan

# In the chat, describe your feature:
# "I want to spec out a user authentication system"

# Lisa will ask probing questions about:
# - Technical implementation details
# - User experience and edge cases
# - Trade-offs and concerns
# - Implementation phases
# - Verification criteria

# Say "done" or "finalize" when ready to complete
```

#### What Makes Lisa Different

Unlike Ralph-Clarify which asks general requirements questions, Lisa asks **non-obvious, probing questions**:

| Ralph-Clarify Might Ask | Lisa Asks Instead |
|------------------------|-------------------|
| "What authentication methods?" | "What authentication methods, and what's driving that choice - user preference, existing infrastructure, or security requirements?" |
| "What should happen on error?" | "When login fails due to network issues, should we retry automatically, show a retry button, or redirect to an offline mode?" |
| "What are the requirements?" | "How should the system handle concurrent login attempts from the same user? Should we invalidate old sessions or allow multiple active sessions?" |

#### Output Files

Lisa generates three files in `docs/specs/`:

1. **`{feature-slug}.md`** - Comprehensive markdown specification
2. **`{feature-slug}.json`** - Structured JSON with user stories and acceptance criteria
3. **`{feature-slug}-progress.txt`** - Progress tracking file for Ralph

**Example:** For "user authentication system":
- `docs/specs/user-authentication-system.md`
- `docs/specs/user-authentication-system.json`
- `docs/specs/user-authentication-system-progress.txt`

See [examples/lisa-workflow-example.md](examples/lisa-workflow-example.md) for a complete walkthrough.

---

## 📝 Phase 2: Plan

Convert the clarify session (or Lisa spec) into actionable instructions.

### Running the Plan Phase

#### From Ralph-Clarify Output

```bash
# Start the plan agent
kiro-cli chat --agent ralph-plan

# Tell it to read clarify-session.md and generate execution files
# It will create PROMPT.md and TODO.md
```

#### From Lisa Spec

If you used Lisa, create a PROMPT.md that references the spec:

```markdown
# PROMPT.md

## Project
Implement the {feature name} as specified in docs/specs/{feature-slug}.md

## Requirements
Read the full specification at docs/specs/{feature-slug}.md

Follow the implementation phases defined in the spec.

## Instructions
1. Read the spec file for complete requirements
2. Implement one user story at a time from the JSON spec
3. After each story, run verification commands
4. Update the JSON spec's "passes" field to true when complete
5. Continue until all user stories pass

## Completion
When all user stories have "passes": true and all tests pass, output: DONE
```

### Generated Files

**PROMPT.md** — Execution instructions with guardrails  
**TODO.md** — Prioritized task checklist with HARD STOP checkpoints

---

## 🚀 Phase 3: Execute

Run the Ralph loop until complete.

### Basic Loop

```bash
# Simple bash loop
while :; do cat PROMPT.md | kiro-cli chat --no-interactive -a; done
```

### Enhanced Loop with Completion Detection

```bash
# Loop that exits when "DONE" is detected
while :; do 
  output=$(cat PROMPT.md | kiro-cli chat --no-interactive -a)
  echo "$output"
  if echo "$output" | grep -q "DONE"; then
    echo "Task completed!"
    break
  fi
done
```

### Loop with Max Iterations

```bash
# Safe loop with iteration limit
max_iterations=50
iteration=0

while [ $iteration -lt $max_iterations ]; do
  echo "Iteration $((iteration + 1))/$max_iterations"
  output=$(cat PROMPT.md | kiro-cli chat --no-interactive -a)
  echo "$output"
  
  if echo "$output" | grep -q "DONE"; then
    echo "Task completed at iteration $((iteration + 1))!"
    break
  fi
  
  iteration=$((iteration + 1))
done

if [ $iteration -eq $max_iterations ]; then
  echo "Reached max iterations without completion"
fi
```

### What Happens During Execution

```
Iteration 1: Kiro reads PROMPT.md → Picks Task 1 → Implements → Commits
     ↓
Iteration 2: Kiro reads PROMPT.md → Sees Task 1 done → Picks Task 2 → Implements → Commits
     ↓
Iteration 3: ...
     ↓
Iteration N: All tasks done → Kiro outputs "DONE" → Loop exits
```

Each iteration:
- Sees the same `PROMPT.md`
- But files have changed (previous work persists)
- Git history shows progress
- `TODO.md` reflects completed tasks

---

## 📄 Templates

### Minimal PROMPT.md (Start Here)

```markdown
# PROMPT.md

Build [WHAT YOU'RE BUILDING].

Requirements:
- [Requirement 1]
- [Requirement 2]
- [Requirement 3]

Track progress in TODO.md. Commit after each completed item.

When all requirements are implemented and tests pass, output: DONE
```

### PROMPT.md with Guardrails

```markdown
# PROMPT.md

## Task
[Description of what to build]

## Requirements
Read clarify-session.md for full requirements.

## Instructions
1. Read TODO.md for current tasks
2. Pick highest priority incomplete task
3. Read any files before editing them
4. Implement the task
5. Run tests
6. If tests fail, fix before continuing
7. Mark complete in TODO.md
8. Commit with clear message
9. Repeat until all tasks done

## Signs (Guardrails)
- Always read before editing
- Never skip failing tests
- Don't refactor unrelated code
- Keep commits focused
- Update TODO.md immediately after completing tasks

## Completion
When TODO.md shows all tasks complete and tests pass, output: DONE
```

### TODO.md Template

```markdown
# TODO

## Critical (Must Have)
- [ ] Task 1
- [ ] Task 2
- [ ] **HARD STOP** - Verify core flow works end-to-end

## Important (Should Have)
- [ ] Task 3
- [ ] Task 4

## Nice to Have
- [ ] Task 5
- [ ] Task 6

---
## Completed
- [x] Example completed task
```

---

## ⚡ Quick Start

```bash
# 1. Set up a new project
./setup-ralph.sh my-awesome-project
cd my-awesome-project

# 2. Phase 1: Clarify - gather requirements
kiro-cli chat --agent ralph-clarify
# Describe your project and answer 40-70 questions

# 3. Phase 2: Plan - convert requirements to execution files
kiro-cli chat --agent ralph-plan
# Agent reads clarify-session.md and generates PROMPT.md and TODO.md

# 4. Phase 3: Execute - run the autonomous loop
while :; do 
  output=$(cat PROMPT.md | kiro-cli chat --no-interactive -a)
  echo "$output"
  if echo "$output" | grep -q "DONE"; then
    break
  fi
done
```

---

## 🔄 Differences from Claude Code

This implementation adapts the original Ralph Wiggum workflow from Claude Code to Kiro CLI:

| Feature | Claude Code | Kiro CLI (This Repo) |
|---------|-------------|----------------------|
| **Plugin System** | `/ralph-loop` command | Bash loop with `kiro-cli chat` |
| **Commands** | Custom slash commands | Kiro agents in `.kiro/agents/` |
| **Clarify Phase** | `/ralph-clarify` with AskUserQuestion | Interactive agent chat |
| **Plan Phase** | `/ralph-plan` command | Agent reads session and generates files |
| **Execute Phase** | `/ralph-loop` with completion promise | Bash loop with grep for "DONE" |
| **Configuration** | `.claude/commands/*.md` | `.kiro/agents/*.yaml` |
| **Loop Control** | Built-in max iterations | Manual bash loop control |
| **Completion Detection** | `<promise>` tag | Plain text "DONE" with grep |

### Key Adaptations

1. **Agents instead of Commands**: Kiro CLI uses agent configurations instead of slash commands
2. **Bash Loop**: Manual bash loop instead of built-in `/ralph-loop` command
3. **Non-interactive Mode**: Use `--no-interactive -a` (`--trust-all-tools`) for autonomous execution
4. **Grep for Completion**: Detect completion by grepping output for "DONE"
5. **Manual Iteration Limit**: Build iteration limits into the bash loop

---

## 🛠️ Troubleshooting

### Loop Runs Forever

**Problem**: The loop doesn't detect completion

**Solutions**:
- Ensure PROMPT.md explicitly tells the agent to output "DONE"
- Check that the completion string matches exactly
- Add a max iterations limit to your loop

### Agent Doesn't Follow Instructions

**Problem**: Agent skips tasks or doesn't follow PROMPT.md

**Solutions**:
- Add more specific guardrails to PROMPT.md
- Break down large tasks into smaller, clearer subtasks
- Review completed iterations and add "signs" for common failures

### Kiro CLI Authentication Issues

**Problem**: CLI asks for authentication repeatedly

**Solutions**:
```bash
# Re-authenticate
kiro-cli configure

# Check authentication status
kiro-cli config list
```

---

## 🎓 Philosophy Recap

Ralph Wiggum is about:

1. **Iteration**: Repeat until done, not turn-by-turn interaction
2. **Guardrails**: Add "signs" based on failures
3. **Autonomy**: Let the AI work without constant supervision
4. **Tuning**: Improve prompts, not blame tools
5. **Patience**: Trust in eventual consistency

### When to Use Ralph

✅ **Good for:**
- Large refactoring projects
- Greenfield development with clear requirements
- Test-driven development loops
- Repetitive implementation tasks

❌ **Not ideal for:**
- Exploratory/research tasks
- Complex debugging of unknown issues
- Tasks requiring frequent human judgment
- High-stakes production changes without review

---

## 📚 Sources

- **Original Ralph Wiggum Concept**: [Geoffrey Huntley's Blog](https://ghuntley.com/ralph/)
- **Original Gist**: [Ralph_Wiggum_Loops.md by Mburdo](https://gist.github.com/Mburdo/ce99c9b08601aaf771efaabf1260d4c0)
- **Kiro CLI Documentation**: [https://kiro.dev/docs/cli/](https://kiro.dev/docs/cli/)
- **Kiro CLI Installation**: [https://kiro.dev/cli/](https://kiro.dev/cli/)

---

## 🤝 Contributing

Improvements welcome! Please submit issues or pull requests.

## 📄 License

MIT License - Based on the original Ralph Wiggum workflow by Geoffrey Huntley
