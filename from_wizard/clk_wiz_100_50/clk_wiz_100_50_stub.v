// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.1 (lin64) Build 2552052 Fri May 24 14:47:09 MDT 2019
// Date        : Tue Oct  8 22:11:26 2019
// Host        : dev-mint19-vivado running 64-bit Linux Mint 19.2 Tina
// Command     : write_verilog -force -mode synth_stub
//               /home/mj/src/albert/vivado/albert/albert.srcs/sources_1/ip/clk_wiz_100_50/clk_wiz_100_50_stub.v
// Design      : clk_wiz_100_50
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a35tcpg236-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module clk_wiz_100_50(clk_out1, reset, clk_in1)
/* synthesis syn_black_box black_box_pad_pin="clk_out1,reset,clk_in1" */;
  output clk_out1;
  input reset;
  input clk_in1;
endmodule
