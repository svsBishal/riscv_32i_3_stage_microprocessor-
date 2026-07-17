`timescale 1ns / 1ps

module riscv32_mp_top_module(
    // Inputs :
    input ms_riscv32_mp_clk_in,
    input ms_riscv32_mp_rst_in,
    input ms_riscv32_mp_instr_hready_in,
    input ms_riscv32_mp_hresp_in,        
    input ms_riscv32_mp_data_hready_in,
    input ms_riscv32_mp_eirq_in,
    input ms_riscv32_mp_tirq_in,
    input ms_riscv32_mp_sirq_in,
          
    input [31:0] ms_riscv32_mp_dmdata_in,
    input [31:0] ms_riscv32_mp_instr_in,
    input [63:0] ms_riscv32_mp_rc_in,
          
    // Outputs :
    output  ms_riscv32_mp_dmwr_req_out,
    output  [31:0] ms_riscv32_mp_dmdata_out,
    output [31:0] ms_riscv32_mp_dmaddr_out,
    output [31:0] ms_riscv32_mp_imaddr_out,
    output  [3:0] ms_riscv32_mp_dmwr_mask_out,
    output [1:0] ms_riscv32_mp_data_htrans_out,
    
    // Extras :
    output [31:0] rd_out_out,
    output [4:0] rs1_addr, rs2_addr, rd_addr,
    output [31:0] rs1, rs2,
    output [3:0] alu_opcode_out_out,
    output [31:0] alu_2nd_src, alu_result,
    output [31:0] reg_block_2_rs1, reg_block_2_rs2,
    output [3:0] reg_block_2_alu_opcode_out
    
    );
    
    // Internal wire declaration :
    // -------------------------------------------------------------
    // Outputs of PC MUX :
    wire [31:0] pc_plus_4_out; // to reg block 2
    wire misaligned_instr_out; // to machine control
    wire [31:0] pc_mux_out; // to reg block 1
    // -------------------------------------------------------------
    // Outputs of REG BLOCK 1 :
    wire [31:0] pc_out; // to REG BLOCK 2, IMMEDIATE ADDER 
    //--------------------------------------------------------------  
    // Outputs to IMMEDIATE GENERATOR :
    wire [31:0] imm_out; // to immediate adder
    // ------------------------------------------------------------- 
    // Outputs of IMMEDIATE ADDER :
    wire [31:0] i_adder_out; // to many modules
    // -------------------------------------------------------------   
    // Outputs of INTEGER FILES :
    wire [31:0] rs1_out; // to reg block 2, branch unit, immediate adder
    wire [31:0] rs2_out; // to reg block_2, branch unit, store unit
    // -------------------------------------------------------------  
    // Outputs of WRITE ENABLE GENERATOR :
    wire wr_en_integer_file_out; // to integer file
    wire wr_en_csr_file_out; // to csr file
    // -------------------------------------------------------------  
    // Outputs of INSTRUCTION MUX :
    wire [6:0] opcode_out; // to decoder, branch unit
    wire [14:12] func3_out; // to decoder, branch unit
    wire [31:25] func7_out; // to decoder
    wire [19:15] rs1_addr_out; // to integer file
    wire [24:20] rs2_addr_out; // to integer file
    wire [11:7] rd_addr_out; // to integer file
    wire [31:20] csr_addr_out; // to reg block 2
    wire [31:7] instr_out; // immediate generator
    // -------------------------------------------------------------  
    // Outputs of BRANCH UNIT :
    wire branch_taken_out; // 
    // -------------------------------------------------------------  
    // Outputs of DECODER :  
    wire [2:0] wb_mux_sel_out; // to reg block 2
    wire [2:0] imm_type_out; // to immediate generator
    wire [2:0]   csr_op_out; // to reg block 2
    wire [3:0] alu_opcode_out; // "
    wire [1:0] load_size_out; // "
    wire mem_wr_req_out; // to store unit
    wire load_unsigned_out; // to reg block 2
    wire alu_src_out; // reg block 2
    wire i_adder_src_out; // to reg block 2 
    wire csr_wr_en_out; // to reg block 2 
    wire rf_wr_en_out; // to reg block 2
    wire illegal_instr_out; // to machine control
    wire misaligned_load_out; // " 
    wire misaligned_store_out; // "
    // -------------------------------------------------------------
    // Output of MACHINE CONTROL :
    wire i_or_e_out; // to csr file
    wire instret_inc_out; // "
    wire mie_clear_out; // "
    wire mie_set_out; // "
    wire misaligned_exception_out; // "
    wire set_epc_out; // "
    wire set_cause_out; // "
    wire flush_out; // to write enable generator, instruction mux
    wire trap_taken_out; // to decoder
    wire [3:0] cause_out; // to csr file
    wire [1:0] pc_src_out; // to pc mux
    // ------------------------------------------------------------
    // Outputs of CSR FILE :
    wire [31:0] csr_data_out; // to wb mux sel out
    wire  mie_out; // to machine control
    wire [31:0] epc_out; // to pc mux
    wire [31:0] trap_address_out; // to pc mux
    wire meie_out; // to machine control
    wire mtie_out; // "
    wire msie_out; // "
    wire meip_out; // "
    wire mtip_out; // "
    wire msip_out; // "
    // ------------------------------------------------------------
    // Output of REGISTER BLOCK 2 :
    wire load_unsigned_ireg_out;
    wire alu_src_reg_out;
    wire csr_wr_en_reg_out;
    wire rf_wr_en_reg_out;
    wire [11:7] rd_addr_reg_out;
    wire [31:20] csr_addr_reg_out;
    wire [31:0] rs1_reg_out;
    wire [31:0] rs2_reg_out;
    wire [31:0] pc_reg_out; 
    wire [31:0] pc_plus_4_reg_out;
    wire [31:0] i_adder_reg_out;
    wire [31:0] imm_reg_out;
    wire [3:0] alu_opcode_reg_out;
    wire [1:0] load_size_ireg_out; 
    wire [2:0] wb_mux_sel_reg_out;
    wire [2:0] csr_op_reg_out;
    // --------------------------------------------------------------
    // Output of LOAD UNIT :
    wire [31:0] lu_output_out; // to wb mux sel unit
    // --------------------------------------------------------------
    // Output of ALU :
    wire [31:0] result_out; // to wb mux sel unit
    // --------------------------------------------------------------
    // Output of WB MUX SEL UNIT :
    wire [31:0] wb_mux_out; // 
    wire [31:0] alu_2nd_src_mux_out; // to alu 
    // -------------------------------------------------------------
    
    // For debugging :
    assign rs1_addr = rs1_addr_out;
    assign rs2_addr = rs2_addr_out;
    assign rd_addr = rd_addr_out;
    assign rs1 = rs1_out;
    assign rs2 = rs2_out;
    assign alu_opcode_out_out = alu_opcode_out;
    assign alu_2nd_src = alu_2nd_src_mux_out;
    assign alu_result = result_out;
    assign reg_block_2_rs1 = rs1_reg_out;
    assign reg_block_2_rs2 = rs2_reg_out;
    assign reg_block_2_alu_opcode_out = alu_opcode_reg_out;
    
    riscv32_pc PC_MODULE (
        // Inputs :
        .ms_riscv32_mp_rst_in(ms_riscv32_mp_rst_in), // external 
        .ahb_ready_in(ms_riscv32_mp_instr_hready_in), // external
        .branch_taken_in(branch_taken_out), // from branch unit
        .pc_src_in(pc_src_out), // from machine control
        .epc_in(epc_out), // from csr file
        .trap_address_in(trap_address_out), // from csr file
        .pc_in(pc_out), // from reg block 1
        .iadder_in(i_adder_out), // from immediate adder
        // Outputs :
        .misaligned_instr_logic_out(misaligned_instr_out), 
        .pc_plus_4_out(pc_plus_4_out),
        .iadder_out(ms_riscv32_mp_imaddr_out),
        .pc_mux_out(pc_mux_out) // to reg block 1
    );
    
    riscv32_reg_block_1 RB1(
        // Inputs :
        .pc_mux_in(pc_mux_out), // from pc mux
        .ms_riscv32_mp_clk_in(ms_riscv32_mp_clk_in), // external
        .ms_riscv32_mp_rst_in(ms_riscv32_mp_rst_in), // external
        // Outputs :
        .pc_out(pc_out) // to immediate adder
    );
    
    riscv32_imm_generator IMMGEN(
        // Inputs :
        .instr_in(instr_out), // from instr mux
        .imm_type_in(imm_type_out), // from decoder
        // Outputs :
        .imm_out(imm_out) // to immediate adder
    );
    
    riscv32_immediate_adder IMMADD (
        // Inputs :
        .pc_in(pc_out), // from reg block 1
        .rs1_in(rs1_out), // from integer file
        .imm_in(imm_out), // from immediate generator
        .iadder_src_in(i_adder_src_out), // from decoder
        // Outputs :
        .iadder_out(i_adder_out)
    );
    
//    dummy_int_file IMMDUM (
//            // Inputs :
//            .ms_riscv32_mp_clk_in(ms_riscv32_mp_clk_in), // external
//            .ms_riscv32_mp_rst_in(ms_riscv32_mp_rst_in), // external
//            .wr_en_in(wr_en_integer_file_out), // from write enable generator
//            .rs2_addr_in(rs2_addr_out), // instruction mux
//            .rs1_addr_in(rs1_addr_out), // "
//            .rd_addr_in(rd_addr_out), // "
//            .rd_in(wb_mux_out), // from wb mux
//            // Outputs :
//            .rs1_out(rs1_out),
//            .rs2_out(rs2_out),
//            .rd_out(rd_out_out)
//    );
    
    riscv32_integer_file (
        // Inputs :
        .ms_riscv32_mp_clk_in(ms_riscv32_mp_clk_in), // external
        .ms_riscv32_mp_rst_in(ms_riscv32_mp_rst_in), // external
        .wr_en_in(wr_en_integer_file_out), // from write enable generator
        .rs2_addr_in(rs2_addr_out), // instruction mux
        .rs1_addr_in(rs1_addr_out), // "
        .rd_addr_in(rd_addr_out), // "
        .rd_in(wb_mux_out), // from wb mux
        // Outputs :
        .rs1_out(rs1_out),
        .rs2_out(rs2_out)
    );
    
    riscv32_wr_en_generator WREN (
        // Inputs :
        .flush_in(flush_out), // from machine control
        .rf_wr_en_reg_in(rf_wr_en_reg_out), // from reg block 2
        .csr_wr_en_reg_in(csr_wr_en_reg_out), // from reg block 2
        // Outputs :
        .wr_en_integer_file_out(wr_en_integer_file_out), // to integer file
        .wr_en_csr_file_out(wr_en_csr_file_out) // to csr file
    );
    
    riscv32_instruction_mux IMUX (
        // Inputs :
        .flush_in(flush_out), // from machine control
        .ms_riscv32_mp_instr_in(ms_riscv32_mp_instr_in), // external
        // Outputs :
        .opcode_out(opcode_out), // to decoder, branch unit
        .func3_out(func3_out), // "
        .func7_out(func7_out), // to decoder
        .rs1_addr_out(rs1_addr_out), // to integer file
        .rs2_addr_out(rs2_addr_out), // "
        .rd_addr_out(rd_addr_out), // "
        .csr_addr_out(csr_addr_out), // to reg block 2
        .instr_out (instr_out) // to immediate genrator
    );
    
    riscv32_branch_unit BU (
        // Inputs :
        .rs1_in(rs1_out), // from integer file
        .rs2_in(rs2_out), // "
        .opcode_6_to_2_in(opcode_out[6:2]), // from instr mux
        .func3_in(func3_out), // "
        // Outputs :
        .branch_taken_out(branch_taken_out) // to pc, reg block 2
    );
    
    riscv32_decoder DEC (
        // Inputs :
        .trap_taken_in(trap_taken_out), // from machine control
        .func7_5_in(func7_out[30]), // from instr mux
        .opcode_in(opcode_out), // "
        .func3_in(func3_out), // "
        .i_adder_out_1_to_0_in(i_adder_out[1:0]), // from immediate adder
        
        // Outputs :
        .wb_mux_sel_out(wb_mux_sel_out), // to reg block 2
        .imm_type_out(imm_type_out), // to immediate generator
        .csr_op_out(csr_op_out), // to reg block 2
        .alu_opcode_out(alu_opcode_out), // "
        .load_size_out(load_size_out), // "
        .mem_wr_req_out(mem_wr_req_out), // to store unit
        .load_unsigned_out(load_unsigned_out), // to reg block 2 
        .alu_src_out(alu_src_out), // to reg block 2
        .i_adder_src_out(i_adder_src_out), // "
        .csr_wr_en_out(csr_wr_en_out), // "
        .rf_wr_en_out(rf_wr_en_out), // "
        .illegal_instr_out(illegal_instr_out), // to machine control
        .misaligned_load_out(misaligned_load_out), // "
        .misaligned_store_out(misaligned_store_out) // "
    );

    riscv32_machine_control MC(
        // Inputs :
        .ms_riscv32_mp_clk_in(ms_riscv32_mp_clk_in), // external
        .ms_riscv32_mp_rst_in(ms_riscv32_mp_rst_in), // "
        .ms_riscv32_mp_eirq_in(ms_riscv32_mp_eirq_in), // "
        .ms_riscv32_mp_tirq_in(ms_riscv32_mp_tirq_in), // "
        .ms_riscv32_mp_sirq_in(ms_riscv32_mp_sirq_in), // "
        .illegal_instr_in(illegal_instr_out), // from decoder
        .misaligned_load_in(misaligned_load_out), // "
        .misaligned_store_in(misaligned_store_out), // "
        .misaligned_instr_in(misaligned_instr_out), // from pc mux
        .mie_in(mie_out), // from csr file
        .meie_in(meie_out), // "
        .mtie_in(mtie_out), // "
        .msie_in(msie_out), // "
        .meip_in(meip_out), // "
        .mtip_in(mtip_out), // "
        .msip_in(msip_out), // " 
        .opcode_6_to_2_in(opcode_out[6:2]), // from instr mux
        .func3_in(func3_out), // "
        .func7_in(func7_out), // "
        .rs1_addr_in(rs1_addr_out), // "
        .rs2_addr_in(rs2_addr_out), // "
        .rd_addr_in(rd_addr_out), // "
        
        // Outputs :
        .i_or_e_out(i_or_e_out),
        .instret_inc_out(instret_inc_out),
        .mie_clear_out(mie_clear_out),
        .mie_set_out(mie_set_out),
        .misaligned_exception_out(misaligned_exception_out),
        .set_epc_out(set_epc_out),
        .set_cause_out(set_cause_out),
        .flush_out(flush_out),
        .trap_taken_out(trap_taken_out),
        .cause_out(cause_out),
        .pc_src_out(pc_src_out)  
    );
        
    riscv32_csr_file CSR (
        .csr_addr_in(csr_addr_reg_out), // from reg block 2
        .csr_op_in(csr_op_reg_out), // "
        .csr_uimm_in(imm_reg_out[4:0]), // "
        .csr_data_in(rs2_reg_out), // "
        .pc_in(pc_reg_out), // "
        .iadder_in(i_adder_reg_out), // "
        .clk_in(ms_riscv32_mp_clk_in), // external
        .rst_in(ms_riscv32_mp_rst_in), // "
        .wr_en_in(wr_en_csr_file_out), // from wb mux
        .e_irq_in(ms_riscv32_mp_eirq_in), // external
        .s_irq_in(ms_riscv32_mp_sirq_in), // "
        .t_irq_in(ms_riscv32_mp_tirq_in), // "
        .i_or_e_in(i_or_e_out), // from machine control
        .set_cause_in(set_cause_out), // "
        .set_epc_in(set_epc_out), // "
        .instret_inc_in(instret_inc_out), // "
        .mie_clear_in(mie_clear_out), // "
        .mie_set_in(mie_set_out), // "
        .cause_in(cause_out), // "
        .real_time_in(ms_riscv32_mp_rc_in), // external
        .misaligned_exception_in(misaligned_exception_out), // from machine control
        // Outputs :
        .csr_data_out(csr_data_out), // to wb mux
        .mie_out(mie_out), // to machine control
        .epc_out(epc_out), // "
        .trap_address_out(trap_address_out), // to pc mux
        .meie_out(meie_out), // to machine control
        .mtie_out(mtie_out), // "
        .msie_out(msie_out), // "
        .meip_out(meip_out), // "
        .mtip_out(mtip_out), // "
        .msip_out(msip_out) // "
    ); 
        
   riscv32_reg_block_2 RB2 (
        // Inputs :
       .clk_in(ms_riscv32_mp_clk_in),
       .rst_in(ms_riscv32_mp_rst_in),
       .branch_taken_in(branch_taken_out),
       .load_unsigned_in(load_unsigned_out),
       .alu_src_in(alu_src_out),
       .csr_wr_en_in(csr_wr_en_out),
       .rf_wr_en_in(rf_wr_en_out),
       .rd_addr_in(rd_addr_out),
       .csr_addr_in(csr_addr_out),
       .rs1_in(rs1_out),
       .rs2_in(rs2_out),
       .pc_in(pc_out),
       .pc_plus_4_in(pc_plus_4_out),
       .i_adder_in(i_adder_out),
       .imm_in(imm_out),
       .alu_opcode_in(alu_opcode_out),
       .load_size_in(load_size_out),
       .wb_mux_sel_in(wb_mux_sel_out),
       .csr_op_in(csr_op_out),
       
       // Outputs :
       .load_unsigned_ireg_out(load_unsigned_ireg_out),
       .alu_src_reg_out(alu_src_reg_out),
       .csr_wr_en_reg_out(csr_wr_en_reg_out),
       .rf_wr_en_reg_out(rf_wr_en_reg_out),
       .rd_addr_reg_out(rd_addr_reg_out),
       .csr_addr_reg_out(csr_addr_reg_out),
       .rs1_reg_out(rs1_reg_out),
       .rs2_reg_out(rs2_reg_out),
       .pc_reg_out(pc_reg_out),
       .pc_plus_4_reg_out(pc_plus_4_reg_out),
       .i_adder_reg_out(i_adder_reg_out),
       .imm_reg_out(imm_reg_out),
       .alu_opcode_reg_out(alu_opcode_reg_out),
       .load_size_ireg_out(load_size_ireg_out),
       .wb_mux_sel_reg_out(wb_mux_sel_reg_out),
       .csr_op_reg_out(csr_op_reg_out) 
   );
   
   riscv32_store_unit SU (
       .mem_wr_req_in(mem_wr_req_out),
       .ahb_ready_in(ms_riscv32_mp_data_hready_in),
       .func3_1_to_0_in(func3_out[1:0]),
       .i_addr_in(i_adder_out),
       .rs2_in(rs2_out),
       .ms_riscv32_mp_dmwr_req_out(ms_riscv32_mp_dmwr_req_out),
       .ms_riscv32_mp_dmdata_out(ms_riscv32_mp_dmdata_out),
       .ms_riscv32_mp_dmaddr_out(ms_riscv32_mp_dmaddr_out),
       .ms_riscv32_mp_dmwr_mask_out(ms_riscv32_mp_dmwr_mask_out),
       .ahb_htrans_out(ms_riscv32_mp_data_htrans_out)
   );
   
   riscv32_load_unit LU (
       // Inputs :
       .ahb_resp_in(ms_riscv32_mp_hresp_in),
       .load_unsigned_in(load_unsigned_ireg_out),
       .ms_riscv32_mp_dmdata_in(ms_riscv32_mp_dmdata_in),
       .i_addr_out_1_to_0_in(i_adder_reg_out[1:0]),
       .load_size_in(load_size_ireg_out),
       // Outputs :
       .lu_output_out(lu_output_out)
   );
   
   risc32_alu ALU (
       // Inputs :
       .op_1_in(rs1_reg_out), // possible error
       .op_2_in(alu_2nd_src_mux_out),
       .opcode_in(alu_opcode_reg_out),
       // Outputs :
       .result_out(result_out)
   );
   
   riscv32_wb_mux_sel_unit WBMUX (
       // Inputs :
       .alu_src_reg_in(alu_src_reg_out),
       .wb_mux_sel_reg_in(wb_mux_sel_reg_out),
       .alu_result_in(result_out),
       .lu_output_in(lu_output_out),
       .imm_reg_in(imm_reg_out),
       .i_adder_out_reg_in(i_adder_reg_out),
       .csr_data_in(csr_data_out),
       .pc_plus_4_reg_in(pc_plus_4_reg_out),
       .rs2_reg_in(rs2_reg_out),
       // Outputs :
       .wb_mux_out(wb_mux_out),
       .alu_2nd_src_mux_out(alu_2nd_src_mux_out)
   );
        
endmodule 