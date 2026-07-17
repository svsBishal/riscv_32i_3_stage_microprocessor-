`timescale 1ns / 1ps

module riscv32_reg_block_2(
    // Inputs :
    
    input [31:0] dm_data_in, 
    
    input clk_in,
    input rst_in,
    input branch_taken_in,
    input load_unsigned_in,
    input alu_src_in,
    input csr_wr_en_in,
    input rf_wr_en_in,
          
    input [11:7] rd_addr_in,
    input [31:20] csr_addr_in,
    input [31:0] rs1_in, 
    input [31:0] rs2_in, 
    input [31:0] pc_in, 
    input [31:0] pc_plus_4_in,
    input [31:0] i_adder_in,
    input [31:0] imm_in,
    input [3:0] alu_opcode_in,
    input [1:0] load_size_in, 
    input [2:0] wb_mux_sel_in,
    input [2:0] csr_op_in,
                
    // Outputs :
    
    output reg [31:0] dm_data_reg_out,
    
    output reg branch_taken_reg_out,
    output reg load_unsigned_ireg_out,
    output reg alu_src_reg_out,
    output reg csr_wr_en_reg_out,
    output reg rf_wr_en_reg_out,
    output reg [11:7] rd_addr_reg_out,
    output reg [31:20] csr_addr_reg_out,
    output reg [31:0] rs1_reg_out, 
    output reg [31:0] rs2_reg_out, 
    output reg [31:0] pc_reg_out, 
    output reg [31:0] pc_plus_4_reg_out,
    output reg [31:0] i_adder_reg_out,
    output reg [31:0] imm_reg_out,
    output reg [3:0] alu_opcode_reg_out,
    output reg [1:0] load_size_ireg_out, 
    output reg [2:0] wb_mux_sel_reg_out,
    output reg [2:0] csr_op_reg_out
                     
    );
    
    always@(posedge clk_in or posedge rst_in) begin
        if(rst_in) begin
            dm_data_reg_out <= 32'b0;
            
            branch_taken_reg_out <= 1'b0;
            load_unsigned_ireg_out <= 1'b0;
            alu_src_reg_out <= 1'b0; 
            csr_wr_en_reg_out <= 1'b0;
            rf_wr_en_reg_out <= 1'b0;
            rd_addr_reg_out <= 5'b0;
            csr_addr_reg_out <= 12'b0;
            rs1_reg_out <= 32'b0;
            rs2_reg_out <= 32'b0;
            pc_reg_out <= 32'b0;
            pc_plus_4_reg_out <= 32'b0;
            i_adder_reg_out <= 32'b0;
            imm_reg_out <= 32'b0;
            alu_opcode_reg_out <= 4'b0;
            load_size_ireg_out <= 2'b0;
            wb_mux_sel_reg_out <= 3'b0;
            csr_op_reg_out <= 3'b0;        
        end
        else begin
            dm_data_reg_out <= dm_data_in;
            
            branch_taken_reg_out <= branch_taken_in;
            load_unsigned_ireg_out <= load_unsigned_in;
            alu_src_reg_out <= alu_src_in; 
            csr_wr_en_reg_out <= csr_wr_en_in;
            rf_wr_en_reg_out <= rf_wr_en_in;
            rd_addr_reg_out <= rd_addr_in;
            csr_addr_reg_out <= csr_addr_in;
            rs1_reg_out <= rs1_in;
            rs2_reg_out <= rs2_in;
            pc_reg_out <= pc_in;
            pc_plus_4_reg_out <= pc_plus_4_in;
            imm_reg_out <= imm_in;
            alu_opcode_reg_out <= alu_opcode_in;
            load_size_ireg_out <= load_size_in;
            wb_mux_sel_reg_out <= wb_mux_sel_in;
            csr_op_reg_out <= csr_op_in;

            // MUX for i_adder_reg_out[0]
            i_adder_reg_out <= i_adder_in;
            i_adder_reg_out[0] <= (branch_taken_in) ? 1'b0 : i_adder_in[0];
        end
    end
    
endmodule
