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

ChatGPT may author and commit PBIP/PBIR/TMDL files through GitHub when repository write tools are available. Do not describe a file as structurally or visually validated unless the applicable validator or Power BI Desktop check was actually executed.

## Hard boundaries

1. **Never write client project files into the public Power-Bi-Vibes repository.**
2. **Never request production operational data by default.** Use a scrubbed/template source, metadata-only schema report, or user-described schema when the real source is restricted.
3. Treat schema and screenshots as potentially sensitive. Worksheet names, column names, formulas, table names, relationships, URLs, internal terminology and metadata can reveal protected information.
4. Never commit credentials, secrets, access tokens, personal authentication material, production connection strings, or production data unless the user explicitly confirms that repository storage is permitted.
5. Develop and visually review with synthetic data whenever production values are restricted.
6. A production-data smoke test can remain local. The user does not need to send sensitive screenshots or records back to the agent.
7. Private-project lessons never write themselves into the public framework. Promotion requires abstraction and human review.

## Bootstrap sequence

### 1. Verify target and inspect before writing

- Confirm the client repository identity from the user's message or connected GitHub context.
- Inspect repository contents, default branch, recent commits and existing project instructions.
- Determine whether this is a new empty project, an existing Power BI project, or a partially initialized Power-Bi-Vibes project.
- Do not overwrite an existing project blindly.

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

### 5. Initialize an empty/new client repository

Once Power BI fit is established, create the following minimal structure on `main`:

```text
AGENTS.md
README.md
.gitignore
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
```

Use the files under `templates/client/` as the starting point. Replace placeholders with project-specific values when known. Do not invent business definitions.

The project manifest must record:

- installed Power-Bi-Vibes version;
- Power-Bi-Vibes source repository;
- Microsoft Power BI authoring source, version and pinned commit from `UPSTREAM.lock.yml`;
- initialization date;
- current development-data mode (`synthetic`, `approved-real-data`, or `mixed`);
- material execution capabilities and pending validation states;
- any intentional deviations from framework defaults.

### 6. Microsoft Power BI authoring guidance

Use the pinned Microsoft `powerbi-authoring` component defined in `UPSTREAM.lock.yml` as the technical authority for Power BI planning, design, semantic-model work, PBIR/PBIP authoring and management.

For ChatGPT + GitHub workflows, prefer reading the required Microsoft skill/reference files directly from the immutable pinned commit rather than copying the entire third-party repository into every client project. If the execution environment requires local skill discovery, materialize the required upstream component under an agent-specific dependency path and record that location in the project manifest.

Power-Bi-Vibes rules govern user interaction, privacy, repository structure, synthetic-data handling, learning, and the client Git policy. Microsoft guidance governs Power BI mechanics. Where Microsoft's generic Git guidance conflicts with `framework/GIT.md`, follow the Power-Bi-Vibes client Git policy.

### 7. Acquire a safe source representation

When a source exists, determine what the user is permitted to share.

Preferred order:

1. approved real sample when explicitly permitted;
2. scrubbed/template file preserving useful structure;
3. metadata-only schema report generated locally with `scripts/inspect-source.ps1` from this framework;
4. manually described schema.

Do not treat an empty workbook as automatically sanitized. Hidden sheets, metadata, connections, formulas, names and other artifacts can remain.

### 8. Create a data contract and swappable source boundary

Write `config/data-contract.yml` before the model becomes complex.

Capture:

- source type and expected structure;
- required and optional fields;
- expected types;
- keys and relationships;
- aliases/mappings where source headers may change;
- business meaning that affects calculations;
- null/blank handling;
- source adapter rules;
- known caveats;
- fields that must never be surfaced publicly;
- the single source parameter (or small parameter set) used to switch between synthetic and production locations.

For file/database sources, do not scatter hardcoded machine paths through M queries. The synthetic-to-production transition should normally be a source-location/connection parameter change rather than a rewrite of downstream transformations.

Ask the user only when a semantic ambiguity affects correctness. Do not ask them to make technical decisions you can safely infer.

### 9. Generate deterministic synthetic development data

Create project-specific synthetic fixtures that preserve the schema and exercise the tool.

Use a fixed seed and include, where plausible:

- every status/category;
- nulls and blanks;
- boundary dates and fiscal-period transitions;
- low, zero, negative and high numeric values when legitimate;
- long text labels;
- unusual but valid characters;
- duplicates only where the real source can contain them;
- high-cardinality dimensions;
- valid and intentionally invalid URLs when link handling matters;
- relationship edge cases.

Never synthesize confidential real values from memory or previous client material.

### 10. Plan before large-scale authoring

For a new tool, use the pinned Microsoft planning/design guidance to create `_brief/report-spec.md`. Keep the user-facing portion plain language.

