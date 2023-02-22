`timescale 1ns / 1ps


module fifo_out_sync_tuser_xpm #(
    parameter DATA_WIDTH = 8      ,
    parameter USER_WIDTH = 1      ,
    parameter MEMTYPE    = "block",
    parameter DEPTH      = 16
) (
    input  logic                      CLK          ,
    input  logic                      RESET        ,
    input  logic [    DATA_WIDTH-1:0] OUT_DIN_DATA ,
    input  logic [(DATA_WIDTH/8)-1:0] OUT_DIN_KEEP ,
    input  logic [  (USER_WIDTH-1):0] OUT_DIN_USER ,
    input  logic                      OUT_DIN_LAST ,
    input  logic                      OUT_WREN     ,
    output logic                      OUT_FULL     ,
    output logic                      OUT_AWFULL   ,
    output logic [    DATA_WIDTH-1:0] M_AXIS_TDATA ,
    output logic [(DATA_WIDTH/8)-1:0] M_AXIS_TKEEP ,
    output logic [  (USER_WIDTH-1):0] M_AXIS_TUSER ,
    output logic                      M_AXIS_TVALID,
    output logic                      M_AXIS_TLAST ,
    input  logic                      M_AXIS_TREADY
);


    parameter integer FIFO_WIDTH            = DATA_WIDTH + (DATA_WIDTH/8) + USER_WIDTH + 1;
    parameter integer FIFO_DATA_COUNT_WIDTH = $clog2(DEPTH)                               ;

    logic rden ; 
    logic empty; 

    always_comb begin 
        if (~empty & M_AXIS_TREADY) begin 
            rden = 1'b1;
        end else begin 
            rden = 1'b0;
        end 
    end 

    always_comb begin 
        M_AXIS_TVALID = ~empty;
    end 


    xpm_fifo_sync #(
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
        .SIM_ASSERT_CHK     (0                    ), // DECIMAL; 0=disable simulation messages, 1=enable simulation messages
        .USE_ADV_FEATURES   ("0008"               ), // String
        .WAKEUP_TIME        (0                    ), // DECIMAL
        .WRITE_DATA_WIDTH   (FIFO_WIDTH           ), // DECIMAL
        .WR_DATA_COUNT_WIDTH(FIFO_DATA_COUNT_WIDTH)  // DECIMAL
    ) xpm_fifo_sync_inst (
        .almost_empty (                                                        ), // 1-bit output: Almost Empty : When asserted, this signal indicates that
        .almost_full  (OUT_AWFULL                                              ), // 1-bit output: Almost Full: When asserted, this signal indicates that
        .data_valid   (                                                        ), // 1-bit output: Read Data Valid: When asserted, this signal indicates
        .dbiterr      (                                                        ), // 1-bit output: Double Bit Error: Indicates that the ECC decoder detected
        .dout         ({M_AXIS_TLAST, M_AXIS_TUSER, M_AXIS_TKEEP, M_AXIS_TDATA}), // READ_DATA_WIDTH-bit output: Read Data: The output data bus is driven
        .empty        (empty                                                   ), // 1-bit output: Empty Flag: When asserted, this signal indicates that the
        .full         (OUT_FULL                                                ), // 1-bit output: Full Flag: When asserted, this signal indicates that the
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
        .din          ({OUT_DIN_LAST, OUT_DIN_USER, OUT_DIN_KEEP, OUT_DIN_DATA}), // WRITE_DATA_WIDTH-bit input: Write Data: The input data bus used when
        .injectdbiterr(1'b0                                                    ), // 1-bit input: Double Bit Error Injection: Injects a double bit error if
        .injectsbiterr(1'b0                                                    ), // 1-bit input: Single Bit Error Injection: Injects a single bit error if
        .rd_en        (rden                                                    ), // 1-bit input: Read Enable: If the FIFO is not empty, asserting this
        .rst          (RESET                                                   ), // 1-bit input: Reset: Must be synchronous to wr_clk. The clock(s) can be
        .sleep        (1'b0                                                    ), // 1-bit input: Dynamic power saving- If sleep is High, the memory/fifo
        .wr_clk       (CLK                                                     ), // 1-bit input: Write clock: Used for write operation. wr_clk must be a
        .wr_en        (OUT_WREN                                                )  // 1-bit input: Write Enable: If the FIFO is not full, asserting this
    );

endmodule
