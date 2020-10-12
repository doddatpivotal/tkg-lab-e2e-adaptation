# Setup TBS Demo Stack and Cluster Builder

1. Set environment variables for use in the following sections

```bash
export TBS_REPOSITORY=$(yq r $PARAMS_YAML tbs.harborRepository)
```

2. Setup custom demo stack and cluster builder

In order to reliably demonstrate the TBS rebase capability that resolves CVE's identified by Harbor, we create a custom ClusterStack within TBS with a TBS dependency version that has known high vulnerabilities, `version 7`.  We downloaded and imported that version earlier, now we will create the ClusterStack `demo-stack` and ClusterBuilder `demo-cluster-builder` using those vulnerabilities.

>Note: You can open the downloaded ~/Downloads/descriptor-7.yaml and see the image sha256 references from below.

```bash
kp clusterstack create demo-stack  \
  --build-image $TBS_REPOSITORY/build@sha256:97ea650641effa523611d715fa16549968252ba803f19b13b4e9d5821708aea6 \
  --run-image $TBS_REPOSITORY/run@sha256:4084f6704cc27a7d93ebb050f5712c869072530576c473440e43c311c0c802f7

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