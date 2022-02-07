# TKG Lab Foundation

If using the GitOps (ArgoCD) go to [TKG Lab Foundation for GitOps](00-tkg-lab-foundation-gitops.md) instead.

Execute the `Foudational Lab Setup` from [tkg-lab](https://github.com/Pivotal-Field-Engineering/tkg-lab).

>Note: I tested this with 6 worker nodes in the Shared Services cluster and 4 worker nodes in the Workload cluster.  Worker nodes were 2 core, 8 GB.

Then exercise the following bonus labs...

1. [Deploy Concourse to Shared Services Cluster](https://github.com/Pivotal-Field-Engineering/tkg-lab/blob/master/docs/bonus-labs/concourse.md)
2. [Deploy Kubeapps to Shared Services Cluster](https://github.com/Pivotal-Field-Engineering/tkg-lab/blob/master/docs/bonus-labs/kubeapps.md)

>Note: Previously Harbor deployment was a bonus lab, but recent updates to tkg-lab, Harbor is now part of the base install, so it is not specifically referenced here.

## Go to Next Step

[Setup Environment Specific Params Yaml](01-environment-config.md)
