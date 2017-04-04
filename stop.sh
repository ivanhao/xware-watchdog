#!/bin/bash
kill -9 `pidof EmbedThunderManager`
kill -9 `pidof ETMDaemon`
kill -9 `pidof vod_httpserver`
killall watchdog.sh
