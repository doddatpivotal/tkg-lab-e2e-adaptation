#!/bin/bash

# Lab Setup...

# Open two terminals
# Terminal 1

# Set context to tbs cluster

# Delete current image
kp image delete spring-petclinic -n tbs-project-petclinic

# Go to harbor and delete all repositories in your petclinic project

# To simplify some of the commands later (depend on your PARAMS_YAML env var)
cd ~/workspace/tanzu-e2e/tkg-lab-e2e-adaptation/
export PARAMS_YAML=local-config/values-vsphere.yaml

export TBS_REPOSITORY=$(yq r $PARAMS_YAML tbs.harborRepository)
export HARBOR_DOMAIN=$(yq r $PARAMS_YAML commonSecrets.harborDomain)

# Update cluster stack to make it match with 100.0.55
kp clusterstack update demo-stack  \
  --build-image $TBS_REPOSITORY/build@sha256:cf87e6b7e69c5394440c11d41c8d46eade57d13236e4fb79c80227cc15d33abf \
  --run-image $TBS_REPOSITORY/run@sha256:52a9a0002b16042b4d34382bc244f9b6bf8fd409557fe3ca8667a5a52da44608

#-----------------------------------

cd ~/workspace/spring-petclinic
./mvnw clean package -D skipTests

# Terminal 2
watch kp build list spring-petclinic -n tbs-project-petclinic

# ------------------------------------------------
# Create an image and then update it
# ------------------------------------------------

# Let's start by creating an image. At this point we have TBS installed and Harbor registry credentials configured
kp image create spring-petclinic --tag $HARBOR_DOMAIN/petclinic/spring-petclinic \
 --cluster-builder demo-cluster-builder \
 --namespace tbs-project-petclinic \
 --local-path target/*.jar

# Check images
kp image list -n tbs-project-petclinic
# Check builds
kp build list spring-petclinic -n tbs-project-petclinic
# Check build logs
kp build logs spring-petclinic -b 1 -n tbs-project-petclinic
# Let's observe the stages of the build from ^^^^

# Let's go to harbor and find the images

# Let's make a quick code change and push it
vi src/main/resources/templates/welcome.html
./mvnw clean package -D skipTests

kp image patch spring-petclinic \
 --namespace tbs-project-petclinic \
 --local-path target/spring-petclinic-*.BUILD-SNAPSHOT.jar

# Check Harbor again for a new image

kp build logs spring-petclinic -b 2 -n tbs-project-petclinic

# ------------------------------------------------
# Explore the build service central configuration
# ------------------------------------------------

# Explore stores
kp clusterstore list
kp clusterstore status default
# Explore stacks
kp clusterstack list
kp clusterstack status demo-stack
# Explore builders
kp clusterbuilder list
kp clusterbuilder status demo-cluster-builder

# ------------------------------------------------
# Inspect image for metadata for traceability and auditability
# ------------------------------------------------

# Discuss Tanzu continually posting updates
open https://network.pivotal.io/products/tbs-dependencies/

# Discuss how you can download the descriptor and then run a command like (but don't actually run)
# This process can easily be automated with a CI tool like Concourse
kp import -f ~/Downloads/descriptor-100.0.67.yaml

# Update cluster stack to make it match with 100.0.67
kp clusterstack update demo-stack  \
  --build-image $TBS_REPOSITORY/build@sha256:9524501920aa148bb28c38ae39a247c1d9434dda1a75a3474586410c5fccd3d6 \
  --run-image $TBS_REPOSITORY/run@sha256:e0da03d34aaee5c60adfdd07833c926efcfb5d1b817be26ecb9c33db4c2277cf
# Image rebuild

# Check logs this time
kp build logs spring-petclinic -b3 -n tbs-project-petclinic

# Check Harbor again for a new image with less vulnerabilities

# ------------------------------------------------
# Inspect image for metadata for traceability and auditability
# ------------------------------------------------

# Show result of a Dockerfile image
docker pull $HARBOR_DOMAIN/concourse/concourse-helper
docker inspect $HARBOR_DOMAIN/concourse/concourse-helper

# Now show a TBS built image

export MOST_RECENT_SUCCESS_IMAGE=$(kp build list spring-petclinic -n tbs-project-petclinic | grep SUCCESS | tail -1 | awk '{print $(3)}')
docker pull $MOST_RECENT_SUCCESS_IMAGE

docker inspect $MOST_RECENT_SUCCESS_IMAGE
# Discuss the sheer amount of metadata, baked right into the image itself

docker inspect $MOST_RECENT_SUCCESS_IMAGE | jq ".[].Config.Labels.\"io.buildpacks.build.metadata\" | fromjson"
# Can be parsed

docker inspect $MOST_RECENT_SUCCESS_IMAGE | jq ".[].Config.Labels.\"io.buildpacks.build.metadata\" | fromjson | .buildpacks"
# And even more specific example, which buildpacks
