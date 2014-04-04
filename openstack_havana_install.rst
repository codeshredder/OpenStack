
1.架构设计

1.1 openstack结点设计

Control Node
 eth0 (10.10.10.1), eth1 (192.168.1.1)
 
Network Node
 eth0 (192.168.1.2), eth1, eth2
 
Compute Node
 eth0 (192.168.1.3)
 


1.2 openstack网络设计

两个直通对外的子网
physnet1:br-ex1      ->eth1
physnet2:br-ex2      ->eth2


2.1 控制结点

安装好Ubuntu12.04 server 64bits后，进入root模式进行安装。
(不能安装ubuntu 12.04.4，内核版本3.11太新，dkms编译可能有问题)


sudo su - 
添加Havana仓库：

apt-get install python-software-properties
add-apt-repository cloud-archive:havana

升级系统：

apt-get update
apt-get upgrade
apt-get dist-upgrade
 
2.2设置网络

vi /etc/network/interfaces

#For Exposing OpenStack API over the internet
auto eth0
iface eth0 inet static
address 10.10.10.1
netmask 255.255.255.0
gateway 10.141.123.1
#dns-nameservers 8.8.8.8

#Not internet connected(used for OpenStack management)
auto eth1
iface eth0 inet static
address 192.168.1.1
netmask 255.255.255.0


重启网络服务

/etc/init.d/networking restart


开启路由转发：
 
sed -i 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/' /etc/sysctl.conf
sysctl -p

2.3安装RabbitMQ和NTP

安装RabbitMQ:

apt-get install rabbitmq-server


安装NTP服务

apt-get install ntp


2.4安装MySQL
安装MySQL并为root用户设置密码：

apt-get install mysql-server python-mysqldb

配置mysql监听所有网络请求

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mysql/my.cnf
service mysql restart



2.5创建数据库

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




2.6.配置Keystone

安装keystone软件包：

apt-get install keystone

在/etc/keystone/keystone.conf中设置连接到新创建的数据库：

connection=mysql://keystoneUser:keystonePass@192.168.1.1/keystone


重启身份认证服务并同步数据库：

service keystone restart
keystone-manage db_sync
 


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
export SERVICE_ENDPOINT="http://192.168.1.1:35357/v2.0"
SERVICE_TENANT_NAME=${SERVICE_TENANT_NAME:-service}
KEYSTONE_REGION=RegionOne
# If you need to provide the service, please to open keystone_wlan_ip and swift_wlan_ip
# of course you are a multi-node architecture, and swift service
# corresponding ip address set the following variables
KEYSTONE_IP="192.168.1.1"
EXT_HOST_IP="10.10.10.1"
SWIFT_IP="192.168.1.1"
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





上述脚本文件为了填充keystone数据库，其中还有些内容根据自身情况修改。
创建一个简单的凭据文件，这样稍后不会因为输入过多的环境变量而感到厌烦。


vi creds-admin


export OS_TENANT_NAME=admin
export OS_USERNAME=admin
export OS_PASSWORD=admin_pass
export OS_AUTH_URL="http://10.10.10.1:5000/v2.0/"


source creds-admin


 

通过命令列出keystone中添加的用户以及得到token：

 
keystone user-list
keystone token-get
 

2.7.设置Glance

安装Glance

apt-get install glance


更新/etc/glance/glance-api-paste.ini

[filter:authtoken]
paste.filter_factory = keystoneclient.middleware.auth_token:filter_factory
delay_auth_decision = true
auth_host = 192.168.1.1
auth_port = 35357
auth_protocol = http
admin_tenant_name = service
admin_user = glance
admin_password = service_pass


更新/etc/glance/glance-registry-paste.ini

[filter:authtoken]
paste.filter_factory = keystoneclient.middleware.auth_token:filter_factory
auth_host = 192.168.1.1
auth_port = 35357
auth_protocol = http
admin_tenant_name = service
admin_user = glance
admin_password = service_pass


更新/etc/glance/glance-api.conf

sql_connection = mysql://glanceUser:glancePass@192.168.1.1/glance
和
[paste_deploy]
flavor = keystone


更新/etc/glance/glance-registry.conf

sql_connection = mysql://glanceUser:glancePass@192.168.1.1/glance
和
[paste_deploy]
flavor = keystone


重新启动glance服务：

cd /etc/init.d/;for i in $( ls glance-* );do service $i restart;done


同步glance数据库

