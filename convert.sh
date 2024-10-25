#!/bin/bash

# 设置 UTF-8 编码
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# 转换 LaTeX 到 HTML
pandoc resume.tex \
  -f latex \
  -t html5 \
  --standalone \
  --mathjax \
  --template=template.html \
  --css=resume.css \
  --lua-filter=filter.lua \
  -V lang=zh-CN \
  -V document-css=false \
  -V pagetitle="个人简历" \
  -o index.html

echo "转换完成！输出文件在 根目录中。"

# 给脚本添加执行权限
chmod +x convert.sh
