---
name: git-workflow
description: Standard git commit and branch management workflow for personal and work projects.
---

# Git Workflow Skill

## Commit Conventions
- Use present tense ("add feature" not "added feature")
- Structure: `<type>(<scope>): <short summary>`
- Common types: `feat`, `fix`, `refactor`, `style`, `test`, `chore`, `docs`

## Pre-Push Checklist
1. Review unstaged changes: `git status -s`
2. Run linters/tests
3. Check branch sync: `git fetch origin`
