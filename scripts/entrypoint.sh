#!/bin/bash
set -e

echo "================================================"
echo "  GitHub Copilot CLI Docker Container"
echo "================================================"

# Set PREFIX for install script
export PREFIX=/usr/local

# Check if Copilot CLI needs to be installed or updated
INSTALLED_VERSION=""
if command -v copilot &>/dev/null; then
    INSTALLED_VERSION=$(copilot --version 2>/dev/null | grep -oP 'v\d+\.\d+\.\d+' || echo "")
fi

REQUESTED_VERSION="${COPILOT_VERSION:-latest}"

# Install or update Copilot CLI if needed
if [ -z "$INSTALLED_VERSION" ]; then
    echo "Installing GitHub Copilot CLI..."
    if [ "$REQUESTED_VERSION" != "latest" ] && [ -n "$REQUESTED_VERSION" ]; then
        wget -qO- https://gh.io/copilot-install | VERSION="$REQUESTED_VERSION" bash
    else
        wget -qO- https://gh.io/copilot-install | bash
    fi
    echo "✓ GitHub Copilot CLI installed"
elif [ "$REQUESTED_VERSION" != "latest" ] && [ "$REQUESTED_VERSION" != "$INSTALLED_VERSION" ]; then
    echo "Updating GitHub Copilot CLI from $INSTALLED_VERSION to $REQUESTED_VERSION..."
    wget -qO- https://gh.io/copilot-install | VERSION="$REQUESTED_VERSION" bash
    echo "✓ GitHub Copilot CLI updated"
else
    echo "✓ GitHub Copilot CLI is installed"
fi

# Display version
if copilot --version &>/dev/null; then
    copilot --version
    
    # Check if GH_TOKEN is set
    if [ -n "$GH_TOKEN" ] || [ -n "$GITHUB_TOKEN" ]; then
        echo "✓ GitHub token environment variable is set"
    else
        echo ""
        echo "On first use, you'll be prompted to authenticate."
        echo "Use the /login command when prompted."
    fi
else
    echo "⚠ GitHub Copilot CLI installation failed"
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
