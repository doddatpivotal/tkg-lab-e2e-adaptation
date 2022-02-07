# Setup TBS Demo Stack and Cluster Builder

1. Set environment variables for use in the following sections

```bash
export TBS_REPOSITORY=$(yq e .tbs.harborRepository $PARAMS_YAML)
```

2. Setup custom demo stack and cluster builder

In order to reliably demonstrate the TBS rebase capability that resolves CVE's identified by Harbor, we create a custom ClusterStack within TBS with a TBS dependency version that has known high vulnerabilities, `version 100.0.230`.  We downloaded and imported that version earlier, now we will create the ClusterStack `demo-stack` and ClusterBuilder `demo-cluster-builder` using those vulnerabilities from the `full` ClusterStack.

>Note: You can open the downloaded ~/Downloads/descriptor-100.0.81.yaml and see the image sha256 references from below.

```bash
# make it match with 100.0.81
kp clusterstack create demo-stack  \
  --build-image $TBS_REPOSITORY@sha256:999eab7567ec796f4284b5b998b24952a2c977506c88f69dcf9b11299164d3a7 \
  --run-image $TBS_REPOSITORY@sha256:c7add890cc6d88fa12d2f1cd9864239aaac2f95c80a5a82c6d811c2ca0bee93d

kp clusterbuilder create demo-cluster-builder \
  --tag $TBS_REPOSITORY:demo-cluster-builder \
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
