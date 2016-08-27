#!/bin/bash
cur_dir=$(cd "$(dirname "$0")"; pwd)
echo "-----------------------check start------------------"
y=1
while true
do
    x=`ps aux| grep ETMDaemon | grep -v grep | grep -v check | wc -l`  # 计算进程数
    y=`ps aux| grep vod_httpserver | grep -v grep | grep -v check | wc -l`  # 计算进程数
    z=`ps aux| grep EmbedThunderManager | grep -v grep | grep -v check | wc -l`  # 计算进程数
    t=`netstat -nap|grep Emb|grep CLOSE|awk 'BEGIN{t=0;} { t++; }  END{print t; }'`  # 有几个连接失败的进程
    let c=$x+$y+$z # 进程相加要大于7个
    if ( [ $y -lt 5 ] && [ $c -gt 7 ] )
    then
        if [ $t -lt 4 ] #如果小于四个连接失败
        then
            echo `date "+%Y-%m-%d %H:%M:%S"`" Xware OK!">>$cur_dir/watchdog.log
            sleep 30
        else #大于等于四个连接失败
            y=$[$y+1] 
            echo `date "+%Y-%m-%d %H:%M:%S"`" Unormal!">>$cur_dir/watchdog.log
	    sleep 30
        fi
    else
        $cur_dir/portal
        echo `date "+%Y-%m-%d %H:%M:%S"`" Restart Xware!!!">>$cur_dir/watchdog.log
	let y=1
	sleep 30
    fi
done
