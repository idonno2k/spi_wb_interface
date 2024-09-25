// ============================================================================
// Copyright (c) 2010 by Terasic Technologies Inc. 
// ============================================================================
//
// Permission:
//
//   Terasic grants permission to use and modify this code for use
//   in synthesis for all Terasic Development Boards and Altera Development 
//   Kits made by Terasic.  Other use of this code, including the selling 
//   ,duplication, or modification of any portion is strictly prohibited.
//
// Disclaimer:
//
//   This VHDL/Verilog or C/C++ source code is intended as a design reference
//   which illustrates how these types of functions can be implemented.
//   It is the user's responsibility to verify their design for
//   consistency and functionality through the use of formal
//   verification methods.  Terasic provides no warranty regarding the use 
//   or functionality of this code.
//
// ============================================================================
//           
//                     Terasic Technologies Inc
//                     356 Fu-Shin E. Rd Sec. 1. JhuBei City,
//                     HsinChu County, Taiwan
//                     302
//
//                     web: http://www.terasic.com/
//                     email: support@terasic.com
//
// ============================================================================
// Major Functions/Design Description:
//
// BUTTON[3]: swich build-in test patter for DVI-TX
// BUTTON[2]: toggle internal rx-tx loopback mode and tx-only mode
// BUTTON[1]: write EEPROM EDID (Please remove the calbe at DVI-RX Port when update EEPROM EDID)
// LEDG[3:0]:
//	- blink: EEPROM EDID updating
//  - all lighten: loopback mode active
//  - other: pattern id in tx-only mode.
//
// ============================================================================
// Revision History:
// ============================================================================
//   Ver.: |Author:   |Mod. Date:    |Changes Made:
//   V1.0  |Lou Lu    |10/06/30      |Init.
// ============================================================================

`include "vpg.h"

// mode define
//`define VGA_640x480p60		0
//`define MODE_720x480    	1	// 480p,  	27		MHZ	   VIC=3
//`define MODE_1024x768		2	// XGA,   	65		MHZ	 
//`define MODE_1280x1024		3	// SXGA,  	108		MHZ
//`define FHD_1920x1080p60	4	// 1080i, 	74.25	MHZ    VIC=5 
//`define VESA_1600x1200p60   5   // VESA 	162 	MHZ	
//
//`define COLOR_RGB444	0



module DVI_DEMO(
	reset_n,
	//////// CLOCK //////////
	pll_100M,
//	pll_100K,

	//////// BUTTON x 4, EXT_IO and CPU_RESET_n //////////
	BUTTON,

	//////// HSMC-B //////////

	DVI_RX_CLK,
	DVI_RX_VS,
	DVI_RX_HS,
	DVI_RX_DE,
	DVI_RX_D,
	
	DVI_EDID_WP,
	DVI_RX_DDCSCL,
	DVI_RX_DDCSDA,

	DVI_TX_CLK,
	DVI_TX_VS,
	DVI_TX_HS,
	DVI_TX_DE,
	DVI_TX_D,
	
	tp

);






//=======================================================
//  PARAMETER declarations
//=======================================================


//=======================================================
//  PORT declarations
//=======================================================

//////////// CLOCK //////////
input		          		pll_100M;
//input		          		pll_100K;
input		          		reset_n;

//////////// BUTTON x 4, EXT_IO and CPU_RESET_n //////////
input		     [3:0]		BUTTON;

//////////// HSMC-B //////////

input		          		DVI_RX_CLK;
input		          		DVI_RX_VS;
input		          		DVI_RX_HS;
input		          		DVI_RX_DE;
input		    [23:0]		DVI_RX_D;

output		          		DVI_EDID_WP;
inout		          		DVI_RX_DDCSCL;
inout		          		DVI_RX_DDCSDA;

output		          		DVI_TX_CLK;
output		          		DVI_TX_VS;
output		          		DVI_TX_HS;
output		          		DVI_TX_DE;
output		    [23:0]		DVI_TX_D;

output		    [17:0]		tp;


//=======================================================
//  REG/WIRE declarations
//=======================================================


//=======================================================
//  Structural coding
//=======================================================

//---------------------------------------------------//
//				Mode Change Button Monitor 			 //
//---------------------------------------------------//
//wire			mode_button;
//reg				pre_mode_button;
//reg		[15:0]	debounce_cnt;
reg		[3:0]	vpg_mode = `MODE_720x480;
reg				vpg_mode_change = 1'b0;

//	assign mode_button = ~BUTTON[3];
//	always@(posedge pll_100M or negedge reset_n)
//		begin
//			if (!reset_n)
//				begin
//					vpg_mode <= `VGA_640x480p60;
//					debounce_cnt <= 1;
//					vpg_mode_change <= 1'b1;
//				end
//			else if (vpg_mode_change)
//				vpg_mode_change <= 1'b0;
//			else if (debounce_cnt)
//				debounce_cnt <= debounce_cnt + 1'b1;
//			else if (mode_button && !pre_mode_button)
//				begin
//					debounce_cnt <= 1;
//					vpg_mode_change <= 1'b1;
//					if (vpg_mode == `VESA_1600x1200p60)
//						vpg_mode <= `VGA_640x480p60;
//					else
//						vpg_mode <= vpg_mode + 1'b1;
//				end
//		end
//
//	always@(posedge pll_100M)
//		begin
//			pre_mode_button <= mode_button;
//		end

