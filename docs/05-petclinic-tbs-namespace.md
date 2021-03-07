# Setup Spring Pet Clinic TBS Project Namespace

In order manage Spring Pet Clinic images, we have to do some setup.  In the past step, we created the namespace for Tanzu Build Service to do it's magic.  Now we have to create a project in Harbor for TBS to publish images, and also create a secret in that namespace with the Harbor credentials required to push the images.

1. Create a project in Harbor for Spring Pet Clinic images.  I created it as `petclinic` and set it as public.

2. Configure the Harbor project to scan images immediately on push.

3. Create a robot account for build service to use when pushing images to harbor.  Store these as the credentials in your `params.yaml` file.

4. Set environment variables for use in the following sections

```bash
export HARBOR_DOMAIN=$(yq e .commonSecrets.harborDomain $PARAMS_YAML)
export REGISTRY_USER=$(yq e .commonSecrets.harborUser $PARAMS_YAML)
export REGISTRY_PASSWORD=$(yq e .commonSecrets.harborPassword $PARAMS_YAML)
export TBS_NAMESPACE=$(yq e .petclinic.tbs.namespace $PARAMS_YAML)
```

3. Create the secret holding Harbor credentials

>Note: Ensure you have switched your local kube context to your shared services cluster

```bash
kp secret create harbor-creds \
  --registry $HARBOR_DOMAIN \
  --registry-user $REGISTRY_USER \
  --namespace $TBS_NAMESPACE
```

## Go to Next Step

[Deploy Spring Pet Clinic MySql Database](06-petclinic-db.md)