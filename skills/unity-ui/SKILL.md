---
name: unity-ui
description: Make UI changes by editing prefabs and scenes carefully without a GUI
---

# Unity UI Skill

Edit Unity UI assets (prefabs, scenes) without visual tools.

> **See also**: [Shared Conventions](../shared/CONVENTIONS.md) | [Safety Guidelines](../shared/SAFETY.md)

## Purpose

Make targeted UI changes by editing YAML asset files, minimizing serialization churn.

## Understanding Unity UI Assets

Unity scenes and prefabs are serialized as YAML:
- `.unity` - Scene files
- `.prefab` - Prefab files
- `.asset` - ScriptableObjects, other assets

## Key Principle: Minimal Diffs

UI work creates large diffs if not careful. Follow these rules:

### 1. Small Changes Per Commit

One logical change at a time:
- ✅ "Add health bar to HUD"
- ❌ "Update entire HUD layout"

### 2. Avoid Reserializing Entire Scenes

Opening a scene in Unity Editor can reserialize everything. When editing YAML directly:
- Only modify the specific components you need
- Don't reformat or reorder unrelated objects
- Keep surrounding YAML intact

### 3. Use Dedicated UI Prefabs

Instead of embedding UI in main scenes:

```
Assets/
  Prefabs/
    UI/
      HUD.prefab           # Main HUD
      HealthBar.prefab     # Reusable health bar
      Dialogs/
        ConfirmDialog.prefab
```

Benefits:
- Changes isolated to one prefab
- Smaller diffs
- Easier merge conflicts

## YAML Structure Basics

### GameObject in Scene/Prefab

```yaml
--- !u!1 &123456789
GameObject:
  m_Name: HealthBar
  m_Component:
  - component: {fileID: 123456790}  # Transform
  - component: {fileID: 123456791}  # Image
  - component: {fileID: 123456792}  # Custom script
```

### RectTransform (UI positioning)

```yaml
--- !u!224 &123456790
RectTransform:
  m_AnchorMin: {x: 0, y: 1}
  m_AnchorMax: {x: 0, y: 1}
  m_AnchoredPosition: {x: 100, y: -50}
  m_SizeDelta: {x: 200, y: 30}
  m_Pivot: {x: 0, y: 1}
```

### Image Component

```yaml
--- !u!114 &123456791
MonoBehaviour:
  m_Script: {fileID: 11500000, guid: <image-guid>, type: 3}
  m_Color: {r: 1, g: 1, b: 1, a: 1}
  m_Sprite: {fileID: 21300000, guid: <sprite-guid>, type: 3}
  m_Type: 1  # 0=Simple, 1=Sliced, 2=Tiled, 3=Filled
```

## Safe Editing Workflow

### Step 1: Identify Target

Find the object to modify:
```bash
grep -n "m_Name: HealthBar" Assets/Prefabs/UI/HUD.prefab
```

### Step 2: Make Targeted Edit

Edit only necessary fields. Example - change position:

```yaml
# Before
m_AnchoredPosition: {x: 100, y: -50}

# After
m_AnchoredPosition: {x: 150, y: -50}
```

### Step 3: Verify YAML Valid

```bash
# Check for syntax errors (basic)
python3 -c "import yaml; yaml.safe_load(open('Assets/Prefabs/UI/HUD.prefab'))"
```

### Step 4: Commit Small

```bash
git add Assets/Prefabs/UI/HUD.prefab
git commit -m "Move health bar position"
```

## Common UI Tasks

### Add Text to Existing UI

Find parent, note its fileID, add new GameObject referencing parent.

### Change Color

```yaml
m_Color: {r: 1, g: 0.5, b: 0, a: 1}  # Orange
```

### Change Anchoring

```yaml
# Top-left anchored
m_AnchorMin: {x: 0, y: 1}
m_AnchorMax: {x: 0, y: 1}

# Stretch horizontal, top
m_AnchorMin: {x: 0, y: 1}
m_AnchorMax: {x: 1, y: 1}

# Center
m_AnchorMin: {x: 0.5, y: 0.5}
m_AnchorMax: {x: 0.5, y: 0.5}
```

## Visual Verification (Headless Limitation)

Since VPS is headless, cannot visually verify UI. Generate a checklist for user:

```markdown
## UI Verification Checklist

Please verify locally:
- [ ] Health bar visible in top-left corner
- [ ] Health bar is 200x30 pixels
- [ ] Health bar color is green (#00FF00)
- [ ] Text shows "100/100" format
- [ ] Bar fills correctly when health changes
```

## Policies

- **Minimal diffs** - change only what's necessary
- **Prefab isolation** - edit prefabs, not scene-embedded UI
- **No blind reserialize** - don't open scenes just to "check"
- **Verification checklist** - always provide visual verification steps
- **Git status before/after** - verify diff is reasonable size
