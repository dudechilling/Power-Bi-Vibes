# Start Here

Power BI Vibes is designed so you can describe your work in ordinary language and let ChatGPT handle most of the Power BI and repository mechanics.

## Before you start

You need:

- a GitHub account;
- a new private GitHub repository for your Power BI project;
- ChatGPT with GitHub connected and permission to work with that repository;
- Power BI Desktop on the Windows computer where you will test and use the tool.

You do **not** need to know DAX, TMDL, PBIR, Power Query, or Git commands before starting.

## 1. Create an empty private repository

Create a new GitHub repository for the tool you want to build. Keep it private if it will contain organization-specific logic, terminology, synthetic fixtures based on internal schemas, or other non-public material.

Use a short repository name such as `regional-project-tracker`, `cost-benchmark-dashboard`, or `operations-planning-tool`. An empty repository is fine.

## 2. Connect GitHub to ChatGPT

Connect GitHub in ChatGPT and make sure ChatGPT can access the private repository you just created. The exact controls can vary by ChatGPT plan and workspace policy.

## 3. Start the project

Paste this into a new ChatGPT conversation and replace the project URL:

```text
I want to build a Power BI tool.

Use this framework:
https://github.com/dudechilling/Power-Bi-Vibes

My private project repository is:
<PASTE YOUR PRIVATE GITHUB REPOSITORY URL>

Read BOOTSTRAP.md in Power-Bi-Vibes and follow it. Do not ask me to share operational data that I am not permitted to share.
```

ChatGPT should inspect both repositories, initialize the private project repository, and then ask what you want the tool to help you do.

## 4. Describe the job, not the implementation

Explain the problem in the language you already use at work. Useful information includes what you do now, what takes too long or is difficult to see, who will use the tool, what decisions the tool should support, what the finished tool should make easier, where the source data comes from, and how often that source changes.

You usually do not need to decide which charts, DAX measures, data model structure, or Power BI internals to use. ChatGPT should propose those based on the job and the data.

## 5. Give ChatGPT a safe representation of the data

If you are permitted to share the real source, you can use it. If the source contains restricted operational information, use one of these approaches instead:

**Scrubbed/template file** - keep the workbook sheets, headers, table names and other useful structure while removing sensitive records.

**Schema report** - run `scripts/inspect-source.ps1` locally and review the resulting JSON before sharing it. The script does not intentionally export row values, but schema and internal terminology can still be sensitive.

**Manually described schema** - tell ChatGPT the worksheets/tables, columns, expected data types and relationships.

ChatGPT should create a deterministic synthetic dataset for development and testing.

## 6. Approve the tool plan

Before large-scale authoring, ChatGPT should summarize the proposed tool in plain language: intended users, pages, important calculations, filters/interactions, data assumptions, and anything that still requires a business decision.

Correct terminology and business meaning at this stage. ChatGPT should handle technical implementation details itself.

## 7. Build and test

ChatGPT writes the project to GitHub in logical, reviewable batches. For Power BI changes it should perform structural validation where possible and give you specific local QA instructions when Power BI Desktop is required.

A useful QA instruction names a filter/action and the expected result. A vague instruction such as "review the dashboard" is not enough.

## 8. Connect the real data locally

After the synthetic-data version works, point the project at the approved operational source on your computer or organizational environment.

Run the production-data smoke test locally. Do not send screenshots, exports, error logs, or copied rows back to ChatGPT if they expose information you are not permitted to share.

If the real source fails, report the error in a sanitized form whenever possible. ChatGPT should adjust the adapter/model rather than asking for unrestricted production records.

## 9. Request changes normally

Continue with ordinary-language requests. ChatGPT should translate them into technical changes, validate them, and keep the repository understandable.

## Local Git commands you may be given

For a new local copy:

```powershell
git clone <YOUR-PRIVATE-REPOSITORY-URL> C:\PBI\<PROJECT-NAME>
```

For an existing local copy:

```powershell
cd C:\PBI\<PROJECT-NAME>
git pull --ff-only
```

Short local paths reduce Power BI project path-length problems.

## If something goes wrong

Tell ChatGPT what you observed and provide a screenshot only if the screenshot is safe to share. ChatGPT should first inspect repository state and validation output, then give one concrete recovery or test step at a time.

Do not delete the repository and start over unless recovery is genuinely more expensive than repair.
