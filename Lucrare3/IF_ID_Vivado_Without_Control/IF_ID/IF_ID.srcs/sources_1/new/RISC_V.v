`timescale 1ns / 1ps

module RISC_V(input clk,
              input reset,
              
              output [31:0] PC_EX,
              output [31:0] ALU_OUT_EX,
              output [31:0] PC_MEM,
              output PCSrc,
              output [31:0] DATA_MEMORY_MEM,
              output [31:0] ALU_DATA_WB,
              output [1:0] forwardA, forwardB,
              output pipeline_stall);

  /////////////////////////////////////////IF signals////////////////////////////////////////////////////////
  wire [31:0] PC_IF;               //current PC
  wire [31:0] INSTRUCTION_IF;
  wire PCSrc_aux;
  
  //////////////////////////////////////////ID signals////////////////////////////////////////////////////////
  wire [31:0] PC_ID;
  wire [31:0] INSTRUCTION_ID;
  wire [31:0] IMM_ID;
  wire [31:0] REG_DATA1_ID,REG_DATA2_ID;
  wire RegWrite_ID,MemtoReg_ID,MemRead_ID,MemWrite_ID;
  wire [1:0] ALUop_ID;
  wire ALUSrc_ID;
  wire Branch_ID; 
  wire pipeline_stall_aux;
  
  wire [2:0] FUNCT3_ID;
  wire [6:0] FUNCT7_ID;
  wire [6:0] OPCODE_ID;
  wire [4:0] RD_ID;
  wire [4:0] RS1_ID;
  wire [4:0] RS2_ID;
  
  wire IF_ID_write;
  wire [31:0] PC_write;
  
  //////////////////////////////////////////EX signals////////////////////////////////////////////////////////
  wire [31:0] PC_EX_aux;
  wire [31:0] PC_Branch;
  wire [31:0] PC_Branch_EX;
  wire [31:0] IMM_EX;
  wire [31:0] REG_DATA1_EX,REG_DATA2_EX;
  wire RegWrite_EX,MemtoReg_EX,MemRead_EX,MemWrite_EX;
  wire Branch_EX;
  wire [1:0] ALUop_EX;
  wire ALUSrc_EX;
  wire [2:0] FUNCT3_EX;
  wire [6:0] FUNCT7_EX;
  wire [4:0] RD_EX;
  wire [4:0] RS1_EX;
  wire [4:0] RS2_EX;
  
  wire [31:0] ALU_OUT_EX_aux;
  wire ZERO_EX;
  wire [1:0] forwardA_aux,forwardB_aux;
  wire [31:0] MUX_B_EX;
  
  //////////////////////////////////////////MEM signals////////////////////////////////////////////////////////
  wire RegWrite_MEM,MemtoReg_MEM,MemRead_MEM,MemWrite_MEM;
  wire Branch_MEM;
  wire [31:0] REG_DATA2_MEM;
  wire [4:0] RD_MEM;
  wire [31:0] ALU_OUT_MEM;
  wire ZERO_MEM;
  wire [2:0] FUNCT3_MEM;
  wire [31:0] RS2_MEM;
  
  wire [31:0] DATA_MEMORY_MEM_aux;
  
  //////////////////////////////////////////WB signals////////////////////////////////////////////////////////
  wire RegWrite_WB,MemtoReg_WB;
  wire [31:0] DATA_MEMORY_WB;
  wire [31:0] ALU_OUT_WB;
  wire [31:0] ALU_DATA_WB_aux;
  wire [4:0] RD_WB;
  
  //////////////////////////////////////pipeline registers////////////////////////////////////////////////////
  IF_ID_reg IF_ID_REGISTER(clk,reset,
                           IF_ID_write,
                           PC_IF,INSTRUCTION_IF,
                           PC_ID,INSTRUCTION_ID);
                           
  ID_EX_reg ID_EX_REGISTER(clk,reset,1'b1,
                           RegWrite_ID,MemtoReg_ID,MemRead_ID,MemWrite_ID,ALUSrc_ID,Branch_ID,ALUop_ID,
                           PC_ID,REG_DATA1_ID,REG_DATA2_ID,IMM_ID,
                           FUNCT7_ID,FUNCT3_ID,
                           RS1_ID,RS2_ID,RD_ID,
                                 
                           RegWrite_EX,MemtoReg_EX,MemRead_EX,MemWrite_EX,ALUSrc_EX,Branch_EX,ALUop_EX,
                           PC_EX_aux,REG_DATA1_EX,REG_DATA2_EX,IMM_EX,
                           FUNCT7_EX,FUNCT3_EX,
                           RS1_EX,RS2_EX,RD_EX);
                           
  EX_MEM_reg EX_MEM_REGISTER(clk,reset,1'b1,
                             RegWrite_EX,MemtoReg_EX,MemRead_EX,MemWrite_EX,Branch_EX,
                             PC_Branch_EX, FUNCT3_EX,
                             ALU_OUT_EX_aux,ZERO_EX,
                             MUX_B_EX,
                             RS2_EX, RD_EX,
                                  
                             RegWrite_MEM,MemtoReg_MEM,MemRead_MEM,MemWrite_MEM,Branch_MEM,
                             PC_Branch, FUNCT3_MEM,
                             ALU_OUT_MEM,ZERO_MEM,
                             REG_DATA2_MEM,
                             RS2_MEM, RD_MEM);
  
  MEM_WB_reg MEM_WB_REGISTER(clk,reset,1'b1,
                             RegWrite_MEM,MemtoReg_MEM,
                             DATA_MEMORY_MEM_aux,
                             ALU_OUT_MEM,
                             RD_MEM,
                                  
                             RegWrite_WB,MemtoReg_WB,
                             DATA_MEMORY_WB,
                             ALU_OUT_WB,
                             RD_WB);
                             
  ///////////////////////////////////////////IF data path/////////////////////////////////////////////////////////
  
  IF instruction_fetch(clk, reset, 
                      PCSrc_aux, PC_write,
                      PC_Branch,
                      PC_IF,INSTRUCTION_IF);
  
  ///////////////////////////////////////////ID data path/////////////////////////////////////////////////////////
  
  ID instruction_decode(clk,
                       PC_ID,INSTRUCTION_ID,
                       RegWrite_WB, 
                       ALU_DATA_WB_aux,
                       RD_WB,
                       IMM_ID,
                       REG_DATA1_ID,REG_DATA2_ID,
                       FUNCT3_ID,
                       FUNCT7_ID,
                       OPCODE_ID,
                       RD_ID,
                       RS1_ID,
                       RS2_ID);
                       
  control_path CONTROL_PATH_MODULE(OPCODE_ID, 
                                   pipeline_stall_aux,
                                   MemRead_ID,MemtoReg_ID,MemWrite_ID,
                                   RegWrite_ID,Branch_ID,ALUSrc_ID,
                                   ALUop_ID);
  
  hazard_detection HAZARD_DETECTION_UNIT(RD_EX,  //ID_EX.rd
                                         RS1_ID, //IF_ID.rs1
                                         RS2_ID, //IF_ID.rs2
                                         MemRead_EX,   //ID_EX.MemRead
                                         PC_write,
                                         IF_ID_write,
                                         pipeline_stall_aux);
                                         
  //////////////////////////////////////////EX data path/////////////////////////////////////////////////////////                                       
  
  EX execute(IMM_EX,
            REG_DATA1_EX,
            REG_DATA2_EX,
            PC_EX_aux,
            FUNCT3_EX,
            FUNCT7_EX,
            RD_EX,
            RS1_EX,
            RS2_EX,
            RegWrite_EX,
            MemtoReg_EX,
            MemRead_EX,
            MemWrite_EX,
            ALUop_EX,
            ALUSrc_EX,
            Branch_EX,
            forwardA_aux, forwardB_aux,
            ALU_DATA_WB_aux,
            ALU_OUT_MEM,
            ZERO_EX,
            ALU_OUT_EX_aux,
            PC_Branch_EX,
            MUX_B_EX);
                  
  forwarding FORWARDING_UNIT(RS1_EX, //rs1
                            RS2_EX,  //rs2
                            RD_MEM,     //ex_mem_rd
                            RD_WB,     //mem_wb_rd
                            RegWrite_MEM,     //ex_mem_regwrite
                            RegWrite_WB,     //mem_wb_regwrite
                            forwardA_aux,forwardB_aux);               
                      
  ///////////////////////////////////////////MEM data path/////////////////////////////////////////////////////////
  data_memory DATA_MEMORY_MODULE(clk,
                                 MemRead_MEM,      //MemRead
                                 MemWrite_MEM,     //MemWrite
                                 ALU_OUT_MEM,      //ALU_OUT(address)
                                 REG_DATA2_MEM,     //rs2(data)
                                 DATA_MEMORY_MEM_aux);
  
  and (PCSrc_aux, Branch_MEM, ZERO_MEM);
                                                  
  ///////////////////////////////////////////MEM data path/////////////////////////////////////////////////////////
  
  mux2_1 MUX_ALU_DATA(ALU_OUT_WB,   //ALU_out result
                      DATA_MEMORY_WB, //Data_memory_out 
                      MemtoReg_WB,    //MemtoReg
                      ALU_DATA_WB_aux);   

  assign PC_EX = PC_EX_aux;
  assign ALU_OUT_EX = ALU_OUT_EX_aux;
  assign PC_MEM = PC_Branch;
  assign PCSrc = PCSrc_aux;
  assign DATA_MEMORY_MEM = DATA_MEMORY_MEM_aux;
  assign ALU_DATA_WB = ALU_DATA_WB_aux;
  assign forwardA = forwardA_aux;
  assign forwardB = forwardB_aux;
  assign pipeline_stall = pipeline_stall_aux;
  
endmodule
