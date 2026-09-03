# Power BI Vibes - Client Guide

## What this is

Power BI Vibes is a workflow for working on Power BI projects with ChatGPT and GitHub while keeping restricted operational data out of the development conversation when necessary.

It supports both new projects and existing Power BI repositories. You explain the job or requested operation and the business meaning. ChatGPT handles most repository and Power BI implementation work while preserving the distinction between GitHub access, local filesystem access, local Git authentication, and Power BI Desktop validation.

## Starting conditions

You need:

- a GitHub account;
- either a new private GitHub repository or an existing project repository you are permitted to work with;
- ChatGPT with GitHub connected and permission to read the project repository;
- write permission only when the task actually requires repository mutation.

If you already have a local clone, include its path in the bootstrap prompt. The path gives ChatGPT useful context about the user's working copy, but it does not prove the current ChatGPT environment can access that filesystem location or use the user's local Git credentials.

You do not need to install new tooling merely to begin repository reconnaissance. Local setup matters when the task actually requires the local clone or Power BI Desktop.

## Choose a starting path

### New Power BI project

For a new project, create a private GitHub repository initialized with a README. See `docs/CREATE-PRIVATE-REPO.md` for the full instructions.

A README-only repository is treated as greenfield. Power BI Vibes should first understand the job and confirm Power BI fit before installing a Power-BI-specific scaffold.

### Existing Power BI repository

Use the repository that already contains the implementation. Do not create a blank replacement just to use Power BI Vibes.

Power BI Vibes should inspect and classify the repository before changing it. Existing and unclear repositories remain read-only during initial reconnaissance. The framework must not install its own scaffold merely because `.power-bi-vibes/` or other framework metadata is absent.

A private repository is still subject to your organization's data-handling rules. Do not treat the Private setting as permission to upload restricted production records, credentials, or secrets.

## Bootstrap prompt

```text
I want to work on a Power BI project.

Use this framework:
https://github.com/dudechilling/Power-Bi-Vibes

My project repository is:
<PASTE YOUR PRIVATE GITHUB REPOSITORY URL>

My local clone is:
<PASTE YOUR LOCAL PATH HERE>

Read BOOTSTRAP.md and follow it.

Inspect the project repository before assuming whether it is new, existing, or already managed by Power BI Vibes. Do not modify an existing implementation until you understand its current structure and my requested task.

Do not ask me to share operational data that I am not permitted to share.
```

If there is no local clone yet, say so or leave the field clearly marked as unavailable. Do not invent a path.

## Repository Mode Gate

Power BI Vibes classifies the target before scaffolding or substantive mutation:

- `greenfield` - empty, README-only, or intentionally blank repository;
- `managed-existing` - existing Power BI Vibes-managed project;
- `brownfield-powerbi` - substantive existing Power BI implementation without Power BI Vibes ownership;
- `unknown-existing` - substantive repository whose relevant architecture or Power BI boundary is not yet clear.

For brownfield and unknown repositories, ChatGPT should inspect read-only first. It should locate the Power BI entrypoint and relevant report/model/source boundaries, understand existing conventions, and establish the requested operation before changing files.

## Describe the job or operation

For a new project, describe what you need the tool to help people do. Power BI Vibes should handle routine technical choices such as model structure, DAX representation, PBIR/TMDL mechanics, and chart selection when the information need makes them clear.

For an existing project, describe the operation you need, for example:

- explain or reverse engineer the existing implementation;
- debug a failure;
- repair or extend a feature;
- refactor a model or report;
- validate behavior;
- migrate or adopt framework conventions.

ChatGPT should understand the relevant existing implementation before resetting the conversation to generic product discovery.

## Restricted data

If the real source contains information you cannot share, do not upload it merely to make development easier.

Use the least revealing representation that resolves the task:

1. permitted structural evidence already present in the repository;
2. approved real sample when explicitly permitted;
3. scrubbed/template source;
4. metadata-only schema report generated locally;
5. manually described schema.

Schema, screenshots, logs, URLs, connection metadata, table names and internal terminology can also reveal restricted information. Treat them according to the same organizational rules as the underlying data.

## Synthetic development data

New Power BI Vibes-managed projects should use deterministic fictional data that matches the permitted structure and deliberately exercises important edge cases.

Existing brownfield repositories should keep their current safe fixture/test conventions when those are adequate. Power BI Vibes should not replace an established source/testing architecture merely to impose its own pattern.

Synthetic QA proves implementation behavior against the fixture. It does not prove that the real dataset has the same distribution, cleanliness, scale, or performance characteristics.

## Planning and implementation

For a new project, ChatGPT should summarize the proposed tool in plain language before large-scale authoring: intended users, pages/functions, important calculations, filters/interactions, source assumptions and unresolved business decisions.

