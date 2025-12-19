`timescale 1ns / 1ps

module joystick_led(
    input clk,
    input rst,
    input vaux0_p,
    //input vaux0_n,
    input vaux1_p,
    //input vaux1_n,
    output [15:0] led
    );

    wire signed [10:0] speed, turn;

    JSTK_control jstk (
        .clk(clk),
        .rst(rst),
        .vaux0_p(vaux0_p),
        .vaux1_p(vaux1_p),
        .speed(speed),
        .turn(turn)
    );

    reg [15:0] led_r;
    assign led = led_r;

    integer i;

    always @(*) begin
        
        led_r = 16'd0;

        // speed 對應 LED[7:0]
        for(i=0; i<8; i=i+1) begin
            if(speed > 0 && i < (speed >>> 7)) led_r[i] = 1'b1;
            else if(speed < 0 && i < (-speed >>> 7)) led_r[i] = 1'b1;
        end

        // turn 對應 LED[15:8]
        for(i=0; i<8; i=i+1) begin
            if(turn > 0 && i < (turn >>> 7)) led_r[i+8] = 1'b1;
            else if(turn < 0 && i < (-turn >>> 7)) led_r[i+8] = 1'b1;
        end
    end

endmodule
