`timescale 1ns / 1ps

module riscv32_immediate_adder_tb;

    // Inputs
    reg [31:0] pc_in;
    reg [31:0] rs1_in;
    reg [31:0] imm_in;
    reg iadder_src_in;

    // Output
    wire [31:0] iadder_out;

    // Instantiate the Unit Under Test (UUT)
    riscv32_immediate_adder uut (
        .pc_in(pc_in),
        .rs1_in(rs1_in),
        .imm_in(imm_in),
        .iadder_src_in(iadder_src_in),
        .iadder_out(iadder_out)
    );

    initial begin
        // Monitor output
        $monitor("Time = %0t | pc = %h | rs1 = %h | imm = %h | src = %b | out = %h", 
                  $time, pc_in, rs1_in, imm_in, iadder_src_in, iadder_out);

        // Test 1: iadder_src_in = 0 => use pc_in
        pc_in = 32'h0000_1000;
        rs1_in = 32'h1111_0000;
        imm_in = 32'h0000_0004;
        iadder_src_in = 0;
        #10;

        // Test 2: iadder_src_in = 1 => use rs1_in
        iadder_src_in = 1;
        #10;

        // Test 3: test with negative immediate
        imm_in = -4;
        iadder_src_in = 0; // using pc_in again
        #10;

        // Test 4: large values
        pc_in = 32'hFFFF_FFFC;
        rs1_in = 32'h0000_0001;
        imm_in = 32'h0000_0008;
        iadder_src_in = 0;
        #10;

        iadder_src_in = 1;
        #10;

        // End simulation
        $finish;
    end

endmodule
