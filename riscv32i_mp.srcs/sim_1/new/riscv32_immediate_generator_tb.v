`timescale 1ns / 1ps

module riscv32_immediate_generator_tb;

    // Inputs
    reg [31:7] instr_in;
    reg [2:0] imm_type_in;

    // Output
    wire [31:0] imm_out;

    // Instantiate the Unit Under Test (UUT)
    riscv32_imm_generator uut (
        .instr_in(instr_in), 
        .imm_type_in(imm_type_in), 
        .imm_out(imm_out)
    );

    // Instruction type encoding parameters
    parameter I_TYPE = 3'b001;
    parameter S_TYPE = 3'b010;
    parameter B_TYPE = 3'b011;
    parameter U_TYPE = 3'b100;
    parameter J_TYPE = 3'b101;
    parameter C_TYPE = 3'b110;

    initial begin
        // Monitor values
        $monitor("Time = %0t | Type = %b | Instr_in = %b | Imm_out = %h", $time, imm_type_in, instr_in, imm_out);

        // Test I-TYPE (e.g. immediate = 0xFFF)
        imm_type_in = I_TYPE;
        instr_in = 25'b111111111111_00000_00000; // immediate = 0xFFF
        #10;

        // Test S-TYPE (e.g. immediate = 0xABC)
        imm_type_in = S_TYPE;
        instr_in = {7'b1010101, 5'b00000, 5'b01100}; // imm[11:5] = 1010101, imm[4:0] = 01100
        #10;

        // Test B-TYPE (e.g. immediate = -4)
        imm_type_in = B_TYPE;
        instr_in = {7'b1111111, 5'b00000, 5'b11100}; // should form -4 (111111...1100)
        #10;

        // Test U-TYPE (e.g. upper 20 = 0xABCDE)
        imm_type_in = U_TYPE;
        instr_in = 25'hABCDE; // imm = 0xABCDE000
        #10;

        // Test J-TYPE (e.g. immediate = some arbitrary offset)
        imm_type_in = J_TYPE;
        instr_in = {1'b1, 8'b10101010, 1'b1, 10'b1100110011, 5'b00000}; // compose imm
        #10;

        // Test C-TYPE (e.g. CSR imm = 5'd10)
        imm_type_in = C_TYPE;
        instr_in = {6'd0, 5'd10, 14'd0}; // CSR field = 10
        #10;

        // Finish simulation
        $finish;
    end

endmodule
