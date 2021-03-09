`timescale 1ns / 1ps

module MEM_WB_reg(clk, reset, write,
    RegWrite_in, MemtoReg_in,
    DATA_MEMORY_in,
    ALU_OUTPUT_in,
    RD_in,
                                  
    RegWrite_out, MemtoReg_out,
    DATA_MEMORY_out,
    ALU_OUTPUT_out,
    RD_out);
    
    input clk, reset, write;
    input RegWrite_in, MemtoReg_in;
    input [31:0] DATA_MEMORY_in, ALU_OUTPUT_in;
    input [4:0] RD_in;
    
    output reg RegWrite_out, MemtoReg_out;
    output reg [31:0] DATA_MEMORY_out, ALU_OUTPUT_out;
    output reg [4:0] RD_out;
    
    always@(posedge clk) begin
        if (reset) begin
            RegWrite_out <= 1'b0;
            MemtoReg_out <= 1'b0;
            DATA_MEMORY_out <= 32'b0;
            ALU_OUTPUT_out <= 32'b0;
            RD_out <= 5'b0;
        end
        else begin
            if(write) begin
                RegWrite_out <= RegWrite_in;
                MemtoReg_out <= MemtoReg_in;
                DATA_MEMORY_out <= DATA_MEMORY_in;
                ALU_OUTPUT_out <= ALU_OUTPUT_in;
                RD_out <= RD_in;
            end
        end
  end
endmodule
