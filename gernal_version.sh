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

write_file() {
    dic="$WORKDIR/$1"
    if [ ! -d "$dic" ]; then
        mkdir -p $dic/$2
        touch $dic/$2/Dockerfile
    fi
    echo "FROM $SERVER_URL/$1:$2" > $dic/$2/Dockerfile
    echo "MAINTAINER tachao <chao.ta@hanshow.com>" >> $dic/$2/Dockerfile
}
for imageName in ${ku_images[@]} ; do
    write_file $imageName $KUBE_V
done
for imageName in ${dns_images[@]} ; do
    write_file $imageName $DNS_V
done
write_file etcd-${ARCH} $ETCD_V
write_file pause-${ARCH} $PAUSE_V
