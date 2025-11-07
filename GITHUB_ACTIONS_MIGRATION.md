# Migrating from Jenkins to GitHub Actions

This guide provides step-by-step instructions to migrate your Java application CI/CD pipeline from Jenkins to GitHub Actions.

## Table of Contents
1. [Prerequisites](#prerequisites)
2. [Understanding the Current Pipeline](#understanding-the-current-pipeline)
3. [Step-by-Step Migration](#step-by-step-migration)
4. [GitHub Actions Workflow Configuration](#github-actions-workflow-configuration)
5. [Setting Up Secrets](#setting-up-secrets)
6. [Testing the Workflow](#testing-the-workflow)
7. [Best Practices](#best-practices)

---

## Prerequisites

Before starting the migration:

- [ ] GitHub repository with appropriate permissions
- [ ] Access to SonarQube server and token
- [ ] Nexus repository credentials
- [ ] Tomcat server credentials
- [ ] Maven settings file (if custom configuration needed)

---

## Understanding the Current Pipeline

Your current Jenkins pipeline performs these stages:

1. **Checkout Code** - Clones repository from GitHub
2. **SonarQube Analysis** - Runs static code analysis
3. **Build Artifact** - Builds WAR file using Maven
4. **Upload to Nexus** - Uploads artifact to Nexus repository
5. **Deploy to Tomcat** - Deploys WAR to Tomcat server

---

## Step-by-Step Migration

### Step 1: Create GitHub Actions Workflow Directory

```bash
mkdir -p .github/workflows
```

### Step 2: Create Workflow File

Create `.github/workflows/ci-cd.yml` (see configuration below)

### Step 3: Set Up GitHub Secrets

Navigate to your repository: **Settings → Secrets and variables → Actions**

Add the following secrets:

| Secret Name | Description | Example Value |
|------------|-------------|---------------|
| `SONAR_TOKEN` | SonarQube authentication token | `sqp_xxxxxxxxxxxxx` |
| `SONAR_HOST_URL` | SonarQube server URL | `http://your-sonar-server:9000` |
| `NEXUS_USERNAME` | Nexus repository username | `admin` |
| `NEXUS_PASSWORD` | Nexus repository password | `your-password` |
| `NEXUS_URL` | Nexus repository URL | `http://3.19.221.46:8081` |
| `TOMCAT_USERNAME` | Tomcat manager username | `deployer` |
| `TOMCAT_PASSWORD` | Tomcat manager password | `your-password` |
| `TOMCAT_URL` | Tomcat manager URL | `http://18.116.203.32:8080` |
| `DEPLOY_SSH_KEY` | SSH private key for deployment server (if needed) | `-----BEGIN RSA PRIVATE KEY-----...` |

### Step 4: Configure Maven Settings (Optional)

If you need custom Maven settings:

1. Store `settings.xml` in repository: `.github/maven/settings.xml`
2. Or add as GitHub secret: `MAVEN_SETTINGS_XML`

### Step 5: Set Up Self-Hosted Runners (Optional)

If you need access to internal resources (SonarQube, Nexus, Tomcat on private network):

1. Go to **Settings → Actions → Runners → New self-hosted runner**
2. Follow instructions to install runner on your server
3. Label runners appropriately (e.g., `build`, `deploy`)

---

## GitHub Actions Workflow Configuration

Create `.github/workflows/ci-cd.yml`:

```yaml
name: Java CI/CD Pipeline

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]
  workflow_dispatch:

env:
  NEXUS_REPO: 'my-java-app'
  NEXUS_GROUP: 'com/web/app'
  NEXUS_ARTIFACT: 'my-app'

jobs:
  build-and-analyze:
    name: Build and Analyze
    runs-on: ubuntu-latest
    # Use self-hosted runner if SonarQube is on private network
    # runs-on: self-hosted
    
    steps:
      - name: 📦 Checkout Code
        uses: actions/checkout@v4
        with:
          fetch-depth: 0  # Shallow clones should be disabled for better analysis

      - name: ☕ Set up JDK 17
        uses: actions/setup-java@v4
        with:
          java-version: '17'
          distribution: 'temurin'
          cache: 'maven'

      - name: 🔍 SonarQube Analysis
        env:
          SONAR_TOKEN: ${{ secrets.SONAR_TOKEN }}
          SONAR_HOST_URL: ${{ secrets.SONAR_HOST_URL }}
        run: |
          echo "Running SonarQube static analysis..."
          mvn clean verify sonar:sonar \
            -Dsonar.projectKey=sample-java-app \
            -Dsonar.host.url=${{ secrets.SONAR_HOST_URL }} \
            -Dsonar.login=${{ secrets.SONAR_TOKEN }} \
            -DskipTests

      - name: ⚙️ Build WAR Artifact
        run: |
          echo "Building WAR file..."
          mvn clean package -DskipTests
          echo "✅ Build Completed!"
          ls -lh target/*.war

      - name: 📤 Upload Artifact to Nexus
        env:
          NEXUS_USERNAME: ${{ secrets.NEXUS_USERNAME }}
          NEXUS_PASSWORD: ${{ secrets.NEXUS_PASSWORD }}
        run: |
          WAR_FILE=$(ls target/*.war | head -1)
          FILE_NAME=$(basename "$WAR_FILE")
          VERSION="0.0.${{ github.run_number }}"
          
          echo "📤 Uploading $FILE_NAME to Nexus as version $VERSION..."
          
          curl -v -u ${{ secrets.NEXUS_USERNAME }}:${{ secrets.NEXUS_PASSWORD }} \
            --upload-file "$WAR_FILE" \
            "${{ secrets.NEXUS_URL }}/repository/${NEXUS_REPO}/${NEXUS_GROUP}/${NEXUS_ARTIFACT}/${VERSION}/${NEXUS_ARTIFACT}-${VERSION}.war"
          
          echo "✅ Artifact uploaded successfully!"

      - name: 📦 Upload Build Artifact
        uses: actions/upload-artifact@v4
        with:
          name: webapp-war
          path: target/*.war
          retention-days: 30

  deploy:
    name: Deploy to Tomcat
    needs: build-and-analyze
    runs-on: ubuntu-latest
    # Use self-hosted runner if Tomcat is on private network
    # runs-on: self-hosted
    if: github.ref == 'refs/heads/main' && github.event_name == 'push'
    
    steps:
      - name: ⬇️ Download Build Artifact
        uses: actions/download-artifact@v4
        with:
          name: webapp-war

      - name: 🚀 Deploy to Tomcat
        env:
          NEXUS_USERNAME: ${{ secrets.NEXUS_USERNAME }}
          NEXUS_PASSWORD: ${{ secrets.NEXUS_PASSWORD }}
          TOMCAT_USERNAME: ${{ secrets.TOMCAT_USERNAME }}
          TOMCAT_PASSWORD: ${{ secrets.TOMCAT_PASSWORD }}
        run: |
          set -e
          cd /tmp; rm -f *.war
          
          echo "🔍 Fetching latest WAR from Nexus..."
          DOWNLOAD_URL=$(curl -s -u ${{ secrets.NEXUS_USERNAME }}:${{ secrets.NEXUS_PASSWORD }} \
            "${{ secrets.NEXUS_URL }}/service/rest/v1/search?repository=${NEXUS_REPO}&group=com.web.app&name=my-app" \
            | grep -oP '"downloadUrl"\s*:\s*"\K[^"]+\.war' | grep -vE '\.md5|\.sha1' | tail -1)
          
          if [[ -z "$DOWNLOAD_URL" ]]; then
            echo "❌ No WAR found in Nexus!"
            exit 1
          fi
          
          echo "⬇️ Downloading WAR: $DOWNLOAD_URL"
          curl -u ${{ secrets.NEXUS_USERNAME }}:${{ secrets.NEXUS_PASSWORD }} -O "$DOWNLOAD_URL"
          WAR_FILE=$(basename "$DOWNLOAD_URL")
          APP_NAME=$(echo "$WAR_FILE" | sed 's/-[0-9].*//')
          
          echo "🧹 Removing old deployment..."
          curl -u ${{ secrets.TOMCAT_USERNAME }}:${{ secrets.TOMCAT_PASSWORD }} \
            "${{ secrets.TOMCAT_URL }}/manager/text/undeploy?path=/${APP_NAME}" || true
          
          echo "🚀 Deploying new WAR to Tomcat..."
          curl -u ${{ secrets.TOMCAT_USERNAME }}:${{ secrets.TOMCAT_PASSWORD }} \
            --upload-file "$WAR_FILE" \
            "${{ secrets.TOMCAT_URL }}/manager/text/deploy?path=/${APP_NAME}&update=true"
          
          echo "✅ Deployment successful!"
```

---

## Setting Up Secrets

### Using GitHub CLI

```bash
# Set up secrets using gh CLI
gh secret set SONAR_TOKEN --body "your-token"
gh secret set SONAR_HOST_URL --body "http://your-sonar-server:9000"
gh secret set NEXUS_USERNAME --body "admin"
gh secret set NEXUS_PASSWORD --body "your-password"
gh secret set NEXUS_URL --body "http://3.19.221.46:8081"
gh secret set TOMCAT_USERNAME --body "deployer"
gh secret set TOMCAT_PASSWORD --body "your-password"
gh secret set TOMCAT_URL --body "http://18.116.203.32:8080"
```

### Using GitHub Web UI

1. Go to repository **Settings**
2. Navigate to **Secrets and variables → Actions**
3. Click **New repository secret**
4. Add each secret with name and value

---

## Testing the Workflow

### Step 1: Dry Run (Test Build Only)

1. Comment out the `deploy` job initially
2. Push changes to a feature branch
3. Verify build and analysis stages work

### Step 2: Test Full Pipeline

1. Uncomment the `deploy` job
2. Push to `main` branch
3. Monitor workflow execution in **Actions** tab

### Step 3: Verify Deployment

1. Check Nexus repository for uploaded artifact
2. Verify Tomcat deployment at `http://18.116.203.32:8080/my-app`
3. Test application functionality

---

## Best Practices

### 1. Use Environment-Specific Workflows

Create separate workflows for different environments:

```
.github/workflows/
├── ci.yml           # Run on all branches (build + test)
├── deploy-dev.yml   # Deploy to dev environment
├── deploy-prod.yml  # Deploy to production
```

### 2. Implement Quality Gates

```yaml
- name: SonarQube Quality Gate
  uses: sonarsource/sonarqube-quality-gate-action@master
  timeout-minutes: 5
  env:
    SONAR_TOKEN: ${{ secrets.SONAR_TOKEN }}
```

### 3. Use Matrix Builds (Optional)

Test against multiple Java versions:

```yaml
strategy:
  matrix:
    java-version: [11, 17, 21]
```

### 4. Add Notifications

```yaml
- name: Notify on Failure
  if: failure()
  uses: 8398a7/action-slack@v3
  with:
    status: ${{ job.status }}
    webhook_url: ${{ secrets.SLACK_WEBHOOK }}
```

### 5. Implement Manual Approval for Production

```yaml
deploy-production:
  needs: build-and-analyze
  runs-on: ubuntu-latest
  environment:
    name: production
    url: http://your-production-url
  steps:
    # deployment steps
```

Then configure environment protection rules in repository settings.

### 6. Cache Maven Dependencies

Already included in the workflow via:

```yaml
- uses: actions/setup-java@v4
  with:
    cache: 'maven'
```

### 7. Security Scanning

Add security scanning:

```yaml
- name: Run Dependency Check
  run: mvn org.owasp:dependency-check-maven:check
```

---

## Key Differences: Jenkins vs GitHub Actions

| Feature | Jenkins | GitHub Actions |
|---------|---------|----------------|
| Checkout | Explicit `checkout` stage | `actions/checkout@v4` |
| Build Number | `${BUILD_NUMBER}` | `${{ github.run_number }}` |
| Credentials | `withCredentials` | `${{ secrets.SECRET_NAME }}` |
| Agents/Runners | `agent { label 'name' }` | `runs-on: self-hosted` |
| Environment Vars | `environment { }` | `env:` block |
| Conditionals | `when { }` | `if:` condition |
| Post Actions | `post { }` | `if: success()` or `if: failure()` |

---

## Troubleshooting

### Issue: SonarQube Connection Timeout

**Solution:** Use self-hosted runner on same network as SonarQube

### Issue: Nexus Upload Fails

**Solution:** Check credentials and network access; verify Nexus URL format

### Issue: Tomcat Deployment Fails

**Solution:** 
- Verify Tomcat manager credentials
- Ensure manager-script role is assigned
- Check Tomcat server accessibility

### Issue: Maven Build Fails

**Solution:**
- Check Java version compatibility
- Verify `pom.xml` configuration
- Review build logs for specific errors

---

## Rollback Plan

If issues occur:

1. Keep Jenkins pipeline active during transition
2. Test GitHub Actions on feature branches first
3. Run both pipelines in parallel initially
4. Disable Jenkins only after GitHub Actions is stable

---

## Next Steps

1. ✅ Create workflow file
2. ✅ Set up secrets
3. ✅ Test on feature branch
4. ✅ Deploy to dev environment
5. ✅ Monitor for 1-2 weeks
6. ✅ Migrate production deployments
7. ✅ Decommission Jenkins pipeline

---

## Additional Resources

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Maven with GitHub Actions](https://docs.github.com/en/actions/automating-builds-and-tests/building-and-testing-java-with-maven)
- [SonarQube GitHub Action](https://github.com/SonarSource/sonarqube-scan-action)
- [Self-hosted Runners](https://docs.github.com/en/actions/hosting-your-own-runners)

---

**Questions or Issues?** Open an issue or contact the DevOps team.
