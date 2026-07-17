`timescale 1ns / 1ps

module dummy_int_file(
    // Inputs :
    input ms_riscv32_mp_clk_in, 
    input ms_riscv32_mp_rst_in, 
    input wr_en_in,
    input [24:20] rs2_addr_in, 
    input [19:15] rs1_addr_in, 
    input [11:7] rd_addr_in,
    input [31:0] rd_in,
    // Outputs :
    output [31:0] rs1_out, 
    output [31:0] rs2_out,
    output [31:0] rd_out
    );
    
    // declaration of register file :
    reg [31:0] reg_file [0:31];
    
    initial begin
        reg_file[0] = 32'b0;
        reg_file[1] = 32'd31;
        reg_file[2] = 32'd20;
        reg_file[28] = 32'b0;
    end
    
    // Asynchronous logic for read operations :
    assign rs1_out = reg_file[rs1_addr_in];
    assign rs2_out = reg_file[rs2_addr_in];
    assign rd_out = reg_file[28];
endmodule
