#! /bin/bash

pushd ./docker

MYSQL_CLIENT=$(dirname $0)/mysql1/scripts
PATH=$PATH:$MYSQL_CLIENT

function usage {
    cat <<EOF
$(basename ${0}) is a tool for ...

Usage:
  $(basename ${0}) [command] [<options>]

Options:
  stats|st          Dockerコンテナの状態を表示します。
  init              初期化します。（データベース・ログ）
  start             すべてのDaemonを起動します。
  stop              すべてのDaemonを停止します。
  mysql login       MySQLにログインします。
  --version, -v     バージョンを表示します。
  --help, -h        ヘルプを表示します。
EOF
}

function version {
    echo "$(basename ${0}) version 0.0.1 "
}

case ${1} in
    stats|st)
        docker container stats
    ;;

    init)
        # 停止＆削除（コンテナ・イメージ・ボリューム）
        docker-compose down --rmi all --volumes
        rm -Rf ./mysql1/data/*
        rm -Rf ./mysql1/logs/*
        rm -Rf ./mysql2/data/*
        rm -Rf ./mysql2/logs/*
    ;;

    start)
        docker-compose up -d
    ;;
    
    stop)
        docker-compose down
    ;;

    mysql1)
      case ${2} in
          login)
              mysql -u root -ppassword -h 127.0.0.1 -P 33061
          ;;
          dump)
              mysqldump -u root -ppassword -h 127.0.0.1 -P 33061 -A > ./mysql1/init/dump.sql
          ;;
          setslave)
              mysql -u root -ppassword -h 127.0.0.1 -P 33062 -e "SHOW MASTER STATUS\G" | grep File: | awk '{print $2}'
              mysql -u root -ppassword -h 127.0.0.1 -P 33061 -e "STOP SLAVE;"
              mysql -u root -ppassword -h 127.0.0.1 -P 33061 -e "RESET SLAVE;"
              mysql -u root -ppassword -h 127.0.0.1 -P 33061 -e "CHANGE MASTER TO MASTER_HOST='mysql2', MASTER_PORT=3306, MASTER_USER='root', MASTER_PASSWORD='password', MASTER_LOG_FILE='mysql-bin.000003', MASTER_LOG_POS=154;"
              mysql -u root -ppassword -h 127.0.0.1 -P 33061 -e "START SLAVE;"
              mysql -u root -ppassword -h 127.0.0.1 -P 33061 -e "SHOW SLAVE STATUS\G"
          ;;
          *)
              usage
          ;;
      esac
    ;;
    
    mysql2)
      case ${2} in
          login)
              mysql -u root -ppassword -h 127.0.0.1 -P 33062
          ;;
          dump)
              mysqldump -u root -ppassword -h 127.0.0.1 -P 33062 -A > ./mysql2/init/dump.sql
          ;;
          setslave)
              mysql -u root -ppassword -h 127.0.0.1 -P 33061 -e "SHOW MASTER STATUS\G" | grep File: | awk '{print $2}'
              mysql -u root -ppassword -h 127.0.0.1 -P 33062 -e "STOP SLAVE;"
              mysql -u root -ppassword -h 127.0.0.1 -P 33062 -e "RESET SLAVE;"
              mysql -u root -ppassword -h 127.0.0.1 -P 33062 -e "CHANGE MASTER TO MASTER_HOST='mysql1', MASTER_PORT=3306, MASTER_USER='root', MASTER_PASSWORD='password', MASTER_LOG_FILE='mysql-bin.000003', MASTER_LOG_POS=154;"
              mysql -u root -ppassword -h 127.0.0.1 -P 33062 -e "START SLAVE;"
              mysql -u root -ppassword -h 127.0.0.1 -P 33062 -e "SHOW SLAVE STATUS\G"
          ;;
          *)
              usage
          ;;
      esac
    ;;
    
    help|--help|-h)
        usage
    ;;

    version|--version|-v)
        version
    ;;
    
    *)
        echo "[ERROR] Invalid subcommand '${1}'"
        usage
        exit 1
    ;;
esac


