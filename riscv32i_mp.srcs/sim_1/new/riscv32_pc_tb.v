`timescale 1ns / 1ps

module riscv32_pc_tb();

  reg rst_in;
  reg ahb_ready_in;
  reg branch_taken_in;
  reg [1:0] pc_src_in;
  reg [31:0] epc_in;
  reg [31:0] trap_address_in;
  reg [31:0] pc_in;
  reg [31:1] iadder_in;

  wire [31:0] pc_plus_4_out;
  wire [31:0] iadder_out;
  wire [31:0] pc_mux_out;
  wire misaligned_instr_logic_out;

  riscv32_pc uut (
    .rst_in(rst_in),
    .ahb_ready_in(ahb_ready_in),
    .branch_taken_in(branch_taken_in),
    .pc_src_in(pc_src_in),
    .epc_in(epc_in),
    .trap_address_in(trap_address_in),
    .pc_in(pc_in),
    .iadder_in(iadder_in),
    .pc_plus_4_out(pc_plus_4_out),
    .iadder_out(iadder_out),
    .pc_mux_out(pc_mux_out),
    .misaligned_instr_logic_out(misaligned_instr_logic_out)
  );

  initial begin
    $display("Starting testbench...");
    $monitor("Time=%0t | rst=%b, ready=%b, pc_src=%b | pc_mux=%h, iadder_out=%h, misaligned=%b",
              $time, rst_in, ahb_ready_in, pc_src_in, pc_mux_out, iadder_out, misaligned_instr_logic_out);

    rst_in = 1;
    ahb_ready_in = 0;
    branch_taken_in = 0;
    pc_src_in = 2'b00;
    epc_in = 32'h1000_0040;
    trap_address_in = 32'hDEAD_BEEF;
    pc_in = 32'h0000_0000;
    iadder_in = 31'h0000_0010;

    #10;
    rst_in = 0;          // Deassert reset
    ahb_ready_in = 1;
    pc_src_in = 2'b11;   // Select next_pc (branch or pc+4)
    branch_taken_in = 1; // Branch taken

    #10;
    iadder_in = 31'h0000_0011; // Misaligned address to test misaligned_instr_logic_out

    #10;
    branch_taken_in = 0; // No branch
    pc_in = 32'h0000_0040;

    #10;
    pc_src_in = 2'b01;   // Select epc
    #10;
    pc_src_in = 2'b10;   // Select trap address

    #10;
    ahb_ready_in = 0;    // Simulate bus not ready

    #10;
    $finish;
  end

endmodule
