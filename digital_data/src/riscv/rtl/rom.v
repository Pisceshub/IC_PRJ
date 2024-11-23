module rom(
    input   wire    [31:0]      inst_addr_i,
    output  reg     [31:0]      inst_o
);
    reg     [31:0]              rom_mem[0:4095];

    always@(*) begin
        inst_o = rom_mem[inst_addr_i>>2];
    end
    initial begin
        $readmemb("/home/ICer/ic_prjs/riscv/digital_data/src/riscv/hex/add_test.hex",rom_mem);
    end

endmodule
