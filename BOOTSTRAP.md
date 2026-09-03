# Power BI Vibes Bootstrap

This is the canonical machine entrypoint for starting, adopting, auditing, or resuming a client Power BI project.

## Role

Act as the technical builder. The user supplies business context, permitted data structure, business definitions, priorities, and local QA observations. Do not require the user to understand Power BI internals unless a technical choice materially affects their decision.

## Required starting context

You should have:

- this Power-Bi-Vibes framework repository;
- a user-designated client project repository;
- the user's local clone path when one already exists and they choose to provide it;
- GitHub write access to the client repository, or a clear alternative write path supplied by the user when mutation is actually required.

A supplied local clone path is contextual information, not proof that the current agent can access that filesystem location, execute commands there, control Power BI Desktop, or use the user's local Git/GitHub authentication. Determine those capabilities separately.

Repository access does not imply permission to initialize, restructure, or otherwise mutate an existing implementation. If the client repository cannot be written from the current environment, state the limitation and switch to a file/patch/local-agent handoff when the task requires changes. Do not claim changes were committed when they were not.

## Capability state

Before substantial implementation, determine what the current environment can actually do and record material limitations in `.power-bi-vibes/manifest.yml` when the repository is managed by Power BI Vibes or the user has approved adopting the framework into an existing repository.

At minimum distinguish:

- repository read/write capability;
- access to any user-supplied local clone path;
- local command execution capability;
- local Git/GitHub authentication capability;
- Power BI Desktop control/reload/screenshot capability;
- whether structural validation has actually been run;
- whether rendered/visual validation has actually been run.

Treat ChatGPT GitHub authorization, local filesystem access, and the user's local Windows Git/GitHub authentication as separate capabilities. A successful repository write from ChatGPT does not prove the user's computer can clone, pull or push. A supplied local path does not prove the current agent can open or modify it.

ChatGPT may author and commit PBIP/PBIR/TMDL files through GitHub when repository write tools are available and the current task authorizes mutation. Do not describe a file as structurally or visually validated unless the applicable validator or Power BI Desktop check was actually executed.

## Hard boundaries

1. **Never write client project files into the public Power-Bi-Vibes repository.**
2. **Never request production operational data by default.** Use a scrubbed/template source, metadata-only schema report, or user-described schema when the real source is restricted.
3. Treat schema and screenshots as potentially sensitive. Worksheet names, column names, formulas, table names, relationships, URLs, internal terminology and metadata can reveal protected information.
4. Never commit credentials, secrets, access tokens, personal authentication material, production connection strings, or production data unless the user explicitly confirms repository storage is permitted.
5. Develop and visually review with synthetic data whenever production values are restricted.
6. A production-data smoke test can remain local. The user does not need to send sensitive screenshots or records back to the agent.
7. Private-project lessons never write themselves into the public framework. Promotion requires abstraction and human review.
8. Do not make the user install local development tooling at project kickoff unless the current task actually requires the local machine.
9. **Classify the repository before mutating it.** Do not initialize Power BI Vibes structures merely because they are absent from a substantive existing repository.
10. **Brownfield and unclear existing repositories are read-only during reconnaissance.** Mutation begins only after the existing architecture and requested operation are understood and the task authorizes the change.

## Bootstrap sequence

### 1. Verify target and inspect before writing

- Confirm the client repository identity from the user's message or connected GitHub context.
- Record any user-supplied local clone path as context, but do not assume it is accessible from the current environment.
- Inspect repository contents, default branch, recent commits and existing project instructions.
- Determine whether this is a new project, an existing Power BI project, a partially initialized Power-Bi-Vibes project, or another substantive repository containing Power BI assets.
- Do not overwrite or reorganize an existing project blindly.
- A repository initialized with only a README and no substantive implementation is the recommended new-project state; treat that as new rather than as an existing implementation.

### 2. Run the Repository Mode Gate

Classify the target before scaffolding, writing framework metadata, or assuming a greenfield design problem.

Use one of these modes:

- `greenfield` - empty, README-only, or otherwise intentionally blank repository with no substantive implementation;
- `managed-existing` - an existing Power BI Vibes project with framework-owned metadata such as `.power-bi-vibes/manifest.yml` and project instructions;
- `brownfield-powerbi` - an existing Power BI implementation that is not already managed by Power BI Vibes, including repositories with `.pbip`, `.Report`, `.SemanticModel`, PBIR, TMDL, Power Query/model/report assets, or surrounding Power BI tooling;
- `unknown-existing` - a substantive repository whose architecture or Power BI boundary is not yet clear.

