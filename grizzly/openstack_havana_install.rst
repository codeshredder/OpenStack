
1.0 get requirment and design deploy architecture




2.0 control node

2.1 install os

1) install Ubuntu12.04.3 server 64bits

2) login as root

3) add Havana repository：

apt-get install python-software-properties
add-apt-repository cloud-archive:havana

4) update ubuntu：

apt-get update
apt-get upgrade
apt-get dist-upgrade
 
2.2 config networks

1) config interface

vi /etc/network/interfaces

#For Exposing OpenStack API over the internet
auto eth0
iface eth0 inet static
address 10.141.71.201
netmask 255.255.255.0
gateway 10.141.70.1
#dns-nameservers 8.8.8.8

#Not internet connected(used for OpenStack management)
auto eth1
iface eth0 inet static
address 192.168.0.1
netmask 255.255.255.0

2) restart network:

/etc/init.d/networking restart


3) enable ipforward：
 
sed -i 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/' /etc/sysctl.conf
sysctl -p



2.3 install RabbitMQ and NTP

1) install RabbitMQ:

apt-get install rabbitmq-server


2) install NTP:

apt-get install ntp


2.4 install MySQL

1)

apt-get install mysql-server python-mysqldb

notice: you may set mysql root's password during install.


2) config mysql setting and restart:

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mysql/my.cnf


service mysql restart



2.5 create databases


login as root:

mysql -u root -p



#Keystone
CREATE DATABASE keystone;
GRANT ALL ON keystone.* TO 'keystoneUser'@'%' IDENTIFIED BY 'keystonePass';
#Glance
CREATE DATABASE glance;
GRANT ALL ON glance.* TO 'glanceUser'@'%' IDENTIFIED BY 'glancePass';
#Neutron
CREATE DATABASE neutron;
GRANT ALL ON neutron.* TO 'neutronUser'@'%' IDENTIFIED BY 'neutronPass';
#Nova
CREATE DATABASE nova;
GRANT ALL ON nova.* TO 'novaUser'@'%' IDENTIFIED BY 'novaPass';
#Cinder
CREATE DATABASE cinder;
GRANT ALL ON cinder.* TO 'cinderUser'@'%' IDENTIFIED BY 'cinderPass';
#Swift
CREATE DATABASE swift;
GRANT ALL ON swift.* TO 'swiftUser'@'%' IDENTIFIED BY 'swiftPass';

quit;




2.6 install Keystone

1) install keystone：

apt-get install keystone

2) update /etc/keystone/keystone.conf:

connection=mysql://keystoneUser:keystonePass@192.168.0.1/keystone


3) restart service and sync data：

service keystone restart

keystone-manage db_sync
 
4) config keystone


vi keystone.sh


#!/bin/sh
#
# Keystone Datas
#
# Description: Fill Keystone with datas.
#


# Please set 13, 30 lines of variables
ADMIN_PASSWORD=${ADMIN_PASSWORD:-admin_pass}
SERVICE_PASSWORD=${SERVICE_PASSWORD:-service_pass}
export SERVICE_TOKEN="ADMIN"
export SERVICE_ENDPOINT="http://192.168.0.1:35357/v2.0"
SERVICE_TENANT_NAME=${SERVICE_TENANT_NAME:-service}
KEYSTONE_REGION=RegionOne
# If you need to provide the service, please to open keystone_wlan_ip and swift_wlan_ip
# of course you are a multi-node architecture, and swift service
# corresponding ip address set the following variables
KEYSTONE_IP="192.168.0.1"
EXT_HOST_IP="10.141.71.201"
SWIFT_IP="192.168.0.1"
COMPUTE_IP=$KEYSTONE_IP
EC2_IP=$KEYSTONE_IP
GLANCE_IP=$KEYSTONE_IP
VOLUME_IP=$KEYSTONE_IP
NEUTRON_IP=$KEYSTONE_IP
CEILOMETER=$KEYSTONE_IP

get_id () {
    echo `$@ | awk '/ id / { print $4 }'`
}

# Create Tenants
ADMIN_TENANT=$(get_id keystone --token $SERVICE_TOKEN --endpoint $SERVICE_ENDPOINT tenant-create --name=admin)
SERVICE_TENANT=$(get_id keystone --token $SERVICE_TOKEN --endpoint $SERVICE_ENDPOINT tenant-create --name=$SERVICE_TENANT_NAME)
DEMO_TENANT=$(get_id keystone --token $SERVICE_TOKEN --endpoint $SERVICE_ENDPOINT tenant-create --name=demo)
INVIS_TENANT=$(get_id keystone --token $SERVICE_TOKEN --endpoint $SERVICE_ENDPOINT tenant-create --name=invisible_to_admin)

# Create Users
ADMIN_USER=$(get_id keystone --token $SERVICE_TOKEN --endpoint $SERVICE_ENDPOINT user-create --name=admin --pass="$ADMIN_PASSWORD" --email=admin@domain.com)
DEMO_USER=$(get_id keystone --token $SERVICE_TOKEN --endpoint $SERVICE_ENDPOINT user-create --name=demo --pass="$ADMIN_PASSWORD" --email=demo@domain.com)

# Create Roles
ADMIN_ROLE=$(get_id keystone --token $SERVICE_TOKEN --endpoint $SERVICE_ENDPOINT role-create --name=admin)
KEYSTONEADMIN_ROLE=$(get_id keystone --token $SERVICE_TOKEN --endpoint $SERVICE_ENDPOINT role-create --name=KeystoneAdmin)
KEYSTONESERVICE_ROLE=$(get_id keystone --token $SERVICE_TOKEN --endpoint $SERVICE_ENDPOINT role-create --name=KeystoneServiceAdmin)

# Add Roles to Users in Tenants
keystone --token $SERVICE_TOKEN --endpoint $SERVICE_ENDPOINT user-role-add --user-id $ADMIN_USER --role-id $ADMIN_ROLE --tenant-id $ADMIN_TENANT
keystone --token $SERVICE_TOKEN --endpoint $SERVICE_ENDPOINT user-role-add --user-id $ADMIN_USER --role-id $ADMIN_ROLE --tenant-id $DEMO_TENANT
keystone --token $SERVICE_TOKEN --endpoint $SERVICE_ENDPOINT user-role-add --user-id $ADMIN_USER --role-id $KEYSTONEADMIN_ROLE --tenant-id $ADMIN_TENANT
keystone --token $SERVICE_TOKEN --endpoint $SERVICE_ENDPOINT user-role-add --user-id $ADMIN_USER --role-id $KEYSTONESERVICE_ROLE --tenant-id $ADMIN_TENANT

