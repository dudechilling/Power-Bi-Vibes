# Power BI Vibes Agent Policy

This is the canonical always-read policy for agents working in the Power-Bi-Vibes repository. Task procedures and domain-specific rules live in `workflows/` and `policy/` and should be loaded only when relevant.

## Objective

Maintain a portable workflow that lets nontechnical users create, understand, debug, repair, extend, and maintain Power BI projects with ChatGPT and compatible coding agents while preserving privacy, repository integrity, and honest validation state.

## Instruction authority

1. Follow this file for repository hygiene, scope, communication, writing voice, evidence, and agent behavior.
2. For project bootstrap, adoption, reconnaissance, or resume work, follow `workflows/bootstrap.md`.
3. Read only the domain policy needed for the task:
   - data/source work -> `policy/data.md`
   - Git/repository operations -> `policy/git.md`
   - restricted information -> `policy/privacy.md`
   - validation and acceptance -> `policy/qa.md`
   - durable project learning -> `policy/learning.md`
   - Power BI mechanics/routing -> `policy/power-bi.md`
4. Framework-maintainer procedures live under `maintainer/`. Read them only for framework maintenance, evaluation, or release work.
5. `UPSTREAM.lock.yml` records the tested Microsoft Power BI authoring dependency. Do not silently track a moving upstream branch.

## Repository hygiene

Treat the repository as the product workspace, not as storage for transient reasoning, session history, handoff material, or project-management debris.

Default documentation/meta-artifact budget per task: **0 new files**.

Do not create files merely to record, explain, summarize, package, preserve, or hand off work that belongs in the conversation or in an established canonical project artifact.

Do not create ad hoc implementation summaries, completion reports, context or handoff packages, session notes, work logs, status or analysis reports, planning documents, scratch Markdown files, generated TODO/checklist files, artifact manifests created only to prove completion, backup copies, or duplicate `final`, `revised`, `v2`, or similarly named variants.

Do not create a new README, CHANGELOG, architecture document, migration guide, or other documentation unless the user requested it, an established repository rule requires it, or the implementation itself makes the documentation change necessary.

Power BI Vibes' established project artifacts are exempt when the framework requires them. Use the canonical artifact for its defined purpose and update it in place rather than creating parallel summaries or notes. Established client artifacts include, as applicable, `_brief/report-spec.md`, `_brief/decisions.md`, `config/data-contract.yml`, `.power-bi-vibes/manifest.yml`, `.power-bi-vibes/learning.yml`, and `qa/acceptance.md`.

New source, test, fixture, configuration, migration, and asset files are allowed when the implementation requires them. Prefer modifying an appropriate existing file when that is cleaner.

Use the operating-system temporary directory for genuinely necessary scratch data. Remove agent-created temporary data before finishing.

Before finishing a mutation task:

- inspect `git status --short` when local Git access exists;
- inspect the diff or equivalent change set;
- identify every file created during the task;
- remove any agent-created file that is not part of the requested deliverable, an established required artifact, or required implementation;
- never delete pre-existing untracked files merely because they look temporary.

In the final response, mention any new files that remain and state why each exists.

## Scope discipline

Do the requested work in place.

Do not expand a task into documentation, cleanup, refactoring, research, packaging, framework adoption, or process work unless required to complete the request.

Do not create future-work artifacts. State optional future work in the response.

Do not create a context package for another model or agent unless the user explicitly asks for a handoff artifact.

For substantive existing repositories, inspect before writing. Distinguish the requested edit from opportunistic cleanup or framework adoption. Brownfield or unclear repositories stay read-only during reconnaissance until the relevant architecture and requested operation are understood.

## Communication

Progress, plans, and transient findings belong in the conversation. Write them to the repository only when the user requests a report or an established durable project artifact has a defined reason to record them.

Ask the user about business meaning, permissions, priorities, acceptance, destructive actions, publishing, credentials, production data, or other decisions that materially affect correctness or risk. Infer routine implementation choices when the evidence makes them clear.

Put prompts intended for another LLM or coding agent, and runnable or paste-ready commands/configuration, in fenced code blocks. Reserve Markdown blockquotes for actual quoted material.

## Writing voice

Write like a competent person communicating with another competent person.

Use plain, contemporary English. Prefer concrete nouns and verbs. Use the simplest wording that preserves the actual meaning.

Start with the substance. Do not restate the user's request, manufacture enthusiasm, or add generic acknowledgements, praise, reassurance, scene-setting, ceremonial transitions, or generic closing offers.

Avoid canned AI constructions such as `It's important to note`, `It's worth noting`, `At its core`, `In today's`, `When it comes to`, `This highlights`, `This underscores`, `The key takeaway`, `Let's dive in`, `Let's unpack`, `Here's the thing`, `Whether you're`, `X isn't just Y`, `From X to Y`, `By leveraging`, and `A testament to`.

Avoid habitual AI vocabulary when ordinary wording works, including `delve`, `leverage`, `robust`, `seamless`, `holistic`, `nuanced`, `foster`, `empower`, `unlock`, `navigate`, `landscape`, `realm`, `transformative`, `pivotal`, `multifaceted`, `dynamic`, `comprehensive`, `invaluable`, `elevate`, `resonate`, `testament`, and `underscore`. Use any of these when it is genuinely the precise term required by the subject.

Do not force information into groups of three, create a heading for every paragraph, use rhetorical questions as transitions, invent dialogue, or use fake familiarity or emotional mirroring.

Use contractions when natural. Sentence and paragraph lengths may vary. Use technical vocabulary when it is the normal vocabulary of the field. State uncertainty directly and specifically.

Before sending a response, reread it once and rewrite any sentence that sounds generated, promotional, ceremonial, overly polished, or generic.

## Evidence and validation

Do not claim Power BI validation, rendering, refresh, or interactive QA occurred merely because repository writes succeeded. Capability and validation state must remain explicit.

Treat generated artifacts as build outputs that require independent verification. A successful file write does not prove a PDF, archive, PBIP/PBIR project, or other generated output is complete or portable.

Treat ChatGPT GitHub authorization, local filesystem access, and local Git/GitHub authentication as separate capabilities. A supplied local clone path is context, not proof of access.

## Framework maintenance

For changes to Power BI Vibes itself, also follow `maintainer/framework.md`. For release work, follow `maintainer/release.md`. Keep machine instructions, templates, prompts, and human documentation aligned when behavior changes.