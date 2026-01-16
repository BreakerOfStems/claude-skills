---
name: azure
description: Azure CLI read-only operations for searching resources, querying configurations, and inspecting RBAC
---

# Azure CLI Skill (Read-Only)

This skill provides safe, read-only access to Azure resources via the Azure CLI.

> **See also**: [Shared Conventions](../shared/CONVENTIONS.md) | [Safety Guidelines](../shared/SAFETY.md)

## Scope

- Search and list Azure resources
- Query resource configurations
- Inspect RBAC role assignments and definitions

## Command Allowlist (Read-Only Only)

### Account

```
az account show
az account list
```

### Resource Groups

```
az group show --name <name>
az group list
```

### Resources

```
az resource list
az resource show --ids <resource-id>
az resource show --name <name> --resource-group <rg> --resource-type <type>
```

### RBAC

```
az role assignment list
az role assignment list --assignee <principal>
az role assignment list --scope <scope>
az role definition list
az role definition show --name <role-name>
```

## Policies

### Output Format

- **Always use JSON output**: Add `-o json` to all commands
- This ensures consistent, parseable output

### No Mutations Allowed

The following command categories are **strictly forbidden**:

- `az * create`
- `az * update`
- `az * delete`
- `az * set`
- `az role assignment create`
- `az role assignment delete`
- Any command that modifies state

### Mutation Requests

If asked to perform a mutating operation:

1. **Stop immediately**
2. Explain that this skill is read-only
3. Show the command that would be needed
4. Require explicit confirmation in the user's request before proceeding
5. If no explicit confirmation, **do not execute**

## Workflow Examples

### List All Resources in a Subscription

```bash
az resource list -o json
```

### Find Resources by Type

```bash
az resource list --resource-type "Microsoft.Compute/virtualMachines" -o json
```

### Inspect a Specific Resource

```bash
az resource show --ids "/subscriptions/.../resourceGroups/.../providers/..." -o json
```

### Check Role Assignments for a User

```bash
az role assignment list --assignee "user@example.com" -o json
```

### List All Role Definitions

```bash
az role definition list -o json
```

## Helper Scripts

- `scripts/az_safe_query.sh` - Wrapper that enforces read-only operations and JSON output

## Common Queries

### Find All VMs in a Resource Group

```bash
az resource list --resource-group <rg-name> --resource-type "Microsoft.Compute/virtualMachines" -o json
```

### Get Subscription Details

```bash
az account show -o json
```

### List Storage Accounts

```bash
az resource list --resource-type "Microsoft.Storage/storageAccounts" -o json
```
