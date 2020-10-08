# Create concourse-helper image

## Retrieve Dependencies

>Note: Assumes you are running this on a mac

1. Set environment variables, ensure you have a valid `.pivnetrc` file, mine is at `~/.pivnetrc`. Update your image tag appropriately

```bash
export PIVNET_CONFIG=~/.pivnetrc
export IMAGE_TAG=harbor.stormsend.tkg-vsphere-lab.winterfell.live/concourse/concourse-helper
```

2. Run script to retrieve utilities.

```bash
./retrieve-utilities.sh
```

3. Build and push image

```bash
docker build -t $IMAGE_TAG .
docker push $IMAGE_TAG
```
