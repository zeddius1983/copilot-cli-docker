FROM node:20-alpine

# Install required packages
RUN apk add --no-cache \
    bash \
    git \
    openssh-server \
    curl \
    && rm -rf /var/cache/apk/*

# Install GitHub CLI
RUN apk add github-cli --repository=http://dl-cdn.alpinelinux.org/alpine/edge/community

# Install GitHub Copilot CLI globally
RUN npm install -g @githubnext/github-copilot-cli

# Create necessary directories
RUN mkdir -p /root/.config/gh /root/.copilot /root/.ssh

# Copy entrypoint script
COPY scripts/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Expose SSH port (optional, for remote access)
EXPOSE 22

# Set entrypoint
ENTRYPOINT ["/entrypoint.sh"]
CMD ["/bin/bash"]
