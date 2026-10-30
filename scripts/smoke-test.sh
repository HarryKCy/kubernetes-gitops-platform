#!/usr/bin/env bash
set -euo pipefail
NAMESPACE="${1:-sre-demo}"
# Intended only for a disposable lab cluster/context.
kubectl config current-context
kubectl -n "$NAMESPACE" rollout status deployment/sre-demo --timeout=120s
kubectl -n "$NAMESPACE" get pods -l app=sre-demo -o wide
kubectl -n "$NAMESPACE" get service/sre-demo
