# End to End Tanzu Demo

## Setup Spring Petclinic Repository

fork spring-petclinic
git https://github.com/doddatpivotal/spring-petclinic.git

Add to spring petclinic pom.xml
```xml
<wavefront.version>2.0.1</wavefront.version>
<dependencyManagement>
  <dependencies>
    <dependency>
      <groupId>com.wavefront</groupId>
      <artifactId>wavefront-spring-boot-bom</artifactId>
      <version>${wavefront.version}</version>
      <type>pom</type>
      <scope>import</scope>
    </dependency>
  </dependencies>
</dependencyManagement>
...
<dependency>
  <groupId>com.wavefront</groupId>
  <artifactId>wavefront-spring-boot-starter</artifactId>
</dependency>
```

mvn clean package -DskipTests
cp ~/Documents/mika.jpeg src/main/resources/static/resources/images/mika.jpeg
git add .
git commit -m "Adds wavefront and mika image"
git push

## TMC: Setup Workspace and Petclinic Namespace

```bash
tmc workspace create -n dpfeffer-petclinic -d "Workspace for Spring Pet Clinic"   #TODO: Local Environment reference
tmc cluster namespace create -c dpfeffer-ironislands-vsphere -n petclinic -d "Namespace for Spring Pet Clinic" -k dpfeffer-petclinic    #TODO: Local Environment reference
```

## Install TBS And Dependencies

pivnet download-product-files --product-slug='build-service' --release-version='1.0.2' --product-file-id=773503 -d ~/Downloads
tar xvf ~/Downloads/build-service-1.0.2.tar -C /tmp
kbld relocate -f /tmp/images.lock --lock-output /tmp/images-relocated.lock --repository harbor.stormsend.tkg-vsphere-lab.winterfell.live/tbs/build-service  #TODO: Local Environment

kubectl config use-context stormsend-admin@stormsend
ytt -f /tmp/values.yaml \
    -f /tmp/manifests/ \
    -v docker_repository="harbor.stormsend.tkg-vsphere-lab.winterfell.live/tbs/build-service" \ #TODO: Local Environment
    -v docker_username="admin" \ #TODO: Local Environment
    -v docker_password="Harbor12345" \ #TODO: Local Environment
    | kbld -f /tmp/images-relocated.lock -f- \
    | kapp deploy -a tanzu-build-service -n tanzu-kapp -f- -y

>Note: Import old dependencies that have vulnerabilities
pivnet download-product-files --product-slug='tbs-dependencies' --release-version='7' --product-file-id=765765 -d ~/Downloads
kp import -f ~/Downloads/descriptor-7.yaml 

>Note: Import new dependencies that have vulnerabilities
pivnet download-product-files --product-slug='tbs-dependencies' --release-version='100.0.22' --product-file-id=801577 -d ~/Downloads
kp import -f ~/Downloads/descriptor-100.0.22.yaml 

kp clusterbuilder list

## Setup TBS Demo Stack and Cluster Builder

```bash
# This sets up a stack with the vulnerabities from TBS dependencies v7
kp clusterstack create demo-stack  \
  --build-image harbor.stormsend.tkg-vsphere-lab.winterfell.live/tbs/build-service/build@sha256:97ea650641effa523611d715fa16549968252ba803f19b13b4e9d5821708aea6 \
  --run-image harbor.stormsend.tkg-vsphere-lab.winterfell.live/tbs/build-service/run@sha256:4084f6704cc27a7d93ebb050f5712c869072530576c473440e43c311c0c802f7

kp clusterbuilder create demo-cluster-builder \
  --tag harbor.stormsend.tkg-vsphere-lab.winterfell.live/tbs/build-service/demo-cluster-builder \
  --order tbs/demo-cluster-builder-order.yaml \
  --stack demo-stack \
  --store default

kp clusterbuilder list
```

>Note: Ensure it is true

## Setup Spring Petclinic TBS Project Namespace

kubectl create ns tbs-project-bizops
./scripts/setup-tbs-petclinic-images

## Deploy MySql

>Note Switch to workload cluster

Go into kubeapps: https://kubeapps.ironislands.tkg-vsphere-lab.winterfell.live/     #TODO: Local Environment reference
Switch context to namespace "petclinic"
Deploy the MySql app, name it as petclinic-db
use values

