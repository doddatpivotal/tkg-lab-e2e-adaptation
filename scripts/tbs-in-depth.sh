#!/bin/bash

# To simplify some of the commands later (depend on your PARAMS_YAML env var)
export TBS_REPOSITORY=$(yq e .tbs.harborRepository $PARAMS_YAML)
export HARBOR_DOMAIN=$(yq e .commonSecrets.harborDomain $PARAMS_YAML)

# Let's start by creating an image. At this point we have TBS installed and Harbor registry credentials configured
kp image create spring-petclinic --tag $HARBOR_DOMAIN/petclinic/spring-petclinic \
 --cluster-builder demo-cluster-builder \
 --namespace tbs-project-petclinic \
 --wait  \
 --local-path target/spring-petclinic-*.jar

# Let's observe the stages of the build

# Check Concourse to see CD triggered

# Check images
kp image list -n tbs-project-petclinic
# Check builds
kp build list spring-petclinic -n tbs-project-petclinic
# Check build logs
kp build logs spring-petclinic -b 1 -n tbs-project-petclinic

# Let's check Concourse to see CD triggered

# Let's make a quick code change and push it
# Check that Concourse CI starts
# Show what's suppossed to happen in the Concourse pipeline code
# And check a new build start when the app is
watch kp build list spring-petclinic -n tbs-project-petclinic
# Check Harbor again for a new image


# Explore stores
kp clusterstore list
kp clusterstore status default
# Explore stacks
kp clusterstack list
# Explore builders
kp clusterbuilder list

# Update cluster stack to make it match with 100.0.101
kp clusterstack update demo-stack  \
  --build-image $TBS_REPOSITORY/build@sha256:2cd4b7a3bdd76c839a29b0a050476ba150c2639b75ff934bb62b8430440e3ea0 \
  --run-image $TBS_REPOSITORY/run@sha256:8e86b77ad25bde9e3f080d30789a4c8987ad81565f56eef54398bc5275070fc2
# Image rebuild
# Check Concourse to see CD triggered
# Check Harbor again for a new image with less vulnerabilities


# Inspect image for metadata for traceability and auditability
#Dockerfile image
docker inspect $HARBOR_DOMAIN/concourse/concourse-helper@sha256:e89d7f3359962828ccd1857477448bb56146095215b7e91f028f11a3b5bb1e15

docker pull $HARBOR_DOMAIN/petclinic/spring-petclinic@sha256:87e7b83d127a8be4afed41b61b35da056b0d97ea2f22f7c424ca46c2092fd606

docker inspect $HARBOR_DOMAIN/petclinic/spring-petclinic@sha256:87e7b83d127a8be4afed41b61b35da056b0d97ea2f22f7c424ca46c2092fd606

docker inspect $HARBOR_DOMAIN/petclinic/spring-petclinic@sha256:87e7b83d127a8be4afed41b61b35da056b0d97ea2f22f7c424ca46c2092fd606 | jq ".[].Config.Labels.\"io.buildpacks.build.metadata\" | fromjson"

docker inspect $HARBOR_DOMAIN/petclinic/spring-petclinic@sha256:87e7b83d127a8be4afed41b61b35da056b0d97ea2f22f7c424ca46c2092fd606 | jq ".[].Config.Labels.\"io.buildpacks.build.metadata\" | fromjson | .buildpacks"

# Update code manually
kp image patch spring-petclinic \
 --namespace tbs-project-petclinic \
 --wait  \
 --local-path target/spring-petclinic-*.jar

# Cleanup

# Update cluster stack to make it match with 100.0.81 again
kp clusterstack update demo-stack  \
  --build-image $TBS_REPOSITORY/build@sha256:e2371eb5092beeb8eada41259e3b070ab2a0037218a28105c0fea590b3b57cb5 \
  --run-image $TBS_REPOSITORY/run@sha256:8c61edbd83d1741b4a50478314bfcb6aea7defa65205fe56044db4ed34874155
