# My Devcontainers

### Useful commands

`devcontainer read-configuration --workspace-folder $PWD --include-merged-configuration | jq`

`gpg --export --armor E78A0D774F0BDAC50F897DC5FF99608021A353C0 > ~/.gnupg/devcon-public.asc`


## Base image 

Builds are reproducible against that exact base due to the sha used.

```dockerfile
FROM ubuntu:26.04@sha256:53958ec7b67c2c9355df922dd08dbf0360611f8c3cdb656875e81873db9ffdba
```

To update the image digest, run `docker buildx imagetools inspect ubuntu:<tag>` to see latest sha on the tag and then update the sha.
