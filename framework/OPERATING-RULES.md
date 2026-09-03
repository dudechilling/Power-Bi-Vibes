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

## Existing repository mutation boundary

Repository access does not imply permission to initialize, restructure, clean up, or otherwise mutate an existing implementation.

For any substantive existing repository:

1. inspect before writing;
2. classify the repository and identify the relevant Power BI/system boundary;
3. understand the existing architecture and project conventions before proposing structural change;
4. distinguish the user's requested edit from opportunistic cleanup or framework adoption;
5. do not add Power BI Vibes scaffolding merely because it is absent;
6. keep brownfield and unclear repositories read-only during reconnaissance;
7. begin mutation only when the requested operation is understood and the task authorizes the change;
8. preserve established repository, Git, source-boundary and validation conventions where reasonable.

When an existing repository already contains enough permitted structural information to perform the task, use that evidence rather than asking the user to re-share restricted operational data or schema.

## Copy/paste-first responses

When the user needs material to transfer from ChatGPT into another tool, optimize the response for direct reuse.

- Put prompts intended for another LLM, coding agent, or ChatGPT session in fenced code blocks.
- Put PowerShell, shell commands, SQL, DAX, M, code, JSON, YAML, configuration, and other runnable or paste-ready text in fenced code blocks, using an appropriate language tag when useful.
- Prefer other ChatGPT response elements that provide clean copy/paste behavior when they are better suited to the material.
- Do not put paste-ready prompts, commands, code, or configuration in Markdown blockquotes. Reserve blockquotes for actual quoted material.
- Keep explanation outside the fenced block unless the explanation is intentionally part of the prompt, command sequence, or file content.

## Make the repository durable memory

For Power BI Vibes-managed projects, important state belongs in files, not only chat history:

- approved scope and design -> `_brief/report-spec.md`;
- business and implementation decisions -> `_brief/decisions.md`;
- source expectations -> `config/data-contract.yml`;
- framework/upstream versions and capability state -> `.power-bi-vibes/manifest.yml`;
- durable implementation observations/lessons -> `.power-bi-vibes/learning.yml`;
- local acceptance checks -> `qa/acceptance.md`.

Use `framework/LEARNING.md` to keep the learning log selective. Do not turn it into a transcript of debugging activity. Do not create these Power BI Vibes artifacts in a brownfield repository merely to document reconnaissance unless the user chooses framework adoption.

## Reduce blast radius

Prefer a stable internal data shape. Put source-specific cleanup and column mapping at the ingestion/adapter boundary so a changed export does not require rebuilding the semantic model and pages unnecessarily.

Use names rather than column positions when transforming structured data. Keep the source location swappable through a named parameter rather than hardcoding machine-specific paths throughout M queries.

For brownfield repositories, first identify the existing source-boundary pattern and preserve it unless the requested change justifies a migration.

## Build behavior, then documentation

Do not create polished final documentation around an interface that is still moving. Stabilize the tool, capture real screenshots using synthetic/safe data, then generate user-facing project documentation.

A User Guide should normally follow the report's actual page/navigation order and explain the task each page supports. A Developer Guide, when needed, should map pages/visuals/measures back to canonical fields and source assumptions using the data contract rather than duplicating undocumented logic.

## Accessibility baseline

Follow the pinned Microsoft design guidance. At minimum use readable text sizes, accessible contrast, consistent navigation, alt text for charts where supported, predictable interactions, searchable controls for high-cardinality dimensions, and no meaning conveyed by color alone when another cue is practical.
