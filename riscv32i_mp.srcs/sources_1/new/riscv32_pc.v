`timescale 1ns / 1ps

module riscv32_pc(

    // Inputs :
    input ms_riscv32_mp_rst_in, 
    input ahb_ready_in, 
    input branch_taken_in,
    input [1:0] pc_src_in,
    input [31:0] epc_in, 
    input [31:0] trap_address_in, 
    input [31:0] pc_in,
    input [31:1] iadder_in,
    
    // Outputs :
    output misaligned_instr_logic_out,
    output [31:0] pc_plus_4_out, 
    output [31:0] iadder_out,
    output reg [31:0]  pc_mux_out
    );
    
    // Encoding :
    parameter BOOT_ADDRESS = 32'h00000200;
    
    // internal wires :
    wire lsb_low;
    wire [31:0] next_pc;
    wire [31:0] iadder_in_concated;
    
    // Assignment :
    assign lsb_low = 1'b0;
    assign iadder_in_concated = {iadder_in, lsb_low};    
    assign pc_plus_4_out = pc_in + 32'd4;   
    assign next_pc = branch_taken_in ? iadder_in_concated : pc_plus_4_out;
    
    // PC mux logic :
    always@(*) begin
        case(pc_src_in)
            2'b00 : pc_mux_out = BOOT_ADDRESS;
            2'b01 : pc_mux_out = epc_in;
            2'b10 : pc_mux_out = trap_address_in;
            2'b11 : pc_mux_out = next_pc;
            //default : pc_mux_out = BOOT_ADDRESS;
        endcase
    end
     
    assign misaligned_instr_logic_out = branch_taken_in & next_pc[1];
    
    assign iadder_out = ms_riscv32_mp_rst_in       ? BOOT_ADDRESS :
                        ahb_ready_in ? pc_mux_out   :
                                       pc_in;

endmodule
