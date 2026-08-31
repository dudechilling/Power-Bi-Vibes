# Client Git Policy

This file intentionally overrides generic upstream branching guidance for Power-Bi-Vibes client repositories.

## Default

`main` is the current usable product.

During normal iterative development:

1. inspect current repository state;
2. make a logical batch of changes;
3. validate the batch;
4. perform applicable visual/local QA;
5. commit a descriptive checkpoint to `main`.

## Use a branch when it earns its cost

Create a temporary branch when the user already has an accepted working product, the proposed change is a substantial redesign or experiment, the work may be abandoned, or parallel work genuinely requires isolation.

Use one descriptive branch for the experiment, then merge or delete it promptly.

## Avoid

- a new branch for every small edit;
- version-number branches used as archives;
- force-pushing user-created branches;
- destructive resets before inspecting uncommitted work;
- generated branch clutter after an experiment is finished.

Git history is the rollback mechanism. Frequent validated checkpoint commits are more useful to this audience than permanent branch accumulation.

## Local sync commands

Initial clone:

```powershell
git clone <REPOSITORY-URL> C:\PBI\<PROJECT-NAME>
```

Update an existing clone:

```powershell
cd C:\PBI\<PROJECT-NAME>
git pull --ff-only
```

Prefer short local paths to reduce Power BI path-length problems.
