`timescale 1ns / 1ps

module EX_MEM_reg(clk, reset, write,
    RegWrite_in, MemtoReg_in, MemRead_in, MemWrite_in, Branch_in,
    PC_in, FUNCT3_in,
    ALU_OUTPUT_in, ZERO_in,
    MUX_B_in,
    RS2_in, RD_in,
                                  
    RegWrite_out, MemtoReg_out, MemRead_out, MemWrite_out, Branch_out,
    PC_out, FUNCT3_out,
    ALU_OUTPUT_out ,ZERO_out,
    REG_DATA2_out,
    RS2_out, RD_out);
    
    input clk, reset, write;
    input RegWrite_in, MemtoReg_in, MemRead_in, MemWrite_in, Branch_in, ZERO_in;
    input [31:0] PC_in, ALU_OUTPUT_in, MUX_B_in, RS2_in;
    input [4:0] RD_in;
    input [2:0] FUNCT3_in;
    
    output reg RegWrite_out, MemtoReg_out, MemRead_out, MemWrite_out, Branch_out, ZERO_out;
    output reg [31:0] PC_out, ALU_OUTPUT_out, REG_DATA2_out, RS2_out;
    output reg [4:0] RD_out;
    output reg [2:0] FUNCT3_out;
    
    always@(posedge clk) begin
        if (reset) begin
                RegWrite_out <= 1'b0;
                MemtoReg_out <= 1'b0;
                MemRead_out <= 1'b0;
                MemWrite_out <= 1'b0;
                Branch_out <= 1'b0;
                PC_out <= 32'b0;
                FUNCT3_out <= 3'b0;
                ALU_OUTPUT_out <= 32'b0;
                ZERO_out <= 1'b0;
                REG_DATA2_out <= 32'b0;
                RS2_out <= 32'b0;
                RD_out <= 5'b0;
        end
        else begin
            if(write) begin
                RegWrite_out <= RegWrite_in;
                MemtoReg_out <= MemtoReg_in;
                MemRead_out <= MemRead_in;
                MemWrite_out <= MemWrite_in;
                Branch_out <= Branch_in;
                PC_out <= PC_in;
                FUNCT3_out <= FUNCT3_in;
                ALU_OUTPUT_out <= ALU_OUTPUT_in;
                ZERO_out <= ZERO_in;
                REG_DATA2_out <= MUX_B_in;
                RS2_out <= RS2_in;
                RD_out <= RD_in;
            end
    end
  end
endmodule
