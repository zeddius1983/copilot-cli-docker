# GitHub Copilot CLI Docker for Unraid

A Docker container packaging GitHub Copilot CLI with persistent authentication for Unraid OS.

## Features

- 🚀 **GitHub Copilot CLI** installed via official script at runtime
- 🔐 **Persistent authentication** via Docker volumes
- 🔄 **Automatic configuration** on startup
- 🖥️ **Optional SSH access** for remote usage
- 📦 **Easy deployment** with docker-compose
- 🔢 **Version pinning** support via COPILOT_VERSION environment variable
- 🔄 **No rebuild needed** - change version and restart container

## Quick Start

### 1. Build the Image

```bash
docker-compose build
```

The Copilot CLI will be installed at container startup, not during build. This allows you to change versions without rebuilding!

### 2. Start the Container

```bash
docker-compose up -d
```

### 3. Access the Container

```bash
docker exec -it copilot-cli /bin/bash
```

### 4. Authenticate (First Time Only)

Once inside the container, run Copilot CLI:

```bash
copilot
```

On first launch, you'll be prompted to authenticate. Enter:
```
/login
```

Follow the on-screen instructions:
1. A one-time code will be displayed
2. Open the provided URL in your browser
3. Enter the code and authorize

**Alternative: Using a Personal Access Token**

You can authenticate using a fine-grained PAT:
1. Create a token at https://github.com/settings/personal-access-tokens/new
2. Enable **Copilot Requests** permission
3. Set as environment variable in docker-compose.yml:
   ```yaml
   environment:
     - GH_TOKEN=your_token_here
   ```
4. Restart the container - Copilot will automatically use the token

### 5. Use Copilot CLI

```bash
# Interactive session
copilot

# Direct question
copilot "how do I list docker containers"
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
  - /mnt/user/appdata/copilot-cli/copilot -> /root/.copilot

Environment Variables:
  - COPILOT_VERSION=latest (or v0.0.410 for specific version)
  - GH_TOKEN=your_token_here (optional, for automatic auth)

Extra Parameters: -it
```

4. **Build the image** first on your Unraid system:
```bash
cd /mnt/user/appdata/copilot-cli-docker
docker build -t copilot-cli:latest .
```

**Note:** No need to rebuild when changing versions - just update COPILOT_VERSION and restart!

## Configuration Options

### Environment Variables

- `COPILOT_VERSION`: Copilot CLI version to install (e.g., `v0.0.410` or `latest`). Changes take effect on container restart.
- `GH_TOKEN` or `GITHUB_TOKEN`: GitHub personal access token for authentication (optional)
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

Authentication is stored in Docker volume:
- `copilot-config`: Copilot CLI configuration (`/root/.copilot`)

If using GH_TOKEN environment variable, authentication happens automatically each time.

These volumes persist across container restarts, so you only need to authenticate once (unless using token-based auth).

## Troubleshooting

### Authentication Lost

If authentication is lost, re-run inside the CLI:
```bash
copilot
# Then use: /login
```

Or set `GH_TOKEN` environment variable in container settings.

### Permission Issues

Ensure volumes have correct permissions:
```bash
docker exec -it copilot-cli chown -R root:root /root/.copilot
```

### Container Won't Start

Check logs:
```bash
docker-compose logs copilot-cli
```

### Version Not Installing

If a specific version isn't installing, check:
1. The version exists: https://github.com/github/copilot-cli/releases
2. Container logs for errors
3. Try setting to `latest` first

## Advanced Usage

### Changing Versions

To change Copilot CLI version:
1. Edit `COPILOT_VERSION` in docker-compose.yml or Unraid template
2. Restart the container
3. The entrypoint will automatically install/update to the new version

### Custom GitHub Token

You can use a GitHub Personal Access Token:

Set in docker-compose.yml:
```yaml
environment:
  - GH_TOKEN=your_token_here
```

Or as environment variable when running:
```bash
docker run -e GH_TOKEN=your_token copilot-cli
```

### Running Commands Directly

```bash
docker exec -it copilot-cli copilot "your question"
```

## License

This project packages open-source tools. Please refer to individual tool licenses:
- [GitHub Copilot CLI](https://docs.github.com/en/copilot/using-github-copilot/using-github-copilot-in-the-cli)

## Support

For issues related to:
- **Docker container**: Open an issue in this repository
- **GitHub CLI**: Visit [cli/cli](https://github.com/cli/cli)
- **Copilot CLI**: Visit [GitHub Next](https://githubnext.com/)
