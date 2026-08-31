# Project Learning

Power BI Vibes treats the client repository as durable project memory. The learning layer exists to preserve implementation knowledge that a future agent would otherwise have to rediscover.

## What belongs here

Record only durable, consequential knowledge. Good candidates include:

- a source behavior that changes how ingestion must work;
- a Power BI/PBIR/TMDL behavior that caused or prevented a real defect;
- a QA check that exposed a meaningful failure;
- a project convention future sessions must preserve;
- a repeated friction point that changed the workflow;
- a reusable project pattern that has been tested.

Do not log ordinary trial and error, transient command failures, typo fixes, or every debugging step.

## Record types

Client projects keep machine-readable entries in `.power-bi-vibes/learning.yml`.

- `observation` - plausible and potentially useful, but not yet confirmed enough to become a rule.
- `lesson` - confirmed by evidence, recurrence, or a consequential failure/success and worth preserving.
- `pattern` - a stable project-specific approach that should be reused within this project.

Recommended status values are `provisional`, `confirmed`, `rejected`, and `promoted`.

## Learning loop

During work:

1. notice a durable insight;
2. record it as an `observation` without interrupting the user;
3. attach concise evidence and the implication;
4. at a validated checkpoint, confirm, reject, or leave it provisional;
5. prune rejected or low-value observations rather than accumulating a diary;
6. update project instructions, the data contract, acceptance checks, or implementation when a confirmed lesson requires a concrete change.

On resume, read confirmed lessons and patterns before making substantial changes.

## Promotion to Power BI Vibes

A private client project must never automatically write lessons into the public Power-Bi-Vibes repository.

A project lesson may be marked `promotion: candidate` when it appears useful beyond the project. Promotion requires human review and abstraction.

Before a lesson can enter the public framework:

- remove client names, schema names, worksheet/table/field names, URLs, paths, values, volumes, screenshots, and organization-specific terminology;
- preserve only the general mechanism and evidence needed to justify the rule;
- apply the privacy rules in `framework/PRIVACY.md`;
- distinguish a repeated/general lesson from a project-specific preference;
- update the public framework only through its normal review/release process.

If the lesson cannot be expressed without revealing client-specific information, keep it project-local.
