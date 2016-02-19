alias dm="docker-machine"

dm-create-custom() {
    # creates a local machine using vbox driver with nfs share
    # extracted from https://github.com/adlogix/docker-machine-nfs/blob/master/docker-machine-nfs.sh

    local machine=${1-dev}
    local create_cmd="docker-machine create -d virtualbox --virtualbox-cpu-count "-1" --virtualbox-no-share $machine"
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

dm-env() {
    local machine=${1-dev}
    echo "Setting up the environment for the \"$machine\" machine..."
    eval "$(docker-machine env ${machine} </dev/null)"
}

dm-env >/dev/null 2>&1
