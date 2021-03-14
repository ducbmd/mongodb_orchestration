#!/bin/bash

## mongos
MONGOS_NUMBER=2

MONGOS0_HOST=10.30.80.79
MONGOS0_PORT=27017
MONGOS0_PATH=/etc/mongodb/mongos0
MONGOS0_CONF_PATH=$MONGOS0_PATH/"mongos.conf"
MONGOS0_LOG_PATH=/var/log/mongodb/mongos0/mongos.log
MONGOS0_SSH=root@10.30.80.79

MONGOS1_HOST=10.30.80.79
MONGOS1_PORT=27018
MONGOS1_PATH=/etc/mongodb/mongos1
MONGOS1_CONF_PATH=$MONGOS1_PATH/"mongos.conf"
MONGOS1_LOG_PATH=/var/log/mongodb/mongos1/mongos.log
MONGOS1_SSH=root@10.30.80.79

## Config SVR
CONFSVR_REPL=3 # number of nodes in config replica set
CONFSVR_REPL_NAME=configsvr_repl
CONFSVR_REPL_PRIMARY=10.30.80.79:27019

CONFSVR_REPL0_HOST=10.30.80.79
CONFSVR_REPL0_PORT=27019
CONFSVR_REPL0_PATH=/etc/mongodb/confsvr0
CONFSVR_REPL0_CONF_PATH=$CONFSVR_PATH/"mongod.conf"
CONFSVR_REPL0_LOG_PATH=/var/log/mongodb/confsvr0/mongod.log
CONFSVR_REPL0_DB_PATH=/data/mongodb/confsvr0
CONFSVR_REPL0_SSH=root@10.30.80.79

CONFSVR_REPL1_HOST=10.30.80.79
CONFSVR_REPL1_PORT=27020
CONFSVR_REPL1_PATH=/etc/mongodb/confsvr1
CONFSVR_REPL1_CONF_PATH=$CONFSVR_PATH/"mongod.conf"
CONFSVR_REPL1_LOG_PATH=/var/log/mongodb/confsvr1/mongod.log
CONFSVR_REPL1_DB_PATH=/data/mongodb/confsvr1
CONFSVR_REPL1_SSH=root@10.30.80.79

CONFSVR_REPL2_HOST=10.30.80.79
CONFSVR_REPL2_PORT=27021
CONFSVR_REPL2_PATH=/etc/mongodb/confsvr2
CONFSVR_REPL2_CONF_PATH=$CONFSVR_PATH/"mongod.conf"
CONFSVR_REPL2_LOG_PATH=/var/log/mongodb/confsvr2/mongod.log
CONFSVR_REPL2_DB_PATH=/data/mongodb/confsvr2
CONFSVR_REPL2_SSH=root@10.30.80.79

## Common config for all shards
SHARD_NUMBER=2

SHARD0_HOST=10.30.80.79
SHARD0_PORT=27020
SHARD0_PATH=/etc/mongodb/shard0
SHARD0_CONF_PATH=$SHARD0_PATH/"mongod.conf"
SHARD0_LOG_PATH=/var/log/mongodb/shard0/mongod.log
SHARD0_DB_PATH=/data/mongodb/shard0

SHARD1_HOST=10.30.80.79
SHARD1_PORT=27021
SHARD1_PATH=/etc/mongodb/shard1
SHARD1_CONF_PATH=$SHARD0_PATH/"mongod.conf"
SHARD1_LOG_PATH=/var/log/mongodb/shard1/mongod.log
SHARD1_DB_PATH=/data/mongodb/shard1

## Auth config
ENABLE_AUTH=true ## true/false

## Service config
USER_MONGODB=mongodb

