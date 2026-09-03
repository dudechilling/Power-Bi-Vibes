# Framework Maintenance

These rules apply when changing the Power-Bi-Vibes framework itself.

## Objective

Maintain a portable, nontechnical-user workflow that lets ChatGPT and compatible coding agents create, understand, debug, repair, extend, and maintain Power BI PBIP projects using privacy-safe data representations.

## Rules

1. Keep the public framework free of client operational data, private schemas, credentials, tokens, and client-specific repository URLs.
2. Keep machine instructions and human instructions aligned. When behavior changes, update the relevant workflow, policy, templates, prompts, and human documentation in the same logical change.
3. Do not silently track Microsoft's moving `main`. Update `UPSTREAM.lock.yml` only after checking the new `powerbi-authoring` release and relevant behavioral changes.
4. Prefer durable principles over product-specific UI details. Put volatile setup steps in human documentation rather than core agent policy.
5. Preserve backward compatibility for client manifests when practical. If a framework change requires client migration, document it explicitly.
6. Do not turn the framework into a Power BI textbook. Teach only what the user needs to act or make a business decision.
7. Test scripts with representative safe fixtures before release.
8. Keep `main` as the current working framework. Use a temporary branch for major framework experiments when needed.
9. Never force-push or rewrite public release history after publication.
10. Treat private-project learning as private by default. A lesson may enter the public framework only after client-specific details are removed and a human reviews privacy and generalizability.
11. Preserve the Repository Mode Gate as a mandatory pre-mutation boundary for substantive existing repositories.
12. Do not claim Power BI validation/rendering occurred merely because repository writes succeeded.
13. Treat generated artifacts as build outputs that require independent verification.
14. Treat ChatGPT GitHub authorization, local filesystem access, and local Git/GitHub authentication as separate capabilities.
15. Defer local dependency installation until a local task needs it and keep required client tooling minimal.

For release work, follow `maintainer/release.md`.