Repository mode controls the next action:

- `greenfield` -> continue to the job question and Power BI fit check before initialization;
- `managed-existing` -> use the Resume behavior in this document;
- `brownfield-powerbi` -> run Brownfield reconnaissance before proposing or making changes;
- `unknown-existing` -> remain read-only and inspect only far enough to classify the repository or establish the relevant system boundary.

Do not add `.power-bi-vibes/`, `_brief/`, `config/`, `qa/`, client templates, or other framework scaffolding to a substantive existing repository merely because those paths are missing. Framework adoption into a brownfield repository is a separate decision from helping with the repository.

### 3. Read framework rules

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

### 4. Brownfield reconnaissance

For `brownfield-powerbi` and `unknown-existing`, inspect read-only before implementation. Read only what is needed to understand the existing system and the user's requested operation.

Inspect, where present and relevant:

- repository-level instructions such as `AGENTS.md`, README files, contributor notes and local conventions;
- directory structure, default branch, recent commits and current repository state;
- `.pbip` entrypoints and the Power BI project boundary;
- `.Report` / PBIR structure, report pages, navigation and interaction definitions;
- `.SemanticModel` / TMDL structure, relationships, measures, calculated objects and model conventions;
- Power Query/source definitions, parameters, source adapters and connection boundaries;
- scripts, local tooling, generators and existing validation mechanisms;
- synthetic/sample/test data and the intended production-data boundary;
- generated versus source-controlled files and material Git conventions;
- existing documentation, specifications, decisions and acceptance criteria.

Do not require every item above when a smaller inspection resolves the current task. Do not turn reconnaissance into an unbounded audit.

Before mutation, produce or internally establish a compact system map containing, as applicable:

- repository mode;
- Power BI entrypoint(s);
- report and semantic-model locations;
- source/data architecture and privacy boundary;
- existing validation capability;
- relevant project conventions;
- the requested operation, such as explain, debug, repair, extend, reverse engineer, refactor, validate or migrate;
- material unknowns that could change the implementation.

For brownfield work, preserve the established architecture and project conventions where reasonable. Distinguish the requested edit from opportunistic cleanup. Ask only when an unresolved semantic or architectural ambiguity materially affects correctness or risk.

### 5. Ask what the user wants to accomplish when appropriate

For a `greenfield` project, ask one concise job-focused question before creating a Power-BI-specific scaffold, for example:

> What should this tool help you or your team do?

Do not start with a questionnaire about DAX, data models, visual types, TMDL or PBIR.

For `brownfield-powerbi`, do not reset the conversation to generic product discovery when the user has already supplied a concrete operation. First understand the existing implementation and then ask only consequential questions needed for that operation.

### 6. Check Power BI fit before scaffolding

For `greenfield`, infer fit from the job. Power BI is generally appropriate for analysis, monitoring, reporting, comparison, planning support and read-oriented exploration.

If the core requirement depends on transactional writeback, multi-user record editing, complex workflow state, or application behavior that Power BI cannot reasonably provide, surface that constraint before creating the Power BI project structure. Do not force the requirement into Power BI merely because this framework is being used.

For brownfield work, do not use the fit check as a reason to redesign an accepted implementation unless the user's requested change materially exposes a platform mismatch.

### 7. Initialize a new client repository

This step applies only to `greenfield` repositories after Power BI fit is established.

Create the minimal project structure on `main`:

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

### 8. Microsoft Power BI authoring guidance

Use the pinned Microsoft `powerbi-authoring` component defined in `UPSTREAM.lock.yml` as the technical authority for Power BI planning, design, semantic-model work, PBIR/PBIP authoring and management.

For ChatGPT + GitHub workflows, prefer reading the required Microsoft skill/reference files directly from the immutable pinned commit rather than copying the entire third-party repository into every client project. If the execution environment requires local skill discovery, materialize the required upstream component under an agent-specific dependency path and record that location in the project manifest when the project is Power BI Vibes-managed.

