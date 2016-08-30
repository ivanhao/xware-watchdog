# xware-watchdog
这是一个为迅雷远程xware1.0x版本写的守护程序，使用方法是将start.sh和watchdog.sh拷到xware的程序文件夹下（跟portal放一起）。运行start.sh即可。程序定期检测一次。

###注：在watchdog.sh中有几个变量
logmode=2 #是否启用日志，默认为2（0：否；1：警告；2：debug）。日志watchdog.log保存在当前目录。debug模式日志量较大。测试稳定后，最好改为0，以免出现写日志时意外断电的极端情况下对磁盘造成的损坏。

tmr=30 #检测周期（秒）

count=3 #允许几次检测失败（建议不要小于3，否则容易频繁重启）

### 附：迅雷远程xware1.0.31下载地址：
http://dl.lazyzhu.com/file/Thunder/Xware/1.0.31/

### 迅雷远程官方论坛：
http://g.xunlei.com/forum-51-1.html
