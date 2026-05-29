P1
support and highlighting of C++ and C in neovim
 consider using -sb by default in git status = ╰$ git status -sb                                           

figure out how we can use copilot.nvim
figure out how we should use debugger in nvim 


p2
 ╰$ sudo semanage fcontext -a -t container_ro_file_t "/home/bchk/docker/overlay2(/.*)?"
sudo restorecon -Rv /home/bchk/docker/overlay2
sudo systemctl restart docker

sudo chcon -R -t container_file_t -l s0 /home/bchk/dev/ib/demoservice

sudo semanage fcontext -d "/home/bchk/dev(/.*)?" 2>/dev/null
sudo semanage fcontext -a -t container_file_t "/home/bchk/dev(/.*)?"

 ╰$ sudo semanage fcontext -l | grep /home/bchk/dev

research
-l s0 — sets the SELinux level (MCS/MLS range) to s0 with no categories. This is the key part:

p3
 ╰$ ls -la ~/.gnupg/public-keys.d/                                           