glance-manage db_sync


测试Glance

mkdir images
cd images
wget http://cdn.download.cirros-cloud.net/0.3.1/cirros-0.3.1-x86_64-disk.img
glance image-create --name="Cirros 0.3.1" --disk-format=qcow2 --container-format=bare --is-public=true <cirros-0.3.1-x86_64-disk.img


列出镜像检查是否上传成功：

glance image-list


2.8.设置Neutron


安装Neutron组件：

apt-get install neutron-server


编辑/etc/neutron/api-paste.ini


[filter:authtoken]
paste.filter_factory = keystoneclient.middleware.auth_token:filter_factory
auth_host = 192.168.1.1
auth_port = 35357
auth_protocol = http
admin_tenant_name = service
admin_user = neutron
admin_password = service_pass


编辑OVS配置文件/etc/neutron/plugins/openvswitch/ovs_neutron_plugin.ini

[OVS]
#tenant_network_type = gre
#tunnel_id_ranges = 1:1000
#enable_tunneling = True

network_vlan_ranges=physnet1,physnet2:100:200
tenant_network_type=vlan
enable_tunneling=False
integration_bridge=br-int
bridge_mappings=physnet1:br-ex1,physnet2:br-ex2


#Firewall driver for realizing neutron security group function
[SECURITYGROUP]
firewall_driver = neutron.agent.linux.iptables_firewall.OVSHybridIptablesFirewallDriver



编辑/etc/neutron/neutron.conf



[database]
connection = mysql://neutronUser:neutronPass@192.168.1.1/neutron

[keystone_authtoken]
auth_host = 192.168.1.1
auth_port = 35357
auth_protocol = http
admin_tenant_name = service
admin_user = neutron
admin_password = service_pass
signing_dir = /var/lib/neutron/keystone-signing


重启Neutron所有服务：
cd /etc/init.d/; for i in $( ls neutron-* ); do sudo service $i restart; done

2.9.设置Nova

安装nova组件：

apt-get install  nova-api nova-cert novnc nova-consoleauth nova-scheduler nova-novncproxy nova-doc nova-conductor nova-ajax-console-proxy 


编辑/etc/nova/api-paste.ini修改认证信息：

[filter:authtoken]
paste.filter_factory = keystoneclient.middleware.auth_token:filter_factory
auth_host = 192.168.1.1
auth_port = 35357
auth_protocol = http
admin_tenant_name = service
admin_user = nova
admin_password = service_pass
signing_dir = /var/lib/nova/keystone-signing
# Workaround for https://bugs.launchpad.net/nova/+bug/1154809
auth_version = v2.0


编辑修改/etc/nova/nova.conf

[DEFAULT]
logdir=/var/log/nova
state_path=/var/lib/nova
lock_path=/run/lock/nova
verbose=True
api_paste_config=/etc/nova/api-paste.ini
compute_scheduler_driver=nova.scheduler.simple.SimpleScheduler
rabbit_host=192.168.1.1
nova_url=http://192.168.1.1:8774/v1.1/
sql_connection=mysql://novaUser:novaPass@192.168.1.1/nova
root_helper=sudo nova-rootwrap /etc/nova/rootwrap.conf

# Auth
use_deprecated_auth=false
auth_strategy=keystone

# Imaging service
glance_api_servers=192.168.1.1:9292
image_service=nova.image.glance.GlanceImageService

# Vnc configuration
novnc_enabled=true
novncproxy_base_url=http://10.10.10.1:6080/vnc_auto.html
novncproxy_port=6080
vncserver_proxyclient_address=192.168.1.1
vncserver_listen=0.0.0.0

# Network settings
network_api_class=nova.network.neutronv2.api.API
neutron_url=http://192.168.1.1:9696
neutron_auth_strategy=keystone
neutron_admin_tenant_name=service
neutron_admin_username=neutron
neutron_admin_password=service_pass
neutron_admin_auth_url=http://192.168.1.1:35357/v2.0
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



同步数据库：

nova-manage db sync


重启Nova所有服务：

cd /etc/init.d/; for i in $( ls nova-* ); do  service $i restart; done

检查所有nova服务是否启动正常：

nova-manage service list



2.10.设置Cinder

安装Cinder软件包

apt-get install  cinder-api cinder-scheduler cinder-volume iscsitarget open-iscsi iscsitarget-dkms

配置iscsi服务：

sed -i 's/false/true/g' /etc/default/iscsitarget

