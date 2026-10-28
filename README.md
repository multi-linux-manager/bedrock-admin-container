This repository is used to maintain a simple container with all that's required to use `bedrock-admin`, from https://github.com/SUSE/bedrock-toolkit

Using podman, you just need to pull the image, then run it with a couple of volumes (one for the AWS login info, one to bind a folder with the bedrock.yaml file(s)

```bash
IMAGE=ghcr.io/multi-linux-manager/bedrock-admin-container:latest
podman pull ${IMAGE}
podman run --userns=keep-id -ti --rm -v bedrock-admin-data:/home/bedrock/.aws \
       -v <PATH_TO_DIR_WITH_YAML>:/home/bedrock/bedrock-configs:Z ${IMAGE}
```

For convenience, you can also use the script `bedrock-admin` from this repository.
```bash
./bedrock-admin -h
```
