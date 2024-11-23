module regs(
    input   wire                    clk                 ,
    input   wire                    rst_n               ,
    input   wire    [ 4:0]          reg1_raddr_i        ,
    input   wire    [ 4:0]          reg2_raddr_i        ,
    output  reg     [31:0]          reg1_rdata_o        ,
    output  reg     [31:0]          reg2_rdata_o        ,

    //from ex 
    input   wire    [ 4:0]          reg_waddr_i         ,
    input   wire    [31:0]          reg_wdata_i         ,
    input   wire                    reg_wen     
    );

    /*autoreg*/
    //Start of automatic reg
    //Define flip-flop registers here
    //Define combination registers here
    //End of automatic reg
    reg [31:0]      regs[0:31];

    always@(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            reg1_rdata_o <= 'd0;
        end
        else if(reg1_raddr_i==5'b0)begin
            reg1_rdata_o <='d0;
        end
        else if(reg_wen && (reg1_raddr_i == reg_waddr_i))begin
            reg1_rdata_o <= reg_wdata_i;
        end
        else begin
            reg1_rdata_o <= regs[reg1_raddr_i];
        end
    end

    always@(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            reg2_rdata_o <= 'd0;
        end
        else if(reg2_raddr_i==5'b0)begin
            reg2_rdata_o <='d0;
        end
        else if (reg_wen && (reg2_raddr_i == reg_waddr_i))begin
            reg2_rdata_o <= reg_wdata_i;
        end
        else begin
            reg2_rdata_o <= regs[reg2_raddr_i];
        end
    end
    
    always@(posedge clk) begin
        if(reg_wen && reg_waddr_i != 'd0) begin
            regs[reg_waddr_i] <= reg_wdata_i;
        end
    end
endmodule














