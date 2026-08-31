# /simplify

## Purpose

Identify complexity that can be removed, deferred, consolidated, or automated while preserving the user's actual job and accepted business meaning.

## Scope

Use the target after the command. If none is supplied, inspect the current report specification, page/feature plan, data/model structure, navigation, and maintenance workflow as relevant.

## Method

Look for complexity in:

- pages or views with overlapping jobs;
- measures that duplicate or obscure simpler business logic;
- navigation layers users do not need;
- filters or slicers that create choice without decision value;
- transformations that can be centralized in the adapter/model layer;
- repeated manual steps that can be automated;
- fields, visuals, labels, or interactions that add maintenance cost without enough user value;
- speculative first-release features that can be deferred;
- documentation or repository machinery that future users/agents are unlikely to use.

## Output

For each useful simplification include:

- current complexity;
- user value it provides;
- maintenance/cognitive cost;
- recommended action: keep, consolidate, defer, automate, or remove;
- consequence of simplifying it.

End with a proposed minimum coherent version if material simplification is available.

## Guardrails

- Do not remove complexity that represents an approved business requirement.
- Do not optimize for minimal page count or minimal code at the expense of usability or correctness.
- Do not modify the project unless the user subsequently asks.
