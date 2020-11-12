# Setup Workspace and Pet Clinic Namespaces

We want to deploy Spring Pet Clinic to your tkg-lab workload cluster.  Let's create a workspace in Tanzu Mission Control and then a namespace within the workload cluster.  Additionally, we want to create a namespace on our shared services cluster for Tanzu Build Service to create pet clinic images.

1. Set environment variables for use in the following sections

```bash
export TMC_WORKLOAD_CLUSTER=$(yq r $PARAMS_YAML petclinic.tmc.workload-cluster)
export TMC_SHARED_SERVICES_CLUSTER=$(yq r $PARAMS_YAML petclinic.tmc.shared-services-cluster)
export TMC_PETCLINIC_WORKSPACE=$(yq r $PARAMS_YAML petclinic.tmc.workspace)
```

2. Use the Tanzu Mission Control cli, `tmc`, to create a workspace and namespace for the Spring Pet Clinic app.

```bash
tmc workspace create -n $TMC_PETCLINIC_WORKSPACE -d "Workspace for Spring Pet Clinic"
tmc cluster namespace create -c $TMC_WORKLOAD_CLUSTER -n petclinic -d "Namespace for Spring Pet Clinic" -k $TMC_PETCLINIC_WORKSPACE -m attached -p attached
tmc cluster namespace create -c $TMC_SHARED_SERVICES_CLUSTER -n tbs-project-petclinic -d "Namespace for TBS to build Spring Pet Clinic images" -k $TMC_PETCLINIC_WORKSPACE -m attached -p attached
```

## Go to Next Step

[Setup Spring Pet Clinic TBS Project Namespace](05-petclinic-tbs-namespace.md)