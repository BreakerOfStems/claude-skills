# Safety Guidelines

## General Principles

1. **Least Privilege**: Only request the minimum permissions needed for each task
2. **Explicit Consent**: Destructive or state-changing operations require explicit user confirmation
3. **Audit Trail**: Document actions taken for accountability
4. **Fail Safe**: When in doubt, stop and ask rather than proceed

## Risk Categories

### High Risk (Require Explicit Confirmation)
- Deleting files or resources
- Modifying production configurations
- Force pushing to repositories
- Restarting critical services
- Any action that cannot be undone

### Medium Risk (Show Plan First)
- Creating new branches or PRs
- Installing packages or dependencies
- Modifying non-production configurations
- Restarting non-critical services

### Low Risk (Proceed with Notification)
- Reading files or configurations
- Querying resource status
- Viewing logs
- Listing resources

## Incident Response

If something goes wrong:

1. **Stop** all automated actions immediately
2. **Document** what happened and what commands were run
3. **Assess** the impact and scope
4. **Report** to the user with full details
5. **Suggest** remediation steps if known

## Credential Handling

- Never log or display credentials, tokens, or secrets
- Use environment variables or secure vaults for sensitive data
- Verify authentication status before operations
- Report authentication failures clearly without exposing details
