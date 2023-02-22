`timescale 1ns / 1ps



module abdulo_st7789 #(
    parameter integer        BIT_ADDR_LIMIT   = 240       ,
    parameter integer        LINE_ADDR_LIMIT  = 240       ,
    parameter         [23:0] BACKGROUND_COLOR = 24'h000000,
    parameter         [23:0] FONT_COLOR       = 24'hFFFFFF
)(
    input  logic       CLK          ,
    input  logic       RESET        ,
    input logic [31:0] AWAIT_INTERVAL,
    input  logic       ENABLE_OUTPUT,
    input  logic       SCLK         , // slowly clk
    output logic       LCD_BLK      ,
    output logic       LCD_RST      ,
    output logic       LCD_DC       ,
    output logic       LCD_SDA      ,
    output logic       LCD_SCK
);

    logic [7:0] tdata ;
    logic       tkeep ;
    logic       tuser ;
    logic       tvalid;
    logic       tlast ;
    logic       tready;

    abdulomgr #(
        .BIT_ADDR_LIMIT  (BIT_ADDR_LIMIT  ),
        .LINE_ADDR_LIMIT (LINE_ADDR_LIMIT ),
        .BACKGROUND_COLOR(BACKGROUND_COLOR),
        .FONT_COLOR      (FONT_COLOR      )
    ) abdulomgr_inst (
        .CLK          (CLK          ),
        .RESET        (RESET        ),
        .ENABLE_OUTPUT(ENABLE_OUTPUT),
        .M_AXIS_TDATA (tdata        ),
        .M_AXIS_TKEEP (tkeep        ),
        .M_AXIS_TUSER (tuser        ),
        .M_AXIS_TVALID(tvalid       ),
        .M_AXIS_TLAST (tlast        ),
        .M_AXIS_TREADY(tready       )
    );

    st7789_driver st7789_driver_inst (
        .CLK          (CLK    ),
        .RESET        (RESET  ),
        .SCLK         (SCLK   ), // slowly clk
        .S_AXIS_TDATA (tdata  ),
        .S_AXIS_TKEEP (tkeep  ),
        .S_AXIS_TUSER (tuser  ),
        .S_AXIS_TVALID(tvalid ),
        .S_AXIS_TLAST (tlast  ),
        .S_AXIS_TREADY(tready ),
        .LCD_BLK      (LCD_BLK),
        .LCD_RST      (LCD_RST),
        .LCD_DC       (LCD_DC ),
        .LCD_SDA      (LCD_SDA),
        .LCD_SCK      (LCD_SCK)
    );





endmodule
