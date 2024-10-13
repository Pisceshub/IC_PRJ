//`include "/home/ICer/ic_prjs/riscv/digital_data/src/riscv/rtl/gen_dff.v"
module id_ex(
    input   wire                    clk         ,
    input   wire                    rst_n       ,
    //from id
    input   wire    [31:0]          inst_i      ,
    input   wire    [31:0]          inst_addr_i ,
    input   wire    [31:0]          op1_i       ,
    input   wire    [31:0]          op2_i       ,
    input   wire    [ 4:0]          rd_addr_i   ,
    input   wire                    reg_wen_i   ,
    //to ex 
    output  wire    [31:0]          inst_o      ,
    output  wire    [31:0]          inst_addr_o ,
    output  wire    [31:0]          op1_o       ,
    output  wire    [31:0]          op2_o       ,
    output  wire    [ 4:0]          rd_addr_o   ,
    output  wire                    reg_wen_o   
    );

    gen_rst_def_dff #(32) u_dff0(clk,rst_n,`INST_NOP,   inst_i,         inst_o);
    gen_rst_def_dff #(32) u_dff1(clk,rst_n,32'b0,       inst_addr_i,    inst_addr_o);
    gen_rst_def_dff #(32) u_dff2(clk,rst_n,32'b0,       op1_i,          op1_o);
    gen_rst_def_dff #(32) u_dff3(clk,rst_n,32'b0,       op2_i,          op2_o);
    gen_rst_def_dff #(5)  u_dff4(clk,rst_n,5'b0,        rd_addr_i,      rd_addr_o);
    gen_rst_def_dff #(1)  u_dff5(clk,rst_n,1'b0,        reg_wen_i,      reg_wen_o);

endmodule


























