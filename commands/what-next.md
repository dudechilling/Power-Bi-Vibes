# /what-next

## Purpose

Identify the highest-value next decision, test, validation step, or implementation slice from the project's current state.

## Scope

Use the target after the command. If none is supplied, inspect current project state broadly enough to understand the accepted scope, open decisions, QA state, recent lessons, and any blocked validation.

Useful sources include `.power-bi-vibes/manifest.yml`, `.power-bi-vibes/learning.yml`, `_brief/report-spec.md`, `_brief/decisions.md`, `config/data-contract.yml`, `qa/acceptance.md`, recent commits, and current validation state.

## Method

Prioritize next actions by:

- expected decision/user value;
- unresolved correctness risk;
- dependency/blocker removal;
- cost of delay;
- amount of rework avoided by learning sooner;
- reversibility;
- whether a local/Desktop test is now more valuable than more remote authoring.

## Output

Return a short prioritized list.

For each item include:

- next action;
- why it is the highest-value move now;
- what evidence/result it should produce;
- what decision or work it unlocks.

End with one recommended immediate next step.

## Guardrails

- Do not default to "continue building." Testing, clarification, source validation, or stopping scope growth can be the correct next move.
- Do not create a long backlog. Focus on the few actions that materially improve the project.
- Do not modify the project unless the user asks to carry out the recommendation.
