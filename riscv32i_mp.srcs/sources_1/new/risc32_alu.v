`timescale 1ns / 1ps

////// Using 3 bit opcode case : /////

module risc32_alu(
    input [31:0] op_1_in,
    input [31:0] op_2_in,
    input [3:0] opcode_in,
    output reg [31:0] result_out
);

    // ALU Operations encoding :
    parameter FUNC3_ADD  = 3'b000;
    parameter FUNC3_SLT  = 3'b010;
    parameter FUNC3_SLTU = 3'b011;
    parameter FUNC3_AND  = 3'b111;
    parameter FUNC3_OR   = 3'b110;
    parameter FUNC3_XOR  = 3'b100;
    parameter FUNC3_SLL  = 3'b001;
    parameter FUNC3_SHR  = 3'b101;

    // Internal wires
    wire signed [31:0] signed_op1;
    wire signed [31:0] adder_op2;
    wire [31:0] minus_op2;
    wire [31:0] shr_result;
    wire [31:0] srl_result;
    wire [31:0] sra_result;
    wire sltu_result;
    wire slt_result;

    assign signed_op1 = op_1_in;
    assign minus_op2 = -op_2_in;
    assign adder_op2 = opcode_in[3] ? minus_op2 : op_2_in;

    assign srl_result = op_1_in >> op_2_in[4:0];
    assign sra_result = signed_op1 >>> op_2_in[4:0];
    assign shr_result = opcode_in[3] ? sra_result : srl_result;

    assign sltu_result = (op_1_in < op_2_in);
    assign slt_result = ($signed(op_1_in) < $signed(op_2_in));

    always @(*) begin
        case (opcode_in[2:0])
            FUNC3_ADD  : result_out = op_1_in + adder_op2;
            FUNC3_SHR  : result_out = shr_result;
            FUNC3_OR   : result_out = op_1_in | op_2_in;
            FUNC3_AND  : result_out = op_1_in & op_2_in;
            FUNC3_XOR  : result_out = op_1_in ^ op_2_in;
            FUNC3_SLT  : result_out = {31'b0, slt_result};
            FUNC3_SLTU : result_out = {31'b0, sltu_result};
            FUNC3_SLL  : result_out = op_1_in << op_2_in[4:0];
            default    : result_out = 32'b0;
        endcase
    end

endmodule



///// using 4 bit opcode count : //////

//`timescale 1ns / 1ps

//module risc32_alu(
//    input [31:0] op_1_in,
//    input [31:0] op_2_in,
//    input [3:0] opcode_in,         // Full 4-bit opcode
//    output reg [31:0] result_out
//);

//    // Opcode encoding (4-bit: {extra_bit, func3})
//    localparam [3:0]
//        OPCODE_ADD  = 4'b0000,
//        OPCODE_SUB  = 4'b1000,
//        OPCODE_SLL  = 4'b0001,
//        OPCODE_SLT  = 4'b0010,
//        OPCODE_SLTU = 4'b0011,
//        OPCODE_XOR  = 4'b0100,
//        OPCODE_SRL  = 4'b0101,
//        OPCODE_SRA  = 4'b1101,
//        OPCODE_OR   = 4'b0110,
//        OPCODE_AND  = 4'b0111;

//    wire signed [31:0] signed_op1 = op_1_in;
//    wire signed [31:0] signed_op2 = op_2_in;

//    always @(*) begin
//        case (opcode_in)
//            OPCODE_ADD  : result_out = op_1_in + op_2_in;
//            OPCODE_SUB  : result_out = op_1_in - op_2_in;
//            OPCODE_SLL  : result_out = op_1_in << op_2_in[4:0];
//            OPCODE_SLT  : result_out = ($signed(op_1_in) < $signed(op_2_in)) ? 32'd1 : 32'd0;
//            OPCODE_SLTU : result_out = (op_1_in < op_2_in) ? 32'd1 : 32'd0;
//            OPCODE_XOR  : result_out = op_1_in ^ op_2_in;
//            OPCODE_SRL  : result_out = op_1_in >> op_2_in[4:0];
//            OPCODE_SRA  : result_out = signed_op1 >>> op_2_in[4:0];
//            OPCODE_OR   : result_out = op_1_in | op_2_in;
//            OPCODE_AND  : result_out = op_1_in & op_2_in;
//            default     : result_out = 32'b0;
//        endcase
//    end

//endmodule

