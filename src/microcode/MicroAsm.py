#!/usr/bin/python

import os
import sys
import re

#####################################################################
# Global Constants
ALUCommands = dict()
ShifterCommands = dict()




ALUCommands['A'] = 0
ALUCommands['B'] = 1
ALUCommands['NOT_A'] = 2
ALUCommands['NOT_B'] = 3

ALUCommands['ADD'] = 4
ALUCommands['ADD_PLUS_1'] = 4
ALUCommands['INCA'] = 6
ALUCommands['INCB'] = 7

ALUCommands['B_MINUS_A'] = 8
ALUCommands['DECB'] = 9
ALUCommands['MINUS_A'] = 10
ALUCommands['A_AND_B'] = 11

ALUCommands['A_OR_B'] = 12
ALUCommands['ZERO'] = 13
ALUCommands['ONE'] = 14
ALUCommands['MINUS_1'] = 15

ALUCommands['DECA'] = 16

ALUCommands['A_XOR_B'] = 17
ALUCommands['A_MINUS_B'] = 18
ALUCommands['A_MUL_B'] = 19
ALUCommands['SRL_A'] = 20
ALUCommands['S_LESS'] = 21

ShifterCommands['SLL8'] = 1
ShifterCommands['SRA1'] = 2
ShifterCommands['SLL1'] = 3
	
#####################################################################



###############################################################################
def DecToBinStr(DecimalValue, Width) :

    OriginalDecimalValue = DecimalValue	

    BinStr = ""
    for i in range(Width) :
        NextBit = DecimalValue % 2

        DecimalValue /= 2
        BinStr = str(NextBit) +  BinStr

    return(BinStr)
###############################################################################



#####################################################################
# Read the 2 column Opcode file
#     opcode decimal_value
#
# Since opcode vals are addresses in the microcode the highest opcode
# val is returned so later portions of code can know where to start
#
# Also this function returns the initially populated SymbolTable.
#
def PassLoadOpcodes(FileName):
    print "INFO PASS Loading Opcodes..."
    try:
        File = open(FileName, "r")
    except:
        print "Could not open %s.  Exiting," % (FileName)
        sys.exit(1)
        
    SymbolTable = dict() 
    ValTable = dict()
    HighestOpcodeVal = 0
    
    LineNum = 0
    for Line in File.readlines():
        LineNum = LineNum + 1
        if (re.match("^\s*$|^\s*#", Line)):
            continue
            
        Tmp = Line.split()
        if (len(Tmp) != 2):
            print "Error more than 2 fields on line <%d> <%s>" % (Line, LineNum)
            continue
            
        Opcode = Tmp[0]
        OpcodeVal = int(Tmp[1], 10)
    
        if (SymbolTable.has_key(Opcode)):
            print "Error saw dup Opcode on line <%d> <%s>" % (Line, LineNum)
            continue
        
        if (ValTable.has_key(OpcodeVal)):
            print "Error saw dup OpcodeVal on line <%d> <%s>" % (Line, LineNum)
            continue
        
        SymbolTable[Opcode] = OpcodeVal
        
        if (OpcodeVal > HighestOpcodeVal):
            HighestOpcodeVal = OpcodeVal

    File.close()

            
    if (len(SymbolTable) != (HighestOpcodeVal + 1)):
        print "Warning There are gaps in the opcode map - len : <%d> high <%d>" % (len(SymbolTable), HighestOpcodeVal)
        
               
    return(SymbolTable, HighestOpcodeVal)
#####################################################################