//----------------------------------------------//
// 			 Video Pattern Generator	  	   	//
//----------------------------------------------//
wire [3:0]	vpg_disp_mode;
wire [1:0]	vpg_disp_color;

wire vpg_pclk;
wire vpg_de;
wire vpg_hs;
wire vpg_vs;
wire [23:0]	vpg_data;

vpg	vpg_inst(
	.clk_100(pll_100M),
	.reset_n(reset_n),
	.mode(vpg_mode),
	.mode_change(vpg_mode_change),
	.disp_color(`COLOR_RGB444),
	.vpg_pclk(vpg_pclk),
	.vpg_de(vpg_de),
	.vpg_hs(vpg_hs),
	.vpg_vs(vpg_vs),
	.vpg_r(vpg_data[23:16]),
	.vpg_g(vpg_data[15:8]),
	.vpg_b(vpg_data[7:0])
);

//----------------------------------------------//
// 				DVI receiver					//
//----------------------------------------------//
// In schematic OCK_INV=GND, latches output data on falling edge
wire rx_clk;
reg	[23:0]	rx_data;
reg			rx_de;
reg			rx_hs;
reg			rx_vs;
assign rx_clk = ~DVI_RX_CLK;
always@(posedge rx_clk) // OCK_INV=GND, latches output data on falling edge
begin
	rx_data <= {DVI_RX_D[23:16], DVI_RX_D[15:8], DVI_RX_D[7:0]};
	rx_de <= DVI_RX_DE;
	rx_hs <= DVI_RX_HS;
	rx_vs <= DVI_RX_VS;	
end

//----------------------------------------------//
// 			 DVI TX                 	  	   	//
//----------------------------------------------//

reg			loopback_mode =  1'b0;
//reg	[15:0]	disable_cnt;
//reg			pre_loopback_btn;
//wire        loopback_btn;
//assign loopback_btn = ~BUTTON[2];


reg			pll_100K;
reg	[15:0]	div_cnt;
always@(posedge pll_100M)
begin
	div_cnt <= div_cnt + 1'b1;
	if (div_cnt > 500)
	begin
		div_cnt <= 16'h0000;
		pll_100K <= ~ pll_100K;
	end	

end



//always @ (posedge pll_100K)
//begin
//	if (disable_cnt)
//	begin
//		disable_cnt <= disable_cnt + 1'b1;
//	end
//	else if (loopback_btn && !pre_loopback_btn && disable_cnt == 0)
//	begin
//		loopback_mode <= loopback_mode + 1'b1;
//		disable_cnt <= 16'hFFFF;
//	end
//	pre_loopback_btn <= loopback_btn;
//end

clk_selector clk_selector_inst(
	.data0(vpg_pclk),
	.data1(rx_clk),
	.sel(loopback_mode),
	.result(DVI_TX_CLK)
	);

video_selector video_selector_inst(
	.clock(DVI_TX_CLK),
	.data0x({vpg_de, vpg_vs, vpg_hs, vpg_data}),
	.data1x({rx_de, rx_vs, rx_hs, rx_data}),
	.sel(loopback_mode),
	.result({DVI_TX_DE, DVI_TX_VS, DVI_TX_HS, DVI_TX_D})
	);

//----------------------------------------------//
// 			 DVI RX EDID (EEPROM Writing)  	   	//
//----------------------------------------------//
wire edid_writing;
WRITE_EDID WRITE_EDID_inst(
		.CLK_I2C_100K(pll_100K),
		.EDID_WRITE_TRIGGER(~BUTTON[1]),
		.EDID_WRITING(edid_writing),
		.EDID_WP(DVI_EDID_WP),
		.EDID_DDCSCL(DVI_RX_DDCSCL),
		.EDID_DDCSDA(DVI_RX_DDCSDA)
		);	

// edid-writing: led indication
reg [3:0] 	edid_writing_led;		
reg [12:0] 	edid_led_cnt;		
always @(posedge pll_100K)
begin
	if (edid_writing)begin
		if (edid_led_cnt == 0)
			edid_writing_led <= edid_writing_led ^ 4'hF;
		edid_led_cnt <= edid_led_cnt + 1'b1;
	end
	else begin
		edid_writing_led <= 4'hF;
		edid_led_cnt <= 0;
	end
end

endmodule
