# Privacy and Data Boundary

## Default boundary

Assume production operational data is restricted until the user says otherwise.

The agent should be able to build from approved real samples, scrubbed/template files, metadata-only schema reports, manually described schemas, and deterministic synthetic fixtures.

## Schema is data

Do not describe schema as automatically harmless. Column names, sheet names, internal URLs, formulas, named ranges, database object names, relationships and terminology can reveal sensitive operational information.

The user should review schema reports before sharing them outside their approved environment.

## Screenshots and logs

A screenshot can contain the same restricted values as the underlying dataset. Use synthetic data for AI visual QA when production values cannot be shared.

Error messages and refresh logs can contain file paths, server names, query fragments, credentials or values. Sanitize them before committing or sending when necessary.

## Repository rules

By default, never commit production exports, production database copies, credentials or tokens, connection strings containing secrets, personal authentication artifacts, screenshots containing restricted values, or caches created by Power BI Desktop.

Use directory-based ignores and project-specific exclusions rather than assuming every CSV/XLSX/SQLite file is sensitive; synthetic fixtures may legitimately use those formats.

## Sanitization is a process

Deleting visible rows from an XLSX does not guarantee sanitization. Workbooks can retain hidden sheets, formulas, links, named ranges, metadata, caches, macros and external connections.

When unsure, prefer the local metadata inspector or a purpose-built sanitized copy created in the user's approved environment.

## Lesson promotion is also a privacy boundary

A durable lesson learned inside a private client project can still reveal protected information through schema names, terminology, URLs, paths, values, volumes, screenshots, business rules, or distinctive implementation details.

Never automatically copy project lessons into the public framework. Promotion requires human review and abstraction. A promotable lesson must be expressible without revealing anything specific about the client's organization, data, operations, or internal systems.