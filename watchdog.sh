#!/bin/bash
logmode=2 #是否启用日志，默认为1（0：否；1：警告；2：debug）
tmr=30 #检测周期（秒）
count=3 #允许几次检测失败（建议不要小于3，否则容易频繁重启）
echo "-----------------------check start------------------"
echo `date "+%Y-%m-%d %H:%M:%S"`" start log."
cur_dir=$(cd "$(dirname "$0")"; pwd)
fail=0
while true
do
    x=`ps aux| grep ETMDaemon | grep -v grep | grep -v check | wc -l`  # 计算进程数
    y=`ps aux| grep vod_httpserver | grep -v grep | grep -v check | wc -l`  # 计算进程数
    z=`ps aux| grep EmbedThunderManager | grep -v grep | grep -v check | wc -l`  # 计算进程数
    t=`netstat -nap|grep Emb|grep CLOSE|awk 'BEGIN{t=0;} { t++; }  END{print t; }'`  # 有几个连接失败的进程
    listen=`netstat -nap|grep Emb|grep LISTEN|awk 'BEGIN{t=0;} { t++; }  END{print t; }'`  # 有几个监听的进程
    es=`netstat -nap|grep Emb|grep ESTABLISH|awk 'BEGIN{t=0;} { t++; }  END{print t; }'`  # 有几个连接成功的进程
    let c=$x+$y+$z # 进程相加要大于7个
    let check=$t-$es #连接失败的数量减连接成功数量，正常应该大于0，如果小于0基本前台就异常了
############################----------DEBUG INFO-----------------############################
    if [ $logmode -ne 0 ];then # debug模式输出
	echo "--------------------debug info-------------------"
    	if ( [ $fail -gt $count ] ) #检测连接失败计数器是否超标，并且进程是否足够
	then
	    echo `date "+%Y-%m-%d %H:%M:%S"`" 检测到非正常状态超过设置的最大次数!"
	fi
	if ( [ $x -lt 0 ] ) #检测连接失败计数器是否超标，并且进程是否足够
	then
            echo `date "+%Y-%m-%d %H:%M:%S"`" 没有ETMDaemon进程！"
	fi
	if ( [ $y -lt 0 ] ) #检测连接失败计数器是否超标，并且进程是否足够
	then
            echo `date "+%Y-%m-%d %H:%M:%S"`" 没有vod_httpserver进程！"
	fi
	if ( [ $z -lt 0 ] ) #检测连接失败计数器是否超标，并且进程是否足够
	then
            echo `date "+%Y-%m-%d %H:%M:%S"`" 没有EmbedThunderManager进程！"
	fi
    fi
###########################------------DEBUG INFO END-------------###########################
    if ( [ $fail -lt $count ] && [ $x -gt 0 ] && [ $y -gt 0 ] && [ $z -gt 0 ] ) #检测连接失败计数器是否超标，并且进程是否足够
    then
        if (  [ $t -lt 4 ] || [ $check -gt 0 ] || [ $listen -gt 2 ] )  #如果小于四个连接失败或者失败数大于成功数或者监听进程不少于3个
        then
	    if [ $logmode -eq 2 ];then
                echo `date "+%Y-%m-%d %H:%M:%S"`" Xware OK!"
	    fi
	    let fail=0
            sleep $tmr
        else #大于等于四个连接失败，或监听进程少于3个
	    ((fail++))
	    if [ $logmode -ne 0 ];then
                echo `date "+%Y-%m-%d %H:%M:%S"`" Unormal! "$fail
	    fi
	    sleep $tmr
        fi
    else
	if [ $logmode -ne 0 ];then
            echo `date "+%Y-%m-%d %H:%M:%S"`" Restart Xware!!!"
	fi
        $cur_dir/portal
	let fail=0
	sleep $tmr 
	sleep $tmr #刚重启完，间隔可以久点
    fi
done
