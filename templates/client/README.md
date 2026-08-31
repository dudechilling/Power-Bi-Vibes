# <PROJECT NAME>

Power BI project managed with [Power BI Vibes](https://github.com/dudechilling/Power-Bi-Vibes).

## Purpose

<Plain-language description of what this tool helps users do.>

## Development data

This repository should contain synthetic or explicitly approved development data only. Production operational data remains in the approved local/organizational environment unless repository storage has been explicitly authorized.

## Analytical commands

Power BI Vibes includes optional user-invoked analytical prompts. They are framework conventions rather than native ChatGPT slash commands.

Useful commands include:

- `/premature-framing` - challenge embedded solution assumptions;
- `/data-savant` - find overlooked analytical value in the current data/model;
- `/blind-spots` - surface consequential omissions and assumptions;
- `/stress-test` - try to break the current design with realistic failure modes;
- `/simplify` - identify removable or deferrable complexity;
- `/what-next` - identify the highest-value next decision or test;
- `/commands` - show the current command menu.

You can add a target, for example `/stress-test the forecasting logic`. These commands return analysis first and do not change the project unless you subsequently ask ChatGPT to implement selected findings.

## First local setup

ChatGPT can build in GitHub before the Windows machine is prepared. At the first Power BI Desktop handoff, follow the public [Windows Local Setup](https://github.com/dudechilling/Power-Bi-Vibes/blob/main/docs/WINDOWS-SETUP.md) guide.

The normal local requirements are Power BI Desktop, Git for Windows, PowerShell, and GitHub authentication for this private repository. GitHub CLI and GitHub Desktop are optional.

Run the included readiness check before local QA:

```powershell
.\scripts\check-local-setup.ps1 -RepositoryUrl <REPOSITORY-URL>
```

## Local use

Clone to a short Windows path such as:

```powershell
New-Item -ItemType Directory -Path C:\PBI -Force | Out-Null
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
