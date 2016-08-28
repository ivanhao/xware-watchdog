# xware-watchdog
这是一个为迅雷远程xware1.0x版本写的守护程序，使用方法是将start.sh和watchdog.sh拷到xware的程序文件夹下（跟portal放一起）。运行start.sh即可。每30秒检测一次。

###注：在watchdog.sh中有几个变量
logmode=1 #是否启用日志，默认为1（0：否；1：警告；2：debug）

tmr=15 #检测周期（秒）

count=5 #允许几次检测失败（建议不要小于5，否则容易频繁重启）
