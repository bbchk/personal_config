#!/usr/bin/env bash

# Remove any previous Go installation by deleting the /usr/local/go folder (if it exists), then extract the archive you just downloaded into /usr/local, creating a fresh Go tree in /usr/local/go:
rm -rf /usr/local/go && tar -C /usr/local -xzf /home/bchk/Downloads/go1.24.4.linux-amd64.tar.gz


# Add /usr/local/go/bin to the PATH environment variable.
# You can do this by adding the following line to your $HOME/.profile or /etc/profile (for a system-wide installation):
export PATH=$PATH:/usr/local/go/bin

# Verify that you've installed Go by opening a command prompt and typing the following command:
go version

curl -sSL https://git.io/g-install | sh -s

g install 1.23.4
g use 1.23.4

# Verify
go version
