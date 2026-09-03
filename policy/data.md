# Data Workflow

## Data contract first

Create `config/data-contract.yml` once the source structure is known. The contract should stabilize what the Power BI model expects even when the upstream export changes.

Distinguish source field, canonical field, business definition, and display label. These can differ.

## Source adapters

Keep source-specific cleanup close to ingestion. Common adapter responsibilities include choosing the correct worksheet/table/view, header normalization, type coercion, trimming whitespace, mapping renamed fields, excluding harmless extra columns, failing clearly when a required field disappears, and transforming source codes into canonical values only when the mapping is known.

Do not silently reinterpret business meaning to make a refresh pass.

## Parameterize the source boundary

For file and database sources, control the source location/connection through one named Power Query parameter or a small explicit parameter set.

The synthetic fixture and production source should share the same downstream adapter/model contract. Switching from synthetic to production should normally require changing the source parameter, not editing multiple M queries or rewriting downstream logic.

Record the parameter name in `config/data-contract.yml`.

Avoid hardcoded machine-specific absolute paths throughout queries. A relative synthetic fixture path may be used for development where Power BI can resolve it reliably, but the production location must remain externally swappable.

## Synthetic fixtures

Synthetic data should test the report rather than merely fill rows.

Use a deterministic seed and create cases that exercise categories/statuses, relationships, blanks/nulls, edge dates, large and small values, long labels, hyperlinks when applicable, high-cardinality filtering, and expected invalid or exceptional records.

Keep synthetic values obviously fictional when a realistic-looking record could be mistaken for a real person, organization, project or transaction.

Choose fixture volume deliberately. A small fixture is appropriate for logic/UI testing; increase synthetic volume when cardinality or performance behavior needs pre-production testing.

## Real-data smoke test

After synthetic implementation and UI QA pass, switch the configured source parameter to the approved real source locally.

Expect first-refresh credentials or data-source privacy prompts where the source requires them. Keep synthetic and production access paths separable and avoid unnecessarily combining sources in one query chain.

Test the real source locally for refresh success, schema compatibility, unexpected nulls/types, relationship behavior, measures and totals, performance at real volume, and source-specific edge cases absent from the fixture.

Do not convert a local production smoke test into an unrestricted data-sharing requirement. Sanitized error text or a safe description is sufficient when production logs/screenshots cannot be shared.