The spec should cover:

- audience and job;
- first-build scope;
- page/feature plan;
- important measures/business rules;
- navigation and interactions;
- accessibility expectations;
- source and refresh assumptions;
- local/service delivery assumptions;
- open business decisions.

Get user approval before a large greenfield build. Small corrective edits to an existing accepted tool do not require repeating the full planning gate.

### 11. Build in logical batches

Typical sequence:

1. source adapter / Power Query layer;
2. semantic model and core measures;
3. one usable page or workflow slice;
4. structural validation when executable in the current environment;
5. rendered/local QA when Power BI Desktop access is available;
6. checkpoint commit;
7. next page or feature.

A scaffold with empty pages is not a completed report. If validation cannot run in the current environment, mark it pending and give the user the shortest exact local validation/QA step.

### 12. Capture durable lessons

Follow `framework/LEARNING.md`.

When a durable implementation insight appears, record it in `.power-bi-vibes/learning.yml` without interrupting the user. At validated checkpoints, confirm, reject or retain provisional observations. Do not turn the file into a debug diary.

If a confirmed lesson changes expected project behavior, update the applicable project-owned artifact (`AGENTS.md`, data contract, report spec, decisions, acceptance checks, or implementation) as well.

### 13. Git behavior

Follow `framework/GIT.md`.

Default client behavior:

- keep the current usable product on `main`;
- make small, descriptive checkpoint commits after validated logical batches;
- use a temporary branch for a substantial experiment or risky redesign of an already working product;
- merge or abandon experimental branches promptly;
- avoid branch proliferation;
- never force-push or rewrite user-created history;
- inspect local and remote repository state before pulling, reverting or discarding edits.

### 14. Local handoff and QA

When the user must interact with Power BI Desktop, provide the shortest exact action needed.

Do not issue `git pull --ff-only` blindly. First have the user run the safe sync preflight from `framework/GIT.md` when local edits may exist.

Before the first PBIP/PBIR open, confirm the current Power BI Desktop requirements for the chosen project/report format. PBIP/PBIR support and preview-feature requirements are version-dependent and must be checked against current Microsoft guidance rather than assumed from memory.

Then give task-based QA criteria. Example:

> Open `powerbi/Project.pbip`. Set Fiscal Year to 2026/27. Confirm the total forecast and the project table both update. Select one project and confirm its drillthrough page shows the same project ID.

If a screenshot is requested, remind the user to use synthetic data or ensure the screenshot is permitted to be shared.

### 15. Production-data smoke test

After synthetic QA passes:

- switch the source parameter to the approved production location locally;
- expect first-refresh credential/privacy prompts when the source requires them;
- refresh;
- verify schema compatibility;
- verify row-level behavior, relationships and key measures;
- test performance with realistic data volume;
- record sanitized failures or schema differences;
- update the adapter/contract if required.

Keep synthetic and production sources separable. Avoid unnecessarily combining sources in a way that creates Power Query privacy/firewall issues. Treat credential/privacy failures as configuration problems, not as reasons to request unrestricted data.

Synthetic QA proves implementation behavior against the fixture. It does not prove production completeness or performance.

### 16. Completion criteria

Do not call a feature complete until the applicable checks pass:

- repository state is coherent;
- Power BI structural validation has actually passed, or is explicitly marked pending local execution;
- pages contain real data-bound visuals/functions rather than placeholders;
- rendered layout has actually been checked when the change affects rendering, or is explicitly marked pending local QA;
- interactions requested by the user work;
- acceptance steps in `qa/acceptance.md` are specific and current;
- project documentation reflects any material source or behavior change.

## Communication policy

Assume the user is capable in their domain and may be new to Power BI development.

- Use the user's terminology.
- Ask one consequential question at a time.
- Infer routine technical choices and explain them only when useful.
- Give copy/paste commands rather than tutorials when the user needs to act locally.
- Translate errors into cause, consequence and next action.
- Keep detailed technical diagnostics in repository files when they help future sessions.
- Avoid repeated confirmation for reversible routine edits.
- Ask before destructive, externally publishing, credential, production-data, or materially risky actions.

## Resume behavior

When returning to an existing project:

1. read `AGENTS.md` and `.power-bi-vibes/manifest.yml`;
2. read confirmed lessons/patterns in `.power-bi-vibes/learning.yml`;
3. inspect recent commits and current repository state;
4. read `_brief/report-spec.md`, `_brief/decisions.md`, `config/data-contract.yml` and `qa/acceptance.md` as relevant;
5. compare the installed framework/upstream versions only when the user's request makes an update relevant;
6. continue from the existing accepted product rather than rebuilding from scratch.
