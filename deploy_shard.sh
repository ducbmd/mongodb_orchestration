#!/bin/bash

## action
ACTION=sync ## sync/start/stop. `sync` only creates files/folders. `start` do the sync and start the service.

## mongos
MONGOS_NUMBER=2

MONGOS0_HOST=10.30.80.79
MONGOS0_PORT=27017
MONGOS0_PATH=/etc/mongodb/mongos0 ## path for config file
MONGOS0_CONF_FILE=mongos0.conf
MONGOS0_LOG_PATH=/var/log/mongodb/mongos0/mongos.log
MONGOS0_SSH=root@10.30.80.79

MONGOS1_HOST=10.30.80.79
MONGOS1_PORT=27018
MONGOS1_PATH=/etc/mongodb/mongos1
MONGOS1_CONF_FILE=mongos1.conf
MONGOS1_LOG_PATH=/var/log/mongodb/mongos1/mongos.log
MONGOS1_SSH=root@10.30.80.79

## Config SVR
CONFSVR_REPL=3 # number of nodes in config replica set
CONFSVR_REPL_NAME=configsvr_repl
CONFSVR_REPL_PRIMARY=10.30.80.79:27019

CONFSVR_REPL0_HOST=10.30.80.79
CONFSVR_REPL0_PORT=27019
CONFSVR_REPL0_PATH=/etc/mongodb/confsvr0
CONFSVR_REPL0_CONF_FILE=mongod_confsvr0.conf
CONFSVR_REPL0_LOG_PATH=/var/log/mongodb/confsvr0/mongod.log
CONFSVR_REPL0_DB_PATH=/data/mongodb/confsvr0
CONFSVR_REPL0_SSH=root@10.30.80.79

CONFSVR_REPL1_HOST=10.30.80.79
CONFSVR_REPL1_PORT=27020
CONFSVR_REPL1_PATH=/etc/mongodb/confsvr1
CONFSVR_REPL1_CONF_FILE=mongod_confsvr1.conf
CONFSVR_REPL1_LOG_PATH=/var/log/mongodb/confsvr1/mongod.log
CONFSVR_REPL1_DB_PATH=/data/mongodb/confsvr1
CONFSVR_REPL1_SSH=root@10.30.80.79

CONFSVR_REPL2_HOST=10.30.80.79
CONFSVR_REPL2_PORT=27021
CONFSVR_REPL2_PATH=/etc/mongodb/confsvr2
CONFSVR_REPL2_CONF_FILE=mongod_confsvr2.conf
CONFSVR_REPL2_LOG_PATH=/var/log/mongodb/confsvr2/mongod.log
CONFSVR_REPL2_DB_PATH=/data/mongodb/confsvr2
CONFSVR_REPL2_SSH=root@10.30.80.79

## Common config for all shards
SHARD_NUMBER=2

### Shard 0
SHARD0_REPL=3
SHARD0_REPL_NAME=shard0_repl
SHARD0_REPL_PRIMARY=10.30.80.79:27020

SHARD0_REPL0_HOST=10.30.80.79
SHARD0_REPL0_PORT=27020
SHARD0_REPL0_PATH=/etc/mongodb/shard0/repl0
SHARD0_REPL0_CONF_FILE=mongod_shard0_repl0.conf
SHARD0_REPL0_LOG_PATH=/var/log/mongodb/shard0/repl0/mongod.log
SHARD0_REPL0_DB_PATH=/data/mongodb/shard0/repl0
SHARD0_REPL0_SSH=root@10.30.80.79

SHARD0_REPL1_HOST=10.30.80.79
SHARD0_REPL1_PORT=27021
SHARD0_REPL1_PATH=/etc/mongodb/shard0/repl1
SHARD0_REPL1_CONF_FILE=mongod_shard0_repl1.conf
SHARD0_REPL1_LOG_PATH=/var/log/mongodb/shard0/repl1/mongod.log
SHARD0_REPL1_DB_PATH=/data/mongodb/shard0/repl1
SHARD0_REPL1_SSH=root@10.30.80.79

