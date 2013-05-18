==========================================================
  OpenStack Grizzly Install Guide
==========================================================

:Version: 1.0
:Source: https://github.com/codeshredder/OpenStack-Experience/blob/master/OpenStack-Grizzly-Install.rst
:Keywords: Multi node, Grizzly, Quantum, Nova, Keystone, Glance, Horizon, Cinder, OpenVSwitch, KVM, Ubuntu Server 12.04/13.04 (64 bits).

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
  2. Controller Node
  3. Network Node
  4. Compute Node
  5. Storage Node
  6. Start VM
  7. Licensing
  8. Contacts

0. What is it?
==============

It is for someone who want an easy way to create your own OpenStack platform. 


1. Overview
====================

    Openstack是一个云计算框架。全部搭起来以后可以实现启动虚拟机，实现虚拟机之间以及虚拟机和外网之间的通讯，实现虚拟
机的虚拟存储的分配和挂接。并且对虚拟的管理可以通过web来实现。
    它包括以下几个重要组件。同时各个主要组件内部也有多个子组件，这些子组件有些是可以装在多个主机上，并且可以是多份，
这也是系统容量扩展的关键。如Nova-compute,cinder-volume等今后会重点关注的几个组件。

:Nova: 各个主要组件的管理和交互。同时也是计算节点的主要承担者，负责虚拟机的启动关闭等管理。
:keystone: 权限控制。用于各个组件消息交互时的认证校验等。
:glance: 负责虚拟机镜像的管理
:quantum: 负责虚拟机之间，以及虚拟机和外部网络之间的网络管理。
:cinder: 负责虚拟机的块设备存储的管理。通俗的讲就是为虚拟机分配硬盘
:horizon: 提供一个web管理页面，这样不少需要命令行的操作，可以直观的在web上实现。

7. Licensing
============



8. Contacts
===========

Cloud  : evilforce@gmail.com

