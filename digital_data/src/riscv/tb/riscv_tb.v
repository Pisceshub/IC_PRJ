module riscv_tb();
    reg clk;
    reg rst_n;

    riscv_soc u_riscv_soc(
        .clk         (clk   ),
        .rst_n       (rst_n )
    );


    always #10 clk=~clk;

    initial begin
        clk <= 1'b1;
        rst_n <= 1'b0;

        #50;
        rst_n <= 1'b1;

        #200;
        $finish();
    end

    initial begin
        $readmemb("/home/ICer/ic_prjs/riscv/digital_data/src/riscv/hex/add_test.hex",harness.u_riscv_tb.u_riscv_soc.u_rom.rom_mem);
    end

    initial begin
        while(1) begin
            @(posedge clk)
            $display("x27 register value is %d",harness.u_riscv_tb.u_riscv_soc.u_riscv_cpu.u_regs.regs[27]);
            $display("x28 register value is %d",harness.u_riscv_tb.u_riscv_soc.u_riscv_cpu.u_regs.regs[28]);
            $display("x29 register value is %d",harness.u_riscv_tb.u_riscv_soc.u_riscv_cpu.u_regs.regs[29]);
            $display("=============");
            $display("=============");
        end
    end

endmodule
