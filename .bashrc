# aliases
alias ll='ls -Al'

# docker
docker-machine-create-vbox-nfs() {
    # creates a local machine using vbox driver with nfs share
    # extracted from https://github.com/adlogix/docker-machine-nfs/blob/master/docker-machine-nfs.sh

    local machine=${1-dev}
    local create_cmd="docker-machine create -d virtualbox --virtualbox-cpu-count \"-1\" --virtualbox-no-share $machine"
    echo $create_cmd && eval "$create_cmd"

    echo "Adding NFS export in /etc/exports, root password might be needed..."
    local guest_ip=$(docker-machine ip $machine)
    local nfs_export="/Users $guest_ip -mapall=$(id -u):$(id -g)"
    grep -q -F "$nfs_export" /etc/exports || echo "$nfs_export" | sudo tee -a /etc/exports >/dev/null

    echo "Restarting nfsd..."
    sudo nfsd restart

    local network_id=$(VBoxManage showvminfo dev --machinereadable | grep hostonlyadapter | cut -d'"' -f2)
    local host_ip=$(VBoxManage list hostonlyifs | grep "^Name:\s*${network_id}$" -A 3 | grep "^IPAddress:" | cut -d':' -f2 | xargs)
    local bootlocalsh="#!/bin/sh
sudo mkdir -p /Users
sudo /usr/local/etc/init.d/nfs-client start
sudo mount -t nfs -o noacl,async '$host_ip':/Users /Users"
    local bootlocalpath='/var/lib/boot2docker/bootlocal.sh'
    docker-machine ssh $machine "echo '$bootlocalsh' | sudo tee $bootlocalpath && sudo chmod +x $bootlocalpath" >/dev/null

    echo "Restarting the VM..."
    docker-machine restart $machine && docker-env $machine
}
docker-env() {
    local machine=${1-dev}
    echo "Setting up the environment for the \"$machine\" machine..."
    eval "$(docker-machine env ${machine})"
}
docker-clean() {
    if [ "$1" == "-f" ]; then
        local ids=$(docker ps -q)
        if [ -d "$ids" ]; then
            echo "Stopping running containers..."
            docker stop $ids
        fi
    fi
    local ids=$(docker ps -a -q)
    [ -z "$ids" ] && return
    echo "Removing inactive containers..."
    docker rm $ids
}

# machine specific
if [ -f ~/.bashrc_pre ]; then
   . ~/.bashrc_pre
fi

# mac osx autocomplete
if [[ "$OSTYPE" == "darwin"* ]] && type brew >/dev/null 2>&1; then
    _brew_prefix=$(brew --prefix)
    if [ -f "$_brew_prefix"/etc/bash_completion ]; then
        . "$_brew_prefix"/etc/bash_completion
    fi
    unset _brew_prefix
fi

# composer global vendor binaries
if [ -d ~/.composer/vendor/bin ]; then
    PATH=$PATH:~/.composer/vendor/bin
fi

# go
if [ -n "$GOPATH" ]; then
    PATH=$PATH:$GOPATH/bin
fi

# direnv hook
if type direnv >/dev/null 2>&1; then
    eval "$(direnv hook bash)"
fi
