#!/bin/bash

# Script to update the cv JSON file from the markdown cv
# Author: Yuan Chen

# Set the base directory to the repository root
BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Define file paths
cv_MARKDOWN="$BASE_DIR/_pages/cv.md"
cv_JSON="$BASE_DIR/_data/cv.json"
CONFIG_FILE="$BASE_DIR/_config.yml"

# Check if the Python script exists
PYTHON_SCRIPT="$BASE_DIR/scripts/cv_markdown_to_json.py"
if [ ! -f "$PYTHON_SCRIPT" ]; then
  echo "Error: Python script not found at $PYTHON_SCRIPT"
  exit 1
fi

# Check if the markdown cv exists
if [ ! -f "$cv_MARKDOWN" ]; then
  echo "Error: Markdown cv not found at $cv_MARKDOWN"
  exit 1
fi

# Run the Python script to convert markdown to JSON
echo "Converting markdown cv to JSON..."
python3 "$PYTHON_SCRIPT" --input "$cv_MARKDOWN" --output "$cv_JSON" --config "$CONFIG_FILE"

# Check if the conversion was successful
if [ $? -eq 0 ]; then
  echo "Successfully updated cv JSON file at $cv_JSON"
  
  # Optional: Build the Jekyll site to see the changes
  echo "Would you like to build the Jekyll site to see the changes? (y/n)"
  read -r answer
  if [[ "$answer" =~ ^[Yy]$ ]]; then
    echo "Building Jekyll site..."
    cd "$BASE_DIR" && bundle exec jekyll serve
  fi
else
  echo "Error: Failed to update cv JSON file"
  exit 1
fi

exit 0
