# QA Standard

Power BI QA has distinct layers. Passing one layer does not prove the others.

## 1. Repository and format validation

Confirm project structure and generated files are coherent. For PBIR/PBIP work, use the validation workflow required by the pinned Microsoft authoring guidance.

Fix structural validation failures before treating Desktop rendering as authoritative.

## 2. Synthetic functional QA

Using deterministic synthetic data, verify pages load, visuals bind to intended fields/measures, slicers filter expected visuals, drillthrough/navigation works, hyperlinks are safe and correct, totals reconcile against known fixture values, and empty/edge cases render intelligibly.

## 3. Visual QA

For changes that affect rendered output, inspect actual Power BI Desktop output when available. Check clipping and overlap, readable type, hierarchy and spacing, empty states, sorting, table widths, filter usability, consistency across pages, and accessibility/contrast.

Mockups are design inputs, not proof that the PBIP renders correctly.

## 4. Production-data smoke test

Run locally with the approved real source. Verify refresh, schema fit, relationships, totals, real-volume performance and source-specific edge cases.

Do not require production screenshots to be sent to the agent when sharing is restricted.

## Acceptance file

Maintain `qa/acceptance.md` with concrete steps. Each acceptance item should state setup/filter state, user action, and expected result.
