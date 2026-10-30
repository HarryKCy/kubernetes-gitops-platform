# Kubernetes Scheduling and Rolling Update Investigation

## Environment

- Local three-node kind Kubernetes cluster
- One control-plane node
- Two worker nodes
- Kubernetes v1.37.0
- Application: Nginx Unprivileged
- Desired replicas: 2

## Incident

A Kubernetes Deployment rolling update became blocked after
introducing strict topology spread constraints.

The new Pod remained Pending while two existing replicas
continued serving the application.

## Scheduler Error

FailedScheduling:

0/3 nodes are available:
1 node had untolerated taints.
2 nodes did not match Pod topology spread constraints.

## Root Cause

The Deployment combined:

- maxSurge: 1
- maxUnavailable: 0
- maxSkew: 1
- whenUnsatisfiable: DoNotSchedule

The topology spread calculation included an ineligible
control-plane topology domain.

This prevented the temporary rollout Pod from scheduling.

## Resolution

Configured:

    nodeTaintsPolicy: Honor

This caused topology spread calculations to honor node taints.

The rolling update subsequently completed successfully.

## Verification

- Deployment reached 2/2 available replicas.
- Old ReplicaSet scaled down to zero.
- New ReplicaSet became available.
- A controlled Pod replacement restored the desired replica count.
- Final placement showed one Pod on each worker.

## Lessons Learned

- Topology spread constraints interact with node eligibility.
- Rolling updates temporarily require additional scheduling capacity.
- Control-plane taints can affect topology calculations.
- Successful rollouts do not guarantee immediate Pod redistribution.
- Scheduler events are essential for diagnosing Pending Pods.

## Scope

This experiment was conducted in an isolated local Kubernetes lab.

It does not establish production-level high availability or
continuous zero-downtime service operation.
