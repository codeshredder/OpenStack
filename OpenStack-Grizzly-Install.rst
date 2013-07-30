==========================================================
  OpenStack Grizzly Install Guide
==========================================================

.. contents::

Authors
==========

`codeshredder <https://github.com/codeshredder>`_ 

Reference
==========

大部分经验来自以下文档：

https://github.com/mseknibilel/OpenStack-Grizzly-Install-Guide

官方手册(install guide)

http://docs.openstack.org/grizzly/basic-install/apt/content/

http://docs.openstack.org/grizzly/openstack-compute/install/apt/content/

(block storage)

http://docs.openstack.org/grizzly/openstack-block-storage/admin/content/

代码(code)

https://github.com/openstack


What is it?
==============

It is for somebody who want an easy way to create a private OpenStack test environment. 


Overview
====================

Openstack是一个云计算框架。全部搭起来以后可以实现启动虚拟机，实现虚拟机之间以及虚拟机和外网之间的通讯，实现虚拟机的虚拟存储的分配和挂接。并且对虚拟的管理可以通过web来实现。

它包括以下几个重要组件。同时各个主要组件内部也有多个子组件，这些子组件有些是可以装在多个主机上，并且可以是多份，这也是系统容量扩展的关键。如Nova-compute,cinder-volume等今后会重点关注的几个组件。

:Nova: 各个主要组件的管理和交互。同时也是计算节点的主要承担者，负责虚拟机的启动关闭等管理。
:keystone: 权限控制。用于各个组件消息交互时的认证校验等。
:glance: 负责虚拟机镜像的管理
:quantum: 负责虚拟机之间，以及虚拟机和外部网络之间的网络管理。
:cinder: 负责虚拟机的块设备存储的管理。通俗的讲就是为虚拟机分配硬盘
:horizon: 提供一个web管理页面，这样不少需要命令行的操作，可以直观的在web上实现。


狭义上的Openstack本身可以看成一个管理框架，大部分代码用python编写。具体的功能需要用到各种开源组件，比如数据库的mysql，虚拟机的kvm，网络的openvswitch，存储的open-iscsi,iscsitarget等。

因此，对openstack的安装配置也分为2个部分，
一个是openstack各组件的配置，如nova.conf,api-paste.ini等。
另一部分就是功能组件本身的一些配置。一些是配置文件的如/etc/default/iscsitarget，另一些是通过组件的配置命令，如ietadm，iscsiadm等。其实从代码中也可以看到，openstack除了自身框架代码外，还有很多一部分driver代码，最终都会调用具体命令来完成功能。
例如，硬盘操作。在openstack中可以归纳到4个命令，create，delete，attach，deattch。create分解到具体命令，可能是先调用lvcreate创建lv，然后使用ietadm创建iscsi target，然后调用iscsiadm挂接target。

希望通过以上的一些原理描述，有助于对后面的安装配置过程的理解。

Requirements
============

安装步骤几乎都是抄的
https://github.com/mseknibilel/OpenStack-Grizzly-Install-Guide。
不过其实人家大部分也是抄的官方文档
http://docs.openstack.org/grizzly/basic-install/apt/content/。
不过技术文档和学习总结嘛，大多如此。。
本文的主要目的和价值在于对mseknibilel的注解以及原理说明，因为自己开始学习的时候也是看这几个文档，但总有某些细节没说清楚，
浪费了不少时间。顺便加一些自己的补充，比如cinder的部分。

openstack的安装首先必须要确定组网，现根据需求确定了组网以后，后续的配置才好以此调整。
我的组网如下：

:Node Role: NICs
:Control Node: eth0 (10.10.10.1), eth1 (192.168.1.1)
:Network Node: eth0 (optional), eth1 (192.168.1.2), eth2 (192.168.100.100)
:Compute Node: eth0 (optional), eth1 (192.168.1.3)
:Storage Node: eth0 (optional), eth1 (192.168.1.4)

* eth0的10.10.10.x是管理网络。只是方便用于ssh登陆到各个Node配置用。其中只有Control Node是必须的，因为需要以此IP访问web。
* eth1的192.168.0.x是内部网络。用于Openstack内部各个Node之间互通。原文内部网络有2个，个人觉得合成一个比较简单。
* eth2的192.168.100.x是外部网络。VM如果要和外网通，需要用到。
* 此外不在物理网络设置之内的还有VM网络，用于VM之间的通讯。VM分配的IP地址在此网络中。我们定为50.50.1.x。


本例把常用能分布式的部分分出来，包括网络，计算，存储，在此基础上，如果想合在一起只要合并配置即可，合比分容易的多。


Controller Node
============


Preparing Ubuntu
-----------------

* After you install Ubuntu 12.04 or 13.04 Server 64bits, Go in sudo mode and don't leave it until the end of this guide::

   sudo su

* Add Grizzly repositories [Only for Ubuntu 12.04]::

   apt-get install -y ubuntu-cloud-keyring 
   echo deb http://ubuntu-cloud.archive.canonical.com/ubuntu precise-updates/grizzly main >> /etc/apt/sources.list.d/grizzly.list

增加源，这个源是针对12.04(precise)的。如果是13.04就不需要了。

* Update your system::

   apt-get update -y
   apt-get upgrade -y
   apt-get dist-upgrade -y

Networking
------------

网络是外围配置的第一步。不同发行版的修改方式不同。下面这是ubuntu中修改/etc/network/interfaces文件。

* Only one NIC should have an internet access::

   #For Exposing OpenStack API over the internet
   auto eth1
   iface eth1 inet static
   address 10.10.10.1
   netmask 255.255.255.0
   gateway 10.10.10.1
   dns-nameservers 8.8.8.8

   #Not internet connected(used for OpenStack management)
   auto eth0
   iface eth0 inet static
   address 192.168.1.1
   netmask 255.255.255.0

