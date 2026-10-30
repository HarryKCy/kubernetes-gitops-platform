# GitOps Reconciliation and Self-Healing Validation

## Environment

- Kubernetes: v1.37.0
- Cluster: Three-node kind cluster
- GitOps Controller: Argo CD
- Repository: HarryKCy/kubernetes-gitops-platform
- Application: sre-demo
- Namespace: sre-demo

## Objective

Validate Git-driven deployment automation and automatic
configuration drift correction.

## Test 1 — Git-Driven Deployment

Initial state:
- Desired replicas: 2
- Available replicas: 2

Action:
- Updated the Deployment configuration in Git from
  2 replicas to 3 replicas.
- Committed and pushed the change to GitHub.
- No manual kubectl apply was executed.

Observed result:
- Argo CD detected the new Git revision.
- Argo CD automatically synchronized the application.
- Kubernetes scaled the Deployment to 3 replicas.
- All three replicas became healthy.

Git commit:
7c8dd796b1658426a49d8042e2c45e9cbf8fe25a

Result: PASSED

## Test 2 — Configuration Drift and Self-Healing

Initial state:
- Git desired replicas: 3
- Kubernetes available replicas: 3

Action:

kubectl -n sre-demo scale deployment/sre-demo --replicas=2

Observed transition:

3/3 -> 3/2 -> 2/2 -> 2/3 -> 3/3

Argo CD automatically detected and corrected the drift.

Final state:
- Git desired replicas: 3
- Kubernetes available replicas: 3
- Argo CD sync status: Synced
- Argo CD health status: Healthy

Controller evidence:
- Automated synchronization: Enabled
- Self-healing: Enabled
- Auto-heal attempts recorded
- Final synchronization phase: Succeeded

Result: PASSED

## Reliability and Operational Considerations

- The experiments ran in an isolated local Kubernetes cluster.
- PodDisruptionBudget requires at least one available replica.
- Topology spread constraints control eligible scheduling decisions.
- Automatic synchronization uses Git as the desired-state source.
- Automatic pruning was disabled during testing.
- No production workloads were involved.

## Limitations

These experiments demonstrate Kubernetes desired-state
reconciliation and GitOps automation.

They do not establish:
- Production high availability
- Zero-downtime deployments
- Disaster recovery guarantees
- Production security compliance
- Multi-region resilience
