@echo off
setlocal enabledelayedexpansion

:: 设置UTF-8编码
chcp 65001

:: 创建输出目录
:: if not exist output mkdir output

:: 转换 LaTeX 到 HTML
pandoc resume.tex ^
  -f latex ^
  -t html5 ^
  --standalone ^
  --mathjax ^
  --template=template.html ^
  --css=resume.css ^
  --lua-filter=filter.lua ^
  -V lang=zh-CN ^
  -V document-css=false ^
  -V pagetitle="个人简历" ^
  -o index.html

:: 复制 CSS 文件到输出目录
::  copy resume.css output\

echo 转换完成！输出文件在 根目录中。

pause
