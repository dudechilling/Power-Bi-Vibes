# /stress-test

## Purpose

Try to break the current idea, specification, model, report, workflow, or maintenance plan using realistic failure modes before they become user-facing defects.

## Scope

Use the target after the command. If none is supplied, inspect the smallest relevant set of project artifacts needed to challenge the current design.

## Method

Test against plausible failure classes such as:

- missing, duplicated, late, malformed, or unexpectedly high-volume source data;
- schema additions, removals, renames, or type changes;
- zero, negative, extreme, boundary, or null values;
- contradictory or interacting filters;
- misleading totals, ratios, averages, ranks, or fiscal-period comparisons;
- broken relationships or unexpected many-to-many behavior;
- stale bookmarks, drillthrough context, hidden filters, or navigation states;
- long labels, unusual characters, accessibility, and small-screen constraints;
- local path, credential, refresh, privacy/firewall, and gateway assumptions;
- performance at realistic production scale;
- user actions outside the intended happy path;
- Git/Desktop divergence and recovery;
- maintenance by a future agent or user without the current conversation context.

## Output

Rank failure modes by practical consequence.

For each material failure mode include:

- scenario;
- expected failure or misleading behavior;
- current protection, if any;
- how to test it;
- smallest hardening action.

Separate **must test before release** from **useful resilience tests**.

## Guardrails

- Prefer realistic adversarial cases over exotic hypotheticals.
- Do not claim a failure exists when only a vulnerability is plausible.
- Do not mutate the project unless the user asks to implement selected hardening actions.
