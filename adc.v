module xadc_top (
    input wire clk,         
    input wire vauxp0,      
    input wire vauxn0,      

    output wire [11:0] adc_data,  
    output wire adc_ready
);

wire [15:0] do_out;
wire drdy_out;


xadc_wiz_0 xadc_inst (
    .dclk_in(clk),

    .daddr_in(7'h10),  
    .den_in(1'b1),
    .dwe_in(1'b0),

    .do_out(do_out),
    .drdy_out(drdy_out),

    .vauxp0(vauxp0),
    .vauxn0(vauxn0),

    .vp_in(1'b0),
    .vn_in(1'b0)
);


assign adc_data  = do_out[15:4];
assign adc_ready = drdy_out;


ila_0 ila_inst (
    .clk(clk),
    .probe0(adc_data),
    .probe1(adc_ready)
);
endmodule
