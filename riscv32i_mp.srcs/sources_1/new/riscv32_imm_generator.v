`timescale 1ns / 1ps

module riscv32_imm_generator(
    // Inputs :
    input [31:7] instr_in,
    input [2:0] imm_type_in,
    // Outputs :
    output reg [31:0] imm_out
    );
    
    // instructions type encoding :
    parameter I_TYPE = 3'b001;
    parameter S_TYPE = 3'b010;
    parameter B_TYPE = 3'b011;
    parameter U_TYPE = 3'b100;
    parameter J_TYPE = 3'b101;
    parameter C_TYPE = 3'b110;
    
    // Internal wires :
    wire [31:0] i_type_imm_out, s_type_imm_out, b_type_imm_out, u_type_imm_out, j_type_imm_out, c_type_imm_out;
    
    // internal wire assignments :
    assign i_type_imm_out = {{20{instr_in[31]}}, instr_in[31:20]};
    assign s_type_imm_out = {{20{instr_in[31]}}, instr_in[31:25], instr_in[11:7]};
    assign b_type_imm_out = {{20{instr_in[31]}}, instr_in[7], instr_in[30:25], instr_in[11:8], 1'b0};
    assign u_type_imm_out = {instr_in[31:12], 12'b0};
    assign j_type_imm_out = {{12{instr_in[31]}}, instr_in[19:12], instr_in[20], instr_in[30:21], 1'b0};
    assign c_type_imm_out = {27'b0, instr_in[19:15]};
    
    // Type selection :
    always@(*) begin
        case(imm_type_in) 
            I_TYPE : imm_out = i_type_imm_out;
            S_TYPE : imm_out = s_type_imm_out;
            B_TYPE : imm_out = b_type_imm_out;
            U_TYPE : imm_out = u_type_imm_out;
            J_TYPE : imm_out = j_type_imm_out;
            C_TYPE : imm_out = c_type_imm_out;
            default : imm_out = i_type_imm_out;
        endcase
        
    end
    
endmodule
