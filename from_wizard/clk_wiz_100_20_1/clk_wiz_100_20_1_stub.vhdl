-- Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2019.1 (lin64) Build 2552052 Fri May 24 14:47:09 MDT 2019
-- Date        : Sun Jan 12 05:29:13 2020
-- Host        : dev-mint19-vivado running 64-bit Linux Mint 19.2 Tina
-- Command     : write_vhdl -force -mode synth_stub
--               /home/mj/hwspi/albert_cpu/vivado_build/project_1.srcs/sources_1/ip/clk_wiz_100_20_1/clk_wiz_100_20_1_stub.vhdl
-- Design      : clk_wiz_100_20_1
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7a35tcpg236-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity clk_wiz_100_20_1 is
  Port ( 
    clk_out1 : out STD_LOGIC;
    reset : in STD_LOGIC;
    clk_in1 : in STD_LOGIC
  );

end clk_wiz_100_20_1;

architecture stub of clk_wiz_100_20_1 is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "clk_out1,reset,clk_in1";
begin
end;