# The Member role is used by Horizon and Swift
MEMBER_ROLE=$(get_id keystone --token $SERVICE_TOKEN --endpoint $SERVICE_ENDPOINT role-create --name=Member)
keystone --token $SERVICE_TOKEN --endpoint $SERVICE_ENDPOINT user-role-add --user-id $DEMO_USER --role-id $MEMBER_ROLE --tenant-id $DEMO_TENANT
keystone --token $SERVICE_TOKEN --endpoint $SERVICE_ENDPOINT user-role-add --user-id $DEMO_USER --role-id $MEMBER_ROLE --tenant-id $INVIS_TENANT

# Configure service users/roles
NOVA_USER=$(get_id keystone --token $SERVICE_TOKEN --endpoint $SERVICE_ENDPOINT user-create --name=nova --pass="$SERVICE_PASSWORD" --tenant-id $SERVICE_TENANT --email=nova@domain.com)
keystone --token $SERVICE_TOKEN --endpoint $SERVICE_ENDPOINT user-role-add --tenant-id $SERVICE_TENANT --user-id $NOVA_USER --role-id $ADMIN_ROLE

GLANCE_USER=$(get_id keystone --token $SERVICE_TOKEN --endpoint $SERVICE_ENDPOINT user-create --name=glance --pass="$SERVICE_PASSWORD" --tenant-id $SERVICE_TENANT --email=glance@domain.com)
keystone --token $SERVICE_TOKEN --endpoint $SERVICE_ENDPOINT user-role-add --tenant-id $SERVICE_TENANT --user-id $GLANCE_USER --role-id $ADMIN_ROLE

SWIFT_USER=$(get_id keystone --token $SERVICE_TOKEN --endpoint $SERVICE_ENDPOINT user-create --name=swift --pass="$SERVICE_PASSWORD" --tenant-id $SERVICE_TENANT --email=swift@domain.com)
keystone --token $SERVICE_TOKEN --endpoint $SERVICE_ENDPOINT user-role-add --tenant-id $SERVICE_TENANT --user-id $SWIFT_USER --role-id $ADMIN_ROLE

RESELLER_ROLE=$(get_id keystone --token $SERVICE_TOKEN --endpoint $SERVICE_ENDPOINT role-create --name=ResellerAdmin)
keystone --token $SERVICE_TOKEN --endpoint $SERVICE_ENDPOINT user-role-add --tenant-id $SERVICE_TENANT --user-id $NOVA_USER --role-id $RESELLER_ROLE

NEUTRON_USER=$(get_id keystone --token $SERVICE_TOKEN --endpoint $SERVICE_ENDPOINT user-create --name=neutron --pass="$SERVICE_PASSWORD" --tenant-id $SERVICE_TENANT --email=neutron@domain.com)
keystone --token $SERVICE_TOKEN --endpoint $SERVICE_ENDPOINT user-role-add --tenant-id $SERVICE_TENANT --user-id $NEUTRON_USER --role-id $ADMIN_ROLE

CINDER_USER=$(get_id keystone --token $SERVICE_TOKEN --endpoint $SERVICE_ENDPOINT user-create --name=cinder --pass="$SERVICE_PASSWORD" --tenant-id $SERVICE_TENANT --email=cinder@domain.com)
keystone --token $SERVICE_TOKEN --endpoint $SERVICE_ENDPOINT user-role-add --tenant-id $SERVICE_TENANT --user-id $CINDER_USER --role-id $ADMIN_ROLE

CEILOMETER_USER=$(get_id keystone --token $SERVICE_TOKEN --endpoint $SERVICE_ENDPOINT user-create --name=ceilometer --pass="$SERVICE_PASSWORD" --tenant-id $SERVICE_TENANT --email=ceilometer@domain.com)
keystone --token $SERVICE_TOKEN --endpoint $SERVICE_ENDPOINT user-role-add --tenant-id $SERVICE_TENANT --user-id $CEILOMETER_USER --role-id $ADMIN_ROLE


## Create Service
KEYSTONE_ID=$(keystone --token $SERVICE_TOKEN --endpoint $SERVICE_ENDPOINT service-create --name keystone --type identity --description 'OpenStack Identity'| awk '/ id / { print $4 }' )
COMPUTE_ID=$(keystone --token $SERVICE_TOKEN --endpoint $SERVICE_ENDPOINT service-create --name=nova --type=compute --description='OpenStack Compute Service'| awk '/ id / { print $4 }' )
CINDER_ID=$(keystone --token $SERVICE_TOKEN --endpoint $SERVICE_ENDPOINT service-create --name=cinder --type=volume --description='OpenStack Volume Service'| awk '/ id / { print $4 }' )
GLANCE_ID=$(keystone --token $SERVICE_TOKEN --endpoint $SERVICE_ENDPOINT service-create --name=glance --type=image --description='OpenStack Image Service'| awk '/ id / { print $4 }' )
SWIFT_ID=$(keystone --token $SERVICE_TOKEN --endpoint $SERVICE_ENDPOINT service-create --name=swift --type=object-store --description='OpenStack Storage Service' | awk '/ id / { print $4 }'  )
EC2_ID=$(keystone --token $SERVICE_TOKEN --endpoint $SERVICE_ENDPOINT service-create --name=ec2 --type=ec2 --description='OpenStack EC2 service'| awk '/ id / { print $4 }' )
NEUTRON_ID=$(keystone --token $SERVICE_TOKEN --endpoint $SERVICE_ENDPOINT service-create --name=neutron --type=network --description='OpenStack Networking service'| awk '/ id / { print $4 }'  )
CEILOMETER_ID=$(keystone --token $SERVICE_TOKEN --endpoint $SERVICE_ENDPOINT service-create --name=ceilometer --type=metering --description='Ceilometer Metering Service'| awk '/ id / { print $4 }' )

