# /repo-recon

## Purpose

Perform a non-mutating architectural reconnaissance of an existing Power BI repository so the agent can safely explain, debug, repair, extend, reverse engineer, refactor, validate, or migrate the existing implementation.

This command is an explicit user-invoked lens. It complements, but does not replace, the mandatory Repository Mode Gate in `BOOTSTRAP.md`.

## Mode

- analysis only
- non-mutating
- read-only repository inspection

## Method

1. Confirm the target repository and relevant branch/context.
2. Read repository-level instructions and conventions first when present.
3. Locate the Power BI boundary and entrypoints, including `.pbip`, `.Report`, `.SemanticModel`, PBIR, TMDL, Power Query/model/report assets, scripts, and validation tooling as relevant.
4. Inspect only enough surrounding structure and recent history to understand how the implementation is organized and how the requested task fits.
5. Identify source/data boundaries, parameters, synthetic/test fixtures, and privacy-sensitive surfaces without requesting restricted operational data when repository structure is sufficient.
6. Identify existing validation mechanisms and distinguish structural validation from rendered Power BI Desktop validation.
7. Preserve existing architecture and conventions as the default. Treat framework adoption, cleanup, restructuring, and migration as separate decisions.
8. Stop expanding the audit when additional inspection would not change the system map or next action.

## Output contract

Return a compact repository system map with:

- **Repository mode:** `brownfield-powerbi`, `managed-existing`, or `unknown-existing` as applicable.
- **Power BI entrypoint(s):** relevant `.pbip` or equivalent project boundary.
- **Report structure:** report/PBIR location and notable organization relevant to the task.
- **Semantic model:** model/TMDL location and notable organization relevant to the task.
- **Data/source architecture:** source boundaries, parameters/adapters, synthetic/test mode, and privacy constraints that can be established safely.
- **Validation capability:** what can actually be checked in the current environment and what remains pending.
- **Project conventions:** material repository, Git, scripting, naming, generation, or QA conventions.
- **Current task fit:** where the user's requested explain/debug/repair/extend/reverse-engineer/refactor/validate/migrate task touches the system.
- **Material unknowns:** only unknowns that could change the recommended action.
- **Next action:** the smallest justified next inspection, change proposal, or validation step.

## Guardrails

- Do not mutate the repository.
- Do not add Power BI Vibes scaffolding or metadata merely because it is absent.
- Do not perform opportunistic cleanup.
- Do not ask the user to share operational data they are not permitted to share.
- Treat schemas, screenshots, URLs, internal names, queries, and connection metadata as potentially sensitive.
- Do not claim structural or rendered validation occurred unless the applicable check actually ran.
- Do not turn a focused task into a full repository audit unless broader architecture is necessary to answer it safely.
