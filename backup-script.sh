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


ping $IP -c 1 1>/dev/null 2>/dev/null
if [  $? != 0 ];then

echo "vzdalenhy stroj neodpovida"
exit 1
fi

echo  "==== backuping... ===="

#echo $DATE >> ~/backup-date.txt
rsync -av --delete --delete-excluded  -e   "ssh -p $PORT -l $USER" ${SourceDir}/ $IP:$AdrZALOHY/ $EXCLUDE  #--dry-run

#is DBPASS set?
if [ -n "$DBPASS" ]; then
echo zalohuju databazi MySQL

DBFILE="/root/mysql-dump_`date +%Y-%m-%d_%Hh`.sql"
mysqldump  -u backup -p"${DBPASS}" --default-character-set=utf8mb4 --all-databases --result-file=$DBFILE
gzip $DBFILE
scp -P $PORT ${DBFILE}.gz $USER@$IP:${AdrZALOHY}/
rm ${DBFILE}.gz
fi

echo end backup
ssh -p $PORT $USER@$IP ">${AdrZALOHY}/backup.snapbackuper"