SHARD0_REPL2_HOST=10.30.80.79
SHARD0_REPL2_PORT=27022
SHARD0_REPL2_PATH=/etc/mongodb/shard0/repl2
SHARD0_REPL2_CONF_FILE=mongod_shard0_repl2.conf
SHARD0_REPL2_LOG_PATH=/var/log/mongodb/shard0/repl2/mongod.log
SHARD0_REPL2_DB_PATH=/data/mongodb/shard0/repl2
SHARD0_REPL2_SSH=root@10.30.80.79

### Shard 1
SHARD1_REPL=3
SHARD1_REPL_NAME=shard1_repl
SHARD1_REPL_PRIMARY=10.30.80.79:27023

SHARD1_REPL0_HOST=10.30.80.79
SHARD1_REPL0_PORT=27023
SHARD1_REPL0_PATH=/etc/mongodb/shard1/repl0
SHARD1_REPL0_CONF_FILE=mongod_shard1_repl0.conf
SHARD1_REPL0_LOG_PATH=/var/log/mongodb/shard1/repl0/mongod.log
SHARD1_REPL0_DB_PATH=/data/mongodb/shard1/repl0
SHARD1_REPL0_SSH=root@10.30.80.79

SHARD1_REPL1_HOST=10.30.80.79
SHARD1_REPL1_PORT=27024
SHARD1_REPL1_PATH=/etc/mongodb/shard1/repl1
SHARD1_REPL1_CONF_FILE=mongod_shard1_repl1.conf
SHARD1_REPL1_LOG_PATH=/var/log/mongodb/shard1/repl1/mongod.log
SHARD1_REPL1_DB_PATH=/data/mongodb/shard1/repl1
SHARD1_REPL1_SSH=root@10.30.80.79

SHARD1_REPL2_HOST=10.30.80.79
SHARD1_REPL2_PORT=27025
SHARD1_REPL2_PATH=/etc/mongodb/shard1/repl2
SHARD1_REPL2_CONF_FILE=mongod_shard1_repl2.conf
SHARD1_REPL2_LOG_PATH=/var/log/mongodb/shard1/repl2/mongod.log
SHARD1_REPL2_DB_PATH=/data/mongodb/shard1/repl2
SHARD1_REPL2_SSH=root@10.30.80.79

## Auth config
ENABLE_AUTH=false ## true/false

## Service config
USER_MONGODB=mongodb

## Create keyfile
mkdir -p target
openssl rand -base64 756 > target/keyfile

## mongos
mkdir -p target/mongos
for ((i = 0; i < $MONGOS_NUMBER; i++));
do
  echo "Generating file for mongos$i"
  mongos_host=MONGOS"$i"_HOST
  mongos_port=MONGOS"$i"_PORT
  mongos_path=MONGOS"$i"_PATH
  mongos_conf_file=MONGOS"$i"_CONF_FILE
  mongos_log_path=MONGOS"$i"_LOG_PATH
  mongos_ssh=MONGOS"$i"_SSH

  ssh ${!mongos_ssh} "sudo id -u $USER_MONGODB &>/dev/null || sudo useradd $USER_MONGODB"

  ssh ${!mongos_ssh} "sudo mkdir -p ${!mongos_path}"
  ssh ${!mongos_ssh} "sudo mkdir -p ${!mongos_log_path%/*} && sudo touch ${!mongos_log_path}"

  ssh ${!mongos_ssh} "sudo chown -R $USER_MONGODB:$USER_MONGODB ${!mongos_path}"
  ssh ${!mongos_ssh} "sudo chown -R $USER_MONGODB:$USER_MONGODB ${!mongos_log_path%/*} ${!mongos_log_path}"

  cat template/mongos.conf | \
  sed "s~%%MONGOS_LOG_PATH%%~${!mongos_log_path}~g" | \
  sed "s~%%MONGOS_HOST%%~${!mongos_host}~g" | \
  sed "s~%%MONGOS_PORT%%~${!mongos_port}~g" | \
  sed "s~%%CONFSVR_REPL_NAME%%~$CONFSVR_REPL_NAME~g" | \
  sed "s~%%CONFSVR_REPL_PRIMARY%%~$CONFSVR_REPL_PRIMARY~g" | \
  sed "s~%%MONGOS_PID%%~${!mongos_path}/mongos.pid~g" > target/mongos/${!mongos_conf_file}

  rsync -aurv target/mongos/${!mongos_conf_file} ${!mongos_ssh}:${!mongos_path}
  ssh ${!mongos_ssh} "sudo chown -R $USER_MONGODB:$USER_MONGODB ${!mongos_path}"
