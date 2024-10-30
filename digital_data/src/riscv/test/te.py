# ==================================================
# Copyright (c)
# All rights reserved
# Filename        : te.py
# Author          : x00897025
# Email           : 1834093202@qq.com
# Created on      : 2024-10-28 02:34:09
# Last Modified   : 2024-10-28 02:38:34
# Description     : 
# 
# 
# ==================================================

import re

# 设置输入文件和输出 tags 文件的路径
input_file = 'define.h'
output_file = 'def_tags'

# 定义正则表达式，匹配 `define` 语句
define_pattern = re.compile(r'^\s*`define\s+([a-zA-Z_][a-zA-Z0-9_]*)\s+')

# 打开输入文件并读取内容
with open(input_file, 'r') as infile, open(output_file, 'w') as outfile:
    for line_number, line in enumerate(infile, start=1):
        match = define_pattern.match(line)
        if match:
            macro_name = match.group(1)
            # 写入 tags 文件，格式为: macro_name<tab>filename<tab>line_number
            outfile.write(f"{macro_name}\t{input_file}\t{line_number}\n")

print(f"Tags file '{output_file}' generated successfully.")
