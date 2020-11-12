# Update TBS Stack to Remediate CVEs 

1. Set environment variables for use in the following sections

```bash
export TBS_REPOSITORY=$(yq r $PARAMS_YAML tbs.harborRepository)
```

2. Trigger a new build of Spring Pet Clinic by updating the Stack associated with its builder

>Note: Ensure you have switched your local kube context to your shared services cluster

```bash
# This sets the stack to use the patched images from TBS dependencies v100.0.39
kp clusterstack update demo-stack \
  --build-image $TBS_REPOSITORY/build@sha256:6f7c6c7fdac97a2f51cdf58923d1d2f5ab034e0fca2daf7e1df98086980c7b3c \
  --run-image $TBS_REPOSITORY/run@sha256:87302783be0a0cab9fde5b68c9954b7e9150ca0d514ba542e9810c3c6f2984ad
```

3. Validate the Harbor has been updated

```bash
kp build list spring-petclinic
```

Harbor should now show a second image created with fewer CVEs.

![Harbor Images](petclinic-rebase.png)

## Go to Next Step

[Setup Load Generation for More Interesting Dashboards](11-load-generation.md)