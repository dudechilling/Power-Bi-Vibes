# Start Here

Power BI Vibes is designed so you can describe your work in ordinary language and let ChatGPT handle most Power BI and repository mechanics.

It supports both new Power BI projects and existing Power BI repositories that need to be understood, debugged, repaired, extended, reverse engineered, refactored, validated, or migrated.

## What you need at the beginning

You need:

- a GitHub account;
- either a new private GitHub repository or an existing project repository you are permitted to work with;
- ChatGPT with GitHub connected and permission to read that repository, plus write permission only when the task requires mutation.

You do **not** need Git, GitHub Desktop, GitHub CLI, Power BI Desktop, DAX knowledge, or Power Query knowledge before ChatGPT starts.

The local Windows setup can wait until the first Power BI Desktop handoff.

## 1. Choose your starting path

### Path A - New Power BI project

For the full click-by-click instructions, read [`docs/CREATE-PRIVATE-REPO.md`](docs/CREATE-PRIVATE-REPO.md).

The short version:

1. Go to `https://github.com/new`.
2. Choose the account or organization that should own the project.
3. Give the repository a short descriptive name.
4. Set visibility to **Private**.
5. Turn **Add README** on so GitHub creates the initial `main` branch and commit.
6. Leave `.gitignore` and license unset unless your organization requires otherwise.
7. Select **Create repository**.
8. Copy the repository page URL.

A README-only repository is intentionally treated as greenfield by Power BI Vibes.

### Path B - Existing Power BI repository

Use the repository that already contains the implementation. Do not create a blank replacement repository merely to use Power BI Vibes.

Power BI Vibes should inspect the existing repository first, classify it, locate the Power BI implementation, and preserve its existing architecture and conventions unless you later choose to change them.

Existing repositories remain read-only during initial reconnaissance. Power BI Vibes should not add its own scaffold or metadata merely because those files are absent.

A private repository is still subject to your organization's data-handling rules. Do not treat the Private setting as permission to upload restricted production records, credentials, or secrets.

## 2. Connect GitHub to ChatGPT

Connect GitHub in ChatGPT and make sure ChatGPT can access the project repository. The exact controls can vary by ChatGPT plan and workspace policy.

The GitHub connection inside ChatGPT is separate from the GitHub authentication your Windows computer will use later for `git clone`, `git pull`, and `git push`.

Repository write access does not mean ChatGPT should immediately write. Existing repositories must be classified and understood before mutation.

## 3. Start the project or repository session

Paste this into a new ChatGPT conversation and replace the project URL:

```text
I want to work on a Power BI project.

Use this framework:
https://github.com/dudechilling/Power-Bi-Vibes

My project repository is:
<PASTE YOUR GITHUB REPOSITORY URL>

Read BOOTSTRAP.md in Power-Bi-Vibes and follow it.

Inspect the project repository before assuming whether it is new, existing, or already managed by Power BI Vibes. Do not modify an existing implementation until you understand its current structure and my requested task.

Do not ask me to share operational data that I am not permitted to share.
```

ChatGPT should inspect both repositories and run the Repository Mode Gate in `BOOTSTRAP.md`.

For a new project, it should ask what the tool should help you do, confirm Power BI is a reasonable fit, and then initialize the private project repository.

For an existing Power BI repository, it should perform read-only brownfield reconnaissance first, establish a compact system map, and continue from the existing implementation rather than rebuilding it.

## 4. Describe the job or operation, not the implementation

For a new project, explain the problem in the language you already use at work. Useful information includes what you do now, what is difficult to see, who will use the tool, what decisions it should support, what the finished tool should make easier, where the source data comes from, and how often that source changes.

For an existing project, describe the operation you need: explain, debug, repair, extend, reverse engineer, refactor, validate, migrate, or another concrete task. ChatGPT should inspect the relevant implementation before asking generic product-design questions.

You usually do not need to decide which charts, DAX measures, data model structure, or Power BI internals to use. ChatGPT should infer routine technical choices from the existing architecture or the job.

## 5. Give ChatGPT only a safe representation of the data when more information is needed

If you are permitted to share the real source, you can use it. If the source contains restricted operational information, use one of these approaches instead:

**Existing repository structure** - when the repository already contains enough permitted model/query/schema information, ChatGPT should use it rather than asking you to re-share restricted data.

**Scrubbed/template file** - keep useful structure while removing sensitive records.

**Schema report** - run `scripts/inspect-source.ps1` locally and review the resulting JSON before sharing it. The script intentionally omits row values, but schema and internal terminology can still be sensitive.

**Manually described schema** - tell ChatGPT the worksheets/tables, columns, expected types and relationships.

For new Power BI Vibes-managed projects, ChatGPT should create deterministic synthetic development data that exercises realistic edge cases. Existing brownfield repositories should use their current safe fixtures when adequate.

