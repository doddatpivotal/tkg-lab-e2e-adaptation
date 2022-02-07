# Create ArgoCD Pipeline for Spring Pet Clinic

> NOTE-TODO: Custom values should be parametrized in the ArgoCD Application (using extVars and something like jsonnet), until then we template it and push to the repo in advance

> NOTE-TODO: We should use the ArgoCD Application CRD but it doesn't seem to work, so we use the Argocd CLI

> NOTE-TODO: We need a solution for managing Secrets in a GitOps pipeline (SOPS or SealedSecrets), until then we push the secret directly outside of the CD pipeline

> NOTE-TODO: With or without the above we should move the below copy&past complexity to scripts


## Get custom configuration
Prepare env variables with Petclinic, Wavefront an custom settings
```bash
export PETCLINIC_CONFIG_LOCAL=$(yq e .petclinic.configRepoLocalPath $PARAMS_YAML)
export PETCLINIC_HOST=$(yq e .petclinic.host $PARAMS_YAML)
export PETCLINIC_IMAGE=$(yq e .petclinic.image $PARAMS_YAML)
export PETCLINIC_CONFIGREPO=$(yq e .petclinic.configRepo $PARAMS_YAML)
export WAVEFRONT_APP_NAME=$(yq e .petclinic.wavefront.applicationName $PARAMS_YAML)
export WAVEFRONT_URI=$(yq e .petclinic.wavefront.uri $PARAMS_YAML)
export WAVEFRONT_APITOKEN=$(yq e .petclinic.wavefront.apiToken $PARAMS_YAML)
export ARGOCD_APPLICATION=$(yq e .petclinic.argocd.applicationName $PARAMS_YAML)
export ARGOCD_CLUSTER=$(yq e .petclinic.argocd.cluster $PARAMS_YAML)
export ARGOCD_PATH=$(yq e .petclinic.argocd.path $PARAMS_YAML)
```

## Prepare spring-petclinic-config repo for ArgoCD
In the command locate the `spring-petclinic-config` directory and set up folders:
```bash
cd $PETCLINIC_CONFIG_LOCAL
mkdir -p argocd/cd
mkdir -p argocd/tmp
cp argocd/values.yaml argocd/tmp/values.yaml
```

Set the values.yaml file with the env variables configuration.
```bash
yq e -i '.petclinic.host = env(PETCLINIC_HOST)' argocd/tmp/values.yaml
yq e -i '.petclinic.image = env(PETCLINIC_IMAGE)' argocd/tmp/values.yaml
yq e -i '.petclinic.wavefront.applicationName = env(WAVEFRONT_APP_NAME)' argocd/tmp/values.yaml
yq e -i '.petclinic.wavefront.uri = env(WAVEFRONT_URI)' argocd/tmp/values.yaml
yq e -i '.petclinic.wavefront.apiToken = env(WAVEFRONT_APITOKEN)' argocd/tmp/values.yaml
# Add back the document seperator that yq removes
sed -i -e '2i\
---\
' argocd/tmp/values.yaml
rm -f argocd/tmp/values.yaml-e
```

Prepare Petclinic App yaml for ArgoCD to manage, and push to repository
```bash
ytt -f argocd/tmp/values.yaml -f argocd/petclinic-app.yaml --ignore-unknown-comments > argocd/cd/petclinic-app.yaml
git add argocd/cd/petclinic-app.yaml
git commit -m "petclinic argocd custom config"
git push origin master
```

Prepare Wavefront Secret to apply directly to your Workload cluster.
> NOTE: Ensure you have switched your local kube context to your workload cluster

```bash
ytt -f argocd/tmp/values.yaml -f argocd/to-secret.yaml --ignore-unknown-comments > argocd/tmp/to-secret.yaml
kubectl apply -f argocd/tmp/to-secret.yaml
```

## Create ArgoCD application
Make sure you `argocd login` to refresh your token. Run the following commands to create the ArgoCD application. We won't set it to sync yet since the images might not be ready. A separate lab will patch this app in order to start syncing when the time is right:
```bash
argocd app create ${ARGOCD_APPLICATION} \
  --repo ${PETCLINIC_CONFIGREPO} \
  --path ${ARGOCD_PATH} \
  --dest-server ${ARGOCD_CLUSTER} \
  --sync-policy none
```

## Check App in ArgoCD

Confirm the application has been registered in ArgoCD and auto-sync is not enabled yet. Run:
```bash
argocd app get ${ARGOCD_APPLICATION}
```
Response should look like this:
```bash
Name:               petclinic
Project:            default
Server:             https://192.168.14.182:6443
Namespace:
URL:                https://argocd.example.com/applications/petclinic
Repo:               https://github.com/jaimegag/spring-petclinic-config
Target:
Path:               argocd/cd
SyncWindow:         Sync Allowed
Sync Policy:        <none>
Sync Status:        OutOfSync from  (0cd469e)
Health Status:      Missing

GROUP       KIND        NAMESPACE  NAME              STATUS     HEALTH   HOOK  MESSAGE
            Service     petclinic  spring-petclinic  OutOfSync  Missing
apps        Deployment  petclinic  spring-petclinic  OutOfSync  Missing
extensions  Ingress     petclinic  spring-petclinic  OutOfSync  Missing
```

To enable auto-sync run:
```bash
argocd app set ${ARGOCD_APPLICATION} --sync-policy automated
```

## Go to Next Step

[Create TO Wavefront Dashboard](09-petclinic-dashboard.md)
