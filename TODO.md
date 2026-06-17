 ╰$ sudoedit /etc/default/grub
 ╭─~ 
 ╰$ sudo grub2-mkconfig -o /boot/efi/EFI/fedora/grub.cfg
Running `grub2-mkconfig -o /boot/efi/EFI/fedora/grub.cfg' will overwrite the GRUB wrapper.
Please run `grub2-mkconfig -o /boot/grub2/grub.cfg' instead to update grub.cfg.
GRUB configuration file was not updated.
 ╭─~ 
 ╰$ sudo grub2-mkconfig -o /boot/grub2/grub.cfg                                               
Generating grub configuration file ...

sudo blkid /dev/sda2
sudo mount /dev/sda2 /mnt && ls /mnt/EFI/boot/
sudo efibootmgr --create --disk /dev/sda --part 2 --label "Ubuntu USB" --loader '\EFI\boot\bootx64.efi'
efibootmgr -v

 ╰$ sudo efibootmgr --create --disk /dev/sda --part 1 --label "Ubuntu USB" --loader '\EFI\boot\bootx64.efi'
sudo efibootmgr --delete-bootnum --bootnum XXXX   # replace XXXX with the new entry number
sudo efibootmgr --timeout 10

sudo dd if=/home/bchk/pers/xdg/Downloads/ubuntu-26.04-desktop-amd64.iso of=/dev/sdX bs=4M status=progress

 ╰$ ls -la ~/.gnupg/public-keys.d/

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

<<<<<<< HEAD

what could we write in C++ for avakgroup.online?
a program that would control how batteries perfom in utk!
a pgrogram for each tool we have


### 🌐 Networking / Protocols
- **HTTP/1.1 server from raw sockets** — No frameworks, just `socket()`, `bind()`, `accept()`. You know HTTP well, now implement it byte by byte.
- **DNS resolver** — Write a recursive DNS resolver. You deal with DNS daily in devops but have probably never parsed a DNS packet manually.
- **WebSocket server** — Implement the upgrade handshake and framing protocol yourself. Very satisfying when a browser connects to your raw C++ server.

### 🐳 DevOps-flavored Systems
- **Mini container runtime** — Use Linux `namespaces` + `cgroups` to isolate processes. Basically a tiny Docker. Very eye-opening.
- **Process supervisor** — A mini `supervisord` that manages child processes, restarts them on failure, and streams logs.

### 🗄️ Storage / Data
- **Key-value store with a WAL** — A mini Redis/LevelDB. Implement a Write-Ahead Log for durability. Very practical, teaches so much.
- **Memory-mapped file cache** — Use `mmap` to build a simple file-backed cache layer.

### 🔧 Tooling
- **A fast `grep` clone** — Implement Boyer-Moore or similar and benchmark against `grep`. Teaches SIMD-friendly thinking.
- **Prometheus metrics library** — Implement the text exposition format and a `/metrics` HTTP endpoint. You'll use this knowledge forever.
- **YAML/TOML parser** — Painful but incredibly educational for parsing, state machines, and error handling.

---

## Suggested Learning Path (for your level)

1. Start with **WebSocket server** — familiar domain, real protocol work
2. Then **key-value store** — introduces memory management, concurrency
3. Then **mini container runtime** — will blow your mind and make you a better devops engineer

---

The key is to pick something where you already understand *what* it should do, so you can focus on the *how* in C++. Your devops background is a cheat code here.




## More Networking & DevOps C++ Projects

---

### 🔌 Low-Level Networking

