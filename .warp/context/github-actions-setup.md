# GitHub Actions Docker Hub Integration

## Overview
The `.github/workflows/docker-build-push.yml` workflow automates building and publishing Docker images to Docker Hub whenever changes are made to the public repository.

## Workflow Features

### Triggers
- **Push to main**: Builds and pushes latest image
- **Tagged releases**: Creates versioned images (v1.0.0, etc.)
- **Pull requests**: Builds but doesn't push (testing)
- **Weekly schedule**: Rebuilds every Monday at 2 AM UTC for security updates

### Multi-Platform Support
- Builds for both `linux/amd64` and `linux/arm64` architectures
- Uses Docker Buildx for cross-platform compilation

### Image Tagging Strategy
- `latest`: Always points to the main branch
- `vX.Y.Z`: Semantic version tags from Git tags
- `vX.Y`: Minor version tags
- `vX`: Major version tags
- `weekly-YYYYMMDD`: Weekly security update builds

### Security Features
- Docker Scout vulnerability scanning
- Fails build on critical/high severity vulnerabilities
- Uses GitHub Actions secrets for credentials

## Required Secrets

Configure these in the public repository's GitHub Settings > Secrets:

### Docker Hub Authentication
```
DOCKERHUB_USERNAME: your-dockerhub-username
DOCKERHUB_TOKEN: your-dockerhub-access-token
```

### How to Create Docker Hub Token
1. Log in to Docker Hub
2. Go to Account Settings > Security
3. Create new Access Token with Read/Write permissions
4. Copy the token (save it, you won't see it again)
5. Add to GitHub repository secrets

## Workflow Steps

### 1. Build Process
- Checks out repository code
- Sets up Docker Buildx for multi-platform builds
- Authenticates with Docker Hub (for pushes)
- Extracts metadata for tagging

### 2. Image Building
- Builds Docker image from Dockerfile
- Applies appropriate tags based on trigger
- Pushes to Docker Hub (except for PRs)
- Uses GitHub Actions cache for faster builds

### 3. Post-Build Actions
- Updates Docker Hub repository description from README.md
- Runs security scan with Docker Scout
- Reports vulnerabilities

## Usage Examples

### Manual Trigger
The workflow runs automatically, but you can also:
```bash
# Create a release tag to trigger versioned build
git tag v1.0.0
git push origin v1.0.0
```

### Docker Hub Repository
Images will be available at:
```bash
docker pull your-dockerhub-username/node-devcontainer:latest
docker pull your-dockerhub-username/node-devcontainer:v1.0.0
```

## Customization

### Change Docker Hub Repository Name
Edit the workflow file:
```yaml
env:
  IMAGE_NAME: your-custom-name  # Change this
```

### Add Build Arguments
Modify the build step:
```yaml
build-args: |
  NODE_VERSION=20
  CUSTOM_ARG=value
```

### Different Registry
Replace Docker Hub with GitHub Container Registry:
```yaml
env:
  REGISTRY: ghcr.io
  IMAGE_NAME: ${{ github.repository }}
```

## Monitoring

### Build Status
- Check the Actions tab in your GitHub repository
- Green checkmarks indicate successful builds
- Red X marks show failures with detailed logs

### Docker Hub
- Images appear in your Docker Hub repositories
- Tags are automatically created based on the workflow
- Repository description updates from README.md

### Security Reports
- Vulnerability reports appear in the Actions logs
- Critical/high vulnerabilities will fail the build
- Regular weekly scans catch new vulnerabilities

## Troubleshooting

### Common Issues
1. **Authentication Failure**: Check DOCKERHUB_USERNAME and DOCKERHUB_TOKEN secrets
2. **Build Failures**: Review the Actions logs for specific errors
3. **Tag Issues**: Ensure Git tags follow semantic versioning (vX.Y.Z)

### Debug Steps
1. Check the Actions tab for detailed logs
2. Verify secrets are correctly configured
3. Test Docker build locally: `docker build -t test .`
4. Validate Dockerfile syntax and dependencies

This workflow provides a complete CI/CD pipeline for your Node.js Dev Container, ensuring it's always up-to-date and secure on Docker Hub.