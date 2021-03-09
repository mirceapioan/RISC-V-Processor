`timescale 1ns / 1ps

module data_memory(clk, mem_read, mem_write,
                  address, write_data,
                  read_data);

    input clk;
    input mem_read;
    input mem_write;
    input [31:0] address;
    input [31:0] write_data;
    output reg [31:0] read_data;

    reg [31:0] data [0:1023];

    integer i;
    initial begin
        for (i = 0; i < 1024; i = i + 1) begin
            data[i] = 32'b0;
        end
    end
    
    always@(posedge clk) begin
        if (mem_write)
            data[address[11:2]] <= write_data;
    end
    
    always@(mem_read, address) begin
        if (mem_read)
            read_data = data[address[11:2]];
    end
    
endmodule
