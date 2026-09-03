# Power BI Vibes Bootstrap

Use this workflow for starting, adopting, auditing, or resuming a client Power BI project. Read root `AGENTS.md` first.

## Required starting context

Have the Power-Bi-Vibes framework repository, the user-designated client repository, any user-supplied local clone path, and a clear write path when mutation is required.

A local clone path is context, not proof that the current agent can access the filesystem, execute commands, control Power BI Desktop, or use the user's local Git/GitHub authentication. Determine those capabilities separately.

Repository access does not imply permission to initialize, restructure, clean up, or otherwise mutate an existing implementation.

## Capability state

Before substantial implementation, distinguish:

- repository read/write capability;
- access to a supplied local clone;
- local command execution;
- local Git/GitHub authentication;
- Power BI Desktop control/reload/screenshot capability;
- structural validation state;
- rendered/visual validation state.

Record material capability limits in `.power-bi-vibes/manifest.yml` for managed projects or approved framework adoptions. Never describe a file as structurally or visually validated unless the applicable check actually ran.

## Hard boundaries

- Never write client project files into the public Power-Bi-Vibes repository.
- Never request production operational data by default.
- Treat schema, screenshots, logs, URLs, internal terminology, formulas, relationships, and metadata as potentially sensitive.
- Never commit credentials, secrets, tokens, personal authentication material, or production data unless the user explicitly confirms repository storage is permitted.
- Develop and visually review with synthetic data when production values are restricted.
- Keep production smoke testing local when required by the data boundary.
- Private-project lessons never promote themselves into the public framework.
- Do not make the user install local tooling at project kickoff unless the task needs the local machine.
- Classify substantive existing repositories before mutation.
- Brownfield and unclear repositories remain read-only during reconnaissance.

## 1. Inspect the target

Confirm the client repository, record any local clone path as context, inspect existing instructions and repository structure, and determine whether the repository is intentionally blank or already contains a substantive implementation.

A README-only repository can be treated as a new project.

## 2. Run the Repository Mode Gate

Classify as:

- `greenfield` - empty, README-only, or intentionally blank;
- `managed-existing` - an existing Power BI Vibes project;
- `brownfield-powerbi` - a substantive existing Power BI implementation without Power BI Vibes ownership;
- `unknown-existing` - substantive repository whose relevant architecture or Power BI boundary is unclear.

Mode controls the next action:

- `greenfield` -> understand the job and confirm Power BI fit before initialization;
- `managed-existing` -> use the resume behavior below;
- `brownfield-powerbi` -> perform bounded read-only reconnaissance;
- `unknown-existing` -> remain read-only until the relevant system boundary is clear.

Do not add Power BI Vibes scaffolding to a substantive existing repository merely because framework metadata is absent. Adoption is a separate decision.

## 3. Load only relevant policy

Root `AGENTS.md` is always authoritative for common behavior. Load the domain policy required by the work:

- `policy/privacy.md`
- `policy/data.md`
- `policy/git.md`
- `policy/qa.md`
- `policy/power-bi.md`
- `policy/learning.md`
- `UPSTREAM.lock.yml` when Power BI mechanics or compatibility matter.

Do not load every policy file mechanically when the task does not need it.

## 4. Brownfield reconnaissance

For `brownfield-powerbi` and `unknown-existing`, inspect only what is needed to understand the user's requested operation. Relevant evidence may include repository instructions, `.pbip` entrypoints, `.Report`/PBIR structure, `.SemanticModel`/TMDL, Power Query/source definitions, scripts, validation tooling, safe fixtures, generated/source-controlled boundaries, documentation, decisions, and acceptance criteria.

Establish a compact system map containing, as applicable, repository mode, Power BI entrypoints, report/model locations, source/data boundary, validation capability, relevant conventions, the requested operation, and material unknowns.

Preserve established architecture and conventions where reasonable. Separate the requested edit from opportunistic cleanup.

## 5. Establish the job and Power BI fit

For greenfield work, ask one concise job-focused question before creating Power-BI-specific structure. Infer routine technical choices.

If the core requirement depends on transactional writeback, multi-user record editing, complex workflow state, or other behavior that Power BI cannot reasonably provide, surface that before scaffolding.

For brownfield work, do not restart generic product discovery when the user already supplied a concrete operation.