重启服务：

service iscsitarget restart
service open-iscsi restart

/* ietd */

lsof -i:3260
COMMAND  PID USER   FD   TYPE DEVICE SIZE/OFF NODE NAME
tgtd    1810 root    4u  IPv4   1406      0t0  TCP *:3260 (LISTEN)
tgtd    1810 root    5u  IPv6   1407      0t0  TCP *:3260 (LISTEN)
tgtd    1813 root    4u  IPv4   1406      0t0  TCP *:3260 (LISTEN)
tgtd    1813 root    5u  IPv6   1407      0t0  TCP *:3260 (LISTEN)

service tgt stop


lsof -i:3260
COMMAND   PID USER   FD   TYPE DEVICE SIZE/OFF NODE NAME
ietd    39894 root    7u  IPv4 225635      0t0  TCP *:3260 (LISTEN)
ietd    39894 root    8u  IPv6 225636      0t0  TCP *:3260 (LISTEN)


/* if dkms build error */

apt-get install linux-image-3.8.0-37-generic linux-headers-3.8.0-37-generic

dpkg -get-selections | grep linux
apt-get remove linux-image-3.11.0-15-generic linux-image-3.11.0-18-generic



配置/etc/cinder/api-paste.ini

[filter:authtoken]
paste.filter_factory = keystoneclient.middleware.auth_token:filter_factory
service_protocol = http
service_host = 10.10.10.1
service_port = 5000
auth_host = 192.168.1.1
auth_port = 35357
auth_protocol = http
admin_tenant_name = service
admin_user = cinder
admin_password = service_pass


编辑/etc/cinder/cinder.conf

[DEFAULT]
rootwrap_config=/etc/cinder/rootwrap.conf
sql_connection = mysql://cinderUser:cinderPass@192.168.1.1/cinder
api_paste_config = /etc/cinder/api-paste.ini
iscsi_helper=ietadm
volume_name_template = volume-%s
volume_group = cinder-volumes
verbose = True
auth_strategy = keystone
#osapi_volume_listen_port=5900


接下来同步数据库：
cinder-manage db sync


最后别忘记创建一个卷组命名为cinder-volumes:

1)
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


2)创建物理卷和卷组：

pvcreate /dev/loop2
vgcreate cinder-volumes /dev/loop2

注意：重启后卷组不会自动挂载，如下进行设置：

vim /etc/init/losetup.conf

description "set up loop devices"
start on mounted MOUNTPOINT=/
task
exec /sbin/losetup  /dev/loop2 /home/cloud/cinder-volumes



3)
pvcreate /dev/sda4
vgcreate cinder-volumes /dev/sda4



重启cinder服务：

cd /etc/init.d/; for i in $( ls cinder-* ); do service $i restart; done

确认Cinder服务在运行：

cd /etc/init.d/; for i in $( ls cinder-* ); do service $i status; done


2.11.设置Horizon

安装horizon：

apt-get install openstack-dashboard memcached

如果你不喜欢OpenStack ubuntu主题，你可以停用它：

dpkg --purge openstack-dashboard-ubuntu-theme

重启Apache和memcached服务：

service apache2 restart; service memcached restart

注意：重启apache2,出现could not reliably determine the server's fully domain name,using 127.0.0.1 for ServerName.这是由于没有解析出域名导致的。
解决方法如下：编辑/etc/apache2/apache2.conf，添加如下操作即可。

ServerName localhost

正常情况下，这时访问 http://10.10.10.1/horizon 就可以看到web界面了。 用户admin,密码admin_pass。


2.12.设置Ceilometer

安装Metering服务

apt-get install ceilometer-api ceilometer-collector ceilometer-agent-central python-ceilometerclient

安装MongoDB数据库

apt-get install mongodb

配置mongodb监听所有网络接口请求：

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongodb.conf

service mongodb restart

创建ceilometer数据库用户：
#mongo
>use ceilometer
>db.addUser({ user:"ceilometer",pwd:"CEILOMETER_DBPASS",roles:["readWrite","dbAdmin"]})


利用openssl生成一个随机token密钥，该密钥用于Ceilometer各个组件之间通信加密使用：

openssl rand -hex 10    
cefafd2288d0e4e43005 （注：这是命令生成的随机token）



编辑/etc/ceilometer/ceilometer.conf

配置token

[publisher_rpc]
# Secret value for signing metering messages (string value)
metering_secret = cefafd2288d0e4e43005


