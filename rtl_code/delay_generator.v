`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.08.2023 18:15:30
// Design Name: 
// Module Name: delay_generator
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


module delay_generator(
    input clk,
    input dly_en,
    output reg delay_done
    );
    
    reg [17:0] counter; //For 2ms Delay, count val => 2msec = x/100M => x = 200_000  
    
    always @ (posedge clk) begin
        if(dly_en & counter != 200_000) counter <= counter + 1;
        else counter <= 0;
    end
    
    always @ (posedge clk) begin
        if(dly_en & counter == 20) delay_done <= 1'b1;
        else delay_done <= 1'b0;
    end
endmodule
