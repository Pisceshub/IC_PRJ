`timescale 1ns/10ps
module harness();

    reg clk;
    reg rst_n;

    //always #10 clk=~clk;

    initial begin
        //clk <= 1'b1;
        rst_n <= 1'b0;

        #50;
        rst_n <= 1'b1;

        #200;
        $finish();
    end
    clock_gen #(.CLK_PERIOD(20)) clock_gen_inst (.clk(clk));

    riscv_soc u_riscv_soc(
        .clk         (clk   ),
        .rst_n       (rst_n )
    );

    initial begin
        while(1) begin
            @(posedge clk)
            $display("x27 register value is %d",harness.u_riscv_soc.u_riscv_cpu.u_regs.regs[27]);
            $display("x28 register value is %d",harness.u_riscv_soc.u_riscv_cpu.u_regs.regs[28]);
            $display("x29 register value is %d",harness.u_riscv_soc.u_riscv_cpu.u_regs.regs[29]);
            $display("=============");
            $display("=============");
        end
    end

    initial begin
    	$fsdbDumpfile("./exce/harness.fsdb"); //指定生成的的fsdb
    	$fsdbDumpvars;
        $fsdbDumpMDA();
    end
    
endmodule
