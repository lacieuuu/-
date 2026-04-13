#!/bin/bash
echo "======================================================="
echo "✨ 账号管理器 - 全自动终极部署脚本 (Supabase 版) ✨"
echo "======================================================="

# 1. 识别操作系统环境
OS="$(uname -s)"
IS_TERMUX=false
if [[ -n "$TERMUX_VERSION" ]] || [[ "$(uname -o 2>/dev/null)" == "Android" ]]; then
    IS_TERMUX=true
    echo "📱 识别到运行环境：Android Termux"
elif [[ "$OS" == "Darwin" ]]; then
    echo "🍏 识别到运行环境：Mac OS"
elif [[ "$OS" == "Linux" ]]; then
    echo "🐧 识别到运行环境：Linux"
elif [[ "$OS" == MINGW* || "$OS" == CYGWIN* || "$OS" == MSYS* ]]; then
    echo "🪟 识别到运行环境：Windows (Git Bash)"
fi

echo "🔍 正在检测并配置基础环境..."

# 2. 检测并自动安装 Git 和 Node.js
install_base_env() {
    if $IS_TERMUX; then
        echo "📦 正在 Termux 中静默安装 git 和 nodejs..."
        pkg update -y && pkg upgrade -y
        pkg install git nodejs -y
    elif [[ "$OS" == "Darwin" ]]; then
        if ! command -v brew &> /dev/null; then
            echo "❌ Mac 系统缺少 Homebrew 包管理器，请先前往 https://brew.sh 安装"
            exit 1
        fi
        echo "📦 正在 Mac 中安装 git 和 node..."
        brew install git node
    elif [[ "$OS" == "Linux" ]]; then
        if command -v apt &> /dev/null; then
            echo "📦 正在 Linux 中安装 git 和 nodejs..."
            sudo apt update && sudo apt install git nodejs npm -y
        fi
    elif [[ "$OS" == MINGW* || "$OS" == CYGWIN* || "$OS" == MSYS* ]]; then
        echo "❌ Windows 无法在终端内全自动安装 Node.js，请前往官网(nodejs.org)手动下载安装后重试！"
        exit 1
    fi
}

if ! command -v git &> /dev/null || ! command -v npm &> /dev/null; then
    install_base_env
else
    echo "✅ 基础环境 (Git, Node.js) 已就绪"
fi

# 3. 检测并自动安装 Vercel CLI
if ! command -v vercel &> /dev/null; then
    echo "📦 检测到未安装 Vercel CLI，正在通过 npm 全局安装 (可能需要一点时间)..."
    npm install -g vercel
else
    echo "✅ Vercel 部署工具已就绪"
fi

# 4. 自动获取/更新项目代码
PROJECT_DIR="private-account-manager"
if [ ! -f "index.html" ]; then
    echo "📥 正在从 GitHub 拉取最新项目代码..."
    if [ -d "$PROJECT_DIR" ]; then
        cd "$PROJECT_DIR"
        git pull origin main
    else
        git clone https://github.com/lacieuuu/private-account-manager.git
        cd "$PROJECT_DIR"
    fi
else
    echo "✅ 已处于项目目录中"
fi

echo "======================================================="
echo "📝 请输入你的配置信息 (右键或长按屏幕即可粘贴)："

read -p "1/3 请输入你的 Supabase Project URL: " user_supabase_url
read -p "2/3 请输入你的 Supabase anon public Key: " user_supabase_key
read -p "3/3 请输入你的 Vercel Token (用于免登录): " user_vercel_token

echo "⚙️ 正在将密钥注入你的专属网页..."

# 5. 兼容苹果 Mac 和 Linux/Android 的替换语法
if [[ "$OS" == "Darwin" ]]; then
    sed -i '' "s|在这里填入你的_Project_URL|$user_supabase_url|g" index.html
    sed -i '' "s|在这里填入你的_anon_public_Key|$user_supabase_key|g" index.html
else
    sed -i.bak "s|在这里填入你的_Project_URL|$user_supabase_url|g" index.html
    sed -i.bak "s|在这里填入你的_anon_public_Key|$user_supabase_key|g" index.html
    rm -f index.html.bak
fi

echo "☁️ 正在免登录推送到 Vercel 生产环境，请稍候..."

# 6. 执行部署
vercel --prod --yes --token="$user_vercel_token"

echo "======================================================="
echo "🎉 部署大功告成！"
echo "👉 请复制上方输出的 Vercel 网址 (通常是 https://xxx.vercel.app) 访问你的平台。"
