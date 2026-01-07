# Quick Reference: Using GitHub Personal Access Token

## Quick Start

```bash
# 1. Create token at: https://github.com/settings/tokens
# 2. Select scope: repo (Full control of private repositories)
# 3. Use with ACE-Box:

export GITHUB_PAT="ghp_your_token_here"
ace enable https://github.com/lawrobar90/ace-box-ext-hot-perform-vegas-app.git \
  --extra-vars "github_personal_access_token=$GITHUB_PAT"
```

## When is a Token Required?

- ✅ Private repositories
- ✅ Avoiding rate limits
- ✅ CI/CD automation
- ❌ Public repositories (optional)

## Token Scope Required

Minimum required scope:
- ✅ `repo` - Full control of private repositories

## Usage Examples

### Basic Usage
```bash
ace enable https://github.com/lawrobar90/ace-box-ext-hot-perform-vegas-app.git \
  --extra-vars "github_personal_access_token=ghp_abc123xyz"
```

### From Environment Variable
```bash
export GITHUB_PAT="ghp_abc123xyz"
ace enable https://github.com/lawrobar90/ace-box-ext-hot-perform-vegas-app.git \
  --extra-vars "github_personal_access_token=$GITHUB_PAT"
```

### From Variables File
```bash
# Create secrets.yml:
echo "github_personal_access_token: ghp_abc123xyz" > secrets.yml

# Use it:
ace enable https://github.com/lawrobar90/ace-box-ext-hot-perform-vegas-app.git \
  --extra-vars "@secrets.yml"
```

### Using Ansible Vault (Secure)
```bash
# Encrypt token:
ansible-vault create secrets.yml

# Add content:
github_personal_access_token: "ghp_abc123xyz"

# Use with vault:
ace enable https://github.com/lawrobar90/ace-box-ext-hot-perform-vegas-app.git \
  --extra-vars "@secrets.yml" \
  --ask-vault-pass
```

## Important Security Notes

⚠️ **DO NOT commit tokens to git!**
- The `.gitignore` file is configured to prevent this
- Always use environment variables or encrypted files

⚠️ **Token has full repository access**
- Treat it like a password
- Use token expiration (recommended: 90 days)
- Rotate regularly

⚠️ **Token appears in git URLs**
- The `no_log: true` option prevents logging
- Still, avoid sharing debug output

## Troubleshooting

| Issue | Solution |
|-------|----------|
| "Authentication failed" | Check token is valid and has `repo` scope |
| Token not working | Verify variable name is exactly `github_personal_access_token` |
| Still hitting rate limits | Confirm token is being used (check ansible output) |
| Token exposed in logs | Ensure ansible task has `no_log: true` |

## Full Documentation

For complete details, see: [docs/GITHUB_PAT_SETUP.md](GITHUB_PAT_SETUP.md)

## Support

Issues? Open an issue at: https://github.com/lawrobar90/ace-box-ext-hot-perform-vegas-app/issues
