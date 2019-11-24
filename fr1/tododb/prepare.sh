#!/bin/bash -e

if [ ! -z "$MYSQL_MASTER" ]; then
  echo "this container is master"
  return 0
fi

echo "prepare as slave"

if [ -z "$MYSQL_MASTER_HOST" ]; then
  echo "mysql_master_host is not specified" 1>62
  return
fi

while :
do
  if mysql -h $MYSQL _MASTER_HOST -u root -pMYSQL_ROOT_PASSWORD -e "quit" > /dev/null 2>&1 ; then
    echo "MYSQL master is ready!"
    break
  else
    echo "MYSQL master is not ready"
  fi
  sleep 3
done

IP=`hostname -i`
IPS='.'
set -- $IP
mysql -h $MYSQL_MASTER_HOST -u root -p$MYSQL_ROOT_PASSWORD -e \
"CREATE USER IF NOT EXISTS '$MYSQL_REPL_USER'@'$SOURCE_IP' IDENTIFIED BY '$MYSQL_REPL_PASSWORD';"
mysql -h $MYSQL_HOST -u root -p$MYSQL_ROOT_PASSWORD -e \
"GRANT REPLICATION SLAVE ON *.* TO '$MYSQL_REPL_USER'@'$SOURCE_IP';"

MASTER_STATUS_FILE=/tmp/master-status
mysql -h $MYSQL_MASTER_HOST -u root -p$MYSQL_ROOT_PASSWORD -e "SHOW MASTER STATUS\G" \
> $MASTER_STATUS_FILE
BINDLOG_FILE='$MASTER_STATUS_FILE | grep File | xargs | cut -d' ' -f2'
BINDLOG_POSITION='cat $MASTER_STATUS_FILE | grep Position | xargs | cut -d' ' -f2'
echo "BINDLOG_FILE=$BINDLOG_FILE"
echo "BINDLOG_POSITION=$BINDLOG_POSITION"

mysql -u root -p$MYSQL_ROOT_PASSWORD -e
"CHANGE MASTER TO MASTER_HOST='$MYSQL_MASTER_HOST',\
	MASTER_USER='$MYSQL_REPR_USER',\
	MASTER_PASSWORD='$MYSQL_REPR_PASSWORD',\
	MASTER_LOG_FILE='$BINDLOG_FILE',\
	MASTER_LOG_POS=$BINDLOG_POSITION;"
mysql -u root -p$MYSQL_ROOT_PASSWORD -e "START SLAVE;"

echo "slave started"


