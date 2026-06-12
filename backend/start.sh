#!/bin/bash

# 闪光少年后端服务启动脚本

# 定义默认配置
DEFAULT_PORT="8000"
DEFAULT_HOST="0.0.0.0"

# 显示帮助信息
show_help() {
    echo "使用方法: ./start.sh [选项]"
    echo ""
    echo "选项:"
    echo "  -p, --port <port>          指定服务端口 (默认: $DEFAULT_PORT)"
    echo "  -h, --host <host>          指定绑定地址 (默认: $DEFAULT_HOST)"
    echo "  --help                     显示帮助信息"
    echo ""
    echo "示例:"
    echo "  ./start.sh                 # 使用默认配置启动"
    echo "  ./start.sh -p 8080         # 使用8080端口启动"
    echo "  ./start.sh -h 127.0.0.1    # 仅本地访问"
}

# 解析命令行参数
while [[ $# -gt 0 ]]; do
    case $1 in
        -p|--port)
            PORT="$2"
            shift
            ;;
        -h|--host)
            HOST="$2"
            shift
            ;;
        --help)
            show_help
            exit 0
            ;;
        *)
            echo "未知参数: $1"
            show_help
            exit 1
            ;;
    esac
    shift
done

# 设置默认值
PORT=${PORT:-$DEFAULT_PORT}
HOST=${HOST:-$DEFAULT_HOST}

echo "=========================================="
echo "  闪光少年 - 后端服务启动脚本"
echo "=========================================="
echo "绑定地址: $HOST"
echo "服务端口: $PORT"
echo ""

# 检查Python是否安装
if ! command -v python3 &> /dev/null
then
    echo "错误: 未找到Python3，请先安装Python 3.8或更高版本"
    exit 1
fi

# 检查pip是否安装
if ! command -v pip3 &> /dev/null
then
    echo "错误: 未找到pip3，请先安装"
    exit 1
fi

# 显示Python版本
echo "Python版本:"
python3 --version
echo ""

# 检查是否已安装依赖
echo "检查依赖..."
if [ ! -d "venv" ]; then
    echo "未找到虚拟环境，创建中..."
    python3 -m venv venv
    
    if [ $? -ne 0 ]; then
        echo "错误: 创建虚拟环境失败"
        exit 1
    fi
    
    echo "安装依赖..."
    source venv/bin/activate
    pip3 install -r requirements.txt
    
    if [ $? -ne 0 ]; then
        echo "错误: 安装依赖失败"
        exit 1
    fi
    
    echo "依赖安装成功！"
    deactivate
fi

# 启动应用
echo ""
echo "=========================================="
echo "  启动后端服务"
echo "=========================================="
echo "执行: uvicorn app.main:app --host $HOST --port $PORT"
echo ""

# 进入虚拟环境并启动
source venv/bin/activate
uvicorn app.main:app --host $HOST --port $PORT

echo ""
echo "应用已停止"
