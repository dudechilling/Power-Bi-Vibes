# Changelog

## Unreleased

Repository authority, onboarding, agent hygiene, and brownfield hardening.

- Restructured the framework around explicit audiences and authority: `README.md` for first-time users, root `AGENTS.md` as canonical always-read agent policy, `workflows/` for procedures, `policy/` for task-specific domain rules, `maintainer/` for framework-only work, and `tools/` for framework build/integrity utilities.
- Added root and client `CLAUDE.md` wrappers containing only `@AGENTS.md` so Claude Code consumes the canonical policy without maintaining a duplicate instruction set.
- Moved bootstrap and client-update procedures to `workflows/bootstrap.md` and `workflows/update.md`; prompts now tell agents to read `AGENTS.md` first and then load the relevant workflow.
- Replaced the former `framework/` policy layout with task-scoped `policy/data.md`, `policy/git.md`, `policy/privacy.md`, `policy/qa.md`, `policy/learning.md`, and `policy/power-bi.md`.
- Moved framework-only rules, release checks, and repository-mode evaluations under `maintainer/` so routine project agents do not need maintainer context.
- Reworked `templates/client/` so template paths match installed client paths directly, including `.power-bi-vibes/`, `_brief/`, `config/`, `qa/`, and `scripts/`; bootstrap no longer relies on a separate source-to-destination mapping table.
- Made the generated client `AGENTS.md` self-contained for core hygiene, scope, voice, privacy, Git, and validation behavior so a client project remains operable when the framework repository is unavailable.
- Rewrote the root README as a beginner landing page and consolidated the full tutorial into `docs/getting-started.md`; renamed setup guides to `docs/github-setup.md` and `docs/windows-setup.md`.
- Moved the guide builder and integrity audit to `tools/build-guide.py` and `tools/repo-integrity.py`; CI now rebuilds from `docs/getting-started.md` and validates the restructured paths.
- Added `tools/claude-artifact-guard.ps1` as an optional Claude Code `PreToolUse` enforcement example for blocking familiar meta-artifact names and requiring approval for new Markdown files.
- Added integrity checks that require the canonical policy routing, mirrored client template layout, thin Claude wrappers, and absence of superseded file paths.
- Added a mandatory Repository Mode Gate to classify target repositories as `greenfield`, `managed-existing`, `brownfield-powerbi`, or `unknown-existing` before scaffolding or substantive mutation.
- Added bounded read-only brownfield reconnaissance for unfamiliar existing Power BI repositories, including PBIP/PBIR/TMDL structure, report and semantic-model boundaries, source architecture, validation tooling, and project conventions.
- Added an explicit mutation boundary: repository write capability does not imply permission to initialize, restructure, clean up, or install Power BI Vibes scaffolding into an existing implementation.
- Added repository-hygiene rules with a default budget of zero new documentation/meta-artifact files per task, plus explicit prohibitions on ad hoc summaries, handoff packages, session notes, work logs, scratch Markdown, generated TODO/checklist files, completion manifests, backup copies, and duplicate `final`/`revised`/`v2` variants.
- Preserved Power BI Vibes' established durable project artifacts as explicit exceptions to the zero-new-meta-file default, with instructions to update canonical artifacts in place rather than creating parallel documentation.
- Added end-of-task change hygiene requiring agents to inspect Git/diff state when available, identify created files, remove unnecessary agent-created files, preserve pre-existing untracked files, and explain any new files that remain.
- Added scope-discipline rules that keep documentation, cleanup, refactoring, research, packaging, framework adoption, and future-work artifacts out of scope unless required by the requested work.
- Added communication rules that keep transient plans, progress, and findings in the conversation unless the user requests a file or an established durable project artifact must be updated.
- Added writing-voice rules for plain contemporary English, direct openings, restrained structure, specific uncertainty, natural contractions, and avoidance of canned assistant phrasing, generic closings, mechanical prose, rhetorical transitions, fake familiarity, and habitual AI vocabulary when simpler precise wording is available.
- Added `/repo-recon` as an optional non-mutating command for explicit architectural mapping of an unfamiliar Power BI repository.
- Added project repository and local clone fields to the bootstrap prompt. The local path is contextual and does not imply that the current agent has local filesystem access or authenticated local Git access.
- Rebuilt and verified the generated client PDF through the Integrity workflow; repository audit, link/YAML/template checks, PDF preflight, and full-page Poppler rendering all passed.
- Release-version metadata has not been advanced; that remains release-gate work.

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