* Restart the networking service::

   service networking restart

MySQL & RabbitMQ
------------

Openstack中很多位置有多个组件可以替代，比如数据库可以用mysql或者sqllite。AMQP也就是消息通讯用的，可以用RabbitMQ或者Qpid。
选择不同的组件配置时不一样的，所以一定要注意。这里选择了Mysql。后续配置中关联的配置就要注意sql_connection=和connection=这样的配置。

* Install MySQL::

   apt-get install -y mysql-server python-mysqldb

安装过程中会要求输入mysql密码。这个在后面mysql -u root -p后会要求输入。

* Configure mysql to accept all incoming requests::

   sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mysql/my.cnf
   service mysql restart

* Create these databases::

   mysql -u root -p
   
   #Keystone
   CREATE DATABASE keystone;
   GRANT ALL ON keystone.* TO 'keystoneUser'@'%' IDENTIFIED BY 'keystonePass';
   
   #Glance
   CREATE DATABASE glance;
   GRANT ALL ON glance.* TO 'glanceUser'@'%' IDENTIFIED BY 'glancePass';

   #Quantum
   CREATE DATABASE quantum;
   GRANT ALL ON quantum.* TO 'quantumUser'@'%' IDENTIFIED BY 'quantumPass';

   #Nova
   CREATE DATABASE nova;
   GRANT ALL ON nova.* TO 'novaUser'@'%' IDENTIFIED BY 'novaPass';      

   #Cinder
   CREATE DATABASE cinder;
   GRANT ALL ON cinder.* TO 'cinderUser'@'%' IDENTIFIED BY 'cinderPass';

   quit;

这里是把需要用到的数据库，先手动创建。用户名密码在后面各个sql_connection配置中会反复出现。

RabbitMQ
-------------------

AMQP选择了RabbitMQ，后面配置中看到的rabbit_host就和这个相关。如果选择Qpid，就要找Qpid字样的。在openstack代码中有个类似nova.conf.sample的文件，里面有比较全的配置项，供参考。

* Install RabbitMQ::

   apt-get install -y rabbitmq-server 

* Install NTP service::

   apt-get install -y ntp

 
Others
-------------------

* Install other services::

   apt-get install -y vlan bridge-utils

* Enable IP_Forwarding::

   sed -i 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/' /etc/sysctl.conf

   # To save you from rebooting, perform the following
   sysctl net.ipv4.ip_forward=1


Keystone
-------------------

keystone主要用于组件件通讯认证用的。这部分也是比较复杂。所以基于原原本本照抄。毕竟这部分不是我关注的重点，能跑就行。。

* Start by the keystone packages::

   apt-get install -y keystone

* Adapt the connection attribute in the /etc/keystone/keystone.conf to the new database::

   connection = mysql://keystoneUser:keystonePass@192.168.1.1/keystone

* Restart the identity service then synchronize the database::

   service keystone restart
   keystone-manage db_sync

* Fill up the keystone database using the two scripts available in the `Scripts folder <https://github.com/codeshredder/OpenStack-Experience/tree/master/OpenStack-Grizzly-Install>`_ of this git repository::

   #Modify the **HOST_IP** and **EXT_HOST_IP** variables before executing the scripts
   
   chmod +x keystone_basic.sh
   chmod +x keystone_endpoints_basic.sh

   ./keystone_basic.sh
   ./keystone_endpoints_basic.sh

为了防止原po删除或者修改，我也抄了一份。放在同级目录下。。

* Create a simple credential file and load it so you won't be bothered later::

   vi creds

   #Paste the following:
   export OS_TENANT_NAME=admin
   export OS_USERNAME=admin
   export OS_PASSWORD=admin_pass
   export OS_AUTH_URL="http://10.10.10.1:5000/v2.0/"

   # Load it:
   source creds

这里是设置环境变量用的，openstack相关的一些配置和查询命令，需要有一定的环境变量才能运行，主要是用于指示操作用户的。
上面表示是admin用户。如下面这个keystone命令，需要admin用户才能运行。
以后建立租户(tenant)的时候，针对不同的租户用户也需要修改个类似的文件。比如在租户用户下创建了一个volume，使用租户环境变量cinder list可以看到。如果用admin的环境变量就看不到。

* To test Keystone, we use a simple CLI command::

   keystone user-list

   +----------------------------------+-----------+---------+---------------------+
   |                id                |    name   | enabled |        email        |
   +----------------------------------+-----------+---------+---------------------+
   | b1676e4df7c6482189187aca5785246c |   admin   |   True  |   admin@domain.com  |
   | 464c8c6ecac24ae8b2bdd192ee8e4b72 |   cinder  |   True  |  cinder@domain.com  |
   | 75a1721b09df42fda648de7ad474f9bd |   glance  |   True  |  glance@domain.com  |
   | 28b053932b484b49bbc3f2af97dd0f2b |    nova   |   True  |   nova@domain.com   |
   | 3e8e411b4bea4a95bb4bd83ecc287268 |  quantum  |   True  |  quantum@domain.com |
   +----------------------------------+-----------+---------+---------------------+

Glance
-------------------

Glance主要用来做镜像管理，用过虚拟机的都知道跑虚拟机需要用到镜像。这个就是用来把可用的镜像输入到Openstack中，供nova起虚拟机时用。

* We Move now to Glance installation::

   apt-get install -y glance

* Update /etc/glance/glance-api-paste.ini with::

   [filter:authtoken]
   paste.filter_factory = keystoneclient.middleware.auth_token:filter_factory
   delay_auth_decision = true
   auth_host = 192.168.1.1
   auth_port = 35357
   auth_protocol = http
   admin_tenant_name = service
   admin_user = glance
   admin_password = service_pass

