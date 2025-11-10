# Required GitHub Secrets

To use the CI/CD workflow, you need to configure the following secrets in your GitHub repository:

**Go to:** Repository Settings → Secrets and variables → Actions → New repository secret

## Required Secrets

### 1. SonarQube Configuration
- **`SONAR_TOKEN`**: SonarQube authentication token
  - Generate from: SonarQube (http://100.25.217.210:9000) → My Account → Security → Generate Token

### 2. Nexus Repository Configuration
- **`NEXUS_USERNAME`**: Nexus repository username
- **`NEXUS_PASSWORD`**: Nexus repository password

### 3. Tomcat Server Configuration
- **`TOMCAT_USERNAME`**: Tomcat manager username (with manager-script role)
- **`TOMCAT_PASSWORD`**: Tomcat manager password

## How to Add Secrets

1. Go to your GitHub repository
2. Click on **Settings** tab
3. Navigate to **Secrets and variables** → **Actions**
4. Click **New repository secret**
5. Enter the secret name and value
6. Click **Add secret**

## Testing the Workflow

Once all secrets are configured:
1. Push changes to the `main` branch
2. Or manually trigger via **Actions** tab → **CI/CD Pipeline** → **Run workflow**
3. Monitor the workflow execution in the **Actions** tab

## Troubleshooting

- Verify all server URLs are accessible from GitHub Actions runners
- Ensure Nexus and Tomcat credentials have appropriate permissions
- Check SonarQube token has analysis permissions
