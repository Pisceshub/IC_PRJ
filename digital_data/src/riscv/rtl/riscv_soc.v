module riscv_soc(
   input    wire                clk         ,
   input    wire                rst_n       
);
    wire    [31:0]  cpu_inst_addr_o;
    wire    [31:0]  rom_inst_o;

    riscv_cpu u_riscv_cpu(
        .clk         (clk               ),
        .rst_n       (rst_n             ),
        .inst_i      (rom_inst_o        ),
        .inst_addr_o (cpu_inst_addr_o   )
    );
    rom u_rom(
        .inst_addr_i(cpu_inst_addr_o    ),
        .inst_o     (rom_inst_o         )    
    );   
endmodule    
