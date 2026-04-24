`timescale 1ns / 1ps

module system_top (
    input  wire clk_100MHz,    // Main 100MHz board clock
    input  wire reset,         // System reset (Active High)
    input  wire vauxp0,        // XADC analog input positive
    input  wire vauxn0,        // XADC analog input negative
    output wire [9:0] duty,    // Duty cycle output from PI Controller (for probing)
    output wire pwm_out,       // Final PWM generated signal
    output wire adc_ready      // ADC ready flag
);

    // ==========================================
    // Internal Wires for Interconnects
    // ==========================================
    wire clk_100KHz;
    wire clk_10KHz;
    wire clk_2MHz;

    wire [11:0] adc_data;
    
    wire signed [12:0] error;
    wire signed [31:0] u;

    // ==========================================
    // Setpoint & Error Calculation
    // ==========================================
    localparam [11:0] SETPOINT = 12'd2048;

    // Calculate Error = Setpoint - Measured Data
    assign error = $signed({1'b0, SETPOINT}) - $signed({1'b0, adc_data});


    // ==========================================
    // Module Instantiations
    // ==========================================

    // 1. Clock Divider
    Clock_divider_module clk_div_inst (
        .clk_100MHz (clk_100MHz),
        .reset      (reset),
        .clk_100KHz (clk_100KHz),
        .clk_10KHz  (clk_10KHz),
        .clk_2MHz   (clk_2MHz)
    );

    // 2. XADC Top Module
    xadc_top xadc_wrapper_inst (
        .clk       (clk_100MHz),
        .vauxp0    (vauxp0),
        .vauxn0    (vauxn0),
        .adc_data  (adc_data),
        .adc_ready (adc_ready)
    );

    // 3. PI Controller
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

    // 4. PWM Generator
    // Note: Driven by 100MHz clock. For a 10-bit PWM (1024 steps), 
    // the PWM switching frequency will be 100MHz / 1024 = ~97.6 kHz.
    pwm_generator pwm_inst (
        .clk        (clk_100MHz),
        .reset      (reset),
        .duty_cycle (duty),        // Driven by PI controller output
        .pwm_out    (pwm_out)
    );

    // ==========================================
    // 5. Integrated Logic Analyzer (ILA)
    // ==========================================
    ila_0 ila_inst (
        .clk    (clk_100MHz),       // Sample using main 100MHz clock
        .probe0 (adc_data),         // 12-bit probe
        .probe1 (adc_ready),        // 1-bit probe
        .probe2 (duty),             // 10-bit probe
        .probe3 (pwm_out),          // 1-bit probe
        .probe4 (error)             // 13-bit probe (Make sure to update IP to 13 bits!)
    );

endmodule