For an existing project, the plan should be scoped against the existing system. Small fixes do not require a greenfield planning cycle. Material redesigns, migrations, framework adoption and architecture changes should be made explicit before implementation.

Repository write capability is not permission to restructure an existing project. ChatGPT should distinguish the requested edit from opportunistic cleanup.

## Optional analytical commands

Power BI Vibes defines user-invoked prompt conventions under `commands/`. They are not native ChatGPT slash commands.

Available commands include:

- `/commands` - show the command menu;
- `/premature-framing` - challenge solution assumptions embedded in the current framing;
- `/data-savant` - find overlooked analytical value the available data can defensibly support;
- `/blind-spots` - surface consequential assumptions, omissions, data gaps and operating risks;
- `/stress-test` - try to break the current idea, model, report or workflow with realistic failure modes;
- `/simplify` - identify complexity that can be removed, deferred, consolidated or automated;
- `/what-next` - identify the highest-value next decision, test or validation step;
- `/repo-recon` - perform non-mutating architectural reconnaissance of an existing Power BI repository.

Examples:

```text
/repo-recon
```

```text
/repo-recon the semantic model and source architecture
```

```text
/stress-test the forecasting logic
```

These commands are non-mutating by default. `/repo-recon` complements the automatic Repository Mode Gate; it is not the safety mechanism that triggers classification.

## Local clone and capability separation

The bootstrap prompt asks for the local clone path because existing Power BI projects often have a working copy that matters to debugging, Desktop testing, generated files, or local changes.

Keep these capabilities separate:

- ChatGPT GitHub read/write authorization;
- access from the current execution environment to the user's local filesystem path;
- the user's local Git/GitHub authentication;
- local command execution;
- Power BI Desktop availability/control.

A GitHub write does not prove the user's clone is current. A supplied Windows path does not prove ChatGPT can open it. A local clone does not prove Git authentication is configured.

## Prepare the Windows computer when local work is needed

At the first Desktop or local-clone handoff, the normal local stack is:

- Power BI Desktop;
- Git for Windows;
- PowerShell;
- browser-based GitHub authentication for the project repository.

GitHub CLI, GitHub Desktop, Python and Visual Studio Code are not required for the normal workflow. SQLite CLI is needed only when locally inspecting a SQLite database schema.

See `docs/WINDOWS-SETUP.md` for setup and troubleshooting.

For a Power BI Vibes-managed repository, after cloning, run:

```powershell
.\scripts\check-local-setup.ps1 -RepositoryUrl https://github.com/OWNER/PROJECT.git
```

For a brownfield repository, use its existing setup/readiness instructions first when present.

## Local Power BI testing

For a first clone when one does not already exist:

```powershell
New-Item -ItemType Directory -Path C:\PBI -Force | Out-Null
git clone https://github.com/OWNER/PROJECT.git C:\PBI\PROJECT
cd C:\PBI\PROJECT
```

Before pulling newer changes into a copy that has been opened or saved in Power BI Desktop:

```powershell
git status --short --branch
```

If the tree is clean and repository policy permits:

```powershell
git pull --ff-only
```

If files are modified, stop and preserve local edits before resolving divergence. Desktop saves can modify tracked PBIP/PBIR/TMDL source.

Before the first local open, ChatGPT should check current Microsoft requirements for the exact PBIP/PBIR format and report whether Desktop version or preview-feature settings need attention.

## Production source

After safe/synthetic QA passes, connect the approved operational source locally when that is how the project is designed.

First refresh can require credentials or a data-source privacy choice. Test refresh, totals, relationships and performance locally. Do not send production screenshots, copied records, exports or logs back to ChatGPT when they expose restricted information.

## Project learning and framework adoption

Power BI Vibes-managed projects keep a small machine-readable learning log for durable observations, confirmed lessons and project patterns.

A brownfield repository does not receive `.power-bi-vibes/` metadata merely because Power BI Vibes is helping with it. Adopting Power BI Vibes project metadata into an existing repository is a separate decision.

Private lessons are never copied automatically into the public Power BI Vibes framework. Upstream promotion requires abstraction and human privacy/generality review.

## Repository and document integrity

The framework includes automated integrity checks for required files, version consistency, relative links, YAML structure, client-scaffold mappings, local-setup packaging, command registration, and generated documentation.

Repository-mode behavior is documented through representative evaluation cases in `docs/REPOSITORY-MODE-EVALS.md`.

Generated PDFs are build outputs and must be rebuilt and visually verified before a release claims the source and PDF are synchronized.

## What "done" means

A feature is ready when the applicable structural checks actually passed, the requested data-bound behavior exists, rendered layout was actually checked when required, requested interactions work, and acceptance steps are current.

If a validator or Desktop check cannot run in the current environment, that check stays pending rather than being inferred from a successful repository write.

For brownfield tasks, completion applies to the requested scope unless the user explicitly asked for a wider audit or migration.
