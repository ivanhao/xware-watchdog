#!/bin/bash
Islog=0 #是否启用日志，默认为0（0：否；1：是）
tmr=15 #检测周期（秒）
count=5 #允许几次检测失败（建议不要小于5，否则容易频繁重启）
echo "-----------------------check start------------------"
fail=0
while true
do
    x=`ps aux| grep ETMDaemon | grep -v grep | grep -v check | wc -l`  # 计算进程数
    y=`ps aux| grep vod_httpserver | grep -v grep | grep -v check | wc -l`  # 计算进程数
    z=`ps aux| grep EmbedThunderManager | grep -v grep | grep -v check | wc -l`  # 计算进程数
    t=`netstat -nap|grep Emb|grep CLOSE|awk 'BEGIN{t=0;} { t++; }  END{print t; }'`  # 有几个连接失败的进程
    listen=`netstat -nap|grep Emb|grep LISTEN|awk 'BEGIN{t=0;} { t++; }  END{print t; }'`  # 有几个监听的进程
    es=`netstat -nap|grep Emb|grep ESTABLISH|awk 'BEGIN{t=0;} { t++; }  END{print t; }'`  # 有几个监听的进程
    let c=$x+$y+$z # 进程相加要大于7个
    let check=$t-$es
    if ( [ $fail -lt $count ] && [ $c -gt 3 ] && [ $x -gt 0 ] && [ $y -gt 0 ] && [ $z -gt 0 ] ) #检测连接失败计数器是否超标，并且进程是否足够
    then
        if (( [ $t -lt 4 ] || [ $check -gt 0 ] ) && [ $listen -gt 2 ] ) #如果小于四个连接失败或者失败数大于成功数，并且监听进程不少于3个
        then
	    if [ $Islog -eq 1 ];then
                echo `date "+%Y-%m-%d %H:%M:%S"`" Xware OK!"
	    fi
	    let fail=0
            sleep $tmr
<<<<<<< HEAD
=======
            let fail=0
>>>>>>> 88e3a2da8ca013ca2c9d216a402e4d9f66ce34bc
        else #大于等于四个连接失败，或监听进程少于3个
	    ((fail++))
	    if [ $Islog -eq 1 ];then
                echo `date "+%Y-%m-%d %H:%M:%S"`" Unormal! "$fail
	    fi
	    sleep $tmr
        fi
    else
        $cur_dir/portal
	if [ $Islog -eq 1 ];then
            echo `date "+%Y-%m-%d %H:%M:%S"`" Restart Xware!!!"
	fi
	let fail=0
<<<<<<< HEAD
	sleep $tmr 
=======
	sleep $tmr #刚重启完，间隔可以久点
>>>>>>> 88e3a2da8ca013ca2c9d216a402e4d9f66ce34bc
	sleep $tmr #刚重启完，间隔可以久点
    fi
done
