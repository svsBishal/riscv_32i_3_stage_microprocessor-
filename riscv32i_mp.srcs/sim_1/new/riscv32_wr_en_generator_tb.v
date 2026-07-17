`timescale 1ns / 1ps

module riscv32_wr_en_generator_tb;

    // Inputs
    reg flush_in;
    reg rf_wr_en_reg_in;
    reg csr_wr_en_reg_in;

    // Outputs
    wire wr_en_integer_file_out;
    wire wr_en_csr_file_out;

    // Instantiate the Unit Under Test (UUT)
    riscv32_wr_en_generator uut (
        .flush_in(flush_in),
        .rf_wr_en_reg_in(rf_wr_en_reg_in),
        .csr_wr_en_reg_in(csr_wr_en_reg_in),
        .wr_en_integer_file_out(wr_en_integer_file_out),
        .wr_en_csr_file_out(wr_en_csr_file_out)
    );

    initial begin
        $monitor("Time=%0t | flush=%b | rf_wr=%b | csr_wr=%b || wr_en_int=%b | wr_en_csr=%b",
                  $time, flush_in, rf_wr_en_reg_in, csr_wr_en_reg_in, wr_en_integer_file_out, wr_en_csr_file_out);

        // Test 1: Normal write enable (no flush)
        flush_in = 0;
        rf_wr_en_reg_in = 1;
        csr_wr_en_reg_in = 1;
        #10;

        // Test 2: Flush active - all outputs should be 0
        flush_in = 1;
        #10;

        // Test 3: Only integer write enabled, flush inactive
        flush_in = 0;
        rf_wr_en_reg_in = 1;
        csr_wr_en_reg_in = 0;
        #10;

        // Test 4: Only CSR write enabled, flush inactive
        rf_wr_en_reg_in = 0;
        csr_wr_en_reg_in = 1;
        #10;

        // Test 5: Flush active again
        flush_in = 1;
        #10;

        // End simulation
        $finish;
    end

endmodule
