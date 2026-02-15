# Publishing Docker Images

This project automatically publishes Docker images to GitHub Container Registry (GHCR) when tags are created.

## Published Images

Images are available at:
```
ghcr.io/zeddius1983/copilot-cli:latest
ghcr.io/zeddius1983/copilot-cli:v1.0.0
ghcr.io/zeddius1983/copilot-cli:1.0
ghcr.io/zeddius1983/copilot-cli:1
```

## How It Works

1. **Create a tag**: `git tag v1.0.0 && git push origin v1.0.0`
2. **GitHub Actions** automatically builds and publishes the image
3. **Multiple tags** are created:
   - `latest` (for default branch tags)
   - `v1.0.0` (full version)
   - `1.0` (minor version)
   - `1` (major version)

## Supported Platforms

Images are built for:
- `linux/amd64` (x86_64)
- `linux/arm64` (ARM 64-bit)

## Creating a Release

To publish a new version:

```bash
# Make sure you're on main branch
git checkout main
git pull

# Create and push a tag
git tag v1.0.0
git push origin v1.0.0
```

The GitHub Action will automatically:
1. Build the Docker image for multiple platforms
2. Push to GitHub Container Registry
3. Tag with version numbers and `latest`

## Manual Build

To build locally:

```bash
docker build -t ghcr.io/zeddius1983/copilot-cli:latest .
```

For multi-platform:

```bash
docker buildx build --platform linux/amd64,linux/arm64 -t ghcr.io/zeddius1983/copilot-cli:latest .
```
