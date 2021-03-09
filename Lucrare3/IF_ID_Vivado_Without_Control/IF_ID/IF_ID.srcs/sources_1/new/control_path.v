`timescale 1ns / 1ps

module control_path(opcode, control_sel, MemRead, MemtoReg, MemWrite, RegWrite, Branch, ALUSrc, ALUop);

    input [6:0] opcode;
    input control_sel;
    output reg MemRead, MemtoReg, MemWrite, RegWrite, Branch, ALUSrc;
    output reg[1:0] ALUop;
    //valori stanga tabel carte pag 104
    //valori dreapta fig 2 + R-imediat  alusrc 1
    always@(opcode, control_sel) begin
        casex({control_sel, opcode})
            8'b00110011: {ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUop} <= 8'b00100010;
            //R-format (add, sub, sll, slt, sltu, xor, srl, sra, or, and)
            8'b00000011: {ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUop} <= 8'b11110000;//ld, lw
            8'b00100011: {ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUop} <= 8'b10001000;//sd, sw
            8'b01100011: {ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUop} <= 8'b00000101;//beq
            8'b00010011: {ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUop} <= 8'b10100010;//R-imediat
            default: {ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUop} <= 8'b00000000;
        endcase
    end
    
endmodule
