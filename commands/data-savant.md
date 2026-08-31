# /data-savant

## Purpose

Inspect the current business objective, permitted data structure, synthetic fixture, semantic model, measures, and report design to find analytical value the user has not explicitly requested but the available evidence can support.

## Scope

Use the target supplied after the command. If no target is supplied, inspect the current project state broadly enough to understand the source contract and current analytical model.

Prioritize `config/data-contract.yml`, `_brief/report-spec.md`, current semantic-model definitions, synthetic data, measures, and relevant project lessons.

## Method

Look for high-value opportunities such as:

- aging/backlog analysis;
- forecast drift or variance;
- concentration and dependency risk;
- cohort or benchmark comparisons;
- temporal transitions and state changes;
- outliers and unusual combinations;
- missingness patterns;
- denominator and normalization problems;
- segmentation opportunities;
- process bottlenecks;
- fields collected but not used;
- duplicate or redundant information;
- useful drillthrough relationships;
- measures whose interpretation changes materially when normalized or contextualized;
- high-value analysis blocked by one clearly missing field.

Classify each material idea as one of:

- **DIRECTLY SUPPORTED** - can be built from existing fields and established business meaning;
- **DERIVABLE** - requires a defensible transformation or measure using current data;
- **POSSIBLE WITH ONE MORE FIELD** - potentially valuable but blocked by a specific missing variable;
- **SPECULATIVE** - interesting hypothesis that the current data cannot establish.

## Output

Return a ranked shortlist rather than an exhaustive brainstorm.

For each finding include:

- classification;
- analytical opportunity;
- why it could matter to the user's job;
- evidence/fields that support it;
- any important caveat;
- smallest useful implementation if the user chooses to pursue it.

End with the one or two highest-value opportunities.

## Guardrails

- Do not infer business meaning from a field name when that meaning affects correctness.
- Do not present correlation as explanation or causation.
- Do not invent unavailable data.
- Do not recommend visual complexity solely because Power BI can display it.
- Do not modify the project unless the user subsequently asks to implement selected findings.
