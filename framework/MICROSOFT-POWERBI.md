# Microsoft Power BI Authoring Routing

Power BI Vibes relies on Microsoft's `powerbi-authoring` plugin for technical Power BI mechanics. The tested upstream source is pinned in `UPSTREAM.lock.yml`.

## Skills

At the pinned release, the plugin contains these primary skills:

- `semantic-model-authoring` - semantic model/TMDL/model operations;
- `powerbi-report-planning` - requirements-to-spec-to-build workflow for new reports;
- `powerbi-report-design` - report visual design, layout and design contracts;
- `powerbi-report-authoring` - concrete PBIR/PBIP pages, visuals, filters, formatting, validation and Desktop verification;
- `powerbi-report-management` - Fabric report management/publishing operations.

## Routing

Use planning for a greenfield tool or major report addition that needs requirements and an approved spec.

Use design when layout, visual hierarchy, theme, accessibility or report composition is genuinely open-ended.

Use semantic-model-authoring when changing model objects, measures, relationships or TMDL.

Use report-authoring for concrete PBIR/PBIP file mechanics and validation.

Use report-management only when publishing/managing Fabric items is requested and authorized.

## Immutable source URLs

Build GitHub URLs from the commit in `UPSTREAM.lock.yml`, for example:

```text
https://github.com/microsoft/skills-for-fabric/blob/<COMMIT>/plugins/powerbi-authoring/skills/powerbi-report-planning/SKILL.md
```

Read only the skill/reference material needed for the current task.

## Desktop/project-format prerequisites

PBIP/PBIR support changes over time and may be gated by Power BI Desktop preview settings or version requirements. Before the user's first local open, check current Microsoft guidance for the exact project/report format being authored.

Do not encode a historical preview-state assumption as a permanent framework rule. Record any required Desktop setting/version in the project manifest or acceptance notes when it materially affects the project.

## Capability boundary

GitHub authoring and local Power BI validation are separate capabilities.

An agent with repository write access may create or modify PBIP/PBIR/TMDL source in GitHub. It must not claim that the project has passed `powerbi-report-author` validation, Power BI Desktop reload, screenshot review, refresh, or interactive QA unless that check was actually executed in an environment with the required tooling.

When local execution is unavailable, mark the relevant check pending and provide the shortest exact local step required to complete it.

## Authority boundary

Microsoft guidance is authoritative for Power BI file/model mechanics and its own tool contracts.

Power BI Vibes is authoritative for client privacy defaults, nontechnical user interaction, synthetic-data workflow, project repository structure, client Git policy, learning, and acceptance/QA handoff conventions.

If guidance conflicts, identify whether the conflict concerns Power BI mechanics or the client workflow and apply the appropriate authority.