* Update the /etc/glance/glance-registry-paste.ini with::

   [filter:authtoken]
   paste.filter_factory = keystoneclient.middleware.auth_token:filter_factory
   auth_host = 192.168.1.1
   auth_port = 35357
   auth_protocol = http
   admin_tenant_name = service
   admin_user = glance
   admin_password = service_pass

* Update /etc/glance/glance-api.conf with::

   sql_connection = mysql://glanceUser:glancePass@192.168.1.1/glance

* And::

   [paste_deploy]
   flavor = keystone
   
* Update the /etc/glance/glance-registry.conf with::

   sql_connection = mysql://glanceUser:glancePass@192.168.1.1/glance

* And::

   [paste_deploy]
   flavor = keystone

* Restart the glance-api and glance-registry services::

   service glance-api restart; service glance-registry restart

* Synchronize the glance database::

   glance-manage db_sync

* To test Glance, upload the cirros cloud image directly from the internet::

   glance image-create --name cirros --is-public true --container-format bare --disk-format qcow2 --location https://launchpad.net/cirros/trunk/0.3.0/+download/cirros-0.3.0-x86_64-disk.img

如果不好联网可以先下下来，再使用命令::

   glance image-create --name cirros --is-public true --container-format bare --disk-format qcow2 --location /home/cirros-0.3.0-x86_64-disk.img

目前比较好用的镜像文件有f16-x86_64-openstack-sda.qcow2和cirros-0.3.0-x86_64-disk.img，请自行搜索下载。

* Now list the image to see what you have just uploaded::

   glance image-list
   
   +--------------------------------------+--------+-------------+------------------+-----------+--------+
   | ID                                   | Name   | Disk Format | Container Format | Size      | Status |
   +--------------------------------------+--------+-------------+------------------+-----------+--------+
   | 4183788b-c581-4286-9ace-781c84496c68 | cirros | qcow2       | bare             | 9761280   | active |
   | e14a5b52-e23a-459f-a881-78edd063dc7a | fc     | qcow2       | bare             | 213581824 | active |
   +--------------------------------------+--------+-------------+------------------+-----------+--------+

另外horizon装好之后也可以通过web来添加镜像。比命令方便直观。

Quantum
-------------------

网络的组件也有多种，这里选择的是openvswitch。如果选择linuxbridge，配置就会不一样。比如修改的plugins文件不同。

* Install the Quantum server and the OpenVSwitch package collection::

   apt-get install -y quantum-server

* Edit the OVS plugin configuration file /etc/quantum/plugins/openvswitch/ovs_quantum_plugin.ini with:: 

   #Under the database section
   [DATABASE]
   sql_connection = mysql://quantumUser:quantumPass@192.168.1.1/quantum

   #Under the OVS section
   [OVS]
   tenant_network_type = gre
   tunnel_id_ranges = 1:1000
   enable_tunneling = True

   #Firewall driver for realizing quantum security group function
   [SECURITYGROUP]
   firewall_driver = quantum.agent.linux.iptables_firewall.OVSHybridIptablesFirewallDriver

需要注意的是[OVS]和下面的要放在一起。默认文件末尾有一些参考配置。但是上面[OVS]是打开的。建议#掉，再在末尾添加。

* Edit /etc/quantum/api-paste.ini ::

   [filter:authtoken]
   paste.filter_factory = keystoneclient.middleware.auth_token:filter_factory
   auth_host = 192.168.1.1
   auth_port = 35357
   auth_protocol = http
   admin_tenant_name = service
   admin_user = quantum
   admin_password = service_pass

* Update the /etc/quantum/quantum.conf::

   core_plugin = quantum.plugins.openvswitch.ovs_quantum_plugin.OVSQuantumPluginV2
   [keystone_authtoken]
   auth_host = 192.168.1.1
   auth_port = 35357
   auth_protocol = http
   admin_tenant_name = service
   admin_user = quantum
   admin_password = service_pass
   signing_dir = /var/lib/quantum/keystone-signing

这里需要指定使用的plugin。默认是Openvswitch。原文因为是默认所以没写。如果使用linuxbridge，这里要改，并且plugin的文件也要对应修改。

* Restart the quantum server::

   service quantum-server restart


Nova
------------------

* Start by installing nova components::

   apt-get install -y nova-api nova-cert novnc nova-consoleauth nova-scheduler nova-novncproxy nova-doc nova-conductor

注意这里没有安装nova-compute-kvm。分布式的原理大致都是将api,scheduler等安装在控制节点，而功能的如compute安装到分布节点。

* Now modify authtoken section in the /etc/nova/api-paste.ini file to this::

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

* Modify the /etc/nova/nova.conf like this::

   [DEFAULT]
   debug=false
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
   network_api_class=nova.network.quantumv2.api.API
   quantum_url=http://192.168.1.1:9696
   quantum_auth_strategy=keystone
   quantum_admin_tenant_name=service
   quantum_admin_username=quantum
   quantum_admin_password=service_pass
   quantum_admin_auth_url=http://192.168.1.1:35357/v2.0
   libvirt_vif_driver=nova.virt.libvirt.vif.LibvirtHybridOVSBridgeDriver
   linuxnet_interface_driver=nova.network.linux_net.LinuxOVSInterfaceDriver
   #If you want Quantum + Nova Security groups
   firewall_driver=nova.virt.firewall.NoopFirewallDriver
   security_group_api=quantum
   #If you want Nova Security groups only, comment the two lines above and uncomment line -1-.
   #-1-firewall_driver=nova.virt.libvirt.firewall.IptablesFirewallDriver

   #Metadata
   service_quantum_metadata_proxy = True
   quantum_metadata_proxy_shared_secret = helloOpenStack

   # Compute #
   compute_driver=libvirt.LibvirtDriver

   # Cinder #
   volume_api_class=nova.volume.cinder.API
   osapi_volume_listen_port=5900

