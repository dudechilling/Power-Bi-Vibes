# Changelog

## Unreleased

Brownfield repository reconnaissance and bootstrap hardening.

- Added a mandatory Repository Mode Gate to classify target repositories as `greenfield`, `managed-existing`, `brownfield-powerbi`, or `unknown-existing` before scaffolding or substantive mutation.
- Added bounded read-only brownfield reconnaissance for unfamiliar existing Power BI repositories, including PBIP/PBIR/TMDL structure, report and semantic-model boundaries, source architecture, validation tooling, and project conventions.
- Added an explicit mutation boundary: repository write capability does not imply permission to initialize, restructure, clean up, or install Power BI Vibes scaffolding into an existing implementation.
- Added `/repo-recon` as an optional non-mutating command for explicit architectural mapping of an unfamiliar Power BI repository. The command complements rather than replaces automatic repository classification.
- Updated bootstrap sequencing so greenfield projects retain the job-first workflow while brownfield projects inspect the existing implementation before generic product-discovery questions.
- Updated the canonical bootstrap prompt from a greenfield-only "build a Power BI tool" framing to a neutral "work on a Power BI project" framing.
- Added project repository and local clone fields to the bootstrap prompt. The local path is contextual and does not imply that the current agent has local filesystem access or authenticated local Git access.
- Updated onboarding guidance to support both new repositories and existing Power BI repositories without requiring users to create a blank replacement repository.
- Added repository-mode behavioral evaluation cases covering README-only greenfield repos, existing PBIP/PBIR/TMDL projects, managed Power BI Vibes projects, mixed software repositories, explicit read-only work, restricted-data scenarios, and supplied local clones.
- Updated framework release checks so brownfield behavior, prompt alignment, local-clone capability separation, and no-scaffold-before-reconnaissance behavior must be reviewed before release.
- Updated core operating rules and framework agent guidance to preserve established brownfield architecture and keep GitHub authorization, local filesystem access, and local Git/GitHub authentication as separate capabilities.
- Updated README and START-HERE documentation to describe repository modes, brownfield behavior, `/repo-recon`, and local-clone handling.
- The generated client PDF has not been regenerated or release-version metadata advanced as part of these source changes; those remain release-gate work.

## 0.1.4 - 2026-08-31

User-invoked analytical command and response-formatting pass.

- Added `commands/` with a machine-readable `registry.yml` and human command menu.
- Added `/premature-framing`, `/data-savant`, `/blind-spots`, `/stress-test`, `/simplify`, `/what-next`, and `/commands` conventions.
- Made analytical commands non-mutating by default so they return analysis/recommendations without silently changing the project.
- Added optional target syntax such as `/stress-test the forecasting logic` and `/data-savant our current source schema`.
- Updated the main README to document command behavior, examples, boundaries, and discovery.
- Added a copy/paste-first response convention: prompts for other LLMs/agents and runnable or paste-ready PowerShell, shell, code, SQL, DAX, M, JSON, YAML, and configuration should use fenced code blocks or another copy-friendly ChatGPT surface.
- Reserved Markdown blockquotes for actual quoted material rather than prompts, commands, code, or configuration the user is expected to reuse.
- Propagated the response-formatting rule through `BOOTSTRAP.md`, `framework/OPERATING-RULES.md`, the client `AGENTS.md` template, and human-facing README guidance.

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
