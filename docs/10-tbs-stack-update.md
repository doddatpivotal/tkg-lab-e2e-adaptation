# Update TBS Stack to Remediate CVEs

This Lab will demonstrate how TBS can automatically and quickly rebuild images when a stack is updated with a patched version.

Alternatively and for a more in depth set of steps to demonstrate TBS capabilities and scenarios, leveraging also the Concourse pipeline, you can also check this [script](/scripts/tbs-in-depth.sh)


1. Set environment variables for use in the following sections

```bash
export TBS_REPOSITORY=$(yq r $PARAMS_YAML tbs.harborRepository)
```

2. Trigger a new build of Spring Pet Clinic by updating the Stack associated with its builder

>Note: Ensure you have switched your local kube context to your shared services cluster

```bash
# This sets the stack to use the patched images from TBS dependencies v100.0.55.  You can check this in the descriptor-100.0.55.yaml that you downloaded in step 2.
kp clusterstack update demo-stack \
  --build-image $TBS_REPOSITORY/build@sha256:cf87e6b7e69c5394440c11d41c8d46eade57d13236e4fb79c80227cc15d33abf \
  --run-image $TBS_REPOSITORY/run@sha256:52a9a0002b16042b4d34382bc244f9b6bf8fd409557fe3ca8667a5a52da44608
```

3. Validate the Harbor has been updated

```bash
kp build list spring-petclinic
```

Harbor should now show a second image created with fewer CVEs.

![Harbor Images](petclinic-rebase.png)

## Go to Next Step

[Setup Load Generation for More Interesting Dashboards](11-load-generation.md)
