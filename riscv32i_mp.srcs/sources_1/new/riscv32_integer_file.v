`timescale 1ns / 1ps

module riscv32_integer_file(
    // Inputs :
    input ms_riscv32_mp_clk_in, 
    input ms_riscv32_mp_rst_in, 
    input wr_en_in,
    input [24:20] rs2_addr_in, 
    input [19:15] rs1_addr_in, 
    input [11:7] rd_addr_in,
    input [31:0] rd_in,
    // Outputs :
    output [31:0] rs1_out, 
    output [31:0] rs2_out
    );
    
    // declaration of register file :
    reg [31:0] reg_file [0:31];
    
    // internal wire for bypassing :
    // it means when writing is enabled and someone wants to read from the same address where new data being written in at the same time 
    // you can rather than writing from the regfile, simply read the data from the 'rd_in' port
    wire fwd_op1_enable, fwd_op2_enable;
    
    // assignments :
    assign fwd_op1_enable = (rd_addr_in != 5'b0 && rs1_addr_in == rd_addr_in && wr_en_in == 1'b1)? 1'b1 : 1'b0;
    assign fwd_op2_enable = (rd_addr_in != 5'b0 && rs2_addr_in == rd_addr_in && wr_en_in == 1'b1)? 1'b1 : 1'b0;
    
    // synchronous logic for reset and write operation :
    always@(posedge ms_riscv32_mp_clk_in or posedge ms_riscv32_mp_rst_in ) begin
        if(ms_riscv32_mp_rst_in) begin 
            reg_file[0] = 32'b0;
            reg_file[1] = 32'b0;
            reg_file[2] = 32'h0002f000;
            reg_file[3] = 32'b0;
            reg_file[4] = 32'b0;
            reg_file[5] = 32'b0;
            reg_file[6] = 32'b0;
            reg_file[7] = 32'b0;
            reg_file[8] = 32'b0;
            reg_file[9] = 32'b0;
            reg_file[10] = 32'b0;
            reg_file[11] = 32'b0;
            reg_file[12] = 32'b0;
            reg_file[13] = 32'b0;
            reg_file[14] = 32'b0;
            reg_file[15] = 32'b0;
            reg_file[16] = 32'b0;
            reg_file[17] = 32'b0;
            reg_file[18] = 32'b0;
            reg_file[19] = 32'b0;
            reg_file[20] = 32'b0;
            reg_file[21] = 32'b0;
            reg_file[22] = 32'b0;
            reg_file[23] = 32'b0;
            reg_file[24] = 32'b0;
            reg_file[25] = 32'b0;
            reg_file[26] = 32'b0;
            reg_file[27] = 32'b0;
            reg_file[28] = 32'b0;
            reg_file[29] = 32'b0;
            reg_file[30] = 32'b0;
            reg_file[31] = 32'b0;
        end 
        else if (wr_en_in && rd_addr_in) begin
            reg_file[rd_addr_in] = rd_in;
        end
    end
    // 2f000
    // Asynchronous logic for read operations :
    assign rs1_out = fwd_op1_enable ? rd_in : reg_file[rs1_addr_in];
    assign rs2_out = fwd_op2_enable ? rd_in : reg_file[rs2_addr_in];
    
endmodule