配置Metering服务使用数据库

...
[database]
...
# The SQLAlchemy connection string used to connect to the
# database (string value)
connection = mongodb://ceilometer:CEILOMETER_DBPASS@192.168.1.1:27017/ceilometer
...


配置RabbitMQ访问
...
[DEFAULT]
log_dir = /var/log/ceilometer

rabbit_host = 192.168.1.1


配置认证信息

[keystone_authtoken]
auth_host = 192.168.1.1
auth_port = 35357
auth_protocol = http
admin_tenant_name = service
admin_user = ceilometer
admin_password = service_pass

[service_credentials]
#os_auth_url = http://192.168.1.1:5000/v2.0
os_tenant_name = service
os_username = ceilometer
os_password = service_pass
os_region_name = RegionOne


简单获取镜像，你必须配置镜像服务以发送通知给总线，
编辑/etc/glance/glance-api.conf

[DEFAULT]
notifier_strategy=rabbit
rabbit_host=192.168.1.1

重启镜像服务
cd /etc/init.d/;for i in $(ls glance-* );do service $i restart;done

重启服务，使配置信息生效

cd /etc/init.d;for i in $( ls ceilometer-* );do service $i restart;done

编辑/etc/cinder/cinder.conf，获取volume。

control_exchange=cinder
notification_driver=cinder.openstack.common.notifier.rpc_notifier

重启Cinder服务

cd /etc/init.d/;for i in $( ls cinder-* );do service $i restart;done


3.网络结点

安装好ubuntu 12.04 Server 64bits后，进入root模式下完成配置：

sudo su - 

添加Havana源：

apt-get install python-software-properties
add-apt-repository cloud-archive:havana

升级系统：

apt-get update
apt-get upgrade
apt-get dist-upgrade

安装ntp服务：

apt-get install ntp

配置ntp服务从控制节点上同步时间：

sed -i 's/server 0.ubuntu.pool.ntp.org/#server 0.ubuntu.pool.ntp.org/g' /etc/ntp.conf
sed -i 's/server 1.ubuntu.pool.ntp.org/#server 1.ubuntu.pool.ntp.org/g' /etc/ntp.conf
sed -i 's/server 2.ubuntu.pool.ntp.org/#server 2.ubuntu.pool.ntp.org/g' /etc/ntp.conf
sed -i 's/server 3.ubuntu.pool.ntp.org/#server 3.ubuntu.pool.ntp.org/g' /etc/ntp.conf

#Set the network node to follow up your conroller node
sed -i 's/server ntp.ubuntu.com/server 192.168.1.1/g' /etc/ntp.conf

service ntp restart


配置网络：

# OpenStack management
auto eth0
iface eth0 inet static
address 192.168.1.2
netmask 255.255.255.0

# ext network
auto eth1
iface eth1 inet manual
up ifconfig $IFACE 0.0.0.0 up
up ip link set $IFACE promisc on
down ip link set $IFACE promisc off
down ifconfig $IFACE down

auto eth2
iface eth1 inet manual
up ifconfig $IFACE 0.0.0.0 up
up ip link set $IFACE promisc on
down ip link set $IFACE promisc off
down ifconfig $IFACE down


编辑/etc/sysctl.conf,开启路由转发和关闭包目的过滤，这样网络节点能协作VMs的traffic。

net.ipv4.ip_forward=1
net.ipv4.conf.all.rp_filter=0
net.ipv4.conf.default.rp_filter=0

#运行下面命令，使生效
sysctl -p


重启网络服务：

/etc/init.d/networking restart



3.3.安装OpenVSwitch

安装OpenVSwitch软件包：

apt-get install  openvswitch-controller openvswitch-switch openvswitch-datapath-dkms

/etc/init.d/openvswitch-switch restart

创建网桥

#br-int will be used for VM integration
ovs-vsctl add-br br-int

#br-ex is used to make to VM accessable from the internet
ovs-vsctl add-br br-ex1
ovs-vsctl add-br br-ex2

把网卡eth2加入br-ex：

ovs-vsctl add-port br-ex1 eth1
ovs-vsctl add-port br-ex2 eth2



查看网桥配置：

root@network:~# ovs-vsctl list-br
br-ex1
br-ex2
br-int

root@network:~# ovs-vsctl show



3.4.Neutron-*

安装Neutron组件：

