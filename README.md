# xware-watchdog
这是一个为迅雷远程xware1.0x版本写的守护程序，使用方法是将start.sh、stop.sh和watchdog.sh拷到xware的程序文件夹下（跟portal放一起）。运行start.sh即可。程序定期检测一次。

** Xware1.0.31_netgear_6300v2.zip是armv7的迅雷远程固件，树莓派、香蕉派可用。解压后可用。 **

### 用法：
1. 启动\重启：`./start.sh`
2. 停止：`./stop.sh`

### 设置开机自动启动：
假设xware目录为`/opt/xware`，将如下的内容存到`/etc/init.d`下，命名为`xware`:
```
#!/bin/sh 
### BEGIN INIT INFO
# Provides: xware
# Required-Start: $network $remote_fs $syslog $time
# Required-Stop:
# Default-Start: 2 3 4 5
# Default-Stop: 0 1 6
# Short-Description: xware
### END INIT INFO
SERVICE_USE_PID=1

START=50

start() {
        /bin/bash /opt/xware/start.sh
}

stop() {
        /opt/xware/stop.sh
}

case "$1" in
 start)
        start
        ;;
 stop)
        stop
        ;;

 *)
        echo $"Usage: $0 {start|stop}"  
        exit 1
        ;;
esac
```

1. 启动\重启：sudo xware start
2. 停止：sudo xware stop
默认是开机自动启动

### 注：在watchdog.sh中有几个变量
logmode=2 #是否启用日志，默认为2（0：否；1：警告；2：debug）。日志watchdog.log保存在当前目录。debug模式日志量较大。测试稳定后，最好改为0，以免出现写日志时意外断电的极端情况下对磁盘造成的损坏。

tmr=30 #检测周期（秒）

count=3 #允许几次检测失败（建议不要小于3，否则容易频繁重启）

### 附：迅雷远程xware1.0.31下载地址：
http://dl.lazyzhu.com/file/Thunder/Xware/1.0.31/

### 迅雷远程官方论坛：
http://g.xunlei.com/forum-51-1.html
