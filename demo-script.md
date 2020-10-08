Make code update, commit and push
> Check out the pipeline doing the unit test and trigger image update
> Check out harbor
> Check out the pipeline doing the update to config repo and wavefront event
> Check out the updated app
> Check out the observability app dashboard and event

Couple things to point out, how did I get mysql database
> Check out kubeapps


## Operator Perspective

### Create Cluster Policies
> Setup Security Policy (type strict, warning only, apply to label acme.io/policy/security-default)
> Setup Quota Policy (warning only, apply to label acme.io/policy/quota-default)

## Create BizOps Workspace
> TMC
  > Creating a workspace (bizops)
  > Set Access Policy edit access to the bizops workspace to the bizops-devs group
  > Set Image registry policy on the bizops workspace (will break TAC)
> Harbor
  > Create a harbor project for the bizops LOB
  > Create a robot account for bizops project
> TBS
  > Create a build namespace (build-service-bizops)
  > Create a registry secret for (build-service-bizops)
> Concourse
  > Create a team

## Create Petclinc Space for BizOps Workspace
> Create a petclinic namespace (label it acme.io/policy/quota-default, cme.io/policy/security-default)
> Nightly backup for the petclinic namespace

## As an Operator
- What I've Done
  - Integrated with corporate membership directory
  - Enabled easy routable apps with wild card dns
  - Provide secure access with wild card ssl
  - Setup a workspace with access and image registry policy
  - Added a petclinic namespace
  - Added nightly backup for petclinic
- What I will do now
  - Have a look at the cluster
  - Create a new namespace for petadoptions
  - Add nightly backup for petadoptions namespace
  - Check on the health of the cluster
