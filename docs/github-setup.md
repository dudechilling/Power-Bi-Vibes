# Create Your Private Project Repository

Each Power BI Vibes project should have its own GitHub repository. For organization-specific work, create it as **Private** unless your organization explicitly approves public storage.

## 1. Sign in to GitHub

Go to `https://github.com/new` and use the account that should own or access the project.

## 2. Choose the owner

Select your personal GitHub account or the organization that should own the project. For employer/client work, use their approved GitHub organization when available.

## 3. Give the repository a short name

Use a short descriptive name such as `regional-project-tracker`, `cost-benchmark-tool`, or `operations-dashboard`. Short names also help keep local Power BI paths manageable.

## 4. Set visibility to Private

Select **Private**. A private repository can still contain sensitive material; the setting is not permission to upload production operational data, credentials, secrets, or restricted records.

## 5. Initialize with a README

Turn **Add README** on. This creates the first commit and a normal `main` branch. Leave `.gitignore` and license unset unless your organization requires otherwise.

## 6. Create the repository

Select **Create repository** and copy the repository URL:

```text
https://github.com/OWNER/PROJECT
```

## 7. Give ChatGPT access

Connect GitHub to ChatGPT and ensure the connected account/workspace can access the repository.

Then use the bootstrap prompt from the root `README.md` or `prompts/BOOTSTRAP.txt`. The agent should read root `AGENTS.md`, then follow `workflows/bootstrap.md`, inspect the project before writing, establish the job and Power BI fit, and initialize only when appropriate.

## 8. Local Git comes later

You do not need Git installed before the agent starts repository work. When local Power BI Desktop testing becomes necessary, follow [`windows-setup.md`](windows-setup.md).