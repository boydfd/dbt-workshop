SCRIPTPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
RUN_ID=$1
LOG_PATH=${2:-/tmp/logs}

mkdir -p $LOG_PATH

. /opt/dbt/bin/activate

cd $SCRIPTPATH

dbt snapshot
dbt run

mv logs/dbt.log $LOG_PATH/$RUN_ID.log
cat $LOG_PATH/$RUN_ID.log