# Setup Environment Specific Params Yaml

Setup a local params file containing all the environment specific values for the e2e demo.  This is distinct from the params file you used for the `tkg-lab`.  Below is a redacted version of the file I used and I placed it in `/local-config/values.yaml` which is referenced in the `.gitignore`.

```yaml
#@data/values
---
cd: argocd # choose concourse or argocd for Continuous Delivery
petclinic:
  host: petclinic.ironislands.tkg-vsphere-lab.winterfell.live # Ingress host for your app
  image: harbor.stormsend.tkg-vsphere-lab.winterfell.live/petclinic/spring-petclinic # image, includes your harbor domain and project
  configRepo: https://github.com/doddatpivotal/spring-petclinic-config.git # your k8s config repo, you could just use mine
  codeRepo: https://github.com/doddatpivotal/spring-petclinic.git # your source code repo
  configRepoLocalPath: /Users/jaguilar/Code/spring-petclinic-config # the location of your code repo cloned locally
  wavefront:
    applicationName: YOUR_PREFIX-petclinic # application name, which appears in Tanzu Observability Application Status dashboard. I used dpfeffer-petclinic
    uri: https://surf.wavefront.com # Your Tanzu Observability URI
    apiToken: REDACTED # Your Tanzu Observability Api Token
    deployEventName: YOUR_EVENT_NAME # Mine is dpfeffer-spring-petclinic-deploy, we don't want to conflict here
  tmc:
    workload-cluster: YOUR_WORKLOAD_CLUSTER_NAME_IN_TMC # Mine is dpfeffer-ironislands-vsphere
    shared-services-cluster: YOUR_SHARED_SERVICES_CLUSTER_NAME_IN_TMC # Mine is dpfeffer-stormsend-vsphere
    workspace: YOUR_WORKSPACE_NAME_IN_TMC # Mine is dpfeffer-petclinic
  tbs:
    namespace: tbs-project-petclinic
  argocd:
    applicationName: petclinic # application name, which appears in the ArgoCD dashboard
    server: https://192.168.14.182:6443 # server ArgoCD targets to deploy the application
    path: argocd/cd # path that ArgoCD will sync in the config repo
tbs:
  harborRepository: harbor.stormsend.tkg-vsphere-lab.winterfell.live/tbs/build-service  # where you want tbs images to be placed
commonSecrets:
  harborDomain: harbor.stormsend.tkg-vsphere-lab.winterfell.live
  harborUser: REDACTED # Recommend creating a robot account in the harbor project you are pushing petclinic images too
  harborPassword: REDACTED
```

## Export Location of Params YAML

```bash
# You can change the location to where you stored your file
export PARAMS_YAML=local-config/values.yaml
```

## Go to Next Step

[Install TBS](02-tbs-base-install.md)
