// ==================================================
// Copyright (c)
// All rights reserved
// Filename        : lp_define.sv
// Author          : x00897025
// Email           : 1834093202@qq.com
// Created on      : 2024-11-23 04:39:23
// Last Modified   : 2024-11-23 04:50:37
// Description     : 
// 
// 
// ==================================================
module clock_gen #(parameter CLK_PERIOD = 10) (output reg clk);
  // 时钟周期，单位为时间单位
  initial begin
    clk = 0;
  end
  
  // 每次反转时钟信号时，延迟半个时钟周期（即 CLK_PERIOD/2）
  always begin
    # (CLK_PERIOD / 2) clk = ~clk;
  end
endmodule


