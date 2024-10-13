module riscv_cpu(
    input   wire                    clk         ,
    input   wire                    rst_n       ,
    input   wire    [31:0]          inst_i      ,
    output  wire    [31:0]          inst_addr_o 
);
    //pc to if 
    wire    [31:0]  pc_reg_pc_addr_o;
    pc_reg u_pc_reg(
        .clk         (clk               ),
        .rst_n       (rst_n             ),
        .pc_addr_o   (pc_reg_pc_addr_o  ) 
    );
    //if to if_id 
    wire    [31:0]  ifetch_addr_o;
    wire    [31:0]  ifetch_inst_o;
    
    ifetch u_ifetch(
        .pc_addr_i          (pc_reg_pc_addr_o   ),
        .rom_inst_i         (inst_i             ),
        .if2rom_addr_o      (inst_addr_o        ),
        .inst_addr_o        (ifetch_addr_o      ),
        .inst_o             (ifetch_inst_o      ) 
    );
    //if_id to id
    wire    [31:0]  if_id_addr_o;
    wire    [31:0]  if_id_inst_o;

    if_id u_if_id(
        .clk         (clk           ),
        .rst_n       (rst_n         ),       
        .inst_i      (ifetch_inst_o ),
        .inst_addr_i (ifetch_addr_o ),
        .inst_addr_o (if_id_addr_o  ),
        .inst_o      (if_id_inst_o  )
    );

    //id to id_ex 
    wire    [31:0]  regs_rs1_data_o;
    wire    [31:0]  regs_rs2_data_o;
    wire    [ 4:0]  id_rs1_addr_o;
    wire    [ 4:0]  id_rs2_addr_o;
    wire    [31:0]  id_inst_o;
    wire    [31:0]  id_addr_o;
    wire    [31:0]  id_op1_o;
    wire    [31:0]  id_op2_o;
    wire    [ 4:0]  id_rd_addr_o;
    wire            id_reg_wen;



    id u_id(
        .inst_i     (if_id_inst_o   ),
        .inst_addr_i(if_id_addr_o   ),
                   
        .rs1_addr_o (id_rs1_addr_o  ),
        .rs2_addr_o (id_rs2_addr_o  ),
                    
        .rs1_data_i (regs_rs1_data_o),
        .rs2_data_i (regs_rs2_data_o),
                                   
        .inst_o     (id_inst_o      ),
        .inst_addr_o(id_addr_o      ),
        .op1_o      (id_op1_o       ),
        .op2_o      (id_op2_o       ),
        .rd_addr_o  (id_rd_addr_o   ),
        .reg_wen_o  (id_reg_wen_o   )      
    );
    //from ex
    wire    [ 4:0]          ex_wr_addr_o;         
    wire    [31:0]          ex_wr_data_o;       
    wire                    ex_wr_en_o;    


    regs u_regs(
        .clk                 (clk            ),
        .rst_n               (rst_n          ),
        .reg1_raddr_i        (id_rs1_addr_o  ),
        .reg2_raddr_i        (id_rs2_addr_o  ),
        .reg1_rdata_o        (regs_rs1_data_o),
        .reg2_rdata_o        (regs_rs2_data_o),
                                           
                                           
        .reg_waddr_i         (ex_wr_addr_o   ),
        .reg_wdata_i         (ex_wr_data_o   ),
        .reg_wen             (ex_wr_en_o     )
    ); 
    //id_ex to ex    
    wire    [31:0]      id_ex_inst_o;      
    wire    [31:0]      id_ex_addr_o;
    wire    [31:0]      id_ex_op1_o;       
    wire    [31:0]      id_ex_op2_o;       
    wire    [ 4:0]      id_ex_rd_addr_o;   
    wire                id_ex_reg_wen_o; 
    id_ex u_id_ex(
        .clk         (clk               ),
        .rst_n       (rst_n             ),
                     
        .inst_i      (id_inst_o         ),
        .inst_addr_i (id_addr_o         ),
        .op1_i       (id_op1_o          ),
        .op2_i       (id_op2_o          ),
        .rd_addr_i   (id_rd_addr_o      ),
        .reg_wen_i   (id_reg_wen_o      ),
                     
        .inst_o      (id_ex_inst_o      ),
        .inst_addr_o (id_ex_addr_o      ),
        .op1_o       (id_ex_op1_o       ),
        .op2_o       (id_ex_op2_o       ),
        .rd_addr_o   (id_ex_rd_addr_o   ),
        .reg_wen_o   (id_ex_reg_wen_o   )
    );
    //from id_ex to ex
    
    ex u_ex(
        .inst_i      (id_ex_inst_o      ),
        .inst_addr_i (id_ex_addr_o      ),
        .op1_i       (id_ex_op1_o       ),
        .op2_i       (id_ex_op2_o       ),
        .rd_addr_i   (id_ex_rd_addr_o   ),
        .reg_wen_i   (id_ex_reg_wen_o   ),  
                     
                                  
        .wr_addr_o   (ex_wr_addr_o      ),
        .wr_data_o   (ex_wr_data_o      ),
        .wr_en_o     (ex_wr_en_o        )       
);

endmodule 
