# Install TBS And Dependencies

1. Create a project in harbor for Tanzu Build Service.  I created it as `tbs` and set it as public.

2. Create a robot account inside of your harbor project.  This can be done in the UI by accessing the project and then selecting the `Robot Accounts` tab.  Update `params.yaml` config `.tbs.harborUser` and `.tbs.harborPassword` with the robot account credentials.

3. Set environment variables for use in the following sections

```bash
export TBS_REPOSITORY=$(yq e .tbs.harborRepository $PARAMS_YAML)
# For backward compatability to old params.yaml format, if you don't have .tbs.harborUser set, we will set from .commonSecrets.harborUser.  Likewise for password
export REGISTRY_USER=$(yq e '.tbs.harborUser // .commonSecrets.harborUser' $PARAMS_YAML)
export REGISTRY_PASSWORD=$(yq e '.tbs.harborPassword //.commonSecrets.harborPassword' $PARAMS_YAML)
export TBS_VERSION=1.2.1
```

4. Download Tanzu Build Service and Dependencies from Tanzu Network

>Note: The demo includes exercising a rebase, that resolves base image vulnerabilities.  In order to do this, we want to import `version 100.0.81` and `version 100.0.125` of the TBS dependencies, where we will see CVE's resolved with the run image used in the demo.

```bash
# Pulled the following from pivnet info icon for tbs 1.2.1
pivnet download-product-files --product-slug='tbs-dependencies' --release-version='100.0.81' --product-file-id=909780 -d ~/Downloads
pivnet download-product-files --product-slug='tbs-dependencies' --release-version='100.0.125' --product-file-id=997318 -d ~/Downloads
```

5. Push the TBS images into your local Harbor registry

>Note: Ensure you have logged into harbor registry with your local docker daemon.

>Note: Ensure you have also logged into Tanzu Network registry (registry.pivotal.io) with your Tanzu Network credentials.

>Note: Ensure you have imgpkg version 0.12.0 or higher.

```bash
imgpkg copy -b "registry.pivotal.io/build-service/bundle:$TBS_VERSION" --to-repo $TBS_REPOSITORY
```

6. Deploy TBS components into your shared services cluster

>Note: Ensure you have switched your local kube context to your shared services cluster

>Note: If you specified a new robot account as harbor user, then make sure the account exists and is a member of the $TBS_REPOSITORY

```bash
imgpkg pull -b "$TBS_REPOSITORY:$TBS_VERSION" -o /tmp/bundle
ytt -f /tmp/bundle/values.yaml \
    -f /tmp/bundle/config/ \
    -v docker_repository="$TBS_REPOSITORY" \
    -v docker_username="$REGISTRY_USER" \
    -v docker_password="$REGISTRY_PASSWORD" \
    | kbld -f /tmp/bundle/.imgpkg/images.yml -f- \
    | kapp deploy -a tanzu-build-service -n tanzu-kapp -f- -y
kp import -f ~/Downloads/descriptor-100.0.81.yaml
kp import -f ~/Downloads/descriptor-100.0.125.yaml
```

## Validate

Verify that the cluster builders are all ready.

```bash
kp clusterbuilder list
```

## Go to Next Step

[Setup TBS Demo Stack and Cluster Builder](03-tbs-custom-dependencies.md)
