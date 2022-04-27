# Install TBS And Dependencies

1. Create a project in harbor for Tanzu Build Service.  I created it as `tbs` and set it as public.

2. Set environment variables for use in the following sections

```bash
export TBS_REPOSITORY=$(yq e .tbs.harborRepository $PARAMS_YAML)
export REGISTRY_USER=$(yq e .commonSecrets.harborUser $PARAMS_YAML)
export REGISTRY_PASSWORD=$(yq e .commonSecrets.harborPassword $PARAMS_YAML)
export TANZUNET_USERNAME=$(yq e .commonSecrets.tanzunet_username $PARAMS_YAML)
export TANZUNET_PASSWORD=$(yq e .commonSecrets.tanzunet_password $PARAMS_YAML)
```

3. Relocate the TBS images into your local Harbor registry

>Note: Ensure you have logged into harbor registry with your local docker daemon.

>Note: Ensure you have also logged into Tanzu Registry (docker login registry.tanzu.vmware.com) with your Tanzu Network credentials.

>Note: Make sure you have the right Carvel tools versions. This combination worked for me: imgpkg v0.17.0 (0.18.0 fails!), kbld v0.31.0, ytt 0.35.1

```bash
imgpkg copy -b "registry.tanzu.vmware.com/build-service/bundle:1.4.3" --to-repo $TBS_REPOSITORY
```

4. Pull the Tanzu Build Service bundle locally:

```bash
rm -rf /tmp/bundle
imgpkg pull -b $TBS_REPOSITORY":1.4.3" -o /tmp/bundle
```

5. Deploy TBS components into your shared services cluster

>Note: Ensure you have switched your local kube context to your shared services cluster

>Note: If you specified a new robot account as harbor user, then make sure the account exists and is a member of the $TBS_REPOSITORY

```bash
ytt -f /tmp/bundle/config/ \
	-v kp_default_repository="$TBS_REPOSITORY" \
	-v kp_default_repository_username="$REGISTRY_USER" \
	-v kp_default_repository_password="$REGISTRY_PASSWORD" \
	--data-value-yaml pull_from_kp_default_repo=true \
	| kbld -f /tmp/bundle/.imgpkg/images.yml -f- \
	| kapp deploy -a tanzu-build-service -f- -y
```

6. Install newest descriptor

```bash
pivnet download-product-files --product-slug='tbs-dependencies' --release-version='100.0.286' --product-file-id=1188028 -d ~/Downloads
kp import -f ~/Downloads/descriptor-100.0.286.yaml
pivnet download-product-files --product-slug='tbs-dependencies' --release-version='100.0.255' --product-file-id=1142215 -d ~/Downloads
kp import -f ~/Downloads/descriptor-100.0.255.yaml
```

## Validate

Verify that the cluster builders are all ready.

```bash
kp clusterbuilder list
```

## Go to Next Step

[Setup TBS Demo Stack and Cluster Builder](03-tbs-custom-dependencies.md)
