# Manual Steps

This runbook records operator actions that still require human judgment or access outside the baseline automation.

The baseline-managed sections in this file may be replaced during future baseline apply operations.
Only edit repo-specific content inside the repo-local block below so baseline re-apply can preserve it safely.

## Baseline-Managed Guidance

### When Manual Steps Are Expected

Manual steps are acceptable when they are one of these:

- an intentional approval or control point
- a task that requires credentials, access, or external systems that the baseline must not automate
- temporary automation debt that is visible, owned, and tracked

Hidden manual steps are defects. If a repo depends on a manual action, record it here and point to the relevant setup guide, runbook, or external system.

### How To Document A Manual Step

For each repo-specific manual step, capture:

- what triggers the step
- who performs it
- the command, UI path, or external system involved
- the expected verification signal after the step is complete
- any rollback, retry, or escalation note that matters for operators

Prefer short, repeatable instructions over narrative background.

### Post-Apply And Post-Bootstrap Verification

After a baseline apply or bootstrap refresh, verify the target repo still matches its intended environment and tooling setup.

Recommended checks:

- `bash scripts/bootstrap/check-prereqs.sh`
- `bash scripts/bootstrap/env-report.sh`
- `npm run verify:baseline -- --target /path/to/target-repo`

If a repo enables optional modules, also run that module's documented verification steps.

### Recording Repo-Specific Exceptions

Use the repo-local section for:

- local manual controls that are intentionally retained
- app-specific or service-specific provisioning steps
- third-party dependencies the baseline cannot provision
- local post-deploy, post-bootstrap, or post-apply checks

If a manual step becomes common across multiple repos, promote it into the baseline-managed guidance or the owning module runbook instead of copying custom wording between repos.

## Repo-Local Manual Steps

<!-- repo-local:begin -->
This block is repo-local. Target repo maintainers may edit it freely, and baseline apply will preserve its contents on re-apply as long as these markers remain in place.

### Local Manual Controls

- Add repo-specific approval gates, operational controls, or environment-specific manual actions here.

### App-Specific Provisioning And Dependencies

- Add external services, tenant setup, DNS, certificates, cloud resources, or vendor-side provisioning steps here.

### Local Post-Deploy Or Post-Bootstrap Checks

- Add the repo's own smoke tests, dashboard checks, content checks, or environment validation notes here.
<!-- repo-local:end -->