#####################################################################
# A Parsed Line is a dict consisting of the following fields
#
# D['OriginalLine']  - str
# D['LineNum']  - int
# D['SubInstructions']  - list of dicts
# D['Label']  - str
#
# A Parsed Line describes a single micro instruction which
# consists of one or more ; delimited SubInstructions
# The SubInstructions may have arguments e.g. SETALU A
#
def ParseLine(Line, LineNum):
    
    Line = Line.rstrip()
    print "DEBUG entered ParseLine <%3d> <%s>" % (LineNum, Line)
    D = dict()
    D['OriginalLine'] = Line
    D['LineNum'] = LineNum
    D['SubInstructions'] = list()
    D['Label'] = ""
    
    if (re.match("\s*#|\s*$", Line)):
        # This line is just a comment
        return(D)

    Line = Line.strip().upper()

   
    # Get the label if present
    if (re.match(".*:", Line)):
        (Label, Line) = Line.split(":", 1)
    else:
        Label = ""
        
    D['Label'] = Label
    
    for SubInstruction in Line.split(';'):
        # A SubInsrruction looks like 
        #  "SETALU A"
        #  "jmpn trueLable falseLabel"
        SubInstruction = SubInstruction.strip()
        
        # There's no harm in a blank SubInstruction
        # Maybe it's the result of a ; at the end of a line.
        if (SubInstruction == "") :
            continue
        
        Tmp = SubInstruction.split()
        InstructionAlone = Tmp[0]
        Args = list()
        Args[:] = Tmp[1:]
        
        R = dict()
        R['SubInstruction'] = InstructionAlone
        R['Args'] = Args
        
        # Add this SubInstruction record to the array of SubInstructions 
        # associated with the line
        D['SubInstructions'].append(R)
        
    return(D)
#####################################################################


#####################################################################
# Create a list of ParsedLines
# Each ParsedLine corresponds to a MicroInstruction
#
def PassParseInput(FileName):
    try:
        File = open(FileName, "r")
    except:
        print "Could not open %s.  Exiting," % (FileName)
        sys.exit(1)
        
    ParsedLines = list()  
    LineNum = 1
    for Line in File.readlines():
        L = ParseLine(Line, LineNum)
        ParsedLines.append(L)
        LineNum = LineNum + 1
        
    File.close()
    return(ParsedLines)        
#####################################################################


#####################################################################
def PrintParsedLines(ParsedLines):
    print "Printing Parsed Lines"
    for ParsedLine in ParsedLines:
        print "============="
        print "%3d %s" % (ParsedLine['LineNum'], ParsedLine['OriginalLine'])
        print "  Label <%s>" % ParsedLine['Label']
        for SubInstructionRecord in ParsedLine['SubInstructions']:
            InstructionAlone = SubInstructionRecord['SubInstruction']
            Args = list()
            Args[:] = SubInstructionRecord['Args']
            print "    <%s> <%s>" % (InstructionAlone, Args)            
#####################################################################


