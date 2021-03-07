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
fly -t $(yq e .commonSecrets.concourseAlias $PARAMS_YAML) login \
  -c $(yq e .commonSecrets.concourseUri $PARAMS_YAML) \
  -n main \
  -u $(yq e .commonSecrets.concourseUser $PARAMS_YAML) \
  -p $(yq e .commonSecrets.concoursePassword $PARAMS_YAML)
./scripts/set-pipeline.sh
```

3. Checkout the Pipeline

```bash
open $(yq e .commonSecrets.concourseUri $PARAMS_YAML)
```
And then login

4. Unpause the pipeline

5. Notice the `continuous-integration` job is automatically triggered

6. Validate that the image was created in Harbor

7. Validate that the CD Pipeline was triggered and runs successfully

8. Access the Spring Pet Clinic App and Click Around

```bash
open https://$(yq e .petclinic.host $PARAMS_YAML)
```

## Go to Next Step

[Create TO Wavefront Dashboard](09-petclinic-dashboard.md)
