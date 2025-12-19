`timescale 1ns / 1ps

module JSTK_control(
    input clk,
    input rst,
    input vaux0_p,
    input vaux1_p,
    output signed [10:0] speed,
    output signed [10:0] turn
    );

    wire [9:0] x_data,y_data;

    ADC_control adc0 (
        .clk(clk),
        .rst(rst),
        .vaux0_p(vaux0_p),
        .vaux1_p(vaux1_p),
        .adc_x(x_data),
        .adc_y(y_data)
    );

    reg signed [10:0] speed_r,turn_r;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            speed_r <= 0;
            turn_r  <= 0;
        end else begin
            // 中心 512，轉成 signed
            speed_r <= (($signed({1'b0, y_data}) - 11'd512) * 900) >>> 9;
            turn_r  <= (($signed({1'b0, x_data}) - 11'd512) * 200) >>> 9;
        end
    end

    assign speed=speed_r;
    assign turn=turn_r;

endmodule
