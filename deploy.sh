#!/bin/bash
echo "✨ 欢迎使用账号管理器一键部署程序 ✨"

# 交互式获取用户凭证
read -p "1/3 请输入你的 JSONBin BIN_ID: " user_bin_id
read -p "2/3 请输入你的 JSONBin MASTER_KEY: " user_master_key
read -p "3/3 请输入你的 Vercel Token (用于免登录): " user_vercel_token

echo "⚙️ 正在配置你的专属网页..."

# 替换 index.html 中的占位符
sed -i.bak "s/{{YOUR_BIN_ID}}/$user_bin_id/g" index.html
sed -i.bak "s/{{YOUR_MASTER_KEY}}/$user_master_key/g" index.html
rm index.html.bak

echo "☁️ 正在免登录推送到 Vercel，请稍候..."

# 核心：使用 --token 参数直接跨过登录步骤进行生产环境部署
vercel --prod --yes --token="$user_vercel_token"

echo " 部署大功告成！请复制上方终端输出的 Vercel 网址访问你的平台。"

