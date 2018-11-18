// ---------------------------------------------------------------------------
//  Jelly  -- the soft-core processor system
//   math
//
//                                 Copyright (C) 2008-2018 by Ryuji Fuchikami
//                                 http://ryuz.my.coocan.jp/
// ---------------------------------------------------------------------------



`timescale 1ns / 1ps
`default_nettype none


module video_mnist_color
		#(
			parameter	DATA_WIDTH  = 8,
			parameter	TUSER_WIDTH = 1,
			parameter	TDATA_WIDTH = 4*DATA_WIDTH
		)
		(
			input	wire						aresetn,
			input	wire						aclk,
			
			input	wire	[TUSER_WIDTH-1:0]	s_axi4s_tuser,
			input	wire						s_axi4s_tlast,
			input	wire	[3:0]				s_axi4s_tnumber,
			input	wire	[1:0]				s_axi4s_tcount,
			input	wire	[TDATA_WIDTH-1:0]	s_axi4s_tdata,
			input	wire						s_axi4s_tvalid,
			output	wire						s_axi4s_tready,
			
			output	wire	[TUSER_WIDTH-1:0]	m_axi4s_tuser,
			output	wire						m_axi4s_tlast,
			output	wire	[TDATA_WIDTH-1:0]	m_axi4s_tdata,
			output	wire						m_axi4s_tvalid,
			input	wire						m_axi4s_tready
		);
	
	
	reg		[TUSER_WIDTH-1:0]		st0_user;
	reg								st0_last;
	reg		[TDATA_WIDTH-1:0]		st0_data;
	reg								st0_en;
	reg		[23:0]					st0_color;
	reg								st0_valid;
	
	reg		[TUSER_WIDTH-1:0]		st1_user;
	reg								st1_last;
	reg		[TDATA_WIDTH-1:0]		st1_data;
	reg								st1_valid;
	
	always @(posedge aclk) begin
		if ( ~aresetn ) begin
			st0_user   <= {TUSER_WIDTH{1'bx}};
			st0_last   <= 1'bx;
			st0_data   <= {TDATA_WIDTH{1'bx}};
			st0_en     <= 1'bx;
			st0_color  <= 24'hxx_xx_xx;
			st0_valid  <= 1'b0;
			
			st1_user   <= {TUSER_WIDTH{1'bx}};
			st1_last   <= 1'bx;
			st1_data   <= {TDATA_WIDTH{1'bx}};
			st1_valid  <= 1'b0;
		end
		else if ( s_axi4s_tready ) begin
			st0_user   <= s_axi4s_tuser;
			st0_last   <= s_axi4s_tlast;
			st0_data   <= s_axi4s_tdata;
			st0_en     <= (s_axi4s_tcount >= 3);
			case ( s_axi4s_tnumber )
			4'd0:		st0_color <= 24'h00_00_00;	// ��
			4'd1:		st0_color <= 24'h00_00_80;	// ��
			4'd2:		st0_color <= 24'h00_00_ff;	// ��
			4'd3:		st0_color <= 24'h4c_b7_ff;	// ��
			4'd4:		st0_color <= 24'h00_ff_ff;	// ��
			4'd5:		st0_color <= 24'h00_80_00;	// ��
			4'd6:		st0_color <= 24'hff_00_00;	// ��
			4'd7:		st0_color <= 24'h80_00_80;	// ��
			4'd8:		st0_color <= 24'h80_80_80;	// �D
			4'd9:		st0_color <= 24'hff_ff_ff;	// ��
			default:	st0_color <= 24'hxx_xx_xx;
			endcase
			st0_valid  <= s_axi4s_tvalid;
			
			st1_user   <= st0_user;
			st1_last   <= st0_last;
			st1_data   <= st0_data;
			if ( st0_en ) begin
				st1_data[ 7: 0] <= (({1'b0, st0_data[ 7: 0]} + {1'b0, st0_color[ 7: 0]}) >> 1);
				st1_data[15: 8] <= (({1'b0, st0_data[15: 8]} + {1'b0, st0_color[15: 8]}) >> 1);
				st1_data[23:16] <= (({1'b0, st0_data[23:16]} + {1'b0, st0_color[23:16]}) >> 1);
			end
			st1_valid  <= st0_valid;
		end
	end
	
	assign s_axi4s_tready = (m_axi4s_tready || !m_axi4s_tvalid);
	
	assign m_axi4s_tuser  = st1_user;
	assign m_axi4s_tlast  = st1_last;
	assign m_axi4s_tdata  = st1_data;
	assign m_axi4s_tvalid = st1_valid;
	
endmodule



`default_nettype wire



// end of file
