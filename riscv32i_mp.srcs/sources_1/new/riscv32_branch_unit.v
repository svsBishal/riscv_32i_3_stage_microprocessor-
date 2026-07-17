`timescale 1ns / 1ps

module riscv32_branch_unit(
    // Inputs :
    input [31:0] rs1_in, 
    input [31:0] rs2_in,
    input [6:2] opcode_6_to_2_in,
    input [14:12] func3_in,
    // Outputs :
    output reg branch_taken_out
    );
    
    // encoding :
    parameter BEQ = 3'b000;
    parameter BNE = 3'b001;
    parameter BLT = 3'b100;
    parameter BGE = 3'b101;
    parameter BLTU = 3'b110;
    parameter BGEU = 3'b111;
    
    // main logic :
    always@(*) begin
        if(opcode_6_to_2_in == 5'b11000) begin
            case(func3_in)
                BEQ : branch_taken_out = (rs1_in == rs2_in);
                BNE : branch_taken_out = (rs1_in != rs2_in);
                BLT : branch_taken_out = $signed(rs1_in) < $signed(rs2_in);
                BGE : branch_taken_out = $signed(rs1_in) >= $signed(rs2_in);
                BLTU : branch_taken_out = rs1_in < rs2_in;
                BGEU : branch_taken_out = rs1_in >= rs2_in;
                default : branch_taken_out = 1'b0;
            endcase
        end else if (opcode_6_to_2_in == 5'b11001 | opcode_6_to_2_in == 5'b11011 )begin
            branch_taken_out = 1'b1;
        end else begin 
            branch_taken_out = 1'b0;
        end
    end
    
endmodule
