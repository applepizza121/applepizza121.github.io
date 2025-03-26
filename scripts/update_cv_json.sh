#!/bin/bash

# Script to update the Material JSON file from the markdown Material
# Author: Yuan Chen

# Set the base directory to the repository root
BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Define file paths
Material_MARKDOWN="$BASE_DIR/_pages/Material.md"
Material_JSON="$BASE_DIR/_data/Material.json"
CONFIG_FILE="$BASE_DIR/_config.yml"

# Check if the Python script exists
PYTHON_SCRIPT="$BASE_DIR/scripts/Material_markdown_to_json.py"
if [ ! -f "$PYTHON_SCRIPT" ]; then
  echo "Error: Python script not found at $PYTHON_SCRIPT"
  exit 1
fi

# Check if the markdown Material exists
if [ ! -f "$Material_MARKDOWN" ]; then
  echo "Error: Markdown Material not found at $Material_MARKDOWN"
  exit 1
fi

# Run the Python script to convert markdown to JSON
echo "Converting markdown Material to JSON..."
python3 "$PYTHON_SCRIPT" --input "$Material_MARKDOWN" --output "$Material_JSON" --config "$CONFIG_FILE"

# Check if the conversion was successful
if [ $? -eq 0 ]; then
  echo "Successfully updated Material JSON file at $Material_JSON"
  
  # Optional: Build the Jekyll site to see the changes
  echo "Would you like to build the Jekyll site to see the changes? (y/n)"
  read -r answer
  if [[ "$answer" =~ ^[Yy]$ ]]; then
    echo "Building Jekyll site..."
    cd "$BASE_DIR" && bundle exec jekyll serve
  fi
else
  echo "Error: Failed to update Material JSON file"
  exit 1
fi

exit 0
