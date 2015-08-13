#!/bin/bash

getOSType=$(/bin/uname -s)
readonly getOSType

if [ -f /etc/redhat-release ]
then
  getOS="redhat"
elif [ -f /etc/debian_version ]
then
  getOS="debian"
else
  echo "Could not determine the Operating System"
fi
readonly getOS

if [ "${getOSType}" = "Linux" ]
then
  hostName=$(hostname)

  if [ -f /usr/sbin/virt-what ]
  then
    isVirtual=$(/usr/sbin/virt-what)
  fi

  if [ -x /usr/bi/lscpu ]
  then
    cpuCore=$(lscpu | grep "^CPU(s)")
    cpuSock=$(lscpu | grep "Socket(s)")
    cpuPers=$(lscpu | grep "Core(s)")
  else
    cpuCore=$(egrep -e "core id" -e ^physical /proc/cpuinfo | xargs -l2 echo | sort -u | uniq | wc -l)
    cpuSock=$(grep "physical id" /proc/cpuinfo | sort -u | wc -l)

    if [ "${cpuSock}" == "0" ]
    then
      echo ""
      if [ -f /usr/sbin/dmidecode ]
      then
        cpuSock=$(/usr/sbin/dmidecode -t4 | grep -e 'cpu' -e 'Manu' | grep -v 000000000000 | wc-l)
      fi
    fi
  fi

  echo "Hostname: ${hostName}"
  
  case "${isVirtual}" in
    "")
      echo -en "CPU(s):\t\t\t${cpuCore}\n"
      echo -en "Sockets:\t\t${cpuSock}\n"
      echo -en "Core(s): per Socket:\t${cpuPers}\n"      
    ;;
    *)
      echo "Virtual: ${isVirtual}"
      echo -en "CPU(s):\t\t\t${cpuCore}\n"
      echo -en "Virtual Sockets:\t${cpuSock}\n"
      echo -en "Core(s): per Socket:\t${cpuCore}\n"
    ;;
  esac

  serialNum=$(dmidecode | grep -A 5 "System Information" | grep "Serial Number:" | awk -F":" '{ print $2 }')
  prodType=$(dmidecode | grep -A 5 "System Information" | grep "Product Name:" | awk -F":" '{ print $2 }')

  echo "Model: ${prodType}"
  echo "SerialNo.: ${serialNum}"
elif [ "${getOSType}" == "SunOS" ]
then
  echo "Build out SunOS logic and information."
else
  echo "An error has occurred. Exiting ..."
  exit 1
fi
