#!/bin/bash

# Fetch tags from the remote
git fetch --tags

# Get the latest tag
latest_tag=$(git describe --tags `git rev-list --tags --max-count=1`)

# Extract the version components
IFS='.' read -r -a version_parts <<< "$latest_tag"

# Increment the patch version
version_parts[2]=$((version_parts[2] + 1))

# Create the new version
new_version="${version_parts[0]}.${version_parts[1]}.${version_parts[2]}"

# Tag the new version
git tag $new_version

# Push the tags to the remote
git push origin --tags

# Output the new version
echo "NEW_VERSION=$new_version" >> $GITHUB_ENV
