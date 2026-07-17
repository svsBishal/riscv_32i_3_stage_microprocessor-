`timescale 1ns / 1ps

module riscv32_mp_top_module_tb();
    // Inputs
    reg clk;
    reg rst;
    reg instr_hready;
    reg hresp;
    reg data_hready;
    reg eirq;
    reg tirq;
    reg sirq;
    reg [63:0] rc_in;
    reg [31:0] dmadata;
    reg [31:0] instr_in;
    
    // Outputs
    wire dmwr_req;
    wire [1:0] data_htrans;
    wire [4:0] rs1_addr, rs2_addr, rd_addr;
    wire [31:0] rd_out, rs1, rs2; // Observe x28 content
    wire [3:0] alu_opcode_out; 
    wire [31:0] alu_2nd_src; 
    wire [31:0] alu_result; 
    wire [31:0] reg_block_2_rs1, reg_block_2_rs2;
    wire [3:0] reg_block_2_alu_opcode_out;
    
    // Instantiate DUT
    riscv32_mp_top_module dut (
        .ms_riscv32_mp_clk_in(clk),
        .ms_riscv32_mp_rst_in(rst),
        .ms_riscv32_mp_instr_hready_in(instr_hready),
        .ms_riscv32_mp_hresp_in(hresp),
        .ms_riscv32_mp_data_hready_in(data_hready),
        .ms_riscv32_mp_eirq_in(eirq),
        .ms_riscv32_mp_tirq_in(tirq),
        .ms_riscv32_mp_sirq_in(sirq),
        .ms_riscv32_mp_rc_in(rc_in),
        .ms_riscv32_mp_dmdata_in(dmadata),
        .ms_riscv32_mp_instr_in(instr_in),
        .ms_riscv32_mp_dmwr_req_out(dmwr_req),
        .ms_riscv32_mp_data_htrans_out(data_htrans),
        .rd_out_out(rd_out),
        .rs1_addr(rs1_addr),
        .rs2_addr(rs2_addr),
        .rd_addr(rd_addr),
        .rs1(rs1),
        .rs2(rs2),
        .alu_opcode_out_out(alu_opcode_out),
        .alu_2nd_src(alu_2nd_src),
        .alu_result(alu_result),
        .reg_block_2_rs1(reg_block_2_rs1),
        .reg_block_2_rs2(reg_block_2_rs2),
        .reg_block_2_alu_opcode_out(reg_block_2_alu_opcode_out)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Test Sequence
    initial begin
        // Init signals
        rc_in = 64'd0;
        instr_hready = 1;
        data_hready = 1;
        hresp = 0;
        eirq = 0;
        tirq = 0;
        sirq = 0;
        dmadata = 32'd0;
        
        
        // R type add : 00000000001000001000111000110011
        // I type add : 00000000010100001000111000010011
        // Provide R-type instruction: add x28, x1, x2
        // binary equivalent of add x28, x1, x2 00000000010100001000111000010011

        // Reset pulse
        rst = 1;
        #20;
        rst = 0;
        
        # 5 instr_in = 32'b00000000001000001000111000110011;
        # 25 instr_in = 32'b00000000010100001000111000010011; 

        // Let it run and observe
        #100;

        $display("x28 (rd_out): %d", rd_out);
        $display("%d", rs1);
        $display("%d", rs2);
        $display("%d", rs1_addr);
        $display("%d", rs2_addr);
        $display("%d", rd_addr);
        $display("%d", alu_opcode_out);
        $display("%d", alu_2nd_src);
        $display("%d", alu_result);
        $display("%d", reg_block_2_rs1);
        $display("%d", reg_block_2_rs2);
        $display("%d", reg_block_2_alu_opcode_out);
        
        if (rd_out == 22)
            $display("TEST PASSED: x28 = %d", rd_out);
        else
            $display("TEST FAILED: x28 = %d", rd_out);

        $stop;
    end
endmodule
