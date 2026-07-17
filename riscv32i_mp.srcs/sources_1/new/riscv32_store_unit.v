`timescale 1ns / 1ps

module riscv32_store_unit(
    // Inputs :
    input mem_wr_req_in,
    input ahb_ready_in,
    input [1:0] func3_1_to_0_in,
    input [31:0] i_addr_in,
    input [31:0] rs2_in,
                 
    // Outputs :
    output reg ms_riscv32_mp_dmwr_req_out,
    output reg [31:0] ms_riscv32_mp_dmdata_out,
    output reg [31:0] ms_riscv32_mp_dmaddr_out,
    output reg [3:0] ms_riscv32_mp_dmwr_mask_out,
    output reg [1:0] ahb_htrans_out,
    output reg uart_write
    );
    
    always@(*) begin
        // Default assignment:
        uart_write = 1'b0;
        ms_riscv32_mp_dmaddr_out = {i_addr_in[31:2], 2'b00};
        ms_riscv32_mp_dmwr_req_out = ahb_ready_in ? mem_wr_req_in : 1'b0;
        ahb_htrans_out = mem_wr_req_in ? 2'b10 : 2'b00; 
        ms_riscv32_mp_dmdata_out = 32'b0; 
        ms_riscv32_mp_dmwr_mask_out = 4'b0;
        
        if (mem_wr_req_in && i_addr_in == 32'h000001f0) begin
            uart_write = 1'b1;
            ms_riscv32_mp_dmwr_mask_out = 4'b0001;  // Byte write
        end
        if(ahb_ready_in) begin
        // Generate data and mask based on store type
            case (func3_1_to_0_in)
                2'b00: begin // byte : 
                    case (i_addr_in[1:0])
                        2'b00: begin
                            ms_riscv32_mp_dmdata_out = {24'b0, rs2_in[7:0]};
                            ms_riscv32_mp_dmwr_mask_out = {3'b0, mem_wr_req_in};
                        end
                        2'b01: begin
                            ms_riscv32_mp_dmdata_out = {16'b0, rs2_in[7:0], 8'b0};
                            ms_riscv32_mp_dmwr_mask_out = {2'b0, mem_wr_req_in, 1'b0};
                        end
                        2'b10: begin
                            ms_riscv32_mp_dmdata_out = {8'b0, rs2_in[7:0], 16'b0};
                            ms_riscv32_mp_dmwr_mask_out = {1'b0, mem_wr_req_in, 2'b0};
                        end
                        2'b11: begin
                            ms_riscv32_mp_dmdata_out = {rs2_in[7:0], 24'b0};
                            ms_riscv32_mp_dmwr_mask_out = {mem_wr_req_in, 3'b0};
                        end
                    endcase
                end
                
                2'b01: begin // HW
                    case (i_addr_in[1])
                        1'b0: begin 
                            ms_riscv32_mp_dmdata_out = {16'b0, rs2_in[15:0]};
                            ms_riscv32_mp_dmwr_mask_out = {2'b0, {2{mem_wr_req_in}}};
                        end
                        1'b1: begin 
                            ms_riscv32_mp_dmdata_out = {rs2_in[15:0], 16'b0};
                            ms_riscv32_mp_dmwr_mask_out = {{2{mem_wr_req_in}}, 2'b0};
                        end
                    endcase
                end
                
                2'b10 : begin
                        ms_riscv32_mp_dmdata_out = rs2_in;
                        ms_riscv32_mp_dmwr_mask_out = {4{mem_wr_req_in}};               
                end
                
                2'b11 : begin
                        ms_riscv32_mp_dmdata_out = rs2_in;
                        ms_riscv32_mp_dmwr_mask_out = {4{mem_wr_req_in}};               
                end
                
                default: begin // Word
                    ms_riscv32_mp_dmdata_out = rs2_in;
                    ms_riscv32_mp_dmwr_mask_out = {4{mem_wr_req_in}};
                end
            endcase 
        end
    end
endmodule


