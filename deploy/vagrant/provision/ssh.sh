#!/bin/sh
# uncomment it for debugging
#set -x

# ssh config
mkdir -p ~/.ssh
src="/vagrant/files"
mkdir -p ${src}
if [ ! -f ${src}/id_rsa ]
then
    # ensure we have ssh-keygen rpm installed
    sudo yum install -y -q openssh
    # generate key
    ssh-keygen -f ${src}/id_rsa -t rsa -N ''
    # ssh without password
    cat ${src}/id_rsa.pub |awk '{print $1, $2, "Generated by vagrant"}' >> ${src}/authorized_keys2
    cat ${src}/id_rsa.pub |awk '{print $1, $2, "Generated by vagrant"}' >> ${src}/authorized_keys
fi

files=('authorized_keys2' 'authorized_keys')
for f in ${files[@]}
do
  cat ${src}/${f} >> ~/.ssh/${f}
done
cp ${src}/id_rsa* ~/.ssh/

cat >> ~/.ssh/config <<EOF
Host *
StrictHostKeyChecking no
UserKnownHostsFile=/dev/null
EOF
chmod 600 ~/.ssh/*
