`timescale 1ns/1ps



module voltage_scaling #(parameter V_ref = 3072)
(
    input clk,
    input reset,
    input [11:0] adc_in,
    output reg signed [12:0] error
);
   //  reg[12:0] error1=0;
always @(posedge clk or posedge reset)
begin
    
    
    if(reset)
        error <= 0;
    else
        error <= V_ref - adc_in;
        
   // error <= error1[12:1];
end

endmodule