对分布式系统中，最重要的是rabbit_host设置，上面提到了这是作为AMQP组件的rabbitMQ。分布在各个节点中的组件主要靠这个通讯。
另外debug=true可以打开调试开关，日志会保存在logdir所设置的目录下。方便调试。同理，其他组件.conf文件也可以设置debug。

* Synchronize your database::

   nova-manage db sync

* Restart nova-* services::

   cd /etc/init.d/; for i in $( ls nova-* ); do sudo service $i restart; done   

* Check for the smiling faces on nova-* services to confirm your installation::

   nova-manage service list

Cinder
--------------

* Install the required packages::

   apt-get install -y cinder-api cinder-scheduler

作为cinder分布式模型，这里也只安装控制组件。对cinder来说，需要在3个节点安装东西，一个是控制节点的api和scheduler，
一个是存储节点的cinder-volume服务以及功能组件iscsitarget iscsitarget-dkms(iscsi的targe端)，还有一个是计算节点的open-iscsi(iscsi的initiator端)。
有一些通过apt的依赖关系安装了，所以可能没注意到。


* Configure /etc/cinder/api-paste.ini like the following::

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
   signing_dir = /var/lib/cinder

* Edit the /etc/cinder/cinder.conf to::

   [DEFAULT]
   rootwrap_config=/etc/cinder/rootwrap.conf
   sql_connection = mysql://cinderUser:cinderPass@192.168.1.1/cinder
   api_paste_config = /etc/cinder/api-paste.ini
   iscsi_helper=ietadm
   volume_name_template = volume-%s
   volume_group = cinder-volumes
   verbose = True
   auth_strategy = keystone
   rabbit_host=192.168.1.1

因为本身不提供cinder-volume服务，所以iscsi_ip_address不用设置。同理，iscsi_helper是否设置关系也不大，主要在存储节点要设置。
不过还是讲一下，iscsi的target端有2个可选，一个是tgt，一个是iet。默认是tgt。不过由于存储和计算不在一个节点，实际上是网络硬盘的模式，
类似SAN。个人经验选择iet好点。

* Then, synchronize your database::

   cinder-manage db sync

* Restart the cinder services::

   cd /etc/init.d/; for i in $( ls cinder-* ); do sudo service $i restart; done

* Verify if cinder services are running::

   cd /etc/init.d/; for i in $( ls cinder-* ); do sudo service $i status; done
   cinder-api start/running, process 1737
   cinder-scheduler start/running, process 1747

Horizon
--------------

* To install horizon, proceed like this ::

   apt-get install -y openstack-dashboard memcached

* If you don't like the OpenStack ubuntu theme, you can remove the package to disable it::

   dpkg --purge openstack-dashboard-ubuntu-theme 

* Reload Apache and memcached::

   service apache2 restart; service memcached restart

正常情况下，这时访问 http://10.10.10.1/horizon 就可以看到web界面了。
用户admin,密码admin_pass。有些可能会报错，因为network,compute,storage节点还没安装。

Network Node
================

Preparing the Node
------------------

* After you install Ubuntu 12.04 or 13.04 Server 64bits, Go in sudo mode::

   sudo su

* Add Grizzly repositories [Only for Ubuntu 12.04]::

   apt-get install -y ubuntu-cloud-keyring 
   echo deb http://ubuntu-cloud.archive.canonical.com/ubuntu precise-updates/grizzly main >> /etc/apt/sources.list.d/grizzly.list

* Update your system::

   apt-get update -y
   apt-get upgrade -y
   apt-get dist-upgrade -y

* Install ntp service::

   apt-get install -y ntp

* Configure the NTP server to follow the controller node::
   
   #Comment the ubuntu NTP servers
   sed -i 's/server 0.ubuntu.pool.ntp.org/#server 0.ubuntu.pool.ntp.org/g' /etc/ntp.conf
   sed -i 's/server 1.ubuntu.pool.ntp.org/#server 1.ubuntu.pool.ntp.org/g' /etc/ntp.conf
   sed -i 's/server 2.ubuntu.pool.ntp.org/#server 2.ubuntu.pool.ntp.org/g' /etc/ntp.conf
   sed -i 's/server 3.ubuntu.pool.ntp.org/#server 3.ubuntu.pool.ntp.org/g' /etc/ntp.conf
   
   #Set the network node to follow up your conroller node
   sed -i 's/server ntp.ubuntu.com/server 192.168.1.1/g' /etc/ntp.conf

   service ntp restart  

* Install other services::

   apt-get install -y vlan bridge-utils

* Enable IP_Forwarding::

   sed -i 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/' /etc/sysctl.conf
   
   # To save you from rebooting, perform the following
   sysctl net.ipv4.ip_forward=1

Networking
------------

* 3 NICs must be present::
   
   # OpenStack management
   auto eth0
   iface eth0 inet static
   address 10.10.10.2
   netmask 255.255.255.0

   # VM Configuration
   auto eth1
   iface eth1 inet static
   address 192.168.1.2
   netmask 255.255.255.0

   # VM internet Access
   auto eth2
   iface eth2 inet static
   address 192.168.100.100
   netmask 255.255.255.0

OpenVSwitch (Part1)
------------------

* Install the openVSwitch::

   apt-get install -y openvswitch-switch openvswitch-datapath-dkms

