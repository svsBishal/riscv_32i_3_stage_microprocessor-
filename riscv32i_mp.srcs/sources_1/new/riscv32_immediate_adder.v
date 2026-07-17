`timescale 1ns / 1ps

module riscv32_immediate_adder(
    // Inputs :
    input [31:0] pc_in, 
    input [31:0] rs1_in, 
    input [31:0] imm_in,
    input iadder_src_in,
    // Output :
    output [31:0] iadder_out
    );
    
    // Internal variable declaration :
    wire [31:0] iadder_src_mux_out;
    
    // Assignment :
    assign iadder_src_mux_out = iadder_src_in ? rs1_in : pc_in;
    
    // Immediate addition :
    assign iadder_out = $signed(imm_in) + $signed(iadder_src_mux_out);
    
endmodule
