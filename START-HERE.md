# Start Here

Power BI Vibes is designed so you can describe your work in ordinary language and let ChatGPT handle most Power BI and repository mechanics.

## What you need at the beginning

You need:

- a GitHub account;
- a new private GitHub repository for your Power BI project;
- ChatGPT with GitHub connected and permission to work with that repository.

You do **not** need Git, GitHub Desktop, GitHub CLI, Power BI Desktop, DAX knowledge, or Power Query knowledge before ChatGPT starts building.

The local Windows setup can wait until the first Power BI Desktop handoff.

## 1. Create your private project repository

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

A private repository is still subject to your organization's data-handling rules. Do not treat the Private setting as permission to upload restricted production records, credentials, or secrets.

## 2. Connect GitHub to ChatGPT

Connect GitHub in ChatGPT and make sure ChatGPT can access the private repository you just created. The exact controls can vary by ChatGPT plan and workspace policy.

The GitHub connection inside ChatGPT is separate from the GitHub authentication your Windows computer will use later for `git clone`, `git pull`, and `git push`.

## 3. Start the project

Paste this into a new ChatGPT conversation and replace the project URL:

```text
I want to build a Power BI tool.

Use this framework:
https://github.com/dudechilling/Power-Bi-Vibes

My private project repository is:
<PASTE YOUR PRIVATE GITHUB REPOSITORY URL>

Read BOOTSTRAP.md in Power-Bi-Vibes and follow it. Do not ask me to share operational data that I am not permitted to share.
```

ChatGPT should inspect both repositories, ask what you want the tool to help you do, confirm Power BI is a reasonable fit, and then initialize the private project repository.

## 4. Describe the job, not the implementation

Explain the problem in the language you already use at work. Useful information includes what you do now, what is difficult to see, who will use the tool, what decisions it should support, what the finished tool should make easier, where the source data comes from, and how often that source changes.

You usually do not need to decide which charts, DAX measures, data model structure, or Power BI internals to use. ChatGPT should propose those based on the job and the data.

## 5. Give ChatGPT a safe representation of the data

If you are permitted to share the real source, you can use it. If the source contains restricted operational information, use one of these approaches instead:

**Scrubbed/template file** - keep useful structure while removing sensitive records.

**Schema report** - run `scripts/inspect-source.ps1` locally and review the resulting JSON before sharing it. The script intentionally omits row values, but schema and internal terminology can still be sensitive.

**Manually described schema** - tell ChatGPT the worksheets/tables, columns, expected types and relationships.

ChatGPT should create deterministic synthetic development data that exercises realistic edge cases.

## 6. Approve the tool plan

Before large-scale authoring, ChatGPT should summarize the proposed tool in plain language: intended users, pages/functions, important calculations, filters/interactions, source assumptions and unresolved business decisions.

Correct terminology and business meaning at this stage. ChatGPT should handle routine technical implementation choices itself.

## 7. Let ChatGPT build in GitHub

ChatGPT can write the project repository when its connected GitHub tools have write access. Structural validation and Power BI Desktop rendering are separate checks and must be reported honestly.

If the current environment cannot execute a validator or Power BI Desktop, ChatGPT should mark that check **pending** rather than treating a successful GitHub commit as a Power BI validation result.

## 8. Prepare the Windows computer only when local QA is needed

When ChatGPT says the project is ready for local Power BI testing, follow [`docs/WINDOWS-SETUP.md`](docs/WINDOWS-SETUP.md).

The normal local requirements are:

- Power BI Desktop;
- Git for Windows;
- PowerShell;
- browser-based GitHub authentication for the private repository.

GitHub CLI and GitHub Desktop are optional. SQLite CLI is optional unless the local schema inspector needs to inspect a SQLite database.

After cloning the project, run the included readiness checker:

```powershell
.\scripts\check-local-setup.ps1 -RepositoryUrl https://github.com/OWNER/PROJECT.git
```

The checker does not install software or change Git configuration. It reports missing requirements so ChatGPT can give the next exact step.

## 9. Clone to a short local path

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

## 10. Open and test in Power BI Desktop

Before the first PBIP/PBIR open, ChatGPT should check current Microsoft requirements for the exact format it created and tell you whether a particular Desktop version or preview feature is required.

ChatGPT should then provide task-based QA instructions such as a specific filter/action and the expected result.

## 11. Pull safely after Power BI Desktop has touched the project

Before pulling newer GitHub changes into a local copy that has been opened or saved in Power BI Desktop:

```powershell
git status --short --branch
```

If the working tree is clean:

```powershell
git pull --ff-only
```

If files are modified, stop and give the status output to ChatGPT. Power BI Desktop saves can modify tracked PBIP/PBIR/TMDL files. The framework preserves local edits before resolving local/remote divergence.

## 12. Connect the real data locally

After synthetic QA passes, change the project's named source parameter/connection to the approved operational source on your computer or organizational environment.

First refresh may ask for credentials or a data-source privacy level. Run the production-data smoke test locally. Do not send screenshots, exports, logs, or copied rows back to ChatGPT if they expose information you are not permitted to share.

## 13. Request changes normally

Continue with ordinary-language requests. ChatGPT should translate them into technical changes, validate them as far as the available environment allows, and keep the repository understandable.

The project maintains a small learning log for durable implementation lessons so later agent sessions do not repeatedly rediscover solved problems. Private project lessons are never copied automatically into the public Power BI Vibes framework.

## If something goes wrong

Tell ChatGPT what you observed and provide a screenshot only if it is safe to share. ChatGPT should inspect repository state and validation output before giving one concrete recovery or test step at a time.

Do not delete the repository and start over unless recovery is genuinely more expensive than repair.
