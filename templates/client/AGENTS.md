# Project Agent Instructions

This project uses Power BI Vibes.

Before making substantial changes:

1. read `.power-bi-vibes/manifest.yml`;
2. read confirmed lessons/patterns in `.power-bi-vibes/learning.yml`;
3. read `_brief/report-spec.md` and `_brief/decisions.md` as relevant;
4. read `config/data-contract.yml` before changing ingestion/model assumptions;
5. read `qa/acceptance.md` before changing accepted behavior;
6. follow the Power BI Vibes framework rules from the source/version recorded in the manifest;
7. use the pinned Microsoft Power BI authoring guidance recorded in the manifest for Power BI mechanics.

## Project defaults

- Treat production operational data as restricted unless the user says otherwise.
- Build and visually review against synthetic data when restricted values cannot be shared.
- Keep the current usable product on `main` during normal iterative development.
- Use a temporary branch for substantial experiments on an accepted working product.
- Make descriptive checkpoint commits after validated logical batches.
- Ask the user business questions, not avoidable implementation questions.
- Give short, exact PowerShell/local QA steps when the user must interact with Power BI Desktop.
- Inspect local Git state before telling the user to pull, reset or discard Desktop-written files.
- Do not claim structural or visual validation ran when the current environment could not execute it; record the check as pending instead.
- Keep file/database source locations behind the named source parameter recorded in `config/data-contract.yml`.
- Record durable implementation insights in `.power-bi-vibes/learning.yml`; prune debugging noise.
- Never promote private project lessons directly into the public framework. Mark promotion candidates and require privacy abstraction plus human review.
- Do not send production screenshots or logs outside the approved environment when they expose restricted information.
