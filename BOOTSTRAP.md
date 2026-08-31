# Power BI Vibes Bootstrap

This is the canonical machine entrypoint for starting or resuming a client Power BI project.

## Role

Act as the technical builder. The user supplies business context, permitted data structure, business definitions, priorities, and local QA observations. Do not require the user to understand Power BI internals unless a technical choice materially affects their decision.

## Required starting context

You should have:

- this Power-Bi-Vibes framework repository;
- a user-designated client project repository;
- GitHub write access to the client repository, or a clear alternative write path supplied by the user.

If the client repository cannot be written from the current environment, state the limitation and switch to a file/patch/local-agent handoff. Do not claim changes were committed when they were not.

## Capability state

Before substantial implementation, determine what the current environment can actually do and record material limitations in `.power-bi-vibes/manifest.yml`.

At minimum distinguish:

- repository read/write capability;
- local command execution capability;
- Power BI Desktop control/reload/screenshot capability;
- whether structural validation has actually been run;
- whether rendered/visual validation has actually been run.

Treat ChatGPT GitHub authorization and the user's local Windows Git/GitHub authentication as separate capabilities. A successful repository write from ChatGPT does not prove the user's computer can clone, pull or push.

ChatGPT may author and commit PBIP/PBIR/TMDL files through GitHub when repository write tools are available. Do not describe a file as structurally or visually validated unless the applicable validator or Power BI Desktop check was actually executed.

## Hard boundaries

1. **Never write client project files into the public Power-Bi-Vibes repository.**
2. **Never request production operational data by default.** Use a scrubbed/template source, metadata-only schema report, or user-described schema when the real source is restricted.
3. Treat schema and screenshots as potentially sensitive. Worksheet names, column names, formulas, table names, relationships, URLs, internal terminology and metadata can reveal protected information.
4. Never commit credentials, secrets, access tokens, personal authentication material, production connection strings, or production data unless the user explicitly confirms repository storage is permitted.
5. Develop and visually review with synthetic data whenever production values are restricted.
6. A production-data smoke test can remain local. The user does not need to send sensitive screenshots or records back to the agent.
7. Private-project lessons never write themselves into the public framework. Promotion requires abstraction and human review.
8. Do not make the user install local development tooling at project kickoff unless the current task actually requires the local machine.

## Bootstrap sequence

### 1. Verify target and inspect before writing

- Confirm the client repository identity from the user's message or connected GitHub context.
- Inspect repository contents, default branch, recent commits and existing project instructions.
- Determine whether this is a new project, an existing Power BI project, or a partially initialized Power-Bi-Vibes project.
- Do not overwrite an existing project blindly.
- A repository initialized with a README is the recommended new-project state; treat that as new rather than as an existing implementation.

### 2. Read framework rules

Read:

- `framework/OPERATING-RULES.md`
- `framework/PRIVACY.md`
- `framework/DATA.md`
- `framework/GIT.md`
- `framework/QA.md`
- `framework/MICROSOFT-POWERBI.md`
- `framework/LEARNING.md`
- `framework/UPDATES.md`
- `UPSTREAM.lock.yml`

Use those as the operating contract for the project.

### 3. Ask what the user wants to accomplish

For a new project, ask one concise job-focused question before creating a Power-BI-specific scaffold, for example:

> What should this tool help you or your team do?

Do not start with a questionnaire about DAX, data models, visual types, TMDL or PBIR.

### 4. Check Power BI fit before scaffolding

Infer fit from the job. Power BI is generally appropriate for analysis, monitoring, reporting, comparison, planning support and read-oriented exploration.

If the core requirement depends on transactional writeback, multi-user record editing, complex workflow state, or application behavior that Power BI cannot reasonably provide, surface that constraint before creating the Power BI project structure. Do not force the requirement into Power BI merely because this framework is being used.

### 5. Initialize a new client repository

Once Power BI fit is established, create the minimal project structure on `main`:

```text
AGENTS.md
README.md
.gitignore
.gitattributes
.power-bi-vibes/
  manifest.yml
  learning.yml
_brief/
  report-spec.md
  decisions.md
config/
  data-contract.yml
data/
  synthetic/
powerbi/
qa/
  acceptance.md
scripts/
  check-local-setup.ps1
```

Use these source-to-destination mappings:

- `templates/client/AGENTS.md` -> `AGENTS.md`
- `templates/client/README.md` -> `README.md`
- `templates/client/.gitignore` -> `.gitignore`
- `templates/client/.gitattributes` -> `.gitattributes`
- `templates/client/manifest.yml` -> `.power-bi-vibes/manifest.yml`
- `templates/client/learning.yml` -> `.power-bi-vibes/learning.yml`
- `templates/client/report-spec.md` -> `_brief/report-spec.md`
- `templates/client/decisions.md` -> `_brief/decisions.md`
- `templates/client/data-contract.yml` -> `config/data-contract.yml`
- `templates/client/acceptance.md` -> `qa/acceptance.md`
- `scripts/check-local-setup.ps1` -> `scripts/check-local-setup.ps1`

Replace placeholders with project-specific values when known. Do not invent business definitions. Keep empty directories only when useful; Git does not track empty folders.

The project manifest must record:

- installed Power-Bi-Vibes version and source repository;
- Microsoft Power BI authoring source, version and pinned commit from `UPSTREAM.lock.yml`;
- initialization date;
- current development-data mode (`synthetic`, `approved-real-data`, or `mixed`);
- material execution capabilities and pending validation states;
- any intentional deviations from framework defaults.

### 6. Microsoft Power BI authoring guidance

Use the pinned Microsoft `powerbi-authoring` component defined in `UPSTREAM.lock.yml` as the technical authority for Power BI planning, design, semantic-model work, PBIR/PBIP authoring and management.

For ChatGPT + GitHub workflows, prefer reading the required Microsoft skill/reference files directly from the immutable pinned commit rather than copying the entire third-party repository into every client project. If the execution environment requires local skill discovery, materialize the required upstream component under an agent-specific dependency path and record that location in the project manifest.

Power-Bi-Vibes rules govern user interaction, privacy, repository structure, synthetic-data handling, learning, local setup and client Git policy. Microsoft guidance governs Power BI mechanics. Where Microsoft's generic Git guidance conflicts with `framework/GIT.md`, follow the Power-Bi-Vibes client Git policy.

### 7. Acquire a safe source representation

When a source exists, determine what the user is permitted to share.

Preferred order:

1. approved real sample when explicitly permitted;
2. scrubbed/template file preserving useful structure;
3. metadata-only schema report generated locally with `scripts/inspect-source.ps1` from this framework;
4. manually described schema.

Do not treat an empty workbook as automatically sanitized. Hidden sheets, metadata, connections, formulas, names and other artifacts can remain.

### 8. Create a data contract and swappable source boundary

Write `config/data-contract.yml` before the model becomes complex. Capture source structure, required/optional fields, types, keys/relationships, aliases, business meaning, null handling, adapter rules, caveats, fields that must not be surfaced, and the source parameter(s) used to switch between synthetic and production locations.

For file/database sources, do not scatter hardcoded machine paths through M queries. The synthetic-to-production transition should normally be a source-location/connection parameter change rather than a downstream rewrite.

Ask the user only when semantic ambiguity affects correctness.

### 9. Generate deterministic synthetic development data

Create project-specific synthetic fixtures with a fixed seed. Exercise every important category/status, null/blank behavior, boundary dates, legitimate numeric extremes, long labels, unusual valid characters, realistic relationship edge cases, and link behavior where relevant.

Never synthesize confidential real values from memory or previous client material.

### 10. Plan before large-scale authoring

Use the pinned Microsoft planning/design guidance to create `_brief/report-spec.md`. Keep the user-facing portion plain language and cover audience/job, first-build scope, page/feature plan, important measures/business rules, navigation/interactions, accessibility, source/refresh assumptions, delivery assumptions, and unresolved business decisions.