#####################################################################
# Dynamic Labels are created as follows
# Upper and Lower paired labels start from 511 & 255 and work their way DOWN
# Single labels (used by GOTO) start from param SingleLowerLC and work their way UP
#
def PassCreateDynamicLabels(ParsedLines, SymbolTable, SingleLowerLC):
    print "INFO PASS Creating Dynamic Label Entries..."
    UpperPairedLC = 511
    LowerPairedLC = 255
    
    for ParsedLine in ParsedLines:
        for SubInstructionRecord in ParsedLine['SubInstructions']:
            InstructionAlone = SubInstructionRecord['SubInstruction']
            Args = list()
            Args[:] = SubInstructionRecord['Args']
            NumArgs = len(Args) 
            if (    InstructionAlone == "JMPN" or 
                    InstructionAlone == "JMPY" or 
                    InstructionAlone == "JMPZ"):
                if (NumArgs != 2):
                    print "ERROR expected two args with JMPXXX instruction <%s>" % ParsedLine["OriginalLine"]
                    sys.exit(1)
                    
                print "INFO saw <%s> <%s> <%s>" % (InstructionAlone, Args[0], Args[1])
                UpperTrueLabel = Args[0]
                LowerFalseLabel = Args[1]
                if (SymbolTable.has_key(UpperTrueLabel)):
                    print "ERROR  UpperTrueLabel <%s> is already in table!" % (UpperTrueLabel)
                    sys.exit(1)

                if (SymbolTable.has_key(LowerFalseLabel)):
                    print "ERROR  LowerFalseLabel <%s> is already in table!" % (LowerFalseLabel)
                    sys.exit(1)

                print "Adding    <%s> <%d>  +++ <%s> <%d>" %  \
                    (UpperTrueLabel, UpperPairedLC, LowerFalseLabel, LowerPairedLC)
                    
                SymbolTable[UpperTrueLabel] = UpperPairedLC
                SymbolTable[LowerFalseLabel] = LowerPairedLC
                UpperPairedLC = UpperPairedLC - 1
                LowerPairedLC = LowerPairedLC - 1

            if (InstructionAlone == "GOTO"):
                if (NumArgs != 1):
                    print "ERROR expected one arg with GOTO instruction <%s>" % ParsedLine["OriginalLine"]
                    continue
                print "INFO saw <%s> <%s>" % (InstructionAlone, Args[0])
                DestLabel = Args[0]
                
                # If DestLabel is a duplicate, this is NOT necessarily a problem.
                # It's possible many micro instructions GOTO a common location
                # As a practical matter the source only goes to MAIN, and HALT
                # so we do not report those. 
                # All others are considered errors.
                #
                if (SymbolTable.has_key(DestLabel)):
                    if ((DestLabel == "MAIN") or (DestLabel == "HALT")) :
                        continue
                        
                    print "ERROR  DestLabel <%s> is already in table." % (DestLabel)
                    sys.exit(1)

                print "INFO    Adding <%s> <%d>" % (DestLabel, SingleLowerLC)
                SymbolTable[DestLabel] = SingleLowerLC
                SingleLowerLC = SingleLowerLC + 1

    return(UpperPairedLC, LowerPairedLC, SingleLowerLC)
#####################################################################



