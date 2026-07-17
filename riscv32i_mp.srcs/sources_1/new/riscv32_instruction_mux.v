`timescale 1ns / 1ps


// NOTE 1 :
// The msrv32_instruction_mux module is called a "mux"
// because it functions like a multiplexer by selecting
// between two instructions based on the flush_in signal. 
// If flush_in is 0, it passes the actual instruction
// If flush_in is 0, it passes the actual instruction

// NOTE 2 :
// So what i am going to do is I'll first create 
// an internal input line of 32 bit and i'll select that line (instr_mux)based on flush_in
// then I'll assign each output lines from instr_mux
// rather than assigning the output lines directly from ms_riscv32_mp_instr_in 

module riscv32_instruction_mux(

    // Inputs :
    input flush_in,
    input [31:0] ms_riscv32_mp_instr_in,
    
    // Outputs :
    output [6:0] opcode_out,
    output [14:12] func3_out,
    output [31:25] func7_out,
    output [19:15] rs1_addr_out,
    output [24:20] rs2_addr_out,
    output [11:7] rd_addr_out,
    output [31:20] csr_addr_out,
    output [31:7] instr_out
    
    );
    
    // encoding :
    parameter NOP = 32'h00000013;
    
    // internal wire declaration :
    wire [31:0] instr_mux;
    
    // Assignment :
    assign instr_mux = flush_in? NOP : ms_riscv32_mp_instr_in;
    
    // Decoding :
    assign opcode_out = instr_mux [6:0];
    assign func3_out = instr_mux [14:12];
    assign func7_out = instr_mux [31:25];
    assign csr_addr_out = instr_mux [31:20];
    assign rs1_addr_out = instr_mux [19:15];
    assign rs2_addr_out = instr_mux [24:20];
    assign rd_addr_out = instr_mux [11:7];
    assign instr_out = instr_mux [31:7];
    
endmodule