done

## Config SVR
mkdir -p target/confsvr
for ((i = 0; i < $CONFSVR_REPL; i++));
do
  echo "----------"
  echo "Generating file for confsvr_repl$i"
  confsvr_repl_host=CONFSVR_REPL"$i"_HOST
  confsvr_repl_port=CONFSVR_REPL"$i"_PORT
  confsvr_repl_path=CONFSVR_REPL"$i"_PATH
  confsvr_repl_conf_file=CONFSVR_REPL"$i"_CONF_FILE
  confsvr_repl_log_path=CONFSVR_REPL"$i"_LOG_PATH
  confsvr_repl_db_path=CONFSVR_REPL"$i"_DB_PATH
  confsvr_repl_ssh=CONFSVR_REPL"$i"_SSH

  ssh ${!confsvr_repl_ssh} "sudo id -u $USER_MONGODB &>/dev/null || sudo useradd $USER_MONGODB"

  ssh ${!confsvr_repl_ssh} "sudo mkdir -p ${!confsvr_repl_path}"
  ssh ${!confsvr_repl_ssh} "sudo mkdir -p ${!confsvr_repl_log_path%/*} && sudo touch ${!confsvr_repl_log_path}"
  ssh ${!confsvr_repl_ssh} "sudo mkdir -p ${!confsvr_repl_db_path}"

  ssh ${!confsvr_repl_ssh} "sudo chown -R $USER_MONGODB:$USER_MONGODB ${!confsvr_repl_path}"
  ssh ${!confsvr_repl_ssh} "sudo chown -R $USER_MONGODB:$USER_MONGODB ${!confsvr_repl_log_path%/*} ${!confsvr_repl_log_path}"
  ssh ${!confsvr_repl_ssh} "sudo chown -R $USER_MONGODB:$USER_MONGODB ${!confsvr_repl_db_path}"

  cat template/mongod.conf | \
  sed "s~%%MONGOD_LOG_PATH%%~${!confsvr_repl_log_path}~g" | \
  sed "s~%%MONGOD_DB_PATH%%~${!confsvr_repl_db_path}~g" | \
  sed "s~%%MONGOD_HOST%%~${!confsvr_repl_host}~g" | \
  sed "s~%%MONGOD_PORT%%~${!confsvr_repl_port}~g" | \
  sed "s~%%MONGOD_REPL_NAME%%~$CONFSVR_REPL_NAME~g" | \
  sed "s~%%MONGO_KEYFILE%%~${!confsvr_repl_path}/keyfile~g" | \
  sed "s~%%MONGOD_PID%%~${!confsvr_repl_path}/mongod.pid~g" > target/confsvr/${!confsvr_repl_conf_file}

  rsync -aurv target/confsvr/${!confsvr_repl_conf_file} ${!confsvr_repl_ssh}:${!confsvr_repl_path}
  ssh ${!confsvr_repl_ssh} "sudo chown -R $USER_MONGODB:$USER_MONGODB ${!confsvr_repl_path}"

  rsync -aurv target/keyfile ${!confsvr_repl_ssh}:${!confsvr_repl_path}
  ssh ${!confsvr_repl_ssh} "sudo chmod 400 ${!confsvr_repl_path}/keyfile"
  ssh ${!confsvr_repl_ssh} "sudo chown -R $USER_MONGODB:$USER_MONGODB ${!confsvr_repl_path}/keyfile"