* Create the bridges::

   #br-int will be used for VM integration  
   ovs-vsctl add-br br-int

   #br-ex is used to make to VM accessible from the internet
   ovs-vsctl add-br br-ex


由于网络组件选择了openvswitch，所以ovs需要配置一些东西。这里br-int,br-tun,br-ex命名是有门道的，建议不修改。
因为有些配置项有默认值，所以有些攻略没有提到。一些逻辑清晰的人在理解上会有断链。
br-int,br-tun在/etc/quantum/plugins/openvswitch/ovs_quantum_plugin.ini等提到。
br-int在/etc/nova/nova-compute.conf等提到。
br-ex在/etc/quantum/l3_agent.ini等提到。
br-int用于虚拟机内部。br-tun用于gre节点之间过渡。br-ex用于连接外网。


Quantum
------------------

* Install the Quantum openvswitch agent, l3 agent and dhcp agent::

   apt-get -y install quantum-plugin-openvswitch-agent quantum-dhcp-agent quantum-l3-agent quantum-metadata-agent

* Edit /etc/quantum/api-paste.ini::

   [filter:authtoken]
   paste.filter_factory = keystoneclient.middleware.auth_token:filter_factory
   auth_host = 192.168.1.1
   auth_port = 35357
   auth_protocol = http
   admin_tenant_name = service
   admin_user = quantum
   admin_password = service_pass

* Edit the OVS plugin configuration file /etc/quantum/plugins/openvswitch/ovs_quantum_plugin.ini with:: 

   #Under the database section
   [DATABASE]
   sql_connection = mysql://quantumUser:quantumPass@192.168.1.1/quantum

   #Under the OVS section
   [OVS]
   tenant_network_type = gre
   tunnel_id_ranges = 1:1000
   integration_bridge = br-int
   tunnel_bridge = br-tun
   local_ip = 192.168.1.2
   enable_tunneling = True

   #Firewall driver for realizing quantum security group function
   [SECURITYGROUP]
   firewall_driver = quantum.agent.linux.iptables_firewall.OVSHybridIptablesFirewallDriver


ovs的tenant_netwoke_type有多种选项，这里选择gre通道方式。因为网络结构是分布式的，由nework node加上各个node的quantum_agent组成。
关注local_ip。

* Update /etc/quantum/metadata_agent.ini::
   
   # The Quantum user information for accessing the Quantum API.
   auth_url = http://192.168.1.1:35357/v2.0
   auth_region = RegionOne
   admin_tenant_name = service
   admin_user = quantum
   admin_password = service_pass

   # IP address used by Nova metadata server
   nova_metadata_ip = 192.168.1.1

   # TCP Port used by Nova metadata server
   nova_metadata_port = 8775

   metadata_proxy_shared_secret = helloOpenStack

* Make sure that your rabbitMQ IP in /etc/quantum/quantum.conf is set to the controller node::

   rabbit_host = 192.168.1.1

   #And update the keystone_authtoken section

   [keystone_authtoken]
   auth_host = 192.168.1.1
   auth_port = 35357
   auth_protocol = http
   admin_tenant_name = service
   admin_user = quantum
   admin_password = service_pass
   signing_dir = /var/lib/quantum/keystone-signing

注意rabbit_host，无处不在的rabbitmq。

* Edit /etc/sudoers to give it full access like this (This is unfortunatly mandatory) ::

   vi /etc/sudoers.d/quantum_sudoers
   
   #Modify the quantum user
   quantum ALL=(ALL) NOPASSWD: ALL

* Restart all the services::

   cd /etc/init.d/; for i in $( ls quantum-* ); do sudo service $i restart; done

OpenVSwitch (Part2)
------------------
* Edit the eth2 in /etc/network/interfaces to become like this::

   # VM internet Access
   auto eth2
   iface eth2 inet manual
   up ifconfig $IFACE 0.0.0.0 up
   up ip link set $IFACE promisc on
   down ip link set $IFACE promisc off
   down ifconfig $IFACE down

由于eth2加入到br-ex后，即使有IP网络也不会通，所以这里设置为空。如果还需要对外通讯，需要把通过ifconfig br-ex或者下面提到的修改/etc/network/interfaces。类似网口变成br-ex。

* Add the eth2 to the br-ex::

   #Internet connectivity will be lost after this step but this won't affect OpenStack's work
   ovs-vsctl add-port br-ex eth2

   #If you want to get internet connection back, you can assign the eth2's IP address to the br-ex in the /etc/network/interfaces file.


Compute Node
=========================

Preparing the Node
------------------

* After you install Ubuntu 12.04 or 13.04 Server 64bits, Go in sudo mode::

   sudo su

* Add Grizzly repositories [Only for Ubuntu 12.04]::

   apt-get install -y ubuntu-cloud-keyring 
   echo deb http://ubuntu-cloud.archive.canonical.com/ubuntu precise-updates/grizzly main >> /etc/apt/sources.list.d/grizzly.list


* Update your system::

   apt-get update -y
   apt-get upgrade -y
   apt-get dist-upgrade -y

* Install ntp service::

   apt-get install -y ntp

* Configure the NTP server to follow the controller node::
   
   #Comment the ubuntu NTP servers
   sed -i 's/server 0.ubuntu.pool.ntp.org/#server 0.ubuntu.pool.ntp.org/g' /etc/ntp.conf
   sed -i 's/server 1.ubuntu.pool.ntp.org/#server 1.ubuntu.pool.ntp.org/g' /etc/ntp.conf
   sed -i 's/server 2.ubuntu.pool.ntp.org/#server 2.ubuntu.pool.ntp.org/g' /etc/ntp.conf
   sed -i 's/server 3.ubuntu.pool.ntp.org/#server 3.ubuntu.pool.ntp.org/g' /etc/ntp.conf
   
   #Set the compute node to follow up your conroller node
   sed -i 's/server ntp.ubuntu.com/server 192.168.1.1/g' /etc/ntp.conf

   service ntp restart  

