# Data Workflow

## Data contract first

Create `config/data-contract.yml` once the source structure is known. The contract should stabilize what the Power BI model expects even when the upstream export changes.

Distinguish source field, canonical field, business definition, and display label. These can differ.

## Source adapters

Keep source-specific cleanup close to ingestion. Common adapter responsibilities include choosing the correct worksheet/table/view, header normalization, type coercion, trimming whitespace, mapping renamed fields, excluding harmless extra columns, failing clearly when a required field disappears, and transforming source codes into canonical values only when the mapping is known.

Do not silently reinterpret business meaning to make a refresh pass.

## Synthetic fixtures

Synthetic data should test the report rather than merely fill rows.

Use a deterministic seed and create cases that exercise categories/statuses, relationships, blanks/nulls, edge dates, large and small values, long labels, hyperlinks when applicable, high-cardinality filtering, and expected invalid or exceptional records.

Keep synthetic values obviously fictional when a realistic-looking record could be mistaken for a real person, organization, project or transaction.

## Real-data smoke test

After synthetic implementation and UI QA pass, test the real source locally for refresh success, schema compatibility, unexpected nulls/types, relationship behavior, measures and totals, performance at real volume, and source-specific edge cases absent from the fixture.

Do not convert a local production smoke test into an unrestricted data-sharing requirement.
