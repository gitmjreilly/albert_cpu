#!/usr/bin/python3
import sys


try:
   f = open(sys.argv[1])
   expansion_size = int(sys.argv[2])
   
except:
   print("Unable to open the input file and get the expansion size.")
   sys.exit(1)


for line in f:
   line = line.rstrip()
   # Note we use line position numbers as would be seen in an editor like vim
   position_in_line = 1
   output_line = ""
   for c in line:
      if (c == "\t"):
         amount_to_indent = expansion_size - (position_in_line % expansion_size) + 1
         s = ""
         for i in range(amount_to_indent):
            s += " "
         output_line += s
         position_in_line += amount_to_indent
         
      else:
         output_line += c
         position_in_line += 1

   print(output_line)
