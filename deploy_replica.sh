#!/bin/bash

## action
ACTION=$1 ## sync/start/restart/stop/check

if
  [[ $ACTION != "sync" ]] && [[ $ACTION != "start" ]] &&
  [[ $ACTION != "restart" ]] && [[ $ACTION != "stop" ]] &&
  [[ $ACTION != "check" ]];
then
  echo "Usage: ./deploy_replica.sh sync/start/restart/stop/check"
  exit 1
fi

## Common
BINDIR=/etc/mongodb/bin

## Replica config
REPL=3 # number of nodes in config replica set
REPL_NAME=svr_repl
REPL_PRIMARY=10.30.80.79:27017

REPL0_HOST=10.30.80.79
REPL0_PORT=27017
REPL0_PATH=/etc/mongodb/svr_repl0
REPL0_CONF_FILE=mongod.conf
REPL0_LOG_PATH=/var/log/mongodb/svr_repl0/mongod.log
REPL0_DB_PATH=/data/mongodb/svr_repl0
REPL0_SSH=root@10.30.80.79

REPL1_HOST=10.30.80.79
REPL1_PORT=27018
REPL1_PATH=/etc/mongodb/svr_repl1
REPL1_CONF_FILE=mongod.conf
REPL1_LOG_PATH=/var/log/mongodb/svr_repl1/mongod.log
REPL1_DB_PATH=/data/mongodb/svr_repl1
REPL1_SSH=root@10.30.80.79

REPL2_HOST=10.30.80.79
REPL2_PORT=27019
REPL2_PATH=/etc/mongodb/svr_repl2
REPL2_CONF_FILE=mongod.conf
REPL2_LOG_PATH=/var/log/mongodb/svr_repl2/mongod.log
REPL2_DB_PATH=/data/mongodb/svr_repl2
REPL2_SSH=root@10.30.80.79

## Auth config
ENABLE_AUTH=true ## true/false
ADMIN_USER=admin
ADMIN_PASS=T3HzPUfPXymQRMxAWe8v

## Service config
USER_MONGODB=mongodb

if [[ $ACTION == "sync" ]]
then
  ## Create keyfile
  mkdir -p target
  openssl rand -base64 756 > target/keyfile

  ## Config SVR
  mkdir -p target/replsvr
  for ((i = 0; i < $REPL; i++));
  do
    echo "----------"
    echo "Generating file for repl$i"
    repl_host=REPL"$i"_HOST
    repl_port=REPL"$i"_PORT
    repl_path=REPL"$i"_PATH
    repl_conf_file=REPL"$i"_CONF_FILE
    repl_log_path=REPL"$i"_LOG_PATH
    repl_db_path=REPL"$i"_DB_PATH
    repl_ssh=REPL"$i"_SSH

    ssh ${!repl_ssh} "sudo id -u $USER_MONGODB &>/dev/null || sudo useradd $USER_MONGODB"

    ssh ${!repl_ssh} "sudo mkdir -p $BINDIR"
    rsync -aurv bin/mongod bin/mongos bin/mongo ${!repl_ssh}:/tmp
    ssh ${!repl_ssh} "sudo rsync -aurv /tmp/mongod /tmp/mongos /tmp/mongo $BINDIR"
    ssh ${!repl_ssh} "sudo chown -R $USER_MONGODB:$USER_MONGODB $BINDIR"

    ssh ${!repl_ssh} "sudo mkdir -p ${!repl_path}"
    ssh ${!repl_ssh} "sudo mkdir -p ${!repl_log_path%/*} && sudo touch ${!repl_log_path}"
    ssh ${!repl_ssh} "sudo mkdir -p ${!repl_db_path}"

    ssh ${!repl_ssh} "sudo chown -R $USER_MONGODB:$USER_MONGODB ${!repl_path}"
    ssh ${!repl_ssh} "sudo chown -R $USER_MONGODB:$USER_MONGODB ${!repl_log_path%/*} ${!repl_log_path}"
    ssh ${!repl_ssh} "sudo chown -R $USER_MONGODB:$USER_MONGODB ${!repl_db_path}"

    cat template/replica/mongod.conf | \
    sed "s~%%MONGOD_LOG_PATH%%~${!repl_log_path}~g" | \
    sed "s~%%MONGOD_DB_PATH%%~${!repl_db_path}~g" | \
    sed "s~%%MONGOD_HOST%%~${!repl_host}~g" | \
    sed "s~%%MONGOD_PORT%%~${!repl_port}~g" | \
    sed "s~%%MONGOD_REPL_NAME%%~$REPL_NAME~g" | \
    sed "s~%%MONGO_KEYFILE%%~${!repl_path}/keyfile~g" | \
    sed "s~%%MONGOD_PID%%~${!repl_path}/mongod.pid~g" > target/replsvr/${!repl_conf_file}

    rsync -aurv target/replsvr/${!repl_conf_file} ${!repl_ssh}:/tmp
    ssh ${!repl_ssh} "sudo rsync -aurv /tmp/${!repl_conf_file} ${!repl_path}"
    ssh ${!repl_ssh} "sudo chown -R $USER_MONGODB:$USER_MONGODB ${!repl_path}"

    rsync -aurv target/keyfile ${!repl_ssh}:/tmp
    ssh ${!repl_ssh} "sudo rsync -aurv /tmp/keyfile ${!repl_path}"
    ssh ${!repl_ssh} "sudo chmod 400 ${!repl_path}/keyfile"
    ssh ${!repl_ssh} "sudo chown -R $USER_MONGODB:$USER_MONGODB ${!repl_path}/keyfile"
  done

elif [[ $ACTION == "start" ]]
then
  for ((i = 0; i < $REPL; i++));
  do
    repl_host=REPL"$i"_HOST
    repl_port=REPL"$i"_PORT
    repl_path=REPL"$i"_PATH
    repl_conf_file=REPL"$i"_CONF_FILE
    repl_log_path=REPL"$i"_LOG_PATH
    repl_db_path=REPL"$i"_DB_PATH
    repl_ssh=REPL"$i"_SSH

    ssh ${!repl_ssh} "sudo -H -u mongodb bash -c '$BINDIR/mongod -f ${!repl_path}/${!repl_conf_file}'"
  done

elif [[ $ACTION == "stop" ]]
then
  echo "stop"

fi