## Create Endpoint
#identity
if [ "$KEYSTONE_WLAN_IP" != '' ];then
    keystone --token $SERVICE_TOKEN --endpoint $SERVICE_ENDPOINT endpoint-create --region $KEYSTONE_REGION --service-id=$KEYSTONE_ID --publicurl http://"$EXT_HOST_IP":5000/v2.0 --adminurl http://"$KEYSTONE_WLAN_IP":35357/v2.0 --internalurl http://"$KEYSTONE_WLAN_IP":5000/v2.0
fi
keystone --token $SERVICE_TOKEN --endpoint $SERVICE_ENDPOINT endpoint-create --region $KEYSTONE_REGION --service-id=$KEYSTONE_ID --publicurl http://"$EXT_HOST_IP":5000/v2.0 --adminurl http://"$KEYSTONE_IP":35357/v2.0 --internalurl http://"$KEYSTONE_IP":5000/v2.0

#compute
keystone --token $SERVICE_TOKEN --endpoint $SERVICE_ENDPOINT endpoint-create --region $KEYSTONE_REGION --service-id=$COMPUTE_ID --publicurl http://"$EXT_HOST_IP":8774/v2/\$\(tenant_id\)s --adminurl http://"$COMPUTE_IP":8774/v2/\$\(tenant_id\)s --internalurl http://"$COMPUTE_IP":8774/v2/\$\(tenant_id\)s

#volume
keystone --token $SERVICE_TOKEN --endpoint $SERVICE_ENDPOINT endpoint-create --region $KEYSTONE_REGION --service-id=$CINDER_ID --publicurl http://"$EXT_HOST_IP":8776/v1/\$\(tenant_id\)s --adminurl http://"$VOLUME_IP":8776/v1/\$\(tenant_id\)s --internalurl http://"$VOLUME_IP":8776/v1/\$\(tenant_id\)s

#image
keystone --token $SERVICE_TOKEN --endpoint $SERVICE_ENDPOINT endpoint-create --region $KEYSTONE_REGION --service-id=$GLANCE_ID --publicurl http://"$EXT_HOST_IP":9292/v2 --adminurl http://"$GLANCE_IP":9292/v2 --internalurl http://"$GLANCE_IP":9292/v2

#object-store
if [ "$SWIFT_WLAN_IP" != '' ];then
    keystone --token $SERVICE_TOKEN --endpoint $SERVICE_ENDPOINT endpoint-create --region $KEYSTONE_REGION --service-id=$SWIFT_ID --publicurl http://"$EXT_HOST_IP":8080/v1/AUTH_\$\(tenant_id\)s --adminurl http://"$SWIFT_WLAN_IP":8080/v1 --internalurl http://"$SWIFT_WLAN_IP":8080/v1/AUTH_\$\(tenant_id\)s
fi
keystone --token $SERVICE_TOKEN --endpoint $SERVICE_ENDPOINT endpoint-create --region $KEYSTONE_REGION --service-id=$SWIFT_ID --publicurl http://"$EXT_HOST_IP":8080/v1/AUTH_\$\(tenant_id\)s --adminurl http://"$SWIFT_IP":8080/v1 --internalurl http://"$SWIFT_IP":8080/v1/AUTH_\$\(tenant_id\)s

#ec2
keystone --token $SERVICE_TOKEN --endpoint $SERVICE_ENDPOINT endpoint-create --region $KEYSTONE_REGION --service-id=$EC2_ID --publicurl http://"$EXT_HOST_IP":8773/services/Cloud --adminurl http://"$EC2_IP":8773/services/Admin --internalurl http://"$EC2_IP":8773/services/Cloud

#network
keystone --token $SERVICE_TOKEN --endpoint $SERVICE_ENDPOINT endpoint-create --region $KEYSTONE_REGION --service-id=$NEUTRON_ID --publicurl http://"$EXT_HOST_IP":9696/ --adminurl http://"$NUETRON_IP":9696/ --internalurl http://"$NEUTRON_IP":9696/

#ceilometer
keystone --token $SERVICE_TOKEN --endpoint $SERVICE_ENDPOINT endpoint-create --region $KEYSTONE_REGION --service-id=$CEILOMETER_ID --publicurl http://"$EXT_HOST_IP":8777/ --adminurl http://"$CEILOMETER_IP":8777/ --internalurl http://"$CEILOMETER_IP":8777/



chmod +x keystone.sh
./keystone.sh

notice: keystone.sh is a simple sample. it can be changed according to real condition.


4) run openstack cmd as admin


vi creds-admin

export OS_TENANT_NAME=admin
export OS_USERNAME=admin
export OS_PASSWORD=admin_pass
export OS_AUTH_URL="http://10.141.71.201:5000/v2.0/"


source creds-admin


5) check if keystone works well

list keystone users and token：

keystone user-list

keystone token-get
 

2.7 install Glance

1) install Glance:

apt-get install glance


2) update /etc/glance/glance-api-paste.ini

[filter:authtoken]
paste.filter_factory = keystoneclient.middleware.auth_token:filter_factory
delay_auth_decision = true
auth_host = 192.168.0.1
auth_port = 35357
auth_protocol = http
admin_tenant_name = service
admin_user = glance
admin_password = service_pass


3) update /etc/glance/glance-registry-paste.ini

[filter:authtoken]
paste.filter_factory = keystoneclient.middleware.auth_token:filter_factory
auth_host = 192.168.0.1
auth_port = 35357
auth_protocol = http
admin_tenant_name = service
admin_user = glance
admin_password = service_pass


4) update /etc/glance/glance-api.conf

sql_connection = mysql://glanceUser:glancePass@192.168.0.1/glance

[paste_deploy]
flavor = keystone


5) update /etc/glance/glance-registry.conf

sql_connection = mysql://glanceUser:glancePass@192.168.0.1/glance

[paste_deploy]
flavor = keystone


6) restart glance service:

cd /etc/init.d/;for i in $( ls glance-* );do service $i restart;done


sync glance database:

glance-manage db_sync


check if Glance works well:

glance image-list


7) create images

notice: we can also do it on web ui after install.

mkdir images
cd images
wget http://cdn.download.cirros-cloud.net/0.3.1/cirros-0.3.1-x86_64-disk.img
glance image-create --name="Cirros 0.3.1" --disk-format=qcow2 --container-format=bare --is-public=true <cirros-0.3.1-x86_64-disk.img


