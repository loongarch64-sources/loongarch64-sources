# LoongArch64 Sources

适用于 LoongArch64 的源码归档

## 版本管理

上游每一个版本对应一个分支，版本分支使用孤立分支（orphan），以上游源码
进行分支初始化，然后进行补丁提交，如果整体补丁较小，建议将多次提交合并
为一次补丁。


## 使用说明
`version.sh` 用于快速初始化一个上游分支。
```
LOONGARCH64_SOURCES_DIRECTORY=/tmp/loongarch64-sources \
LOONGARCH64_SOURCES_UPSTREAM=github \
LOONGARCH64_SOURCES_ORGANIZATION=kubernetes \
LOONGARCH64_SOURCES_PROJECT=kubernetes  \
LOONGARCH64_SOURCES_VERSION=v1.29.0 \
./version.sh
```
