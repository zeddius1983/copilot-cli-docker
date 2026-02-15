# GitHub Copilot CLI Docker for Unraid

A Docker container packaging GitHub Copilot CLI with persistent authentication for Unraid OS.

## Features

- 🚀 GitHub Copilot CLI pre-installed
- 🔐 Persistent authentication via Docker volumes
- 🔄 Automatic configuration on startup
- 🖥️ Optional SSH access for remote usage
- 📦 Easy deployment with docker-compose

## Quick Start

### 1. Build the Image

```bash
docker-compose build
```

### 2. Start the Container

```bash
docker-compose up -d
```

### 3. Access the Container

```bash
docker exec -it copilot-cli /bin/bash
```

### 4. Authenticate (First Time Only)

Once inside the container, authenticate with GitHub:

```bash
# Authenticate GitHub CLI
gh auth login
```

Follow the prompts:
1. Select **GitHub.com**
2. Choose **HTTPS** protocol
3. **Yes** to authenticate Git with GitHub credentials
4. **Login with a web browser**
5. Copy the one-time code shown
6. Open the URL in your browser and paste the code

Then install GitHub Copilot extension:

```bash
# Install Copilot CLI extension
gh extension install github/gh-copilot
```

### 5. Use Copilot CLI

```bash
# Get command suggestions
gh copilot suggest "install docker"

# Explain a command
gh copilot explain "tar -xzf file.tar.gz"
```

## Unraid Installation

### Using Docker Compose

1. **Install Compose Manager** plugin from Community Applications
2. **Create a new stack** in Compose Manager
3. **Copy the contents** of `docker-compose.yml`
4. **Deploy the stack**

### Using Unraid Docker Template

1. Go to **Docker** tab in Unraid
2. Click **Add Container**
3. Use these settings:

```
Name: copilot-cli
Repository: copilot-cli:latest
Console shell command: /bin/bash

Volume Mappings:
  - /mnt/user/appdata/copilot-cli/gh -> /root/.config/gh
  - /mnt/user/appdata/copilot-cli/copilot -> /root/.copilot

Extra Parameters: -it
```

4. **Build the image** first on your Unraid system:
```bash
cd /mnt/user/appdata/copilot-cli-docker
docker build -t copilot-cli:latest .
```

## Configuration Options

### Environment Variables

- `ENABLE_SSH`: Set to `true` to enable SSH server (default: `false`)
- `SSH_PASSWORD`: Root password for SSH access (only if ENABLE_SSH=true)

### SSH Access (Optional)

To enable remote SSH access:

1. Edit `docker-compose.yml`:
```yaml
environment:
  - ENABLE_SSH=true
  - SSH_PASSWORD=yourpassword
ports:
  - "2222:22"
```

2. Restart the container:
```bash
docker-compose down
docker-compose up -d
```

3. Connect via SSH:
```bash
ssh root@your-unraid-ip -p 2222
```

## Volume Persistence

Authentication is stored in Docker volumes:
- `gh-config`: GitHub CLI credentials (`/root/.config/gh`)
- `copilot-config`: Copilot CLI configuration (`/root/.copilot`)

These volumes persist across container restarts, so you only need to authenticate once.

## Troubleshooting

### Authentication Lost

If authentication is lost, re-run:
```bash
gh auth login
gh extension install github/gh-copilot
```

### Permission Issues

Ensure volumes have correct permissions:
```bash
docker exec -it copilot-cli chown -R root:root /root/.config/gh /root/.copilot
```

### Container Won't Start

Check logs:
```bash
docker-compose logs copilot-cli
```

## Advanced Usage

### Custom GitHub Token

You can use a GitHub Personal Access Token:

```bash
echo "your-token" | gh auth login --with-token
```

### Running Commands Directly

```bash
docker exec -it copilot-cli gh copilot suggest "your question"
```

## License

This project packages open-source tools. Please refer to individual tool licenses:
- [GitHub CLI](https://github.com/cli/cli)
- [GitHub Copilot CLI](https://githubnext.com/projects/copilot-cli/)

## Support

For issues related to:
- **Docker container**: Open an issue in this repository
- **GitHub CLI**: Visit [cli/cli](https://github.com/cli/cli)
- **Copilot CLI**: Visit [GitHub Next](https://githubnext.com/)
