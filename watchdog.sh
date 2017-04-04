#!/bin/bash
logmode=1 #是否启用日志，默认为1（0：否；1：警告；2：debug）
tmr=10 #检测周期（秒）
count=3 #允许几次检测失败（建议不要小于3，否则容易频繁重启）
cur_dir=$(cd "$(dirname "$0")"; pwd)
echo "--------------------check start------------------">> $cur_dir/watchdog.log
if [ $logmode -eq 2 ];then # debug模式输出
    echo "--------------------debug mode-------------------">> $cur_dir/watchdog.log 
fi
if [ $logmode -eq 1 ];then # warnning模式输出
    echo "--------------------warnning mode-------------------">> $cur_dir/watchdog.log
fi
echo `date "+%Y-%m-%d %H:%M:%S"`" start log.">> $cur_dir/watchdog.log
fail=0
while true
do
    x=`ps aux| grep ETMDaemon | grep -v grep | grep -v check | wc -l`  # 计算进程数
    y=`ps aux| grep vod_httpserver | grep -v grep | grep -v check | wc -l`  # 计算进程数
    z=`ps aux| grep EmbedThunderManager | grep -v grep | grep -v check | wc -l`  # 计算进程数
    cl=`netstat -nap|grep Emb|grep CLOSE|awk 'BEGIN{t=0;} { t++; }  END{print t; }'`  # 有几个连接失败的进程
    listen=`netstat -nap|grep Emb|grep LISTEN|awk 'BEGIN{t=0;} { t++; }  END{print t; }'`  # 有几个监听的进程
    es=`netstat -nap|grep Emb|grep ESTABLISH|awk 'BEGIN{t=0;} { t++; }  END{print t; }'`  # 有几个连接成功的进程
    let c=$x+$y+$z # 进程相加要大于7个
    let check=$es-$cl #连接失败的数量减连接成功数量，正常应该大于0，如果小于0基本前台就异常了
############################----------DEBUG INFO-----------------############################
    if [ $logmode -eq 2 ];then # debug模式输出
    	if ( [ $fail -gt $count ] ) 
	then
	    echo `date "+%Y-%m-%d %H:%M:%S"`" 检测到非正常状态超过设置的最大次数!">> $cur_dir/watchdog.log
	fi
	if ( [ $x -le 0 ] )
	then
            echo `date "+%Y-%m-%d %H:%M:%S"`" 没有ETMDaemon进程！">> $cur_dir/watchdog.log
	fi
	if ( [ $y -le 0 ] )
	then
            echo `date "+%Y-%m-%d %H:%M:%S"`" 没有vod_httpserver进程！">> $cur_dir/watchdog.log
	fi
	if ( [ $z -le 0 ] )
	then
            echo `date "+%Y-%m-%d %H:%M:%S"`" 没有EmbedThunderManager进程！">> $cur_dir/watchdog.log
	fi
	if ( [ $cl -ge 4 ] ) 
	then
            echo `date "+%Y-%m-%d %H:%M:%S"`" 失败连接数:"$cl"大于等于4！">> $cur_dir/watchdog.log
	fi
	if ( [ $check -le 0 ] ) 
	then
            echo `date "+%Y-%m-%d %H:%M:%S"`" 失败连接数:"$cl"大于等于成功的连接数:"$es"！">> $cur_dir/watchdog.log
	fi
	if ( [ $listen -lt 3 ] ) 
	then
            echo `date "+%Y-%m-%d %H:%M:%S"`" 监听数"$listen"小于3！">> $cur_dir/watchdog.log
	fi
    fi
###########################------------DEBUG INFO END-------------###########################
    if ( [ $fail -lt $count ] ) #检测连接失败计数器是否超标，并且进程是否足够
    then
        if (  [ $cl -lt 4 ] && [ $check -gt 0 ]  && [ $listen -ge 3 ] && [ $x -gt 0 ] && [ $y -gt 0 ] && [ $z -gt 0 ] )  #如果小于四个连接失败或者失败数大于成功数或者监听进程不少于3个
        then
	    if [ $logmode -eq 2 ];then
                echo `date "+%Y-%m-%d %H:%M:%S"`" Xware OK!">> $cur_dir/watchdog.log
	    fi
	    let fail=0
            sleep $tmr
        else #大于等于四个连接失败，或监听进程少于3个
	    ((fail++))
	    if [ $logmode -ne 0 ];then
                echo `date "+%Y-%m-%d %H:%M:%S"`" Unnormal! "$fail>> $cur_dir/watchdog.log
	    fi
	    sleep $tmr
        fi
    else
	if [ $logmode -ne 0 ];then
            echo `date "+%Y-%m-%d %H:%M:%S"`" Restart Xware!!!">> $cur_dir/watchdog.log
	fi
        $cur_dir/portal>>$cur_dir/watchdog.log
	let fail=0
	sleep $tmr*3 #刚重启完，间隔可以久点
    fi
done
