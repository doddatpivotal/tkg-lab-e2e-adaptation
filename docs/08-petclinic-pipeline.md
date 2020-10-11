# Create Concourse Pipeline for Spring Pet Clinic

The Spring Pet Clinic CI/CD pipeline in concourse heavily relies on environment-specific data.  

1. Ensure you PARAMS_YAML environment value from step 01 is set.

2. Login to concourse, setup pipeline secrets, and create pipeline

```bash
fly -t $(yq r $PARAMS_YAML commonSecrets.concourseAlias) login \
  -c $(yq r $PARAMS_YAML commonSecrets.concourseUri) \
  -n main \
  -u $(yq r $PARAMS_YAML commonSecrets.concourseUser) \
  -p $(yq r $PARAMS_YAML commonSecrets.concoursePassword)
./scripts/set-pipeline.sh
```

3. Checkout the Pipeline

```bash
open https://$(yq r $PARAMS_YAML commonSecrets.concourseUri)
```

4. Unpause the pipeline

5. Trigger the CI Pipeline

6. Validate that the image was created in Harbor

7. Validate that the CD Pipeline was triggered and runs successfully

8. Access the Spring Pet Clinic App and Click Around

```bash
open https://$(yq r $PARAMS_YAML petclinic.host)
```

## Go to Next Step

[Create TO Wavefront Dashboard](09-petclinic-dashboard.md)