#####################################################################
#
# AssembleParsedLine
#
# Only call if we know this is an instruction line!
# One instruction line consists of one or more sub instructions
# and an optional label
#
def AssembleParsedLine (ParsedLine, SymbolTable, DefaultNextAddress):

    ControlWord = dict()
    print "INFO Assembling Control Word  <%4d> <%s>" % (ParsedLine['LineNum'], ParsedLine['OriginalLine'])

    ControlWord['NEXT_ADDRESS'] = DefaultNextAddress
    
    
    for  SubInstructionRecord in (ParsedLine['SubInstructions']) :
        InstructionAlone = SubInstructionRecord['SubInstruction'].lower()
        Args = list()
        Args[:] = SubInstructionRecord['Args']
        NumArgs = len(Args)

        #
        # Process instructions which enable register output onto
        # the b bus.
        #
        if	(InstructionAlone == "ena_pc")		: ControlWord['B'] = 1 
        elif (InstructionAlone == "ena_mbr")	: ControlWord['B'] = 2 
        elif (InstructionAlone == "ena_es")	: ControlWord['B'] = 3 

        # Parameter stack pointer regs
        elif (InstructionAlone == "ena_sp")		: ControlWord['B'] = 4 
        elif (InstructionAlone == "ena_psp")	: ControlWord['B'] = 4 

        elif (InstructionAlone == "ena_lv")		: ControlWord['B'] = 5 
        elif (InstructionAlone == "ena_cpp")	: ControlWord['B'] = 6 
        elif (InstructionAlone == "ena_rsp")	: ControlWord['B'] = 5 
        elif (InstructionAlone == "ena_rtos")	: ControlWord['B'] = 6 

        elif (InstructionAlone == "ena_tos")	: ControlWord['B'] = 7 
        elif (InstructionAlone == "ena_ptos")	: ControlWord['B'] = 7 

        elif	(InstructionAlone == "ena_cs")		: ControlWord['B'] = 8 

        elif	(InstructionAlone == "ena_mdr")	: ControlWord['B'] = 9 

        elif (InstructionAlone == "ena_intctl"): ControlWord['B'] = 10 

        elif (InstructionAlone == "ena_ds"): ControlWord['B'] = 11 

        #
        # Process Memory Control instructions
        #
        elif (InstructionAlone == "rd")			: ControlWord['READ']  = "1"	
        elif (InstructionAlone == "wr")			: ControlWord['WRITE'] = "1"	
        elif (InstructionAlone == "fetch")		: ControlWord['FETCH'] = "1"	

        #
        # Process instructions which load values from C Bus
        #
        elif (InstructionAlone == "load_h")		: ControlWord['LOAD_H']   = "1" 
        elif (InstructionAlone == "load_opc")	: ControlWord['LOAD_OPC'] = "1" 
        elif (InstructionAlone == "load_tmp1")	: ControlWord['LOAD_OPC'] = "1" 
        elif (InstructionAlone == "load_intctl_low")	: ControlWord['LOAD_OPC'] = "1" 

        elif (InstructionAlone == "load_lv")	: ControlWord['LOAD_LV']  = "1" 
        elif (InstructionAlone == "load_rsp")	: ControlWord['LOAD_LV']  = "1" 
        elif (InstructionAlone == "load_cpp")	: ControlWord['LOAD_CPP'] = "1" 
        elif (InstructionAlone == "load_rtos")	: ControlWord['LOAD_CPP'] = "1" 

        elif (InstructionAlone == "load_sp")	: ControlWord['LOAD_SP']  = "1" 
        elif (InstructionAlone == "load_psp")	: ControlWord['LOAD_SP']  = "1" 
        elif (InstructionAlone == "load_tos")	: ControlWord['LOAD_TOS'] = "1" 
        elif (InstructionAlone == "load_ptos")	: ControlWord['LOAD_TOS'] = "1" 


        elif (InstructionAlone == "load_pc")	: ControlWord['LOAD_PC']  = "1" 
        elif (InstructionAlone == "load_mdr")	: ControlWord['LOAD_MDR'] = "1" 
        elif (InstructionAlone == "load_mar")	: ControlWord['LOAD_MAR'] = "1" 

        elif (InstructionAlone == "load_es")	: ControlWord['LOAD_ES'] = "1" 
        elif (InstructionAlone == "load_cs")	: ControlWord['LOAD_CS'] = "1" 
        elif (InstructionAlone == "load_ds")	: ControlWord['LOAD_DS'] = "1" 

        #
        # Memory access instructions
        #
        elif (InstructionAlone == "write")	: ControlWord['WRITE'] = "1" 
        elif (InstructionAlone == "read")	: ControlWord['READ']  = "1" 
        elif (InstructionAlone == "fetch")	: ControlWord['FETCH'] = "1" 
        elif (InstructionAlone == "use_es")	: ControlWord['USE_ES'] = "1" 



        #
        # Process goto instructions (i.e. those which set "JAM" bits)
        #
        elif (InstructionAlone == "goto"):
            if (NumArgs != 1) :
                print "ERROR - Wrong num of args to goto"
                continue
            Dst = Args[0]
            if (not SymbolTable.has_key(Dst)):
                print "ERROR - goto dest not in sym table <%s>" % (Dst)
                continue

            ControlWord['NEXT_ADDRESS'] = SymbolTable[Dst]


        elif (	(InstructionAlone == "jmpz") or	(InstructionAlone == "jmpn") or	(InstructionAlone == "jmpy")) :

            #print "Found conditional jmp <%s> " % (InstructionAlone)

            if (InstructionAlone == "jmpz") : 
                ControlWord['JMPZ'] = 1 
            if (InstructionAlone == "jmpn") : 
                ControlWord['JMPN'] = 1 
            if (InstructionAlone == "jmpy") : 
                ControlWord['JMPY'] = 1 
            
            #
            # Get the 2 symbols representing branch locations.
            # The 1st (true) one is an upper.  The 2nd (false) one is a lower.
            #
            if (NumArgs != 2):
                print "Did not see the 2 number of args <%d>" % (NumArgs)
                continue
            
            HighSymbol = Args[0]
            LowSymbol  = Args[1]

            if (not SymbolTable.has_key(HighSymbol)) :
                print "ERROR - High Symbol not in sym table <%s>" % (HighSymbol)
                sys.exit(1)
             
            if (not SymbolTable.has_key(LowSymbol)) :
                print "ERROR - Low Symbol not in sym table <%s>" % (HighSymbol)
                sys.exit(1)
             
            ControlWord['NEXT_ADDRESS'] = SymbolTable[LowSymbol]
                    

        elif (InstructionAlone == "gotombr") :
            ControlWord['JMPC'] = 1
            ControlWord['NEXT_ADDRESS'] = 0

        #
        # Process ALU InstructionAlone
        #
        elif (InstructionAlone == "setalu") :

            if (NumArgs != 1):
                print "Did not see the 1 number of args <%d>" % (NumArgs)
                continue
            
            ALUCommand = Args[0]

            if (not ALUCommands.has_key(ALUCommand)):
                print "ERROR - ALU Command is not defined <%s>" % (ALUCommand)
                continue              
            
            ControlWord['ALU'] = ALUCommands[ALUCommand]


        #
        # Process shifter InstructionAlone
        #
        elif (InstructionAlone == "setshifter") :

            if (NumArgs != 1):
                print "Did not see the 1 number of args <%d>" % (NumArgs)
                continue
            
            ShifterCommand = Args[0]

            if (not ShifterCommands.has_key(ShifterCommand)):
                print "ERROR - Shifter Command is not defined <%s>" % (ShifterCommand)
                continue
                         
            ControlWord['Shifter'] = ShifterCommands[ShifterCommand]
           

        #
        # "micronop" is a Jamet created micro op used to create
        # an InstructionAlone which does nothing.
        #
        elif (InstructionAlone == "micronop") :
            pass


        else :
            print "Unknown instr <%s> [] on line <%s>." % (InstructionAlone, ParsedLine['LineNum'])

   	
	ControlWord['OriginalLine'] = ParsedLine['OriginalLine']
    ControlWord['LineNum'] = ParsedLine['LineNum']
    
    if (ControlWord['NEXT_ADDRESS'] is None):
        print "ERROR - Tried to assemble a control word with NEXT_ADDRESS is None"
        sys.exit(1)

    return(ControlWord)

