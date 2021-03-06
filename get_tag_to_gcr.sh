#! /bin/bash
ARCH=amd64
KUBE_V=v1.7.10
DNS_V=1.14.4
ETCD_V=3.0.17
PAUSE_V=3.0
WORKDIR=~/Documents/git/k8s
SERVER_URL=gcr.io/google_containers

ku_images=(kube-apiserver-${ARCH} 
kube-controller-manager-${ARCH} 
kube-scheduler-${ARCH} 
kube-proxy-${ARCH})

dns_images=(k8s-dns-sidecar-${ARCH} 
k8s-dns-kube-dns-${ARCH} 
k8s-dns-dnsmasq-nanny-${ARCH})

pull_container() {
    docker pull killonexx/$1:$2
}
tag_container() {
    docker tag killonexx/$1:$2 $SERVER_URL/$1:$2
}
for imageName in ${ku_images[@]} ; do
    pull_container $imageName $KUBE_V
    tag_container $imageName $KUBE_V
done
for imageName in ${dns_images[@]} ; do
    pull_container $imageName $DNS_V
    tag_container $imageName $DNS_V
done
pull_container etcd-${ARCH} $ETCD_V
pull_container pause-${ARCH} $PAUSE_V
tag_container etcd-${ARCH} $ETCD_V
tag_container pause-${ARCH} $PAUSE_V
