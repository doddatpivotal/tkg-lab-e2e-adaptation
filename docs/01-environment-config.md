# Setup Environment Specific Params Yaml

Setup a local params file containing all the environment specific values for the e2e demo.  This is distinct from the params file you used for the `tkg-lab`.  Below is a redacted version of the file I used and I placed it in `/local-config/values.yaml` which is referenced in the `.gitignore`.

>Note: For the kubeconfig reference below, I setup my context, then took the config yaml to this site to convert to JSON and minify it.  [https://www.convertjson.com/yaml-to-json.htm](https://www.convertjson.com/yaml-to-json.htm)

```yaml
#@data/values
---
petclinic:
  host: petclinic.ironislands.tkg-vsphere-lab.winterfell.live # Ingress host for your app
  image: harbor.stormsend.tkg-vsphere-lab.winterfell.live/petclinic/spring-petclinic # image, includes your harbor domain and project
  configRepo: https://github.com/doddatpivotal/spring-petclinic-config.git # your source code repo
  codeRepo: https://github.com/doddatpivotal/spring-petclinic.git # your k8s config repo, you could just use mine
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
  harborUser: REDACTED 
  harborPassword: REDACTED
  kubeconfigBuildServer: REDACTED # This should be minified json version of your kubeconfig with context set to the cluster where you Tanzu Build Server is deployed.  That should be the shared services cluster.
  kubeconfigAppServer: REDACTED # This should be minified json version of your kubeconfig with context set to the cluster where you Pet Clinic is deployed.  That should be the workload cluster.
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

## Go to Next Step

[Create new Shared Services Cluster](02-tbs-base-install.md)