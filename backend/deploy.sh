#!/bin/bash

# 闪光少年后端服务部署脚本

# 定义服务器配置
DEFAULT_SERVER="user@your-server-ip"
DEFAULT_PORT="22"
DEFAULT_REMOTE_DIR="/opt/ai-sports/backend"

# 显示帮助信息
show_help() {
    echo "使用方法: ./deploy.sh [选项]"
    echo ""
    echo "选项:"
    echo "  -s, --server <server>      指定服务器地址 (默认: $DEFAULT_SERVER)"
    echo "  -p, --port <port>          指定SSH端口 (默认: $DEFAULT_PORT)"
    echo "  -d, --dir <dir>            指定远程部署目录 (默认: $DEFAULT_REMOTE_DIR)"
    echo "  --help                     显示帮助信息"
    echo ""
    echo "示例:"
    echo "  ./deploy.sh                        # 使用默认配置部署"
    echo "  ./deploy.sh -s admin@192.168.1.100 # 指定服务器"
    echo "  ./deploy.sh -d /opt/app/backend    # 指定部署目录"
}

# 解析命令行参数
while [[ $# -gt 0 ]]; do
    case $1 in
        -s|--server)
            SERVER="$2"
            shift
            ;;
        -p|--port)
            SSH_PORT="$2"
            shift
            ;;
        -d|--dir)
            REMOTE_DIR="$2"
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
SERVER=${SERVER:-$DEFAULT_SERVER}
SSH_PORT=${SSH_PORT:-$DEFAULT_PORT}
REMOTE_DIR=${REMOTE_DIR:-$DEFAULT_REMOTE_DIR}

echo "=========================================="
echo "  闪光少年 - 后端服务部署脚本"
echo "=========================================="
echo "服务器地址: $SERVER"
echo "SSH端口: $SSH_PORT"
echo "远程目录: $REMOTE_DIR"
echo ""

# 检查是否已停止本地服务
echo "检查本地服务状态..."
LOCAL_PID=$(lsof -ti:8000 2>/dev/null)
if [ ! -z "$LOCAL_PID" ]; then
    echo "检测到本地服务正在运行，停止中..."
    ./stop.sh
fi

# 检查git状态
echo ""
echo "检查代码状态..."
if ! git diff --quiet; then
    echo "警告: 存在未提交的修改"
    read -p "是否继续部署? (y/N) " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "部署已取消"
        exit 0
    fi
fi

# 同步代码到服务器
echo ""
echo "=========================================="
echo "  同步代码到服务器"
echo "=========================================="
echo "执行: rsync -avz --delete -e 'ssh -p $SSH_PORT' . $SERVER:$REMOTE_DIR"
echo ""

# 创建必要的目录
ssh -p $SSH_PORT $SERVER "mkdir -p $REMOTE_DIR"

# 使用rsync同步代码（排除不必要的文件）
rsync -avz --delete \
    --exclude='.git/' \
    --exclude='__pycache__/' \
    --exclude='*.pyc' \
    --exclude='*.pyo' \
    --exclude='.DS_Store' \
    --exclude='*.log' \
    --exclude='uploads/' \
    -e "ssh -p $SSH_PORT" \
    . $SERVER:$REMOTE_DIR

if [ $? -ne 0 ]; then
    echo "错误: 代码同步失败"
    exit 1
fi

echo "代码同步成功！"

# 在服务器上安装依赖并启动服务
echo ""
echo "=========================================="
echo "  在服务器上配置服务"
echo "=========================================="

ssh -p $SSH_PORT $SERVER << EOF
    cd $REMOTE_DIR
    
    # 停止旧服务
    if [ -f "stop.sh" ]; then
        echo "停止旧服务..."
        ./stop.sh
    fi
    
    # 创建虚拟环境
    if [ ! -d "venv" ]; then
        echo "创建虚拟环境..."
        python3 -m venv venv
    fi
    
    # 安装依赖
    echo "安装/更新依赖..."
    source venv/bin/activate
    pip3 install -r requirements.txt
    
    # 设置执行权限
    chmod +x start.sh stop.sh
    
    echo "服务配置完成！"
EOF

if [ $? -ne 0 ]; then
    echo "错误: 服务器配置失败"
    exit 1
fi

echo ""
echo "=========================================="
echo "  部署完成！"
echo "=========================================="
echo "服务器地址: $SERVER"
echo "远程目录: $REMOTE_DIR"
echo ""
echo "启动命令:"
echo "  ssh -p $SSH_PORT $SERVER 'cd $REMOTE_DIR && ./start.sh'"
echo ""
echo "停止命令:"
echo "  ssh -p $SSH_PORT $SERVER 'cd $REMOTE_DIR && ./stop.sh'"
echo ""
echo "=========================================="
