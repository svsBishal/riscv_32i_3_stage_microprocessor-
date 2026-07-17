`timescale 1ns / 1ps

module riscv32_reg_block_1(
    // Inputs :
    input [31:0] pc_mux_in,
    input ms_riscv32_mp_clk_in, 
    input ms_riscv32_mp_rst_in,
    // Outputs :
    output [31:0] pc_out
    );
    // Encoding :
    parameter BOOT_ADDRESS = 32'h00000200;
    // declaration :
    reg [31:0] out;
    
    // Assignments :
    assign pc_out = out;
    
    // main logic :
    always@(posedge ms_riscv32_mp_clk_in or posedge ms_riscv32_mp_rst_in) begin
        if(ms_riscv32_mp_rst_in) out <= BOOT_ADDRESS;
        else out <= pc_mux_in;
    end
endmodule
