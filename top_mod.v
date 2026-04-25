`timescale 1ns / 1ps

module system_top (
    input  wire clk_100MHz,    
    input  wire reset,         
    input  wire vauxp0,        
    input  wire vauxn0,       
    output wire [9:0] duty,    
    output wire pwm_out,     
    output wire adc_ready      
);

   
    wire clk_100KHz;
    wire clk_10KHz;
    wire clk_2MHz;

    wire [11:0] adc_data;
    
    wire signed [12:0] error;
    wire signed [31:0] u;

    
    localparam [11:0] SETPOINT = 12'd2048;

   
    assign error = $signed({1'b0, SETPOINT}) - $signed({1'b0, adc_data});


  


    Clock_divider_module clk_div_inst (
        .clk_100MHz (clk_100MHz),
        .reset      (reset),
        .clk_100KHz (clk_100KHz),
        .clk_10KHz  (clk_10KHz),
        .clk_2MHz   (clk_2MHz)
    );


    xadc_top xadc_wrapper_inst (
        .clk       (clk_100MHz),
        .vauxp0    (vauxp0),
        .vauxn0    (vauxn0),
        .adc_data  (adc_data),
        .adc_ready (adc_ready)
    );

    pi_controller #(
        .Kp(16'd5),
        .Ki(16'd1),
        .SCALE(10),
        .duty_min(10'd51),
        .duty_max(10'd920)
    ) pi_ctrl_inst (
        .reset     (reset),
        .clk_10KHz (clk_10KHz),    
        .error     (error),        
        .duty      (duty),         
        .u         (u)             
    );

   
    pwm_generator pwm_inst (
        .clk        (clk_100MHz),
        .reset      (reset),
        .duty_cycle (duty),       
        .pwm_out    (pwm_out)
    );

 
  
    ila_0 ila_inst (
        .clk    (clk_100MHz),       
        .probe0 (adc_data),         
        .probe1 (adc_ready),        
        .probe2 (duty),             
        .probe3 (pwm_out),        
        .probe4 (error)             
    );

endmodule
