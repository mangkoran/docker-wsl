#!/usr/bin/env fish

# Launcher for dockerd on WSL 2

# Copyright 2021 Jonathan Bowman. All documentation and code contained
# in this file may be freely shared in compliance with the
# Apache License, Version 2.0 (http://www.apache.org/licenses/LICENSE-2.0)
# and is provided "AS IS" without warranties or conditions of any kind.
#
# To use this script, first ask yourself if I can be trusted, then read the code
# below and make sure you feel good about it, then consider downloading and
# executing this code that comes with no warranties or claims of suitability.
#
# You might name this script "docker-service" and place it in "$HOME/bin".
#
# This script should be called with a single argument: the name of the WSL
# distribution with dockerd. To find a list of WSL distros, launch Powershell then
#
# wsl -l -q
#
# A usage example:
#
# $HOME/bin/docker-service Ubuntu
#
# If no distribution is specified, the default one will be used.
# This script can also be sourced from your shell initialization script, such
# as .bashrc or .profile, with something like (assuming distro is "Ubuntu":
#
# . $HOME/bin/docker-service Ubuntu
#
# Or called from Windows with
#
# wsl -d Ubuntu ~/bin/docker-service Ubuntu

[ -z "$argv" ] && set -x DOCKER_DISTRO "$WSL_DISTRO_NAME" || set -x DOCKER_DISTRO "$argv"
# If embedding this in .bashrc, .profile, .zshenv, or the like, remove the above line
# and set $DOCKER_DISTRO to an empty string or something like this:
# DOCKER_DISTRO="-d Ubuntu"
set -x DOCKER_DIR /mnt/wsl/docker
set -x DOCKER_SOCK "$DOCKER_DIR/docker.sock"
set -x DOCKER_HOST "unix://$DOCKER_SOCK"
if [ ! -S "$DOCKER_SOCK" ]
    command mkdir -pm o=,ug=rwx "$DOCKER_DIR"
    command chgrp docker "$DOCKER_DIR"
    command nohup sudo -b dockerd < /dev/null > $DOCKER_DIR/dockerd.log 2>&1
end
