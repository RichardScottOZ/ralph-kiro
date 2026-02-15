You can resume the last conversation from your current directory by      │
│                    launching with kiro-cli chat --resume


# Option A: Ralph workflow (general)
kiro-cli chat --agent ralph-clarify     # Answer 40-70 questions
kiro-cli chat --agent ralph-plan        # Generates PROMPT.md + TODO.md
./ralph-execute.sh                      # Autonomous execution loop

# Option B: Lisa + Ralph (recommended for new features)
kiro-cli chat --agent lisa-plan         # Spec interview, say "done" to finalize
# Then create/edit PROMPT.md to reference the spec
./ralph-execute.sh                      # Autonomous execution loop

# Or the raw loop:
while :; do cat PROMPT.md | kiro-cli chat --no-interactive -a; done