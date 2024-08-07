#!/bin/bash

# Define the directory where your repositories are located
BASE_DIR="/home/User" # Replace this with the actual path to your repositories

AUTHOR="example@example.com" # Replace this with your Git email or name

# Repository lists
REPOS_GITLAB=("repo1" "repo2")
REPOS_GITHUB=("repo3" "repo4")

generate_logs() {
  local BASE_DIR=$1
  shift
  local REPOS=("$@")
  
  cd "$BASE_DIR" || { echo "Failed to navigate to $BASE_DIR"; exit 1; }
  
  for REPO in "${REPOS[@]}"
  do
    echo "Processing repository: $REPO"
    if [ -d "$REPO" ]; then
      cd "$REPO" || { echo "Failed to navigate to $REPO"; exit 1; }
      echo "Generating commit log for $REPO"
      git log --author="$AUTHOR" > "../${REPO}-log.txt"
      cd .. || { echo "Failed to navigate back from $REPO"; exit 1; }
      echo "Commit log for $REPO has been saved to ${REPO}-log.txt"
    else
      echo "Directory $REPO does not exist."
    fi
  done
}

# Generate logs for GitHub repositories
echo "Generating logs for GitHub repositories"
generate_logs "$BASE_DIR" "${REPOS_GITHUB[@]}"

# Generate logs for GitLab repositories
echo "Generating logs for GitLab repositories"
generate_logs "$BASE_DIR" "${REPOS_GITLAB[@]}"

# Verify that log files are present
echo "Checking for generated log files..."
ls -l "$BASE_DIR"/*-log.txt

# Combine all logs into a single file
echo "Combining all commit logs into a single file: combined-logs.txt"
cat "$BASE_DIR"/*-log.txt > git_logs.txt

# Check if the combined file has content
echo "Checking content of git-logs.txt"
if [ -s git_logs.txt ]; then
  cat git_logs.txt
else
  echo "git-logs.txt is empty."
fi

# Convert the combined log file to PDF
echo "Converting combined-logs.txt to combined-logs.pdf using pandoc"
pandoc git_logs.txt -o git_logs.pdf --pdf-engine=wkhtmltopdf
echo "Conversion complete. Commit logs have been saved to combined-logs.pdf"

