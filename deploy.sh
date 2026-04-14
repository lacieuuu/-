#!/bin/bash
echo "======================================================="
echo "✨ 账号管理器 - 全自动终极部署脚本 (Unix/Linux 版) ✨"
echo "======================================================="

OS="$(uname -s)"
IS_TERMUX=false
[[ -n "$TERMUX_VERSION" ]] && IS_TERMUX=true

# 1. 环境自动补全
if ! command -v git &> /dev/null || ! command -v npm &> /dev/null; then
    echo "📦 正在安装基础环境..."
    if $IS_TERMUX; then pkg update -y && pkg install git nodejs -y
    elif [[ "$OS" == "Darwin" ]]; then brew install git node
    else sudo apt update && sudo apt install git nodejs npm -y; fi
fi

if ! command -v vercel &> /dev/null; then
    echo "📦 正在安装 Vercel CLI..."
    npm install -g vercel
fi

# 2. 代码下载
if [ ! -f "index.html" ]; then
    if [ -d "private-account-manager" ]; then cd "private-account-manager"
    else git clone https://github.com/lacieuuu/private-account-manager.git && cd "private-account-manager"; fi
fi

echo "======================================================="
read -p "1/3 Supabase URL: " u_url
read -p "2/3 Supabase Key: " u_key
read -p "3/3 Vercel Token: " u_token

echo "⚙️ 正在注入配置..."
# 匹配英文占位符，避免斜杠冲突
sed -i "s|REPLACE_WITH_URL|$u_url|g" index.html
sed -i "s|REPLACE_WITH_KEY|$u_key|g" index.html

echo "☁️ 正在生成唯一网址并部署..."
# 生成 6 位随机数
RAND_ID=$(LC_ALL=C tr -dc 'a-z0-9A-Z' < /dev/urandom | head -c 6)
PROJECT_NAME="private-account-manager-$RAND_ID"

vercel --prod --yes --name "$PROJECT_NAME" --token="$u_token"

echo "======================================================="
echo "🎉 部署成功！网址为: https://$PROJECT_NAME.vercel.app"