2.8 install Neutron


1) install Neutron：

apt-get install neutron-server


2) update /etc/neutron/api-paste.ini


[filter:authtoken]
paste.filter_factory = keystoneclient.middleware.auth_token:filter_factory
auth_host = 192.168.0.1
auth_port = 35357
auth_protocol = http
admin_tenant_name = service
admin_user = neutron
admin_password = service_pass


3) update /etc/neutron/plugins/openvswitch/ovs_neutron_plugin.ini

[OVS]
#tenant_network_type = gre
#tunnel_id_ranges = 1:1000
#enable_tunneling = True

network_vlan_ranges=physnet1:100:200
tenant_network_type=vlan
enable_tunneling=False
integration_bridge=br-int
bridge_mappings=physnet1:br-ex1


#Firewall driver for realizing neutron security group function
[SECURITYGROUP]
firewall_driver = neutron.agent.linux.iptables_firewall.OVSHybridIptablesFirewallDriver



4) update /etc/neutron/neutron.conf



[database]
connection = mysql://neutronUser:neutronPass@192.168.0.1/neutron

[keystone_authtoken]
auth_host = 192.168.0.1
auth_port = 35357
auth_protocol = http
admin_tenant_name = service
admin_user = neutron
admin_password = service_pass
signing_dir = /var/lib/neutron/keystone-signing


5) restart Neutron service

cd /etc/init.d/; for i in $( ls neutron-* ); do service $i restart; done

2.9 install Nova


1) install nova:

apt-get install  nova-api nova-cert novnc nova-consoleauth nova-scheduler nova-novncproxy nova-doc nova-conductor nova-ajax-console-proxy 


2) update /etc/nova/api-paste.ini

[filter:authtoken]
paste.filter_factory = keystoneclient.middleware.auth_token:filter_factory
auth_host = 192.168.0.1
auth_port = 35357
auth_protocol = http
admin_tenant_name = service
admin_user = nova
admin_password = service_pass
signing_dir = /var/lib/nova/keystone-signing
# Workaround for https://bugs.launchpad.net/nova/+bug/1154809
auth_version = v2.0


3) update /etc/nova/nova.conf

[DEFAULT]
debug=false
logdir=/var/log/nova
state_path=/var/lib/nova
lock_path=/run/lock/nova
verbose=True
api_paste_config=/etc/nova/api-paste.ini
compute_scheduler_driver=nova.scheduler.simple.SimpleScheduler
rabbit_host=192.168.0.1
nova_url=http://192.168.0.1:8774/v1.1/
sql_connection=mysql://novaUser:novaPass@192.168.0.1/nova
root_helper=sudo nova-rootwrap /etc/nova/rootwrap.conf

# Auth
use_deprecated_auth=false
auth_strategy=keystone

# Imaging service
glance_api_servers=192.168.0.1:9292
image_service=nova.image.glance.GlanceImageService

# Vnc configuration
novnc_enabled=true
novncproxy_base_url=http://10.141.71.201:6080/vnc_auto.html
novncproxy_port=6080
vncserver_proxyclient_address=192.168.0.1
vncserver_listen=0.0.0.0

# Network settings
network_api_class=nova.network.neutronv2.api.API
neutron_url=http://192.168.0.1:9696
neutron_auth_strategy=keystone
neutron_admin_tenant_name=service
neutron_admin_username=neutron
neutron_admin_password=service_pass
neutron_admin_auth_url=http://192.168.0.1:35357/v2.0
libvirt_vif_driver=nova.virt.libvirt.vif.LibvirtHybridOVSBridgeDriver
linuxnet_interface_driver=nova.network.linux_net.LinuxOVSInterfaceDriver
#If you want Neutron + Nova Security groups
firewall_driver=nova.virt.firewall.NoopFirewallDriver
security_group_api=neutron
#If you want Nova Security groups only, comment the two lines above and uncomment line -1-.
#-1-firewall_driver=nova.virt.libvirt.firewall.IptablesFirewallDriver

#Metadata
service_neutron_metadata_proxy = True
neutron_metadata_proxy_shared_secret = helloOpenStack

# Compute #
compute_driver=libvirt.LibvirtDriver

# Cinder #
volume_api_class=nova.volume.cinder.API
osapi_volume_listen_port=5900


4) sync db

nova-manage db sync

(notice: need root)



5) restart nova service

cd /etc/init.d/; for i in $( ls nova-* ); do  service $i restart; done


6) check nova service

nova-manage service list

notice: need creds-admin


2.10 install Cinder

1) install Cinder

apt-get install cinder-api cinder-scheduler

notice: 
we install cinder-api cinder-scheduler on control node.
we can install storage node( cinder-volume iscsitarget open-iscsi iscsitarget-dkms ) with compute node.


2) update /etc/cinder/api-paste.ini

[filter:authtoken]
paste.filter_factory = keystoneclient.middleware.auth_token:filter_factory
service_protocol = http
service_host = 10.141.71.201
service_port = 5000
auth_host = 192.168.0.1
auth_port = 35357
auth_protocol = http
admin_tenant_name = service
admin_user = cinder
admin_password = service_pass


3) update /etc/cinder/cinder.conf

[DEFAULT]
rootwrap_config=/etc/cinder/rootwrap.conf
sql_connection = mysql://cinderUser:cinderPass@192.168.0.1/cinder
api_paste_config = /etc/cinder/api-paste.ini
iscsi_helper=ietadm
volume_name_template = volume-%s
volume_group = cinder-volumes
verbose = True
auth_strategy = keystone
#osapi_volume_listen_port=5900
rabbit_host = 192.168.0.1

4) sync data:
cinder-manage db sync


5) restart cinder service and check

cd /etc/init.d/; for i in $( ls cinder-* ); do service $i restart; done


cd /etc/init.d/; for i in $( ls cinder-* ); do service $i status; done


2.11 install Horizon

1) install horizon：

apt-get install openstack-dashboard memcached

notice: if you don't like OpenStack ubuntu theme, you can remove it：
dpkg --purge openstack-dashboard-ubuntu-theme


2) restart apache and memcached:

service apache2 restart; service memcached restart

