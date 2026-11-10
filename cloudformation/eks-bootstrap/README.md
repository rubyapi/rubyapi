# Private EKS machine bootstrap and release runner

Colby approved the proposed bootstrap/shared-resource and capacity envelope on
10 November 2026. The 11-addition foundation was applied to `rubyapi-prod-edge`;
the bootstrap build installed one Ready C9g.xlarge ARM64 node and temporary
non-HA Argo. A separate completed update removed temporary machine-admin access.
Both `BootstrapAccess` and `ReleaseRunner` are now disabled. No source has been
activated as a release workflow. Existing Terraform and HCP are untouched.
Production SQL, application workers/schedulers and traffic cutover remain
unapproved. Colby authorized publication to a review branch in `rubyapi/rubyapi`,
without a PR, and deprecated `rubyapi/infrastructure` for future work.

## Source ownership and deployed state

This public repository owns the CloudFormation source, bootstrap scripts and
Kubernetes platform manifests. No Terraform source or state was moved here.
Historical repository/Terraform tags in the frozen core are preserved, not an
instruction to use the deprecated repository or HCP.

The generated template now points the **disabled future runner source** at
`https://github.com/rubyapi/rubyapi` and updates the project description. Those
two declaration changes have **not** been applied to AWS. The actually deployed
template SHA-256 is
`f5f787308bf3116169002edd150c23246655429202e7a2988164bc0dda3288d2`.
`review.json` describes the newly generated template, not a live execution.
Its zero incumbent changes refers to the historical 51-resource input; the
runner's source/description delta is within the 11 bootstrap additions.

The public repository is not a security boundary for a privileged runner.
Before activation, enforce trusted workflow/ref controls independently of job
conditions and workflow-name filters; verify that public PRs and fork code
cannot schedule or execute on the private runner. The source URL change alone
does not establish that protection. No release workflow is included here.

The deployed core now has 62 resources. `core-before.json` is the historical
51-resource input for this additive slice, not the current deployed baseline.
Before another stack operation, compare against the current 62-resource stack
and preserve its parameters, identities and protections. Do not replay this
bootstrap or re-enable admin access without separately scoped authorization.

## Scope

`prepare.py` adds 11 declarations to the frozen pre-bootstrap 51-resource
`rubyapi-prod-edge` core snapshot. It rejects baseline drift and collisions with
existing declarations. It creates no nested/application stack and changes none
of the existing resource definitions, parameters or outputs.

- Custom Auto Mode node IAM role and EC2-type EKS access entry.
- One CodeBuild project, dedicated role, machine access entry, outbound-only SG,
  private API ingress rule and 30-day logs.
- Versioned, private, TLS-only S3 bucket/policy for reviewed bootstrap bundles.
- Repository-level GitHub App CodeConnection, initially pending authorization.

No default NodePool, second Karpenter controller, human access entry, runtime
role changes, production data-service ingress changes, ALB, DNS change or
application workload is included. The image-publisher role was removed from
this slice pending alignment with the intended public image registry.

## One project, two disjoint phases

1. **Bootstrap:** `BootstrapAccess=enabled`, `ReleaseRunner=disabled`.
   The project has no Git source or webhook. An authorized operator starts a
   build using `bootstrap/buildspec.yaml` and an explicitly reviewed S3 object
   key, VersionId and SHA-256. Its default buildspec deliberately fails closed.
   Only this machine has temporary cluster-admin access; human access remains
   deferred. `bootstrap/run.sh` installs the custom capacity and pinned temporary
   non-HA Argo, with internal UI/local admin disabled. It creates no Application,
   web/worker, migration Job or secret mounts.
2. **Revoke bootstrap:** wait for the build to finish (including on failure),
   verify there are no running/queued builds, then complete a separate core
   update with **both parameters disabled**. Verify removal of the admin access
   policy and effective denial of cluster-admin actions from the machine.
   Do not combine this with enabling the runner: a final-state CloudFormation
   rule does not prove safe ordering of simultaneous updates.
3. **Release runner:** only after trusted source, connection authorization,
   namespace RBAC, release lock/gate and promotion authentication are verified,
   enable `ReleaseRunner`. The same project becomes an ephemeral single-job
   Actions runner for trusted releases in `rubyapi/rubyapi`, with source-level
   CodeConnection authentication, no account-wide default credential. The
   temporary cluster-admin policy stays absent. The access-entry group alone
   grants no namespace permissions; release RBAC is not installed by this slice.

The template prohibits both flags being enabled. Direct CodeBuild StartBuild
overrides remain privileged operator actions; this is not a protection against
an AWS administrator intentionally overriding the project.

GitHub's CodeBuild workflow-job webhook supports workflow-name filtering, not a
branch authorization filter. The name/label is routing, **not a trust boundary**.
Only trusted release workflow/repository administrators may control this runner.
Never connect public application PR workflows to it. Repository/ref/workflow
controls must be verified before activation; a job-level `if` alone is not an
enforcement boundary against someone who can change workflow source.

