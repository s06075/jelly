// ---------------------------------------------------------------------------
//  Jelly  -- the soft-core processor system
//   image processing
//
//                                 Copyright (C) 2008-2016 by Ryuji Fuchikami
//                                 http://ryuz.my.coocan.jp/
// ---------------------------------------------------------------------------



`timescale 1ns / 1ps
`default_nettype none


module jelly_img_demosaic_acpi_g_unit
        #(
            parameter   DATA_WIDTH = 10
        )
        (
            input   wire                            reset,
            input   wire                            clk,
            input   wire                            cke,
            
            input   wire    [5*5*DATA_WIDTH-1:0]    in_raw,
            
            output  wire    [DATA_WIDTH-1:0]        out_raw,
            output  wire    [DATA_WIDTH-1:0]        out_g
        );
    
    
    // 計算用に余裕を持った幅を定義
    localparam      CALC_WIDTH = DATA_WIDTH + 5;
    
    
    function signed [CALC_WIDTH+1:0]    abs(input signed [CALC_WIDTH-1:0] a);
    begin
        abs = a >= 0 ? a : -a;
    end
    endfunction
    
    function signed [CALC_WIDTH+1:0]    absdiff(input signed [CALC_WIDTH-1:0] a, input signed [CALC_WIDTH-1:0] b);
    begin
        absdiff = a > b ? a - b : b - a;
    end
    endfunction
    
    
    wire    signed  [CALC_WIDTH-1:0]    in_raw11 = in_raw[(0*5+0)*DATA_WIDTH +: DATA_WIDTH];
    wire    signed  [CALC_WIDTH-1:0]    in_raw12 = in_raw[(0*5+1)*DATA_WIDTH +: DATA_WIDTH];
    wire    signed  [CALC_WIDTH-1:0]    in_raw13 = in_raw[(0*5+2)*DATA_WIDTH +: DATA_WIDTH];
    wire    signed  [CALC_WIDTH-1:0]    in_raw14 = in_raw[(0*5+3)*DATA_WIDTH +: DATA_WIDTH];
    wire    signed  [CALC_WIDTH-1:0]    in_raw15 = in_raw[(0*5+4)*DATA_WIDTH +: DATA_WIDTH];
    wire    signed  [CALC_WIDTH-1:0]    in_raw21 = in_raw[(1*5+0)*DATA_WIDTH +: DATA_WIDTH];
    wire    signed  [CALC_WIDTH-1:0]    in_raw22 = in_raw[(1*5+1)*DATA_WIDTH +: DATA_WIDTH];
    wire    signed  [CALC_WIDTH-1:0]    in_raw23 = in_raw[(1*5+2)*DATA_WIDTH +: DATA_WIDTH];
    wire    signed  [CALC_WIDTH-1:0]    in_raw24 = in_raw[(1*5+3)*DATA_WIDTH +: DATA_WIDTH];
    wire    signed  [CALC_WIDTH-1:0]    in_raw25 = in_raw[(1*5+4)*DATA_WIDTH +: DATA_WIDTH];
    wire    signed  [CALC_WIDTH-1:0]    in_raw31 = in_raw[(2*5+0)*DATA_WIDTH +: DATA_WIDTH];
    wire    signed  [CALC_WIDTH-1:0]    in_raw32 = in_raw[(2*5+1)*DATA_WIDTH +: DATA_WIDTH];
    wire    signed  [CALC_WIDTH-1:0]    in_raw33 = in_raw[(2*5+2)*DATA_WIDTH +: DATA_WIDTH];
    wire    signed  [CALC_WIDTH-1:0]    in_raw34 = in_raw[(2*5+3)*DATA_WIDTH +: DATA_WIDTH];
    wire    signed  [CALC_WIDTH-1:0]    in_raw35 = in_raw[(2*5+4)*DATA_WIDTH +: DATA_WIDTH];
    wire    signed  [CALC_WIDTH-1:0]    in_raw41 = in_raw[(3*5+0)*DATA_WIDTH +: DATA_WIDTH];
    wire    signed  [CALC_WIDTH-1:0]    in_raw42 = in_raw[(3*5+1)*DATA_WIDTH +: DATA_WIDTH];
    wire    signed  [CALC_WIDTH-1:0]    in_raw43 = in_raw[(3*5+2)*DATA_WIDTH +: DATA_WIDTH];
    wire    signed  [CALC_WIDTH-1:0]    in_raw44 = in_raw[(3*5+3)*DATA_WIDTH +: DATA_WIDTH];
    wire    signed  [CALC_WIDTH-1:0]    in_raw45 = in_raw[(3*5+4)*DATA_WIDTH +: DATA_WIDTH];
    wire    signed  [CALC_WIDTH-1:0]    in_raw51 = in_raw[(4*5+0)*DATA_WIDTH +: DATA_WIDTH];
    wire    signed  [CALC_WIDTH-1:0]    in_raw52 = in_raw[(4*5+1)*DATA_WIDTH +: DATA_WIDTH];
    wire    signed  [CALC_WIDTH-1:0]    in_raw53 = in_raw[(4*5+2)*DATA_WIDTH +: DATA_WIDTH];
    wire    signed  [CALC_WIDTH-1:0]    in_raw54 = in_raw[(4*5+3)*DATA_WIDTH +: DATA_WIDTH];
    wire    signed  [CALC_WIDTH-1:0]    in_raw55 = in_raw[(4*5+4)*DATA_WIDTH +: DATA_WIDTH];
    
    reg     signed  [CALC_WIDTH-1:0]    st0_raw;
    reg     signed  [CALC_WIDTH-1:0]    st0_a0;
    reg     signed  [CALC_WIDTH-1:0]    st0_a1;
    reg     signed  [CALC_WIDTH-1:0]    st0_b0;
    reg     signed  [CALC_WIDTH-1:0]    st0_b1;
    reg     signed  [CALC_WIDTH-1:0]    st0_v;
    reg     signed  [CALC_WIDTH-1:0]    st0_h;
    
    reg     signed  [CALC_WIDTH-1:0]    st1_raw;
    reg     signed  [CALC_WIDTH-1:0]    st1_a0;
    reg     signed  [CALC_WIDTH-1:0]    st1_a1;
    reg     signed  [CALC_WIDTH-1:0]    st1_b0;
    reg     signed  [CALC_WIDTH-1:0]    st1_b1;
    reg     signed  [CALC_WIDTH-1:0]    st1_v;
    reg     signed  [CALC_WIDTH-1:0]    st1_h;
    
    reg     signed  [CALC_WIDTH-1:0]    st2_raw;
    reg     signed  [CALC_WIDTH-1:0]    st2_a;
    reg     signed  [CALC_WIDTH-1:0]    st2_b;
    reg     signed  [CALC_WIDTH-1:0]    st2_v;
    reg     signed  [CALC_WIDTH-1:0]    st2_h;
    
    reg     signed  [CALC_WIDTH-1:0]    st3_raw;
    reg     signed  [CALC_WIDTH-1:0]    st3_g;
    
    reg     signed  [CALC_WIDTH-1:0]    st4_raw;
    reg     signed  [CALC_WIDTH-1:0]    st4_g;
    
    always @(posedge clk) begin
        if ( cke ) begin
            st0_raw <= in_raw33;
            st0_a0  <= in_raw13 + in_raw53;
            st0_a1  <= absdiff(in_raw23, in_raw43);
            st0_b0  <= in_raw31 + in_raw35;
            st0_b1  <= absdiff(in_raw32, in_raw34);
            st0_v   <= in_raw23 + in_raw43;
            st0_h   <= in_raw32 + in_raw34;
            
            st1_raw <= st0_raw;
            st1_a0  <= st0_raw * 2 - st0_a0;
            st1_a1  <= st0_a1;
            st1_b0  <= st0_raw * 2 - st0_b0;
            st1_b1  <= st0_b1;
            st1_v   <= st0_v;
            st1_h   <= st0_h;
            
            st2_raw <= st1_raw;
            st2_a   <= abs(st1_a0) + st1_a1;
            st2_b   <= abs(st1_b0) + st1_b1;
            st2_v   <= st1_v * 2 + st1_a0;
            st2_h   <= st1_h * 2 + st1_b0;
            
            st3_raw <= st2_raw;
            st3_g   <= ((st2_a < st2_b ? st2_v : st2_h) + (st2_a > st2_b ? st2_h : st2_v)) >>> 3;
            
            st4_raw <= st3_raw;
            st4_g   <= st3_g < {DATA_WIDTH{1'b0}} ? {DATA_WIDTH{1'b0}} : st3_g;
            st4_g   <= st3_g > {DATA_WIDTH{1'b1}} ? {DATA_WIDTH{1'b1}} : st3_g;
        end
    end
    
    assign  out_raw  = st4_raw;
    assign  out_g    = st4_g;
    
endmodule


`default_nettype wire


// end of file