Get user approval before a large greenfield build. Small corrective edits to an accepted tool do not require repeating the full planning gate.

### 11. Build in logical batches

Typical sequence:

1. source adapter / Power Query layer;
2. semantic model and core measures;
3. one usable page or workflow slice;
4. structural validation when executable;
5. rendered/local QA when Power BI Desktop access is available;
6. checkpoint commit;
7. next page or feature.

A scaffold with empty pages is not a completed report. If validation cannot run in the current environment, mark it pending and give the shortest exact local validation/QA step.

### 12. Capture durable lessons

Follow `framework/LEARNING.md`. Record durable implementation insights in `.power-bi-vibes/learning.yml` without interrupting the user. At validated checkpoints, confirm, reject or retain provisional observations. Do not turn it into a debug diary.

If a confirmed lesson changes expected project behavior, update the applicable project-owned artifact as well.

### 13. Git behavior

Follow `framework/GIT.md`. Keep the current usable product on `main`, make descriptive checkpoint commits after validated logical batches, use a temporary branch only for a substantial experiment/risky redesign, avoid branch proliferation, never force-push user-created history, and inspect local/remote state before pulling/reverting/discarding edits.

### 14. First local handoff and dependency setup

Do not force local setup at project kickoff. When the first task requires Power BI Desktop or local file access:

1. point the user to `docs/WINDOWS-SETUP.md` in Power BI Vibes if first-time setup is needed;
2. explain that ChatGPT's GitHub connection and local GitHub authentication are separate;
3. use Git for Windows + HTTPS + Git Credential Manager as the default Windows path;
4. do not require GitHub CLI, GitHub Desktop, SSH keys, Python, VS Code or SQLite CLI unless the task needs them;
5. after the client repository is cloned, have the user run:

```powershell
.\scripts\check-local-setup.ps1 -RepositoryUrl https://github.com/OWNER/PROJECT.git
```

6. fix failed required checks one at a time;
7. before the first PBIP/PBIR open, confirm current Power BI Desktop requirements for the exact project/report format.

Then give task-based QA criteria. If a screenshot is requested, remind the user to use synthetic data or ensure the screenshot is permitted to be shared.

### 15. Safe synchronization after Desktop edits

Do not issue `git pull --ff-only` blindly after Power BI Desktop has saved the project. First run the safe sync preflight from `framework/GIT.md`. Preserve local Desktop edits before resolving divergence.

### 16. Production-data smoke test

After synthetic QA passes, switch the source parameter to the approved production location locally, expect first-refresh credential/privacy prompts where applicable, refresh, verify schema compatibility/relationships/key measures, test performance at realistic volume, record sanitized failures, and update the adapter/contract if needed.

Synthetic QA proves implementation behavior against the fixture. It does not prove production completeness or performance.

### 17. Completion criteria

Do not call a feature complete until the applicable checks pass or are explicitly marked pending: coherent repository state, structural validation, real data-bound visuals/functions, rendered layout review, requested interactions, specific/current acceptance steps, and current project documentation.

## Communication policy

- Use the user's terminology.
- Ask one consequential question at a time.
- Infer routine technical choices.
- Give copy/paste commands rather than tutorials when the user must act locally.
- Translate errors into cause, consequence and next action.
- Keep detailed diagnostics in repository files when useful.
- Avoid repeated confirmation for reversible routine edits.
- Ask before destructive, externally publishing, credential, production-data, or materially risky actions.

## Resume behavior

When returning to an existing project:

1. read `AGENTS.md` and `.power-bi-vibes/manifest.yml`;
2. read confirmed lessons/patterns in `.power-bi-vibes/learning.yml`;
3. inspect recent commits and current repository state;
4. read `_brief/report-spec.md`, `_brief/decisions.md`, `config/data-contract.yml` and `qa/acceptance.md` as relevant;
5. compare framework/upstream versions only when relevant;
6. continue from the accepted product rather than rebuilding from scratch.
