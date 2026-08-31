# Updating Existing Client Projects

Power BI Vibes is referenced by version from `.power-bi-vibes/manifest.yml`. Client projects are not disposable copies of the framework; they contain project-specific decisions and implementation state.

## Update principle

Update framework behavior without overwriting client-specific content.

Before applying a framework update:

1. read the client's manifest and current `AGENTS.md`;
2. read the public framework `CHANGELOG.md` between the installed and target versions;
3. identify changes that affect client instructions, templates, data contracts, learning, QA rules or upstream Microsoft compatibility;
4. inspect the client's corresponding files before editing;
5. preserve project-specific business rules, confirmed lessons/patterns and accepted behavior;
6. make the smallest migration required;
7. validate the project after migration as far as the available environment permits;
8. update the manifest only after the migration succeeds.

## Files that are usually project-owned after initialization

Do not replace these wholesale from public templates:

- `README.md`;
- `_brief/report-spec.md`;
- `_brief/decisions.md`;
- `.power-bi-vibes/learning.yml`;
- `config/data-contract.yml`;
- `qa/acceptance.md`;
- Power BI project files;
- project-specific scripts.

The learning log is private project memory. A framework migration may add new supported fields or statuses, but it must merge that schema change without deleting existing observations, lessons or patterns.

## Files that may need framework-rule updates

`AGENTS.md`, `.gitignore`, `.gitattributes`, `.power-bi-vibes/manifest.yml`, and generic helper scripts originally copied from the framework may require merge-style updates. Do not erase project-specific additions.

## Microsoft dependency updates

A newer Power-Bi-Vibes release can adopt a newer Microsoft `powerbi-authoring` release. Treat this as a compatibility change. Read the new Microsoft skill/plugin metadata and relevant release changes, check for changed CLI requirements/validation behavior/file formats/workflow instructions, update the client manifest after compatibility is verified, and do not silently switch an existing client project from its pinned Microsoft commit to upstream `main`.