# Client Git Policy

This file intentionally overrides generic upstream branching guidance for Power-Bi-Vibes client repositories.

## Default

`main` is the current usable product.

During normal iterative development:

1. inspect current repository state;
2. make a logical batch of changes;
3. validate the batch as far as the current environment allows;
4. perform applicable visual/local QA;
5. commit a descriptive checkpoint to `main`.

## GitHub access has two separate authentication contexts

ChatGPT's connected GitHub authorization and the user's local Windows Git authentication are separate.

A successful ChatGPT repository write does not prove that the user's computer can clone/pull/push the repository. Before the first local Desktop handoff, use `scripts/check-local-setup.ps1` from the client project and the public `docs/windows-setup.md` guide to establish local Git, Git identity and GitHub access.

Power BI Vibes defaults to HTTPS + Git Credential Manager on Windows. Do not require GitHub CLI, GitHub Desktop or SSH-key configuration unless the user's environment specifically needs them.

## Author of record

The agent is the author of record for tracked PBIP/PBIR/TMDL/model/report files unless the user deliberately chooses to edit them in Power BI Desktop.

Desktop may write tracked project files when the user saves. Treat a user save as a real source-code change. Before pulling newer agent commits, inspect the local working tree so those edits are never silently lost.

## Use a branch when it earns its cost

Create a temporary branch when the user already has an accepted working product, the proposed change is a substantial redesign or experiment, the work may be abandoned, or parallel work genuinely requires isolation.

Use one descriptive branch for the experiment, then merge or delete it promptly.

## Avoid

- a new branch for every small edit;
- version-number branches used as archives;
- force-pushing user-created branches;
- destructive resets before inspecting uncommitted work;
- generated branch clutter after an experiment is finished.

Git history is the rollback mechanism. Frequent validated checkpoint commits are more useful to this audience than permanent branch accumulation.

## First local readiness check

Local setup is deferred until Power BI Desktop testing is needed. From the cloned client repository, run:

```powershell
.\scripts\check-local-setup.ps1 -RepositoryUrl https://github.com/OWNER/PROJECT.git
```

The checker is read-only. It does not install software or change Git configuration. If required checks fail, give the output to the agent and fix one dependency/authentication problem at a time.

## Local clone

Prefer a short writable path to reduce Power BI path-length problems:

```powershell
New-Item -ItemType Directory -Path C:\PBI -Force | Out-Null
git clone <REPOSITORY-URL> C:\PBI\<PROJECT-NAME>
```

If `C:\PBI` is unavailable, use a short user-owned path. In PowerShell:

```powershell
New-Item -ItemType Directory -Path "$env:USERPROFILE\PBI" -Force | Out-Null
git clone <REPOSITORY-URL> "$env:USERPROFILE\PBI\<PROJECT-NAME>"
```

On the first HTTPS operation, Git Credential Manager may open a browser sign-in. Complete GitHub account, organization/SSO and two-factor prompts as required. Do not tell the user to type their GitHub account password into an HTTPS Git password prompt.

## Safe sync preflight

Before pulling changes into a clone that has been opened or saved in Power BI Desktop, run:

```powershell
cd C:\PBI\<PROJECT-NAME>
git status --short --branch
```

### Clean working tree

If there are no modified/untracked project files, update with:

```powershell
git pull --ff-only
```

### Local edits must be kept

Do not pull or reset first. Preserve them in a rescue branch:

```powershell
$stamp = Get-Date -Format 'yyyyMMdd-HHmm'
git switch -c "local-desktop-edits-$stamp"
git add -A
git commit -m "checkpoint: preserve local Power BI Desktop edits"
git switch main
git pull --ff-only
```

Then give the agent the rescue branch name. The agent should inspect and deliberately integrate or discard those changes.

### Local edits may be discarded

Only after the user confirms the local tracked edits are disposable:

```powershell
git fetch origin
git reset --hard origin/main
```

Before deleting untracked files, preview them:

```powershell
git clean -nd
```

Run `git clean -fd` only if the preview contains nothing the user needs. A reset or clean is destructive and must never be the first response to a dirty working tree.

### `git pull --ff-only` refuses

Treat this as a divergence signal rather than an instruction to force anything. Inspect:

```powershell
git status --short --branch
git log --oneline --decorate --graph --all -20
```

Preserve any user-authored commits/edits before resolving the divergence. Do not force-push or rewrite user-created history.

## Known-good checkpoints

After a meaningful accepted milestone, an agent may create a descriptive annotated tag when that materially improves recovery, for example:

```powershell
git tag -a known-good-2026-08-31 -m "Accepted working checkpoint"
git push origin known-good-2026-08-31
```

Do not create a tag after every minor edit. Normal checkpoint commits remain the primary history.
