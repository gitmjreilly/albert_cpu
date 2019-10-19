// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.1 (lin64) Build 2552052 Fri May 24 14:47:09 MDT 2019
// Date        : Tue Oct  8 22:21:52 2019
// Host        : dev-mint19-vivado running 64-bit Linux Mint 19.2 Tina
// Command     : write_verilog -force -mode synth_stub
//               /home/mj/src/albert/vivado/albert/albert.srcs/sources_1/ip/block_ram_64_KW/block_ram_64_KW_stub.v
// Design      : block_ram_64_KW
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a35tcpg236-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "blk_mem_gen_v8_4_3,Vivado 2019.1" *)
module block_ram_64_KW(clka, wea, addra, dina, douta)
/* synthesis syn_black_box black_box_pad_pin="clka,wea[0:0],addra[15:0],dina[15:0],douta[15:0]" */;
  input clka;
  input [0:0]wea;
  input [15:0]addra;
  input [15:0]dina;
  output [15:0]douta;
endmodule
