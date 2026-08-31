# Power BI Vibes - Client Guide

## What this is

Power BI Vibes is a workflow for building Power BI tools with ChatGPT and GitHub while keeping restricted operational data out of the development conversation when necessary.

You explain the job and the business meaning. ChatGPT handles most Power BI and repository mechanics.

## The workflow

1. Create an empty private GitHub repository for your project.
2. Connect GitHub to ChatGPT.
3. Give ChatGPT the Power BI Vibes framework URL and your private project URL.
4. Describe what you want the tool to help you do.
5. Provide a permitted source representation: approved sample, scrubbed template, metadata-only schema report, or manual schema.
6. ChatGPT creates synthetic development data and a data contract.
7. Approve the proposed pages/functions/business rules.
8. ChatGPT builds and validates the PBIP project in GitHub.
9. Pull the project to a short local folder such as `C:\PBI\ProjectName` and open it in Power BI Desktop.
10. Follow ChatGPT's specific QA checks.
11. Connect the real operational source locally and perform the production-data smoke test.
12. Continue requesting changes in ordinary language.

## Bootstrap prompt

```text
I want to build a Power BI tool.

Use this framework:
https://github.com/dudechilling/Power-Bi-Vibes

My private project repository is:
<PASTE YOUR PRIVATE GITHUB REPOSITORY URL>

Read BOOTSTRAP.md in Power-Bi-Vibes and follow it. Do not ask me to share operational data that I am not permitted to share.
```

## Restricted data

If the real source contains information you cannot share, do not upload it just to make development easier. Use a scrubbed/template source or run the local metadata inspector and review its JSON before sharing it.

## Synthetic development data

ChatGPT should build a fictional dataset that matches the permitted structure and deliberately covers important edge cases. The synthetic fixture is for development and QA. It does not prove that the real dataset has the same distribution, cleanliness or performance characteristics.

## Local Power BI testing

For a first clone:

```powershell
git clone <YOUR-PRIVATE-REPOSITORY-URL> C:\PBI\<PROJECT-NAME>
```

For later updates:

```powershell
cd C:\PBI\<PROJECT-NAME>
git pull --ff-only
```

Open the `.pbip` file under `powerbi/` in Power BI Desktop. ChatGPT should give you a short list of exact actions and expected results.

## Production source

Connect the approved real source only in the environment where it is permitted to exist. Test refresh, totals, relationships and performance locally.

Do not send production screenshots, copied records or logs back to ChatGPT when they expose restricted information. Give a sanitized error description or safe screenshot instead.

## How changes are managed

The private project repository keeps the current usable product on `main` during normal iterative work. ChatGPT makes descriptive checkpoint commits after validated changes. A temporary branch is appropriate for a major experiment on an accepted working product.

## What "done" means

A feature is ready when the project validates, the requested data-bound visuals/functions exist, the rendered layout has been checked, the requested interactions work, and the acceptance steps are current.

The production-data smoke test is a separate final check against the approved real source.