The CodeConnection does not replace Argo's read-only Git identity or the
restricted promotion writer. Neither is created here. No credential goes into
the template, bundle, source URL or logs. GitHub App authorization must occur in
AWS/GitHub's console flow, not by pasting credentials into a thread.

## Approved bootstrap capacity and spend envelope

One on-demand Linux small CodeBuild job at USD 0.005/minute. Concurrency is one;
the project timeout is 60 minutes, and bootstrap should use a 30-minute build
timeout. That is USD 0.15 for 30 billed minutes, not a monthly budget or absolute
billing ceiling. Existing NAT is reused. S3, logs and data-transfer charges are
additional. No reserved fleet or idle runner is provisioned.

The proposed C9g-only ARM64 On-Demand NodePool allows aggregate 8 vCPU / 16 GiB,
equivalent to two `c9g.xlarge` nodes, each with 80 GiB ephemeral data storage.
This is a scheduling envelope, not a hard node-count/spending guarantee:
eventual consistency, replacement/disruption and provisioned storage can add
cost. The bootstrap successfully ran all four active Argo components on one
Ready C9g.xlarge ARM64 node; this is not a production-HA commitment.

Earlier us-east-1 pricing reads gave EC2 USD 0.17388/hour plus Auto Mode
USD 0.02087/hour: USD 142.17 per node at 730 hours, or USD 284.34 for two,
before storage. A fresh AWS price-catalog read confirmed gp3 USD 0.08/GB-month:
two configured 80-GiB data volumes add USD 12.80, bringing that subtotal to
**USD 297.14/month**, excluding root volumes, logs, transfer and other existing
infrastructure. Actual EBS layout must be checked after provisioning. This is
not an all-in bill or hard spending ceiling. The existing EKS control-plane
charge is already incurred and is not included here.

Actual bootstrap provisioned **one** node with encrypted gp3 volumes of 80 GiB
(data) and 4 GiB (root), both deleted on instance termination. At the same rates,
one continuously running node plus those volumes is approximately USD 148.89
per 730-hour month, excluding logs, transfer, S3 and existing infrastructure.

## Local validation

From the `rubyapi/rubyapi` repository root:

```sh
uv run --with cfn-lint python cloudformation/eks-bootstrap/prepare.py
uv run --with cfn-lint cfn-lint --region us-east-1 --template cloudformation/eks-bootstrap/core.template.json
helm lint bootstrap/vendor/argo-cd-10.17.1.tgz -f kubernetes/platform/argocd-values.yaml
bash -n bootstrap/run.sh
```

These checks do not demonstrate private connectivity, effective AWS/Kubernetes
permissions, ARM64 Argo image execution or application readiness. Refresh STS
against account `794038216860`, exact oncall role
`AWSReservedSSO_oncall_5bbe8d4e7f0e0142`, region `us-east-1`, then compare the
current deployed 62-resource template/resources before any authorized preview.
Preserve all current parameter values, stack policy, protection, tags and
rollback configuration. The initial native change set showed exactly 11
additions and no incumbent modifications/replacements/removals; do not expect
11 additions against today's already bootstrapped stack.

## Executed bootstrap evidence — 10 November 2026

- Core `rubyapi-prod-edge`: UPDATE_COMPLETE, 62 resources, all 51 original
  physical identities preserved.
- CodeBuild bootstrap `rubyapi-prod-release:5ec99cc4-c749-4423-a696-c70288e7f84d`:
  SUCCEEDED. Versioned bundle SHA-256:
  `2fb1caf93750be5b8bbbcaaad94410dead16e9c2cc2c083cab7d52bede0679b0`.
- Node `i-0567680cea41636c3`: Ready, C9g.xlarge, ARM64, On-Demand. Argo
  application-controller, repo-server, server and Redis each 1/1 Ready with
  zero restarts. ApplicationSet replicas 0; UI ClusterIP; admin/exec disabled;
  no Application exists.
- Separate completed core update removed machine cluster-admin. Fresh build
  `rubyapi-prod-release:cb85fb37-9def-42be-80d1-939b2cda34aa`: SUCCEEDED,
  private API reachable, effective namespace creation/node listing/Secret
  access/Job creation denied via permission checks (no Secret values read).
- Both flags disabled, project NO_SOURCE, no webhook, connection PENDING.
  No application pods, production SQL, worker/scheduler or traffic change.
  Existing production homepage and `/up` returned HTTP 200 before and after.

Build details and logs are retained in CodeBuild/CloudWatch in us-east-1. This
evidence proves the bootstrap, not application deployment or release readiness.

The completed approval covered these shared resources, temporary machine
privilege, the worker-capacity envelope and charges. Nodes/Argo were verified
and the temporary access policy was removed before any runner activation.
Application and Datadog foundations, secret/readiness checks, the external
migration-success gate and its durable unresolved lock remain subsequent work.
No production SQL, worker/scheduler start or traffic cutover is authorized here.