###############################################################################



#####################################################################
def PassCreateIntermediateOutput(ParsedLines, SymbolTable, UpperPairedLC, LowerPairedLC, SingleLowerLC ) :


    print "INFO PASS create intermediate output - works Backward from end of ParsedLines"
    IntermediateOutput = 512 * [None]
    
    TmpList = list()
    TmpList[:] = ParsedLines
    TmpList.reverse()
    ForwardNextAddress = None
    LC = UpperPairedLC
    for ParsedLine in TmpList:
        # Every source line was parsed.  Some may be empty so 
        # we explicitly check for such a case.
        if (len(ParsedLine['SubInstructions']) == 0) : 
            continue
            
        AssembledMicroInstruction = AssembleParsedLine(ParsedLine, SymbolTable, ForwardNextAddress)
        Label = ParsedLine['Label']
        if (Label == "") : 
            TmpLC = LC
            ForwardNextAddress = LC
            LC = LC - 1
        else:
            TmpLC = SymbolTable[Label]
            ForwardNextAddress = None

        if (IntermediateOutput[TmpLC] is not None):
            print "ERROR Intermediate Output at <%d> is already allocated!" % (TmpLC)
            continue
            
        IntermediateOutput[TmpLC] = AssembledMicroInstruction

            
    return(IntermediateOutput)
#####################################################################


#####################################################################
def PrintIntermediateOutput(IntermediateOutput) :

    print "INFO Printing Intermediate Output"
    for (LC, Rec) in enumerate(IntermediateOutput):
        if (Rec == None): continue
        
        print "=========="
        print "LC : <%3d>   NEXT_ADDRESS : <%3d>    LineNum <%4d>  OriginalLine <%s>   " % (LC, Rec['NEXT_ADDRESS'] , Rec['LineNum'], Rec['OriginalLine'])