notice: if there is a error "could not reliably determine the server's fully domain name,using 127.0.0.1 for ServerName" when restart apache2.
you can fix it by update /etc/apache2/apache2.conf.

add
ServerName localhost


3) use browser to visit http://10.141.71.201/horizon

user:admin
passwd:admin_pass。


2.12 install Ceilometer(optional)

1) install Metering

apt-get install ceilometer-api ceilometer-collector ceilometer-agent-central python-ceilometerclient

2) install MongoDB

apt-get install mongodb


3) config mongodb and restart

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongodb.conf

service mongodb restart

4) create ceilometer database
#mongo
>use ceilometer
>db.addUser({ user:"ceilometer",pwd:"CEILOMETER_DBPASS",roles:["readWrite","dbAdmin"]})



5) create a token by openssl. it will be used between Ceilometer components.

openssl rand -hex 10    
cefafd2288d0e4e43005 (notice: record this token, it will be used later)



6)config token

vi /etc/ceilometer/ceilometer.conf

[publisher_rpc]
# Secret value for signing metering messages (string value)
metering_secret = cefafd2288d0e4e43005      #from record toke before


[database]

# The SQLAlchemy connection string used to connect to the
# database (string value)
connection = mongodb://ceilometer:CEILOMETER_DBPASS@192.168.0.1:27017/ceilometer


[DEFAULT]
log_dir = /var/log/ceilometer

rabbit_host = 192.168.0.1


[keystone_authtoken]
auth_host = 192.168.0.1
auth_port = 35357
auth_protocol = http
admin_tenant_name = service
admin_user = ceilometer
admin_password = service_pass

[service_credentials]
#os_auth_url = http://192.168.0.1:5000/v2.0
os_tenant_name = service
os_username = ceilometer
os_password = service_pass
os_region_name = RegionOne


7)  config glance service

vi /etc/glance/glance-api.conf

[DEFAULT]
notifier_strategy=rabbit
rabbit_host=192.168.0.1


8) restart glance service

cd /etc/init.d/;for i in $(ls glance-* );do service $i restart;done

cd /etc/init.d;for i in $( ls ceilometer-* );do service $i restart;done


9) config cinder service

vi /etc/cinder/cinder.conf

control_exchange=cinder
notification_driver=cinder.openstack.common.notifier.rpc_notifier

10) restart Cinder

cd /etc/init.d/;for i in $( ls cinder-* );do service $i restart;done

cd /etc/init.d;for i in $( ls ceilometer-* );do service $i restart;done



3. network node


3.1 install os

1) install ubuntu 12.04 Server 64bits

2) login as root

3) add Havana repository

apt-get install python-software-properties
add-apt-repository cloud-archive:havana

4) update system

apt-get update
apt-get upgrade
apt-get dist-upgrade


5) install ntp

apt-get install ntp


sed -i 's/server 0.ubuntu.pool.ntp.org/#server 0.ubuntu.pool.ntp.org/g' /etc/ntp.conf
sed -i 's/server 1.ubuntu.pool.ntp.org/#server 1.ubuntu.pool.ntp.org/g' /etc/ntp.conf
sed -i 's/server 2.ubuntu.pool.ntp.org/#server 2.ubuntu.pool.ntp.org/g' /etc/ntp.conf
sed -i 's/server 3.ubuntu.pool.ntp.org/#server 3.ubuntu.pool.ntp.org/g' /etc/ntp.conf

#Set the network node to follow up your conroller node
sed -i 's/server ntp.ubuntu.com/server 192.168.0.1/g' /etc/ntp.conf


service ntp restart

3.2 config networks


# ext network
auto eth0
iface eth0 inet manual
up ifconfig $IFACE 0.0.0.0 up
up ip link set $IFACE promisc on
down ip link set $IFACE promisc off
down ifconfig $IFACE down


# int network
auto eth1
iface eth1 inet static
address 192.168.0.2
netmask 255.255.255.0

3) config ipforward

vi /etc/sysctl.conf

net.ipv4.ip_forward=1
net.ipv4.conf.all.rp_filter=0
net.ipv4.conf.default.rp_filter=0


sysctl -p

3.3 install OpenVSwitch

1) install OpenVSwitch

apt-get install  openvswitch-controller openvswitch-switch openvswitch-datapath-dkms


/etc/init.d/openvswitch-switch restart


2) create ovs bridge:

#br-int will be used for VM integration
ovs-vsctl add-br br-int

#br-ex is used to make to VM accessable from the internet
ovs-vsctl add-br br-ex1

ovs-vsctl add-port br-ex1 eth0


/etc/init.d/networking restart


ovs-vsctl list-br
br-ex1
br-int

ovs-vsctl show
    Bridge br-int
        Port br-int
            Interface br-int
                type: internal
    Bridge br-ex
        Port "eth2"
            Interface "eth0"
        Port br-ex
            Interface br-ex
                type: internal
    ovs_version: "1.4.0+build0"


3.4 install Neutron

1) install Neutron

apt-get install neutron-plugin-openvswitch-agent neutron-dhcp-agent neutron-l3-agent neutron-metadata-agent


2) update /etc/neutron/api-paste.ini

[filter:authtoken]
paste.filter_factory = keystoneclient.middleware.auth_token:filter_factory
auth_host = 192.168.0.1
auth_port = 35357
auth_protocol = http
admin_tenant_name = service
admin_user = neutron
admin_password = service_pass

3) update /etc/neutron/plugins/openvswitch/ovs_neutron_plugin.ini

[OVS]
#tenant_network_type = gre
#enable_tunneling = True
#tunnel_id_ranges = 1:1000
#integration_bridge = br-int
#tunnel_bridge = br-tun
#local_ip = 192.168.0.2

network_vlan_ranges=physnet1:100:200
tenant_network_type=vlan
enable_tunneling=False
integration_bridge=br-int
bridge_mappings=physnet1:br-ex1

#Firewall driver for realizing neutron security group function
[SECURITYGROUP]
firewall_driver = neutron.agent.linux.iptables_firewall.OVSHybridIptablesFirewallDriver


4) update /etc/neutron/metadata_agent.ini

auth_url = http://192.168.0.1:35357/v2.0
auth_region = RegionOne
admin_tenant_name = service
admin_user = neutron
admin_password = service_pass

