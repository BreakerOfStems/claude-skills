---
name: skill-authoring
description: Create new Claude Code skills with proper structure, YAML frontmatter, and best practices
---

# Skill Authoring Skill

Create new skills for Claude Code following established patterns and conventions.

> **See also**: [Shared Conventions](../shared/CONVENTIONS.md) | [Safety Guidelines](../shared/SAFETY.md)

## Purpose

Author well-structured skills that extend Claude's capabilities for domain-specific tasks.

## Background Knowledge

### What is a Skill?

A skill is a modular capability that provides Claude with domain-specific expertise: workflows, context, and best practices. Skills are filesystem-based, stored as directories containing a `SKILL.md` file with optional supporting resources.

### Skill Discovery

Claude Code discovers skills by reading `SKILL.md` files with YAML frontmatter. Skills can be:
- **Personal**: `~/.claude/skills/<skill-name>/SKILL.md`
- **Project-based**: `.claude/skills/<skill-name>/SKILL.md`
- **Repository-based**: `<repo>/<skill-name>/SKILL.md`

### Progressive Disclosure

Skills use three levels of content loading:
1. **Metadata** (always loaded): YAML frontmatter with name and description
2. **Instructions** (loaded when triggered): Main SKILL.md body
3. **Resources** (loaded as needed): Additional files, scripts, templates

## Skill Structure Requirements

### Required: SKILL.md with YAML Frontmatter

```yaml
---
name: my-skill-name
description: Brief description of what this skill does and when to use it
---
```

**Field requirements**:
- `name`: Max 64 chars, lowercase letters, numbers, hyphens only
- `description`: Max 1024 chars, should include both what the skill does AND when to use it

### Recommended Directory Structure

```
my-skill/
├── SKILL.md           # Required: Main instructions
├── scripts/           # Optional: Executable scripts
│   └── helper.sh
├── templates/         # Optional: File templates
│   └── template.md
└── examples/          # Optional: Example files
    └── example.json
```

## SKILL.md Anatomy

A well-structured skill includes these sections:

```markdown
---
name: skill-name
description: Description including what it does and when to use it
---

# Skill Title

Brief one-line description.

> **See also**: [Shared Conventions](../shared/CONVENTIONS.md) | [Safety Guidelines](../shared/SAFETY.md)

## Purpose

What the skill does (one sentence).

## Background Knowledge

Domain context Claude needs to understand before executing tasks.

## Commands

Allowed commands with examples:
```bash
example-command --flag value
```

## Workflow

Step-by-step usage patterns:
1. First step
2. Second step
3. Third step

## Policies

Safety rules and constraints:
- What is allowed
- What is forbidden
- When to stop and ask
```

## Workflow: Create a New Skill

### 1. Gather Requirements

Understand the skill's purpose:
- What domain does it cover?
- What commands/tools does it use?
- What are the safety boundaries?
- What mistakes should be avoided?

### 2. Create the Directory

```bash
mkdir -p <skills-location>/<skill-name>
```

### 3. Write the SKILL.md

Create the file with proper structure:

```bash
cat > <skills-location>/<skill-name>/SKILL.md << 'EOF'
---
name: skill-name
description: Description of what this skill does
---

# Skill Title

[Content following the anatomy above]
EOF
```

### 4. Add Supporting Resources (Optional)

If the skill needs scripts or templates:

```bash
mkdir -p <skills-location>/<skill-name>/scripts
# Create helper scripts as needed
```

### 5. Validate the Skill

Check that:
- [ ] YAML frontmatter is valid
- [ ] `name` follows naming conventions (lowercase, hyphens, max 64 chars)
- [ ] `description` is clear and under 1024 chars
- [ ] Purpose section explains the skill's function
- [ ] Commands section lists allowed operations
- [ ] Policies section defines safety boundaries
- [ ] Cross-references to shared conventions are included

### 6. Update Documentation

If adding to a skills repository:
- Add the skill to the repository README
- Place skill in appropriate category

## Best Practices

### Design Principles

1. **One function per skill** - Keep skills focused and granular
2. **No overlap** - Each skill has a distinct purpose
3. **Clear boundaries** - Explicit about what's allowed and forbidden
4. **Shared conventions** - Reference common protections, don't duplicate

### Description Writing

Write descriptions that help Claude know when to trigger the skill:

**Good**: "Create and manage Docker containers for local development. Use when working with Docker, containerization, or when the user mentions containers, images, or docker-compose."

**Bad**: "Docker stuff"

### Command Documentation

- Show actual command syntax with placeholders
- Include common flag combinations
- Provide concrete examples

### Safety Considerations

- Define what operations are read-only vs. state-changing
- Specify when to ask for confirmation
- List protected resources that should not be modified
- Reference shared safety guidelines

## Policies

- Always include YAML frontmatter with `name` and `description`
- Always include a Purpose section
- Always include a Policies section defining safety boundaries
- Always reference shared conventions when applicable
- Never duplicate safety rules that exist in shared guidelines
- Never create skills that bypass security boundaries
- When in doubt about scope, keep the skill narrowly focused

## Example: Creating a Kubernetes Skill

```bash
# 1. Create directory
mkdir -p ~/.claude/skills/kubernetes-pods

# 2. Create SKILL.md
cat > ~/.claude/skills/kubernetes-pods/SKILL.md << 'EOF'
---
name: kubernetes-pods
description: View and manage Kubernetes pods. Use when working with K8s pods, containers, or when the user mentions kubectl, pods, or deployments.
---

# Kubernetes Pods Skill

Manage Kubernetes pods safely within designated namespaces.

## Purpose

View pod status, logs, and perform safe pod operations.

## Commands

```bash
kubectl get pods -n <namespace>
kubectl describe pod <name> -n <namespace>
kubectl logs <pod> -n <namespace>
kubectl delete pod <name> -n <namespace>
```

## Policies

- Always specify namespace explicitly
- Read operations do not require confirmation
- Delete operations require explicit user confirmation
- Never delete pods in kube-system namespace
EOF
```

## Output Format

When creating a skill, report:
1. Skill location and name
2. Sections included
3. Any warnings about missing recommended sections
4. Next steps (e.g., "Test the skill by asking Claude to use it")
