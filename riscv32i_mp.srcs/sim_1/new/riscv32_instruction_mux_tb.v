`timescale 1ns / 1ps

module riscv32_instruction_mux_tb;

    // Inputs
    reg flush_in;
    reg [31:0] ms_riscv32_mp_instr_in;

    // Outputs
    wire [6:0] opcode_out;
    wire [14:12] func3_out;
    wire [31:25] func7_out;
    wire [19:15] rs1_addr_out;
    wire [24:20] rs2_addr_out;
    wire [11:7] rd_addr_out;
    wire [31:20] csr_addr_out;
    wire [31:7] instr_out;

    // Instantiate DUT
    riscv32_instruction_mux uut (
        .flush_in(flush_in),
        .ms_riscv32_mp_instr_in(ms_riscv32_mp_instr_in),
        .opcode_out(opcode_out),
        .func3_out(func3_out),
        .func7_out(func7_out),
        .rs1_addr_out(rs1_addr_out),
        .rs2_addr_out(rs2_addr_out),
        .rd_addr_out(rd_addr_out),
        .csr_addr_out(csr_addr_out),
        .instr_out(instr_out)
    );

    initial begin
        // Initialize Inputs
        flush_in = 0;

        // Provide the instruction: add x28, x1, x2 => 0x002087B3
        ms_riscv32_mp_instr_in = 32'b00000000010100001000111000010011 ;

        #10;
        $display("When flush_in = 0 (normal mode):");
        $display("opcode     = %b", opcode_out);
        $display("func3      = %b", func3_out);
        $display("func7      = %b", func7_out);
        $display("rs1_addr   = %d", rs1_addr_out);
        $display("rs2_addr   = %d", rs2_addr_out);
        $display("rd_addr    = %d", rd_addr_out);
        $display("csr_addr   = %h", csr_addr_out);
        $display("instr_out  = %h", instr_out);

        // Now test with flush enabled (should give NOP = 0x00000013)
        flush_in = 1;
        #10;
        $display("\nWhen flush_in = 1 (NOP injected):");
        $display("opcode     = %b", opcode_out);
        $display("func3      = %b", func3_out);
        $display("func7      = %b", func7_out);
        $display("rs1_addr   = %d", rs1_addr_out);
        $display("rs2_addr   = %d", rs2_addr_out);
        $display("rd_addr    = %d", rd_addr_out);
        $display("csr_addr   = %h", csr_addr_out);
        $display("instr_out  = %h", instr_out);

        $stop;
    end

endmodule
