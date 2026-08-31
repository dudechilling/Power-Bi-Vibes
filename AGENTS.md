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
11. Treat private-project learning as private by default. A lesson may enter the public framework only after client-specific details are removed and a human reviews both privacy and whether the lesson generalizes.
12. Do not claim Power BI validation/rendering occurred merely because repository writes succeeded. Capability and validation state must remain explicit.
13. Treat generated artifacts as build outputs that require independent verification. Do not assume a successful file write means a PDF, archive, or other binary is complete or portable.
14. Treat ChatGPT GitHub authorization and local Git/GitHub authentication as separate capabilities. Do not assume one proves the other.
15. Defer local dependency installation until a local task needs it. Keep the required client stack minimal and distinguish required from optional tools.

## Release check

Before changing `VERSION`:

- check links and pinned upstream references;
- run `scripts/inspect-source.ps1` against representative CSV/XLSX fixtures and, when available, SQLite;
- syntax-check and exercise `scripts/check-local-setup.ps1` on Windows before claiming its local-detection behavior is fully verified;
- review the bootstrap workflow for privacy regressions and premature Power-BI-specific scaffolding;
- confirm client templates include the current learning, source-parameter, capability, Git-recovery, `.gitattributes`, acceptance, and local-readiness contracts;
- confirm the private-repository creation guide still matches GitHub's current repository creation workflow;
- confirm the Windows setup guide still reflects current Git for Windows/Git Credential Manager behavior and does not require optional developer tooling without need;
- reject any proposed upstream lesson that exposes client schema, terminology, URLs, paths, values, volumes, screenshots, or organization-specific details;
- compare `README.md`, `START-HERE.md`, `BOOTSTRAP.md`, human guide source, templates, `VERSION`, and `CHANGELOG.md` for contradictory or stale workflow/version claims;
- build the PDF from its committed source using `docs/build_guide.py` rather than hand-maintaining a separate layout;
- preflight the generated PDF, confirm the expected page count, and verify every page contains substantive text or intentional visual content;
- render every PDF page and visually inspect all pages for clipping, blank/missing pages, broken glyphs, or overflow;
- verify the PDF in two renderers when practical and normalize through Ghostscript when available for broad embedded-viewer compatibility;
- confirm the committed PDF's byte size/hash matches the locally verified artifact after upload;
- confirm templates do not contain example secrets or client data;
- summarize material changes and known unverified items in the changelog/release notes.

A release is not complete while any generated client-facing artifact has been checked only in the environment that created it.
