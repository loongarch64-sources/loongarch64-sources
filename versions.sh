#!/bin/bash

set -e
set -u
wkdir=$(dirname $(readlink -f $0))

SOURCES_DIRECTORY=${LOONGARCH64_SOURCES_DIRECTORY:-"~/loongarch64-sources/sources"}
SOURCES_UPSTREAM=${LOONGARCH64_SOURCES_UPSTREAM:-"github"}

org=$LOONGARCH64_SOURCES_ORGANIZATION
proj=$LOONGARCH64_SOURCES_PROJECT
version=$LOONGARCH64_SOURCES_VERSION
upstrem=
case $SOURCES_UPSTREAM in
    github) upstream=github.com;;
    gitee)  upstream=gitee.com;;
esac

init_project()
{
    mkdir -p $SOURCES_DIRECTORY/$org/$proj

    pushd $SOURCES_DIRECTORY/$org/$proj > /dev/null 2>&1

    # 创建 README.md
    cat << EOF > README.md
# $org/$proj

<https://$upstream/$org/$proj>
EOF

    # 初始化 git 仓库
    git init --quiet
    git add . > /dev/null 2>&1
    git commit --quiet -m 'init'
    git branch -M main

    # 自动关联远程仓库
    git remote add origin git@$upstream:loongarch64-sources/$org-$proj.git
    popd > /dev/null 2>&1
}

init_branch()
{
    pushd $SOURCES_DIRECTORY/$org/$proj > /dev/null 2>&1

    echo "Create $org/$proj $version..."
    # 检测是否是 git 仓库
    if [ ! -d .git ]; then
        echo "$SOURCES_DIRECTORY/$org/$proj is not a valid sources tree."
    fi

    # 检测是否存在该分支
    if git branch | grep -q $version; then
        echo "Branch $version already exists."
        return 0
    fi

    # 创建独立分支
    git checkout --orphan $version

    # 初始化上游源码
    tempdir=$(mktemp -d)
    
    wget -O $tempdir/$version.zip --quiet --show-progress https://$upstream/$org/$proj/archive/refs/tags/$version.zip
    unzip -q $tempdir/$version.zip -d $tempdir
    cp -R $tempdir/$proj-${version#v}/* $SOURCES_DIRECTORY/$org/$proj/
    
    # 初始化独立分支

    git add . > /dev/null 2>&1
    git commit --quiet -m "$version init"

    
    popd > /dev/null 2>&1

}

if [ ! -d $SOURCES_DIRECTORY/$org/$proj ]; 
then
    init_project
fi



init_branch
