# Setup TBS Demo Stack and Cluster Builder

1. Set environment variables for use in the following sections

```bash
export TBS_REPOSITORY=$(yq e .tbs.harborRepository $PARAMS_YAML)
```

2. Setup custom demo stack and cluster builder

In order to reliably demonstrate the TBS rebase capability that resolves CVE's identified by Harbor, we create a custom ClusterStack within TBS with a TBS dependency version that has known high vulnerabilities, `version 100.0.81`.  We downloaded and imported that version earlier, now we will create the ClusterStack `demo-stack` and ClusterBuilder `demo-cluster-builder` using those vulnerabilities from the `full` ClusterStack.

>Note: You can open the downloaded ~/Downloads/descriptor-100.0.81.yaml and see the image sha256 references from below.

```bash
# make it match with 100.0.81
kp clusterstack create demo-stack  \
  --build-image $TBS_REPOSITORY/build@sha256:e2371eb5092beeb8eada41259e3b070ab2a0037218a28105c0fea590b3b57cb5 \
  --run-image $TBS_REPOSITORY/run@sha256:8c61edbd83d1741b4a50478314bfcb6aea7defa65205fe56044db4ed34874155

kp clusterbuilder create demo-cluster-builder \
  --tag $TBS_REPOSITORY/demo-cluster-builder \
  --order tbs/demo-cluster-builder-order.yaml \
  --stack demo-stack \
  --store default
```

## Validate

Verify that the cluster builders are all ready.

```bash
kp clusterbuilder list
```

## Go to Next Step

[Setup Workspace and Pet Clinic Namespace](04-petclinic-workspace.md)
