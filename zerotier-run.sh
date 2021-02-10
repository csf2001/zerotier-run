#!/bin/sh

# You need modify this part use your network information:
# -------------------------------------------------------
pingip="8.8.8.8"            #--Ping test IP address
ztnetid="ad4e7455b22f89ae"  #--ZeroTier network ID
ztnetaddr="192.168.192.0"   #--ZeroTier network address
rtnetaddr="192.168.1.0"     #--network address which is running ZeroTier on a router
rtnetgw="192.168.1.1"       #--gateway of network which is running ZeroTier on a router
# -------------------------------------------------------

ztjoin() {
  echo "Check Network..."
  while true
  do
    if [ `route -n|grep 0.0.0.0|wc -l` -gt 0 ]
    then
      break
    fi
    sleep 5s
  done

  while true
  do
    echo "Network is working, check Internet..."

    if [ `ping -i 5 -n -c 2 $pingip|grep ttl|wc -l` -gt 0 ]
    then
      echo "Internet is working, check Route..."
      route8=`route -n|grep $rtnetaddr|wc -l`

      if [ $route8 -eq 0 ]
      then
        echo "ZeroTier Cli is NOT working, start ZeroTier Cli..."
        /usr/bin/zerotier-cli join $ztnetid
      elif [ $route8 -eq 1 ]
      then

        if [ `route -n|grep $rtnetaddr.*zt|wc -l` -eq 1 ]
        then
          echo "ZeroTier Cli is running!"
        else
          echo "Now in ztRouteNet, add Route..."
          /usr/bin/route add -net $ztnetaddr netmask 255.255.255.0 gw $rtnetgw
          echo "Route is OK!"
        fi

      elif [ $route8 -gt 1 ]
      then
        echo "Now in ztRouteNet, stop ZeroTier Cli AND add Route..."
        /usr/bin/zerotier-cli leave $ztnetid
        /usr/bin/route add -net $ztnetaddr netmask 255.255.255.0 gw $rtnetgw
      else
        echo "Route is OK!"
      fi

      break
    else
      echo "Internet is NOT working!"
    fi

  done
}

ztleave() {
  route192=`route -n|grep $ztnetaddr|wc -l`
  if [ $route192 -eq 0 ]
  then
    echo "ZeroTier Cli is NOT working!"
  elif [ `route -n|grep $ztnetaddr.*zt|wc -l` -gt 0 ]
  then
    echo "Stop ZeroTier Cli..."
    /usr/bin/zerotier-cli leave $ztnetid
  else
    echo "Now in ztRouteNet, delete Route..."
    /usr/bin/route del -net $ztnetaddr netmask 255.255.255.0 gw $rtnetgw
    echo "Route is OK!"
  fi
}

if [ `whoami` != "root" ]
then
  echo " Note: ONLY root can run!"
  exit 1
fi

case $1 in
  "join")
    ztjoin
    ;;
  "leave")
    ztleave
    ;;
  "restart")
    ztleave
    ztjoin
    ;;
  *)
    echo "Usage: zerotier-run.sh [ join | leave | restart ]"
    echo " Note: ONLY root can run!"
    ;;
esac
exit 0