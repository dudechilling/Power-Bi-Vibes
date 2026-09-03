# Power BI Vibes

**Build, understand, debug, repair, extend, and maintain useful Power BI tools with ChatGPT, GitHub, and privacy-safe development data.**

Power BI Vibes is a public, machine-readable workflow for people who understand their work but do not need to understand DAX, TMDL, PBIR, Power Query, or Git internals.

It supports two primary starting conditions:

- **new project** - a greenfield repository that Power BI Vibes can initialize after understanding the job and confirming Power BI fit;
- **existing project** - a substantive Power BI repository that must be classified and inspected read-only before any mutation.

The basic pattern is:

1. Give ChatGPT this framework repository and the project repository.
2. Tell ChatGPT to read [`BOOTSTRAP.md`](BOOTSTRAP.md).
3. ChatGPT inspects the target first and runs the Repository Mode Gate: `greenfield`, `managed-existing`, `brownfield-powerbi`, or `unknown-existing`.
4. For greenfield work, describe the job before ChatGPT creates a Power-BI-specific scaffold.
5. For brownfield work, ChatGPT maps the existing implementation before debugging, repairing, extending, reverse engineering, refactoring, validating, or migrating it.
6. Provide only data you are permitted to share. For restricted operational data, use existing permitted repository structure, a scrubbed/template file, or a locally generated schema report.
7. Power BI Vibes-managed projects use deterministic synthetic data and swappable source boundaries. Existing repositories keep their established source/test conventions unless the requested work justifies changing them.
8. Use optional Power BI Vibes analytical commands when you want to challenge framing, surface blind spots, mine the data for overlooked value, stress-test the design, simplify it, decide what to do next, or explicitly map an unfamiliar repository.
9. When local QA becomes necessary, use the supplied local clone when one exists or prepare the Windows machine with Git for Windows and Power BI Desktop, authenticate local Git separately from ChatGPT, and clone the project.
10. Structural validation and Power BI Desktop rendering are treated as separate checks: ChatGPT only claims them when the required tooling actually ran.
11. Connect the real operational source locally when appropriate and perform the production-data smoke test on your own machine.
12. Power BI Vibes-managed projects record durable lessons so later agent sessions do not have to rediscover the same implementation knowledge.

## Start here

For a nontechnical walkthrough, read [`START-HERE.md`](START-HERE.md) or the PDF guide in [`docs/Power-BI-Vibes-Guide.pdf`](docs/Power-BI-Vibes-Guide.pdf).

If you are starting a new project, [`docs/CREATE-PRIVATE-REPO.md`](docs/CREATE-PRIVATE-REPO.md) gives click-by-click GitHub setup. If you already have a Power BI repository, use that repository directly; do not create a blank replacement just to use the framework.

Local setup guidance is in [`docs/WINDOWS-SETUP.md`](docs/WINDOWS-SETUP.md).

### Bootstrap prompt

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

If no local clone exists yet, replace the local-path placeholder with `not cloned yet`. A local path is context, not a requirement to use local tooling immediately.

## Repository modes

`BOOTSTRAP.md` requires classification before scaffolding or mutation:

- `greenfield` - empty, README-only, or intentionally blank repository;
- `managed-existing` - existing Power BI Vibes-managed project;
- `brownfield-powerbi` - substantive existing Power BI implementation without Power BI Vibes ownership;
- `unknown-existing` - substantive repository whose relevant architecture or Power BI boundary is not yet clear.

Brownfield and unknown repositories stay read-only during reconnaissance. Power BI Vibes must not install its scaffold merely because framework metadata is absent.

## Analytical commands

Power BI Vibes includes optional command-style prompts under [`commands/`](commands/). These are framework conventions, not native ChatGPT slash commands. Start a message with a command trigger and optionally add a target.

Available commands:

- `/commands` - show the command menu.
- `/premature-framing` - challenge embedded solution assumptions and recover the underlying problem or job.
- `/data-savant` - identify overlooked analytical value the current data can defensibly support.
- `/blind-spots` - surface consequential assumptions, omissions, data gaps, and operating risks.
- `/stress-test` - try to break the current idea, model, report, or workflow with realistic failure modes.
- `/simplify` - identify complexity that can be removed, deferred, consolidated, or automated.
- `/what-next` - identify the highest-value next decision, test, or validation step.
- `/repo-recon` - perform non-mutating architectural reconnaissance of an existing Power BI repository.

`/repo-recon` is useful when you explicitly want a compact system map before debugging or changing an unfamiliar repository. It complements, but does not replace, the automatic Repository Mode Gate.

These commands are **non-mutating by default**. They return analysis and recommendations; ChatGPT should wait for the user to choose what to implement before changing the project. See [`commands/README.md`](commands/README.md) and [`commands/registry.yml`](commands/registry.yml).

## Copy/paste response convention

When ChatGPT gives the user material intended to be transferred into another tool, Power BI Vibes treats copyability as part of the interface.

