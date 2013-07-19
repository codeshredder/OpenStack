==========================================================
  Cinder iscsi analysis
==========================================================

.. contents::


Authors
==========

`codeshredder <https://github.com/codeshredder>`_ 

Overview
====================

openstack是一个管理套件，业务功能部分主要还是由各个开源组件集合完成。openstack的操作最终会变成各个功能组件自己的配置命令。

根据cinder的使用情况，以及代码分析。猜测出cinder的一些工作原理。并试图将组件剥离出openstack。


首先一个网络存储系统，需要的组件有:

1）存储使用者。指使用存储的KVM组件

2）存储提供者。包括直接提供给虚拟机使用的存储（initiator部分）以及具体的存储物理介质管理(target部分)。target的物理存储可以使用LVM。


按照节点来分。target作为一个存储节点，而initiator和kvm组成一个计算节点。


ISCSI Target Node
====================

安装iscsitarget iscsitarget-dkms(target部分)。

(target程序可以选择tgt或者iet，本例使用iet。如果是tgt，命令会有不同，如tgt-admin -s等)

安装LVM::

   #apt-get install lvm2

使用物理分区作为vg::

   #pvcreate /dev/sda4
   #vgcreate cinder-volumes /dev/sda4

安装target程序::

   #apt-get install iscsitarget iscsitarget-dkms
   
   sed -i 's/false/true/g' /etc/default/iscsitarget
   
   service iscsitarget start

查看target服务是否正常::

   #lsof -i:3260
   COMMAND  PID USER   FD   TYPE DEVICE SIZE/OFF NODE NAME
   ietd    7885 root    7u  IPv4  14886      0t0  TCP *:3260 (LISTEN)
   ietd    7885 root    8u  IPv6  14887      0t0  TCP *:3260 (LISTEN)

(有时候tgt和iet都安装时会有冲突，需要先把tgt停掉。)


制作硬盘

1）lv方式::

   #lvcreate -L 2G cinder-volumes
   Logical volume "lvol0" created
   
   #ls /dev/cinder-volumes/lvol0
   /dev/cinder-volumes/lvol0

2）文件方式

制作一个512M的磁盘镜像::

   #dd if=/dev/zero of=/home/disk.img bs=512 count=1000000 


创建iet分区::

   #ietadm --op new --tid=1 --params Name=iqn.foo.example
   
   #ietadm --op new --tid=1 --lun=1 --params Path=/dev/cinder-volumes/lvol0,Type=fileio
   or
   #ietadm --op new --tid=1 --lun=1 --params Path=/home/disk.img,Type=fileio

重启iet服务，上面的配置会丢失::

   #/etc/init.d/iscsitarget restart

查看当前虚拟单元清单::

   #cat /proc/net/iet/volume 
   tid:1 name:iqn.foo.example
           lun:1 state:0 iotype:fileio iomode:wt blocks:4194304 blocksize:512 path:/dev/cinder-volumes/lvol0

如果initiator已经连上，可以查看连接状态命令::

   #cat /proc/net/iet/session
   tid:1 name:iqn.foo.example
           sid:562949990973952 initiator:iqn.1993-08.org.debian:01:5d5f7d6e2951
                   cid:0 ip:192.168.1.5 state:active hd:none dd:none

服务正常运行时，target端fdisk -l能看到刚才新建立的分区。


ISCSI Initiator Node
====================

主要安装open-iscsi（initiator部分）。

安装initiator::

   #apt-get install open-iscsi

手动发现target。输入target的ip，正常情况能看到target建立的硬盘。也可以在ip后面加:3206指定端口，一般默认不用加::

   #iscsiadm -m discovery -t sendtargets -p 192.168.1.5

discovery之后可以看到建立的node::

   #iscsiadm -m node
   192.168.1.5:3260,1 iqn.foo.example

登入::

   #iscsiadm -m node -T iqn.foo.example -l -p 192.168.1.5

正确登陆之后，通过fdisk就能看到远程硬盘::

   #fdisk -l

查看建立的session::

   #iscsiadm -m session
   tcp: [2] 192.168.1.5:3260,1 iqn.foo.example


退出::

   #iscsiadm -m node -T iqn.foo.example -u

删除节点(需要先退出再删除)::

   #iscsiadm -m node -o delete -T iqn.foo.example


Compute Node (together with Initiator Node)
====================

主要安装kvm，由于initiator需要直接提供存储给kvm,所以需要和initiator安装在一个node上。

1）安装kvm相关包

略

2）启动虚拟机

略

查看虚拟机启动状态::

   #virsh list --all
    Id    Name                           State
   ----------------------------------------------------
    2     instance-00000005              running


3）挂接和卸载硬盘

使用virsh命令::

   virsh attach-disk <domain> <source> <target>
   virsh detach-disk <domain> <target>

例如将host机中/dev/sda4分区，挂接到虚拟机的/dev/vdb::

   #virsh attach-disk instance-00000005 /dev/sda4 vdb

成功后，进入虚拟机使用fdisk -l，可以看到新添加的硬盘。和结合之前的iscsi步骤关联起来，只需将/dev/sda4换成iscsi initiator挂接后的硬盘设备即可。

卸载使用::

   #virsh detach-disk instance-00000005 vdb



