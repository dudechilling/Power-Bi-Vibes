# Release Procedure

Use this checklist before changing `VERSION` or publishing a framework release.

- check links and pinned upstream references;
- run `tools/inspect-source.ps1` against representative CSV/XLSX fixtures and, when available, SQLite;
- syntax-check and exercise `templates/client/scripts/check-local-setup.ps1` on Windows before claiming its detection behavior is fully verified;
- review `workflows/bootstrap.md` for privacy regressions and premature Power-BI-specific scaffolding;
- run the repository-mode evaluation cases in `maintainer/evals/repository-modes.md`, including a representative foreign brownfield repository containing existing Power BI assets;
- confirm a brownfield bootstrap performs read-only reconnaissance before mutation and does not install Power BI Vibes scaffolding merely because framework metadata is absent;
- confirm the canonical bootstrap prompt is aligned across `prompts/BOOTSTRAP.txt`, `README.md`, and `docs/getting-started.md`;
- confirm a supplied local clone is not treated as proof of local filesystem access or local Git authentication;
- confirm client templates include the current learning, source-parameter, capability, Git-recovery, `.gitattributes`, acceptance, and local-readiness contracts;
- confirm `docs/github-setup.md` still matches GitHub's current repository creation workflow;
- confirm `docs/windows-setup.md` still reflects current Git for Windows/Git Credential Manager behavior and does not require optional developer tooling without need;
- reject any proposed upstream lesson that exposes client schema, terminology, URLs, paths, values, volumes, screenshots, or organization-specific details;
- compare `README.md`, `workflows/bootstrap.md`, `docs/getting-started.md`, templates, `VERSION`, and `CHANGELOG.md` for contradictory or stale workflow/version claims;
- build the PDF from `docs/getting-started.md` using `tools/build-guide.py` rather than maintaining a separate Markdown guide source;
- preflight the generated PDF, confirm the expected page count, and verify every page contains substantive text or intentional visual content;
- render every PDF page and visually inspect all pages for clipping, blank/missing pages, broken glyphs, or overflow;
- verify the PDF in two renderers when practical and normalize through Ghostscript when available for broad embedded-viewer compatibility;
- confirm the committed PDF's byte size/hash matches the locally verified artifact after upload;
- confirm templates do not contain example secrets or client data;
- summarize material changes and known unverified items in the changelog/release notes.

A release is not complete while any generated client-facing artifact has been checked only in the environment that created it.