#####################################################################



###############################################################################
#  ControlWordToBitPattern(ControlWord)
#
#
# Build up control word from left to right.
#
# Control Word Pattern is :

#		USE_ES  DS   CS   ES   JMPY
#		  1      1    1   1     1
#
#		NEXT_ADDRESS JMPC JMPN JMPZ SLL8 SRA1 ALU H OPC TOS CPP LV SP PC MDR MAR
#			9           1   1     1    1    1   6  1  1   1   1   1  1  1   1   1
#
#		WRITE READ FETCH B
#		   1    1    1   4
#
def ControlWordToBitPattern (ControlWord) :


    BitPattern = ""

    if (ControlWord.has_key('USE_ES')) :
        BitPattern = BitPattern +  "1"
    else:  BitPattern = BitPattern +  "0"

    #
    # Later C Bus Load Signals
    #
    if (ControlWord.has_key('LOAD_DS')) :
        BitPattern = BitPattern +  "1" 
    else:  BitPattern = BitPattern +  "0"
    if (ControlWord.has_key('LOAD_CS')) :
        BitPattern = BitPattern +  "1" 
    else:  BitPattern = BitPattern +  "0"
    if (ControlWord.has_key('LOAD_ES')) :
        BitPattern = BitPattern +  "1" 
    else:  BitPattern = BitPattern +  "0"

    #
    # JMPY Control signal
    #
    if (ControlWord.has_key('JMPY')) :
        BitPattern = BitPattern +  "1" 
    else:  BitPattern = BitPattern +  "0"


    # NEXT ADDRESS
    #
    BitPattern = BitPattern +  DecToBinStr(ControlWord['NEXT_ADDRESS'], 9);

    #
    # JAM signals (excluding JMPY which was not part of Tanenbaum design
    #		See above for details.)
    #
    if (ControlWord.has_key('JMPC')) :
        BitPattern = BitPattern +  "1" 
    else:  BitPattern = BitPattern +  "0"
    if (ControlWord.has_key('JMPN')) :
        BitPattern = BitPattern +  "1" 
    else:  BitPattern = BitPattern +  "0"
    if (ControlWord.has_key('JMPZ')) :
        BitPattern = BitPattern +  "1" 
    else:  BitPattern = BitPattern +  "0"

    # Shifter Signals
    #
    ShifterBitPattern = DecToBinStr(ControlWord.get('Shifter', 0), 2)
    BitPattern = BitPattern +  ShifterBitPattern

    # ALU Signals
    #
    ALUBitPattern = DecToBinStr(ControlWord.get('ALU', 0), 6)
    BitPattern = BitPattern +  ALUBitPattern

    # C Bus Load Signals
    #
    if (ControlWord.has_key('LOAD_H'))   :
        BitPattern = BitPattern +  "1" 
    else:  BitPattern = BitPattern +  "0"
    if (ControlWord.has_key('LOAD_OPC')) :
        BitPattern = BitPattern +  "1" 
    else:  BitPattern = BitPattern +  "0"
    if (ControlWord.has_key('LOAD_TOS')) :
        BitPattern = BitPattern +  "1" 
    else:  BitPattern = BitPattern +  "0"
    if (ControlWord.has_key('LOAD_CPP')) :
        BitPattern = BitPattern +  "1" 
    else:  BitPattern = BitPattern +  "0"
    if (ControlWord.has_key('LOAD_LV'))  :
        BitPattern = BitPattern +  "1" 
    else:  BitPattern = BitPattern +  "0"
    if (ControlWord.has_key('LOAD_SP'))  :
        BitPattern = BitPattern +  "1" 
    else:  BitPattern = BitPattern +  "0"
    if (ControlWord.has_key('LOAD_PC'))  :
        BitPattern = BitPattern +  "1" 
    else:  BitPattern = BitPattern +  "0"
    if (ControlWord.has_key('LOAD_MDR')) :
        BitPattern = BitPattern +  "1" 
    else:  BitPattern = BitPattern +  "0"
    if (ControlWord.has_key('LOAD_MAR')) :
        BitPattern = BitPattern +  "1" 
    else:  BitPattern = BitPattern +  "0"

    #		WRITE READ FETCH
    #
    if (ControlWord.has_key('WRITE')) :
        BitPattern = BitPattern +  "1" 
    else:  BitPattern = BitPattern +  "0"
    if (ControlWord.has_key('READ'))  :
        BitPattern = BitPattern +  "1" 
    else:  BitPattern = BitPattern +  "0"
    if (ControlWord.has_key('FETCH')) :
        BitPattern = BitPattern +  "1" 
    else:  BitPattern = BitPattern +  "0"

    #	BitPattern = BitPattern +  " ";

    # B Bus enable signals
    #
    BBusBitPattern = DecToBinStr(ControlWord.get('B', 0), 4)

    BitPattern = BitPattern +  BBusBitPattern


    return(BitPattern)