Power-Bi-Vibes rules govern user interaction, privacy, repository structure, synthetic-data handling, learning, local setup and client Git policy. Microsoft guidance governs Power BI mechanics. Where Microsoft's generic Git guidance conflicts with `framework/GIT.md`, follow the Power-Bi-Vibes client Git policy for Power BI Vibes-managed projects. In brownfield repositories, preserve stricter existing repository policy unless the user explicitly chooses to adopt a different policy.

### 9. Acquire a safe source representation

When a source exists and additional source representation is needed for the current task, determine what the user is permitted to share.

Preferred order:

1. approved real sample when explicitly permitted;
2. scrubbed/template file preserving useful structure;
3. metadata-only schema report generated locally with `scripts/inspect-source.ps1` from this framework;
4. manually described schema.

Do not treat an empty workbook as automatically sanitized. Hidden sheets, metadata, connections, formulas, names and other artifacts can remain.

When the permitted repository already contains enough safe structural information to perform the requested work, use it rather than asking the user to re-share data or schema.

### 10. Create a data contract and swappable source boundary

For a `greenfield` or explicitly adopted Power BI Vibes project, write `config/data-contract.yml` before the model becomes complex. Capture source structure, required/optional fields, types, keys/relationships, aliases, business meaning, null handling, adapter rules, caveats, fields that must not be surfaced, and the source parameter(s) used to switch between synthetic and production locations.

For an existing brownfield project, first identify and preserve its current source-boundary convention. Do not introduce a parallel data-contract system unless the user chooses to adopt one or the requested change requires it.

For file/database sources, do not scatter hardcoded machine paths through M queries. The synthetic-to-production transition should normally be a source-location/connection parameter change rather than a downstream rewrite.

Ask the user only when semantic ambiguity affects correctness.

### 11. Generate deterministic synthetic development data

For greenfield and Power BI Vibes-managed projects, create project-specific synthetic fixtures with a fixed seed. Exercise every important category/status, null/blank behavior, boundary dates, legitimate numeric extremes, long labels, unusual valid characters, realistic relationship edge cases, and link behavior where relevant.

For brownfield projects, use existing synthetic/test fixtures when adequate. Add or replace fixtures only when the requested work requires it and repository conventions permit it.

Never synthesize confidential real values from memory or previous client material.

### 12. Plan before large-scale authoring

For greenfield projects, use the pinned Microsoft planning/design guidance to create `_brief/report-spec.md`. Keep the user-facing portion plain language and cover audience/job, first-build scope, page/feature plan, important measures/business rules, navigation/interactions, accessibility, source/refresh assumptions, delivery assumptions, and unresolved business decisions.

Get user approval before a large greenfield build. Small corrective edits to an accepted tool do not require repeating the full planning gate.

For brownfield projects, use existing specifications and architecture first. Create Power BI Vibes planning artifacts only if the project is being adopted into the framework or if the user explicitly wants those artifacts.

### 13. Build in logical batches

Typical sequence:

1. source adapter / Power Query layer;
2. semantic model and core measures;
3. one usable page or workflow slice;
4. structural validation when executable;
5. rendered/local QA when Power BI Desktop access is available;
6. checkpoint commit;
7. next page or feature.

For brownfield work, adjust the sequence to the requested operation rather than rebuilding unaffected layers. A scaffold with empty pages is not a completed report. If validation cannot run in the current environment, mark it pending and give the shortest exact local validation/QA step.

### 14. Capture durable lessons

Follow `framework/LEARNING.md`. For Power BI Vibes-managed projects, record durable implementation insights in `.power-bi-vibes/learning.yml` without interrupting the user. At validated checkpoints, confirm, reject or retain provisional observations. Do not turn it into a debug diary.

If a confirmed lesson changes expected project behavior, update the applicable project-owned artifact as well.

Do not create a learning log in a brownfield repository merely to record observations unless the user has chosen framework adoption.

### 15. Git behavior

Follow `framework/GIT.md` for Power BI Vibes-managed projects. Keep the current usable product on `main`, make descriptive checkpoint commits after validated logical batches, use a temporary branch only for a substantial experiment/risky redesign, avoid branch proliferation, never force-push user-created history, and inspect local/remote state before pulling/reverting/discarding edits.

