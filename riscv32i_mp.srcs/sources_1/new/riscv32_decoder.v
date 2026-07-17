`timescale 1ns / 1ps

module riscv32_decoder(
    // Inputs :
    input trap_taken_in, 
    input func7_5_in,
    input [6:0] opcode_in,
    input [14:12] func3_in,
    input [1:0] i_adder_out_1_to_0_in,
    
    // Outputs :
    output is_load_out,
    output is_store_out,
    output [2:0] wb_mux_sel_out, 
    output [2:0] imm_type_out, 
    output [2:0] csr_op_out,
    output [3:0] alu_opcode_out,
    output [1:0] load_size_out,
    output mem_wr_req_out, 
    output load_unsigned_out, 
    output alu_src_out, 
    output i_adder_src_out, 
    output csr_wr_en_out, 
    output rf_wr_en_out, 
    output illegal_instr_out, 
    output misaligned_load_out, 
    output misaligned_store_out
    );
    
    // internal wire declaration :
    wire is_branch,
         is_jal,
         is_jalr,
         is_auipc,
         is_lui,
         is_op,
         is_op_imm,
         is_load,
         is_store,
         is_system,
         is_misc_mem,
         
         is_csr,
         mal_word,
         mal_half,
         is_implemented_instr;
         
    
    wire is_addi,
         is_slti,
         is_sltui,
         is_andi,
         is_ori,
         is_xori;
         
    assign is_load_out = is_load;
    assign is_store_out = is_store;
    
       
    // opcode_6_to_2_in_decoder implementation :
    assign is_branch = (opcode_in[6:2] == 5'b11000);
    assign is_jal = (opcode_in[6:2] == 5'b11011);
    assign is_jalr = (opcode_in[6:2] == 5'b11001);
    assign is_auipc = (opcode_in[6:2] == 5'b00101);
    assign is_lui = (opcode_in[6:2] == 5'b01101);
    assign is_op = (opcode_in[6:2] == 5'b01100);
    assign is_op_imm = (opcode_in[6:2] == 5'b00100);
    assign is_load = (opcode_in[6:2] == 5'b00000);
    assign is_store = (opcode_in[6:2] == 5'b01000);
    assign is_system = (opcode_in[6:2] == 5'b11100);
    assign is_misc_mem = (opcode_in[6:2] == 5'b00011);
    
    assign is_csr = is_system & (|func3_in);
    assign mal_word = (func3_in == 3'b010 && i_adder_out_1_to_0_in != 2'b00);
    assign mal_half = (func3_in == 3'b001 && i_adder_out_1_to_0_in[0] != 1'b0);
    
    // immediate operations flag :
    assign is_addi = (is_op_imm && (func3_in == 3'b000));
    assign is_slti = (is_op_imm && (func3_in == 3'b010));
    assign is_sltui = (is_op_imm && (func3_in == 3'b011));
    assign is_andi = (is_op_imm && (func3_in == 3'b111));
    assign is_ori = (is_op_imm && (func3_in == 3'b110));
    assign is_xori = (is_op_imm && (func3_in == 3'b100));
    
    
    // -----------------------------------------------------------------------------------
    // OUTPUTS ::::
    
    // logic to output alu_opcode_out :
    assign alu_opcode_out[2:0] = func3_in;
    assign alu_opcode_out[3] = func7_5_in & (~(is_addi | is_slti | is_sltui | is_andi | is_ori | is_xori));
    
    // logic to output rf_wr_en_out :
    assign rf_wr_en_out = is_lui | is_auipc | is_jalr | is_jal | is_op | is_load |is_csr | is_op_imm;

    // logic to output load_size_out & load_unsigned_out :
    assign load_size_out = func3_in[13:12];
    assign load_unsigned_out = func3_in[14];
    
    // logic to output alu_src_out :
    assign alu_src_out = opcode_in[5];
    
    // logic to output i_adder_src_out :
    assign i_adder_src_out = is_load | is_store | is_jalr;
    
    // logic to output csr_wr_en_out :
    assign csr_wr_en_out = is_csr;
    
    // logic to output wb_mux_sel_out :
    assign wb_mux_sel_out [0] = is_load | is_auipc | is_jal|is_jalr;
    assign wb_mux_sel_out [1] = is_lui | is_auipc;
    assign wb_mux_sel_out [2] = is_csr | is_jal | is_jalr;
    
    // logic to output imm_type_out :
    assign imm_type_out [0] = is_op_imm|is_load |is_jalr | is_branch |is_jal;
    assign imm_type_out [1] = is_store |is_branch | is_csr;
    assign imm_type_out [2] = is_lui |is_auipc |is_jal|is_csr;
    
    // logic to output is_implemented_out :
    assign is_implemented_instr = is_branch | is_jal | is_jalr | is_auipc | is_lui |
                                is_op | is_op_imm | is_load | is_store |
                                is_system | is_misc_mem;
    
    assign illegal_instr_out = ~is_implemented_instr;

    
    // logic to output csr_op_out :
    assign csr_op_out = func3_in;
    
    // logic to output misaligned_load_out :
    assign misaligned_load_out = is_load && (mal_half | mal_word);
    
    // logic to output misaligned_store_out :
    assign misaligned_store_out = is_store && (mal_half | mal_word);
    
    // logic to output misaligned_store_out :
    assign  mem_wr_req_out = is_store && (!trap_taken_in && !mal_word && !mal_half);
    
endmodule
