`timescale 1ns / 1ps

module riscv32_mp_topmost(
    // Inputs :
    input ms_riscv32_mp_clk_in,
    input ms_riscv32_mp_rst_in,
    output dout_out
    );
    
    // Output wires :
    wire ms_riscv32_mp_dmwr_req_out;
    wire [1:0] ms_riscv32_mp_data_htrans_out;   
    
    // Internal wire declaration :
    wire [31:0] ms_riscv32_mp_dmdata_in;
    wire [31:0] ms_riscv32_mp_instr_in;
    
    wire [31:0] ms_riscv32_mp_dmaddr_out;
    wire [3:0] ms_riscv32_mp_dmwr_mask_out;
    wire [31:0] ms_riscv32_mp_dmdata_out;
    wire [31:0] ms_riscv32_mp_imaddr_out;
    
    // Wire declaration for UART :
    wire [7:0] din;
    wire vin;
    wire dout;
    //wire uart_write;
    
    wire ms_riscv32_mp_eirq_in = 1'b0;
    wire ms_riscv32_mp_tirq_in = 1'b0;
    wire ms_riscv32_mp_sirq_in = 1'b0;
          
    wire [63:0] ms_riscv32_mp_rc_in = 64'b0;
    wire ms_riscv32_mp_hresp_in = 1'b0;
    wire ms_riscv32_mp_instr_hready_in = 1'b1;
    wire ms_riscv32_mp_data_hready_in = 1'b1;
    
    assign dout_out = dout;
    
    // UART assignments :
    assign din = ms_riscv32_mp_dmdata_out[7:0];
    //assign vin = uart_write;
    assign vin = (ms_riscv32_mp_dmaddr_out == 32'h000001f0);
 

    riscv32_mp_top_module CORE(
        .ms_riscv32_mp_clk_in(ms_riscv32_mp_clk_in),
        .ms_riscv32_mp_rst_in(ms_riscv32_mp_rst_in),
        .ms_riscv32_mp_instr_hready_in(ms_riscv32_mp_instr_hready_in),
        .ms_riscv32_mp_hresp_in(ms_riscv32_mp_hresp_in),        
        .ms_riscv32_mp_data_hready_in(ms_riscv32_mp_data_hready_in),
        .ms_riscv32_mp_eirq_in(ms_riscv32_mp_eirq_in),
        .ms_riscv32_mp_tirq_in(ms_riscv32_mp_tirq_in),
        .ms_riscv32_mp_sirq_in(ms_riscv32_mp_sirq_in),
              
        .ms_riscv32_mp_dmdata_in(ms_riscv32_mp_dmdata_in),
        .ms_riscv32_mp_instr_in(ms_riscv32_mp_instr_in),
        .ms_riscv32_mp_rc_in(ms_riscv32_mp_rc_in),
              
        // Outputs :
        .ms_riscv32_mp_dmwr_req_out(ms_riscv32_mp_dmwr_req_out),
        .ms_riscv32_mp_dmdata_out(ms_riscv32_mp_dmdata_out),
        .ms_riscv32_mp_dmaddr_out(ms_riscv32_mp_dmaddr_out),
        .ms_riscv32_mp_imaddr_out(ms_riscv32_mp_imaddr_out),
        .ms_riscv32_mp_dmwr_mask_out(ms_riscv32_mp_dmwr_mask_out),
        .ms_riscv32_mp_data_htrans_out(ms_riscv32_mp_data_htrans_out)
    
    );
   
    D_cache DM (
        // Inputs :
        .clk(ms_riscv32_mp_clk_in),
        .reset(ms_riscv32_mp_rst_in),
        .addr(ms_riscv32_mp_dmaddr_out),
        .wen(ms_riscv32_mp_dmwr_mask_out),
        .wdata(ms_riscv32_mp_dmdata_out),
        // Outputs :
        .rdata(ms_riscv32_mp_dmdata_in)
    );
   
    I_cache IM (
        // Inputs :
        .clk(ms_riscv32_mp_clk_in),
        .reset(ms_riscv32_mp_rst_in),
        .addr(ms_riscv32_mp_imaddr_out),
        // Outputs :
        .rdata(ms_riscv32_mp_instr_in)
    );
    
    uart UART (
        // Inputs :
        .clk_100MHz(ms_riscv32_mp_clk_in), 
        .reset(ms_riscv32_mp_rst_in),
        .din(din),
        .vdin(vin),
        
        // Outputs :
        .dout(dout)
    );
        
endmodule  
