#!/usr/bin/bash

#Log file path
LOGFILE=/home/vagrant/logs/ram.log

#Email Recipient
EMAIL="support@ubuntu-focal"

#Create Log file function
function createLog() {
	if test -f $LOGFILE; then
		rm -rf $LOGFILE
	else
		touch $LOGFILE
		date >> $LOGFILE
		free -h >> $LOGFILE
	fi

	touch $LOGFILE
	date >> $LOGFILE
	free -h >> $LOGFILE
}

createLog
echo "Hey, SysAdmin this is the log file for $(date)" | mail -s "RAM LOG FOR $(date)" -A $LOGFILE $EMAIL
