#!/bin/sh

# ghdl -a --ieee=synopsys mem_based_spi.vhd 
# ghdl -e --ieee=synopsys mem_based_spi
#
#
# ghdl -a --ieee=synopsys spi_tb.vhd 
# ghdl -e --ieee=synopsys spi_tb

 rm *cf 

 ghdl -a ../../src/block_ram_64kb.vhd
 ghdl -e block_ram_64kb

  ghdl -a block_ram_two_phase_tb.vhd 
  ghdl -e block_ram_two_phase_tb

