#!/bin/bash                                           
# author: Bc. Josef Jebavý 
# date: 2021-02-09
# backup skript via ssh
dir=`dirname $0`




if [ -f ${dir}/config.sh ] ; then
	. ${dir}/config.sh
else
	echo config file not found
	exit 1 
fi
echo

renice 19 $$ > /dev/null


ping $IP -c 1 1>/dev/null 2>/dev/null|| (echo "vzdalenhy stroj neodpovida"; exit 1)
echo  "==== backuping... ===="

#echo $DATE >> ~/backup-date.txt
rsync -av --delete --delete-excluded  -e   "ssh -p $PORT -l $USER" ~/ $IP:$AdrZALOHY $EXCLUDE  #--dry-run
ssh -p $PORT $USER@$IP ">${AdrZALOHY}/backup.snapbackuper"






