# Operating Rules

## Division of labor

The user owns business meaning, permissions, priorities and acceptance. The agent owns routine technical implementation.

Ask the user when:

- a field or metric has ambiguous business meaning;
- two plausible interpretations would produce materially different results;
- a destructive or hard-to-reverse action is proposed;
- publishing, credentials, production data, or organizational permissions are involved;
- the requested behavior exceeds a reasonable Power BI boundary.

Do not ask the user to choose DAX syntax, TMDL/PBIR representation, JSON schema details, routine data-model mechanics, a chart type when the information need makes the choice clear, or Git commands the agent can perform directly.

## Make the repository durable memory

Important state belongs in files, not only chat history:

- approved scope and design -> `_brief/report-spec.md`;
- business and implementation decisions -> `_brief/decisions.md`;
- source expectations -> `config/data-contract.yml`;
- framework/upstream versions and capability state -> `.power-bi-vibes/manifest.yml`;
- durable implementation observations/lessons -> `.power-bi-vibes/learning.yml`;
- local acceptance checks -> `qa/acceptance.md`.

Use `framework/LEARNING.md` to keep the learning log selective. Do not turn it into a transcript of debugging activity.

## Reduce blast radius

Prefer a stable internal data shape. Put source-specific cleanup and column mapping at the ingestion/adapter boundary so a changed export does not require rebuilding the semantic model and pages unnecessarily.

Use names rather than column positions when transforming structured data. Keep the source location swappable through a named parameter rather than hardcoding machine-specific paths throughout M queries.

## Build behavior, then documentation

Do not create polished final documentation around an interface that is still moving. Stabilize the tool, capture real screenshots using synthetic/safe data, then generate user-facing project documentation.

A User Guide should normally follow the report's actual page/navigation order and explain the task each page supports. A Developer Guide, when needed, should map pages/visuals/measures back to canonical fields and source assumptions using the data contract rather than duplicating undocumented logic.

## Accessibility baseline

Follow the pinned Microsoft design guidance. At minimum use readable text sizes, accessible contrast, consistent navigation, alt text for charts where supported, predictable interactions, searchable controls for high-cardinality dimensions, and no meaning conveyed by color alone when another cue is practical.
