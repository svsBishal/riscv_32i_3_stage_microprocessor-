`timescale 100ns / 1ns

module risc32_alu_tb;

    // Inputs
    reg [31:0] op_1_in;
    reg [31:0] op_2_in;
    reg [3:0] opcode_in;

    // Output
    wire [31:0] result_out;

    // Instantiate the ALU
    risc32_alu uut (
        .op_1_in(op_1_in),
        .op_2_in(op_2_in),
        .opcode_in(opcode_in),
        .result_out(result_out)
    );

    // Task to display result
    task show_result;
        input [8*10:1] operation;
        begin
            #5; // small delay for output to settle
            $display("%s: op1 = %0d, op2 = %0d => result = %0d (hex: %h)", 
                     operation, op_1_in, op_2_in, result_out, result_out);
        end
    endtask

    initial begin
        $display("=== Starting ALU Testbench ===");

        // ADD (opcode_in = 4'b0000)
        op_1_in = 32'd10; op_2_in = 32'd5; opcode_in = 4'b0000;
        show_result("ADD");

        // SUB (opcode_in = 4'b1000)
        op_1_in = 32'd10; op_2_in = 32'd5; opcode_in = 4'b1000;
        show_result("SUB");

        // SRA (opcode_in = 4'b1101)
        op_1_in = -32'sd16; op_2_in = 32'd2; opcode_in = 4'b1101;
        show_result("SRA");

        // SRL (opcode_in = 4'b0101)
        op_1_in = 32'd16; op_2_in = 32'd2; opcode_in = 4'b0101;
        show_result("SRL");

        // OR (opcode_in = 4'b0110)
        op_1_in = 32'h0F0F0F0F; op_2_in = 32'h00FF00FF; opcode_in = 4'b0110;
        show_result("OR");

        // AND (opcode_in = 4'b0111)
        op_1_in = 32'h0F0F0F0F; op_2_in = 32'h00FF00FF; opcode_in = 4'b0111;
        show_result("AND");

        // XOR (opcode_in = 4'b0100)
        op_1_in = 32'h0F0F0F0F; op_2_in = 32'h00FF00FF; opcode_in = 4'b0100;
        show_result("XOR");

        // SLT (opcode_in = 4'b0010)
        op_1_in = -32'sd1; op_2_in = 32'sd1; opcode_in = 4'b0010;
        show_result("SLT");

        // SLTU (opcode_in = 4'b0011)
        op_1_in = 32'hFFFFFFFF; op_2_in = 32'd0; opcode_in = 4'b0011;
        show_result("SLTU");

        // SLL (opcode_in = 4'b0001)
        op_1_in = 32'd1; op_2_in = 32'd3; opcode_in = 4'b0001;
        show_result("SLL");

        $display("=== Testbench Complete ===");
        $finish;
    end

endmodule
