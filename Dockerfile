FROM node:24-slim

# Tools the install script expects / commonly needed
RUN apt-get update \
  && apt-get install -y --no-install-recommends bash wget ca-certificates git openssh-server \
  && rm -rf /var/lib/apt/lists/*

# Create necessary directories
RUN mkdir -p /root/.copilot /root/.ssh /usr/local/bin

# Copy entrypoint script
COPY scripts/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Expose SSH port (optional, for remote access)
EXPOSE 22

# Set entrypoint
ENTRYPOINT ["/entrypoint.sh"]
CMD ["/bin/bash"]
