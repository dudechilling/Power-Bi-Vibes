# Microsoft Power BI Authoring Routing

Power BI Vibes relies on Microsoft's `powerbi-authoring` plugin for technical Power BI mechanics. The tested upstream source is pinned in `UPSTREAM.lock.yml`.

## Skills

At the pinned release, the plugin contains primary skills for semantic-model authoring, report planning, report design, report authoring, and Fabric report management/publishing.

## Routing

Use planning for a greenfield tool or major report addition that needs requirements and an approved spec. Use design when layout, visual hierarchy, theme, accessibility, or composition is open-ended. Use semantic-model authoring for model objects, measures, relationships, or TMDL. Use report authoring for PBIR/PBIP file mechanics and validation. Use report management only when publishing/managing Fabric items is requested and authorized.

Read only the upstream skill/reference material needed for the current task and build immutable GitHub URLs from the commit in `UPSTREAM.lock.yml`.

## Desktop/project-format prerequisites

PBIP/PBIR support changes over time and may be gated by Power BI Desktop version or preview settings. Before the first local open, check current Microsoft guidance for the exact format being authored. Do not encode a historical preview-state assumption as a permanent rule.

## Capability boundary

GitHub authoring and local Power BI validation are separate capabilities. An agent with repository write access may create or modify PBIP/PBIR/TMDL source, but must not claim validator, Desktop reload, screenshot review, refresh, or interactive QA occurred unless that check actually ran.

When local execution is unavailable, mark the relevant check pending and provide the shortest exact local step required to complete it.

## Authority boundary

Microsoft guidance is authoritative for Power BI file/model mechanics and its own tool contracts. Power BI Vibes is authoritative for client privacy defaults, nontechnical user interaction, synthetic-data workflow, project repository structure, client Git policy, learning, and acceptance/QA handoff conventions.

If guidance conflicts, identify whether the conflict concerns Power BI mechanics or the client workflow and apply the appropriate authority.