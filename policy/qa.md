# QA Standard

Power BI QA has distinct layers. Passing one layer does not prove the others.

## 1. Repository and format validation

Confirm project structure and generated files are coherent. For PBIR/PBIP work, use the validation workflow required by the pinned Microsoft authoring guidance.

Fix structural validation failures before treating Desktop rendering as authoritative.

For client-ready projects, also test a fresh clone to a short local path. It should open and refresh the committed synthetic fixture without manual path repairs or reliance on uncommitted local settings.

## 2. Synthetic functional QA

Using deterministic synthetic data, verify:

- pages load and visuals bind to intended fields/measures;
- slicers and cross-visual interactions filter only the visuals they are supposed to filter;
- drillthrough/navigation/bookmarks carry or reset filter context as specified;
- hyperlinks are safe and correct;
- row values and grand totals are both correct;
- measure format strings, currencies, percentages, units and locales are intentional;
- sort order is deterministic, including Sort By Column behavior where used;
- empty/edge cases render intelligibly.

## 3. Visual QA

For changes that affect rendered output, inspect actual Power BI Desktop output when available. Check clipping and overlap, readable type, hierarchy and spacing, empty states, sorting, table widths, filter usability, consistency across pages, and accessibility/contrast.

Mockups are design inputs, not proof that the PBIP renders correctly.

Structural validity does not rule out Desktop failures. Actively check for classes such as broken field/measure references, missing custom visuals/resources, stale bookmark/drillthrough references, canvas clipping, relationship/sort issues, and other render/open-time behavior relevant to the project's features. Treat specific examples as version-sensitive rather than permanent bug claims.

## 4. Production-data smoke test

Run locally with the approved real source. Verify refresh, schema fit, relationships, totals, real-volume performance and source-specific edge cases.

Expect credential/privacy prompts where applicable. Keep synthetic and production sources separable so source switching does not unnecessarily create Power Query privacy/firewall conflicts.

Do not require production screenshots to be sent to the agent when sharing is restricted.

## Local QA handoff

After an agent mutates a client/target repository, its final response must include a copy/paste-ready local QA handoff unless the user explicitly declines one.

The handoff begins with one self-contained fenced `powershell` block. It should use the user's known local clone path when available; otherwise use a clear placeholder.

The block must be safe by default:

1. verify the clone path and `Set-Location` into it;
2. run `git status --short --branch`;
3. stop if any local tracked or untracked changes exist, preserving possible Power BI Desktop edits for deliberate review;
4. run `git pull --ff-only` only from a clean worktree;
5. run the managed-project readiness checker on the first relevant local handoff when available;
6. start only services whose commands are already established by the target repository or user;
7. launch the exact relevant `.pbip` or `.pbix` with `Start-Process` when Desktop QA applies and repository evidence identifies the entrypoint.

Do not guess service commands, entrypoints, or machine dependencies. If multiple Power BI entrypoints exist and the correct one is ambiguous, surface the choice instead of launching one arbitrarily.

Do not include destructive Git recovery, `git clean`, `git reset`, credential changes, or package/tool installation in the routine handoff block.

Immediately after the block, provide the task-specific QA actions and expected results. Use the managed project's `qa/acceptance.md` when available and supplement it with checks specific to the change just made.

## Validation-state honesty

If the current environment cannot execute a validator or Power BI Desktop, record that layer as pending. Never convert "file written successfully" into "Power BI validated successfully."

A generated local QA handoff does not mean local QA occurred. Keep those checks pending until the user or an available local execution environment actually performs them.

## Acceptance file

Maintain `qa/acceptance.md` with concrete steps. Each acceptance item should state setup/filter state, user action, and expected result.
