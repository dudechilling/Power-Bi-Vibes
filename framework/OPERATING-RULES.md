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
- framework/upstream versions -> `.power-bi-vibes/manifest.yml`;
- local acceptance checks -> `qa/acceptance.md`.

## Reduce blast radius

Prefer a stable internal data shape. Put source-specific cleanup and column mapping at the ingestion/adapter boundary so a changed export does not require rebuilding the semantic model and pages unnecessarily.

Use names rather than column positions when transforming structured data.

## Build behavior, then documentation

Do not create polished final documentation around an interface that is still moving. Stabilize the tool, capture real screenshots using synthetic/safe data, then generate user-facing project documentation.

## Accessibility baseline

Follow the pinned Microsoft design guidance. At minimum use readable text sizes, accessible contrast, consistent navigation, alt text for charts where supported, predictable interactions, searchable controls for high-cardinality dimensions, and no meaning conveyed by color alone when another cue is practical.
