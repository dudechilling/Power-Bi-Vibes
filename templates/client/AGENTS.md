# Project Agent Instructions

This project uses Power BI Vibes.

Before making substantial changes:

1. read `.power-bi-vibes/manifest.yml`;
2. read `_brief/report-spec.md` and `_brief/decisions.md` as relevant;
3. read `config/data-contract.yml` before changing ingestion/model assumptions;
4. read `qa/acceptance.md` before changing accepted behavior;
5. follow the Power BI Vibes framework rules from the source/version recorded in the manifest;
6. use the pinned Microsoft Power BI authoring guidance recorded in the manifest for Power BI mechanics.

## Project defaults

- Treat production operational data as restricted unless the user says otherwise.
- Build and visually review against synthetic data when restricted values cannot be shared.
- Keep the current usable product on `main` during normal iterative development.
- Use a temporary branch for substantial experiments on an accepted working product.
- Make descriptive checkpoint commits after validated logical batches.
- Ask the user business questions, not avoidable implementation questions.
- Give short, exact PowerShell/local QA steps when the user must interact with Power BI Desktop.
- Do not send production screenshots or logs outside the approved environment when they expose restricted information.
