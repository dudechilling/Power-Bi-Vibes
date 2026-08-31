# /blind-spots

## Purpose

Surface consequential assumptions, omissions, data gaps, user conditions, operational constraints, and maintenance risks that the current project may be ignoring.

## Scope

Use the target after the command. If none is supplied, inspect the current project specification, data contract, decisions, acceptance criteria, and relevant implementation state.

## Method

Look for blind spots across:

- users and decision context;
- source completeness and data provenance;
- ambiguous business definitions;
- missing denominators or comparison groups;
- edge cases and unusual operating periods;
- refresh cadence and stale data;
- permissions, privacy and sensitive outputs;
- accessibility and usability;
- local/Desktop versus Service/Fabric behavior;
- performance and scale;
- deployment and maintenance ownership;
- source-schema change risk;
- filter/interaction behavior;
- misleading totals, averages or rankings;
- assumptions about what users will notice or understand;
- dependencies on one person, file, path, export, or undocumented process.

## Output

Return only material blind spots.

For each include:

- **Blind spot** - what may be missing or assumed;
- **Evidence** - why it is plausible from current project state;
- **Consequence** - what could go wrong;
- **Resolution** - the smallest test, question, or design change that would close it;
- **Priority** - now, before release, or later.

## Guardrails

- Suspicion is not evidence. Label uncertain findings as such.
- Do not manufacture theoretical risks with no plausible project consequence.
- Do not modify the project unless the user asks to act on findings.
