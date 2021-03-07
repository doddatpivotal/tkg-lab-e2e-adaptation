# One Off Activities

## Reset Demo Stack For use Later in a demo

```bash
export TBS_REPOSITORY=$(yq e .tbs.harborRepository $PARAMS_YAML)

kp clusterstack update demo-stack  \
  --build-image $TBS_REPOSITORY/build@sha256:97ea650641effa523611d715fa16549968252ba803f19b13b4e9d5821708aea6 \
  --run-image $TBS_REPOSITORY/run@sha256:4084f6704cc27a7d93ebb050f5712c869072530576c473440e43c311c0c802f7
```

## Teardown Pet Clinic

- Within TMC
  - delete petclinic namespace within petclinic workspace
  - delete tbs-project-petclinic namespace within petclinic workspace
  - delete the petclinic workspace
- Within Harbor
  - delete project: petclinic
- Within Tanzu Observability
  - delete custom dashboard for petclinic application
- For Concorse, delete pipeline and secrets

```bash
kapp delete -a concourse-main-secrets -n concourse-main
fly -t $TARGET destroy-pipeline -p petclinic
```

## Teardown TBS

```bash
kapp delete -a tanzu-build-service -n tanzu-kapp
```

Delete Harbor project: tbs