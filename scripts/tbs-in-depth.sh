#!/bin/bash

# To simplify some of the commands later
export TBS_REPOSITORY=harbor.rito.tkg-vsp-lab.hyrulelab.com/tbs/build-service
export TBS_REGISTRY=harbor.rito.tkg-vsp-lab.hyrulelab.com

# Let's start by creating an image. At this point we have TBS installed and Harbor registry credentials configured
kp image create spring-petclinic --tag harbor.rito.tkg-vsp-lab.hyrulelab.com/petclinic/spring-petclinic \
 --cluster-builder demo-cluster-builder \
 --namespace tbs-project-petclinic \
 --wait  \
 --local-path target/spring-petclinic-2.4.0.BUILD-SNAPSHOT.jar

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

# Update cluster stack to make it match with 100.0.55
kp clusterstack update demo-stack \
 --build-image $TBS_REPOSITORY/build@sha256:cf87e6b7e69c5394440c11d41c8d46eade57d13236e4fb79c80227cc15d33abf \
 --run-image $TBS_REPOSITORY/run@sha256:52a9a0002b16042b4d34382bc244f9b6bf8fd409557fe3ca8667a5a52da44608
# Image rebuild
# Check Concourse to see CD triggered
# Check Harbor again for a new image with less vulnerabilities


# Inspect image for metadata for traceability and auditability
#Dockerfile image
docker inspect $TBS_REGISTRY/concourse/concourse-helper@sha256:e89d7f3359962828ccd1857477448bb56146095215b7e91f028f11a3b5bb1e15

docker pull $TBS_REGISTRY/petclinic/spring-petclinic@sha256:87e7b83d127a8be4afed41b61b35da056b0d97ea2f22f7c424ca46c2092fd606

docker inspect $TBS_REGISTRY/petclinic/spring-petclinic@sha256:87e7b83d127a8be4afed41b61b35da056b0d97ea2f22f7c424ca46c2092fd606

docker inspect $TBS_REGISTRY/petclinic/spring-petclinic@sha256:87e7b83d127a8be4afed41b61b35da056b0d97ea2f22f7c424ca46c2092fd606 | jq ".[].Config.Labels.\"io.buildpacks.build.metadata\" | fromjson"

docker inspect $TBS_REGISTRY/petclinic/spring-petclinic@sha256:87e7b83d127a8be4afed41b61b35da056b0d97ea2f22f7c424ca46c2092fd606 | jq ".[].Config.Labels.\"io.buildpacks.build.metadata\" | fromjson | .buildpacks"

# Update code manually
kp image patch spring-petclinic \
 --namespace tbs-project-petclinic \
 --wait  \
 --local-path target/spring-petclinic-2.4.0.BUILD-SNAPSHOT.jar

# Cleanup

# Update cluster stack to make it match with 100.0.22 again
kp clusterstack update demo-stack  \
  --build-image $TBS_REPOSITORY/build@sha256:ee37e655a4f39e2e6ffa123306db0221386032d3e6e51aac809823125b0a400e \
  --run-image $TBS_REPOSITORY/run@sha256:51cebe0dd77a1b09934c4ce407fb07e3fc6f863da99cdd227123d7bfc7411efa
