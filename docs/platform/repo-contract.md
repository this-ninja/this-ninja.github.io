# Repo Contract

This document defines the shared operating contract for a baseline-managed repository.

When repo behavior and ad hoc practice differ, this contract is the default reference point until the repo updates its documented contract or approved exception notes.

The baseline-managed sections in this file may be replaced during future baseline apply operations.
Only edit repo-specific content inside the repo-local block below so baseline re-apply can preserve it safely.

## Baseline-Managed Contract

### Purpose Of The Contract

The repo contract exists to make a repository's operating model explicit:

- what the baseline manages
- what repo maintainers own locally
- how contributors should find the source of truth
- where exceptions and repo-specific behavior belong

This contract should stay aligned with the repo's setup docs, runbooks, scripts, and agent guidance.

### Ownership Expectations

Use a clear ownership split:

- the baseline owns reusable shared scaffolding, standard docs, and shared helper workflows
- the target repo owns its product code, domain behavior, local policies, and repo-specific operational decisions
- module-specific systems own only the behavior explicitly enabled for that repo

If a repo enables a planning or platform module, that module's runbooks should describe the additional responsibilities it introduces.

### Baseline-Managed Assets

Baseline-managed assets may include:

- shared docs and orientation pages
- bootstrap and verification helpers
- environment scaffolding
- reusable runbooks, templates, and agent guidance
- overlay-rendered files driven by supported baseline variables

Consumers should treat those assets as baseline-managed unless a document explicitly marks a repo-local section.

### Module Consumption Expectations

Modules are expected to be:

- explicitly enabled in the repo manifest
- applied without silently importing unrelated module concerns
- verified after apply so missing, drifted, or manual-review items are visible

Optional modules must remain optional. A repo should not depend on module-specific behavior unless that module is enabled and documented.

### Where Repo-Specific Behavior Belongs

Repo-specific behavior belongs in one of these places:

- repo-local sections inside baseline-managed docs when the baseline explicitly preserves them
- repo-owned runbooks, domain docs, or architecture docs
- the repo manifest when the behavior is driven by supported module or template variables

Local exceptions should be documented rather than implied.

### Manual Step Policy

Manual steps are allowed only when they are:

- explicit
- reviewable
- verifiable
- either intentional control points or acknowledged automation gaps

The repo should record those steps in `docs/operations/manual-steps.md`.

### Alignment Rule

When repo workflow changes, keep these aligned:

- scripts
- setup docs
- runbooks
- the repo contract
- agent guidance

## Repo-Local Contract Notes

<!-- repo-local:begin -->
This block is repo-local. Target repo maintainers may edit it freely, and baseline apply will preserve its contents on re-apply as long as these markers remain in place.

### Repo Mission And Domain Scope

- Add the repo's mission, product/domain scope, or service boundary notes here.

### Local Constraints

- Add repo-specific operational, compliance, hosting, or delivery constraints here.

### Local Ownership Notes

- Add team ownership, stewardship, escalation, or maintenance expectations that apply only to this repo here.

### Repo-Specific Exceptions

- Add approved exceptions to the standard contract here, including links to supporting runbooks where helpful.
<!-- repo-local:end -->
