# Update TBS Stack to Remediate CVEs 

1. Trigger a new build of Spring Pet Clinic by updating the Stack associated with its builder

>Note: Ensure you have switched your local kube context to your shared services cluster

```bash
# This sets the stack to use the patched images from TBS dependencies v100.0.22
kp clusterstack update demo-stack \
  --build-image harbor.stormsend.tkg-vsphere-lab.winterfell.live/tbs/build-service/build@sha256:ee37e655a4f39e2e6ffa123306db0221386032d3e6e51aac809823125b0a400e \
  --run-image harbor.stormsend.tkg-vsphere-lab.winterfell.live/tbs/build-service/run@sha256:51cebe0dd77a1b09934c4ce407fb07e3fc6f863da99cdd227123d7bfc7411efa
```

2. Validate the Harbor has been updated

Harbor should now show a second image created with fewer CVEs.

![Harbor Images](petclinic-rebase.png)
