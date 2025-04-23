#!/bin/bash

# === SETTINGS ===
GITHUB_USER="Khiroksy"
REPO_NAME="KhiroksyUI"
BRANCH="master"

# === GENERATE LINKS ===
echo "Generating raw GitHub file links..."
> generated_links.txt

git ls-files | while read -r file; do
  echo "https://raw.githubusercontent.com/$GITHUB_USER/$REPO_NAME/$BRANCH/$file" >> generated_links.txt
done

echo "✅ Done. Output saved to generated_links.txt"