#!/bin/sh
cur_dir=$(cd "$(dirname "$0")"; pwd)
echo $cur_dir
kill -9 `ps aux|grep watchdog.sh|awk '{print $2}'`
$cur_dir/portal
nohup $cur_dir/watchdog.sh >> $cur_dir/watchdog.log 2>&1 &
