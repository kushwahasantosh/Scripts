#!/bin/sh
# @Author: logic
# @Email: santoshvkushwaha@gmail.com
# @Date:   2015-09-06 23:42:11
# @Last Modified by:   logic
# @Last Modified time: 2015-11-19 21:20:51

# ~/Scripts/aria2HookOnPause.sh
# libnotify will notifiy the user if file is downloaded.
# aria2 passes 3 arguments to specified command when it is executed. These arguments are
# GID, the number of files and file path. For http,ftp downloads, usually the number of files is 1.
# 
GID=$1
NoOfFiles=$2
FilePath=$3
notify-send "Aria2" "Downloading paused. \n File: $3" --icon=dialog-information --expire-time=5000
