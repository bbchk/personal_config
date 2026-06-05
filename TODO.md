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




Great starting point — your web/devops background is actually a huge advantage here because you already understand protocols, networking, and infrastructure concepts. You just need to implement them at a lower level.

---

## Projects That Bridge Your Background Into C++

### 🌐 Networking / Protocols
- **HTTP/1.1 server from raw sockets** — No frameworks, just `socket()`, `bind()`, `accept()`. You know HTTP well, now implement it byte by byte.
- **DNS resolver** — Write a recursive DNS resolver. You deal with DNS daily in devops but have probably never parsed a DNS packet manually.
- **RESP protocol parser** (Redis Serialization Protocol) — Implement a Redis client from scratch. The protocol is simple but teaches you binary protocol parsing.
- **WebSocket server** — Implement the upgrade handshake and framing protocol yourself. Very satisfying when a browser connects to your raw C++ server.

### 🐳 DevOps-flavored Systems
- **Mini container runtime** — Use Linux `namespaces` + `cgroups` to isolate processes. Basically a tiny Docker. Very eye-opening.
- **Process supervisor** — A mini `supervisord` that manages child processes, restarts them on failure, and streams logs.
- **Simple load balancer** — A TCP-level round-robin proxy. Connect it to two local servers and watch it work.
- **Log shipper/aggregator** — High-throughput log tail + forward over TCP. Teaches file I/O, buffering, and backpressure.

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
