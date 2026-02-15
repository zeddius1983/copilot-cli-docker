FROM node:24-alpine

# Install required packages
RUN apk add --no-cache \
    bash \
    git \
    openssh-server \
    curl \
    wget \
    && rm -rf /var/cache/apk/*

# Install GitHub Copilot CLI via npm (requires Node.js 24+)
RUN npm install -g @github/copilot

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
