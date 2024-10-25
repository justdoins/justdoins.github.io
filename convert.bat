@echo off
setlocal enabledelayedexpansion

:: 设置代码页为 UTF-8
chcp 65001
:: 设置终端字体为支持 UTF-8 的字体
reg add "HKEY_CURRENT_USER\Console" /v "FaceName" /t REG_SZ /d "Consolas" /f
:: 设置终端输出编码为 UTF-8
set PYTHONIOENCODING=utf-8

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

echo 转换完成！输出文件在 根目录中。

pause