apt-get install neutron-plugin-openvswitch-agent neutron-dhcp-agent neutron-l3-agent neutron-metadata-agent


编辑/etc/neutron/api-paste.ini

[filter:authtoken]
paste.filter_factory = keystoneclient.middleware.auth_token:filter_factory
auth_host = 192.168.1.1
auth_port = 35357
auth_protocol = http
admin_tenant_name = service
admin_user = neutron
admin_password = service_pass

编辑OVS配置文件：/etc/neutron/plugins/openvswitch/ovs_neutron_plugin.ini

[OVS]
#tenant_network_type = gre
#enable_tunneling = True
#tunnel_id_ranges = 1:1000
#integration_bridge = br-int
#tunnel_bridge = br-tun
#local_ip = 192.168.1.2

network_vlan_ranges=physnet1,physnet2:100:200
tenant_network_type=vlan
enable_tunneling=False
integration_bridge=br-int
bridge_mappings=physnet1:br-ex1,physnet2:br-ex2

#Firewall driver for realizing neutron security group function
[SECURITYGROUP]
firewall_driver = neutron.agent.linux.iptables_firewall.OVSHybridIptablesFirewallDriver


更新/etc/neutron/metadata_agent.ini

auth_url = http://192.168.1.1:35357/v2.0
auth_region = RegionOne
admin_tenant_name = service
admin_user = neutron
admin_password = service_pass

# IP address used by Nova metadata server
nova_metadata_ip = 192.168.1.1
    
# TCP Port used by Nova metadata server
nova_metadata_port = 8775

metadata_proxy_shared_secret = helloOpenStack

编辑/etc/neutron/neutron.conf

rabbit_host = 192.168.1.1
    
[keystone_authtoken]
auth_host = 192.168.1.1
auth_port = 35357
auth_protocol = http
admin_tenant_name = service
admin_user = neutron
admin_password = service_pass
signing_dir = /var/lib/quantum/keystone-signing

[database]
connection = mysql://neutronUser:neutronPass@192.168.1.1/neutron

编辑/etc/neutron/l3_agent.ini:

[DEFAULT]
interface_driver = neutron.agent.linux.interface.OVSInterfaceDriver
use_namespaces = True
external_network_bridge = br-ex
signing_dir = /var/cache/neutron
admin_tenant_name = service
admin_user = neutron
admin_password = service_pass
auth_url = http://192.168.1.1:35357/v2.0
l3_agent_manager = neutron.agent.l3_agent.L3NATAgentWithStateReport
root_helper = sudo neutron-rootwrap /etc/neutron/rootwrap.conf

编辑/etc/neutron/dhcp_agent.ini:

[DEFAULT]
interface_driver = neutron.agent.linux.interface.OVSInterfaceDriver
dhcp_driver = neutron.agent.linux.dhcp.Dnsmasq
use_namespaces = True
signing_dir = /var/cache/neutron
admin_tenant_name = service
admin_user = neutron
admin_password = service_pass
auth_url = http://192.168.1.1:35357/v2.0
dhcp_agent_manager = neutron.agent.dhcp_agent.DhcpAgentWithStateReport
root_helper = sudo neutron-rootwrap /etc/neutron/rootwrap.conf
state_path = /var/lib/neutron

重启服务：
cd /etc/init.d/; for i in $( ls neutron-* ); do service $i restart; done
 

4.计算结点

4.1.准备结点

安装好ubuntu 12.04 Server 64bits后，进入root模式进行安装：
sudo su - 

添加Havana源：

apt-get install python-software-properties
add-apt-repository cloud-archive:havana

升级系统：

apt-get update
apt-get upgrade
apt-get dist-upgrade


安装ntp服务：

apt-get install ntp

配置ntp服务从控制节点同步时间：

sed -i 's/server 0.ubuntu.pool.ntp.org/#server 0.ubuntu.pool.ntp.org/g' /etc/ntp.conf
sed -i 's/server 1.ubuntu.pool.ntp.org/#server 1.ubuntu.pool.ntp.org/g' /etc/ntp.conf
sed -i 's/server 2.ubuntu.pool.ntp.org/#server 2.ubuntu.pool.ntp.org/g' /etc/ntp.conf
sed -i 's/server 3.ubuntu.pool.ntp.org/#server 3.ubuntu.pool.ntp.org/g' /etc/ntp.conf


#Set the network node to follow up your conroller node
sed -i 's/server ntp.ubuntu.com/server 192.168.1.1/g' /etc/ntp.conf

