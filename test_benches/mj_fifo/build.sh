#!/bin/sh


 rm *cf 

 ghdl -a mj_fifo.vhd
 ghdl -e mj_fifo

  ghdl -a mj_fifo_tb.vhd 
  ghdl -e mj_fifo_tb

