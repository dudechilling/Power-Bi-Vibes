# Acceptance Checks

Use synthetic data unless the check is explicitly marked as a local production-data smoke test.

## Structural

- [ ] PBIP/PBIR validation passes with no unresolved errors, or is explicitly marked pending local execution.
- [ ] Every requested page contains functioning data-bound content.
- [ ] A fresh clone to a short local path opens and refreshes the committed synthetic fixture without manual source-path repairs.

## Functional

- [ ] Slicers and cross-visual interactions affect the intended visuals only.
- [ ] Drillthrough/navigation/bookmarks carry or reset filter context as specified.
- [ ] Row values and grand totals both reconcile against known synthetic fixture values.
- [ ] Measure formats (currency, percentage, units, locale) are intentional.
- [ ] Sort order is deterministic where ordering matters.
- [ ] <Add project-specific action and expected result.>

## Visual

- [ ] Actual Power BI Desktop output has been reviewed when the change affects rendering, or the check is explicitly marked pending local QA.
- [ ] No clipped or overlapping content at the intended laptop/display size.
- [ ] Labels, tables, slicers and navigation are readable and consistent.

## Production-data smoke test - local only

- [ ] Source parameter/connection is switched to the approved real source without rewriting downstream transformations.
- [ ] Refresh succeeds against the approved real source.
- [ ] Required fields map successfully through the source adapter.
- [ ] Core totals/measures reconcile against an approved reference check.
- [ ] Performance is acceptable at real data volume.