# IP address used by Nova metadata server
nova_metadata_ip = 192.168.0.1
    
# TCP Port used by Nova metadata server
nova_metadata_port = 8775

metadata_proxy_shared_secret = helloOpenStack

5) update /etc/neutron/neutron.conf

rabbit_host = 192.168.0.1
    
[keystone_authtoken]
auth_host = 192.168.0.1
auth_port = 35357
auth_protocol = http
admin_tenant_name = service
admin_user = neutron
admin_password = service_pass
signing_dir = /var/lib/quantum/keystone-signing

[database]
connection = mysql://neutronUser:neutronPass@192.168.0.1/neutron

6) update /etc/neutron/l3_agent.ini:

[DEFAULT]
interface_driver = neutron.agent.linux.interface.OVSInterfaceDriver
use_namespaces = True
external_network_bridge = br-ex
signing_dir = /var/cache/neutron
admin_tenant_name = service
admin_user = neutron
admin_password = service_pass
auth_url = http://192.168.0.1:35357/v2.0
l3_agent_manager = neutron.agent.l3_agent.L3NATAgentWithStateReport
root_helper = sudo neutron-rootwrap /etc/neutron/rootwrap.conf

7) update /etc/neutron/dhcp_agent.ini:

[DEFAULT]
interface_driver = neutron.agent.linux.interface.OVSInterfaceDriver
dhcp_driver = neutron.agent.linux.dhcp.Dnsmasq
use_namespaces = True
signing_dir = /var/cache/neutron
admin_tenant_name = service
admin_user = neutron
admin_password = service_pass
auth_url = http://192.168.0.1:35357/v2.0
dhcp_agent_manager = neutron.agent.dhcp_agent.DhcpAgentWithStateReport
root_helper = sudo neutron-rootwrap /etc/neutron/rootwrap.conf
state_path = /var/lib/neutron

8) restart serivce

cd /etc/init.d/; for i in $( ls neutron-* ); do service $i restart; done
 



4. compute node


4.1 install os

1) install ubuntu 12.04 Server 64bits

2) login as root

3) add Havana repository

apt-get install python-software-properties
add-apt-repository cloud-archive:havana

4) update system

apt-get update
apt-get upgrade
apt-get dist-upgrade


5) install ntp

apt-get install ntp


sed -i 's/server 0.ubuntu.pool.ntp.org/#server 0.ubuntu.pool.ntp.org/g' /etc/ntp.conf
sed -i 's/server 1.ubuntu.pool.ntp.org/#server 1.ubuntu.pool.ntp.org/g' /etc/ntp.conf
sed -i 's/server 2.ubuntu.pool.ntp.org/#server 2.ubuntu.pool.ntp.org/g' /etc/ntp.conf
sed -i 's/server 3.ubuntu.pool.ntp.org/#server 3.ubuntu.pool.ntp.org/g' /etc/ntp.conf


#Set the network node to follow up your conroller node
sed -i 's/server ntp.ubuntu.com/server 192.168.0.1/g' /etc/ntp.conf

service ntp restart


4.2 config network

1)
vi /etc/network/interfaces:

# The loopback network interface
auto lo
iface lo inet loopback
    

# VM Configuration
auto eth1
iface eth1 inet static
address 192.168.0.3
netmask 255.255.255.0


2) config ip forward

sed -i 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/' /etc/sysctl.conf
sysctl -p


4.3 install KVM


1) check if your hardware supports virtualization:

apt-get install cpu-checker
kvm-ok

notice: if your cpu is ok, check bios setting to enable virtualization support


2) install kvm

apt-get install -y kvm libvirt-bin pm-utils



3) update /etc/libvirt/qemu.conf


cgroup_device_acl = [
"/dev/null", "/dev/full", "/dev/zero",
"/dev/random", "/dev/urandom",
"/dev/ptmx", "/dev/kvm", "/dev/kqemu",
"/dev/rtc", "/dev/hpet","/dev/net/tun"
]

do not use '#'
(old config: # "/dev/rtc","/dev/hpet", "/dev/vfio/vfio")


4) delete default setting

virsh net-destroy default
virsh net-undefine default

5) update /etc/libvirt/libvirtd.conf

listen_tls = 0
listen_tcp = 1
auth_tcp = "none"

6) update /etc/init/libvirt-bin.conf

env libvirtd_opts="-d -l"

7) update /etc/default/libvirt-bin

libvirtd_opts="-d -l"


8) restart libvirt

service libvirt-bin restart



4.4 install OpenVSwitch

1) install OpenVSwitch

apt-get install  openvswitch-switch openvswitch-datapath-dkms

service openvswitch-switch restart

2) create ovs bridge

ovs-vsctl add-br br-int


4.5 install Neutron

1) install Neutron OpenVSwitch agent

apt-get install neutron-plugin-openvswitch-agent

2) update /etc/neutron/plugins/openvswitch/ovs_neutron_plugin.ini

[OVS]
#tenant_network_type = gre
#tunnel_id_ranges = 1:1000
#integration_bridge = br-int
#tunnel_bridge = br-tun
#local_ip = 192.168.0.3
#enable_tunneling = True

network_vlan_ranges=physnet1:100:200
tenant_network_type=vlan
enable_tunneling=False
integration_bridge=br-int
bridge_mappings=physnet1:br-ex1

#Firewall driver for realizing quantum security group function
[SECURITYGROUP]
firewall_driver = neutron.agent.linux.iptables_firewall.OVSHybridIptablesFirewallDriver

3) update /etc/neutron/neutron.conf

rabbit_host = 192.168.0.1

[keystone_authtoken]
auth_host = 192.168.0.1
auth_port = 35357
auth_protocol = http
admin_tenant_name = service
admin_user = neutron
admin_password = service_pass
signing_dir = /var/lib/neutron/keystone-signing

[database]
connection = mysql://neutronUser:neutronPass@192.168.0.1/neutron


4) restart service

service neutron-plugin-openvswitch-agent restart


4.6 install Nova


1) install nova

apt-get install nova-compute-kvm python-guestfs

(if your hardware do not support virtualization，you can change nova-compute-kvm to nova-compute-qemu
and update /etc/nova/nova-compute.conf  with libvirt_type=qemu)


2) update /etc/nova/api-paste.ini