service ntp restart


4.2.配置网络

如下配置网络/etc/network/interfaces:

# The loopback network interface
auto lo
iface lo inet loopback
    
# Not internet connected(used for OpenStack management)
auto eth0
iface eth0 inet static
address 192.168.1.3
netmask 255.255.255.0


开启路由转发：
sed -i 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/' /etc/sysctl.conf
sysctl -p


4.3.KVM

确保你的硬件启动virtualization:

apt-get install cpu-checker
kvm-ok

安装kvm并配置它：

apt-get install -y kvm libvirt-bin pm-utils

在/etc/libvirt/qemu.conf配置文件中启用 cgroup_device_acl 数组：

cgroup_device_acl = [
"/dev/null", "/dev/full", "/dev/zero",
"/dev/random", "/dev/urandom",
"/dev/ptmx", "/dev/kvm", "/dev/kqemu",
"/dev/rtc", "/dev/hpet","/dev/net/tun"
]

删除默认的虚拟网桥：

virsh net-destroy default
virsh net-undefine default

更新/etc/libvirt/libvirtd.conf配置文件：

listen_tls = 0
listen_tcp = 1
auth_tcp = "none"

编辑libvirtd_opts变量在/etc/init/libvirt-bin.conf配置文件中：

env libvirtd_opts="-d -l"

编辑/etc/default/libvirt-bin文件：

libvirtd_opts="-d -l"

重启libvirt服务使配置生效：

service libvirt-bin restart



4.4.OpenVSwitch

安装OpenVSwitch软件包：

apt-get install  openvswitch-switch openvswitch-datapath-dkms

service openvswitch-switch restart

创建网桥：
ovs-vsctl add-br br-int


4.5.Neutron

安装Neutron OpenVSwitch代理：

apt-get install neutron-plugin-openvswitch-agent

编辑OVS配置文件/etc/neutron/plugins/openvswitch/ovs_neutron_plugin.ini:

[OVS]
#tenant_network_type = gre
#tunnel_id_ranges = 1:1000
#integration_bridge = br-int
#tunnel_bridge = br-tun
#local_ip = 192.168.1.3
#enable_tunneling = True

network_vlan_ranges=physnet1,physnet2:100:200
tenant_network_type=vlan
enable_tunneling=False
integration_bridge=br-int
bridge_mappings=physnet1:br-ex1,physnet2:br-ex2

    
#Firewall driver for realizing quantum security group function
[SECURITYGROUP]
firewall_driver = neutron.agent.linux.iptables_firewall.OVSHybridIptablesFirewallDriver

编辑/etc/neutron/neutron.conf

rabbit_host = 192.168.1.1

[keystone_authtoken]
auth_host = 192.168.1.1
auth_port = 35357
auth_protocol = http
admin_tenant_name = service
admin_user = neutron
admin_password = service_pass
signing_dir = /var/lib/neutron/keystone-signing

[database]
connection = mysql://neutronUser:neutronPass@192.168.1.1/neutron

重启服务：
service neutron-plugin-openvswitch-agent restart


4.6.Nova

安装nova组件：

apt-get install nova-compute-kvm python-guestfs

注意：如果你的宿主机不支持kvm虚拟化，可把nova-compute-kvm换成nova-compute-qemu
同时/etc/nova/nova-compute.conf配置文件中的libvirt_type=qemu


在/etc/nova/api-paste.ini配置文件中修改认证信息：

[filter:authtoken]
paste.filter_factory = keystoneclient.middleware.auth_token:filter_factory
auth_host = 192.168.1.1
auth_port = 35357
auth_protocol = http
admin_tenant_name = service
admin_user = nova
admin_password = service_pass
signing_dirname = /tmp/keystone-signing-nova
# Workaround for https://bugs.launchpad.net/nova/+bug/1154809
auth_version = v2.0

编辑修改/etc/nova/nova.conf

[DEFAULT]
logdir=/var/log/nova
state_path=/var/lib/nova
lock_path=/run/lock/nova
verbose=True
api_paste_config=/etc/nova/api-paste.ini
compute_scheduler_driver=nova.scheduler.simple.SimpleScheduler
rabbit_host=192.168.1.1
nova_url=http://192.168.1.1:8774/v1.1/
sql_connection=mysql://novaUser:novaPass@192.168.1.1/nova
root_helper=sudo nova-rootwrap /etc/nova/rootwrap.conf

