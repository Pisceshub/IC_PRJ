`timescale 1ns/10ps
module harness();

    riscv_tb u_riscv_tb();
    initial begin
    	$fsdbDumpfile("./exce/harness.fsdb"); //指定生成的的fsdb
    	$fsdbDumpvars;
        $fsdbDumpMDA();
    end
    
endmodule