* Install other services::

   apt-get install -y vlan bridge-utils

* Enable IP_Forwarding::

   sed -i 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/' /etc/sysctl.conf
   
   # To save you from rebooting, perform the following
   sysctl net.ipv4.ip_forward=1

Networking
------------

* Perform the following::
   
   # OpenStack management
   auto eth0
   iface eth0 inet static
   address 10.10.10.3
   netmask 255.255.255.0

   # VM Configuration
   auto eth1
   iface eth1 inet static
   address 192.168.1.3
   netmask 255.255.255.0

KVM
------------------

* make sure that your hardware enables virtualization::

   apt-get install -y cpu-checker
   kvm-ok

* Normally you would get a good response. Now, move to install kvm and configure it::

   apt-get install -y kvm libvirt-bin pm-utils

虚拟机框架选择了kvm。openstack也支持xen,vmware等。

* Edit the cgroup_device_acl array in the /etc/libvirt/qemu.conf file to::

   cgroup_device_acl = [
   "/dev/null", "/dev/full", "/dev/zero",
   "/dev/random", "/dev/urandom",
   "/dev/ptmx", "/dev/kvm", "/dev/kqemu",
   "/dev/rtc", "/dev/hpet","/dev/net/tun"
   ]

注意和默认比增加了"/dev/net/tun"。

* Delete default virtual bridge ::

   virsh net-destroy default
   virsh net-undefine default

* Enable live migration by updating /etc/libvirt/libvirtd.conf file::

   listen_tls = 0
   listen_tcp = 1
   auth_tcp = "none"

* Edit libvirtd_opts variable in /etc/init/libvirt-bin.conf file::

   env libvirtd_opts="-d -l"

* Edit /etc/default/libvirt-bin file ::

   libvirtd_opts="-d -l"

* Restart the libvirt service to load the new values::

   service libvirt-bin restart

OpenVSwitch
------------------

* Install the openVSwitch::

   apt-get install -y openvswitch-switch openvswitch-datapath-dkms

* Create the bridges::

   #br-int will be used for VM integration  
   ovs-vsctl add-br br-int

每个节点都需要加入到br-int。

Quantum
------------------

* Install the Quantum openvswitch agent::

   apt-get -y install quantum-plugin-openvswitch-agent

因为虚拟机需要网络支持，所以要装quantum。如果VM不需要网络，这部分可以不用。

* Edit the OVS plugin configuration file /etc/quantum/plugins/openvswitch/ovs_quantum_plugin.ini with:: 

   #Under the database section
   [DATABASE]
   sql_connection = mysql://quantumUser:quantumPass@192.168.1.1/quantum

   #Under the OVS section
   [OVS]
   tenant_network_type = gre
   tunnel_id_ranges = 1:1000
   integration_bridge = br-int
   tunnel_bridge = br-tun
   local_ip = 192.168.1.3
   enable_tunneling = True
   
   #Firewall driver for realizing quantum security group function
   [SECURITYGROUP]
   firewall_driver = quantum.agent.linux.iptables_firewall.OVSHybridIptablesFirewallDriver

注意local_ip为本节点ip。

* Make sure that your rabbitMQ IP in /etc/quantum/quantum.conf is set to the controller node::
   
   rabbit_host = 192.168.1.1

   #And update the keystone_authtoken section

   [keystone_authtoken]
   auth_host = 192.168.1.1
   auth_port = 35357
   auth_protocol = http
   admin_tenant_name = service
   admin_user = quantum
   admin_password = service_pass
   signing_dir = /var/lib/quantum/keystone-signing

* Restart all the services::

   service quantum-plugin-openvswitch-agent restart


Nova
------------------

* Install nova's required components for the compute node::

   apt-get install -y nova-compute-kvm

* Now modify authtoken section in the /etc/nova/api-paste.ini file to this::

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

* Edit /etc/nova/nova-compute.conf file ::
   
   [DEFAULT]
   libvirt_type=kvm
   compute_driver=libvirt.LibvirtDriver
   libvirt_ovs_bridge=br-int
   libvirt_vif_type=ethernet
   libvirt_vif_driver=nova.virt.libvirt.vif.LibvirtHybridOVSBridgeDriver
   libvirt_use_virtio_for_bridges=True

注意br-int。

* Modify the /etc/nova/nova.conf like this::

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
   vncserver_proxyclient_address=192.168.1.3
   vncserver_listen=0.0.0.0

   # Network settings
   network_api_class=nova.network.quantumv2.api.API
   quantum_url=http://192.168.1.1:9696
   quantum_auth_strategy=keystone
   quantum_admin_tenant_name=service
   quantum_admin_username=quantum
   quantum_admin_password=service_pass
   quantum_admin_auth_url=http://192.168.1.1:35357/v2.0
   libvirt_vif_driver=nova.virt.libvirt.vif.LibvirtHybridOVSBridgeDriver
   linuxnet_interface_driver=nova.network.linux_net.LinuxOVSInterfaceDriver
   #If you want Quantum + Nova Security groups
   firewall_driver=nova.virt.firewall.NoopFirewallDriver
   security_group_api=quantum
   #If you want Nova Security groups only, comment the two lines above and uncomment line -1-.
   #-1-firewall_driver=nova.virt.libvirt.firewall.IptablesFirewallDriver
   
   #Metadata
   service_quantum_metadata_proxy = True
   quantum_metadata_proxy_shared_secret = helloOpenStack

   # Cinder #
   volume_api_class=nova.volume.cinder.API
   osapi_volume_listen_port=5900
   cinder_catalog_info=volume:cinder:internalURL

