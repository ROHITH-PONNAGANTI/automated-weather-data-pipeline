#!/bin/bash
set -e

PROJECT_DIR="$(cd "$(dirname "$0")" && pwd)"
VENV="$PROJECT_DIR/venv/bin/activate"

cd "$PROJECT_DIR"

if [ ! -f "$VENV" ]; then
    echo "Virtual environment not found: $VENV"
    exit 1
fi

source "$VENV"
python3 "$PROJECT_DIR/main.py"
