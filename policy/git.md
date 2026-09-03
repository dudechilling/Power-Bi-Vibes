# Client Git Policy

This policy overrides generic upstream branching guidance for Power-BI-Vibes-managed client repositories.

## Default

`main` is the current usable product. During normal iterative development: inspect state, make a logical batch, validate it as far as the environment allows, perform applicable visual/local QA, then commit a descriptive checkpoint.

## Separate authentication contexts

ChatGPT's connected GitHub authorization and the user's local Windows Git authentication are separate. A successful ChatGPT repository write does not prove the user's computer can clone, pull, or push.

Power BI Vibes defaults to HTTPS + Git Credential Manager on Windows. GitHub CLI, GitHub Desktop, and SSH keys are optional unless the environment specifically needs them.

## Author of record

The agent is the author of record for tracked PBIP/PBIR/TMDL/model/report files unless the user deliberately edits them in Power BI Desktop. Treat Desktop saves as real source-code changes and inspect the working tree before pulling newer agent commits.

## Use a branch when it earns its cost

Create a temporary branch for a substantial redesign or experiment that may be abandoned or genuinely needs isolation. Merge or delete it promptly.

Avoid branch-per-edit workflows, version-number archive branches, force-pushing user-created branches, destructive resets before inspecting uncommitted work, and generated branch clutter.

## First local readiness check

Local setup is deferred until Power BI Desktop testing is needed. From the cloned client repository, run:

```powershell
.\scripts\check-local-setup.ps1 -RepositoryUrl https://github.com/OWNER/PROJECT.git
```

## Local clone

Prefer a short writable path:

```powershell
New-Item -ItemType Directory -Path C:\PBI -Force | Out-Null
git clone <REPOSITORY-URL> C:\PBI\<PROJECT-NAME>
```

If `C:\PBI` is unavailable, use a short user-owned path.

## Safe sync preflight

Before pulling changes into a clone opened or saved in Power BI Desktop:

```powershell
git status --short --branch
```

If clean:

```powershell
git pull --ff-only
```

If local edits must be kept, preserve them in a rescue branch before updating `main`. If the user confirms tracked edits are disposable, `git reset --hard origin/main` may be used only after inspection. Preview untracked deletion with `git clean -nd` before any `git clean -fd`.

If `git pull --ff-only` refuses, inspect status and recent graph history. Preserve user-authored commits and edits before resolving divergence. Never force-push or rewrite user-created history.

## Known-good checkpoints

Use an annotated known-good tag only when it materially improves recovery. Normal checkpoint commits remain the primary history.