For brownfield projects, inspect and follow the repository's established Git policy first. Repository write capability is not itself authorization to initialize, reorganize or opportunistically clean up the project.

### 16. First local handoff and dependency setup

Do not force local setup at project kickoff. If the user supplied a local clone path, use it as the preferred local working-copy location only when the current environment can actually access it. Do not ask the user to reclone merely because the framework's default examples use another path.

When the first task requires Power BI Desktop or local file access:

1. point the user to `docs/WINDOWS-SETUP.md` in Power BI Vibes if first-time setup is needed;
2. explain that ChatGPT's GitHub connection, local filesystem access, and local GitHub authentication are separate;
3. use Git for Windows + HTTPS + Git Credential Manager as the default Windows path;
4. do not require GitHub CLI, GitHub Desktop, SSH keys, Python, VS Code or SQLite CLI unless the task needs them;
5. after a Power BI Vibes-managed client repository is cloned, have the user run:

```powershell
.\scripts\check-local-setup.ps1 -RepositoryUrl https://github.com/OWNER/PROJECT.git
```

6. fix failed required checks one at a time;
7. before the first PBIP/PBIR open, confirm current Power BI Desktop requirements for the exact project/report format.

For brownfield repositories, prefer the project's existing setup scripts and documentation when present. Then give task-based QA criteria. If a screenshot is requested, remind the user to use synthetic data or ensure the screenshot is permitted to be shared.

### 17. Safe synchronization after Desktop edits

For Power BI Vibes-managed projects, do not issue `git pull --ff-only` blindly after Power BI Desktop has saved the project. First run the safe sync preflight from `framework/GIT.md`. Preserve local Desktop edits before resolving divergence.

For brownfield projects, follow the repository's own synchronization policy when one exists and preserve local Desktop edits before resolving divergence.

### 18. Production-data smoke test

After synthetic QA passes, switch the source parameter to the approved production location locally, expect first-refresh credential/privacy prompts where applicable, refresh, verify schema compatibility/relationships/key measures, test performance at realistic volume, record sanitized failures, and update the adapter/contract if needed.

Synthetic QA proves implementation behavior against the fixture. It does not prove production completeness or performance.

### 19. Completion criteria

Do not call a feature complete until the applicable checks pass or are explicitly marked pending: coherent repository state, structural validation, real data-bound visuals/functions, rendered layout review, requested interactions, specific/current acceptance steps, and current project documentation.

For brownfield tasks, completion criteria apply only to the affected scope unless the user requested a wider audit or migration.

## Communication policy

- Use the user's terminology.
- Ask one consequential question at a time.
- Infer routine technical choices.
- Give copy/paste commands rather than tutorials when the user must act locally.
- Put prompts intended for another LLM, coding agent, or ChatGPT session in fenced code blocks.
- Put PowerShell, shell commands, code, SQL, DAX, M, JSON, YAML, configuration, and similar runnable or paste-ready material in fenced code blocks, with a useful language tag when appropriate.
- Prefer other response elements that provide clean copy/paste behavior when they better fit the material.
- Do not use Markdown blockquotes for paste-ready prompts, commands, code, or configuration. Reserve blockquotes for actual quoted material.
- Keep explanation outside copy/paste blocks unless the explanation is intentionally part of what the user should paste.
- Translate errors into cause, consequence and next action.
- Keep detailed diagnostics in repository files when useful.
- Avoid repeated confirmation for reversible routine edits.
- Ask before destructive, externally publishing, credential, production-data, or materially risky actions.

## Resume behavior

Use this behavior only for `managed-existing` projects unless the user explicitly adopts Power BI Vibes into a brownfield repository.

When returning to an existing Power BI Vibes-managed project:

1. read `AGENTS.md` and `.power-bi-vibes/manifest.yml`;
2. read confirmed lessons/patterns in `.power-bi-vibes/learning.yml`;
3. inspect recent commits and current repository state;
4. read `_brief/report-spec.md`, `_brief/decisions.md`, `config/data-contract.yml` and `qa/acceptance.md` as relevant;
5. compare framework/upstream versions only when relevant;
6. continue from the accepted product rather than rebuilding from scratch.

If those Power BI Vibes artifacts are absent but substantive Power BI assets exist, return to the Repository Mode Gate and treat the repository as `brownfield-powerbi` rather than assuming it is a broken managed project.