###############################################################################



###############################################################################
def CreateControlStoreVHDL(IntermediateAssembly):


    print  "library IEEE;"
    print  "use IEEE.STD_LOGIC_1164.ALL;"
    print "use IEEE.STD_LOGIC_ARITH.ALL;"
    print "use IEEE.STD_LOGIC_UNSIGNED.ALL;"

    print "entity control_store is"
    print "    Port ( input : in std_logic_vector(8 downto 0);"
    print "           output : out std_logic_vector(40 downto 0));"
    print "end control_store;"

    print ""
    print ""

    print "architecture Behavioral of control_store is"
    print ""
    print "begin"


    print "output <= "

    #
    #
    for LC in range(512) :
        ControlWord = IntermediateAssembly[LC]
        AddressBitPattern  = DecToBinStr(LC, 9)
        
        
        if (ControlWord is None) :  
            RomBitPattern = DecToBinStr(0, 41)
            print '"%s" when (input = "%s") else ' % (RomBitPattern, AddressBitPattern)
            continue
            
        RomBitPattern = ControlWordToBitPattern(ControlWord)

        print '"%s" when (input = "%s") else ' % (RomBitPattern, AddressBitPattern)
        

        print "    -- %3d %s" %  (LC, ControlWord['OriginalLine'])
        for (Key, Val) in ControlWord.iteritems():
            print "       -- <%s> <%s>" % (Key, Val)
        print ""		
        
        
    RomBitPattern = DecToBinStr(0, 41)
    print '"%s";' % (RomBitPattern)

    print ""

    print "end Behavioral;"


    # print "-- ==== Symbol Table ====\n"
    # for my Symbol (sort(keys(%SymbolTable))) {
    # print "  -- [Symbol] [SymbolTable{Symbol}]\n"
    # printf(SYMBOLTABLEFILE "Symbol SymbolTable{Symbol}\n"



#####################################################################



#####################################################################
def main():
    (SymbolTable, MaxOpcodeVal) = PassLoadOpcodes("OpcodeMap.txt")
    
    FileName = "microcode_source.txt"
    ParsedLines = PassParseInput(FileName)

    PrintParsedLines(ParsedLines)
    
    (UpperPairedLC, LowerPairedLC, SingleLowerLC) = \
        PassCreateDynamicLabels(ParsedLines, SymbolTable, MaxOpcodeVal + 1)
    
    IntermediateOutput = PassCreateIntermediateOutput(
        ParsedLines, SymbolTable, UpperPairedLC, LowerPairedLC, SingleLowerLC)
        
    PrintIntermediateOutput(IntermediateOutput)
    
    CreateControlStoreVHDL(IntermediateOutput)    
#####################################################################


#####################################################################
# Main Program
main()
#####################################################################
	
	
