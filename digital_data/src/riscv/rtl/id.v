module id (
    input   wire    [31:0]      inst_i      ,
    input   wire    [31:0]      inst_addr_i ,
    
    output  reg     [ 4:0]      rs1_addr_o  ,
    output  reg     [ 4:0]      rs2_addr_o  ,
    
    input   wire    [31:0]      rs1_data_i  ,
    input   wire    [31:0]      rs2_data_i  ,

    output  reg     [31:0]      inst_o      ,
    output  reg     [31:0]      inst_addr_o ,
    output  reg     [31:0]      op1_o       ,
    output  reg     [31:0]      op2_o       ,
    output  reg     [ 4:0]      rd_addr_o   ,
    output  reg                 reg_wen_o     
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
        inst_o      =   inst_i;
        inst_addr_o =   inst_addr_i;
        case(opcode) 
            `INST_TYPE_I: begin
                case(func3) 
                    `INST_ADDI: begin
                        rs1_addr_o  = rs1;
                        rs2_addr_o  = rs2_addr_o; //lowpower keep addr
                        op1_o       = rs1_data_i;
                        op2_o       = {{20{imm[11]}},imm};
                        rd_addr_o   = rd;
                        reg_wen_o   = 1'b1;
                    end
                    default:begin
                        rs1_addr_o  = 5'd0;
                        rs2_addr_o  = 5'd0; 
                        op1_o       = 32'd0;
                        op2_o       = 32'd0;
                        rd_addr_o   = 5'd0;
                        reg_wen_o   = 1'b0;
                    end
                endcase
            end
            `INST_TYPE_R_M:begin
                case(func3)
                    `INST_ADD_SUB:begin
                        rs1_addr_o  = rs1;
                        rs2_addr_o  = rs2;
                        op1_o       = rs1_data_i;
                        op2_o       = rs2_data_i;
                        rd_addr_o   = rd;
                        reg_wen_o   = 1'b1;
                    end
                    default:begin
                        rs1_addr_o  = 5'd0;
                        rs2_addr_o  = 5'd0; 
                        op1_o       = 32'd0;
                        op2_o       = 32'd0;
                        rd_addr_o   = 5'd0;
                        reg_wen_o   = 1'b0;
                    end
                endcase
            end
                    
            default:begin
                rs1_addr_o  = 5'd0;
                rs2_addr_o  = 5'd0; 
                op1_o       = 32'd0;
                op2_o       = 32'd0;
                rd_addr_o   = 5'd0;
                reg_wen_o   = 1'b0;
            end
        endcase
    end
endmodule
