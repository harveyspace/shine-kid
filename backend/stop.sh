#!/bin/bash

# 闪光少年后端服务停止脚本

echo "=========================================="
echo "  闪光少年 - 后端服务停止脚本"
echo "=========================================="
echo ""

# 定义服务端口
SERVICE_PORT="8000"

# 查找运行中的uvicorn进程（通过端口匹配）
PID=$(lsof -ti:$SERVICE_PORT 2>/dev/null)

# 如果没找到，尝试通过进程名查找
if [ -z "$PID" ]; then
    PID=$(ps aux | grep 'uvicorn' | grep 'app.main' | grep -v grep | awk '{print $2}')
fi

# 如果还是没找到，尝试查找包含ai-sports的Python进程
if [ -z "$PID" ]; then
    PID=$(ps aux | grep 'ai-sports' | grep -v grep | grep python | awk '{print $2}')
fi

if [ -z "$PID" ]; then
    echo "未找到运行中的后端服务进程"
    echo "服务可能未运行"
    echo ""
    echo "尝试查找所有Python进程..."
    ps aux | grep python | grep -v grep
else
    echo "找到服务进程，PID: $PID"
    echo ""
    
    # 尝试优雅停止
    echo "尝试优雅停止服务..."
    kill $PID
    
    # 等待进程结束
    for i in {1..10}; do
        if ! ps -p $PID > /dev/null 2>&1; then
            echo "服务已成功停止"
            exit 0
        fi
        echo "等待进程结束... ($i/10)"
        sleep 1
    done
    
    # 如果进程还在运行，强制停止
    if ps -p $PID > /dev/null 2>&1; then
        echo "进程未响应，强制停止..."
        kill -9 $PID
        sleep 1
        
        if ! ps -p $PID > /dev/null 2>&1; then
            echo "服务已强制停止"
        else
            echo "错误: 无法停止服务进程"
            exit 1
        fi
    fi
fi

echo ""
echo "=========================================="
