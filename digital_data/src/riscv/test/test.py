// ==================================================
// Copyright (c)
// All rights reserved
// Filename        : test.py
// Author          : x00897025
// Email           : 1834093202@qq.com
// Created on      : 2024-10-28 02:30:23
// Last Modified   : 2024-10-28 02:31:05
// Description     : 
// 
// 
// ==================================================

import re

text = """`define INST_MULH   3'b001
`define INST_DIV    3'b100"""

pattern = r'^\s*`define\s+([a-zA-Z_][a-zA-Z0-9_]*)\s+'
matches = re.findall(pattern, text, re.MULTILINE)

print(matches)  # 应该输出 ['INST_MULH', 'INST_DIV']