# Auth
use_deprecated_auth=false
auth_strategy=keystone

# Imaging service
glance_api_servers=192.168.1.1:9292
image_service=nova.image.glance.GlanceImageService

# Vnc configuration
novnc_enabled=true
novncproxy_base_url=http://10.141.123.202:6080/vnc_auto.html
novncproxy_port=6080
vncserver_proxyclient_address=192.168.1.3                   #这是与控制节点不同的地方。
vncserver_listen=0.0.0.0

# Network settings
network_api_class=nova.network.neutronv2.api.API
neutron_url=http://192.168.1.1:9696
neutron_auth_strategy=keystone
neutron_admin_tenant_name=service
neutron_admin_username=neutron
neutron_admin_password=service_pass
neutron_admin_auth_url=http://192.168.1.1:35357/v2.0
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

重启nova-*服务：

cd /etc/init.d/; for i in $( ls nova-* ); do service $i restart; done

检查所有nova服务是否正常启动：

nova-manage service list


4.7. 安装监控服务计算代理ceilometer

安装监控服务：
apt-get install ceilometer-agent-compute

配置修改/etc/nova/nova.conf:

...
[DEFAULT]
...
instance_usage_audit=True
instance_usage_audit_period=hour
notify_on_state_change=vm_and_task_state
notification_driver=nova.openstack.common.notifier.rpc_notifier
notification_driver=ceilometer.compute.nova_notifier

编辑/etc/ceilometer/ceilometer.conf，配置计算节点上Ceilometer的选项：

[publisher_rpc]
# Secret value for signing metering messages (string value)
metering_secret = cefafd2288d0e4e43005         #之前生成的密码

[DEFAULT]
rabbit_host = 192.168.1.1

[keystone_authtoken]
auth_host = 192.168.1.1
auth_port = 35357
auth_protocol = http
admin_tenant_name = service
admin_user = ceilometer
admin_password = service_pass

[service_credentials]
os_auth_url = http://192.168.1.1:5000/v2.0
os_username = ceilometer
os_tenant_name = service
os_password = service_pass
os_region_name = RegionOne

[DEFAULT]
log_dir = /var/log/ceilometer


重启服务：
service ceilometer-agent-compute restart





5.创建VM

5.1.flat network


1)设置环境变量：

vi creds-admin

#Paste the following:
export OS_TENANT_NAME=admin
export OS_USERNAME=admin
export OS_PASSWORD=admin_pass
export OS_AUTH_URL="http://10.10.10.1:5000/v2.0/"

source creds-admin

2) create tenant

keystone tenant-create --name project_one

keystone tenant-list
keystone role-list

keystone user-create --name=user_one --pass=user_one --tenant-id $put_id_of_project_one --email=user_one@domain.com
keystone user-role-add --tenant-id $put_id_of_project_one  --user-id $put_id_of_user_one --role-id $put_id_of_member_role


3) create network

neutron net-create Public1 --provider:network_type flat --provider:physical_network physnet1 --shared
neutron subnet-create Public1 192.168.2.0/24 --disable-dhcp --allocation-pool start=192.168.2.100,end=192.168.2.220

neutron net-create Public2 --provider:network_type flat --provider:physical_network physnet2 --shared
neutron subnet-create Public2 192.168.3.0/24 --disable-dhcp --allocation-pool start=192.168.3.100,end=192.168.3.220


neutron net-list
neutron subnet-list


4) go to web and create instance
http://10.10.10.1/horizon

user: user_one
password: user_one


5) 去除ip限制

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

./mkpy.sh firewall.py

6) 虚拟机可以ping通外面，外面ping不通虚拟机的问题
（可能是bug）

解决方法：

在web界面修改访问控制

修改安全组default规则
添加定制ICMP，TCP，UDP规则
包括出口，入口
端口-1


5.1.gre router network

参考grizzly
 

6.参考文档：
1.
http://docs.openstack.org/havana/install-guide/install/apt/openstack-install-guide-apt-havana.pdf

2.
https://github.com/mseknibilel/OpenStack-Grizzly-Install-Guide/blob/OVS_MultiNode/OpenStack_Grizzly_Install_Guide.rst

3.
http://www.cnblogs.com/awy-blog/p/3447176.html

4.
http://panpei.net.cn/2014/03/08/ceilometer-deploy-guide/

5.
http://www.nemosky.com/job/1331.html
