# Creating Node js app with mongo db on kubernetes in openstack

```bash
# create a volume, copy ID and edit mongo-controller.yaml
cinder create --display-name=demo-mongodb 1 | awk -F'|' '$2~/^[[:space:]]*id/ {print $3}'
# Configure kubectl
eval $(magnum cluster-config k8s-cluster01 --force)
# Create controllers and services for Node js with mongo db app
kubectl create -f mongo-controller.yaml -f mongo-service.yaml 
kubectl create -f web-controller-demo.yaml -f web-service.yaml
# Create a floating IP
FLOATING_ID=$(openstack floating ip create public -f value -c id)
# Get the ID for the load balancer
neutron lbaas-loadbalancer-list
# Get the port ID 
PORT_ID=$(neutron lbaas-loadbalancer-show LOADBALANCER_ID | grep vip_port_id  | awk '{print $4}')
# Associate the floating IP with the loadbalancer
neutron floatingip-associate $FLOATING_ID $PORT_ID
# Create a security group for Ingress webb traffic and add it to the loadbalancer
neutron security-group-create lb-node-mongo-app
neutron security-group-rule-create \
  --direction ingress \
  --protocol tcp \
  --port-range-min 80 \
  --port-range-max 80 \
  --remote-ip-prefix 0.0.0.0/0 \
  lb-node-mongo-app
neutron port-update --security-group lb-node-mongo-app $PORT_ID
# open app
open "http://$(openstack floating ip show $FLOATING_ID | grep floating_ip_address  | awk '{print $4}')"
```