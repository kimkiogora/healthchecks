#!/usr/bin/env bash
# Author Kim kiogora
# 2017 Sep 20th
DAEMON="manage.py"
DAEMONPATH=`pwd`
PIDFILE="/var/run/hc-system.pid"
VENV_FOLDER="../../hc-venv/bin/activate"

isroot(){
	if ! [ $(id -u) = 0 ]; then
		echo "You must be root to run this script"
		exit
	fi
}

start(){
	isroot
	echo "Starting daemon $DAEMON"
	if [ -e "$PIDFILE" ]
	then
		PID=`cat $PIDFILE`
		echo "Already running pid, $PID"
		exit 2
	else
		source $VENV_FOLDER
		cd $DAEMONPATH
		nohup python $DAEMON runserver >/dev/null 2>&1 &
		pid=`ps aux | grep $DAEMON | grep -v "grep"| awk '{print $2}'`
		echo $pid > $PIDFILE &
		deactivate
	fi
}

status(){
	isroot
	pid=`ps aux | grep $DAEMON | grep -v "grep"| awk '{print $2}'`
	if [ ! -z "$pid" ]
	then
		echo "$DAEMON running with $pid"
	else
		echo "$DAEMON is now stopped/not running"
	fi
}

stop() {
	isroot
	echo "Stopping daemon $DAEMON"
	pid=`ps aux | grep $DAEMON | grep -v "grep"| awk '{print $2}'`
	echo $pid
	#exit
	if [  -z "$pid" ]
	then
		echo ""
	else
		echo "$DAEMON pid = $pid"
		kill -9 $pid
		rm -rf $PIDFILE
	fi
	if [ -e "$PIDFILE" ]
	then
		rm -rf $PIDFILE
	fi
}

case "$1" in
	start)
		start
		status
		;;
	stop)
		stop
		status
		;;
	status)
		status
		;;
	restart)
		stop
		start
		;;
	*)
		echo "Usage:  {start|stop|status|restart}"
		exit 1
		;;
esac
exit $?

