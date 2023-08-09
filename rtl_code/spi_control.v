`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.08.2023 19:27:43
// Design Name: 
// Module Name: spi_controller
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


module spi_controller(
    input clk, rst,
    input [7:0] data_in,

    output spi_clk,
    output reg spi_data,

    input load_data, 
    output reg data_sent
    );

    /***********Generate Slow clk for spi_clk (10MHz max)*************
     *************Counter value = 0.5 * (100M/10M) = 5 ***************/

    reg [2:0] count = 3'b000;
    reg clk_10mhz;
    reg clk_en;
    parameter COUNT_MAX = 5;

    assign spi_clk = (clk_en == 1) ? clk_10mhz : 1'b1;
    
    always @(posedge clk or posedge rst) begin

        if(rst) begin count <= 3'b000; clk_10mhz <= 1'b0; end

        else if(count == COUNT_MAX-1) begin count <= 0; clk_10mhz <= ~clk_10mhz; end

        else count <= count + 1;    
    end


    /***********State Machine for generating spi_data*************/

    reg [7:0] shift_reg;
    reg [2:0] data_count;
    
    //(*KEEP = "true"*)  // During debugging don't change the name of variable "state"
    reg [1:0] state;
    
    localparam IDLE = 1,
               SEND = 2,
               DONE = 3;
               
    always @(negedge clk_10mhz) begin
        if (rst) begin
            clk_en <= 1'b0;
            state <= IDLE;
            data_count <= 0;
            data_sent <= 1'b0;
        end
        else begin
            case(state)
            
                IDLE: begin
                    if(load_data) begin
                        shift_reg <= data_in;
                        data_count <= 0;
                        state <= SEND;
                    end
                end 
                   
                SEND: begin
                    clk_en <= 1'b1;
                    spi_data <= shift_reg[7];
                    shift_reg <= {shift_reg[6:0], 1'b0};
                    
                    if(data_count != 7) data_count <= data_count + 1;
                    else state <= DONE;
                end
                
                DONE: begin
                    clk_en <= 1'b0;
                    data_sent <= 1'b1;
                    if(!load_data) begin
                        data_sent <= 1'b0;
                        state <= IDLE;
                    end
                end
            endcase
        end
    end
endmodule

