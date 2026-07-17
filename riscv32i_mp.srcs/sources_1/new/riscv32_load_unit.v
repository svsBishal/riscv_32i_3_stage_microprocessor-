`timescale 1ns / 1ps

module riscv32_load_unit(
    // Inputs :
    input  ahb_resp_in,
    input  load_unsigned_in,       
    input  [31:0] ms_riscv32_mp_dmdata_in,
    //input  [31:0] dm_data_in,
    input  [1:0]  i_addr_out_1_to_0_in,
    input  [1:0]  load_size_in,
    // Outputs :
    output reg [31:0] lu_output_out  
);
//    wire [31:0] ms_riscv32_mp_dmdata_in; 
//    assign ms_riscv32_mp_dmdata_in = dm_data_in;
    
    always @(*) begin
        // Default assignment
        
        lu_output_out = ms_riscv32_mp_dmdata_in;
        
        // NOTE : ahb_resp_in is a active low signal !!!!
        if (!ahb_resp_in) begin
            case (load_size_in)
                2'b00 : begin // Byte Load
                    case (i_addr_out_1_to_0_in)
                        2'b00 : lu_output_out = load_unsigned_in ?
                                {24'b0, ms_riscv32_mp_dmdata_in[7:0]} : 
                                {{24{ms_riscv32_mp_dmdata_in[7]}}, ms_riscv32_mp_dmdata_in[7:0]};
                        2'b01 : lu_output_out = load_unsigned_in ?
                                {24'b0, ms_riscv32_mp_dmdata_in[15:8]} : 
                                {{24{ms_riscv32_mp_dmdata_in[15]}}, ms_riscv32_mp_dmdata_in[15:8]};
                        2'b10 : lu_output_out = load_unsigned_in ?
                                {24'b0, ms_riscv32_mp_dmdata_in[23:16]} : 
                                {{24{ms_riscv32_mp_dmdata_in[23]}}, ms_riscv32_mp_dmdata_in[23:16]};
                        2'b11 : lu_output_out = load_unsigned_in ?
                                {24'b0, ms_riscv32_mp_dmdata_in[31:24]} : 
                                {{24{ms_riscv32_mp_dmdata_in[31]}}, ms_riscv32_mp_dmdata_in[31:24]};
                    endcase
                end
                2'b01 : begin // Half-Word Load
                    case (i_addr_out_1_to_0_in[1])
                        1'b0 : lu_output_out = load_unsigned_in ? 
                                {16'b0, ms_riscv32_mp_dmdata_in[15:0]} : 
                                {{16{ms_riscv32_mp_dmdata_in[15]}}, ms_riscv32_mp_dmdata_in[15:0]};
                        1'b1 : lu_output_out = load_unsigned_in ? 
                                {16'b0, ms_riscv32_mp_dmdata_in[31:16]} : 
                                {{16{ms_riscv32_mp_dmdata_in[31]}}, ms_riscv32_mp_dmdata_in[31:16]};
                    endcase
                end
                2'b10 : begin
                    lu_output_out = ms_riscv32_mp_dmdata_in;
                end 
                2'b11 : begin
                    lu_output_out = ms_riscv32_mp_dmdata_in;
                end 
            endcase
        end
    end
endmodule