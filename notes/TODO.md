P1
FIX THIS on desk!: /bin/sh: error while loading shared libraries: /lib64/libc.so.6: cannot apply additional memory protection after relocation: Permission denied

This is a known SELinux + container issue on Fedora. The fix is an SELinux boolean, not disabling SELinux:
getsebool container_use_cephfs container_manage_cgroup 2>/dev/null; echo "---" && sudo setsebool -P container_use_cephfs 0 2>/dev/null; echo "---" && sudo ausearch -m avc -ts recent 2>/dev/null | head -20
sudo semanage fcontext -a -t container_var_lib_t "/home/bchk/docker(/.*)?"
sudo restorecon -Rv /home/bchk/docker
sudo systemctl restart docker

 <!-- ╰$ sudo luarocks install --lua-version 5.4 tiktoken_core -->
