# Sync Workflow Example

## Complete Workflow from Development to Docker Hub

### 1. Development Phase (Private Repository)

```bash
# Work on main branch as usual
git checkout main
vim Dockerfile  # Make improvements to container
vim .github/README.md  # Update documentation

# Commit changes to private repository
git add -A
git commit -m "Update Node.js to v20.18, improve security hardening"
git push private main
```

### 2. Sync to Public Repository

```bash
# Run the sync script when ready to publish
.warp/sync-public.sh
```

**Script Output Example:**
```
[SYNC] Current branch: main
[SYNC] Checking out public branch...
[SYNC] Clearing public branch...
[SYNC] Syncing public files from main...
  Copying: Dockerfile
  Copying: .github/README.md
  Copying: .github/CHANGELOG.md  
  Copying: .github/LICENSE
  Copying: .github/workflows
[SYNC] Keep .github directory structure for both repositories
[SYNC] Adding files to public...
[SYNC] Pushing public as sync/public-20240930-014523 to public...
[SUCCESS] Public sync branch created: sync/public-20240930-014523
  🔗 Create PR: sync/public-20240930-014523 → main in public repository
[SYNC] Pushing full project to private...
[SUCCESS] Dual remote sync completed!

[SYNC] Repository Status:
  Private repo (private): Full project on main branch
  Public repo (public):   Sync branch sync/public-20240930-014523 ready for PR
  Local branches: main (private), public (public sync)

[SYNC] Next Steps:
  1. Create PR: sync/public-20240930-014523 → main in public repository
  2. Review and merge the PR to update public main branch
  3. GitHub Actions will automatically build and push to Docker Hub
```

### 3. Create Pull Request

Use your established PR workflow:

```bash
# Since the sync branch is now pushed, you can create a PR
# "Create PR from sync/public-20240930-014523 to main"
```

**Example PR that would be created:**

**Title:** Sync public files from main - 2024-09-30 01:45:23

**Description:** 
```markdown
## Changes Synced from Private Repository

### Container Updates
- **Node.js Version**: Updated to v20.18 for latest security patches
- **Security Hardening**: Enhanced container security configuration
- **Performance**: Optimized layer caching for faster builds

### Documentation Updates
- **README.md**: Updated installation instructions and examples
- **CHANGELOG.md**: Added v1.1.0 release notes
- **Workflow**: Refined Docker Hub automation configuration

### Files Synced
- `Dockerfile` - Container definition with Node.js v20.18
- `.github/README.md` - Updated documentation
- `.github/CHANGELOG.md` - Version history
- `.github/LICENSE` - MIT license
- `.github/workflows/docker-build-push.yml` - CI/CD automation

### Impact
This sync brings the public repository up-to-date with the latest container improvements and documentation. Upon merge, GitHub Actions will automatically build and publish the updated image to Docker Hub.

### Testing
- [x] Container builds successfully locally
- [x] All documentation links verified
- [x] GitHub Actions workflow validated
```

### 4. Merge and Automatic Deployment

Once the PR is merged:

1. **GitHub Actions Triggered**: The merge to main triggers the workflow
2. **Multi-Platform Build**: Container built for AMD64 and ARM64
3. **Docker Hub Push**: Images pushed with appropriate tags:
   - `latest` (from main branch merge)
   - `weekly-YYYYMMDD` (if it's a scheduled build)
4. **Security Scan**: Docker Scout runs vulnerability scan
5. **Description Update**: README.md content pushed to Docker Hub description

### 5. Verification

```bash
# Pull the updated image from Docker Hub
docker pull your-dockerhub-username/node-devcontainer:latest

# Verify the changes
docker run -it --rm your-dockerhub-username/node-devcontainer:latest node --version
# Should show: v20.18.0
```

## Benefits of This Workflow

### 🔍 **Review Process**
- All public changes go through PR review
- Diff shows exactly what's being published
- Opportunity to catch issues before public release

### 🏷️ **Clean Branch Management**
- No spam commits on public main branch
- Clear separation between sync commits and development
- Timestamped sync branches for easy tracking

### 🚀 **Automated Deployment**
- PR merge automatically triggers Docker Hub build
- No manual intervention needed for container updates
- Multi-platform builds ensure broad compatibility

### 📊 **Audit Trail**
- Every public release has a corresponding PR
- Easy to track what was published when
- Clear connection between private development and public releases

## Troubleshooting

### Sync Branch Already Exists
If you run the sync script multiple times quickly, branch names might conflict:
```bash
# The script uses timestamps to avoid this, but if needed:
git push public --delete sync/public-20240930-014523  # Delete remote branch
git branch -D sync/public-20240930-014523             # Delete local branch (if exists)
```

### PR Creation Fails
Ensure the sync branch exists on the public remote:
```bash
git ls-remote public | grep sync/public
# Should show the sync branch
```

### Docker Hub Build Fails
Check the GitHub Actions tab in the public repository for detailed error logs.

This workflow provides a robust, reviewable, and automated path from development to production Docker images!