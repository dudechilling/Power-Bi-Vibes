# Power BI Vibes - Framework Agent Instructions

These instructions govern agents editing the **Power-Bi-Vibes framework repository itself**. Client project rules are defined in `BOOTSTRAP.md`, `framework/`, and `templates/client/AGENTS.md`.

## Objective

Maintain a portable, nontechnical-user workflow that lets ChatGPT and compatible coding agents create and maintain Power BI PBIP projects using privacy-safe data representations.

## Framework rules

1. Keep the public framework free of client operational data, private schemas, credentials, tokens, and client-specific repository URLs.
2. Keep machine instructions and human instructions aligned. When behavior changes, update `BOOTSTRAP.md`, relevant files under `framework/`, templates, and human documentation in the same logical change.
3. Do not silently track Microsoft's moving `main`. Update `UPSTREAM.lock.yml` only after checking the new `powerbi-authoring` release and its relevant behavioral changes.
4. Prefer durable principles over product-specific UI details. Put volatile setup steps in human documentation rather than core operating rules.
5. Treat `BOOTSTRAP.md` as the canonical machine entrypoint.
6. Preserve backward compatibility for client manifests when practical. If a framework change requires client migration, document the migration explicitly.
7. Do not turn the framework into a Power BI textbook. Teach only what the user needs to act or make a business decision.
8. Test scripts with representative safe fixtures before release.
9. Keep `main` as the current working framework. Use a temporary branch for major framework experiments when needed.
10. Never force-push or rewrite public release history after publication.

## Release check

Before changing `VERSION`:

- check links and pinned upstream references;
- run `scripts/inspect-source.ps1` against representative CSV/XLSX fixtures and, when available, SQLite;
- review the bootstrap workflow for privacy regressions;
- render and inspect the PDF guide;
- confirm templates do not contain example secrets or client data;
- summarize breaking changes in the commit/release notes.
