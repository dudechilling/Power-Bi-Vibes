# Changelog

## 0.1.3 - 2026-08-31

First-time onboarding and local-readiness pass.

- Added `docs/CREATE-PRIVATE-REPO.md` with click-by-click private GitHub repository creation instructions.
- Changed the recommended new-project setup to initialize the private repository with a README so `main` and the first commit exist before ChatGPT starts writing.
- Added `docs/WINDOWS-SETUP.md` covering Git for Windows, Git identity, HTTPS + Git Credential Manager authentication, private-repository access, short local paths, Power BI Desktop, and common failures.
- Added `scripts/check-local-setup.ps1`, a non-installing readiness checker for Git, Git identity, Git Credential Manager, repository read access, Power BI Desktop, local workspace availability, optional SQLite CLI, and optional dry-run push access.
- Updated the client scaffold so every new project receives `scripts/check-local-setup.ps1` for later local/Desktop handoff.
- Made the framework explicitly distinguish ChatGPT's GitHub authorization from the user's local Windows Git/GitHub authentication.
- Deferred local dependency setup until the first task that requires the local machine instead of making Git/Power BI installation a project-start prerequisite.
- Clarified the minimum local stack: Power BI Desktop, Git for Windows, PowerShell and GitHub authentication. GitHub CLI, GitHub Desktop, Python, VS Code and SQLite CLI remain optional unless a specific task requires them.
- Updated client README/agent guidance, human documentation, Git policy and integrity checks for the new onboarding contract.

## 0.1.2 - 2026-08-31

Repository-integrity hardening pass.

- Replaced the hand-maintained PDF layout with a reproducible `docs/build_guide.py` build from the committed Markdown guide source.
- Added PDF preflight expectations for page count, non-empty page content, full-page rendering, renderer parity, and broad embedded-viewer compatibility.
- Added `scripts/repo_integrity.py` plus a GitHub Actions integrity workflow to catch missing files, stale version references, broken relative links, malformed YAML, scaffold drift, and blank/truncated PDF pages.
- Fixed the bootstrap scaffold so `.gitattributes` is actually installed and documented the exact template-to-client destination mapping.
- Fixed PowerShell examples that previously used shell-style placeholders literally (`%USERPROFILE%`, `<YYYYMMDD-HHMM>`).
- Made destructive Git recovery safer by separating tracked reset from an explicit `git clean -nd` preview before untracked-file deletion.
- Updated framework migrations so private `.power-bi-vibes/learning.yml` is explicitly project-owned and preserved across upgrades.
- Updated the client README template so learning, decisions, capability state, and safe Desktop/Git synchronization are visible project state.

## 0.1.1 - 2026-08-31

External-review hardening pass.

- Reordered bootstrap so the user's job and Power BI fit are established before a Power-BI-specific scaffold is created.
- Added explicit capability/validation state so GitHub authoring is not confused with local Power BI validation or rendering.
- Added safe local Git sync, Desktop-edit preservation, divergence recovery, and optional known-good tags.
- Required a named swappable source parameter for synthetic-to-production transitions.
- Added project learning with private `learning.yml`, selective lesson capture, pruning rules, and privacy-gated promotion to the public framework.
- Added version-sensitive Power BI Desktop/PBIP/PBIR prerequisite checks.
- Strengthened QA with cold-clone refresh, cross-interaction, grand-total, format-string, sorting, and filter-context checks.
- Added client `.gitattributes` for stable TMDL/PBIR diffs.
- Expanded human documentation and resume guidance to reflect the new safeguards.

## 0.1.0 - 2026-08-31

Initial framework release.

- Added ChatGPT-to-private-GitHub bootstrap workflow.
- Added privacy boundary and schema-as-sensitive-data rules.
- Added deterministic synthetic-data workflow and data-contract template.
- Added client Git policy that keeps normal iterative work on `main` and reserves branches for substantial experiments.
- Added layered structural, synthetic, visual and production-smoke-test QA model.
- Added pinned Microsoft `powerbi-authoring` dependency (`0.3.14`, commit `714ea2f9431179344ecd9bc673a9881a773c9f47`).
- Added local metadata-only source inspector for CSV, TSV, XLSX/XLSM and SQLite.
- Added client project templates, bootstrap/resume prompts, and human PDF guide.
