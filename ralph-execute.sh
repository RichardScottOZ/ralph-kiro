#!/bin/bash

# Ralph Execute Loop Script for Kiro CLI
# This script runs the Ralph Wiggum execution loop with safety features

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Default settings
MAX_ITERATIONS=50
COMPLETION_WORD="DONE"
PROMPT_FILE="PROMPT.md"
LOG_FILE="ralph-execution.log"

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --max-iterations)
            MAX_ITERATIONS="$2"
            shift 2
            ;;
        --completion-word)
            COMPLETION_WORD="$2"
            shift 2
            ;;
        --prompt-file)
            PROMPT_FILE="$2"
            shift 2
            ;;
        --log-file)
            LOG_FILE="$2"
            shift 2
            ;;
        --help)
            echo "Ralph Execute Loop - Run the autonomous execution phase"
            echo ""
            echo "Usage: ./ralph-execute.sh [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  --max-iterations N    Maximum iterations (default: 50)"
            echo "  --completion-word W   Word that signals completion (default: DONE)"
            echo "  --prompt-file F       Prompt file to use (default: PROMPT.md)"
            echo "  --log-file L          Log file path (default: ralph-execution.log)"
            echo "  --help                Show this help message"
            echo ""
            echo "Example:"
            echo "  ./ralph-execute.sh --max-iterations 30 --completion-word COMPLETE"
            exit 0
            ;;
        *)
            echo -e "${RED}Error: Unknown option $1${NC}"
            echo "Use --help for usage information"
            exit 1
            ;;
    esac
done

# Check if PROMPT.md exists
if [ ! -f "$PROMPT_FILE" ]; then
    echo -e "${RED}Error: $PROMPT_FILE not found${NC}"
    echo "Make sure you've run the plan phase first."
    exit 1
fi

# Check if kiro-cli is installed
if ! command -v kiro-cli &> /dev/null; then
    echo -e "${RED}Error: kiro-cli not found${NC}"
    echo "Please install Kiro CLI: https://kiro.dev/cli/"
    exit 1
fi

# Initialize log file
echo "Ralph Execution Log - $(date)" > "$LOG_FILE"
echo "Max Iterations: $MAX_ITERATIONS" >> "$LOG_FILE"
echo "Completion Word: $COMPLETION_WORD" >> "$LOG_FILE"
echo "Prompt File: $PROMPT_FILE" >> "$LOG_FILE"
echo "----------------------------------------" >> "$LOG_FILE"
echo "" >> "$LOG_FILE"

# Display banner
echo -e "${BLUE}╔════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║      Ralph Wiggum Execution Loop - Kiro       ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${YELLOW}Configuration:${NC}"
echo -e "  Max Iterations: ${GREEN}$MAX_ITERATIONS${NC}"
echo -e "  Completion Word: ${GREEN}$COMPLETION_WORD${NC}"
echo -e "  Prompt File: ${GREEN}$PROMPT_FILE${NC}"
echo -e "  Log File: ${GREEN}$LOG_FILE${NC}"
echo ""
echo -e "${YELLOW}Press Ctrl+C to stop the loop at any time${NC}"
echo ""

# Confirmation
read -p "Ready to start execution? (y/n) " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${YELLOW}Execution cancelled${NC}"
    exit 0
fi

# Main execution loop
iteration=0
start_time=$(date +%s)

echo -e "${GREEN}Starting execution loop...${NC}"
echo ""

while [ $iteration -lt $MAX_ITERATIONS ]; do
    iteration=$((iteration + 1))
    iteration_start=$(date +%s)
    
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}Iteration $iteration/$MAX_ITERATIONS${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    
    # Log iteration start
    echo "=== Iteration $iteration - $(date) ===" >> "$LOG_FILE"
    
    # Execute kiro-cli with the prompt
    output=$(cat "$PROMPT_FILE" | kiro-cli chat --no-interactive -a 2>&1) || {
        echo -e "${RED}Error: kiro-cli command failed${NC}"
        echo "$output"
        echo "ERROR: kiro-cli failed at iteration $iteration" >> "$LOG_FILE"
        echo "$output" >> "$LOG_FILE"
        exit 1
    }
    
    # Display output
    echo "$output"
    
    # Log output
    echo "$output" >> "$LOG_FILE"
    echo "" >> "$LOG_FILE"
    
    # Check for completion
    if echo "$output" | grep -q "$COMPLETION_WORD"; then
        iteration_end=$(date +%s)
        iteration_time=$((iteration_end - iteration_start))
        total_time=$((iteration_end - start_time))
        
        echo ""
        echo -e "${GREEN}╔════════════════════════════════════════════════╗${NC}"
        echo -e "${GREEN}║           TASK COMPLETED! 🎉                   ║${NC}"
        echo -e "${GREEN}╚════════════════════════════════════════════════╝${NC}"
        echo ""
        echo -e "${YELLOW}Summary:${NC}"
        echo -e "  Completed at iteration: ${GREEN}$iteration${NC}"
        echo -e "  Total iterations: ${GREEN}$iteration${NC}"
        echo -e "  Total time: ${GREEN}$((total_time / 60))m $((total_time % 60))s${NC}"
        echo -e "  Log file: ${GREEN}$LOG_FILE${NC}"
        echo ""
        
        # Log completion
        echo "=== COMPLETED at iteration $iteration ===" >> "$LOG_FILE"
        echo "Total time: $total_time seconds" >> "$LOG_FILE"
        
        exit 0
    fi
    
    # Check if we're stuck (same error repeated)
    if echo "$output" | grep -q "STUCK"; then
        echo ""
        echo -e "${RED}╔════════════════════════════════════════════════╗${NC}"
        echo -e "${RED}║              EXECUTION STUCK                   ║${NC}"
        echo -e "${RED}╚════════════════════════════════════════════════╝${NC}"
        echo ""
        echo -e "${YELLOW}The agent reported being stuck. Review the output above.${NC}"
        echo -e "${YELLOW}Consider:${NC}"
        echo -e "  1. Adding more specific guardrails to PROMPT.md"
        echo -e "  2. Breaking down the current task in TODO.md"
        echo -e "  3. Fixing the issue manually and resuming"
        echo ""
        
        echo "=== STUCK at iteration $iteration ===" >> "$LOG_FILE"
        exit 1
    fi
    
    # Calculate iteration time
    iteration_end=$(date +%s)
    iteration_time=$((iteration_end - iteration_start))
    echo -e "${YELLOW}Iteration time: ${iteration_time}s${NC}"
    echo ""
    
    # Small delay to avoid rate limiting
    sleep 2
done

# Max iterations reached
total_time=$(($(date +%s) - start_time))

echo ""
echo -e "${YELLOW}╔════════════════════════════════════════════════╗${NC}"
echo -e "${YELLOW}║     MAX ITERATIONS REACHED                     ║${NC}"
echo -e "${YELLOW}╚════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${YELLOW}Summary:${NC}"
echo -e "  Iterations completed: ${GREEN}$MAX_ITERATIONS${NC}"
echo -e "  Total time: ${GREEN}$((total_time / 60))m $((total_time % 60))s${NC}"
echo -e "  Log file: ${GREEN}$LOG_FILE${NC}"
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo -e "  1. Review TODO.md to see progress"
echo -e "  2. Check git log to see what was completed"
echo -e "  3. Adjust PROMPT.md if needed"
echo -e "  4. Run again with: ./ralph-execute.sh"
echo ""

echo "=== MAX ITERATIONS REACHED ===" >> "$LOG_FILE"
echo "Total time: $total_time seconds" >> "$LOG_FILE"

exit 1
