# Getting Started with Power BI Vibes

Power BI Vibes lets you describe Power BI work in ordinary language while an agent handles most repository and implementation mechanics.

It supports new Power BI projects and existing repositories that need to be understood, debugged, repaired, extended, reverse engineered, refactored, validated, or migrated.

## What you need at the beginning

You need a GitHub account, a project repository you are permitted to work with, and ChatGPT or another compatible agent with repository access.

You do **not** need Git, GitHub Desktop, GitHub CLI, Power BI Desktop, DAX knowledge, Power Query knowledge, PBIR knowledge, or TMDL knowledge before repository work begins.

## 1. Choose your starting path

### New project

Create a private repository using [`github-setup.md`](github-setup.md). A README-only repository is intentionally treated as a new project.

### Existing Power BI project

Use the repository that already contains the implementation. Do not create a blank replacement repository merely to use Power BI Vibes.

The agent should inspect the existing project first and preserve its architecture and conventions unless the requested change justifies altering them.

## 2. Connect GitHub to your agent

Make sure the agent can access the project repository. ChatGPT's GitHub connection is separate from the GitHub authentication your Windows computer will use later for `git clone`, `git pull`, and `git push`.

Write access is capability, not permission to restructure an existing project.

## 3. Start the session

Paste the prompt from `prompts/BOOTSTRAP.txt`, or use this version:

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

For a new project, the agent should establish what the tool needs to accomplish and confirm Power BI is a reasonable fit before creating project structure.

For an existing project, it should perform bounded read-only reconnaissance before changing anything.

## 4. Describe the job, not the implementation

Explain the problem in the language you already use at work. For a new project, describe what is difficult to see, who will use the tool, what decisions it should support, where the source data comes from, and how often it changes.

For an existing project, describe the operation you need: explain, debug, repair, extend, reverse engineer, refactor, validate, migrate, or another concrete task.

You normally do not need to choose DAX syntax, PBIR/TMDL representation, data-model mechanics, or chart types when the information need makes those choices clear.

## 5. Share only safe project information

A private GitHub repository is still subject to your organization's data-handling rules.

If real source data is restricted, the agent can often work from existing repository structure, a scrubbed/template file, a metadata-only schema report, a manually described schema, or deterministic synthetic development data.

Schema, screenshots, logs, file paths, URLs, field names, and internal terminology can also be sensitive.

## 6. Let the agent implement authorized changes

For a new Power BI Vibes-managed project, the agent installs the client template, records the project contract, and builds in logical batches.

For an existing project, it should make the smallest change required by the requested operation and preserve established conventions where reasonable.

A successful GitHub write is not proof that Power BI Desktop opened, rendered, refreshed, or validated the project. Unavailable checks should be marked pending.

## 7. Understand the four moving parts

| Part | Responsibility |
| --- | --- |
| **You** | Explain the work, business meaning, constraints, permissions, and whether the result is useful. |
| **Agent** | Inspect and change project files, write implementation logic, diagnose problems, and tell you what needs local testing. |
| **GitHub** | Store the project and its change history. |
| **Power BI Desktop** | Open, render, refresh, and interactively test the actual Power BI project on your Windows computer. |

Typical flow:

```text
You describe the job
        ↓
Agent works in GitHub
        ↓
Project files are created or changed
        ↓
Power BI Desktop tests the result when needed
        ↓
You review and request the next change
```

## 8. Prepare Windows only when local QA is needed

When the agent says local Power BI testing is necessary, follow [`windows-setup.md`](windows-setup.md).

The normal local stack is Power BI Desktop, Git for Windows, PowerShell, and browser-based GitHub authentication. GitHub CLI and GitHub Desktop are optional.

Managed projects include a readiness checker:

```powershell
.\scripts\check-local-setup.ps1 -RepositoryUrl https://github.com/OWNER/PROJECT.git
```

If you already supplied a usable local clone, keep using it rather than cloning a second copy.

## 9. Open and test in Power BI Desktop

Before the first PBIP/PBIR open, the agent should check current Microsoft requirements for the exact format in the repository.

The agent should then give task-based QA instructions: the action to perform, the expected result, and any required filter state.

## 10. Pull safely after Desktop edits

Before pulling newer changes into a local copy that has been opened or saved in Power BI Desktop:

```powershell
git status --short --branch
```

If clean:

```powershell
git pull --ff-only
```

If files are modified, stop and give the status output to the agent. Desktop saves can modify tracked PBIP/PBIR/TMDL files and those edits should be preserved deliberately.

## 11. Connect the real data locally

After safe/synthetic QA passes, switch the approved source connection or parameter to the operational source locally when that is how the project is designed.

Run the production-data smoke test locally. Do not send screenshots, exports, logs, or copied rows back to an agent if they expose information you are not permitted to share.

## 12. Continue with ordinary requests

Ask for changes normally. The agent should translate them into technical work, validate as far as available tools allow, and keep durable project memory selective.

## Optional analytical commands

Power BI Vibes includes optional prompt conventions such as `/stress-test`, `/data-savant`, `/blind-spots`, `/simplify`, `/what-next`, and `/repo-recon`. See [`../commands/README.md`](../commands/README.md).

## Terms you will see

**Repository / repo** — the project folder stored on GitHub.

**Local clone** — a copy of that repository on your computer.

**Commit** — a saved set of repository changes.

**Agent** — ChatGPT or another AI system that can inspect files, use tools, and make authorized changes.

**PBIP** — Power BI's project format where report/model content is stored as source files rather than only inside one `.pbix` file.

## If something goes wrong

Tell the agent what you observed and provide only information you are permitted to share. The agent should inspect repository state and validation output before recommending recovery. Do not delete the project and start over unless repair genuinely costs more than recovery from scratch.