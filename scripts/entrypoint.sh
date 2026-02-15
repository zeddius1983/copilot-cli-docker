#!/bin/bash
set -e

echo "================================================"
echo "  GitHub Copilot CLI Docker Container"
echo "================================================"

# Check if GitHub CLI is authenticated
if gh auth status &>/dev/null; then
    echo "✓ GitHub CLI is authenticated"
else
    echo "⚠ GitHub CLI is not authenticated"
    echo ""
    echo "Please run the following command to authenticate:"
    echo "  gh auth login"
    echo ""
    echo "Choose the following options:"
    echo "  1. GitHub.com"
    echo "  2. HTTPS"
    echo "  3. Yes (authenticate Git with your GitHub credentials)"
    echo "  4. Login with a web browser"
    echo ""
    echo "After authentication, restart the container or run:"
    echo "  github-copilot-cli auth"
fi

# Check if Copilot CLI is authenticated
if [ -d "/root/.copilot" ] && [ "$(ls -A /root/.copilot)" ]; then
    echo "✓ Copilot CLI configuration found"
else
    echo "⚠ Copilot CLI not configured"
    echo ""
    echo "After authenticating GitHub CLI, run:"
    echo "  github-copilot-cli auth"
fi

echo ""
echo "================================================"
echo "  Available commands:"
echo "    github-copilot-cli    - Start Copilot CLI"
echo "    gh auth login         - Authenticate GitHub"
echo "    github-copilot-cli auth - Authenticate Copilot"
echo "================================================"
echo ""

# Setup SSH if enabled
if [ "$ENABLE_SSH" = "true" ]; then
    echo "Setting up SSH server..."
    
    # Generate host keys if they don't exist
    ssh-keygen -A 2>/dev/null || true
    
    # Set root password if provided
    if [ -n "$SSH_PASSWORD" ]; then
        echo "root:$SSH_PASSWORD" | chpasswd
    fi
    
    # Start SSH daemon
    /usr/sbin/sshd
    echo "✓ SSH server started on port 22"
    echo ""
fi

# Execute the command passed to docker run
exec "$@"
