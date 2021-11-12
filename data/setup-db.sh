#!/bin/bash

tenant=$1
env=$2

if [ -z "$2" ] ; then
    env="local"
else
    env="$2"
fi

echo "env = $env"

do_mysql_c() {
    MYSQL_HISTFILE=/dev/null
    if [ -z "$1" ] ; then
        sql="$(cat)"
    else
        sql="$1"
    fi

    [ $DEBUG ] && echo "mysql>> $sql"
    mysql $MYSQL_ARGS 2>&1 <<END
$sql
END
    if [ $? -gt 0 ]; then
        echo "Failure during MYSQL query!"
        exit 1
    fi
    return 0
}

do_mysql_in() {
    MYSQL_HISTFILE=/dev/null

    [ $DEBUG ] && echo "mysql>> $sql"
    cat | mysql $MYSQL_ARGS "$@" 2>&1

    if [ $? -gt 0 ]; then
        echo "Failure during MYSQL query!"
        exit 1
    fi
    return 0
}

mysql_online() {
    # known issue, new feature of bash prints errors, and redirect to null doesn't help
    if [ "$(cat /proc/1/cmdline 2>/dev/null)" = "mysqld" ]; then
        if [ -e /var/run/mysqld/mysqld.sock ]; then
            #dbs=$(do_mysql_c "use mysql; show tables;")
            #echo "$dbs"
            #dbs=$(do_mysql_c "use mysql; select * from user;")
            #echo "$dbs"
            return 0
        fi
    fi
    return 1
}

# a little bit of a crap shoot knowing if mysql is ready or not
while ! mysql_online; do
    echo "Waiting for db to come online..."
    sleep 1
done

echo "Creating Database $tenant..."
do_mysql_c "CREATE DATABASE IF NOT EXISTS \`pyr-$tenant-$env\`;"

echo "Loading Database schema for $tenant..."
do_mysql_in "pyr-$tenant-$env" < /data/$tenant.sql

echo "Success"
