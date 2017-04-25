#!/bin/bash
VOLUME_HOME="/var/lib/mysql"

sed -ri -e "s/^upload_max_filesize.*/upload_max_filesize = ${PHP_UPLOAD_MAX_FILESIZE}/" \
    -e "s/^post_max_size.*/post_max_size = ${PHP_POST_MAX_SIZE}/" /etc/php5/apache2/php.ini
if [[ ! -d $VOLUME_HOME/mysql ]]; then
    echo "=> An empty or uninitialized MySQL volume is detected in $VOLUME_HOME"
    echo "=> Installing MySQL ..."
    mysql_install_db > /dev/null 2>&1
    echo "=> Done!"  
    /create_mysql_admin_user.sh
else
    echo "=> Using an existing volume of MySQL"
fi
rm -rf /etc/supervisor/conf.d/supervisord-vsftpd.conf
#exec supervisord -n
#exec supervisord
service apache2 start
service mysql start
# Entry script to start Xvfb and set display
set -e
echo "Start Robot"
# Set the defaults
DEFAULT_LOG_LEVEL="INFO" # Available levels: TRACE, DEBUG, INFO (default), WARN, NONE (no logging)
DEFAULT_RES="1280x1024x24"
DEFAULT_DISPLAY=":99"
DEFAULT_ROBOT_TESTS="/test/"
DEFAULT_ROBOT_PARAM=""
DEFAULT_GDRIVE="false"

# Use default if none specified as env var
LOG_LEVEL=${LOG_LEVEL:-$DEFAULT_LOG_LEVEL}
RES=${RES:-$DEFAULT_RES}
DISPLAY=${DISPLAY:-$DEFAULT_DISPLAY}
ROBOT_TESTS=${ROBOT_TESTS:-$DEFAULT_ROBOT_TESTS}
ROBOT_PARAM=${ROBOT_TESTS:-$DEFAULT_ROBOT_PARAM}
GDRIVE=${GDRIVE:-$DEFAULT_GDRIVE}

if [[ "${ROBOT_TESTS}" == "false" ]]; then
  echo "Error: Please specify the robot test or directory as env var ROBOT_TESTS"
  exit 1
fi

# Start Xvfb
echo -e "Starting Xvfb on display ${DISPLAY} with res ${RES}"
Xvfb ${DISPLAY} -ac -screen 0 ${RES} +extension RANDR >/var/www/html/xvfb.log 2>&1 &
export DISPLAY=${DISPLAY}

# Import database
mysql -uroot -punknown -e "CREATE DATABASE IF NOT EXISTS magento;"
mysql -uroot -punknown magento < /var/www/html/alldatabase.sql

# Execute tests
echo -e "Executing robot tests at log level ${LOG_LEVEL}"

pybot --loglevel ${LOG_LEVEL} --outputdir ${ROBOT_TESTS} ${ROBOT_TESTS}
#pybot --loglevel ${LOG_LEVEL} ${ROBOT_TESTS}

# Stop Xvfb
kill -9 $(pgrep Xvfb)
echo -e "End Robot"

if [[ "${GDRIVE}" == "false" ]]; then
  echo -e "Warning: Do not specific google drive id, do not upload."
  exit 0
fi
echo -e "Start convert result to excel and upload"
python /robot2docs/robot2excel.py ${ROBOT_TESTS} ${GDRIVE}
