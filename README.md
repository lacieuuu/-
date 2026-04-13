# 个人账号管理工具
简易私人专属账号管理工具。

*切记*：**不要把你的专属工具网址暴露在任何公共环境下**，为了图方便我没有设计登录网址要输入密码的步骤，意味着任何人只要知道知道你的工具网址就能访问你的账号库！

# 功能
* ✅内置邮箱随机生成器，可添加自定义邮箱后缀，生成后可单独复制username/完整邮箱/密码，点击保存按钮自动入邮箱库
* ✅支持跨设备云端同步账号库
* ✅分为邮箱库、网站库（放杂七杂八账号）、api库（存放薅羊毛收集的url和API key 😋），网站库和api库可以添加备注提醒账号用途
* ✅可批量粘贴导入，文件（.txt/.csv）导入，以及文件导出
* ✅每个账号名/密码都有单独复制按钮，懒人福音
* ✅私有化部署，保护隐私

# 使用步骤
### 第一阶段：准备工作
 1. **Supabase Project URL** 与 **anon public Key**（数据存储凭证）
 * 访问 https://supabase.com/ 注册账号并创建一个新项目（Project）。
 * 进入项目仪表盘，在导航菜单里找到并点击 **Project Settings**，分别在 **API Keys**和**Data Api**里复制你的**anon public key** 和 **Project URL**。
 2. **初始化数据表 (核心步骤)**
 * 点击仪表盘右上角>_ 图标（SQL Editor）。
 * 粘贴并运行（Run）以下代码来创建数据表和初始数据：
   ```sql
   create table if not exists manager_data (
     id int8 primary key default 1,
     content jsonb not null,
     updated_at timestamp with time zone default now()
   );
   insert into manager_data (id, content) values (1, '{"acc":[], "site":[], "api":[]}') on conflict (id) do nothing;
   
   ```
 * 运行成功后，点击右上角导航菜单里的 **Table Editor**（表格图标），选中刚创建的 manager_data 表。
 * 确保页面上方选中的是 **Disable RLS**（关闭权限控制，确保网页端可正常读写数据）。
 3. **Vercel Token**（免登录部署令牌）
 * 注册登录vercel官网 
 * 进入 https://vercel.com/account/tokens 页面。
 * 创建并复制token 令牌，用于在终端执行免登录的自动化部署。
### 第二阶段：部署
 1. **运行脚本**：
  *  Windows 打开powershell，执行以下命令：
   ```powershell
   Invoke-RestMethod -Uri "https://raw.githubusercontent.com/lacieuuu/private-account-manager/main/deploy.ps1" | Invoke-Expression
   
   ```

 *  安卓手机打开termux，执行以下命令：
   ```bash
   <(curl -s https://raw.githubusercontent.com/lacieuuu/private-account-manager/main/deploy.sh)

   ```
 2. **完成配置**
 * 根据终端弹出的提示，依次粘贴 **Project URL**、**anon public Key** 和 **Vercel Token** 并按回车。
 * 脚本将自动完成密钥的替换与打包发布，部署成功后会返回属于你的专属访问网址。