- **TCP/IP stack on raw sockets (using `AF_PACKET`)** — Bypass the OS TCP stack entirely, read raw Ethernet frames, parse IP/TCP headers yourself. You'll never take `curl` for granted again.
- **DHCP server** — Implement lease management, broadcast handling, and the DORA handshake. Very practical for homelabs too.
- **SOCKS5 proxy** — Surprisingly simple protocol, teaches connection tunneling and async I/O patterns.
- **BGP speaker (toy)** — Parse BGP `OPEN`/`UPDATE` messages. Even a read-only implementation teaches you how the internet actually routes traffic.
- **ICMP ping + traceroute clone** — Craft raw ICMP packets with TTL manipulation. A classic but still deeply educational.
- **NTP client** — Parse NTP packets, handle timestamp arithmetic. You configure NTP in devops all the time but have probably never touched the 48-byte packet.
- **TLS 1.3 handshake visualizer** — Don't implement crypto yourself, but use `OpenSSL` BIO to intercept and pretty-print every step of the handshake. Great for understanding what happens under `https://`.
- **QUIC connection logger** — Hook into a QUIC library (like `ngtcp2`) and log connection events. QUIC is the future and almost nobody understands its internals.
- **Virtual TUN/TAP interface** — Open `/dev/tun`, assign an IP, and route packets through your program. Foundation of how VPNs work.
- **Netflow/IPFIX collector** — Receive and parse flow records exported by routers. Very relevant in network monitoring and devops observability.

---

### 🛠️ DevOps Tooling