[filter:authtoken]
paste.filter_factory = keystoneclient.middleware.auth_token:filter_factory
auth_host = 192.168.0.1
auth_port = 35357
auth_protocol = http
admin_tenant_name = service
admin_user = nova
admin_password = service_pass
signing_dirname = /tmp/keystone-signing-nova
# Workaround for https://bugs.launchpad.net/nova/+bug/1154809
auth_version = v2.0

3) update /etc/nova/nova.conf

[DEFAULT]
debug=false
logdir=/var/log/nova
state_path=/var/lib/nova
lock_path=/run/lock/nova
verbose=True
api_paste_config=/etc/nova/api-paste.ini
compute_scheduler_driver=nova.scheduler.simple.SimpleScheduler
rabbit_host=192.168.0.1
nova_url=http://192.168.0.1:8774/v1.1/
sql_connection=mysql://novaUser:novaPass@192.168.0.1/nova
root_helper=sudo nova-rootwrap /etc/nova/rootwrap.conf

# Auth
use_deprecated_auth=false
auth_strategy=keystone

# Imaging service
glance_api_servers=192.168.0.1:9292
image_service=nova.image.glance.GlanceImageService

# Vnc configuration
novnc_enabled=true
novncproxy_base_url=http://10.141.71.201:6080/vnc_auto.html
novncproxy_port=6080
vncserver_proxyclient_address=192.168.0.3                   # different from control node
vncserver_listen=0.0.0.0

# Network settings
network_api_class=nova.network.neutronv2.api.API
neutron_url=http://192.168.0.1:9696
neutron_auth_strategy=keystone
neutron_admin_tenant_name=service
neutron_admin_username=neutron
neutron_admin_password=service_pass
neutron_admin_auth_url=http://192.168.0.1:35357/v2.0
libvirt_vif_driver=nova.virt.libvirt.vif.LibvirtHybridOVSBridgeDriver
linuxnet_interface_driver=nova.network.linux_net.LinuxOVSInterfaceDriver
#If you want Neutron + Nova Security groups
firewall_driver=nova.virt.firewall.NoopFirewallDriver
security_group_api=neutron
#If you want Nova Security groups only, comment the two lines above and uncomment line -1-.
#-1-firewall_driver=nova.virt.libvirt.firewall.IptablesFirewallDriver

#Metadata
service_neutron_metadata_proxy = True
neutron_metadata_proxy_shared_secret = helloOpenStack

# Compute #
compute_driver=libvirt.LibvirtDriver

# Cinder #
volume_api_class=nova.volume.cinder.API
osapi_volume_listen_port=5900



4) restart service

cd /etc/init.d/; for i in $( ls nova-* ); do service $i restart; done


5) check on control node

nova-manage service list

(notice: need creds-admin)


4.7 install cinder volume service

notice: we usually install cinder service with compute node

1)

apt-get install cinder-volume iscsitarget open-iscsi iscsitarget-dkms


notice:
if dkms build error, we must downgrade linux kernel from 3.11 to 3.8

apt-get install linux-image-3.8.0-37-generic linux-headers-3.8.0-37-generic

dpkg -get-selections | grep linux
apt-get remove linux-image-3.11.0-15-generic linux-image-3.11.0-18-generic


2) config iscsi

sed -i 's/false/true/g' /etc/default/iscsitarget


3) restart iscsi service

service iscsitarget restart
service open-iscsi restart


4) check iscsi target serice

notice: we use ietd instead of tgt

/* ietd */

lsof -i:3260

COMMAND  PID USER   FD   TYPE DEVICE SIZE/OFF NODE NAME
tgtd    1810 root    4u  IPv4   1406      0t0  TCP *:3260 (LISTEN)
tgtd    1810 root    5u  IPv6   1407      0t0  TCP *:3260 (LISTEN)
tgtd    1813 root    4u  IPv4   1406      0t0  TCP *:3260 (LISTEN)
tgtd    1813 root    5u  IPv6   1407      0t0  TCP *:3260 (LISTEN)

if tgt is running, we must stop it and restart service.

service tgt stop

service iscsitarget restart
service open-iscsi restart


lsof -i:3260
COMMAND   PID USER   FD   TYPE DEVICE SIZE/OFF NODE NAME
ietd    39894 root    7u  IPv4 225635      0t0  TCP *:3260 (LISTEN)
ietd    39894 root    8u  IPv6 225636      0t0  TCP *:3260 (LISTEN)


5) update /etc/cinder/api-paste.ini

[filter:authtoken]
paste.filter_factory = keystoneclient.middleware.auth_token:filter_factory
service_protocol = http
service_host = 10.141.71.201
service_port = 5000
auth_host = 192.168.0.1
auth_port = 35357
auth_protocol = http
admin_tenant_name = service
admin_user = cinder
admin_password = service_pass


6) update /etc/cinder/cinder.conf

[DEFAULT]
rootwrap_config=/etc/cinder/rootwrap.conf
sql_connection = mysql://cinderUser:cinderPass@192.168.0.1/cinder
api_paste_config = /etc/cinder/api-paste.ini
iscsi_helper=ietadm
volume_name_template = volume-%s
volume_group = cinder-volumes
verbose = True
auth_strategy = keystone
#osapi_volume_listen_port=5900
rabbit_host = 192.168.0.1
iscsi_ip_address = 192.168.0.3         #local ip

7) create cinder-volumes

we can use a real partition(recommend):

pvcreate /dev/cciss/c0d0p3
vgcreate cinder-volumes /dev/cciss/c0d0p3

notice: /dev/cciss/c0d0p3 is a real partition.you can list partitions by "fdisk -l"



wen can also use a file(not recommend):

dd if=/dev/zero of=cinder-volumes bs=1 count=0 seek=2G
losetup /dev/loop2 cinder-volumes
fdisk /dev/loop2
#Type in the followings:
n
p
1
ENTER
ENTER
t
8e
w

pvcreate /dev/loop2
vgcreate cinder-volumes /dev/loop2


8) restart service

cd /etc/init.d/; for i in $( ls cinder-* ); do sudo service $i restart; done

cd /etc/init.d/; for i in $( ls cinder-* ); do sudo service $i status; done
cinder-volume start/running, process 41513


9) check on control node


cinder-manage host list

(notice: need creds-admin)


