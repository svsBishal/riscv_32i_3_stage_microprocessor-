`timescale 1ns / 1ps

module riscv32_decoder_tb;

  // Inputs
  reg trap_taken_in;
  reg func7_5_in;
  reg [6:0] opcode_in;
  reg [14:12] func3_in;
  reg [1:0] i_adder_out_1_to_0_in;

  // Outputs
  wire [2:0] wb_mux_sel_out, imm_type_out, csr_op_out;
  wire [3:0] alu_opcode_out;
  wire [1:0] load_size_out;
  wire mem_wr_req_out, load_unsigned_out, alu_src_out, i_adder_src_out;
  wire csr_wr_en_out, rf_wr_en_out, illegal_instr_out;
  wire misaligned_load_out, misaligned_store_out;

  // Instantiate the Unit Under Test (UUT)
  riscv32_decoder uut (
    .trap_taken_in(trap_taken_in),
    .func7_5_in(func7_5_in),
    .opcode_in(opcode_in),
    .func3_in(func3_in),
    .i_adder_out_1_to_0_in(i_adder_out_1_to_0_in),
    .wb_mux_sel_out(wb_mux_sel_out),
    .imm_type_out(imm_type_out),
    .csr_op_out(csr_op_out),
    .alu_opcode_out(alu_opcode_out),
    .load_size_out(load_size_out),
    .mem_wr_req_out(mem_wr_req_out),
    .load_unsigned_out(load_unsigned_out),
    .alu_src_out(alu_src_out),
    .i_adder_src_out(i_adder_src_out),
    .csr_wr_en_out(csr_wr_en_out),
    .rf_wr_en_out(rf_wr_en_out),
    .illegal_instr_out(illegal_instr_out),
    .misaligned_load_out(misaligned_load_out),
    .misaligned_store_out(misaligned_store_out)
  );

  initial begin
    // Monitor output
    $monitor("opcode_in[6:2]=%b => is_branch=%b, is_jal=%b, is_op=%b, is_load=%b, is_store=%b, is_system=%b", 
              opcode_in[6:2],
              uut.is_branch, uut.is_jal, uut.is_op, uut.is_load, uut.is_store, uut.is_system);

    // Initialize irrelevant inputs
    trap_taken_in = 0;
    //func7_5_in = 0;
    //func3_in = 3'b000;
    i_adder_out_1_to_0_in = 2'b00;

    // Test different opcodes
    
    // 0000000_00010_00001_000_11100_0110011

    opcode_in = 7'h33; // is_branch
    func3_in = 3'h0;
    func7_5_in = 1'b0;
    
    

    #10 $finish;
  end

endmodule
