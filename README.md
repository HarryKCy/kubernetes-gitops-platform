# Kubernetes GitOps Platform — starter implementation

A **development-lab** Kubernetes deployment with a namespaced Kustomize overlay, restricted NGINX container, resource bounds, readiness/liveness probes, service and a sample Argo CD Application.

## Validate (without a cluster)
```bash
kubectl kustomize k8s/overlays/dev
```

## Deploy to a disposable cluster
```bash
kubectl config current-context  # verify this is NOT a production cluster
kubectl apply -k k8s/overlays/dev
bash scripts/smoke-test.sh
kubectl -n sre-demo port-forward service/sre-demo 8080:80
# Another terminal: curl -f http://127.0.0.1:8080/
```

## Argo CD example
Install/configure Argo CD in the disposable cluster separately, publish the repository, verify the repo URL and revision in `argocd/application-example.yaml`, then apply the Application manifest to the `argocd` namespace. The manifest is an **example**, not proof of working GitOps deployment. Automated pruning and self-healing are intentionally disabled.

## Limitations and follow-ups
The deployment image is version-tagged but not digest-pinned. Verify image tag availability and pin an immutable digest for reproducibility. Do not use this as a production-ready network or security posture. Add namespace NetworkPolicy, supply-chain scanning, secret handling, progressive delivery, SLO monitoring, cluster-side integration tests, and rollback evidence after the initial lab verification.
