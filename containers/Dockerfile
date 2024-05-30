# Use Arch Linux as a parent image
FROM archlinux:latest

# Update the system and install necessary packages
RUN pacman -Syu --noconfirm && \
    pacman -S --noconfirm ansible git python-pip

# Set the working directory to /tmp
WORKDIR /tmp

# Make port 80 available to the world outside this container
EXPOSE 80

# Define environment variable
ENV NAME marge



# Use ansible-pull to apply the playbook from the remote git repository
# RUN ansible-pull -U https://github.com/bbuukk/pers.git /ansible/main.yml