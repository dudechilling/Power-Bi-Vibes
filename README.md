# Power BI Vibes

**Build and maintain Power BI projects by describing what you need in ordinary language.**

Power BI Vibes gives ChatGPT and compatible coding agents a set of rules for working safely with Power BI projects stored in GitHub.

You explain the work. The agent handles most repository, Git, Power BI project, DAX, Power Query, and implementation details. When Power BI Desktop or your real data is required, it gives you the local steps to perform.

## You do not need to know

- Git commands
- DAX
- Power Query
- PBIR or TMDL
- how coding agents work internally

You should understand the work the Power BI project needs to support and what information you are permitted to share.

## Start here

### I am starting a new Power BI project

1. Create a private GitHub repository.
2. Connect GitHub to ChatGPT or another compatible agent.
3. Copy the new repository URL.
4. Paste the bootstrap prompt below.
5. Describe what you want the Power BI tool to help you do.

See [`docs/github-setup.md`](docs/github-setup.md) for click-by-click GitHub setup.

### I already have a Power BI project

Use the repository that already contains it. Do not create a blank replacement repository.

Give the agent the existing repository and describe what you want explained, fixed, changed, or added. Power BI Vibes tells the agent to inspect the existing project before changing it.

## Copy this into your agent

```text
I want to work on a Power BI project.

Use this framework:
https://github.com/dudechilling/Power-Bi-Vibes

My project repository is:
<PASTE YOUR PROJECT REPOSITORY URL>

My local clone is:
<PASTE YOUR LOCAL PATH HERE OR WRITE "not cloned yet">

Read AGENTS.md first, then follow workflows/bootstrap.md.

Inspect the project repository before assuming whether it is new, existing, or already managed by Power BI Vibes. Do not modify an existing implementation until you understand its current structure and my requested task.

Do not ask me to share operational data that I am not permitted to share.
```

The same prompt is available in [`prompts/BOOTSTRAP.txt`](prompts/BOOTSTRAP.txt).

## How the pieces fit together

| Part | What it does |
| --- | --- |
| **You** | Explain the job, business meaning, constraints, permissions, and whether the result works. |
| **Agent** | Reads and changes project files, writes implementation logic, diagnoses problems, and tells you what needs local testing. |
| **GitHub** | Stores the project and its change history. |
| **Power BI Desktop** | Opens, renders, refreshes, and interactively tests the Power BI project on your computer. |

```text
You describe the job
        ↓
Agent works in GitHub
        ↓
Project files are created or changed
        ↓
Power BI Desktop tests the result when needed
        ↓
You review and continue
```

## What the agent handles

The agent can inspect repository structure, understand existing Power BI projects, create or edit project files, write Power Query/DAX/configuration, maintain repository history, create safe synthetic test data when appropriate, validate what its environment can actually validate, and give exact local QA steps when Power BI Desktop is required.

You remain responsible for business meaning, data-sharing permissions, access decisions, destructive or publishing actions, and acceptance of the finished result.

## Before sharing data

Power BI Vibes does not require production data to be stored in GitHub.

If real data is sensitive, the agent can often work from existing project structure, a scrubbed example, a metadata-only schema report, a manually described schema, or deterministic synthetic data.

Schema, screenshots, logs, field names, URLs, file paths, and internal terminology can also be sensitive. Share only what you are permitted to share.

## When Power BI Desktop becomes necessary

Local setup can wait until the work needs Desktop rendering, refresh, or interactive QA. See [`docs/windows-setup.md`](docs/windows-setup.md).

There are two separate GitHub connections:

- **Agent -> GitHub:** lets the agent read or change the repository online.
- **Your computer -> GitHub:** lets your local Git installation clone, pull, and push later.

Setting up one does not set up the other.

## Common terms

**Repository / repo** — the project folder stored on GitHub.

**Local clone** — a copy of that repository on your computer.

**Commit** — a saved set of repository changes.

**Agent** — ChatGPT or another AI system that can inspect files, use tools, and make authorized changes.

**PBIP** — Power BI's project format where report/model content is stored as source files rather than only inside one `.pbix` file.

## Full walkthrough

Read [`docs/getting-started.md`](docs/getting-started.md) for the complete beginner workflow from repository creation through local Power BI Desktop testing.

The generated PDF guide remains available at [`docs/Power-BI-Vibes-Guide.pdf`](docs/Power-BI-Vibes-Guide.pdf).

## Optional agent commands

Power BI Vibes includes optional analytical prompt conventions for challenging a design, finding blind spots, exploring analytical value, simplifying a project, choosing the next action, and mapping an unfamiliar repository.

Examples:

```text
/stress-test this dashboard design
/data-savant the current project
/repo-recon
```

See [`commands/README.md`](commands/README.md).

## Repository structure

- `AGENTS.md` — canonical always-read agent policy.
- `CLAUDE.md` — thin Claude Code wrapper that imports `AGENTS.md`.
- `workflows/` — procedures such as bootstrap and client updates.
- `policy/` — domain policy loaded only when relevant: data, Git, privacy, QA, learning, and Power BI routing.
- `commands/` — optional user-invoked analytical lenses.
- `templates/client/` — the exact structure installed into managed client repositories.
- `docs/` — human onboarding and setup guides.
- `maintainer/` — framework-only maintenance, release, and evaluation material.
- `tools/` — framework build and integrity tooling.
- `prompts/` — copy/paste bootstrap, resume, and update prompts.
- `UPSTREAM.lock.yml` — the tested Microsoft Power BI authoring dependency pin.

## Core boundaries

- Do not put production operational data in this public framework repository.
- Treat substantive existing repositories as read-only until the agent understands their relevant structure and the requested operation.
- Repository write capability is not permission to scaffold, restructure, or clean up an existing project.
- Treat structural validation and Power BI Desktop rendering as separate checks and report unavailable checks as pending.
- Preserve local Power BI Desktop edits before pulling or resetting repository state.
- Keep durable project memory selective rather than turning the repository into an agent notebook.

## For framework contributors

Framework maintenance rules are in [`maintainer/framework.md`](maintainer/framework.md); release checks are in [`maintainer/release.md`](maintainer/release.md). Ordinary users do not need these files.