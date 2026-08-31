# Acceptance Checks

Use synthetic data unless the check is explicitly marked as a local production-data smoke test.

## Structural

- [ ] PBIP/PBIR validation passes with no unresolved errors.
- [ ] Every requested page contains functioning data-bound content.

## Functional

- [ ] <Set a filter / perform an action and state the expected result.>

## Visual

- [ ] No clipped or overlapping content at the intended laptop/display size.
- [ ] Labels, tables, slicers and navigation are readable and consistent.

## Production-data smoke test - local only

- [ ] Refresh succeeds against the approved real source.
- [ ] Required fields map successfully through the source adapter.
- [ ] Core totals/measures reconcile against an approved reference check.
- [ ] Performance is acceptable at real data volume.
