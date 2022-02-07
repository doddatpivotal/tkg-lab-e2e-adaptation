#!/bin/bash

# ---------------------------
#   Preparation / Cleanup
# ---------------------------

# To simplify some of the commands later (depend on your PARAMS_YAML env var)
cd ~/Code/tkg-lab-e2e-adaptation
export PARAMS_YAML=local-config/values.yaml
export TBS_REPOSITORY=$(yq e .tbs.harborRepository $PARAMS_YAML)
export TODOS_IMAGE=$(yq e .todos.image $PARAMS_YAML)
export TBS_TODOS_NAMESPACE=$(yq e .todos.tbs.namespace $PARAMS_YAML)
export TODOS_REPO=$(yq e .todos.codeRepo $PARAMS_YAML)
export TODOS_REPO_PATH=$(yq e .todos.codeRepoPath $PARAMS_YAML)

# We assume TBS_TODOS_NAMESPACE exists and the Harbor credentials are created via "kp" in it

# Delete current images
kp image delete todos -n $TBS_TODOS_NAMESPACE

# Update cluster stack to make it match with 100.0.230
kp clusterstack update demo-stack  \
  --build-image $TBS_REPOSITORY@sha256:999eab7567ec796f4284b5b998b24952a2c977506c88f69dcf9b11299164d3a7 \
  --run-image $TBS_REPOSITORY@sha256:c7add890cc6d88fa12d2f1cd9864239aaac2f95c80a5a82c6d811c2ca0bee93d

# -------------------------------
#   Create image from source code
# -------------------------------

# Let's start by creating an image based in source. At this point we have TBS installed and Harbor registry credentials configured
kp image create todos --tag $TODOS_IMAGE \
 --cluster-builder demo-cluster-builder \
 --namespace $TBS_TODOS_NAMESPACE \
 --wait  \
 --git $TODOS_REPO \
 --git-revision main \
 --sub-path $TODOS_REPO_PATH

# Let's observe the stages of the build
# ...

# Check images
kp image list -n $TBS_TODOS_NAMESPACE

# Check builds from existing image (already created)
kp build list todos -n $TBS_TODOS_NAMESPACE
# Check build logs from existing image (already created)
kp build logs todos -n $TBS_TODOS_NAMESPACE

# Let's go to harbor and find the images

# Update cluster stack to make it match with 100.0.255
kp clusterstack update demo-stack  \
  --build-image $TBS_REPOSITORY@sha256:ae63b7c588f3dd728d2d423dd26790af784decc3d3947eaff2696b8fd30bcfb0 \
  --run-image $TBS_REPOSITORY@sha256:ec48e083ab3d47df591de02423440c5de7f8af2e4ec6b4263af476812c4e3f85
# Image(s) rebuild
kp build list todos -n $TBS_TODOS_NAMESPACE
# Check logs
kp build logs todos -n $TBS_TODOS_NAMESPACE

# ---------------------------
#   More TBS
# ---------------------------

# Let's make a quick code change and push it (within the spring-petclinic repo folder)
# Go to your petclinic app local code repo
cd ~/Code/dotnet-core-sql-k8s-demo src/main/resources/templates/welcome.html
git add . && git commit -m "code change" && git push origin main

# Check new build kicks in
watch kp build list spring-petclinic -n tbs-project-petclinic

# Check Harbor again for a new image

# TODO: Sync changes on ArgoCD or make changes on k8s config objects instead (ConfigMap) that causee app UI to react.

# Explore the build service central configuration
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

# Show result of a Dockerfile image
docker pull jaimegag/cassandra-demo
docker inspect jaimegag/cassandra-demo

# Now show a TBS built image

export MOST_RECENT_SUCCESS_IMAGE=$(kp build list spring-petclinic -n tbs-project-petclinic | grep SUCCESS | tail -1 | awk '{print $(3)}')
docker pull $MOST_RECENT_SUCCESS_IMAGE

docker inspect $MOST_RECENT_SUCCESS_IMAGE
# Discuss the sheer amount of metadata, baked right into the image itself

docker inspect $MOST_RECENT_SUCCESS_IMAGE | jq ".[].Config.Labels.\"io.buildpacks.build.metadata\" | fromjson"
# Can be parsed

docker inspect $MOST_RECENT_SUCCESS_IMAGE | jq ".[].Config.Labels.\"io.buildpacks.build.metadata\" | fromjson | .buildpacks"
# And even more specific example, which buildpacks
