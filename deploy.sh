#!/bin/bash

function end
{
        echo "$@" 1>&2
        exit 1
}

PATH=/usr/bin:$PATH
export PATH
BRC=$1
APP=$2

###################################################################
#要確認
USR=
REP=
REF=
###################################################################

if [ -z "$APP" -o -z "$BRC" ]; then
        end "使用例 ./deploy.sh ブランチ名 アプリ名"
fi

cd /home/$USR/$APP || end "存在しないアプリケーション"

RBR="`git branch -a | grep "remotes/origin/HEAD" | awk '{print $3}'`"
LBR="`git branch -a | grep \*`"

if [ "$RBR" != "origin/$BRC" ]; then end "追跡リモートブランチ名が違う"; fi
if [ "$LBR" != "* $BRC" ]; then end "チェックアウト先のブランチ名が違う"; fi

RST=$(sudo -u $USR git pull $REP $BRC) || end "git pullに失敗"

echo $RST | grep "Already up-to-date" && exit 0

git diff --name-only HEAD^ | grep "$APP/package.json" && mv node_modules node_modules.bak && npm install || end "npm installに失敗"

$REF || end "反映に失敗"

end "正常終了"
