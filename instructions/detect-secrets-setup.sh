#!/bin/bash

# Install pre-commit 
pip install pre-commit


# Define the pre-commit config
PRE_COMMIT_CONFIG=".pre-commit-config.yaml"
DETECT_SECRETS_HOOK="repos:
- repo: https://github.com/Yelp/detect-secrets
  rev: v1.0.3  # Use the latest stable version
  hooks:
    - id: detect-secrets
      args: ['--baseline', '.secrets.baseline']"

# Create the pre-commit config file
echo "$DETECT_SECRETS_HOOK" > $PRE_COMMIT_CONFIG

# Generate the initial detect-secrets baseline with exclusions
detect-secrets scan --exclude-files '.*\.py$' --exclude-files '.*/lib/.*' --exclude-files '\.secrets\.baseline' > .secrets.baseline

# Install the pre-commit hooks
pre-commit install

# Install detect-secrets 
pip install detect-secrets

# Generate the initial detect-secrets baseline
detect-secrets scan > .secrets.baseline

# Add the baseline to the repository
git add .secrets.baseline
git commit -m "Add detect-secrets baseline"
