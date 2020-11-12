# Setup TBS Demo Stack and Cluster Builder

1. Set environment variables for use in the following sections

```bash
export TBS_REPOSITORY=$(yq r $PARAMS_YAML tbs.harborRepository)
```

2. Setup custom demo stack and cluster builder

In order to reliably demonstrate the TBS rebase capability that resolves CVE's identified by Harbor, we create a custom ClusterStack within TBS with a TBS dependency version that has known high vulnerabilities, `version 100.0.22`.  We downloaded and imported that version earlier, now we will create the ClusterStack `demo-stack` and ClusterBuilder `demo-cluster-builder` using those vulnerabilities from the `full` ClusterStack.

>Note: You can open the downloaded ~/Downloads/descriptor-7.yaml and see the image sha256 references from below.

```bash
# make it match with 100.0.2
kp clusterstack create demo-stack  \
  --build-image $TBS_REPOSITORY/build@sha256:ee37e655a4f39e2e6ffa123306db0221386032d3e6e51aac809823125b0a400e \
  --run-image $TBS_REPOSITORY/run@sha256:51cebe0dd77a1b09934c4ce407fb07e3fc6f863da99cdd227123d7bfc7411efa


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