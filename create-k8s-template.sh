#!/bin/bash
imageId=$(openstack image list | grep "Fedora Atomic 26" |  awk '{print $2}')
magnum cluster-template-create k8s-template \
  --image $imageId \
  --external-network public \
  --flavor cpu1-ram2048-disk20 \
  --master-flavor cpu1-ram2048-disk20 \
  --docker-volume-size 5 \
  --network-driver flannel \
  --volume-driver cinder \
  --coe kubernetes 