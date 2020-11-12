# Install TBS And Dependencies

1. Create a project in harbor for Tanzu Build Service.  I created it as `tbs` and set it as public.

2. Set environment variables for use in the following sections

```bash
export TBS_REPOSITORY=$(yq r $PARAMS_YAML tbs.harborRepository)
export REGISTRY_USER=$(yq r $PARAMS_YAML commonSecrets.harborUser)
export REGISTRY_PASSWORD=$(yq r $PARAMS_YAML commonSecrets.harborPassword)
```

3. Download Tanzu Build Service and Dependencies from Tanzu Network

>Note: The demo includes exercising a rebase, that resolves base image vulnerabilities.  In order to do this, we want to import `version 100.0.22` and `version 100.0.39` of the TBS dependencies, where we will see CVE's resolved with the run image used in the demo.

```bash
# Pulled the following from pivnet info icon for tbs 1.0.3
pivnet download-product-files --product-slug='build-service' --release-version='1.0.3' --product-file-id=817468 -d ~/Downloads
pivnet download-product-files --product-slug='tbs-dependencies' --release-version='100.0.22' --product-file-id=801577 -d ~/Downloads
pivnet download-product-files --product-slug='tbs-dependencies' --release-version='100.0.39' --product-file-id=822244 -d ~/Downloads
```

4. Push the TBS images into your local Harbor registry

>Note: Ensure you have logged into harbor registry with your local docker daemon.

```bash
tar xvf ~/Downloads/build-service-1.0.3.tar -C /tmp
kbld relocate -f /tmp/images.lock --lock-output /tmp/images-relocated.lock --repository $TBS_REPOSITORY  
```

5. Deploy TBS components into your shared services cluster

>Note: Ensure you have switched your local kube context to your shared services cluster

```bash
ytt -f /tmp/values.yaml \
    -f /tmp/manifests/ \
    -v docker_repository="$TBS_REPOSITORY" \
    -v docker_username="$REGISTRY_USER" \
    -v docker_password="$REGISTRY_PASSWORD" \
    | kbld -f /tmp/images-relocated.lock -f- \
    | kapp deploy -a tanzu-build-service -n tanzu-kapp -f- -y
kp import -f ~/Downloads/descriptor-100.0.22.yaml
kp import -f ~/Downloads/descriptor-100.0.39.yaml
```

## Validate

Verify that the cluster builders are all ready.

```bash
kp clusterbuilder list
```

## Go to Next Step

[Setup TBS Demo Stack and Cluster Builder](03-tbs-custom-dependencies.md)