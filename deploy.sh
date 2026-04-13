#!/bin/bash
echo "✨ 欢迎使用账号管理器一键部署程序 (Supabase 版) ✨"

# 交互式获取用户凭证
read -p "1/3 请输入你的 Supabase Project URL: " user_supabase_url
read -p "2/3 请输入你的 Supabase anon public Key: " user_supabase_key
read -p "3/3 请输入你的 Vercel Token (用于免登录部署): " user_vercel_token

echo "⚙️ 正在配置你的专属网页..."

# 替换 index.html 中的占位符
# 注意：因为 URL 中包含 '/'，所以此处的 sed 替换分隔符改用 '|'
sed -i.bak "s|在这里填入你的_Project_URL|$user_supabase_url|g" index.html
sed -i.bak "s|在这里填入你的_anon_public_Key|$user_supabase_key|g" index.html

# 删除产生的备份文件
rm index.html.bak

echo "☁️ 正在免登录推送到 Vercel，请稍候..."

# 核心：使用 --token 参数直接跨过登录步骤进行生产环境部署
vercel --prod --yes --token="$user_vercel_token"

echo "🎉 部署大功告成！请复制上方终端输出的 Vercel 网址访问你的平台。"
