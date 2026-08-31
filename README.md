# Power BI Vibes

**Build useful Power BI tools with ChatGPT, GitHub, and privacy-safe development data.**

Power BI Vibes is a public, machine-readable workflow for people who understand their work but do not need to understand DAX, TMDL, PBIR, Power Query, or Git internals.

The basic pattern is:

1. Create an empty **private** GitHub repository for your project.
2. Connect GitHub to ChatGPT with permission to read and write that repository.
3. Give ChatGPT this repository and your private project repository.
4. Tell ChatGPT to read [`BOOTSTRAP.md`](BOOTSTRAP.md).
5. Describe the job before ChatGPT creates a Power-BI-specific scaffold.
6. Provide only data you are permitted to share. For restricted operational data, provide a scrubbed/template file or a locally generated schema report.
7. ChatGPT creates the project in GitHub using deterministic synthetic data and a swappable source parameter.
8. Structural validation and Power BI Desktop rendering are treated as separate checks: ChatGPT only claims them when the required local tooling actually ran.
9. You connect the real operational source locally and perform the production-data smoke test on your own machine.
10. The project records durable lessons so later agent sessions do not have to rediscover the same implementation knowledge.

## Start here

For a nontechnical walkthrough, read [`START-HERE.md`](START-HERE.md) or the PDF guide in [`docs/Power-BI-Vibes-Guide.pdf`](docs/Power-BI-Vibes-Guide.pdf).

### Bootstrap prompt

```text
I want to build a Power BI tool.

Use this framework:
https://github.com/dudechilling/Power-Bi-Vibes

My private project repository is:
<PASTE YOUR PRIVATE GITHUB REPOSITORY URL>

Read BOOTSTRAP.md in Power-Bi-Vibes and follow it. Do not ask me to share operational data that I am not permitted to share.
```

## What this repository contains

- `BOOTSTRAP.md` - the entrypoint ChatGPT follows when starting or resuming a client project.
- `AGENTS.md` - rules for agents working on this framework itself.
- `framework/` - durable operating rules for privacy, project structure, Git, data contracts, QA, learning, and Microsoft Power BI skill routing.
- `templates/` - files ChatGPT can install into a client project.
- `scripts/inspect-source.ps1` - local metadata-only inspector for CSV, TSV, XLSX/XLSM, and SQLite sources.
- `scripts/repo_integrity.py` - repository/document integrity checks used by CI.
- `prompts/` - copy/paste bootstrap, resume, and update prompts.
- `docs/Power-BI-Vibes-Guide.md` - canonical human guide source.
- `docs/build_guide.py` - reproducible PDF builder for the human guide.
- `docs/Power-BI-Vibes-Guide.pdf` - generated client guide.
- `UPSTREAM.lock.yml` - the tested Microsoft Power BI authoring dependency and immutable commit pin.

## Core boundaries

- **No production operational data in this public repository.**
- **No production operational data in client GitHub repositories unless the client explicitly permits it.**
- Develop with deterministic synthetic data that mirrors the real schema and important edge cases.
- Treat schema, worksheet names, formulas, internal terminology, logs, and screenshots as potentially sensitive too.
- Keep source locations behind a named Power Query parameter so synthetic and production sources can be swapped without rewriting downstream logic.
- Keep the client repository on `main` during normal iterative work. Use a branch for substantial experiments that could destabilize an accepted working product.
- Inspect local Git state before pulling over Power BI Desktop edits.
- Validate structurally and visually before calling a Power BI change complete; mark unavailable checks as pending rather than pretending they ran.
- Private client lessons can become public framework improvements only after abstraction, privacy review, and human approval.

## Microsoft Power BI authoring dependency

Power BI Vibes currently targets Microsoft's `powerbi-authoring` plugin from `microsoft/skills-for-fabric`, pinned in [`UPSTREAM.lock.yml`](UPSTREAM.lock.yml). Power BI Vibes does not claim ownership of Microsoft's materials. See [`THIRD_PARTY_NOTICES.md`](THIRD_PARTY_NOTICES.md).

## Integrity checks

The repository carries a CI audit that checks required files, version consistency, relative links, YAML parsing, scaffold mappings, and the generated PDF. The PDF is built from committed Markdown and checked for valid structure and substantive content on every page before release.

## Status

`v0.1.2` is the repository-integrity hardening release. It makes the client guide reproducible, adds automated integrity checks, closes scaffold/migration gaps, and strengthens safe Git recovery examples before fresh-project external testing.
