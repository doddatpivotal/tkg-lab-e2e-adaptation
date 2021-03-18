# Deploy Spring Pet Clinic MySql Database

1. Access Kubeapps on Workload Cluster

2. Switch the context to the namespace "petclinic"

3. Click Catalog and Search for MySql and then click MySql

4. Deploy MySql and name it `petclinic-db`

Use values

```yaml
auth:
  database: petclinic
  password: petclinic
  username: petclinic
  rootPassword: petclinic
```

5. Wait for App to be ready

![Pet Clinic MySql DB](petclinic-db.png)

## [Alternate Method] Install directly using helm

```bash
helm repo add tac https://charts.trials.tac.bitnami.com/demo
helm install petclinic-db tac/mysql -n petclinic --set auth.database=petclinic,auth.password=petclinic,auth.username=petclinic,auth.rootPassword=petclinic
```

## Go to Next Step

[Setup Spring Pet Clinic code and config repositories](07-petclinic-repos.md)