# Project Learning

Power BI Vibes treats the client repository as durable project memory. Preserve implementation knowledge that a future agent would otherwise have to rediscover, but keep the learning layer selective.

## What belongs here

Record only durable, consequential knowledge: source behavior that changes ingestion, a Power BI/PBIR/TMDL behavior that caused or prevented a real defect, a QA check that exposed a meaningful failure, a project convention future sessions must preserve, a repeated friction point that changed the workflow, or a tested reusable project pattern.

Do not log ordinary trial and error, transient command failures, typo fixes, or every debugging step.

## Record types

Client projects keep machine-readable entries in `.power-bi-vibes/learning.yml`:

- `observation` - plausible and potentially useful, but not yet confirmed enough to become a rule;
- `lesson` - confirmed by evidence, recurrence, or a consequential failure/success and worth preserving;
- `pattern` - a stable project-specific approach that should be reused within this project.

Recommended status values are `provisional`, `confirmed`, `rejected`, and `promoted`.

## Learning loop

During work: notice a durable insight, record it concisely with evidence and implication, confirm/reject it at a validated checkpoint, prune low-value observations rather than accumulating a diary, and update project instructions/data contract/acceptance/implementation when a confirmed lesson requires a concrete change.

On resume, read confirmed lessons and patterns before making substantial changes.

## Promotion to Power BI Vibes

A private client project must never automatically write lessons into the public framework. Promotion requires human review and abstraction.

Before a lesson enters the public framework, remove client names, schema names, worksheet/table/field names, URLs, paths, values, volumes, screenshots, and organization-specific terminology; preserve only the general mechanism and evidence; apply `policy/privacy.md`; distinguish a repeated/general lesson from a project-specific preference; and use the normal framework review/release process.

If the lesson cannot be expressed without revealing client-specific information, keep it project-local.