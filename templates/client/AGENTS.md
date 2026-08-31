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

## User-invoked analytical commands

Power BI Vibes defines optional prompt conventions in the public framework `commands/` directory. If a user message begins with a registered trigger such as `/premature-framing`, `/data-savant`, `/blind-spots`, `/stress-test`, `/simplify`, `/what-next`, or `/commands`, read `commands/registry.yml` and the referenced command definition from the framework version recorded in `.power-bi-vibes/manifest.yml` before answering.

Text after the trigger is the requested target/scope. If no target is supplied, use the current request and the smallest relevant project context.

Analytical commands are non-mutating by default. Return the analysis first and wait for the user to choose what to implement. A command never overrides project privacy, Git, evidence, QA, or validation rules.

## Project defaults

- Treat production operational data as restricted unless the user says otherwise.
- Build and visually review against synthetic data when restricted values cannot be shared.
- Keep the current usable product on `main` during normal iterative development.
- Use a temporary branch for substantial experiments on an accepted working product.
- Make descriptive checkpoint commits after validated logical batches.
- Ask the user business questions, not avoidable implementation questions.
- Give short, exact PowerShell/local QA steps when the user must interact with Power BI Desktop.
- Treat ChatGPT GitHub authorization and the user's local GitHub/Git authentication as separate capability checks.
- Defer local-machine setup until the first Desktop handoff unless a local source-inspection task requires it earlier.
- Before first local QA, ensure `scripts/check-local-setup.ps1` exists and use it to identify missing Git, identity, repository-access, or Power BI Desktop requirements.
- Do not require GitHub CLI, GitHub Desktop, SSH keys, Python, or other developer tooling unless the task/environment specifically needs them.
- Inspect local Git state before telling the user to pull, reset or discard Desktop-written files.
- Do not claim structural or visual validation ran when the current environment could not execute it; record the check as pending instead.
- Keep file/database source locations behind the named source parameter recorded in `config/data-contract.yml`.
- Record durable implementation insights in `.power-bi-vibes/learning.yml`; prune debugging noise.
- Never promote private project lessons directly into the public framework. Mark promotion candidates and require privacy abstraction plus human review.
- Do not send production screenshots or logs outside the approved environment when they expose restricted information.
