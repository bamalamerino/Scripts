#!/bin/bash

# Function to create directories
create_directories() {
    local project_name="$1"
    
    # Create main project directory
    mkdir -p "$project_name"
    
    # Create subdirectories
    mkdir -p "$project_name/RAW"
    mkdir -p "$project_name/SELECTS"
    mkdir -p "$project_name/EDITS"
    mkdir -p "$project_name/FINALS"
    mkdir -p "$project_name/LEGAL/CONTRACTS"
    mkdir -p "$project_name/LEGAL/INVOICES"
    
    echo "Project structure created successfully for: $project_name"
}

# Main script
echo "Photographer Project Setup"
echo "========================="

# Check if a project name was provided as a command-line argument
if [ $# -eq 1 ]; then
    project_name="$1"
else
    # Prompt for project name if not provided as an argument
    read -p "Enter project name: " project_name
fi

# Validate project name
if [ -z "$project_name" ]; then
    echo "Error: Project name cannot be empty."
    exit 1
fi

# Create project structure
create_directories "$project_name"

# Display created structure
echo -e "\nCreated project structure:"
if command -v tree &> /dev/null; then
    tree "$project_name"
else
    find "$project_name" -type d | sed -e "s/[^-][^\/]*\//  |/g" -e "s/|\([^ ]\)/|-\1/"
fi
