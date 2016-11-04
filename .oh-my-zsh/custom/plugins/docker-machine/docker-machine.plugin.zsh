alias dm="docker-machine"
alias dm-dns="docker-machine-dns -server-only -port 10054"

# Custom virtualbox docker machine with :
#   - full usage of available CPUs
#   - nfs share (mainly extracted from https://github.com/adlogix/docker-machine-nfs/blob/master/docker-machine-nfs.sh)
#   - dummy ssh-auth-sock container at bootup to allow agent forwarding (see docker-ssh-fwd())
dm-create-custom() {
    local machine=${1-dev}
    local create_cmd="docker-machine create -d virtualbox --virtualbox-cpu-count "-1" --virtualbox-no-share --virtualbox-memory "512" $machine"
    echo $create_cmd && eval "$create_cmd"

    echo "Adding NFS export in /etc/exports, password prompt might show up..."
    local nfs_export="/Users $machine.docker -mapall=$(id -u):$(id -g)"
    grep -q -F "$nfs_export" /etc/exports || echo "$nfs_export" | sudo tee -a /etc/exports >/dev/null

    echo "Restarting nfsd..."
    sudo nfsd restart

    echo "Adding boot script to the VM..."
    local network_id=$(VBoxManage showvminfo dev --machinereadable | grep hostonlyadapter | cut -d'"' -f2)
    local host_ip=$(VBoxManage list hostonlyifs | grep "^Name:\s*${network_id}$" -A 3 | grep "^IPAddress:" | cut -d':' -f2 | xargs)
    local bootlocalsh="#!/bin/sh
sudo mkdir -p /Users
sudo /usr/local/etc/init.d/nfs-client start
sudo mount -t nfs -o noacl,async $host_ip:/Users /Users
docker run --name ssh-auth-sock tianon/true"
    local bootlocalpath='/var/lib/boot2docker/bootlocal.sh'
    docker-machine ssh $machine "echo '$bootlocalsh' | sudo tee $bootlocalpath && sudo chmod +x $bootlocalpath && sh $bootlocalpath" >/dev/null

    dm-env $machine
}

# Shortcut function to set environment variables for a given docker machine
# Usage : dm-env [machine_name] (defaults to dev)
dm-env() {
    local machine=${1-dev}
    echo "Setting up the environment for the \"$machine\" machine..."
    eval "$(docker-machine env ${machine} </dev/null)"
}

# Helper to SSH into the same docker machine directory than the current one
# Mainly useful in development 
dm-ssh() {
    local machine=${1-dev}
    echo "SSHing into \"$PWD\" from \"$machine\" machine..."
    docker-machine ssh $machine -At "cd $PWD; sh"
}