- Prompts for another LLM, coding agent, or ChatGPT session should use fenced code blocks.
- PowerShell, shell commands, SQL, DAX, M, code, JSON, YAML, configuration, and similar runnable or paste-ready material should use fenced code blocks with a useful language tag where appropriate.
- Other ChatGPT response elements with strong copy/paste behavior can be used when they fit the material better.
- Markdown blockquotes should be reserved for actual quoted material, not prompts, commands, code, or configuration the user is expected to paste elsewhere.
- Explanatory prose should remain outside the copy/paste block unless it is intentionally part of the material to transfer.

## What this repository contains

- `BOOTSTRAP.md` - the canonical entrypoint for classifying, starting, adopting, auditing, or resuming a client project.
- `AGENTS.md` - rules for agents working on this framework itself.
- `framework/` - durable operating rules for privacy, repository mutation boundaries, project structure, Git, data contracts, QA, learning, and Microsoft Power BI skill routing.
- `commands/` - optional user-invoked analytical lenses plus a machine-readable command registry.
- `templates/` - files ChatGPT can install into a new or explicitly adopted Power BI Vibes client project.
- `scripts/check-local-setup.ps1` - read-only Windows/Git/GitHub/Power BI readiness checker copied into managed client projects.
- `scripts/inspect-source.ps1` - local metadata-only inspector for CSV, TSV, XLSX/XLSM, and SQLite sources.
- `scripts/repo_integrity.py` - repository/document integrity checks used by CI.
- `prompts/` - copy/paste bootstrap, resume, and update prompts.
- `docs/CREATE-PRIVATE-REPO.md` - first-time GitHub repository setup for greenfield projects.
- `docs/WINDOWS-SETUP.md` - first-time Windows/local Git setup.
- `docs/Power-BI-Vibes-Guide.md` - canonical human guide source.
- `docs/build_guide.py` - reproducible PDF builder for the human guide.
- `docs/Power-BI-Vibes-Guide.pdf` - generated client guide.
- `UPSTREAM.lock.yml` - the tested Microsoft Power BI authoring dependency and immutable commit pin.

## Core boundaries

- **No production operational data in this public repository.**
- **No production operational data in client GitHub repositories unless the client explicitly permits it.**
- **Classify substantive existing repositories before mutation.**
- **Repository write capability is not permission to scaffold, restructure, or clean up an existing implementation.**
- Develop with deterministic synthetic data when production values are restricted and the project needs fixtures.
- Treat schema, worksheet names, formulas, internal terminology, logs, URLs, queries, and screenshots as potentially sensitive too.
- Preserve existing source, Git, and validation conventions in brownfield repositories unless the requested change justifies altering them.
- Keep source locations behind a named Power Query parameter in Power BI Vibes-managed projects so synthetic and production sources can be swapped without rewriting downstream logic.
- Keep managed client repositories on `main` during normal iterative work. Use a branch for substantial experiments that could destabilize an accepted working product.
- Treat ChatGPT GitHub authorization and the user's local GitHub authentication as separate capability checks.
- Treat a supplied local clone path as separate execution context from connected GitHub access; do not assume either one proves access to the other.
- Inspect local Git state before pulling over Power BI Desktop edits.
- Validate structurally and visually before calling a Power BI change complete; mark unavailable checks as pending rather than pretending they ran.
- Treat analytical commands as advisory unless the user explicitly asks to implement their findings.
- Private client lessons can become public framework improvements only after abstraction, privacy review, and human approval.

## Local dependency policy

Do not make users install development tooling at project kickoff unless the current task needs it. ChatGPT can work in the repository first. A supplied local clone path should be used when the current environment can access it and the task benefits from local inspection or execution; otherwise it remains contextual information. At the first local Power BI Desktop handoff, the normal required local stack is Power BI Desktop, Git for Windows, PowerShell, and browser-based GitHub authentication. GitHub CLI and GitHub Desktop are optional. SQLite CLI is required only for local SQLite schema inspection.

## Microsoft Power BI authoring dependency

Power BI Vibes currently targets Microsoft's `powerbi-authoring` plugin from `microsoft/skills-for-fabric`, pinned in [`UPSTREAM.lock.yml`](UPSTREAM.lock.yml). Power BI Vibes does not claim ownership of Microsoft's materials. See [`THIRD_PARTY_NOTICES.md`](THIRD_PARTY_NOTICES.md).

## Integrity checks

The repository carries a CI audit that checks required files, version consistency, relative links, YAML parsing, scaffold mappings, command registry/definition consistency, local-setup packaging, and the generated PDF. Repository-mode behavior is also documented through representative evaluation cases in [`docs/REPOSITORY-MODE-EVALS.md`](docs/REPOSITORY-MODE-EVALS.md).

## Status

The current framework adds repository-mode classification, mandatory brownfield reconnaissance before mutation, local-clone context in the bootstrap prompt, and `/repo-recon` for explicit read-only mapping of unfamiliar Power BI repositories. Release/version metadata should only be advanced after the normal release checks and regenerated client guide complete successfully.
