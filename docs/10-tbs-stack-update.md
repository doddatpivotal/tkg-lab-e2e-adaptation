# Update TBS Stack to Remediate CVEs

This Lab will demonstrate how TBS can automatically and quickly rebuild images when a stack is updated with a patched version.

Alternatively and for a more in depth set of steps to demonstrate TBS capabilities and scenarios, leveraging also the Concourse pipeline, you can also check this [script](/scripts/tbs-in-depth.sh)


1. Set environment variables for use in the following sections

```bash
export TBS_REPOSITORY=$(yq e .tbs.harborRepository $PARAMS_YAML)
```

2. Trigger a new build of Spring Pet Clinic by updating the Stack associated with its builder

>Note: Ensure you have switched your local kube context to your shared services cluster

```bash
# This sets the stack to use the patched images from TBS dependencies v100.0.101.  You can check by looking at full stack in the descriptor-100.0.100.yaml that you downloaded in step 2.
kp clusterstack update demo-stack  \
  --build-image $TBS_REPOSITORY/build@sha256:2cd4b7a3bdd76c839a29b0a050476ba150c2639b75ff934bb62b8430440e3ea0 \
  --run-image $TBS_REPOSITORY/run@sha256:8e86b77ad25bde9e3f080d30789a4c8987ad81565f56eef54398bc5275070fc2
```

3. Validate the Harbor has been updated

```bash
kp build list spring-petclinic -n tbs-project-petclinic
```

Harbor should now show a second image created with fewer CVEs.

![Harbor Images](petclinic-rebase.png)

## Go to Next Step

[Setup Load Generation for More Interesting Dashboards](11-load-generation.md)
