`timescale 1ns / 1ps

module riscv32_wb_mux_sel_unit(
    // Inputs :
    input alu_src_reg_in,
    input [2:0] wb_mux_sel_reg_in,
    input [31:0] alu_result_in,
    input [31:0] lu_output_in,
    input [31:0] imm_reg_in,
    input [31:0] i_adder_out_reg_in,
    input [31:0] csr_data_in,
    input [31:0]pc_plus_4_reg_in,
    input [31:0] rs2_reg_in,
                 
    // Outputs :
    output reg [31:0] wb_mux_out,
     output reg [31:0] alu_2nd_src_mux_out
    );
    // encoding :
    parameter WB_ALU = 3'b000;
    parameter WB_LU = 3'b001;
    parameter WB_IMM = 3'b010;
    parameter WB_IADDER_OUT = 3'b011;
    parameter WB_CSR = 3'b100;
    parameter WB_PC_PLUS = 3'b101;
    
    always@(*) begin
        // To output alu_2nd_src_mux_out :
        alu_2nd_src_mux_out = alu_src_reg_in? rs2_reg_in : imm_reg_in;
        
        // To output wb_mux_out
        case (wb_mux_sel_reg_in) 
            WB_ALU : wb_mux_out = alu_result_in;
            WB_LU : wb_mux_out = lu_output_in;
            WB_IMM : wb_mux_out = imm_reg_in;
            WB_IADDER_OUT : wb_mux_out = i_adder_out_reg_in;
            WB_CSR : wb_mux_out = csr_data_in;
            WB_PC_PLUS : wb_mux_out = pc_plus_4_reg_in;
        endcase
    end
    
endmodule