```yaml
db:
  name: petclinic
  password: petclinic
  user: petclinic
replication:
  enabled: false
root:
  password: petclinic
```

## Create Concourse Pipeline for Spring Petclinic

1. Setup your local variables

Create a local-config/values.yaml file like the one below

```yaml
#@data/values
---
petclinic:
  host: petclinic.ironislands.tkg-vsphere-lab.winterfell.live
  image: harbor.stormsend.tkg-vsphere-lab.winterfell.live/bizops/spring-petclinic:latest
  wavefront:
    applicationName: dpfeffer-petclinic
    uri: https://surf.wavefront.com
    apiToken: REDACTED
commonSecrets:
  harborDomain: harbor.stormsend.tkg-vsphere-lab.winterfell.live
  harborUser: admin
  harborPassword: REDACTED
  harborProject: bizops
  tbsProject: tbs-project-bizops 
  kubeconfigBuildServer: REDACTED_MINIFIED_JSON_OF_KUBECONFIG
  kubeconfigAppServer: REDACTED_MINIFIED_JSON_OF_KUBECONFIG
petclinicSecrets:
  host: petclinic.ironislands.tkg-vsphere-lab.winterfell.live
  image: petclinic.ironislands.tkg-vsphere-lab.winterfell.live
  wavefrontApplicationName: dpfeffer-petclinic
  wavefrontUri: https://surf.wavefront.com
  wavefrontApiToken: REDACTED
  configRepo: https://github.com/doddatpivotal/spring-petclinic-config.git
  codeRepo: https://github.com/doddatpivotal/spring-petclinic.git
```

>Note: for your minified kubeconfig you can pop your current kubeconfig into https://www.convertjson.com/yaml-to-json.htm to convert to minified json

2. Login to concourse, setup pipeline secrets, and create pipeline

```bash
fly -t stormsend login -c https://concourse.stormsend.tkg-vsphere-lab.winterfell.live -n main -u test -p test #TODO: Local Environment reference
./scripts/set-pipeline.sh
```

## Trigger a new build of Spring Petclinic by updating the Stack associated with its builder

```bash
# This sets the stack to use the patched images from TBS dependencies v100.0.22
kp clusterstack update demo-stack \
  --build-image harbor.stormsend.tkg-vsphere-lab.winterfell.live/tbs/build-service/build@sha256:ee37e655a4f39e2e6ffa123306db0221386032d3e6e51aac809823125b0a400e \
  --run-image harbor.stormsend.tkg-vsphere-lab.winterfell.live/tbs/build-service/run@sha256:51cebe0dd77a1b09934c4ce407fb07e3fc6f863da99cdd227123d7bfc7411efa
```

## One-off Activity

### Deploy Petclinic Manually

ytt -f k8s --ignore-unknown-comments | kapp deploy -n petclinic -a petclinic -y -f -

### Reset Demo Stack For use Later in a demo

kp clusterstack update demo-stack  \
  --build-image harbor.stormsend.tkg-vsphere-lab.winterfell.live/tbs/build-service/build@sha256:97ea650641effa523611d715fa16549968252ba803f19b13b4e9d5821708aea6 \
  --run-image harbor.stormsend.tkg-vsphere-lab.winterfell.live/tbs/build-service/run@sha256:4084f6704cc27a7d93ebb050f5712c869072530576c473440e43c311c0c802f7

### Manually setup Spring Petclinic Image without CI/CD

kubectl create ns tbs-project-bizops

kp secret create harbor-creds \
  --registry harbor.stormsend.tkg-vsphere-lab.winterfell.live \
  --registry-user admin \
  --namespace tbs-project-bizops

>Note: Enter Harbor12345 when prompted

kp image list --namespace tbs-project-bizops

kp image create spring-petclinic \
  --tag harbor.stormsend.tkg-vsphere-lab.winterfell.live/bizops/spring-petclinic:latest \
  --cluster-builder demo-cluster-builder \
  --namespace tbs-project-bizops \
  --git https://github.com/doddatpivotal/spring-petclinic.git \
  --git-revision main \
  --wait


### Teardown

Using TMC
  Delete workspace "bizops"
    Should delete "petclinic
  Delete workspace "bizops"

Concourse
  Delete pipeline
  Delete pipeline's secrets
  Look for pvc's to delete

TBS
  Delete tbs-project-bizops namespace  
  Look for pvc's to delete