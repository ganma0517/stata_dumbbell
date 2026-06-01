#!/bin/bash
#===============================================================
# dumbbell 一鍵推送腳本（雙擊即可執行）
#
# 第一次使用前：
#   1) 到 https://github.com/new 建立一個 Public 倉庫，名稱填 stata_dumbbell
#      （不要勾任何初始檔）
#   2) 把下面這行的 PUT_TOKEN_HERE 換成你的有效 GitHub token（ghp_開頭）
#      然後存檔，再雙擊本檔。
#===============================================================
TOKEN="PUT_TOKEN_HERE"
USER="ganma0517"
REPO="stata_dumbbell"
EMAIL="jay8956047@gmail.com"
NAME="Wen-Cheng Lin"

cd "$(dirname "$0")" || exit 1
echo "==> 專案資料夾: $(pwd)"

# 清除殘留 git lock
rm -f .git/index.lock .git/HEAD.lock .git/config.lock .git/refs/remotes/origin/main.lock 2>/dev/null

# 初始化（若尚未是 git 倉庫）
if [ ! -d .git ]; then
  echo "==> 初始化 git 倉庫"
  git init
  git branch -M main
fi

git config user.email "$EMAIL"
git config user.name  "$NAME"

echo "==> 加入並提交所有變更"
git add -A
git commit -m "update dumbbell" || echo "（沒有新變更可提交，或已提交）"

# 設定帶 token 的 remote
if [ "$TOKEN" != "PUT_TOKEN_HERE" ] && [ -n "$TOKEN" ]; then
  REMOTE_URL="https://${USER}:${TOKEN}@github.com/${USER}/${REPO}.git"
  if git remote | grep -q origin; then
    git remote set-url origin "$REMOTE_URL"
  else
    git remote add origin "$REMOTE_URL"
  fi
else
  echo "！！ 尚未填入 token：請編輯本檔，把 PUT_TOKEN_HERE 換成有效 token 後再執行。"
fi

echo "==> 推送到 GitHub"
git push -u origin main

echo ""
echo "==> 完成。若看到 'main -> main' 即成功。"
echo "    若出現 'Repository not found'，請先到 https://github.com/new 建立名為 ${REPO} 的 Public 倉庫。"
echo "    若出現 'Authentication failed'，請確認 token 正確（ghp_ 開頭、無中文）。"
echo ""
read -n 1 -s -r -p "按任意鍵關閉視窗..."
