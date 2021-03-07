# Setup TBS Demo Stack and Cluster Builder

1. Set environment variables for use in the following sections

```bash
export TBS_REPOSITORY=$(yq e .tbs.harborRepository $PARAMS_YAML)
```

2. Setup custom demo stack and cluster builder

In order to reliably demonstrate the TBS rebase capability that resolves CVE's identified by Harbor, we create a custom ClusterStack within TBS with a TBS dependency version that has known high vulnerabilities, `version 100.0.55`.  We downloaded and imported that version earlier, now we will create the ClusterStack `demo-stack` and ClusterBuilder `demo-cluster-builder` using those vulnerabilities from the `full` ClusterStack.

>Note: You can open the downloaded ~/Downloads/descriptor-55.yaml and see the image sha256 references from below.

```bash
# make it match with 100.0.55
kp clusterstack create demo-stack  \
  --build-image $TBS_REPOSITORY/build@sha256:cf87e6b7e69c5394440c11d41c8d46eade57d13236e4fb79c80227cc15d33abf \
  --run-image $TBS_REPOSITORY/run@sha256:52a9a0002b16042b4d34382bc244f9b6bf8fd409557fe3ca8667a5a52da44608

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