About
===

This script is used to configure networks when you use ZeroTier in your network through a router which is running ZeroTier.

It is useful for your laptop.  It can check your network, and set ZeroTier or route table in your linux system.

Install
===

Just run:
```
$./install.sh
```

<b>Note</b>: you need `root` permission.

<b>Import</b>: After installed, you need modify the head of script use your network information through run:
```
$sudo vi /usr/bin/zerotier-run.sh
```

You need modify this part:

>pingip="8.8.8.8"            --Ping test IP address
>
>ztnetid="ad4e7455b22f89ae"  --ZeroTier network ID
>
>ztnetaddr="192.168.192.0"   --ZeroTier network address
>
>rtnetaddr="192.168.1.0"     --network address which is running ZeroTier on a router
>
>rtnetgw="192.168.1.1"       --gateway of network which is running ZeroTier on a router

Usage
===
```
$/usr/bin/zerotier-run.sh [ join | leave | restart ]
```

Maintainers
===
csf2001@gmail.com
