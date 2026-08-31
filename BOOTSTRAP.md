# Power BI Vibes Bootstrap

This is the canonical machine entrypoint for starting or resuming a client Power BI project.

## Role

Act as the technical builder. The user supplies business context, permitted data structure, business definitions, and local QA observations. Do not require the user to understand Power BI internals unless a technical choice materially affects their decision.

## Required starting context

You should have:

- this Power-Bi-Vibes framework repository;
- a user-designated client project repository;
- GitHub write access to the client repository, or a clear alternative write path supplied by the user.

If the client repository cannot be written from the current environment, state the limitation and switch to a file/patch/local-agent handoff. Do not claim changes were committed when they were not.

## Hard boundaries

1. **Never write client project files into the public Power-Bi-Vibes repository.**
2. **Never request production operational data by default.** Use a scrubbed/template source, metadata-only schema report, or user-described schema when the real source is restricted.
3. Treat schema and screenshots as potentially sensitive. Worksheet names, column names, formulas, table names, relationships, URLs, internal terminology and metadata can reveal protected information.
4. Never commit credentials, secrets, access tokens, personal authentication material, production connection strings, or production data unless the user explicitly confirms that repository storage is permitted.
5. Develop and visually review with synthetic data whenever production values are restricted.
6. A production-data smoke test can remain local. The user does not need to send sensitive screenshots or records back to the agent.

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
- `framework/UPDATES.md`
- `UPSTREAM.lock.yml`

Use those as the operating contract for the project.

### 3. Initialize an empty/new client repository

Create the following minimal structure on `main`:

```text
AGENTS.md
README.md
.gitignore
.power-bi-vibes/
  manifest.yml
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
- any intentional deviations from framework defaults.

### 4. Microsoft Power BI authoring guidance

Use the pinned Microsoft `powerbi-authoring` component defined in `UPSTREAM.lock.yml` as the technical authority for Power BI planning, design, semantic-model work, PBIR/PBIP authoring and management.

For ChatGPT + GitHub workflows, prefer reading the required Microsoft skill/reference files directly from the immutable pinned commit rather than copying the entire third-party repository into every client project. If the execution environment requires local skill discovery, materialize the required upstream component under an agent-specific dependency path and record that location in the project manifest.

Power-Bi-Vibes rules govern user interaction, privacy, repository structure, synthetic-data handling, and the client Git policy. Microsoft guidance governs Power BI mechanics. Where Microsoft's generic Git guidance conflicts with `framework/GIT.md`, follow the Power-Bi-Vibes client Git policy.

### 5. Ask what the user wants to accomplish

After initialization, return to the user with one concise question focused on the job, for example:

> The project repository is initialized. What should this Power BI tool help you or your team do?

Do not start with a questionnaire about DAX, data models, visual types, TMDL or PBIR.

### 6. Check Power BI fit without derailing the user

Infer fit from the request. Power BI is generally appropriate for analysis, monitoring, reporting, comparison, planning support and read-oriented exploration.

If the core requirement depends on transactional writeback, multi-user record editing, complex workflow state, or application behavior that Power BI cannot reasonably provide, surface that constraint before major implementation. Do not force the requirement into Power BI merely because this framework is being used.

### 7. Acquire a safe source representation

When a source exists, determine what the user is permitted to share.

Preferred order:

1. approved real sample when explicitly permitted;
2. scrubbed/template file preserving useful structure;
3. metadata-only schema report generated locally with `scripts/inspect-source.ps1` from this framework;
4. manually described schema.

Do not treat an empty workbook as automatically sanitized. Hidden sheets, metadata, connections, formulas, names and other artifacts can remain.

### 8. Create a data contract

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
- fields that must never be surfaced publicly.

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
4. structural validation;
5. rendered/local QA;
6. checkpoint commit;
7. next page or feature.

A scaffold with empty pages is not a completed report.

### 12. Git behavior

Follow `framework/GIT.md`.

Default client behavior:

- keep the current usable product on `main`;
- make small, descriptive checkpoint commits after validated logical batches;
- use a temporary branch for a substantial experiment or risky redesign of an already working product;
- merge or abandon experimental branches promptly;
- avoid branch proliferation;
- never force-push or rewrite user-created history;
- inspect repository state before reverting.

### 13. Local handoff and QA

When the user must interact with Power BI Desktop, provide the shortest exact action needed.

Prefer commands such as:

```powershell
cd C:\PBI\<PROJECT>
git pull --ff-only
```

Then give task-based QA criteria. Example:

> Open `powerbi/Project.pbip`. Set Fiscal Year to 2026/27. Confirm the total forecast and the project table both update. Select one project and confirm its drillthrough page shows the same project ID.

If a screenshot is requested, remind the user to use synthetic data or ensure the screenshot is permitted to be shared.

### 14. Production-data smoke test

After synthetic QA passes:

- connect the approved production source locally;
- refresh;
- verify schema compatibility;
- verify row-level behavior, relationships and key measures;
- test performance with realistic data volume;
- record sanitized failures or schema differences;
- update the adapter/contract if required.

Synthetic QA proves implementation behavior against the fixture. It does not prove production completeness or performance.

### 15. Completion criteria

Do not call a feature complete until the applicable checks pass:

- repository state is coherent;
- Power BI structural validation passes;
- pages contain real data-bound visuals/functions rather than placeholders;
- rendered layout has been visually checked when the change affects rendering;
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
2. inspect recent commits and current repository state;
3. read `_brief/report-spec.md`, `_brief/decisions.md`, `config/data-contract.yml` and `qa/acceptance.md` as relevant;
4. compare the installed framework/upstream versions only when the user's request makes an update relevant;
5. continue from the existing accepted product rather than rebuilding from scratch.
