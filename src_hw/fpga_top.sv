`timescale 1ns / 1ps



module fpga_top (
    input  logic MAIN_CLK,
    output logic LCD_BLK ,
    output logic LCD_RST ,
    output logic LCD_DC  ,
    output logic LCD_SDA ,
    output logic LCD_SCK
);




    logic        clk_100       ;
    logic        clk_50        ;
    logic [31:0] await_interval;

    clk_wiz_100 clk_wiz_100_inst (
        .clk_out1(clk_100 ), // output clk_out1
        .clk_out2(clk_50  ), // output clk_out2
        .clk_in1 (MAIN_CLK)
    );

    logic reset        ;
    logic enable_output;



    vio_control vio_control_inst (
        .clk       (clk_100       ), // input wire clk
        .probe_out0(reset         ), // output wire [0 : 0] probe_out0
        .probe_out1(enable_output ), // output wire [0 : 0] probe_out1
        .probe_out2(await_interval)
    );



    abdulo_st7789 #(
        .BIT_ADDR_LIMIT  (240       ),
        .LINE_ADDR_LIMIT (240       ),
        .BACKGROUND_COLOR(24'h000000),
        .FONT_COLOR      (24'hFFFFFF)
    ) abdulo_st7789_inst (
        .CLK           (clk_100       ),
        .RESET         (reset         ),
        .ENABLE_OUTPUT (enable_output ),
        .AWAIT_INTERVAL(await_interval),
        .SCLK          (clk_50        ), // slowly clk
        .LCD_BLK       (LCD_BLK       ),
        .LCD_RST       (LCD_RST       ),
        .LCD_DC        (LCD_DC        ),
        .LCD_SDA       (LCD_SDA       ),
        .LCD_SCK       (LCD_SCK       )
    );



    endmodule
