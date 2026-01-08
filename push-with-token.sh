#!/bin/bash
# Push script with token authentication
# Usage: ./push-with-token.sh YOUR_GITHUB_TOKEN

if [ -z "$1" ]; then
    echo "Usage: $0 <github_token>"
    echo "Get your token from: https://github.com/settings/tokens"
    echo "Grant 'repo' scope for the token"
    exit 1
fi

TOKEN=$1
USERNAME=$(git config user.name || echo "your_username")

echo "Pushing to GitHub with token authentication..."
git push https://$USERNAME:$TOKEN@github.com/lawrobar90/ace-box-ext-hot-partner-powerup-bizobs.git main

echo "Push completed!"