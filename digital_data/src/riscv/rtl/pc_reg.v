module pc_reg(
    input   wire            clk         ,
    input   wire            rst_n       ,
    output  reg  [31:0]     pc_addr_o    
    );
    always@(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            pc_addr_o <= 'd0;
        end
        else begin
            pc_addr_o <= pc_addr_o +'d4;
        end
    end

endmodule

