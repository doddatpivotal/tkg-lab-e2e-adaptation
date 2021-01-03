# Create Concourse Pipeline for Spring Pet Clinic

## Build Concourse Helper Image and Push to Harbor

I've created a concourse helper image, which is used within the concourse pipeline, with the the following utilities:

- kapp
- ytt
- kubectl
- kp

You can do the same and push the image to your local harbor repository.

1. Create project in Harbor for the image.  I named mine `concourse` and set it to public access

2. Clone or fork my repository [https://github.com/doddatpivotal/concourse-helper](https://github.com/doddatpivotal/concourse-helper)

Follow instructions in the [readme](https://github.com/doddatpivotal/concourse-helper/blob/master/Readme.md) to build the image and push to your local repository.

## Create Pipeline

The Spring Pet Clinic CI/CD pipeline in concourse heavily relies on environment-specific data.  

1. Ensure you PARAMS_YAML environment value from step 01 is set.

2. Ensure you have switched your local kube context to your shared services cluster

3. Login to concourse, setup pipeline secrets, and create pipeline

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
open $(yq r $PARAMS_YAML commonSecrets.concourseUri)
```
And then login

4. Unpause the pipeline

5. Notice the `continuous-integration` job is automatically triggered

6. Validate that the image was created in Harbor

7. Validate that the CD Pipeline was triggered and runs successfully

8. Access the Spring Pet Clinic App and Click Around

```bash
open https://$(yq r $PARAMS_YAML petclinic.host)
```

## Go to Next Step

[Create TO Wavefront Dashboard](09-petclinic-dashboard.md)
