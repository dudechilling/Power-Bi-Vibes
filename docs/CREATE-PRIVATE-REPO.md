# Create Your Private Project Repository

Each Power BI Vibes project should have its own GitHub repository. For organization-specific work, create it as **Private** unless your organization explicitly approves public storage.

## 1. Sign in to GitHub

Go to:

https://github.com/new

If GitHub asks you to sign in, use the account that should own or access the project.

## 2. Choose the owner

Under **Owner**, select your personal GitHub account or the organization that should own the project.

If the repository belongs to an employer or client, use their approved GitHub organization when available. Repository ownership affects who controls access later.

## 3. Give the repository a short name

Use a short, descriptive name such as:

- `regional-project-tracker`
- `cost-benchmark-tool`
- `operations-dashboard`

Short names also help keep local Power BI file paths manageable.

## 4. Set visibility to Private

Under **Choose visibility**, select **Private**.

A private repository can still contain sensitive material. Power BI Vibes does not treat GitHub privacy settings as permission to upload production operational data, credentials, secrets, or restricted records.

## 5. Initialize with a README

Turn **Add README** on.

This creates the first commit and a normal `main` branch immediately. It makes the initial ChatGPT/Git/local-clone workflow more predictable than a completely empty repository.

You can leave `.gitignore` and license unset. ChatGPT will add the project-specific files during Power BI Vibes initialization.

## 6. Create the repository

Select **Create repository**.

When GitHub opens the new repository page, copy the browser URL. It should look like:

```text
https://github.com/OWNER/PROJECT
```

That is the project URL you give ChatGPT.

## 7. Give ChatGPT access

Connect GitHub to ChatGPT and make sure the connected GitHub account/workspace can access the new private repository.

Then start a new ChatGPT conversation with:

```text
I want to build a Power BI tool.

Use this framework:
https://github.com/dudechilling/Power-Bi-Vibes

My private project repository is:
https://github.com/OWNER/PROJECT

Read BOOTSTRAP.md in Power-Bi-Vibes and follow it. Do not ask me to share operational data that I am not permitted to share.
```

ChatGPT should inspect the repository before writing, ask what the tool should help you do, check whether Power BI is a reasonable fit, and then initialize the project.

## 8. Local Git comes later

You do not need Git installed on your Windows computer before ChatGPT starts building in GitHub.

When the project is ready for Power BI Desktop testing, follow [`WINDOWS-SETUP.md`](WINDOWS-SETUP.md). That guide covers Git for Windows, GitHub authentication, Git identity, cloning the private repository, and the Power BI Vibes readiness check.
