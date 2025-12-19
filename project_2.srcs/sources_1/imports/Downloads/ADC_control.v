`timescale 1ns / 1ps

module ADC_control(
    input clk,
    input rst,
    input vaux0_p,
    input vaux1_p,
    output [9:0] adc_x,
    output [9:0] adc_y
    );

    // XADC interface
    reg  [6:0] daddr;
    reg        den;
    wire [15:0] do_out;
    wire        drdy;

    reg [9:0] adc_x_r, adc_y_r;
    assign adc_x = adc_x_r;
    assign adc_y = adc_y_r;

    // VAUX channel addresses
    localparam CH_X = 7'h10; // VAUX0
    localparam CH_Y = 7'h11; // VAUX1

    // XADC primitive (Artix-7)
    XADC #(
        .INIT_40(16'h3000), // averaging
        .INIT_41(16'h21AF), // continuous sampling
        .INIT_42(16'h0400)
    ) XADC_inst (
        .DCLK(clk),
        .RESET(rst),
        .DEN(den),
        .DADDR(daddr),
        .DI(16'd0),
        .DWE(1'b0),
        .DO(do_out),
        .DRDY(drdy),

        .CONVST(1'b0),
        .CONVSTCLK(1'b0),

        .BUSY(),
        .CHANNEL(),
        .EOC(),
        .EOS(),
        .MUXADDR(),
        .ALM(),
        .OT(),
        .JTAGBUSY(),
        .JTAGLOCKED(),
        .JTAGMODIFIED(),

        // analog inputs
        .VP(1'b0),
        .VN(1'b0),
        .VAUXP({14'b0,vaux1_p,vaux0_p}),
        .VAUXN(16'b0)
    );

    always @(posedge clk or posedge rst) begin
        if(rst) begin
            daddr<=CH_X;
            den<=1'b0;
            adc_x_r<=10'd0;
            adc_y_r<=10'd0;
        end
        else begin
            den<=1'b1;
            if(drdy) begin
                if(daddr==CH_X) begin
                    adc_x_r<=do_out[15:6];
                    daddr<=CH_Y;
                end
                else begin
                    adc_y_r<=do_out[15:6];
                    daddr<=CH_X;
                end
            end
        end
    end


endmodule
