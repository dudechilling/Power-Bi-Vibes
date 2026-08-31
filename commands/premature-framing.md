# /premature-framing

## Purpose

Challenge solution assumptions embedded in the current request, specification, page, metric, process, or Power BI implementation and recover the underlying problem/job before more work is committed.

## Scope

Use the target supplied after the command. If no target is supplied, inspect the current user request and the smallest relevant project context.

Useful context can include `_brief/report-spec.md`, `_brief/decisions.md`, `config/data-contract.yml`, current page/feature definitions, and recent user instructions.

## Method

Identify:

1. the underlying job, decision, or problem;
2. implementation choices already embedded in the framing;
3. assumptions currently being treated as requirements;
4. questions that sit one level above the current question;
5. alternative framings that could materially change the solution;
6. whether Power BI itself, a particular page, chart, KPI, metric, workflow, or organizational unit is being assumed prematurely.

Separate findings when useful into:

- **Fact / explicit requirement** - directly established by the user or project artifacts;
- **Inference** - a reasonable interpretation that still needs calibration;
- **Assumption** - currently embedded in the framing without adequate support;
- **Unknown** - information that would materially affect the framing but is unresolved.

## Output

Keep the response focused. Return:

### Current framing
A concise statement of the problem as currently framed.

### Embedded assumptions
Only assumptions that could materially distort the decision or solution.

### Higher-order framing
One or more broader formulations that expose the actual job or decision.

### Recommended framing
The smallest reframing that would materially improve the next decision.

### Consequence for the current build
State whether the present plan can continue, should pause for one business decision, or needs reconsideration.

## Guardrails

- Do not invent a broader problem merely to appear strategic.
- Do not treat every implementation choice as premature; some are already approved constraints.
- Do not modify the repository or accepted specification unless the user subsequently asks.
- Do not turn the response into generic ideation. Focus on framing errors with operational consequences.
