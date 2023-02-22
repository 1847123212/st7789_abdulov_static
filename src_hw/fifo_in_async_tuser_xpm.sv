`timescale 1ns / 1ps


module fifo_in_async_tuser_xpm #(
    parameter integer CDC_SYNC   = 4      ,
    parameter integer DATA_WIDTH = 16     ,
    parameter integer USER_WIDTH = 1      ,
    parameter string  MEMTYPE    = "block",
    parameter integer DEPTH      = 16
) (
    input  logic                      S_AXIS_CLK   ,
    input  logic                      S_AXIS_RESET ,
    input  logic                      M_AXIS_CLK   ,
    // input interface
    input  logic [  (DATA_WIDTH-1):0] S_AXIS_TDATA ,
    input  logic [(DATA_WIDTH/8)-1:0] S_AXIS_TKEEP ,
    input  logic                      S_AXIS_TLAST ,
    input  logic [    USER_WIDTH-1:0] S_AXIS_TUSER ,
    input  logic                      S_AXIS_TVALID,
    output logic                      S_AXIS_TREADY,
    // internal fifo interface
    output logic [  (DATA_WIDTH-1):0] IN_DOUT_DATA ,
    output logic [(DATA_WIDTH/8)-1:0] IN_DOUT_KEEP ,
    output logic [    USER_WIDTH-1:0] IN_DOUT_USER ,
    output logic                      IN_DOUT_LAST ,
    input  logic                      IN_RDEN      ,
    output logic                      IN_EMPTY
);


    parameter integer FIFO_DATA_COUNT_WIDTH = ($clog2(DEPTH));
    parameter integer FIFO_WIDTH = DATA_WIDTH + (DATA_WIDTH/8) + USER_WIDTH + 1;

    logic                  full;
    logic                  wren;

    always_comb begin 
        S_AXIS_TREADY = ~full ;
    end 

    always_comb begin 
        if (~full & S_AXIS_TVALID) begin 
            wren = 1'b1;
        end else begin 
            wren = 1'b0;
        end 
    end 

    xpm_fifo_async #(
        .CDC_SYNC_STAGES    (CDC_SYNC             ), // DECIMAL
        .DOUT_RESET_VALUE   ("0"                  ), // String
        .ECC_MODE           ("no_ecc"             ), // String
        .FIFO_MEMORY_TYPE   (MEMTYPE              ), // String
        .FIFO_READ_LATENCY  (0                    ), // DECIMAL
        .FIFO_WRITE_DEPTH   (DEPTH                ), // DECIMAL
        .FULL_RESET_VALUE   (1                    ), // DECIMAL
        .PROG_EMPTY_THRESH  (10                   ), // DECIMAL
        .PROG_FULL_THRESH   (10                   ), // DECIMAL
        .RD_DATA_COUNT_WIDTH(FIFO_DATA_COUNT_WIDTH), // DECIMAL
        .READ_DATA_WIDTH    (FIFO_WIDTH           ), // DECIMAL
        .READ_MODE          ("fwft"               ), // String
        .RELATED_CLOCKS     (0                    ), // DECIMAL
        .SIM_ASSERT_CHK     (0                    ), // DECIMAL; 0=disable simulation messages, 1=enable simulation messages
        .USE_ADV_FEATURES   ("0000"               ), // String
        .WAKEUP_TIME        (0                    ), // DECIMAL
        .WRITE_DATA_WIDTH   (FIFO_WIDTH           ), // DECIMAL
        .WR_DATA_COUNT_WIDTH(FIFO_DATA_COUNT_WIDTH)  // DECIMAL
    ) xpm_fifo_async_inst (
        .almost_empty (                                                        ), // 1-bit output: Almost Empty : When asserted, this signal indicates that
        .almost_full  (                                                        ), // 1-bit output: Almost Full: When asserted, this signal indicates that
        .data_valid   (                                                        ), // 1-bit output: Read Data Valid: When asserted, this signal indicates
        .dbiterr      (                                                        ), // 1-bit output: Double Bit Error: Indicates that the ECC decoder detected
        .dout         ({IN_DOUT_LAST, IN_DOUT_USER, IN_DOUT_KEEP, IN_DOUT_DATA}), // READ_DATA_WIDTH-bit output: Read Data: The output data bus is driven
        .empty        (IN_EMPTY                                                ), // 1-bit output: Empty Flag: When asserted, this signal indicates that the
        .full         (full                                                    ), // 1-bit output: Full Flag: When asserted, this signal indicates that the
        .overflow     (                                                        ), // 1-bit output: Overflow: This signal indicates that a write request
        .prog_empty   (                                                        ), // 1-bit output: Programmable Empty: This signal is asserted when the
        .prog_full    (                                                        ), // 1-bit output: Programmable Full: This signal is asserted when the
        .rd_data_count(                                                        ), // RD_DATA_COUNT_WIDTH-bit output: Read Data Count: This bus indicates the
        .rd_rst_busy  (                                                        ), // 1-bit output: Read Reset Busy: Active-High indicator that the FIFO read
        .sbiterr      (                                                        ), // 1-bit output: Single Bit Error: Indicates that the ECC decoder detected
        .underflow    (                                                        ), // 1-bit output: Underflow: Indicates that the read request (rd_en) during
        .wr_ack       (                                                        ), // 1-bit output: Write Acknowledge: This signal indicates that a write
        .wr_data_count(                                                        ), // WR_DATA_COUNT_WIDTH-bit output: Write Data Count: This bus indicates
        .wr_rst_busy  (                                                        ), // 1-bit output: Write Reset Busy: Active-High indicator that the FIFO
        .din          ({S_AXIS_TLAST, S_AXIS_TUSER, S_AXIS_TKEEP, S_AXIS_TDATA} ), // WRITE_DATA_WIDTH-bit input: Write Data: The input data bus used when
        .injectdbiterr(1'b0                                                    ), // 1-bit input: Double Bit Error Injection: Injects a double bit error if
        .injectsbiterr(1'b0                                                    ), // 1-bit input: Single Bit Error Injection: Injects a single bit error if
        .rd_clk       (M_AXIS_CLK                                              ), // 1-bit input: Read clock: Used for read operation. rd_clk must be a free
        .rd_en        (IN_RDEN                                                 ), // 1-bit input: Read Enable: If the FIFO is not empty, asserting this
        .rst          (S_AXIS_RESET                                            ), // 1-bit input: Reset: Must be synchronous to wr_clk. The clock(s) can be
        .sleep        (1'b0                                                    ), // 1-bit input: Dynamic power saving: If sleep is High, the memory/fifo
        .wr_clk       (S_AXIS_CLK                                              ), // 1-bit input: Write clock: Used for write operation. wr_clk must be a
        .wr_en        (wren                                                    )  // 1-bit input: Write Enable: If the FIFO is not full, asserting this
    );



endmodule