## 6. Initialize a greenfield client repository

Only after Power BI fit is established, install the mirrored client template from `templates/client/` so template path equals installed path:

```text
AGENTS.md
CLAUDE.md
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
qa/
  acceptance.md
scripts/
  check-local-setup.ps1
```

Copy each tracked file from `templates/client/` to the same relative path in the client repository. Do not maintain a separate source-to-destination mapping table.

Create `data/synthetic/` and `powerbi/` only when the implementation needs tracked files there; Git does not track empty directories.

The project manifest records installed Power-Bi-Vibes version/source, pinned Microsoft authoring dependency, initialization date, development-data mode, material execution capabilities, pending validation states, and intentional deviations.

## 7. Acquire a safe source representation

When more source information is needed, prefer: approved real sample when explicitly permitted; scrubbed/template source; metadata-only schema report generated locally; or manually described schema.

When permitted repository structure already contains enough evidence, use it rather than asking the user to re-share data or schema.

## 8. Stabilize the source boundary

For managed projects, create or update `config/data-contract.yml` once source structure is known. Keep file/database source location behind one named Power Query parameter or a small explicit parameter set so synthetic-to-production switching does not require downstream rewrites.

For brownfield projects, preserve the existing source-boundary convention unless the user chooses migration or the requested change requires it.

## 9. Use deterministic synthetic fixtures

For greenfield and managed projects, use a fixed seed and exercise important categories/statuses, relationships, nulls, boundary dates, legitimate numeric extremes, long labels, unusual valid characters, and relevant edge cases.

For brownfield projects, use existing safe fixtures when adequate.

## 10. Plan before large greenfield builds

Use `_brief/report-spec.md` for the approved audience/job, first-build scope, page/feature plan, measures/business rules, navigation/interactions, accessibility, source/refresh assumptions, delivery assumptions, and unresolved business decisions.

Small corrective edits do not require a full planning cycle. Brownfield projects should use existing specifications first.

## 11. Build and validate in logical batches

Typical greenfield sequence: source adapter, semantic model/core measures, one usable workflow slice, structural validation when executable, rendered/local QA when Desktop access exists, checkpoint commit, then the next feature.

For brownfield work, limit implementation and validation to the requested scope unless the user asks for a wider audit.

Follow `policy/qa.md`. Mark unavailable checks pending instead of pretending they ran.

## 12. Capture durable lessons selectively

Follow `policy/learning.md`. Managed projects record durable implementation insights in `.power-bi-vibes/learning.yml`; debugging noise stays out. Brownfield projects do not receive this metadata unless the user chooses framework adoption.

## 13. Git behavior

Follow `policy/git.md` for managed projects and the repository's established Git policy for brownfield projects. Inspect local state before pulling, resetting, reverting, or discarding Power BI Desktop edits.

## 14. First local handoff

Do not force local setup at kickoff. When Desktop or local file access becomes necessary, point first-time Windows users to `docs/windows-setup.md` and use the client readiness checker:

```powershell
.\scripts\check-local-setup.ps1 -RepositoryUrl https://github.com/OWNER/PROJECT.git
```

Confirm current Power BI Desktop requirements for the exact PBIP/PBIR format before the first local open.

## 15. Production-data smoke test

After safe/synthetic QA passes, switch to the approved real source locally, refresh, verify schema compatibility, relationships, important measures, performance, and source-specific edge cases. Record only sanitized failures when production details cannot be shared.

## Completion criteria

Do not call affected work complete until applicable checks pass or are explicitly marked pending: coherent repository state, structural validation, real data-bound behavior, rendered layout review, requested interactions, current acceptance steps, and required documentation.

## Resume behavior

For `managed-existing` projects:

1. read project `AGENTS.md` and `.power-bi-vibes/manifest.yml`;
2. read confirmed lessons/patterns in `.power-bi-vibes/learning.yml`;
3. inspect recent commits and current repository state;
4. read `_brief/report-spec.md`, `_brief/decisions.md`, `config/data-contract.yml`, and `qa/acceptance.md` as relevant;
5. compare framework/upstream versions only when relevant;
6. continue from the accepted product rather than rebuilding.

If those artifacts are absent but substantive Power BI assets exist, return to the Repository Mode Gate instead of assuming a broken managed project.