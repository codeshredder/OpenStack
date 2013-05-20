==========================================================
  OpenStack Grizzly Install Guide
==========================================================

:Version: 1.0
:Source: https://github.com/codeshredder/OpenStack-Experience/blob/master/OpenStack-Grizzly-Install.rst
:Keywords: Grizzly, Quantum, Nova, Keystone, Glance, Horizon, Cinder, OpenVSwitch, KVM, Ubuntu 12.04/13.04 (64 bits).

Authors
==========

`Cloud <https://github.com/codeshredder>`_ 

Reference
==========

大部分经验来自以下文档：

https://github.com/mseknibilel/OpenStack-Grizzly-Install-Guide

安装(install guide)

http://docs.openstack.org/grizzly/basic-install/apt/content/

http://docs.openstack.org/grizzly/openstack-compute/install/apt/content/

块存储(block storage)

http://docs.openstack.org/grizzly/openstack-block-storage/admin/content/

代码(code)

https://github.com/openstack


Table of Contents
=================

::

  0. What is it?
  1. Overview
  2. Requirements
  3. Controller Node
  4. Network Node
  5. Compute Node
  6. Storage Node
  7. Start VM
  8. Licensing
  9. Contacts

0. What is it?
==============

It is for someone who want an easy way to create your own OpenStack platform. 


1. Overview
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

2. Requirements
============


:Node Role: NICs
:Control Node: eth0 (10.10.10.1), eth1 (192.168.0.1)
:Network Node: eth0 (10.10.10.2), eth1 (192.168.0.2), eth2 (192.168.1.1)
:Compute Node: eth0 (10.10.10.3), eth1 (192.168.0.3)
:Volume Node: eth0 (10.10.10.4), eth1 (192.168.0.4)

* 10.10.10.x是管理网络。只是方便用于ssh登陆到各个Node配置用。其中只有Control Node是必须的，因为需要以此IP访问web。
* 192.168.0.x是内部网络。用于Openstack内部各个Node之间互通。
* 192.168.1.x是VM网络。用于VM之间和VM对外通讯用。VM分配的IP地址在此网络中。

* 这里把常用能分布式的部分分出来，包括网络，计算，存储，在此基础上，如果想合在一起只要合并配置即可。相对来说，分比合难。

3. Controller Node
============



8. Licensing
============

This project is licensed under Creative Commons License.

To view a copy of this license, visit [ http://creativecommons.org/licenses/ ].

9. Contacts
===========

Cloud  : evilforce@gmail.com

