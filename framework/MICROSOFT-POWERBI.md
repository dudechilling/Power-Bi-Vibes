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

## Authority boundary

Microsoft guidance is authoritative for Power BI file/model mechanics and its own tool contracts.

Power BI Vibes is authoritative for client privacy defaults, nontechnical user interaction, synthetic-data workflow, project repository structure, client Git policy, and acceptance/QA handoff conventions.

If guidance conflicts, identify whether the conflict concerns Power BI mechanics or the client workflow and apply the appropriate authority.
