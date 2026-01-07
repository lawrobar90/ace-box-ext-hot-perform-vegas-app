# GitHub Personal Access Token Setup

This document explains how to create and use a GitHub Personal Access Token (PAT) with this ACE-Box extension.

## Why Use a Personal Access Token?

A Personal Access Token is recommended when:
- Cloning private repositories
- Avoiding GitHub API rate limits
- Automating deployments via CI/CD
- Providing secure, authenticated access to repositories

## Creating a Personal Access Token

### Step 1: Navigate to GitHub Settings

1. Log in to your GitHub account
2. Click your profile picture (top right) → **Settings**
3. Scroll down and click **Developer settings** (left sidebar)
4. Click **Personal access tokens** → **Tokens (classic)**

### Step 2: Generate New Token

1. Click **Generate new token** → **Generate new token (classic)**
2. Provide a descriptive note (e.g., "ACE-Box Deployment Token")
3. Set expiration date (recommended: 90 days for security)
4. Select required scopes:
   - ✅ `repo` - Full control of private repositories
     - Includes: `repo:status`, `repo_deployment`, `public_repo`, `repo:invite`, `security_events`

### Step 3: Generate and Copy Token

1. Click **Generate token** at the bottom
2. **Important**: Copy the token immediately - you won't see it again!
3. Store it securely (password manager, secrets management system)

## Using the Token with ACE-Box

### Method 1: Environment Variable (Recommended for CI/CD)

Set the token as an environment variable before running ACE-Box:

```bash
export GITHUB_PAT="ghp_your_token_here"
ace enable https://github.com/lawrobar90/ace-box-ext-hot-perform-vegas-app.git \
  --extra-vars "github_personal_access_token=$GITHUB_PAT"
```

### Method 2: Ansible Extra Variables

Pass the token directly via extra-vars:

```bash
ace enable https://github.com/lawrobar90/ace-box-ext-hot-perform-vegas-app.git \
  --extra-vars "github_personal_access_token=ghp_your_token_here"
```

### Method 3: Ansible Variables File

Create a secure variables file (e.g., `secrets.yml`):

```yaml
---
github_personal_access_token: "ghp_your_token_here"
```

**Important**: Add this file to `.gitignore` to prevent committing secrets!

Then use it:

```bash
ace enable https://github.com/lawrobar90/ace-box-ext-hot-perform-vegas-app.git \
  --extra-vars "@secrets.yml"
```

### Method 4: Ansible Vault (Most Secure)

Encrypt the token using Ansible Vault:

```bash
ansible-vault create secrets.yml
```

Add the token:

```yaml
---
github_personal_access_token: "ghp_your_token_here"
```

Use with vault password:

```bash
ace enable https://github.com/lawrobar90/ace-box-ext-hot-perform-vegas-app.git \
  --extra-vars "@secrets.yml" \
  --ask-vault-pass
```

## Token Security Best Practices

1. **Never commit tokens to Git** - Add token files to `.gitignore`
2. **Use token expiration** - Set reasonable expiration dates
3. **Limit token scope** - Only grant necessary permissions
4. **Rotate tokens regularly** - Update tokens periodically
5. **Use environment-specific tokens** - Different tokens for dev/staging/prod
6. **Monitor token usage** - Review GitHub's token activity logs
7. **Revoke compromised tokens immediately** - Go to GitHub Settings → Developer settings

## Troubleshooting

### Authentication Failed

If you see "Authentication failed" errors:

1. Verify the token is still valid (not expired)
2. Check the token has `repo` scope enabled
3. Ensure no extra spaces in the token string
4. Verify the repository URL is correct

### Token Not Being Used

If the token isn't being applied:

1. Check the variable name is exactly: `github_personal_access_token`
2. Verify extra-vars syntax is correct
3. Check Ansible debug output (if available)

### Rate Limit Issues

If you still hit rate limits with a token:

1. Verify the token is actually being used (check git clone URL)
2. Check your token's rate limit status on GitHub
3. Consider using a different token or account

## Additional Resources

- [GitHub: Creating a personal access token](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token)
- [GitHub: Token expiration and revocation](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/token-expiration-and-revocation)
- [Ansible Vault documentation](https://docs.ansible.com/ansible/latest/user_guide/vault.html)

## Support

For issues with token setup or usage, please open an issue in the repository.
