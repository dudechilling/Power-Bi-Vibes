# Windows Local Setup

Use this guide when the agent says the project is ready for local Power BI Desktop testing. You do not need this setup before repository work begins.

## Required for normal local work

A standard Windows machine needs Power BI Desktop, Git for Windows, PowerShell, a web browser for GitHub authentication, and access to the private project repository.

GitHub CLI, GitHub Desktop, Python, Visual Studio Code, and Excel are optional for the normal workflow. `sqlite3.exe` is needed only for local SQLite schema inspection.

## 1. Check Git

```powershell
git --version
```

If Git is missing, install Git for Windows using your approved method. With `winget`:

```powershell
winget install --id Git.Git -e --source winget
```

Git for Windows includes Git Credential Manager, so Power BI Vibes uses HTTPS + browser/GCM authentication by default.

## 2. Configure Git identity

```powershell
git config --global user.name "Your Name"
git config --global user.email "YOUR-GITHUB-EMAIL"
```

The email identifies commits; it is not a GitHub login credential.

## 3. Verify repository access

Copy the repository HTTPS URL from GitHub and test read access:

```powershell
git ls-remote https://github.com/OWNER/PROJECT.git HEAD
```

Git Credential Manager may open a browser sign-in. Complete any organization/SSO/two-factor prompts that apply.

## 4. Clone to a short path

```powershell
New-Item -ItemType Directory -Path C:\PBI -Force | Out-Null
git clone https://github.com/OWNER/PROJECT.git C:\PBI\PROJECT
cd C:\PBI\PROJECT
```

If `C:\PBI` is unavailable, use a short folder under your Windows profile.

## 5. Run the readiness check

Power BI Vibes-managed client repositories include `scripts/check-local-setup.ps1`:

```powershell
.\scripts\check-local-setup.ps1 -RepositoryUrl https://github.com/OWNER/PROJECT.git
```

The checker is read-only. It reports Git, Git identity, GitHub access, Power BI Desktop, workspace, Git Credential Manager, and optional-tool state. It does not install software or change Git configuration.

Optional dry-run push check:

```powershell
.\scripts\check-local-setup.ps1 -RepositoryUrl https://github.com/OWNER/PROJECT.git -TestPush
```

## 6. Confirm Power BI Desktop requirements

PBIP/PBIR requirements can change by Desktop version. Before the first project open, the agent should check current Microsoft guidance for the exact format and tell you whether a version or setting is required.

## 7. Open only after the clone is healthy

```powershell
git status --short --branch
git remote -v
```

Then open the `.pbip` file as instructed. After Power BI Desktop saves the project, inspect `git status` before pulling newer GitHub changes because Desktop can modify tracked PBIP/PBIR/TMDL files.

## Common failures

- **`git` not recognized:** install/update Git for Windows and reopen PowerShell.
- **Browser authentication does not open:** check `git credential-manager --version` and update Git for Windows if GCM is missing.
- **Repository not found / 404:** confirm the URL and signed-in account.
- **403 / SSO failure:** complete organization authorization or contact the GitHub administrator.
- **Push rejected:** do not force-push. Give the exact output to the agent.

## What Power BI Vibes should do

Do not send a nontechnical user through this guide at project kickoff. Build in GitHub first. When the first local Desktop action becomes necessary, provide the smallest relevant setup step and proceed from the readiness results.