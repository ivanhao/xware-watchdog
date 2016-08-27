#!/bin/bash
Islog=0 #是否启用日志，默认为0（0：否；1：是）
tmr=15 #检测周期（秒）
count=3 #允许几次检测失败（建议不要小于2，否则容易频繁重启）
cur_dir=$(cd "$(dirname "$0")"; pwd)
echo "-----------------------check start------------------"
y=1
while true
do
    x=`ps aux| grep ETMDaemon | grep -v grep | grep -v check | wc -l`  # 计算进程数
    y=`ps aux| grep vod_httpserver | grep -v grep | grep -v check | wc -l`  # 计算进程数
    z=`ps aux| grep EmbedThunderManager | grep -v grep | grep -v check | wc -l`  # 计算进程数
    t=`netstat -nap|grep Emb|grep CLOSE|awk 'BEGIN{t=0;} { t++; }  END{print t; }'`  # 有几个连接失败的进程
    listen=`netstat -nap|grep Emb|grep LISTEN|awk 'BEGIN{t=0;} { t++; }  END{print t; }'`  # 有几个监听的进程
    let c=$x+$y+$z # 进程相加要大于7个
    if ( [ $y -lt $count ] && [ $c -gt 3 ] && [ $x -gt 0 ] && [ $y -gt 0 ] && [ $z -gt 0 ] ) #检测连接失败计数器是否超标，并且进程是否足够
    then
        if ( [ $t -lt 4 ] && [ $listen -gt 2 ] ) #如果小于四个连接失败，并且监听进程不少于3个
        then
	    if [ $Islog -eq 1 ];then
                echo `date "+%Y-%m-%d %H:%M:%S"`" Xware OK!">>$cur_dir/watchdog.log
	    fi
            sleep $tmr
        else #大于等于四个连接失败
	    let y++
	    if [ $Islog -eq 1 ];then
                echo `date "+%Y-%m-%d %H:%M:%S"`" Unormal! "$y>>$cur_dir/watchdog.log
	    fi
	    sleep $tmr
        fi
    else
        $cur_dir/portal
	if [ $Islog -eq 1 ];then
            echo `date "+%Y-%m-%d %H:%M:%S"`" Restart Xware!!!">>$cur_dir/watchdog.log
	fi
	let y=1
	sleep $tmr
    fi
done
