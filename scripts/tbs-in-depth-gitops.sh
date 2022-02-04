#!/bin/bash

# ---------------------------
#   Preparation / Cleanup
# ---------------------------

# To simplify some of the commands later (depend on your PARAMS_YAML env var)
cd ~/Code/tkg-lab-e2e-adaptation
export PARAMS_YAML=local-config/values.yaml
export TBS_REPOSITORY=$(yq e .tbs.harborRepository $PARAMS_YAML)
export HARBOR_DOMAIN=$(yq e .commonSecrets.harborDomain $PARAMS_YAML)
export PETCLINIC_REPO=$(yq e .petclinic.codeRepo $PARAMS_YAML)
export ARGOCD_APPLICATION=$(yq e .petclinic.argocd.applicationName $PARAMS_YAML)

# Delete current images
kp image delete spring-petclinic -n tbs-project-petclinic
kp image delete spring-petclinic-demo -n tbs-project-petclinic

# Update cluster stack to make it match with 100.0.81
kp clusterstack update demo-stack  \
  --build-image $TBS_REPOSITORY/build@sha256:e2371eb5092beeb8eada41259e3b070ab2a0037218a28105c0fea590b3b57cb5 \
  --run-image $TBS_REPOSITORY/run@sha256:8c61edbd83d1741b4a50478314bfcb6aea7defa65205fe56044db4ed34874155

# Go to your petclinic app local code repo
cd ~/Code/spring-petclinic
# Let's start by creating an image based in source. At this point we have TBS installed and Harbor registry credentials configured
kp image create spring-petclinic --tag $HARBOR_DOMAIN/petclinic/spring-petclinic \
 --cluster-builder demo-cluster-builder \
 --namespace tbs-project-petclinic \
 --wait  \
 --git $PETCLINIC_REPO \
 --git-revision main

# Sync ArgoCD app
argocd app sync $ARGOCD_APPLICATION
# Check ArgoCD UI to see objects syncing
# Check Petclinic app UI to confirm app is up and running

# ---------------------------
#   TBS Demo for E2E flow
# ---------------------------

# Go to your petclinic app local code repo
cd ~/Code/spring-petclinic
# Let's create another image based in source, to show the process and first steps of the build
kp image create spring-petclinic-demo --tag $HARBOR_DOMAIN/petclinic/spring-petclinic-demo \
 --cluster-builder demo-cluster-builder \
 --namespace tbs-project-petclinic \
 --wait  \
 --git $PETCLINIC_REPO \
 --git-revision main
# Let's observe the stages of the build
# ...

# Check images
kp image list -n tbs-project-petclinic

# Check builds from existing image (already created)
kp build list spring-petclinic -n tbs-project-petclinic
# Check build logs from existing image (already created)
kp build logs spring-petclinic -b 1 -n tbs-project-petclinic

# Let's go to harbor and find the images

# Update cluster stack to make it match with 100.0.101
kp clusterstack update demo-stack  \
  --build-image $TBS_REPOSITORY/build@sha256:2cd4b7a3bdd76c839a29b0a050476ba150c2639b75ff934bb62b8430440e3ea0 \
  --run-image $TBS_REPOSITORY/run@sha256:8e86b77ad25bde9e3f080d30789a4c8987ad81565f56eef54398bc5275070fc2
# Image(s) rebuild
kp build list spring-petclinic -n tbs-project-petclinic
# Check logs
kp build logs spring-petclinic -b3 -n tbs-project-petclinic

# ---------------------------
#   More TBS
# ---------------------------

# Let's make a quick code change and push it (within the spring-petclinic repo folder)
# Go to your petclinic app local code repo
cd ~/Code/spring-petclinicvi src/main/resources/templates/welcome.html
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