## mongos
for ((i = 0; i < $MONGOS_NUMBER; i++));
do
  echo "Generating file for mongos$i"
  mongos_host=MONGOS"$i"_HOST
  mongos_port=MONGOS"$i"_PORT
  mongos_path=MONGOS"$i"_PATH
  mongos_conf_path=MONGOS"$i"_CONF_PATH
  mongos_log_path=MONGOS"$i"_LOG_PATH
  mongos_ssh=MONGOS"$i"_SSH

  # ssh ${!mongos_ssh} "sudo adduser $USER_MONGODB"
  ssh ${!mongos_ssh} "sudo id -u $USER_MONGODB &>/dev/null || sudo useradd $USER_MONGODB"

  ssh ${!mongos_ssh} "sudo mkdir -p ${!mongos_path}"
  ssh ${!mongos_ssh} "sudo mkdir -p ${!mongos_conf_path%/*}"
  ssh ${!mongos_ssh} "sudo mkdir -p ${!mongos_log_path%/*} && sudo touch ${!mongos_log_path}"

  ssh ${!mongos_ssh} "sudo chown -R $USER_MONGODB:$USER_MONGODB ${!mongos_path}"
  ssh ${!mongos_ssh} "sudo chown -R $USER_MONGODB:$USER_MONGODB ${!mongos_conf_path%/*}"
  ssh ${!mongos_ssh} "sudo chown -R $USER_MONGODB:$USER_MONGODB ${!mongos_log_path%/*} ${!mongos_log_path}"

  cat template/mongos.conf | \
  sed "s~%%MONGOS_PATH%%~${!mongos_conf_path}~g" | \
  sed "s~%%MONGOS_HOST%%~${!mongos_host}~g" | \
  sed "s~%%MONGOS_PORT%%~${!mongos_port}~g" | \
  sed "s~%%CONFSVR_REPL_NAME%%~$CONFSVR_REPL_NAME~g" | \
  sed "s~%%CONFSVR_REPL_PRIMARY%%~$CONFSVR_REPL_PRIMARY~g" > target/mongos/mongos$i.conf

  rsync -aurv target/mongos/mongos$i.conf ${!mongos_ssh}:${!mongos_conf_path%/*}
  ssh ${!mongos_ssh} "sudo chown -R $USER_MONGODB:$USER_MONGODB ${!mongos_conf_path}"
done


## Config SVR
for ((i = 0; i < $CONFSVR_REPL; i++));
do

done
# sudo mkdir -p $CONFSVR_PATH
# sudo mkdir -p "${CONFSVR_CONF_PATH%/*}" && sudo touch "$CONFSVR_CONF_PATH"
# sudo mkdir -p "${CONFSVR_LOG_PATH%/*}" && sudo touch "$CONFSVR_LOG_PATH"
# sudo mkdir -p $CONFSVR_DB_PATH

# sudo chown -R $USER_MONGODB:$USER_MONGODB $CONFSVR_PATH
# sudo chown -R $USER_MONGODB:$USER_MONGODB "${CONFSVR_CONF_PATH%/*}" $CONFSVR_CONF_PATH
# sudo chown -R $USER_MONGODB:$USER_MONGODB "${CONFSVR_LOG_PATH%/*}" $CONFSVR_LOG_PATH
# sudo chown -R $USER_MONGODB:$USER_MONGODB $CONFSVR_DB_PATH

# sudo mkdir -p $SHARD0_PATH
# sudo mkdir -p "${SHARD0_CONF_PATH%/*}" && sudo touch "$SHARD0_CONF_PATH"
# sudo mkdir -p "${SHARD0_LOG_PATH%/*}" && sudo touch "$SHARD0_LOG_PATH"
# sudo mkdir -p $SHARD0_DB_PATH

# sudo chown -R $USER_MONGODB:$USER_MONGODB $SHARD0_PATH
# sudo chown -R $USER_MONGODB:$USER_MONGODB "${SHARD0_CONF_PATH%/*}" $SHARD0_CONF_PATH
# sudo chown -R $USER_MONGODB:$USER_MONGODB "${SHARD0_LOG_PATH%/*}" $SHARD0_LOG_PATH
# sudo chown -R $USER_MONGODB:$USER_MONGODB $SHARD0_DB_PATH



