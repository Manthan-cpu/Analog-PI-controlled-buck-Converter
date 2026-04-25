`timescale 1ns / 1ps

module pi_controller#(
parameter signed [15:0] Kp = 16'd5,  
parameter signed [15:0] Ki = 16'd1,
parameter SCALE = 10,
parameter [9:0] duty_min = 10'd51,
parameter [9:0] duty_max = 10'd920
)(   
    input reset, 
    input clk_10KHz,                 
    input signed [12:0] error, 
    output reg signed [9:0] duty,
    output reg signed [31:0] u
);
    
    reg signed [12:0] error_prev;
    reg signed [31:0] u_prev;
    
    reg signed [31:0] u_temp;

    wire signed [31:0] p_term;
    wire signed [31:0] i_term;

    assign p_term = Kp * (error - error_prev);
    assign i_term = Ki * error;
    
    always @(posedge clk_10KHz or posedge reset) begin
        if (reset) begin
            error_prev <= 0;
            u_prev <= 0;
            u <= 0;
            duty <= 0;
        end
        else begin
            
        
            u_temp <= u_prev 
                   + (p_term >>> SCALE) 
                   + (i_term >>> SCALE);

          
            if (u_temp > (duty_max <<< SCALE))
                u <= (duty_max <<< SCALE);
            else if (u_temp < (duty_min <<< SCALE))
                u <= (duty_min <<< SCALE);
            else
                u <= u_temp;

           
            duty <= u >>> SCALE;

            
            error_prev <= error;
            u_prev <= u;
        end
    end

endmodule