done


## SHARDs
for ((i = 0; i < $SHARD_NUMBER; i++));
do
  echo "----------"
  echo "Generating file for shard$i"

  shard_repl=SHARD"$i"_REPL
  shard_repl_name=SHARD"$i"_REPL_NAME
  shard_dir_local=target/shard"$i"
  mkdir -p $shard_dir_local

  for ((j = 0; j < ${!shard_repl}; j++));
  do
    echo "----------"
    echo "Generating file for shard$i - replica$j"

    shard_repl_host=SHARD"$i"_REPL"$j"_HOST
    shard_repl_port=SHARD"$i"_REPL"$j"_PORT
    shard_repl_path=SHARD"$i"_REPL"$j"_PATH
    shard_repl_conf_file=SHARD"$i"_REPL"$j"_CONF_FILE
    shard_repl_log_path=SHARD"$i"_REPL"$j"_LOG_PATH
    shard_repl_db_path=SHARD"$i"_REPL"$j"_DB_PATH
    shard_repl_ssh=SHARD"$i"_REPL"$j"_SSH

    ssh ${!shard_repl_ssh} "sudo id -u $USER_MONGODB &>/dev/null || sudo useradd $USER_MONGODB"

    ssh ${!shard_repl_ssh} "sudo mkdir -p ${!shard_repl_path}"
    ssh ${!shard_repl_ssh} "sudo mkdir -p ${!shard_repl_log_path%/*} && sudo touch ${!shard_repl_log_path}"
    ssh ${!shard_repl_ssh} "sudo mkdir -p ${!shard_repl_db_path}"

    ssh ${!shard_repl_ssh} "sudo chown -R $USER_MONGODB:$USER_MONGODB ${!shard_repl_path}"
    ssh ${!shard_repl_ssh} "sudo chown -R $USER_MONGODB:$USER_MONGODB ${!shard_repl_log_path%/*} ${!shard_repl_log_path}"
    ssh ${!shard_repl_ssh} "sudo chown -R $USER_MONGODB:$USER_MONGODB ${!shard_repl_db_path}"

    cat template/mongod.conf | \
    sed "s~%%MONGOD_LOG_PATH%%~${!shard_repl_log_path}~g" | \
    sed "s~%%MONGOD_DB_PATH%%~${!shard_repl_db_path}~g" | \
    sed "s~%%MONGOD_HOST%%~${!shard_repl_host}~g" | \
    sed "s~%%MONGOD_PORT%%~${!shard_repl_port}~g" | \
    sed "s~%%MONGOD_REPL_NAME%%~${!shard_repl_name}~g" | \
    sed "s~%%MONGO_KEYFILE%%~${!shard_repl_path}/keyfile~g" | \
    sed "s~%%MONGOD_PID%%~${!shard_repl_path}/mongod.pid~g" > $shard_dir_local/${!shard_repl_conf_file}

    rsync -aurv $shard_dir_local/${!shard_repl_conf_file} ${!shard_repl_ssh}:${!shard_repl_path}
    ssh ${!shard_repl_ssh} "sudo chown -R $USER_MONGODB:$USER_MONGODB ${!shard_repl_path}"

    rsync -aurv target/keyfile ${!shard_repl_ssh}:${!shard_repl_path}
    ssh ${!shard_repl_ssh} "sudo chmod 400 ${!shard_repl_path}/keyfile"
    ssh ${!shard_repl_ssh} "sudo chown -R $USER_MONGODB:$USER_MONGODB ${!shard_repl_path}/keyfile"
  done
done

echo "Deploy files/folders completed."