## 6. Approve material plans when needed

Before large-scale greenfield authoring, ChatGPT should summarize the proposed tool in plain language: intended users, pages/functions, important calculations, filters/interactions, source assumptions and unresolved business decisions.

For an existing project, ChatGPT should scope the proposed change against the existing system. Small fixes do not require a greenfield planning cycle. Material redesigns, migrations, framework adoption, and architecture changes should be made explicit before implementation.

## 7. Let ChatGPT make authorized changes in GitHub

ChatGPT can write the project repository when its connected GitHub tools have write access and the current task authorizes mutation.

Structural validation and Power BI Desktop rendering are separate checks and must be reported honestly. If the current environment cannot execute a validator or Power BI Desktop, ChatGPT should mark that check **pending** rather than treating a successful GitHub commit as a Power BI validation result.

For existing projects, write access must not be treated as permission for opportunistic cleanup, restructuring, or Power BI Vibes scaffold installation.

## 8. Use `/repo-recon` when you want an explicit repository map

Power BI Vibes automatically performs the necessary repository classification during bootstrap. You can also explicitly request the non-mutating reconnaissance lens:

```text
/repo-recon
```

or:

```text
/repo-recon the semantic model and source architecture
```

It should return a compact map of the existing Power BI implementation, data/source boundaries, validation capability, relevant conventions, material unknowns, and the smallest justified next action. The command does not edit the repository.

## 9. Prepare the Windows computer only when local QA is needed

When ChatGPT says the project is ready for local Power BI testing, follow [`docs/WINDOWS-SETUP.md`](docs/WINDOWS-SETUP.md).

The normal local requirements are:

- Power BI Desktop;
- Git for Windows;
- PowerShell;
- browser-based GitHub authentication for the private repository.

GitHub CLI and GitHub Desktop are optional. SQLite CLI is optional unless the local schema inspector needs to inspect a SQLite database.

For a Power BI Vibes-managed repository, after cloning, run the included readiness checker:

```powershell
.\scripts\check-local-setup.ps1 -RepositoryUrl https://github.com/OWNER/PROJECT.git
```

For a brownfield repository, use its existing setup/readiness instructions first when present.

## 10. Clone to a short local path

For a first local copy:

```powershell
New-Item -ItemType Directory -Path C:\PBI -Force | Out-Null
git clone https://github.com/OWNER/PROJECT.git C:\PBI\PROJECT
cd C:\PBI\PROJECT
```

If `C:\PBI` is unavailable, use a short user-owned path:

```powershell
New-Item -ItemType Directory -Path "$env:USERPROFILE\PBI" -Force | Out-Null
git clone https://github.com/OWNER/PROJECT.git "$env:USERPROFILE\PBI\PROJECT"
cd "$env:USERPROFILE\PBI\PROJECT"
```

On the first private-repository operation, Git Credential Manager may open a browser sign-in. Complete the GitHub account, organization/SSO and two-factor prompts that apply.

## 11. Open and test in Power BI Desktop

Before the first PBIP/PBIR open, ChatGPT should check current Microsoft requirements for the exact format in the repository and tell you whether a particular Desktop version or preview feature is required.

ChatGPT should then provide task-based QA instructions such as a specific filter/action and the expected result.

## 12. Pull safely after Power BI Desktop has touched the project

Before pulling newer changes into a local copy that has been opened or saved in Power BI Desktop:

```powershell
git status --short --branch
```

If the working tree is clean:

```powershell
git pull --ff-only
```

If files are modified, stop and give the status output to ChatGPT. Power BI Desktop saves can modify tracked PBIP/PBIR/TMDL files. Preserve local edits before resolving local/remote divergence and follow stricter repository-specific synchronization rules when present.

## 13. Connect the real data locally

After safe/synthetic QA passes, change the project's approved source parameter/connection to the operational source locally when that is how the project is designed.

First refresh may ask for credentials or a data-source privacy level. Run the production-data smoke test locally. Do not send screenshots, exports, logs, or copied rows back to ChatGPT if they expose information you are not permitted to share.

## 14. Request changes normally

Continue with ordinary-language requests. ChatGPT should translate them into technical changes, validate them as far as the available environment allows, and keep the repository understandable.

Power BI Vibes-managed projects maintain a small learning log for durable implementation lessons so later agent sessions do not repeatedly rediscover solved problems. Brownfield repositories do not receive that framework metadata unless you intentionally adopt Power BI Vibes into the project.

## If something goes wrong

Tell ChatGPT what you observed and provide a screenshot only if it is safe to share. ChatGPT should inspect repository state and validation output before giving one concrete recovery or test step at a time.

Do not delete the repository and start over unless recovery is genuinely more expensive than repair.
