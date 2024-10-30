`include "/home/ICer/ic_prjs/riscv/digital_data/src/riscv/include/define.h"
module ex(
    //from id_ex
    input  wire     [31:0]          inst_i      ,
    input  wire     [31:0]          inst_addr_i ,
    input  wire     [31:0]          op1_i       ,
    input  wire     [31:0]          op2_i       ,
    input  wire     [ 4:0]          rd_addr_i   ,
    input  wire                     reg_wen_i   ,  
    //to regs   

    output reg      [ 4:0]          wr_addr_o   ,
    output reg      [31:0]          wr_data_o   ,
    output reg                      wr_en_o    
); 
    wire    [ 6:0]   opcode;
    wire    [ 4:0]   rd;
    wire    [ 3:0]   func3;
    wire    [ 4:0]   rs1;
    wire    [ 4:0]   rs2;
    wire    [ 6:0]   func7;
    wire    [11:0]   imm;
 
    assign opcode   =   inst_i[ 6: 0];
    assign rd       =   inst_i[11: 7];
    assign func3    =   inst_i[14:12];
    assign rs1      =   inst_i[19:15];    
    assign rs2      =   inst_i[24:20];
    assign func7    =   inst_i[31:25];
    assign imm      =   inst_i[31:20];


    
    always@(*)begin

        case(opcode) 
            `INST_TYPE_I: begin
                case(func3) 
                    `INST_ADDI: begin
                        wr_data_o   = op1_i + op2_i;
                        wr_addr_o   = rd_addr_i; 
                        wr_en_o     = 1'b1;
                    end
                    default:begin
                        wr_data_o  = 32'd0;
                        wr_addr_o  = 5'd0; 
                        wr_en_o    = 1'b0;
                    end
                endcase
            end
            `INST_TYPE_R_M: begin
                case(func3)
                    `INST_ADD_SUB:begin
                        if(func7 == 7'd0) begin //add
                            wr_data_o   = op1_i + op2_i;
                            wr_addr_o   = rd_addr_i; 
                            wr_en_o     = 1'b1;
                        end
                        else begin
                            wr_data_o   = op2_i - op1_i;
                            wr_addr_o   = rd_addr_i; 
                            wr_en_o     = 1'b1;
                        end
                    end
                    default:begin
                        wr_data_o  = 32'd0;
                        wr_addr_o  = 5'd0; 
                        wr_en_o    = 1'b0;
                    end
                endcase
            end
            default:begin
                wr_data_o  = 32'd0;
                wr_addr_o  = 5'd0; 
                wr_en_o    = 1'b0;
            end
        endcase
    end

endmodule






