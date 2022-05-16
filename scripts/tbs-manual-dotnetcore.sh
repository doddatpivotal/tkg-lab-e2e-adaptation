#!/bin/bash

# ---------------------------
#   Preparation / Cleanup
# ---------------------------

# To simplify some of the commands later (depend on your PARAMS_YAML env var)
cd ~/Code/tkg-lab-e2e-adaptation
export PARAMS_YAML=local-config/values.yaml
export HARBOR_DOMAIN=$(yq e .commonSecrets.harborDomain $PARAMS_YAML)
export HARBOR_USER=$(yq e .commonSecrets.harborUser $PARAMS_YAML)
export TBS_REPOSITORY=$(yq e .tbs.harborRepository $PARAMS_YAML)
export TODOS_IMAGE=$(yq e .todos.image $PARAMS_YAML)
export TBS_TODOS_NAMESPACE=$(yq e .todos.tbs.namespace $PARAMS_YAML)
export TODOS_REPO=$(yq e .todos.codeRepo $PARAMS_YAML)
export TODOS_REPO_PATH=$(yq e .todos.codeRepoPath $PARAMS_YAML)
export TODOS_LOCAL_PATH=$(yq e .todos.codeLocalPath $PARAMS_YAML)

# We assume TBS_TODOS_NAMESPACE exists and the Harbor credentials are created via "kp" in it
# Create namespace if it doesn't exist
kubectl create namespace $TBS_TODOS_NAMESPACE --dry-run=client --output yaml | kubectl apply -f -

# Create secret for tbs/kpack to be able to push new OCI images to our registry
kp secret create harbor-creds \
  --registry $HARBOR_DOMAIN \
  --registry-user $HARBOR_USER \
  --namespace $TBS_TODOS_NAMESPACE

# Delete current images
kp image delete todos -n $TBS_TODOS_NAMESPACE

# Update cluster stack to make it match with 100.0.255
kp clusterstack update demo-stack  \
  --build-image $TBS_REPOSITORY@sha256:ae63b7c588f3dd728d2d423dd26790af784decc3d3947eaff2696b8fd30bcfb0 \
  --run-image $TBS_REPOSITORY@sha256:ec48e083ab3d47df591de02423440c5de7f8af2e4ec6b4263af476812c4e3f85

# -------------------------------
#   Create image from source code
# -------------------------------

# Let's start by creating an image based in source. At this point we have TBS installed and Harbor registry credentials configured
kp image create todos --tag $TODOS_IMAGE \
 --cluster-builder demo-cluster-builder \
 --namespace $TBS_TODOS_NAMESPACE \
 --wait  \
 --local-path $TODOS_LOCAL_PATH

# Let's observe the stages of the build
# ...

# Check images
kp image list -n $TBS_TODOS_NAMESPACE

# Check builds from existing image (already created)
kp build list todos -n $TBS_TODOS_NAMESPACE
# Check build logs from existing image (already created)
kp build logs todos -n $TBS_TODOS_NAMESPACE

# Let's go to harbor and find the images

# Update cluster stack to make it match with 100.0.286
kp clusterstack update demo-stack  \
  --build-image $TBS_REPOSITORY@sha256:43c78f6bcbcfb4ddf1ec6c14effdf26414ffbb21d8773519e85c325fd1a2561f \
  --run-image $TBS_REPOSITORY@sha256:d20231b7664446896d79d4d9178a62ce04a45d3ce02b3be54964a6c403b1ef06
# Image(s) rebuild
watch kp build list todos -n $TBS_TODOS_NAMESPACE
# Check logs
kp build logs todos -n $TBS_TODOS_NAMESPACE

# ---------------------------
#   Iterate on Source Code
# ---------------------------

# Let's make a quick code change 
# Change some literal string in
vi $TODOS_LOCAL_PATH/Controllers/EmployeesController.cs

# Patch existing image (this would normally be triggered by the CI pipeline when suitable)
kp image patch todos \
 --cluster-builder demo-cluster-builder \
 --namespace $TBS_TODOS_NAMESPACE \
 --wait  \
 --local-path $TODOS_LOCAL_PATH

# Check new build
kp build list todos -n $TBS_TODOS_NAMESPACE

# Check how only one layer is changed and the rest of the layers are reused from cache

# Check Harbor again for a new image

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
docker pull $TODOS_IMAGE
docker inspect $TODOS_IMAGE
# Discuss the sheer amount of metadata, baked right into the image itself

docker inspect $TODOS_IMAGE | jq ".[].Config.Labels.\"io.buildpacks.build.metadata\" | fromjson"
# Can be parsed

docker inspect $TODOS_IMAGE | jq ".[].Config.Labels.\"io.buildpacks.build.metadata\" | fromjson | .buildpacks"
# And even more specific example, which buildpacks


# -------------------------------
#   Create image from source code from GitHub
# -------------------------------

# Let's also see how can we create an image from a source code repo (github)
kp image create todos2 --tag $TODOS_IMAGE \
 --cluster-builder demo-cluster-builder \
 --namespace $TBS_TODOS_NAMESPACE \
 --wait  \
 --git $TODOS_REPO \
 --git-revision main \
 --sub-path $TODOS_REPO_PATH


# ---------------------------
#   Iterate on Source Code into GitHub
# ---------------------------

# Let's make a quick code change and push it (within the dotnet-core-sql-k8s-demo repo folder)
# Change some literal string in
vi $TODOS_LOCAL_PATH/Controllers/EmployeesController.cs
git add . && git commit -m "code change" && git push origin main

# Check new build kicks in
watch kp build list todos2 -n $TBS_TODOS_NAMESPACE