注意vncserver_proxyclient_address为本node地址。

* Restart nova-* services::

   cd /etc/init.d/; for i in $( ls nova-* ); do sudo service $i restart; done   

* Check for the smiling faces on nova-* services to confirm your installation(on control node as admin)::

   nova-manage service list


Storage Node
=========================

Preparing the Node
------------------

* After you install Ubuntu 12.04 or 13.04 Server 64bits, Go in sudo mode::

   sudo su

* Add Grizzly repositories [Only for Ubuntu 12.04]::

   apt-get install -y ubuntu-cloud-keyring 
   echo deb http://ubuntu-cloud.archive.canonical.com/ubuntu precise-updates/grizzly main >> /etc/apt/sources.list.d/grizzly.list

* Update your system::

   apt-get update -y
   apt-get upgrade -y
   apt-get dist-upgrade -y

* Install ntp service::

   apt-get install -y ntp

* Configure the NTP server to follow the controller node::
   
   #Comment the ubuntu NTP servers
   sed -i 's/server 0.ubuntu.pool.ntp.org/#server 0.ubuntu.pool.ntp.org/g' /etc/ntp.conf
   sed -i 's/server 1.ubuntu.pool.ntp.org/#server 1.ubuntu.pool.ntp.org/g' /etc/ntp.conf
   sed -i 's/server 2.ubuntu.pool.ntp.org/#server 2.ubuntu.pool.ntp.org/g' /etc/ntp.conf
   sed -i 's/server 3.ubuntu.pool.ntp.org/#server 3.ubuntu.pool.ntp.org/g' /etc/ntp.conf
   
   #Set the compute node to follow up your conroller node
   sed -i 's/server ntp.ubuntu.com/server 192.168.1.1/g' /etc/ntp.conf

   service ntp restart  

* Install other services::

   apt-get install -y vlan bridge-utils

* Enable IP_Forwarding::

   sed -i 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/' /etc/sysctl.conf
   
   # To save you from rebooting, perform the following
   sysctl net.ipv4.ip_forward=1


下面这部分理论上应该是不需要的。本节点只要安装后面章节的内容应该就可以了。但是通讯相关的如rabbitMQ部分似乎并没有被apt-get自动包含到。
经过几次试验，也没有找到需要安装什么包才能让通讯畅通。最后只能参考compute的方案。只安装compute节点的包，但不配置。
仅是为了解决storage node和control node的通讯问题::

   apt-get install -y cpu-checker
   apt-get install -y kvm libvirt-bin pm-utils
   apt-get install -y openvswitch-switch openvswitch-datapath-dkms
   apt-get -y install quantum-plugin-openvswitch-agent
   apt-get install -y nova-compute-kvm


Networking
------------

* Perform the following::
   
   # OpenStack management
   auto eth0
   iface eth0 inet static
   address 10.10.10.4
   netmask 255.255.255.0

   # VM Configuration
   auto eth1
   iface eth1 inet static
   address 192.168.1.4
   netmask 255.255.255.0


Cinder
--------------

* Install the required packages::

   apt-get install -y cinder-volume iscsitarget iscsitarget-dkms

由于openstack默认装tgt。所以这里安装iet时可能会冲突。
需要先用lsof -i:3260检查端口。如果tgt已经运行，则需要先停止tgt服务再安装。最终要保证iet正确运行。
::

   /etc/init.d/tgt stop

* tgt运行时::

   lsof -i:3260
   COMMAND  PID USER   FD   TYPE DEVICE SIZE/OFF NODE NAME
   tgtd    1810 root    4u  IPv4   1406      0t0  TCP *:3260 (LISTEN)
   tgtd    1810 root    5u  IPv6   1407      0t0  TCP *:3260 (LISTEN)
   tgtd    1813 root    4u  IPv4   1406      0t0  TCP *:3260 (LISTEN)
   tgtd    1813 root    5u  IPv6   1407      0t0  TCP *:3260 (LISTEN)

* iet运行时::

   lsof -i:3260
   COMMAND   PID USER   FD   TYPE DEVICE SIZE/OFF NODE NAME
   ietd    39894 root    7u  IPv4 225635      0t0  TCP *:3260 (LISTEN)
   ietd    39894 root    8u  IPv6 225636      0t0  TCP *:3260 (LISTEN)

* Configure the iscsi services::

   sed -i 's/false/true/g' /etc/default/iscsitarget

* Restart the services::
   
   service iscsitarget start


* Configure /etc/cinder/api-paste.ini like the following::

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
   signing_dir = /var/lib/cinder

* Edit the /etc/cinder/cinder.conf to::

   [DEFAULT]
   rootwrap_config=/etc/cinder/rootwrap.conf
   sql_connection = mysql://cinderUser:cinderPass@192.168.1.1/cinder
   api_paste_config = /etc/cinder/api-paste.ini
   iscsi_helper=ietadm
   volume_name_template = volume-%s
   volume_group = cinder-volumes
   verbose = True
   auth_strategy = keystone
   rabbit_host = 192.168.1.1
   iscsi_ip_address = 192.168.1.4

这个配置文件中需要注意的是iscsi_helper=ietadm表示使用了iet。volume_group = cinder-volumes，这个名字在后面vgcreate的时候要用到。
rabbit_host = 192.168.1.1和iscsi_ip_address = 192.168.1.4用来和控制节点相连。iscsi_ip_address为本node的ip。


* Finally, don't forget to create a volumegroup and name it cinder-volumes::

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

* Proceed to create the physical volume then the volume group::

   pvcreate /dev/loop2
   vgcreate cinder-volumes /dev/loop2