notice: 
kvm -> open-iscsi(initiator) ---(net)---> iscsitarget(target) -> lvm -> file(/dev/loop2) or partition(/dev/cciss/c0d0p3)。


4.8 install ceilometer(optional)

1) install ceilometer

apt-get install ceilometer-agent-compute

2) update /etc/nova/nova.conf:

...
[DEFAULT]
...
instance_usage_audit=True
instance_usage_audit_period=hour
notify_on_state_change=vm_and_task_state
notification_driver=nova.openstack.common.notifier.rpc_notifier
notification_driver=ceilometer.compute.nova_notifier

3) update /etc/ceilometer/ceilometer.conf

[publisher_rpc]
# Secret value for signing metering messages (string value)
metering_secret = cefafd2288d0e4e43005         #from record toke before

[DEFAULT]
rabbit_host = 192.168.0.1

[keystone_authtoken]
auth_host = 192.168.0.1
auth_port = 35357
auth_protocol = http
admin_tenant_name = service
admin_user = ceilometer
admin_password = service_pass

[service_credentials]
os_auth_url = http://192.168.0.1:5000/v2.0
os_username = ceilometer
os_tenant_name = service
os_password = service_pass
os_region_name = RegionOne

[DEFAULT]
log_dir = /var/log/ceilometer


4) restart service


service ceilometer-agent-compute restart



5. how to start VM


5.1 flat network sample


1) set env

vi creds-admin

#Paste the following:
export OS_TENANT_NAME=admin
export OS_USERNAME=admin
export OS_PASSWORD=admin_pass
export OS_AUTH_URL="http://10.141.71.201:5000/v2.0/"

source creds-admin

2) create tenant

keystone tenant-create --name project_one

keystone tenant-list
keystone role-list

keystone user-create --name=user_one --pass=user_one --tenant-id $put_id_of_project_one --email=user_one@domain.com
keystone user-role-add --tenant-id $put_id_of_project_one  --user-id $put_id_of_user_one --role-id $put_id_of_member_role


3) create network

neutron net-create ext-network1 --provider:network_type flat --provider:physical_network physnet1 --shared

neutron subnet-create ext-network1 192.168.2.0/24 --disable-dhcp --allocation-pool start=192.168.2.100,end=192.168.2.220



neutron net-list
neutron subnet-list


4) go to web and create instance
http://10.141.71.201/horizon

login as user_one:

user: user_one
password: user_one


we can also change env as new tenant

vi creds-user

export OS_TENANT_NAME=project_one
export OS_USERNAME=user_one
export OS_PASSWORD=user_one
export OS_AUTH_URL="http://10.141.71.201:5000/v2.0/"


source reds-user



5) openstack restrict one vm eth port have one ip.
usually we need many different ip address through one eth port.


find iptables_firewall.py

/usr/lib/python2.7/dist-packages/neutron/agent/linux/iptables_firewall.py

vi iptables_firewall.py
find _add_rule_by_security_group

# self._ip_spoofing_rule(port, ipv4_iptables_rule, ipv6_iptables_rule)


compile iptables_firewall.py to iptables_firewall.pyc
copy iptables_firewall.pyc to /usr/lib/python2.7/dist-packages/neutron/agent/linux/

restart


/* how to compile .py to .pyc */

vi mkpy.sh

in="./"$1
out=${in}"c"
cmd="py_compile.compile(r\""${in}"\", r\""${out}"\")"

echo $in
echo $out
echo $cmd

(echo 'import py_compile'; echo $cmd)| python

chmod +x mkpy.sh

./mkpy.sh iptables_firewall.py





5.1 router network sample


1) set env

vim creds-admin

#Paste the following:
export OS_TENANT_NAME=admin
export OS_USERNAME=admin
export OS_PASSWORD=admin_pass
export OS_AUTH_URL="http://10.141.71.201:5000/v2.0/"

source creds-admin

2) create tenant

keystone tenant-create --name project_one

keystone tenant-list
keystone role-list

keystone user-create --name=user_one --pass=user_one --tenant-id $put_id_of_project_one --email=user_one@domain.com
keystone user-role-add --tenant-id $put_id_of_project_one  --user-id $put_id_of_user_one --role-id $put_id_of_member_role


3) create network for tenant


quantum net-create --tenant-id $put_id_of_project_one net_proj_one
quantum net-list


4) create a new subnet inside the new tenant network:

quantum subnet-create --tenant-id $put_id_of_project_one net_proj_one 50.50.1.0/24
quantum subnet-list


5) Create a dhcp agent:

quantum agent-list (to get the dhcp agent id)
quantum dhcp-agent-network-add $dhcp_agent_id net_proj_one


6) Create a router for the new tenant:

quantum router-create --tenant-id $put_id_of_project_one router_proj_one
quantum router-list


7) Add the router to the running l3 agent (if it wasn't automatically added):

quantum agent-list (to get the l3 agent id)
quantum l3-agent-router-add $l3_agent_id router_proj_one

8) Add the router to the subnet:

quantum router-interface-add $put_router_proj_one_id_here $put_subnet_id_here

9) Restart all quantum services:

cd /etc/init.d/; for i in $( ls quantum-* ); do sudo service $i restart; done


10) Create an external network with the tenant id belonging to the admin tenant (keystone tenant-list to get the appropriate id):

neutron net-create --tenant-id $put_id_of_admin_tenant ext-net --provider:physical_network=physnet1 --provider:network_type=vlan --router:external=True  --provider:segmentation_id 2 


notice: tenant-id is admin here


11) Create a subnet for the floating ips:

quantum subnet-create --tenant-id $put_id_of_admin_tenant --allocation-pool start=192.168.100.102,end=192.168.100.150 --gateway 192.168.100.1 ext_net 192.168.100.100/24 --enable_dhcp=False

notice: tenant-id is admin here


12) set your router's gateway to the external network:

quantum router-gateway-set $put_router_proj_one_id_here $put_id_of_ext_net_here


 

6. reference

1.

http://docs.openstack.org/havana/install-guide/install/apt/openstack-install-guide-apt-havana.pdf

2.
https://github.com/mseknibilel/OpenStack-Grizzly-Install-Guide/blob/OVS_MultiNode/OpenStack_Grizzly_Install_Guide.rst

 
