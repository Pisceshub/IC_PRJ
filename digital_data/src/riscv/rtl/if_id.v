// `include "/home/ICer/ic_prjs/riscv/digital_data/src/riscv/rtl/gen_dff.v"

module if_id(
    input   wire            clk         ,
    input   wire            rst_n       ,       
    input   wire    [31:0]  inst_i      ,
    input   wire    [31:0]  inst_addr_i ,
    output  wire    [31:0]  inst_addr_o ,
    output  wire    [31:0]  inst_o  
);
    gen_rst_def_dff #(32) u_dff0(clk,rst_n,`INST_NOP,inst_i,inst_o);
    gen_rst_def_dff #(32) u_dff1(clk,rst_n,'d0,inst_addr_i,inst_addr_o);

endmodule    