**Note:** Beware that this volume group gets lost after a system reboot. (Click `Here <https://github.com/mseknibilel/OpenStack-Folsom-Install-guide/blob/master/Tricks%26Ideas/load_volume_group_after_system_reboot.rst>`_ to know how to load it after a reboot) 

原文提供的是文件作为存储。实际上我们可以把实际的分区作为存储。比如我有个空分区/dev/sda4，可以这样::

   pvcreate /dev/sda4
   vgcreate cinder-volumes /dev/sda4

整个存储系统的结构是这样的::

   kvm -> open-iscsi(initiator) ---(net)---> iscsitarget(target) -> lvm -> file(/dev/loop2) or partition(/dev/sda4)。


* Restart the cinder services::

   cd /etc/init.d/; for i in $( ls cinder-* ); do sudo service $i restart; done

* Verify if cinder services are running::

   cd /etc/init.d/; for i in $( ls cinder-* ); do sudo service $i status; done
   cinder-volume start/running, process 41513

* Verify if cinder host are running(on control node as admin)::

   cinder-manage host list


Start VM
=========================

To start your first VM, we first need to create a new tenant, user and internal network.

* Create a new tenant ::

   keystone tenant-create --name project_one

* Create a new user and assign the member role to it in the new tenant (keystone role-list to get the appropriate id)::

   keystone tenant-list
   keystone user-create --name=user_one --pass=user_one --tenant-id $put_id_of_project_one --email=user_one@domain.com
   keystone role-list
   keystone user-role-add --tenant-id $put_id_of_project_one  --user-id $put_id_of_user_one --role-id $put_id_of_member_role

* Create a new network for the tenant::

   quantum net-create --tenant-id $put_id_of_project_one net_proj_one
   quantum net-list

* Create a new subnet inside the new tenant network::

   quantum subnet-create --tenant-id $put_id_of_project_one net_proj_one 50.50.1.0/24
   quantum subnet-list

* Create a dhcp agent::

   quantum agent-list (to get the dhcp agent id)
   quantum dhcp-agent-network-add $dhcp_agent_id net_proj_one

* Create a router for the new tenant::

   quantum router-create --tenant-id $put_id_of_project_one router_proj_one
   quantum router-list

* Add the router to the running l3 agent (if it wasn't automatically added)::

   quantum agent-list (to get the l3 agent id)
   quantum l3-agent-router-add $l3_agent_id router_proj_one

* Add the router to the subnet::

   quantum router-interface-add $put_router_proj_one_id_here $put_subnet_id_here

* Restart all quantum services::

   cd /etc/init.d/; for i in $( ls quantum-* ); do sudo service $i restart; done

* Create an external network with the tenant id belonging to the admin tenant (keystone tenant-list to get the appropriate id)::

   quantum net-create --tenant-id $put_id_of_admin_tenant ext_net --router:external=True

**Note:** tenant-id is admin here

* Create a subnet for the floating ips::

   quantum subnet-create --tenant-id $put_id_of_admin_tenant --allocation-pool start=192.168.100.102,end=192.168.100.150 --gateway 192.168.100.1 ext_net 192.168.100.100/24 --enable_dhcp=False

**Note:** tenant-id is admin here

* Set your router's gateway to the external network:: 

   quantum router-gateway-set $put_router_proj_one_id_here $put_id_of_ext_net_here

* Source creds relative to your project one tenant now::

   vi creds_proj_one

   #Paste the following:
   export OS_TENANT_NAME=project_one
   export OS_USERNAME=user_one
   export OS_PASSWORD=user_one
   export OS_AUTH_URL="http://10.10.10.1:5000/v2.0/"

   source creds_proj_one

* Add this security rules to make your VMs pingable::

   nova --no-cache secgroup-add-rule default icmp -1 -1 0.0.0.0/0
   nova --no-cache secgroup-add-rule default tcp 22 22 0.0.0.0/0


到此为止，配置基本完成。大致原理就是先要创建一个租户，之后所有的资源管理，如虚拟机(instance),网络(network)，存储(volume)都是基于这个用户的。
对应的用户操作也需要使用creds_proj_one的环境变量。

创建2个网络。一个是VM内部网络，另一个是出外网的网络，并且创建一个router，把这两个网络连在一起。

至于floatingip。从下面的操作可以看出来，虚拟机启动后分配的内网IP，如果要出外网，需要分配一个外网ip也就是floatingip，并且把这个外网ip关联给这个虚拟机。

使用部分可以使用horizon的web界面操作。简洁美观。

* Start by allocating a floating ip to the project one tenant::

   quantum floatingip-create ext_net

* Start a VM::

   nova --no-cache boot --image $id_myFirstImage --flavor 1 my_first_vm 

* pick the id of the port corresponding to your VM::

   quantum port-list

* Associate the floating IP to your VM::

   quantum floatingip-associate $put_id_floating_ip $put_id_vm_port

That's it ! ping your VM and enjoy your OpenStack.


另外补充下volume的用法。volume的操作包括create,delete,attach,dettach。create和delete仅和存储节点相关，只负责创建删除硬盘。
而attach和dettach则负责把创建好的硬盘挂接到具体的虚拟机中。需要涉及compute node。

openstack中大量用到uuid。命令行经常要用到很长的id作为关联用。需要注意如上面命令中的$put_id_of_admin_tenant等，都需要查询替换成实际系统中的id。


* Rest API

OpenStack CLI调用的是rest api. 可以使用--debug查看每条命令整个调用rest api的过程,例如::

   keystone --debug tenant-list


Licensing
============

This project is licensed under Creative Commons License.

To view a copy of this license, visit [ http://creativecommons.org/licenses/ ].

Contacts
===========

codeshredder  : evilforce@gmail.com

