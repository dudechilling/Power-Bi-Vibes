# Power BI Vibes Commands

Power BI Vibes commands are optional analytical lenses that a user can invoke during a project. They are **prompt conventions defined by this framework**, not native ChatGPT slash commands or product UI features.

Type a registered trigger at the beginning of a message. You can optionally add a target after it.

Examples:

```text
/premature-framing
```

```text
/stress-test the forecasting logic
```

```text
/data-savant our current source schema
```

```text
/repo-recon this existing Power BI repository
```

## Command rules

- Commands are user-invoked. Do not run them automatically unless the user asks for the same analysis in ordinary language.
- The leading token must exactly match a trigger in `commands/registry.yml`.
- Text after the trigger is the target/scope. If no target is supplied, use the current request and relevant project state.
- Analysis commands are non-mutating by default. Do not edit the project, change the accepted specification, or commit recommendations merely because a command was invoked.
- After returning the analysis, wait for the user to choose what to implement.
- Commands do not override privacy, security, evidence, Git, QA, repository-mode, or validation rules elsewhere in Power BI Vibes.
- Read only the project artifacts needed for the command. Do not turn a focused command into a full repository audit unless its purpose requires one.
- Distinguish supported findings from inference and unknowns when that distinction affects the recommendation.
- `/repo-recon` is an explicit reconnaissance lens. It does not replace the automatic Repository Mode Gate required by `workflows/bootstrap.md`.

## Available commands

| Command | Purpose |
|---|---|
| `/commands` | Show the current command menu and brief usage guidance. |
| `/premature-framing` | Challenge solution assumptions embedded in the current framing and recover the underlying problem/job. |
| `/data-savant` | Find overlooked analytical value that the current data and model can defensibly support. |
| `/blind-spots` | Surface consequential assumptions, missing perspectives, data gaps, operational conditions, and maintenance risks. |
| `/stress-test` | Try to break the current idea, specification, model, report, or workflow with realistic failure modes. |
| `/simplify` | Identify complexity that can be removed, deferred, or consolidated while preserving the user's actual job. |
| `/what-next` | Identify the highest-value next decision, test, or validation step from the current project state. |
| `/repo-recon` | Perform non-mutating architectural reconnaissance of an existing Power BI repository before debugging, repair, extension, reverse engineering, refactoring, validation, or migration. |

## Dispatch

Agents should use `commands/registry.yml` as the machine-readable registry. Each command points to a Markdown definition containing its purpose, method, output contract, and guardrails.

`/commands` can be answered directly from this file and the registry. Other registered commands should load their named definition before answering.

## Adding commands

Add a command only when it represents a reusable thinking operation rather than a one-off prompt. New commands should:

1. solve a recurring user need;
2. have a narrow, distinct purpose;
3. define whether they may mutate project state;
4. specify the evidence/context they should inspect;
5. define an output contract that resists generic brainstorming;
6. preserve Power BI Vibes privacy and validation boundaries;
7. be added to `commands/registry.yml`, this menu, the README, and repository integrity checks.
