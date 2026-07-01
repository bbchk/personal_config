FROM ubuntu:26.04@sha256:53958ec7b67c2c9355df922dd08dbf0360611f8c3cdb656875e81873db9ffdba

# Ubuntu 24.04+ ships a built-in "ubuntu" user at uid/gid 1000, which collides
# with the host user that owns the bind-mounted ~/pers. Remove it so the
# common-utils feature can create "bchk" at uid/gid 1000 and match the host
# (see remoteUser + updateRemoteUserUID in the definitions). Without this, bchk
# lands on uid 1001 and compaudit still flags the mounted completion dirs.
RUN userdel -r ubuntu 2>/dev/null || true; \
    groupdel ubuntu 2>/dev/null || true
