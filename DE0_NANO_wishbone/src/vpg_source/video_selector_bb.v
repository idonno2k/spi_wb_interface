// megafunction wizard: %LPM_MUX%VBB%
// GENERATION: STANDARD
// VERSION: WM1.0
// MODULE: LPM_MUX 

// ============================================================
// File Name: video_selector.v
// Megafunction Name(s):
// 			LPM_MUX
//
// Simulation Library Files(s):
// 			
// ============================================================
// ************************************************************
// THIS IS A WIZARD-GENERATED FILE. DO NOT EDIT THIS FILE!
//
// 15.1.0 Build 185 10/21/2015 SJ Standard Edition
// ************************************************************

//Copyright (C) 1991-2015 Altera Corporation. All rights reserved.
//Your use of Altera Corporation's design tools, logic functions 
//and other software and tools, and its AMPP partner logic 
//functions, and any output files from any of the foregoing 
//(including device programming or simulation files), and any 
//associated documentation or information are expressly subject 
//to the terms and conditions of the Altera Program License 
//Subscription Agreement, the Altera Quartus Prime License Agreement,
//the Altera MegaCore Function License Agreement, or other 
//applicable license agreement, including, without limitation, 
//that your use is for the sole purpose of programming logic 
//devices manufactured by Altera and sold by Altera or its 
//authorized distributors.  Please refer to the applicable 
//agreement for further details.

module video_selector (
	clock,
	data0x,
	data1x,
	sel,
	result);

	input	  clock;
	input	[26:0]  data0x;
	input	[26:0]  data1x;
	input	  sel;
	output	[26:0]  result;

endmodule

// ============================================================
// CNX file retrieval info
// ============================================================
// Retrieval info: PRIVATE: INTENDED_DEVICE_FAMILY STRING "Stratix IV"
// Retrieval info: PRIVATE: SYNTH_WRAPPER_GEN_POSTFIX STRING "0"
// Retrieval info: PRIVATE: new_diagram STRING "1"
// Retrieval info: LIBRARY: lpm lpm.lpm_components.all
// Retrieval info: CONSTANT: LPM_PIPELINE NUMERIC "1"
// Retrieval info: CONSTANT: LPM_SIZE NUMERIC "2"
// Retrieval info: CONSTANT: LPM_TYPE STRING "LPM_MUX"
// Retrieval info: CONSTANT: LPM_WIDTH NUMERIC "27"
// Retrieval info: CONSTANT: LPM_WIDTHS NUMERIC "1"
// Retrieval info: USED_PORT: clock 0 0 0 0 INPUT NODEFVAL "clock"
// Retrieval info: USED_PORT: data0x 0 0 27 0 INPUT NODEFVAL "data0x[26..0]"
// Retrieval info: USED_PORT: data1x 0 0 27 0 INPUT NODEFVAL "data1x[26..0]"
// Retrieval info: USED_PORT: result 0 0 27 0 OUTPUT NODEFVAL "result[26..0]"
// Retrieval info: USED_PORT: sel 0 0 0 0 INPUT NODEFVAL "sel"
// Retrieval info: CONNECT: @clock 0 0 0 0 clock 0 0 0 0
// Retrieval info: CONNECT: @data 0 0 27 0 data0x 0 0 27 0
// Retrieval info: CONNECT: @data 0 0 27 27 data1x 0 0 27 0
// Retrieval info: CONNECT: @sel 0 0 1 0 sel 0 0 0 0
// Retrieval info: CONNECT: result 0 0 27 0 @result 0 0 27 0
// Retrieval info: GEN_FILE: TYPE_NORMAL video_selector.v TRUE
// Retrieval info: GEN_FILE: TYPE_NORMAL video_selector.inc FALSE
// Retrieval info: GEN_FILE: TYPE_NORMAL video_selector.cmp FALSE
// Retrieval info: GEN_FILE: TYPE_NORMAL video_selector.bsf TRUE
// Retrieval info: GEN_FILE: TYPE_NORMAL video_selector_inst.v FALSE
// Retrieval info: GEN_FILE: TYPE_NORMAL video_selector_bb.v TRUE
