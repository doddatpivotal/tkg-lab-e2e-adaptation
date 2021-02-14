#!/bin/bash

# To simplify some of the commands later (depend on your PARAMS_YAML env var)
export TBS_REPOSITORY=$(yq r $PARAMS_YAML tbs.harborRepository)
export HARBOR_DOMAIN=$(yq r $PARAMS_YAML commonSecrets.harborDomain)

# Let's start by creating an image. At this point we have TBS installed and Harbor registry credentials configured
kp image create spring-petclinic --tag $HARBOR_DOMAIN/petclinic/spring-petclinic \
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

# Update cluster stack to make it match with 100.0.67
kp clusterstack update demo-stack  \
  --build-image $TBS_REPOSITORY/build@sha256:9524501920aa148bb28c38ae39a247c1d9434dda1a75a3474586410c5fccd3d6 \
  --run-image $TBS_REPOSITORY/run@sha256:e0da03d34aaee5c60adfdd07833c926efcfb5d1b817be26ecb9c33db4c2277cf
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
 --local-path target/spring-petclinic-2.4.0.BUILD-SNAPSHOT.jar

# Cleanup

# Update cluster stack to make it match with 100.0.55 again
kp clusterstack update demo-stack  \
  --build-image $TBS_REPOSITORY/build@sha256:cf87e6b7e69c5394440c11d41c8d46eade57d13236e4fb79c80227cc15d33abf \
  --run-image $TBS_REPOSITORY/run@sha256:52a9a0002b16042b4d34382bc244f9b6bf8fd409557fe3ca8667a5a52da44608
