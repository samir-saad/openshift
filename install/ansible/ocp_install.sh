echo "
# Create an OSEv3 group that contains the masters and nodes groups
[OSEv3:children]
masters
nodes
#glusterfs
#glusterfs_registry
#nfs

# Set variables common for all OSEv3 hosts
[OSEv3:vars]
# SSH user, this user should allow ssh based auth without requiring a password
ansible_ssh_user=root

# If ansible_ssh_user is not root, ansible_sudo must be set to true
#ansible_sudo=true

deployment_type=openshift-enterprise

# if you want the POD network to be on a different IP network range - (PODS  normally 10.1.0.0)
#osm_cluster_network_cidr=192.168.128.0/17

# if you want the kube network to be on a different IP network range - (Services normally 172.30.0.0)
#openshift_master_portal_net = 192.168.0.0/16

# ntp for master/nodes
openshift_clock_enabled=true

# set subdomain
#openshift_master_default_subdomain=apps.example.com
openshift_master_default_subdomain=apps.ocp.techknowledgeshare.net
openshift_master_cluster_public_hostname=master.ocp.techknowledgeshare.net

# set default node selector to only deploy apps into region primary
# when this is set, registry and router cannot deploy because it doesn't know where to go
osm_default_node_selector='region=primary'

# default selectors for router and registry services, it is already region=infra by default
openshift_router_selector='region=infra'
openshift_registry_selector='region=infra'

# session options
openshift_master_session_name=ssn
openshift_master_session_max_seconds=3600
openshift_master_session_auth_secrets=['DONT+USE+THIS+SECRET+b4NV+pmZNSO']
openshift_master_session_encryption_secrets=['DONT+USE+THIS+SECRET+b4NV+pmZNSO']

# uncomment the following to enable htpasswd authentication; defaults to DenyAllPasswordIdentityProvider
#openshift_master_identity_providers=[{'name': 'htpasswd_auth', 'login': 'true', 'challenge': 'true', 'kind': 'HTPasswdPasswordIdentityProvider', 'filename': '/etc/openshift/openshift-passwd'}]
openshift_master_identity_providers=[{'name': 'any_password', 'login': 'true', 'challenge': 'true','kind': 'AllowAllPasswordIdentityProvider'}]

# metrics
openshift_hosted_metrics_deploy=true
openshift_hosted_metrics_storage_kind=nfs
openshift_hosted_metrics_storage_access_modes=['ReadWriteOnce']
openshift_hosted_metrics_storage_host=workstation.example.com
openshift_hosted_metrics_storage_nfs_directory=/var/export
openshift_hosted_metrics_storage_volume_name=metrics
openshift_hosted_metrics_storage_volume_size=10Gi
#openshift_hosted_metrics_storage_kind=dynamic

# logging
openshift_hosted_logging_deploy=true
openshift_hosted_logging_storage_kind=nfs
openshift_hosted_logging_storage_access_modes=['ReadWriteOnce']
openshift_hosted_logging_storage_host=workstation.example.com
openshift_hosted_logging_storage_nfs_directory=/var/export
openshift_hosted_logging_storage_volume_name=logging
openshift_hosted_logging_storage_volume_size=10Gi
#openshift_hosted_logging_storage_kind=dynamic

# gluster
#openshift_storage_glusterfs_namespace=glusterfs 
#openshift_storage_glusterfs_name=storage

# enable gluster registry 
#openshift_hosted_registry_storage_kind=glusterfs 
#openshift_hosted_registry_replicas=3

# service catalog
openshift_enable_service_catalog=true

# ansible service broker storage
openshift_hosted_etcd_storage_kind=nfs
openshift_hosted_etcd_storage_nfs_directory=/var/export
openshift_hosted_etcd_storage_host=workstation.example.com 
openshift_hosted_etcd_storage_volume_name=etcd
openshift_hosted_etcd_storage_access_modes=['ReadWriteOnce']
openshift_hosted_etcd_storage_volume_size=1Gi
openshift_hosted_etcd_storage_labels={'storage': 'etcd'}

openshift_template_service_broker_namespaces=['openshift']

# docker storage loopback check
openshift_disable_check=docker_storage

# host group for masters
[masters]
master.example.com

# host group for nodes, includes region info
[nodes]
master.example.com openshift_schedulable=false
infra.example.com openshift_node_labels=\"{'region': 'infra', 'zone': 'default'}\"
node1.example.com openshift_node_labels=\"{'region': 'primary', 'zone': 'east'}\"
node2.example.com openshift_node_labels=\"{'region': 'primary', 'zone': 'west'}\"
#10.0.0.30
#10.0.0.31
#10.0.0.32

#[glusterfs]
#10.0.0.30 glusterfs_ip=10.0.0.30 glusterfs_devices='[ \"/dev/vdb\" ]'
#10.0.0.31 glusterfs_ip=10.0.0.31 glusterfs_devices='[ \"/dev/vdb\" ]'
#10.0.0.32 glusterfs_ip=10.0.0.32 glusterfs_devices='[ \"/dev/vdb\" ]'

#[glusterfs_registry]
#10.0.0.30 glusterfs_ip=10.0.0.30 glusterfs_devices='[ \"/dev/vdb\" ]'
#10.0.0.31 glusterfs_ip=10.0.0.31 glusterfs_devices='[ \"/dev/vdb\" ]'
#10.0.0.32 glusterfs_ip=10.0.0.32 glusterfs_devices='[ \"/dev/vdb\" ]'

#[nfs]
#master.example.com

" > /etc/ansible/hosts

ansible-playbook /usr/share/ansible/openshift-ansible/playbooks/byo/config.yml

echo "Verify Installation..."
echo " - Run oc get nodes"
echo " - Check external browser access: https://master.ocp.techknowledgeshare.net:8443"
