# Day 2 Ops 

# Setup (modify appropriately)
export SCALE_CLUSTER_IP=10.213.92.145
export UPGRADE_CLUSTER_IP=10.213.92.150
export TEMP_CLUSTER_IP=10.213.92.140

tkg create cluster scale-cluster -p dev --vsphere-controlplane-endpoint $SCALE_CLUSTER_IP
tkg create cluster upgrade-cluster -p dev --vsphere-controlplane-endpoint $UPGRADE_CLUSTER_IP --kubernetes-version v1.19.1+vmware.2

# List clusters
tkg get clusters

# create a cluster
tkg create cluster temp-cluster -p dev --vsphere-controlplane-endpoint $TEMP_CLUSTER_IP

# Scale a cluster
tkg scale cluster scale-cluster -w 2

# TKG Versions
tkg get kubernetesversions

# Upgrade a cluster
tkg upgrade cluster upgrade-cluster --kubernetes-version v1.19.3+vmware.1

# Create new Management Cluster
tkg init --config ~/temp/config.yaml --ui

# Demo UI wizard but don't provision.  Use values from your .secrets file
AZURE_TENANT_ID: <GUID/>
AZURE_CLIENT_ID: <GUID/>
AZURE_CLIENT_SECRET: <GUID/>
AZURE_SUBSCRIPTION_ID: <GUID/>
AZURE_NODE_MACHINE_TYPE: Standard_D2s_v3
SSH_KEY: |-
    ssh-rsa foo-keu == email@testmail.com

# Review Cluster API Components

kubectl get clusters
kubectl describe cluster upgrade-cluster
kubectl describe vspherecluster upgrade-cluster
kubectl get machines
export SOME_MACHINE=$(kubectl get machine | grep upgrade-cluster-md | tail -1 | awk '{print $(1)}')
kubectl describe machine $SOME_MACHINE
export SOME_VSPHERE_MACHINE=$(kubectl get machine $SOME_MACHINE -o json | jq '.spec.infrastructureRef.name' -r)
kubectl describe vspheremachine $SOME_VSPHERE_MACHINE

# Cleanup

tkg delete cluster upgrade-cluster -y
tkg delete cluster scale-cluster -y
tkg delete cluster temp-cluster -y