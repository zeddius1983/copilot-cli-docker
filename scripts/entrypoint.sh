#!/bin/bash
set -e

echo "================================================"
echo "  GitHub Copilot CLI Docker Container"
echo "================================================"

# Check if Copilot CLI is available
if copilot --version &>/dev/null; then
    echo "✓ GitHub Copilot CLI is installed"
    copilot --version
    
    # Check if authenticated (will prompt on first run)
    echo ""
    echo "On first use, you'll be prompted to authenticate."
    echo "Use the /login command when prompted."
else
    echo "⚠ GitHub Copilot CLI not found"
fi

echo ""
echo "================================================"
echo "  Available commands:"
echo "    copilot              - Start Copilot session"
echo ""
echo "  Authentication:"
echo "    Use /login inside the CLI session"
echo "    Or set GH_TOKEN or GITHUB_TOKEN env var"
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
