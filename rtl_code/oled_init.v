`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.08.2023 18:00:08
// Design Name: 
// Module Name: oled_control
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module oled_control(

    input clk, rst,
    
    output oled_spi_clk,
    output oled_spi_data,
    output reg oled_vdd,
    output reg oled_vbat,
    output reg oled_rst_n,
    output reg oled_dc_n
    );
    
    
    /*********State Machine to initialize the OLED********/
    reg [4:0] state, next_state;
    reg start_dly;
    wire dly_done;
    reg [7:0] spi_data;
    reg spi_load_data;
    wire spi_done;
    
    
    localparam IDLE = 0,
               DELAY = 1,
               INIT = 2,
               RESET = 3,
               CHARG_PUMP = 4,
               WAIT_SPI = 5,
               CHARG_PUMP1 = 6,
               PRE_CHRG = 7,
               PRE_CHRG1 = 8,
               VBAT_ON = 9,
               CONTRAST = 10,
               CONTRAST1 = 11,
               SEG_REMAP = 12,
               SCAN_DIR = 13,
               COM_PIN = 14,
               COM_PIN1 = 15,
               DISPLAY_ON = 16,
               ALL_PIX_ON = 17,
               DONE = 18
     ;
    
    always @(posedge clk) begin
        if(rst) begin
            // Initialize all the reg. with some value!!!
            state <= IDLE;
            next_state <= IDLE;
            oled_vdd <= 1'b1;
            oled_vbat <= 1'b1;
            oled_rst_n <= 1'b1;
            oled_dc_n <= 1'b1;
            start_dly <= 1'b0;
            spi_data <= 8'b0;
            spi_load_data <= 1'b0;
        end
        
        else begin
            case(state) 
                IDLE: begin
                    oled_vdd <= 1'b0; //ON (Active LOW)
                    oled_vbat <= 1'b1; // OFF (Active LOW)
                    oled_rst_n <= 1'b1; //No reset
                    oled_dc_n <= 1'b0; //Send Command
                    state <= DELAY;
                    next_state <= INIT; // After delay it should go to INIT state.
                end
                
                DELAY: begin
                    start_dly <= 1'b1;
                    if (dly_done) begin
                        state <= next_state;
                        start_dly <= 1'b0;
                    end
                end
                
                INIT: begin
                    spi_data <= 'hAE;
                    spi_load_data <= 1'b1;
                    if(spi_done) begin
                        spi_load_data <= 1'b0;
                        oled_rst_n <= 1'b0; //Reset
                        state <= DELAY;
                        next_state <= RESET; //After the DELAY state, go to RESET state
                    end 
                end
                
                RESET: begin
                    oled_rst_n <= 1'b1; //Remove Reset
                    state <= DELAY;
                    next_state <= CHARG_PUMP; //After the DELAY state, go to CHARG_PUMP state
                end
                
                CHARG_PUMP: begin
                    spi_data <= 'h8D;
                    spi_load_data <= 1'b1;
                    if(spi_done) begin
                        spi_load_data <= 1'b0;
                        state <= WAIT_SPI;
                        next_state <= CHARG_PUMP1;
                    end 
                end
                
                WAIT_SPI: begin // As, the state machine is running at 100MHz, but SPI_Controller is running at 10MHz, sometimes the spi_controller may not see the data "spi_load_data <= 1'b0;", So we need some delay here.
                    if (!spi_done) begin // When spi_done becomes low--> means slave has seen the signal "spi_load_data <= 1'b0;" Then only go to next state
                        state <= next_state;
                    end
                end
                
                CHARG_PUMP1: begin
                    spi_data <= 'h14;
                    spi_load_data <= 1'b1;
                    if(spi_done) begin
                        spi_load_data <= 1'b0;
                        state <= WAIT_SPI;
                        next_state <= PRE_CHRG;
                    end 
                end
                
                PRE_CHRG: begin
                    spi_data <= 'hD9;
                    spi_load_data <= 1'b1;
                    if(spi_done) begin
                        spi_load_data <= 1'b0;
                        state <= WAIT_SPI;
                        next_state <= PRE_CHRG1;
                    end 
                end
                
                PRE_CHRG1: begin
                    spi_data <= 'hF1;
                    spi_load_data <= 1'b1;
                    if(spi_done) begin
                        spi_load_data <= 1'b0;
                        state <= WAIT_SPI;
                        next_state <= VBAT_ON;
                    end 
                end
                
                VBAT_ON: begin
                    oled_vbat <= 1'b0; //Active Low 
                    state <= DELAY;
                    next_state <= CONTRAST;
                end
                
                CONTRAST: begin
                    spi_data <= 'h81;
                    spi_load_data <= 1'b1;
                    if(spi_done) begin
                        spi_load_data <= 1'b0;
                        state <= WAIT_SPI;
                        next_state <= CONTRAST1;
                    end 
                end
                
                CONTRAST1: begin
                    spi_data <= 'hFF;
                    spi_load_data <= 1'b1;
                    if(spi_done) begin
                        spi_load_data <= 1'b0;
                        state <= WAIT_SPI;
                        next_state <= SEG_REMAP;
                    end 
                end
                
                SEG_REMAP: begin
                    spi_data <= 'hA0;
                    spi_load_data <= 1'b1;
                    if(spi_done) begin
                        spi_load_data <= 1'b0;
                        state <= WAIT_SPI;
                        next_state <= SCAN_DIR;
                    end 
                end
                
                SCAN_DIR: begin
                    spi_data <= 'hC0;
                    spi_load_data <= 1'b1;
                    if(spi_done) begin
                        spi_load_data <= 1'b0;
                        state <= WAIT_SPI;
                        next_state <= COM_PIN;
                    end 
                end
                
                COM_PIN: begin
                    spi_data <= 'hDA;
                    spi_load_data <= 1'b1;
                    if(spi_done) begin
                        spi_load_data <= 1'b0;
                        state <= WAIT_SPI;
                        next_state <= COM_PIN1;
                    end 
                end
                
                COM_PIN1: begin
                    spi_data <= 'h00;
                    spi_load_data <= 1'b1;
                    if(spi_done) begin
                        spi_load_data <= 1'b0;
                        state <= WAIT_SPI;
                        next_state <= DISPLAY_ON;
                    end 
                end
                
                DISPLAY_ON: begin
                    spi_data <= 'hAF;
                    spi_load_data <= 1'b1;
                    if(spi_done) begin
                        spi_load_data <= 1'b0;
                        state <= WAIT_SPI;
                        next_state <= ALL_PIX_ON;
                    end 
                end
                
                ALL_PIX_ON: begin //To check if initialization is correct or not. Send 0xA5 to glow all the Pixels.
                    spi_data <= 'hA5;
                    spi_load_data <= 1'b1;
                    if(spi_done) begin
                        spi_load_data <= 1'b0;
                        state <= WAIT_SPI;
                        next_state <= DONE;
                    end 
                end
                
                DONE: begin
                    state <= DONE;
                end
            
            
            endcase
        end
    end
    
    
    delay_generator dly_gen(
    .clk(clk),
    .dly_en(start_dly),
    .delay_done(dly_done)
    );
    
    
    spi_controller spi_ctrl(
    .clk(clk), .rst(rst),
    .data_in(spi_data),
    
    .spi_clk(oled_spi_clk),
    .spi_data(oled_spi_data),

    .load_data(spi_load_data), 
    .data_sent(spi_done)
    );
endmodule
