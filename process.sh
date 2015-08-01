#!/bin/bash

echo "process.sh - See the top 5 running processes"
echo ""
echo "PNU - Number of Process"
echo "PID - Process Identification"
echo "Proccess - Running Processes"
echo ""
echo "PNU PID Process" | column -t

for proc in $(ps -ef | awk '{ print $2 }' | grep -v 'PID')
do
   cmdLine="/proc/${proc}/cmdline"

   if [ -f "${cmdLine}" ]
   then
      val=$(cat "${cmdLine}") 2>/dev/null
   fi

   echo $(ls "/proc/${proc}/fd" 2>/dev/null | wc -l) "${proc}" "${val}" 2>/dev/null
done | sort -n -r | head -n 5 | column -t
