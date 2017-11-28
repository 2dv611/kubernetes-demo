#!/bin/bash
magnum cluster-create k8s-cluster01 \
  --cluster-template k8s-template \
  --master-count 1 \
  --node-count 3 \
  --keypair tlija-key