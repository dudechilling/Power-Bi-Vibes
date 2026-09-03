# Project Agent Instructions

This project uses Power BI Vibes. This file is the local agent policy for the client repository; it must remain usable even when the public framework repository is unavailable.

## Before substantial changes

1. read `.power-bi-vibes/manifest.yml`;
2. read confirmed lessons/patterns in `.power-bi-vibes/learning.yml`;
3. read `_brief/report-spec.md` and `_brief/decisions.md` as relevant;
4. read `config/data-contract.yml` before changing ingestion/model assumptions;
5. read `qa/acceptance.md` before changing accepted behavior;
6. use the Power BI Vibes version/source recorded in the manifest when framework-specific policy or optional commands are needed;
7. use the pinned Microsoft Power BI authoring guidance recorded in the manifest for Power BI mechanics.

## Repository hygiene

Treat this repository as the product workspace, not as storage for reasoning, session history, handoff material, or project-management debris.

Default documentation/meta-artifact budget per task: **0 new files**.

Do not create ad hoc implementation/completion summaries, context or handoff packages, session notes, work logs, status/analysis reports, planning or scratch Markdown, generated TODO/checklist files, artifact manifests created only to prove completion, backup copies, or duplicate `final`, `revised`, `v2`, or similar variants.

Use established project artifacts for their defined purpose rather than creating parallel notes. New source, test, fixture, configuration, migration, and asset files are allowed when the implementation requires them.

Progress, plans, and transient findings belong in the conversation. Before finishing, inspect the change set and remove agent-created files that are not requested deliverables, established project artifacts, or required implementation. Never delete pre-existing untracked files merely because they look temporary.

## Scope discipline

Do the requested work in place. Do not expand a task into documentation, cleanup, refactoring, research, packaging, framework adoption, or process work unless required to complete it.

Repository write capability is not permission to restructure or clean up an existing implementation. Preserve established architecture and project conventions where reasonable.

## Writing voice

Use plain, contemporary English. Start with the substance. Do not restate the request, manufacture enthusiasm, add generic acknowledgements or ceremonial transitions, force groups of three, use rhetorical questions as transitions, invent dialogue, or append generic offers.

Avoid canned AI constructions and habitual AI vocabulary when ordinary wording works. Use technical vocabulary when it is the normal vocabulary of the field. State uncertainty directly and specifically. Reread responses once and rewrite generated, promotional, ceremonial, or generic phrasing.

## Project defaults

- Treat production operational data as restricted unless the user says otherwise.
- Build and visually review against synthetic data when restricted values cannot be shared.
- Keep the current usable product on `main` during normal iterative development.
- Use a temporary branch only for substantial experiments on an accepted working product.
- Make descriptive checkpoint commits after validated logical batches.
- Ask business questions, not avoidable implementation questions.
- Put paste-ready prompts, commands, code, SQL, DAX, M, JSON, YAML, and configuration in fenced code blocks when useful.
- Treat ChatGPT GitHub authorization, local filesystem access, and local Git/GitHub authentication as separate capabilities.
- Defer local-machine setup until the first Desktop handoff unless the task needs it earlier.
- Use `scripts/check-local-setup.ps1` before first local QA when appropriate.
- Do not require GitHub CLI, GitHub Desktop, SSH keys, Python, or other developer tooling unless the task needs them.
- Inspect local Git state before telling the user to pull, reset, or discard Desktop-written files.
- Do not claim structural or visual validation ran when the environment could not execute it; mark the check pending.
- Keep file/database source locations behind the named source parameter recorded in `config/data-contract.yml`.
- Record only durable implementation insights in `.power-bi-vibes/learning.yml`; prune debugging noise.
- Never promote private project lessons directly into the public framework.
- Do not send production screenshots or logs outside the approved environment when they expose restricted information.

## Local QA handoff after changes

After you mutate this repository and report what changed, include a **Local QA handoff** unless the user explicitly says they do not want one.

The handoff must include one self-contained fenced `powershell` block the user can copy and paste. Use the known local clone path when available; otherwise use `$Repo = '<LOCAL-CLONE-PATH>'`.

The block must:

- verify the clone path and change to it;
- run `git status --short --branch` and stop if any tracked or untracked local changes exist;
- run `git pull --ff-only` only from a clean worktree;
- run `scripts/check-local-setup.ps1` on the first relevant local handoff when available;
- start only local services whose startup commands are established by this repository or by the user;
- launch the exact relevant `.pbip` or `.pbix` with `Start-Process` when Desktop QA applies and the entrypoint is known;
- avoid destructive Git operations, cleans/resets, credential changes, package installation, and unrelated machine changes.

If more than one Power BI entrypoint exists and the requested change does not make the correct one clear, do not guess. Tell the user which choice is needed instead of launching an arbitrary report.

After the PowerShell block, list the task-specific QA actions and expected results from `qa/acceptance.md` and the change itself. Keep Desktop/local checks pending until they are actually performed.

## Optional analytical commands

If a user invokes a registered Power BI Vibes command such as `/premature-framing`, `/data-savant`, `/blind-spots`, `/stress-test`, `/simplify`, `/what-next`, `/repo-recon`, or `/commands`, read the command registry/definition from the framework version recorded in `.power-bi-vibes/manifest.yml` before answering.

Analytical commands are non-mutating by default. Return the analysis first and wait for the user to choose what to implement.