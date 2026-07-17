`timescale 1ns / 1ps

module tb_riscv32_integer_file();

  reg clk;
  reg rst;
  reg wr_en;
  reg [4:0] rs1_addr;
  reg [4:0] rs2_addr;
  reg [4:0] rd_addr;
  reg [31:0] rd_in;

  wire [31:0] rs1_out;
  wire [31:0] rs2_out;

  riscv32_integer_file uut (
    .ms_riscv32_mp_clk_in(clk),
    .ms_riscv32_mp_rst_in(rst),
    .wr_en_in(wr_en),
    .rs1_addr_in(rs1_addr),
    .rs2_addr_in(rs2_addr),
    .rd_addr_in(rd_addr),
    .rd_in(rd_in),
    .rs1_out(rs1_out),
    .rs2_out(rs2_out)
  );

  initial begin
    clk = 0;
    forever #5 clk = ~clk; 
  end

  initial begin
    $display("Starting test...");
    $monitor("Time=%0t | wr_en=%b rd_addr=%0d rd_in=%h | rs1_addr=%0d rs2_addr=%0d => rs1_out=%h rs2_out=%h", 
             $time, wr_en, rd_addr, rd_in, rs1_addr, rs2_addr, rs1_out, rs2_out);

    // Initial values
    rst = 1; wr_en = 0;
    rd_addr = 0; rs1_addr = 0; rs2_addr = 0; rd_in = 0;

    // Apply reset
    #3 rst = 0;    // Assert reset
    #10 rst = 1;   // Deassert reset

    // Write 0xAAAA_BBBB into register 5
    rd_addr = 5;
    rd_in = 32'hAAAA_BBBB;
    wr_en = 1;
    #10;

    // Read from register 5 (after write completes)
    wr_en = 0;
    rs1_addr = 5;
    rs2_addr = 0;  // reading x0
    #10;

    // Forwarding test: write and read rs1 from same register in same cycle
    rd_addr = 6;
    rd_in = 32'h1234_5678;
    wr_en = 1;
    rs1_addr = 6;  // same as rd_addr -> should bypass
    rs2_addr = 0;
    #10;

    // Check that writing to x0 has no effect
    rd_addr = 0;
    rd_in = 32'hDEAD_BEEF;
    wr_en = 1;
    rs1_addr = 0;
    #10;

    // Disable write and verify x0 is still 0
    wr_en = 0;
    #10;

    $finish;
  end

endmodule
