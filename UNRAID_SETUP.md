# Unraid Installation Guide

## Method 1: Using the XML Template (Recommended)

### Step 1: Copy Files to Unraid

1. Copy the entire `copilot-cli-docker` folder to your Unraid server:
   ```bash
   scp -r copilot-cli-docker root@your-unraid-ip:/mnt/user/appdata/
   ```

### Step 2: Build the Docker Image

1. SSH into your Unraid server
2. Build the image:
   ```bash
   cd /mnt/user/appdata/copilot-cli-docker
   docker build -t copilot-cli:latest .
   ```

### Step 3: Add Template to Unraid

1. Go to **Docker** tab in Unraid web interface
2. Click **Add Container**
3. Click **Toggle to Advanced View** (top right)
4. At the bottom, find **Template repositories**
5. Click **Template** dropdown and select **XML Template**
6. Paste the contents of `unraid-template.xml`
7. Click **Apply**

### Step 4: Configure and Start

1. The template will auto-populate all settings
2. Review the configuration:
   - **GitHub CLI Config**: `/mnt/user/appdata/copilot-cli/gh`
   - **Copilot CLI Config**: `/mnt/user/appdata/copilot-cli/copilot`
   - **Extra Parameters**: Should show `-it`
3. Click **Apply** to create and start the container

### Step 5: First-Time Authentication

1. Click the container's **Console** button (or icon)
2. Authenticate GitHub CLI:
   ```bash
   gh auth login
   ```
   - Select: GitHub.com
   - Select: HTTPS
   - Select: Yes (authenticate Git)
   - Select: Login with a web browser
   - Copy the code shown
   - Open the URL in your browser
   - Paste the code and authorize

3. Install GitHub Copilot extension:
   ```bash
   gh extension install github/gh-copilot
   ```

4. Test it:
   ```bash
   gh copilot suggest "list docker containers"
   ```

## Method 2: Manual Docker Template Setup

If you prefer not to use the XML template:

1. **Docker** tab → **Add Container**
2. Fill in manually:

   **Basic Settings:**
   - Name: `copilot-cli`
   - Repository: `copilot-cli:latest`
   - Console shell command: `/bin/bash`

   **Path Mappings:**
   - Container Path: `/root/.config/gh` → Host Path: `/mnt/user/appdata/copilot-cli/gh`
   - Container Path: `/root/.copilot` → Host Path: `/mnt/user/appdata/copilot-cli/copilot`

   **Extra Parameters:**
   - Add: `-it`

3. Click **Apply**

## Method 3: Docker Compose with Compose Manager

1. Install **Compose Manager** plugin from Community Applications
2. Create a new stack named `copilot-cli`
3. Paste the contents of `docker-compose.yml`
4. Make sure the image is built first:
   ```bash
   cd /mnt/user/appdata/copilot-cli-docker
   docker build -t copilot-cli:latest .
   ```
5. Click **Compose Up**

## Accessing the Container

### From Unraid Web UI
- Click the container icon → **Console**

### From SSH/Terminal
```bash
docker exec -it copilot-cli /bin/bash
```

### Via SSH (if enabled)
```bash
ssh root@your-unraid-ip -p 2222
```

## Enabling SSH Access

To access Copilot CLI remotely via SSH:

1. Edit the container settings
2. Set environment variable:
   - **Variable**: `ENABLE_SSH` → **Value**: `true`
   - **Variable**: `SSH_PASSWORD` → **Value**: `yourpassword`
3. Add port mapping:
   - **Container Port**: `22` → **Host Port**: `2222`
4. Apply changes and restart container

## Troubleshooting

### Container Won't Start
- Check logs: Docker tab → container → **Logs**
- Ensure image was built: `docker images | grep copilot-cli`

### Authentication Failed
- Re-run authentication inside container console:
  ```bash
  gh auth login
  gh extension install github/gh-copilot
  ```

### Can't Access Console
- Ensure Extra Parameters includes `-it`
- Try restarting the container

### Volumes Not Persisting
- Check permissions:
  ```bash
  ls -la /mnt/user/appdata/copilot-cli/
  ```
- Should show `gh/` and `copilot/` directories

## Updating

To update the container:

1. Make changes to Dockerfile or scripts
2. Rebuild the image:
   ```bash
   cd /mnt/user/appdata/copilot-cli-docker
   docker build -t copilot-cli:latest .
   ```
3. Restart the container from Docker tab

## Backup

Your authentication is stored in:
- `/mnt/user/appdata/copilot-cli/gh/`
- `/mnt/user/appdata/copilot-cli/copilot/`

Include these in your Unraid backup strategy.
