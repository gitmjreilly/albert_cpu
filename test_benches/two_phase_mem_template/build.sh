#!/bin/sh

# ghdl -a --ieee=synopsys mem_based_spi.vhd 
# ghdl -e --ieee=synopsys mem_based_spi
#
#
# ghdl -a --ieee=synopsys spi_tb.vhd 
# ghdl -e --ieee=synopsys spi_tb

 rm *cf 

 ghdl -a mem_based_fsm_template.vhd
 ghdl -e mem_based_fsm_template

 ghdl -a mem_io_no_finish_tb.vhd 
 ghdl -e mem_io_no_finish_tb

