#!/bin/bash

set -e  # 如果任何命令失败，则退出脚本
set -u  # 如果使用未定义的变量，则退出脚本

# 确保 version.sh 可执行
chmod +x ./version.sh

# 运行 version.sh 生成 version.txt
./version.sh

# 检查 version.txt 是否生成成功
if [[ ! -f version.txt ]]; then
    echo "Error: version.txt was not generated."
    exit 1
fi

# 复制 version.txt 到目标目录
cp version.txt templates/version.txt

# 创建压缩包
zip -r templates.zip templates

echo "Templates package created successfully: templates.zip"