`timescale 1ns / 1ps

module riscv32_reg_block_1_tb;

    reg [31:0] pc_mux_in;
    reg ms_riscv32_mp_clk_in;
    reg ms_riscv32_mp_rst_in;
    wire [31:0] pc_out;

    riscv32_reg_block_1 uut (
        .pc_mux_in(pc_mux_in),
        .ms_riscv32_mp_clk_in(ms_riscv32_mp_clk_in),
        .ms_riscv32_mp_rst_in(ms_riscv32_mp_rst_in),
        .pc_out(pc_out)
    );

    initial begin
        ms_riscv32_mp_clk_in = 0;
        forever #5 ms_riscv32_mp_clk_in = ~ms_riscv32_mp_clk_in;
    end

    initial begin
        ms_riscv32_mp_rst_in = 0;
        pc_mux_in = 32'h12345678;
        #10;
        ms_riscv32_mp_rst_in = 1;
        #10;
        pc_mux_in = 32'hDEADBEEF;
        #10;
        pc_mux_in = 32'hCAFEBABE;
        #10;
        $finish;
    end

endmodule
