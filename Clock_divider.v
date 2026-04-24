`timescale 1ns / 1ps

module Clock_divider_module(
input clk_100MHz,
input reset,
output reg clk_100KHz,
output reg clk_10KHz,
output reg clk_2MHz
    );
    
 
  reg[8:0] count=0;
  reg[12:0] counter=0;
  reg[5:0] count_another=0;
  always@(posedge clk_100MHz or posedge reset) 
  begin
  if(reset)  
  begin 
  clk_100KHz<=0;
  count<=0;
  end
  else begin
  count <= count +1 ;
  if(count==499) begin 
  clk_100KHz<= ~ clk_100KHz;
  count<= 0;
  end
   end
   end
  always @(posedge clk_100MHz or posedge reset) 
begin
    if(reset)  
    begin 
        clk_2MHz <= 0;
        count_another <= 0;
    end
    else 
    begin
        count_another <= count_another + 1;
        if(count_another == 24) 
        begin 
            clk_2MHz <= ~clk_2MHz;
            count_another <= 0;
        end
    end
end
    always@(posedge clk_100MHz or posedge reset) 
  begin
  if(reset)  
  begin 
  clk_10KHz<=0;
  counter<=0;
  end
  else begin 
  counter <= counter +1 ;
  if(counter==4999) begin 
  clk_10KHz<= ~ clk_10KHz;
  counter<= 0;
  end
   end
   end
endmodule