- **`strace` lite** — Use `ptrace` syscall to intercept and log system calls of another process. Incredibly educational about OS internals.
- **cgroup v2 stats collector** — Read CPU/memory/IO metrics directly from `/sys/fs/cgroup` and expose them as Prometheus metrics. No libraries.
- **eBPF program launcher** — Write a C++ userspace tool that loads and attaches a simple eBPF program (e.g., count syscalls per PID). Use `libbpf`. This is cutting-edge observability.
- **`htop` clone** — Parse `/proc/[pid]/stat`, `/proc/meminfo`, `/proc/net/dev`. Teaches procfs deeply, very useful for a devops engineer.
- **Minimal CI runner** — A daemon that polls a git repo for changes, clones it, runs a command in a subprocess, and reports pass/fail over HTTP. Mini GitHub Actions.
- **OCI image layer parser** — Parse a Docker image tarball (they're just JSON + tar layers). Understand exactly what `docker pull` downloads.
- **Secrets manager client** — Talk to HashiCorp Vault's HTTP API over raw sockets. Parse JWT tokens, handle lease renewal. No SDKs.
- **Config file hot-reloader** — Watch files with `inotify` (Linux) and trigger callbacks on change. The same mechanism used by nginx, Prometheus, etc.
- **Namespace-aware `ps` clone** — List processes and show which Linux namespaces they belong to (PID, net, mnt). Makes container isolation tangible.
- **TCP connection tracker** — Read from `/proc/net/tcp` and `/proc/net/tcp6`, resolve inodes to PIDs, print a `ss`/`netstat`-like table. Pure file parsing, zero libraries.

---

### 📡 Service Mesh / Distributed Systems (Advanced)

- **Gossip protocol implementation** — Implement SWIM or a simple gossip protocol for cluster membership. Foundation of how Consul and etcd work.
- **Raft consensus (toy)** — Implement leader election and log replication. Hard, but nothing teaches distributed systems better.
- **Service discovery via mDNS** — Broadcast and listen for mDNS packets on the local network. How `avahi` and Docker's internal DNS works.
- **Health check daemon** — A `systemd`-style watchdog that runs TCP/HTTP/exec checks and manages service state with exponential backoff.
- **Sidecar proxy skeleton** — Accept connections on one port, forward to another, inject headers, collect metrics. A mini Envoy. Teaches everything.

---

### 🧭 Suggested Deep-Dive Path for You

```
Week 1-2  →  TCP connection tracker (pure /proc parsing, zero friction)
Week 3-4  →  SOCKS5 proxy (async I/O, connection state machines)
Week 5-6  →  TUN/TAP virtual interface (understand VPNs for real)
Week 7-8  →  cgroup v2 stats collector (devops-native, immediately useful)
Month 3+  →  eBPF launcher OR mini container runtime
```

The `/proc` and `/sys` filesystem projects are especially good for devops engineers — you interact with that data daily through tools, but reading it raw in C++ makes everything click.


## The Most Basic Starting Projects

The goal here is **minimum viable complexity** — projects where you can get something working in a few hours and actually see results.

---

### 🔌 Networking — Start Here First

**1. Ping clone (ICMP)**
- Craft a raw ICMP echo packet, send it, read the reply
- ~100 lines of code
- Teaches: raw sockets, structs as packet headers, checksums
- You already know what `ping` does, so zero conceptual overhead

**2. TCP port scanner**
- Loop over ports, try `connect()`, report open/closed
- ~80 lines of code
- Teaches: sockets, `connect()`, timeouts with `select()`
- Basically a toy `nmap`

**3. `netstat` clone**
- Read `/proc/net/tcp`, parse the hex columns, print a table
- ~100 lines of code
- Teaches: file parsing, hex conversion, string manipulation
- No sockets at all — pure file I/O, very low friction start

**4. HTTP GET from scratch**
- Open a TCP socket, write a raw HTTP GET request string, read and print the response
- ~60 lines of code
- Teaches: sockets, the request/response cycle at byte level
- You know HTTP, so you're just translating knowledge to C++

---

### 🛠️ DevOps — Start Here First

**5. `/proc` system monitor**
- Read `/proc/meminfo`, `/proc/loadavg`, `/proc/uptime` and print a dashboard
- ~80 lines of code
- Teaches: file I/O, string parsing, basic formatting
- Zero networking, zero sockets — the gentlest possible start

**6. Process lister (`ps` clone)**
- Iterate `/proc/[pid]/status` for every numeric directory in `/proc`
- Print PID, name, memory usage
- ~100 lines of code
- Teaches: directory traversal (`opendir`), file parsing, string-to-int

**7. File change watcher**
- Use `inotify` to watch a directory and print what changed
- ~70 lines of code
- Teaches: Linux-specific syscalls, event loops, file descriptors
- Directly useful — this is how config hot-reloaders work

**8. Command runner with output capture**
- Use `fork()` + `exec()` + `pipe()` to run a shell command and capture stdout
- ~80 lines of code
- Teaches: process creation, IPC, the Unix process model
- Foundation of every CI runner, supervisor, and container runtime

---

### 🗺️ Recommended Order (Absolute Beginner to C++)

```
Step 1 → /proc system monitor       (just file reading, no syscalls)
Step 2 → Process lister             (add directory traversal)
Step 3 → HTTP GET from scratch      (introduce sockets gently)
Step 4 → TCP port scanner           (expand on sockets)
Step 5 → File change watcher        (inotify, event loop thinking)
Step 6 → Command runner             (fork/exec, processes)
Step 7 → Ping clone                 (raw sockets, your first "wow" moment)
```

---

### 💡 Tips for Each Project

| Project | Key header files to look up |
|---|---|
| /proc monitor | `<fstream>`, `<string>` |
| Process lister | `<dirent.h>`, `<fstream>` |
| HTTP GET | `<sys/socket.h>`, `<netdb.h>` |
| Port scanner | `<sys/socket.h>`, `select()` |
| File watcher | `<sys/inotify.h>` |
| Command runner | `<unistd.h>`, `fork()`, `pipe()` |
| Ping clone | `<netinet/ip_icmp.h>` |

Start with **Step 1** — you can finish it in an afternoon and it will give you enough confidence and muscle memory (compilation, headers, Makefiles) to tackle everything else.
=======
adb shell pm uninstall --user 0 com.google.android.youtube
<<<<<<< HEAD
>>>>>>> 4d4e6db (feat(todo): add one)
=======
adb shell pm uninstall --user 0 com.android.chrome
>>>>>>> 47bcf4d (feat(todo): add one)
