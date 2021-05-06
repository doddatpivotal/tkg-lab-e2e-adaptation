# One Off Activities

## Reset Demo Stack For use Later in a demo

```bash
export TBS_REPOSITORY=$(yq e .tbs.harborRepository $PARAMS_YAML)

# make it match with 100.0.81
kp clusterstack update demo-stack  \
  --build-image $TBS_REPOSITORY/build@sha256:e2371eb5092beeb8eada41259e3b070ab2a0037218a28105c0fea590b3b57cb5 \
  --run-image $TBS_REPOSITORY/run@sha256:8c61edbd83d1741b4a50478314bfcb6aea7defa65205fe56044db4ed34874155
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