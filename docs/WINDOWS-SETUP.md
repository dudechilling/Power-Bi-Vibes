# Windows Local Setup

Use this guide when ChatGPT says the project is ready for local Power BI Desktop testing. You do not need to complete this setup before ChatGPT starts building in GitHub.

## Required for normal local work

A standard Power BI Vibes Windows machine needs:

- Power BI Desktop;
- Git for Windows;
- Windows PowerShell or PowerShell;
- a web browser for GitHub authentication;
- access to the private GitHub project repository.

GitHub CLI, GitHub Desktop, Python, Visual Studio Code, and Microsoft Excel are not required for the normal workflow.

`sqlite3.exe` is optional and is needed only when you want `scripts/inspect-source.ps1` to inspect a SQLite/SQLite3/DB file locally.

## 1. Check whether Git is already installed

Open PowerShell and run:

```powershell
git --version
```

If Git returns a version, continue to the next section.

If PowerShell says `git` is not recognized, install the current Git for Windows release. If `winget` is available, the official Git for Windows package can be installed with:

```powershell
winget install --id Git.Git -e --source winget
```

Otherwise use the official Git for Windows installer:

https://git-scm.com/install/windows

Close and reopen PowerShell after installation so the updated PATH is available.

GitHub recommends Git Credential Manager (GCM) or GitHub CLI for HTTPS credentials. Git for Windows includes GCM, so Power BI Vibes uses HTTPS + GCM as the default rather than requiring GitHub CLI or SSH keys:

https://docs.github.com/en/get-started/git-basics/caching-your-github-credentials-in-git?platform=windows

## 2. Configure your Git identity once

Local rescue commits and any changes you intentionally commit from Power BI Desktop need an author name and email.

```powershell
git config --global user.name "Your Name"
git config --global user.email "YOUR-GITHUB-EMAIL"
```

Check them:

```powershell
git config --global --get user.name
git config --global --get user.email
```

The email identifies commits. It is not your GitHub login credential. If you prefer to keep your personal email out of commit metadata, use the GitHub-provided no-reply address associated with your account.

## 3. Use the repository HTTPS address

In GitHub, open your private project repository and select **Code > Local > HTTPS**, then copy the repository address.

It should look like:

```text
https://github.com/OWNER/PROJECT.git
```

HTTPS is the default Power BI Vibes transport because it works cleanly with Git Credential Manager and avoids requiring the user to configure SSH keys.

## 4. Verify GitHub authentication

If the repository was created with a README, this command can test read access without cloning it:

```powershell
git ls-remote https://github.com/OWNER/PROJECT.git HEAD
```

On the first HTTPS operation, Git Credential Manager may open a browser window. Sign in to the GitHub account that has access to the repository. Complete any organization authorization, SSO, or two-factor-authentication prompts that apply.

GitHub account passwords are not used as Git HTTPS passwords. If an old-style username/password prompt appears instead of the expected browser/GCM flow, update Git for Windows and give the exact error to ChatGPT rather than repeatedly entering credentials.

## 5. Clone to a short path

Power BI project files can become deeply nested. Prefer a short local path.

```powershell
New-Item -ItemType Directory -Path C:\PBI -Force | Out-Null
git clone https://github.com/OWNER/PROJECT.git C:\PBI\PROJECT
cd C:\PBI\PROJECT
```

If you cannot write to `C:\PBI`, use a short folder under your Windows profile:

```powershell
New-Item -ItemType Directory -Path "$env:USERPROFILE\PBI" -Force | Out-Null
git clone https://github.com/OWNER/PROJECT.git "$env:USERPROFILE\PBI\PROJECT"
cd "$env:USERPROFILE\PBI\PROJECT"
```

## 6. Run the Power BI Vibes readiness check

Every new Power BI Vibes client repository should contain `scripts/check-local-setup.ps1`.

From the cloned project folder:

```powershell
.\scripts\check-local-setup.ps1 -RepositoryUrl https://github.com/OWNER/PROJECT.git
```

The checker is read-only. It reports whether Git, Git identity, GitHub read access, Power BI Desktop, the preferred workspace, Git Credential Manager, and optional tools are available. It does not install software, change Git configuration, or modify the repository.

If you also want a non-mutating Git push-permission test from inside the clone:

```powershell
.\scripts\check-local-setup.ps1 -RepositoryUrl https://github.com/OWNER/PROJECT.git -TestPush
```

`-TestPush` uses `git push --dry-run`; it does not publish a commit. A protected branch or organizational policy can still reject the dry run even when your account otherwise has repository access, so give the reported result to ChatGPT if it fails.

## 7. Confirm Power BI Desktop requirements

Power BI Desktop must be installed before local report rendering or Desktop QA. Use your organization's approved installation method.

PBIP/PBIR support and preview-feature requirements can change by Power BI Desktop version. Before the first project open, ChatGPT should check current Microsoft guidance for the exact project/report format it created and tell you whether a particular version or setting is required.

## 8. Open the project only after the clone is healthy

Check repository state:

```powershell
git status --short --branch
git remote -v
```

Then open the `.pbip` file under `powerbi/` as instructed by ChatGPT.

After Power BI Desktop has saved the project, always inspect `git status` before pulling newer GitHub changes. Power BI Desktop can update tracked PBIP/PBIR/TMDL files.

## Optional: SQLite schema inspection

CSV/TSV and XLSX/XLSM schema inspection uses Windows/.NET capabilities already available to the script. SQLite inspection additionally requires `sqlite3.exe` on PATH.

Check for it with:

```powershell
sqlite3 --version
```

If it is missing and you need SQLite inspection, ask ChatGPT for the current approved installation route for your environment. Do not install extra software merely because it appears in this optional section.

## Common failures

### `git` is not recognized

Install or update Git for Windows, close all PowerShell windows, open a new PowerShell window, and rerun `git --version`.

### Browser authentication does not open

Check:

```powershell
git credential-manager --version
```

If Git Credential Manager is unavailable, update Git for Windows. Corporate device policy may also control credential helpers.

### Repository not found / 404

Usually the repository URL is wrong or the signed-in GitHub account cannot access the private repository. Confirm the URL in GitHub and confirm ChatGPT/local Git are using the intended account.

### 403 / SSO authorization failure

The GitHub account may have repository access but still require organization or SSO authorization. Complete the organization-provided authorization flow or contact the organization's GitHub administrator.

### Push rejected

Do not force-push. Give ChatGPT the exact output. Common causes include missing write permission, branch protection, a remote commit you have not pulled, or a local/remote divergence that needs deliberate recovery.

## What Power BI Vibes should do for the user

The agent should not send a nontechnical user through this guide at project kickoff. Build in GitHub first. When the first local Desktop action becomes necessary, provide the smallest relevant setup step, then use the readiness checker and proceed to clone/QA.
