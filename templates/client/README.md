# <PROJECT NAME>

Power BI project managed with [Power BI Vibes](https://github.com/dudechilling/Power-Bi-Vibes).

## Purpose

<Plain-language description of what this tool helps users do.>

## Development data

This repository should contain synthetic or explicitly approved development data only. Production operational data remains in the approved local/organizational environment unless repository storage has been explicitly authorized.

## Local use

Clone to a short Windows path such as:

```powershell
git clone <REPOSITORY-URL> C:\PBI\<PROJECT-NAME>
```

Open the `.pbip` project under `powerbi/` in Power BI Desktop.

## Project state

- Framework/capability state: `.power-bi-vibes/manifest.yml`
- Durable implementation lessons: `.power-bi-vibes/learning.yml`
- Approved scope: `_brief/report-spec.md`
- Business/implementation decisions: `_brief/decisions.md`
- Source contract: `config/data-contract.yml`
- QA steps: `qa/acceptance.md`

Before pulling over a local copy that has been opened or saved in Power BI Desktop, inspect Git state first. Desktop saves can modify tracked project source.