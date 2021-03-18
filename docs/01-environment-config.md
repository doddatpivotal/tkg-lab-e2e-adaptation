# Setup Environment Specific Params Yaml

Setup a local params file containing all the environment specific values for the e2e demo.  This is distinct from the params file you used for the `tkg-lab`.  Below is a redacted version of the file I used and I placed it in `/local-config/values.yaml` which is referenced in the `.gitignore`.

>Note: for the kubeconfig references below, I used the following approach to get single line json...

```bash
# Set your context to the build server context, then...
kubectl config view --flatten --minify | yq e - --tojson | jq -c .
# Set your context to the app server context, then...
kubectl config view --flatten --minify | yq e - --tojson | jq -c .
```

```yaml
#@data/values
---
petclinic:
  host: petclinic.ironislands.tkg-vsphere-lab.winterfell.live # Ingress host for your app
  image: harbor.stormsend.tkg-vsphere-lab.winterfell.live/petclinic/spring-petclinic # image, includes your harbor domain and project
  configRepo: https://github.com/doddatpivotal/spring-petclinic-config.git # your k8s config repo, you could just use mine
  codeRepo: https://github.com/doddatpivotal/spring-petclinic.git # your source code repo
  wavefront:
    applicationName: YOUR_PREFIX-petclinic # application name, which appears in Tanzu Observability Application Status dashboard. I used dpfeffer-petclinic
    uri: https://surf.wavefront.com # Your Tanzu Observability URI
    apiToken: REDACTED # Your Tanzu Obsevability Api Token
    deployEventName: YOUR_EVENT_NAME # Mine is dpfeffer-spring-petclinic-deploy, we don't want to conflict here
  tmc:
    workload-cluster: YOUR_WORKLOAD_CLUSTER_NAME_IN_TMC # Mine is dpfeffer-ironislands-vsphere
    shared-services-cluster: YOUR_SHARED_SERVICES_CLUSTER_NAME_IN_TMC # Mine is dpfeffer-stormsend-vsphere
    workspace: YOUR_WORKSPACE_NAME_IN_TMC # Mine is dpfeffer-petclinic
  tbs:
    namespace: tbs-project-petclinic
tbs:
  harborRepository: harbor.stormsend.tkg-vsphere-lab.winterfell.live/tbs/build-service  # where you want tbs images to be placed  
commonSecrets:
  harborDomain: harbor.stormsend.tkg-vsphere-lab.winterfell.live
  harborUser: REDACTED # Recommend creating a robot account in the harbor project you are pushing petclinic images too
  harborPassword: REDACTED
  kubeconfigBuildServer: 'REDACTED' # This should be minified json version of your kubeconfig with context set to the cluster where you Tanzu Build Server is deployed.  That should be the shared services cluster.
  kubeconfigAppServer: 'REDACTED' # This should be minified json version of your kubeconfig with context set to the cluster where you Pet Clinic is deployed.  That should be the workload cluster.
  concourseHelperImage: harbor.stormsend.tkg-vsphere-lab.winterfell.live/concourse/concourse-helper # Your concourse helper image, explained in 08-petclinic-peipline.md
  concourseAlias: stormsend # Your concourse alias
  concourseUri: https://concourse.stormsend.tkg-vsphere-lab.winterfell.live # Your concourse URI
  concourseUser: REDACTED
  concoursePassword: REDACTED  
```

## Export Location of Params YAML

```bash
# You can change the location to where you stored your file
export PARAMS_YAML=local-config/values.yaml
```

## [Optional] Automate population of the kubeconfig in your params.yaml

```bash
# Set your context to the build server context, then...
export CONFIG=$(kubectl config view --flatten --minify | yq e - --tojson | jq -c .)
yq e -i '.commonSecrets.kubeconfigBuildServer = strenv(CONFIG)' $PARAMS_YAML

# Change your context to the app server and repeat
export CONFIG=$(kubectl config view --flatten --minify | yq e - --tojson | jq -c .)
yq e -i '.commonSecrets.kubeconfigAppServer = strenv(CONFIG)' $PARAMS_YAML

# Add back the document seperator that yq removes
sed -i -e '2i\
---
' "$PARAMS_YAML"
rm -f "$PARAMS_YAML-e"

# Clear out the neviornment variable
unset CONFIG
```

## Go to Next Step

[Install TBS](02-tbs-base-install.md)
