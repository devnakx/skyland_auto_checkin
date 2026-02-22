@echo off
setlocal enabledelayedexpansion

:: 获取脚本所在目录
set "ROOTDIR=%~dp0"
cd /d "%ROOTDIR%"

:: 设置环境变量（用分号分隔多个token）
set SKYLAND_TOKEN=token1;token2;token3;

:: 执行Python脚本
call python .\main.py

pause