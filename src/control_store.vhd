
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity control_store is
    Port ( input : in std_logic_vector(8 downto 0);
           output : out std_logic_vector(40 downto 0));
end control_store;


architecture Behavioral of control_store is

begin
output <= 
"00000100111000000010011110000010000000000" when (input = "000000000") else 
    --   0 RESET:	setalu MINUS_1; setshifter SLL8; load_sp
       -- <LOAD_SP> <1>
       -- <LineNum> <29>
       -- <OriginalLine> <RESET:	setalu MINUS_1; setshifter SLL8; load_sp>
       -- <Shifter> <1>
       -- <NEXT_ADDRESS> <312>
       -- <ALU> <15>

"00000000110101000000000000000000000000000" when (input = "000000001") else 
    --   1 NOP:	goto Main
       -- <LineNum> <46>
       -- <NEXT_ADDRESS> <53>
       -- <OriginalLine> <NOP:	goto Main>

"00000100111100000000000000000000100000111" when (input = "000000010") else 
    --   2 DO_LIT:	ena_ptos; setalu A; load_mdr
       -- <B> <7>
       -- <LineNum> <67>
       -- <LOAD_MDR> <1>
       -- <OriginalLine> <DO_LIT:	ena_ptos; setalu A; load_mdr>
       -- <NEXT_ADDRESS> <316>
       -- <ALU> <0>

"00000000000011000000000000000000000000000" when (input = "000000011") else 
    --   3 HALT:	goto HALT
       -- <LineNum> <89>
       -- <NEXT_ADDRESS> <3>
       -- <OriginalLine> <HALT:	goto HALT>

"00000101000000000000000000000000000000000" when (input = "000000100") else 
    --   4 BRANCH:	micronop
       -- <LineNum> <100>
       -- <NEXT_ADDRESS> <320>
       -- <OriginalLine> <BRANCH:	micronop>

"00000101000010000000100000000010010100100" when (input = "000000101") else 
    --   5 LESS:	ena_psp; setalu DECA; load_psp; load_mar; read
       -- <B> <4>
       -- <READ> <1>
       -- <LOAD_SP> <1>
       -- <LOAD_MAR> <1>
       -- <LineNum> <122>
       -- <OriginalLine> <LESS:	ena_psp; setalu DECA; load_psp; load_mar; read>
       -- <NEXT_ADDRESS> <322>
       -- <ALU> <16>

"00000101000110000000000000000000010100111" when (input = "000000110") else 
    --   6 PLUSPLUS:	ena_ptos; setalu A; load_mar; read
       -- <B> <7>
       -- <READ> <1>
       -- <LOAD_MAR> <1>
       -- <LineNum> <164>
       -- <OriginalLine> <PLUSPLUS:	ena_ptos; setalu A; load_mar; read>
       -- <NEXT_ADDRESS> <326>
       -- <ALU> <0>

"00000101001011000000100000000010010100100" when (input = "000000111") else 
    --   7 DROP:	ena_psp; setalu DECA; load_mar; load_sp; read
       -- <B> <4>
       -- <READ> <1>
       -- <LOAD_SP> <1>
       -- <LOAD_MAR> <1>
       -- <LineNum> <184>
       -- <OriginalLine> <DROP:	ena_psp; setalu DECA; load_mar; load_sp; read>
       -- <NEXT_ADDRESS> <331>
       -- <ALU> <16>

"00000101001101000000100000000010010100100" when (input = "000001000") else 
    --   8 STORE:	ena_sp; setalu DECA; load_mar; load_sp; read
       -- <B> <4>
       -- <READ> <1>
       -- <LOAD_SP> <1>
       -- <LOAD_MAR> <1>
       -- <LineNum> <203>
       -- <OriginalLine> <STORE:	ena_sp; setalu DECA; load_mar; load_sp; read>
       -- <NEXT_ADDRESS> <333>
       -- <ALU> <16>

"00000101010001000000000000000000010100111" when (input = "000001001") else 
    --   9 FETCH:	ena_ptos; setalu A; load_mar; read
       -- <B> <7>
       -- <READ> <1>
       -- <LOAD_MAR> <1>
       -- <LineNum> <227>
       -- <OriginalLine> <FETCH:	ena_ptos; setalu A; load_mar; read>
       -- <NEXT_ADDRESS> <337>
       -- <ALU> <0>

"00000101010011000000000000000000100000110" when (input = "000001010") else 
    --  10 JSR:	ena_rtos; setalu A; load_mdr
       -- <B> <6>
       -- <LineNum> <244>
       -- <LOAD_MDR> <1>
       -- <OriginalLine> <JSR:	ena_rtos; setalu A; load_mdr>
       -- <NEXT_ADDRESS> <339>
       -- <ALU> <0>

"00000101011000000000100000000100010100101" when (input = "000001011") else 
    --  11 RET:	ena_rsp; setalu DECA; load_rsp; load_mar; read
       -- <B> <5>
       -- <READ> <1>
       -- <LOAD_MAR> <1>
       -- <LOAD_LV> <1>
       -- <LineNum> <271>
       -- <OriginalLine> <RET:	ena_rsp; setalu DECA; load_rsp; load_mar; read>
       -- <NEXT_ADDRESS> <344>
       -- <ALU> <16>

"00000011111110001000000000000000000000111" when (input = "000001100") else 
    --  12 DOWHILE:	ena_ptos; setalu A; jmpz dowhile_true_1 dowhile_false_1
       -- <B> <7>
       -- <JMPZ> <1>
       -- <LineNum> <287>
       -- <OriginalLine> <DOWHILE:	ena_ptos; setalu A; jmpz dowhile_true_1 dowhile_false_1>
       -- <NEXT_ADDRESS> <254>
       -- <ALU> <0>

"00000101011110000000000000000000100000110" when (input = "000001101") else 
    --  13 TO_R:	ena_rtos; setalu A;load_mdr
       -- <B> <6>
       -- <LineNum> <317>
       -- <LOAD_MDR> <1>
       -- <OriginalLine> <TO_R:	ena_rtos; setalu A;load_mdr>
       -- <NEXT_ADDRESS> <350>
       -- <ALU> <0>

"00000101100100000000000000000000100000111" when (input = "000001110") else 
    --  14 FROM_R:	ena_ptos; setalu A;load_mdr
       -- <B> <7>
       -- <LineNum> <341>
       -- <LOAD_MDR> <1>
       -- <OriginalLine> <FROM_R:	ena_ptos; setalu A;load_mdr>
       -- <NEXT_ADDRESS> <356>
       -- <ALU> <0>

"00000000110101000110000000010000000000111" when (input = "000001111") else 
    --  15 SLL:	ena_ptos; setalu A; setshifter SLL1; load_ptos; goto Main
       -- <LOAD_TOS> <1>
       -- <LineNum> <828>
       -- <OriginalLine> <SLL:	ena_ptos; setalu A; setshifter SLL1; load_ptos; goto Main>
       -- <B> <7>
       -- <Shifter> <3>
       -- <NEXT_ADDRESS> <53>
       -- <ALU> <0>

"00000101101010000000000000000000100000111" when (input = "000010000") else 
    --  16 RP_FETCH:	ena_ptos; setalu A; load_mdr
       -- <B> <7>
       -- <LineNum> <364>
       -- <LOAD_MDR> <1>
       -- <OriginalLine> <RP_FETCH:	ena_ptos; setalu A; load_mdr>
       -- <NEXT_ADDRESS> <362>
       -- <ALU> <0>

"00000101101101000000100000000010010100100" when (input = "000010001") else 
    --  17 RP_STORE:	ena_psp; setalu DECA; load_psp; load_mar; read
       -- <B> <4>
       -- <READ> <1>
       -- <LOAD_SP> <1>
       -- <LOAD_MAR> <1>
       -- <LineNum> <380>
       -- <OriginalLine> <RP_STORE:	ena_psp; setalu DECA; load_psp; load_mar; read>
       -- <NEXT_ADDRESS> <365>
       -- <ALU> <16>

"00000101101111000000000000000000100000111" when (input = "000010010") else 
    --  18 R_FETCH:	ena_ptos; setalu A; load_mdr
       -- <B> <7>
       -- <LineNum> <396>
       -- <LOAD_MDR> <1>
       -- <OriginalLine> <R_FETCH:	ena_ptos; setalu A; load_mdr>
       -- <NEXT_ADDRESS> <367>
       -- <ALU> <0>

"00000101110010000000000000000000100000111" when (input = "000010011") else 
    --  19 DUP:	ena_ptos; setalu A; load_mdr
       -- <B> <7>
       -- <LineNum> <410>
       -- <LOAD_MDR> <1>
       -- <OriginalLine> <DUP:	ena_ptos; setalu A; load_mdr>
       -- <NEXT_ADDRESS> <370>
       -- <ALU> <0>

"00000101110100000000000000000000100000111" when (input = "000010100") else 
    --  20 SP_FETCH:	ena_ptos; setalu A; load_mdr
       -- <B> <7>
       -- <LineNum> <425>
       -- <LOAD_MDR> <1>
       -- <OriginalLine> <SP_FETCH:	ena_ptos; setalu A; load_mdr>
       -- <NEXT_ADDRESS> <372>
       -- <ALU> <0>

"00000101110111000000100000000000010100100" when (input = "000010101") else 
    --  21 SWAP:	ena_psp; setalu DECA; load_mar; read
       -- <B> <4>
       -- <READ> <1>
       -- <LOAD_MAR> <1>
       -- <LineNum> <439>
       -- <OriginalLine> <SWAP:	ena_psp; setalu DECA; load_mar; read>
       -- <NEXT_ADDRESS> <375>
       -- <ALU> <16>

"00000101111010000000000000000000100000111" when (input = "000010110") else 
    --  22 OVER:	ena_ptos; setalu A; load_mdr
       -- <B> <7>
       -- <LineNum> <484>
       -- <LOAD_MDR> <1>
       -- <OriginalLine> <OVER:	ena_ptos; setalu A; load_mdr>
       -- <NEXT_ADDRESS> <378>
       -- <ALU> <0>

"00000000110101000000000000000010000000111" when (input = "000010111") else 
    --  23 SP_STORE:	ena_ptos; setalu A; load_psp; goto Main
       -- <B> <7>
       -- <LOAD_SP> <1>
       -- <LineNum> <506>
       -- <OriginalLine> <SP_STORE:	ena_ptos; setalu A; load_psp; goto Main>
       -- <NEXT_ADDRESS> <53>
       -- <ALU> <0>

"00000110000000000000100000000010010100100" when (input = "000011000") else 
    --  24 PLUS:	ena_psp; setalu DECA; load_psp; load_mar; read
       -- <B> <4>
       -- <READ> <1>
       -- <LOAD_SP> <1>
       -- <LOAD_MAR> <1>
       -- <LineNum> <518>
       -- <OriginalLine> <PLUS:	ena_psp; setalu DECA; load_psp; load_mar; read>
       -- <NEXT_ADDRESS> <384>
       -- <ALU> <16>

"00000110000010000000100000000010010100100" when (input = "000011001") else 
    --  25 SUB:	ena_psp; setalu DECA; load_psp; load_mar; read
       -- <B> <4>
       -- <READ> <1>
       -- <LOAD_SP> <1>
       -- <LOAD_MAR> <1>
       -- <LineNum> <532>
       -- <OriginalLine> <SUB:	ena_psp; setalu DECA; load_psp; load_mar; read>
       -- <NEXT_ADDRESS> <386>
       -- <ALU> <16>

"00000011111101010000000000000000000000111" when (input = "000011010") else 
    --  26 NEG:	ena_ptos; setalu A; jmpn NEG_TRUE_1 NEG_FALSE_1
       -- <B> <7>
       -- <LineNum> <547>
       -- <JMPN> <1>
       -- <OriginalLine> <NEG:	ena_ptos; setalu A; jmpn NEG_TRUE_1 NEG_FALSE_1>
       -- <NEXT_ADDRESS> <253>
       -- <ALU> <0>

"00000110000100000000100000000010010100100" when (input = "000011011") else 
    --  27 AND:	ena_psp; setalu DECA; load_psp; load_mar; read
       -- <B> <4>
       -- <READ> <1>
       -- <LOAD_SP> <1>
       -- <LOAD_MAR> <1>
       -- <LineNum> <563>
       -- <OriginalLine> <AND:	ena_psp; setalu DECA; load_psp; load_mar; read>
       -- <NEXT_ADDRESS> <388>
       -- <ALU> <16>

"00000110000110000000100000000010010100100" when (input = "000011100") else 
    --  28 OR:	ena_psp; setalu DECA; load_psp; load_mar; read
       -- <B> <4>
       -- <READ> <1>
       -- <LOAD_SP> <1>
       -- <LOAD_MAR> <1>
       -- <LineNum> <575>
       -- <OriginalLine> <OR:	ena_psp; setalu DECA; load_psp; load_mar; read>
       -- <NEXT_ADDRESS> <390>
       -- <ALU> <16>

"00000110001000000000100000000010010100100" when (input = "000011101") else 
    --  29 XOR:	ena_psp; setalu DECA; load_psp; load_mar; read
       -- <B> <4>
       -- <READ> <1>
       -- <LOAD_SP> <1>
       -- <LOAD_MAR> <1>
       -- <LineNum> <588>
       -- <OriginalLine> <XOR:	ena_psp; setalu DECA; load_psp; load_mar; read>
       -- <NEXT_ADDRESS> <392>
       -- <ALU> <16>

"00000110001010000000100000000010010100100" when (input = "000011110") else 
    --  30 MUL:	ena_psp; setalu DECA; load_psp; load_mar; read
       -- <B> <4>
       -- <READ> <1>
       -- <LOAD_SP> <1>
       -- <LOAD_MAR> <1>
       -- <LineNum> <601>
       -- <OriginalLine> <MUL:	ena_psp; setalu DECA; load_psp; load_mar; read>
       -- <NEXT_ADDRESS> <394>
       -- <ALU> <16>

"00000110001100000000100000000010010100100" when (input = "000011111") else 
    --  31 EQUAL:	ena_psp; setalu DECA; load_psp; load_mar; read
       -- <B> <4>
       -- <READ> <1>
       -- <LOAD_SP> <1>
       -- <LOAD_MAR> <1>
       -- <LineNum> <621>
       -- <OriginalLine> <EQUAL:	ena_psp; setalu DECA; load_psp; load_mar; read>
       -- <NEXT_ADDRESS> <396>
       -- <ALU> <16>

"00000110001110000000100000000010010100100" when (input = "000100000") else 
    --  32 UM_PLUS:	ena_psp; setalu DECA; load_psp; load_mar; read
       -- <B> <4>
       -- <READ> <1>
       -- <LOAD_SP> <1>
       -- <LOAD_MAR> <1>
       -- <LineNum> <654>
       -- <OriginalLine> <UM_PLUS:	ena_psp; setalu DECA; load_psp; load_mar; read>
       -- <NEXT_ADDRESS> <398>
       -- <ALU> <16>

"00000110010001000000000001000000010000101" when (input = "000100001") else 
    --  33 JSRINT:	ena_rsp; setalu A; load_mar; load_h
       -- <B> <5>
       -- <LOAD_MAR> <1>
       -- <LineNum> <683>
       -- <OriginalLine> <JSRINT:	ena_rsp; setalu A; load_mar; load_h>
       -- <LOAD_H> <1>
       -- <NEXT_ADDRESS> <401>
       -- <ALU> <0>

"00000110100110000000100000000100010100101" when (input = "000100010") else 
    --  34 RETI:	ena_rsp; setalu DECA; load_rsp; load_mar; read
       -- <B> <5>
       -- <READ> <1>
       -- <LOAD_MAR> <1>
       -- <LOAD_LV> <1>
       -- <LineNum> <753>
       -- <OriginalLine> <RETI:	ena_rsp; setalu DECA; load_rsp; load_mar; read>
       -- <NEXT_ADDRESS> <422>
       -- <ALU> <16>

"00000000110101000000011100100000000000000" when (input = "000100011") else 
    --  35 EI:	setalu ONE; load_intctl_low; goto Main
       -- <LineNum> <804>
       -- <NEXT_ADDRESS> <53>
       -- <ALU> <14>
       -- <OriginalLine> <EI:	setalu ONE; load_intctl_low; goto Main>
       -- <LOAD_OPC> <1>

"00000000110101000100000000010000000000111" when (input = "000100100") else 
    --  36 SRA:	ena_ptos; setalu A; setshifter SRA1; load_ptos; goto Main
       -- <LOAD_TOS> <1>
       -- <LineNum> <821>
       -- <OriginalLine> <SRA:	ena_ptos; setalu A; setshifter SRA1; load_ptos; goto Main>
       -- <B> <7>
       -- <Shifter> <2>
       -- <NEXT_ADDRESS> <53>
       -- <ALU> <0>

"00000000110101000000011010100000000000000" when (input = "000100101") else 
    --  37 DI:	setalu ZERO; load_intctl_low; goto Main
       -- <LineNum> <814>
       -- <NEXT_ADDRESS> <53>
       -- <ALU> <13>
       -- <OriginalLine> <DI:	setalu ZERO; load_intctl_low; goto Main>
       -- <LOAD_OPC> <1>

"00000000110101000000101000010000000000111" when (input = "000100110") else 
    --  38 SRL:	ena_ptos; setalu SRL_A; load_ptos; goto Main
       -- <B> <7>
       -- <LineNum> <835>
       -- <LOAD_TOS> <1>
       -- <OriginalLine> <SRL:	ena_ptos; setalu SRL_A; load_ptos; goto Main>
       -- <NEXT_ADDRESS> <53>
       -- <ALU> <20>

"00000110111110000000100000000010010100100" when (input = "000100111") else 
    --  39 TO_ES:	ena_psp; setalu DECA; load_psp; load_mar; read
       -- <B> <4>
       -- <READ> <1>
       -- <LOAD_SP> <1>
       -- <LOAD_MAR> <1>
       -- <LineNum> <841>
       -- <OriginalLine> <TO_ES:	ena_psp; setalu DECA; load_psp; load_mar; read>
       -- <NEXT_ADDRESS> <446>
       -- <ALU> <16>

"00000111000000000000100000000010010100100" when (input = "000101000") else 
    --  40 TO_DS:	ena_psp; setalu DECA; load_psp; load_mar; read
       -- <B> <4>
       -- <READ> <1>
       -- <LOAD_SP> <1>
       -- <LOAD_MAR> <1>
       -- <LineNum> <850>
       -- <OriginalLine> <TO_DS:	ena_psp; setalu DECA; load_psp; load_mar; read>
       -- <NEXT_ADDRESS> <448>
       -- <ALU> <16>

"00000111000010000000000000000000100000111" when (input = "000101001") else 
    --  41 ES_FETCH:	ena_ptos; setalu A; load_mdr
       -- <B> <7>
       -- <LineNum> <861>
       -- <LOAD_MDR> <1>
       -- <OriginalLine> <ES_FETCH:	ena_ptos; setalu A; load_mdr>
       -- <NEXT_ADDRESS> <450>
       -- <ALU> <0>

"00000111000101000000000000000000100000111" when (input = "000101010") else 
    --  42 DS_FETCH:	ena_ptos; setalu A; load_mdr
       -- <B> <7>
       -- <LineNum> <873>
       -- <LOAD_MDR> <1>
       -- <OriginalLine> <DS_FETCH:	ena_ptos; setalu A; load_mdr>
       -- <NEXT_ADDRESS> <453>
       -- <ALU> <0>

"00000111001000000000000000000000100000111" when (input = "000101011") else 
    --  43 CS_FETCH:	ena_ptos; setalu A; load_mdr
       -- <B> <7>
       -- <LineNum> <885>
       -- <LOAD_MDR> <1>
       -- <OriginalLine> <CS_FETCH:	ena_ptos; setalu A; load_mdr>
       -- <NEXT_ADDRESS> <456>
       -- <ALU> <0>

"10000111001011000000000000000000010100111" when (input = "000101100") else 
    --  44 LONG_FETCH:	ena_ptos; setalu A; load_mar; read; use_es
       -- <B> <7>
       -- <USE_ES> <1>
       -- <READ> <1>
       -- <LOAD_MAR> <1>
       -- <LineNum> <895>
       -- <OriginalLine> <LONG_FETCH:	ena_ptos; setalu A; load_mar; read; use_es>
       -- <NEXT_ADDRESS> <459>
       -- <ALU> <0>

"00000111001101000000100000000010010100100" when (input = "000101101") else 
    --  45 LONG_STORE:	ena_sp; setalu DECA; load_mar; load_sp; read
       -- <B> <4>
       -- <READ> <1>
       -- <LOAD_SP> <1>
       -- <LOAD_MAR> <1>
       -- <LineNum> <909>
       -- <OriginalLine> <LONG_STORE:	ena_sp; setalu DECA; load_mar; load_sp; read>
       -- <NEXT_ADDRESS> <461>
       -- <ALU> <16>

"00000111010001000000000001000000010000101" when (input = "000101110") else 
    --  46 SYSCALL:	ena_rsp; setalu A; load_mar; load_h
       -- <B> <5>
       -- <LOAD_MAR> <1>
       -- <LineNum> <936>
       -- <OriginalLine> <SYSCALL:	ena_rsp; setalu A; load_mar; load_h>
       -- <LOAD_H> <1>
       -- <NEXT_ADDRESS> <465>
       -- <ALU> <0>

"01000111101000000000011010000000000000000" when (input = "000101111") else 
    --  47 K_SP_STORE:	setalu ZERO; load_ds
       -- <LOAD_DS> <1>
       -- <NEXT_ADDRESS> <488>
       -- <ALU> <13>
       -- <OriginalLine> <K_SP_STORE:	setalu ZERO; load_ds>
       -- <LineNum> <1003>

"00000111101001000000000000000000100000111" when (input = "000110000") else 
    --  48 PUSHF:	ena_ptos; setalu A; load_mdr
       -- <B> <7>
       -- <LineNum> <1014>
       -- <LOAD_MDR> <1>
       -- <OriginalLine> <PUSHF:	ena_ptos; setalu A; load_mdr>
       -- <NEXT_ADDRESS> <489>
       -- <ALU> <0>

"00000111101100000000100000000010010100100" when (input = "000110001") else 
    --  49 POPF:	ena_psp; setalu DECA; load_mar; load_sp; read
       -- <B> <4>
       -- <READ> <1>
       -- <LOAD_SP> <1>
       -- <LOAD_MAR> <1>
       -- <LineNum> <1029>
       -- <OriginalLine> <POPF:	ena_psp; setalu DECA; load_mar; load_sp; read>
       -- <NEXT_ADDRESS> <492>
       -- <ALU> <16>

"00000111101110000000100000000010010100100" when (input = "000110010") else 
    --  50 S_LESS:	ena_psp; setalu DECA; load_psp; load_mar; read
       -- <B> <4>
       -- <READ> <1>
       -- <LOAD_SP> <1>
       -- <LOAD_MAR> <1>
       -- <LineNum> <1048>
       -- <OriginalLine> <S_LESS:	ena_psp; setalu DECA; load_psp; load_mar; read>
       -- <NEXT_ADDRESS> <494>
       -- <ALU> <16>

"00000111110000000000000000000000100000111" when (input = "000110011") else 
    --  51 L_VAR:	ena_ptos; setalu A; load_mdr
       -- <B> <7>
       -- <LineNum> <1075>
       -- <LOAD_MDR> <1>
       -- <OriginalLine> <L_VAR:	ena_ptos; setalu A; load_mdr>
       -- <NEXT_ADDRESS> <496>
       -- <ALU> <0>

"00000111110101000000100000000010010100100" when (input = "000110100") else 
    --  52 STORE2:	ena_psp; setalu DECA; load_mar; load_psp; read
       -- <B> <4>
       -- <READ> <1>
       -- <LOAD_SP> <1>
       -- <LOAD_MAR> <1>
       -- <LineNum> <1111>
       -- <OriginalLine> <STORE2:	ena_psp; setalu DECA; load_mar; load_psp; read>
       -- <NEXT_ADDRESS> <501>
       -- <ALU> <16>

"00000000000000100000001100000001000010001" when (input = "000110101") else 
    --  53 Main:	ena_pc; setalu INCA; load_pc; fetch; gotombr
       -- <B> <1>
       -- <LineNum> <13>
       -- <OriginalLine> <Main:	ena_pc; setalu INCA; load_pc; fetch; gotombr>
       -- <NEXT_ADDRESS> <0>
       -- <ALU> <6>
       -- <JMPC> <1>
       -- <FETCH> <1>
       -- <LOAD_PC> <1>

"00000000000000000000000000000000000000000" when (input = "000110110") else 
"00000000000000000000000000000000000000000" when (input = "000110111") else 
"00000000000000000000000000000000000000000" when (input = "000111000") else 
"00000000000000000000000000000000000000000" when (input = "000111001") else 
"00000000000000000000000000000000000000000" when (input = "000111010") else 
"00000000000000000000000000000000000000000" when (input = "000111011") else 
"00000000000000000000000000000000000000000" when (input = "000111100") else 
"00000000000000000000000000000000000000000" when (input = "000111101") else 
"00000000000000000000000000000000000000000" when (input = "000111110") else 
"00000000000000000000000000000000000000000" when (input = "000111111") else 
"00000000000000000000000000000000000000000" when (input = "001000000") else 
"00000000000000000000000000000000000000000" when (input = "001000001") else 
"00000000000000000000000000000000000000000" when (input = "001000010") else 
"00000000000000000000000000000000000000000" when (input = "001000011") else 
"00000000000000000000000000000000000000000" when (input = "001000100") else 
"00000000000000000000000000000000000000000" when (input = "001000101") else 
"00000000000000000000000000000000000000000" when (input = "001000110") else 
"00000000000000000000000000000000000000000" when (input = "001000111") else 
"00000000000000000000000000000000000000000" when (input = "001001000") else 
"00000000000000000000000000000000000000000" when (input = "001001001") else 
"00000000000000000000000000000000000000000" when (input = "001001010") else 
"00000000000000000000000000000000000000000" when (input = "001001011") else 
"00000000000000000000000000000000000000000" when (input = "001001100") else 
"00000000000000000000000000000000000000000" when (input = "001001101") else 
"00000000000000000000000000000000000000000" when (input = "001001110") else 
"00000000000000000000000000000000000000000" when (input = "001001111") else 
"00000000000000000000000000000000000000000" when (input = "001010000") else 
"00000000000000000000000000000000000000000" when (input = "001010001") else 
"00000000000000000000000000000000000000000" when (input = "001010010") else 
"00000000000000000000000000000000000000000" when (input = "001010011") else 
"00000000000000000000000000000000000000000" when (input = "001010100") else 
"00000000000000000000000000000000000000000" when (input = "001010101") else 
"00000000000000000000000000000000000000000" when (input = "001010110") else 
"00000000000000000000000000000000000000000" when (input = "001010111") else 
"00000000000000000000000000000000000000000" when (input = "001011000") else 
"00000000000000000000000000000000000000000" when (input = "001011001") else 
"00000000000000000000000000000000000000000" when (input = "001011010") else 
"00000000000000000000000000000000000000000" when (input = "001011011") else 
"00000000000000000000000000000000000000000" when (input = "001011100") else 
"00000000000000000000000000000000000000000" when (input = "001011101") else 
"00000000000000000000000000000000000000000" when (input = "001011110") else 
"00000000000000000000000000000000000000000" when (input = "001011111") else 
"00000000000000000000000000000000000000000" when (input = "001100000") else 
"00000000000000000000000000000000000000000" when (input = "001100001") else 
"00000000000000000000000000000000000000000" when (input = "001100010") else 
"00000000000000000000000000000000000000000" when (input = "001100011") else 
"00000000000000000000000000000000000000000" when (input = "001100100") else 
"00000000000000000000000000000000000000000" when (input = "001100101") else 
"00000000000000000000000000000000000000000" when (input = "001100110") else 
"00000000000000000000000000000000000000000" when (input = "001100111") else 
"00000000000000000000000000000000000000000" when (input = "001101000") else 
"00000000000000000000000000000000000000000" when (input = "001101001") else 
"00000000000000000000000000000000000000000" when (input = "001101010") else 
"00000000000000000000000000000000000000000" when (input = "001101011") else 
"00000000000000000000000000000000000000000" when (input = "001101100") else 
"00000000000000000000000000000000000000000" when (input = "001101101") else 
"00000000000000000000000000000000000000000" when (input = "001101110") else 
"00000000000000000000000000000000000000000" when (input = "001101111") else 
"00000000000000000000000000000000000000000" when (input = "001110000") else 
"00000000000000000000000000000000000000000" when (input = "001110001") else 
"00000000000000000000000000000000000000000" when (input = "001110010") else 
"00000000000000000000000000000000000000000" when (input = "001110011") else 
"00000000000000000000000000000000000000000" when (input = "001110100") else 
"00000000000000000000000000000000000000000" when (input = "001110101") else 
"00000000000000000000000000000000000000000" when (input = "001110110") else 
"00000000000000000000000000000000000000000" when (input = "001110111") else 
"00000000000000000000000000000000000000000" when (input = "001111000") else 
"00000000000000000000000000000000000000000" when (input = "001111001") else 
"00000000000000000000000000000000000000000" when (input = "001111010") else 
"00000000000000000000000000000000000000000" when (input = "001111011") else 
"00000000000000000000000000000000000000000" when (input = "001111100") else 
"00000000000000000000000000000000000000000" when (input = "001111101") else 
"00000000000000000000000000000000000000000" when (input = "001111110") else 
"00000000000000000000000000000000000000000" when (input = "001111111") else 
"00000000000000000000000000000000000000000" when (input = "010000000") else 
"00000000000000000000000000000000000000000" when (input = "010000001") else 
"00000000000000000000000000000000000000000" when (input = "010000010") else 
"00000000000000000000000000000000000000000" when (input = "010000011") else 
"00000000000000000000000000000000000000000" when (input = "010000100") else 
"00000000000000000000000000000000000000000" when (input = "010000101") else 
"00000000000000000000000000000000000000000" when (input = "010000110") else 
"00000000000000000000000000000000000000000" when (input = "010000111") else 
"00000000000000000000000000000000000000000" when (input = "010001000") else 
"00000000000000000000000000000000000000000" when (input = "010001001") else 
"00000000000000000000000000000000000000000" when (input = "010001010") else 
"00000000000000000000000000000000000000000" when (input = "010001011") else 
"00000000000000000000000000000000000000000" when (input = "010001100") else 
"00000000000000000000000000000000000000000" when (input = "010001101") else 
"00000000000000000000000000000000000000000" when (input = "010001110") else 
"00000000000000000000000000000000000000000" when (input = "010001111") else 
"00000000000000000000000000000000000000000" when (input = "010010000") else 
"00000000000000000000000000000000000000000" when (input = "010010001") else 
"00000000000000000000000000000000000000000" when (input = "010010010") else 
"00000000000000000000000000000000000000000" when (input = "010010011") else 
"00000000000000000000000000000000000000000" when (input = "010010100") else 
"00000000000000000000000000000000000000000" when (input = "010010101") else 
"00000000000000000000000000000000000000000" when (input = "010010110") else 
"00000000000000000000000000000000000000000" when (input = "010010111") else 
"00000000000000000000000000000000000000000" when (input = "010011000") else 
"00000000000000000000000000000000000000000" when (input = "010011001") else 
"00000000000000000000000000000000000000000" when (input = "010011010") else 
"00000000000000000000000000000000000000000" when (input = "010011011") else 
"00000000000000000000000000000000000000000" when (input = "010011100") else 
"00000000000000000000000000000000000000000" when (input = "010011101") else 
"00000000000000000000000000000000000000000" when (input = "010011110") else 
"00000000000000000000000000000000000000000" when (input = "010011111") else 
"00000000000000000000000000000000000000000" when (input = "010100000") else 
"00000000000000000000000000000000000000000" when (input = "010100001") else 
"00000000000000000000000000000000000000000" when (input = "010100010") else 
"00000000000000000000000000000000000000000" when (input = "010100011") else 
"00000000000000000000000000000000000000000" when (input = "010100100") else 
"00000000000000000000000000000000000000000" when (input = "010100101") else 
"00000000000000000000000000000000000000000" when (input = "010100110") else 
"00000000000000000000000000000000000000000" when (input = "010100111") else 
"00000000000000000000000000000000000000000" when (input = "010101000") else 
"00000000000000000000000000000000000000000" when (input = "010101001") else 
"00000000000000000000000000000000000000000" when (input = "010101010") else 
"00000000000000000000000000000000000000000" when (input = "010101011") else 
"00000000000000000000000000000000000000000" when (input = "010101100") else 
"00000000000000000000000000000000000000000" when (input = "010101101") else 
"00000000000000000000000000000000000000000" when (input = "010101110") else 
"00000000000000000000000000000000000000000" when (input = "010101111") else 
"00000000000000000000000000000000000000000" when (input = "010110000") else 
"00000000000000000000000000000000000000000" when (input = "010110001") else 
"00000000000000000000000000000000000000000" when (input = "010110010") else 
"00000000000000000000000000000000000000000" when (input = "010110011") else 
"00000000000000000000000000000000000000000" when (input = "010110100") else 
"00000000000000000000000000000000000000000" when (input = "010110101") else 
"00000000000000000000000000000000000000000" when (input = "010110110") else 
"00000000000000000000000000000000000000000" when (input = "010110111") else 
"00000000000000000000000000000000000000000" when (input = "010111000") else 
"00000000000000000000000000000000000000000" when (input = "010111001") else 
"00000000000000000000000000000000000000000" when (input = "010111010") else 
"00000000000000000000000000000000000000000" when (input = "010111011") else 
"00000000000000000000000000000000000000000" when (input = "010111100") else 
"00000000000000000000000000000000000000000" when (input = "010111101") else 
"00000000000000000000000000000000000000000" when (input = "010111110") else 
"00000000000000000000000000000000000000000" when (input = "010111111") else 
"00000000000000000000000000000000000000000" when (input = "011000000") else 
"00000000000000000000000000000000000000000" when (input = "011000001") else 
"00000000000000000000000000000000000000000" when (input = "011000010") else 
"00000000000000000000000000000000000000000" when (input = "011000011") else 
"00000000000000000000000000000000000000000" when (input = "011000100") else 
"00000000000000000000000000000000000000000" when (input = "011000101") else 
"00000000000000000000000000000000000000000" when (input = "011000110") else 
"00000000000000000000000000000000000000000" when (input = "011000111") else 
"00000000000000000000000000000000000000000" when (input = "011001000") else 
"00000000000000000000000000000000000000000" when (input = "011001001") else 
"00000000000000000000000000000000000000000" when (input = "011001010") else 
"00000000000000000000000000000000000000000" when (input = "011001011") else 
"00000000000000000000000000000000000000000" when (input = "011001100") else 
"00000000000000000000000000000000000000000" when (input = "011001101") else 
"00000000000000000000000000000000000000000" when (input = "011001110") else 
"00000000000000000000000000000000000000000" when (input = "011001111") else 
"00000000000000000000000000000000000000000" when (input = "011010000") else 
"00000000000000000000000000000000000000000" when (input = "011010001") else 
"00000000000000000000000000000000000000000" when (input = "011010010") else 
"00000000000000000000000000000000000000000" when (input = "011010011") else 
"00000000000000000000000000000000000000000" when (input = "011010100") else 
"00000000000000000000000000000000000000000" when (input = "011010101") else 
"00000000000000000000000000000000000000000" when (input = "011010110") else 
"00000000000000000000000000000000000000000" when (input = "011010111") else 
"00000000000000000000000000000000000000000" when (input = "011011000") else 
"00000000000000000000000000000000000000000" when (input = "011011001") else 
"00000000000000000000000000000000000000000" when (input = "011011010") else 
"00000000000000000000000000000000000000000" when (input = "011011011") else 
"00000000000000000000000000000000000000000" when (input = "011011100") else 
"00000000000000000000000000000000000000000" when (input = "011011101") else 
"00000000000000000000000000000000000000000" when (input = "011011110") else 
"00000000000000000000000000000000000000000" when (input = "011011111") else 
"00000000000000000000000000000000000000000" when (input = "011100000") else 
"00000000000000000000000000000000000000000" when (input = "011100001") else 
"00000000000000000000000000000000000000000" when (input = "011100010") else 
"00000000000000000000000000000000000000000" when (input = "011100011") else 
"00000000000000000000000000000000000000000" when (input = "011100100") else 
"00000000000000000000000000000000000000000" when (input = "011100101") else 
"00000000000000000000000000000000000000000" when (input = "011100110") else 
"00000000000000000000000000000000000000000" when (input = "011100111") else 
"00000000000000000000000000000000000000000" when (input = "011101000") else 
"00000000000000000000000000000000000000000" when (input = "011101001") else 
"00000000000000000000000000000000000000000" when (input = "011101010") else 
"00000000000000000000000000000000000000000" when (input = "011101011") else 
"00000000000000000000000000000000000000000" when (input = "011101100") else 
"00000000000000000000000000000000000000000" when (input = "011101101") else 
"00000000000000000000000000000000000000000" when (input = "011101110") else 
"00000000000000000000000000000000000000000" when (input = "011101111") else 
"00000000000000000000000000000000000000000" when (input = "011110000") else 
"00000000000000000000000000000000000000000" when (input = "011110001") else 
"00000000000000000000000000000000000000000" when (input = "011110010") else 
"00000000000000000000000000000000000000000" when (input = "011110011") else 
"00000000000000000000000000000000000000000" when (input = "011110100") else 
"00000000000000000000000000000000000000000" when (input = "011110101") else 
"00000000000000000000000000000000000000000" when (input = "011110110") else 
"00000000000000000000000000000000000000000" when (input = "011110111") else 
"00000000000000000000000000000000000000000" when (input = "011111000") else 
"00000000000000000000000000000000000000000" when (input = "011111001") else 
"00000000000000000000000000000000000000000" when (input = "011111010") else 
"00000000110101000000011010010000000000000" when (input = "011111011") else 
    -- 251 UM_PLUS_FALSE_1:	setalu ZERO; load_ptos; goto Main
       -- <LineNum> <668>
       -- <NEXT_ADDRESS> <53>
       -- <ALU> <13>
       -- <OriginalLine> <UM_PLUS_FALSE_1:	setalu ZERO; load_ptos; goto Main>
       -- <LOAD_TOS> <1>

"00000000110101000000011010010000000000000" when (input = "011111100") else 
    -- 252 EQUAL_FALSE_1:	setalu ZERO; load_ptos; goto Main
       -- <LineNum> <642>
       -- <NEXT_ADDRESS> <53>
       -- <ALU> <13>
       -- <OriginalLine> <EQUAL_FALSE_1:	setalu ZERO; load_ptos; goto Main>
       -- <LOAD_TOS> <1>

"00000000110101000000011010010000000000000" when (input = "011111101") else 
    -- 253 NEG_FALSE_1:	setalu ZERO; load_ptos; goto Main
       -- <LineNum> <551>
       -- <NEXT_ADDRESS> <53>
       -- <ALU> <13>
       -- <OriginalLine> <NEG_FALSE_1:	setalu ZERO; load_ptos; goto Main>
       -- <LOAD_TOS> <1>

"00000101011100000000100000000010010100100" when (input = "011111110") else 
    -- 254 dowhile_false_1:	ena_psp; setalu DECA; load_psp; load_mar; read
       -- <B> <4>
       -- <READ> <1>
       -- <LOAD_SP> <1>
       -- <LOAD_MAR> <1>
       -- <LineNum> <298>
       -- <OriginalLine> <dowhile_false_1:	ena_psp; setalu DECA; load_psp; load_mar; read>
       -- <NEXT_ADDRESS> <348>
       -- <ALU> <16>

"00000000110101000000011010010000000000000" when (input = "011111111") else 
    -- 255 LESS_FALSE_1:	setalu ZERO; load_ptos; goto Main
       -- <LineNum> <146>
       -- <NEXT_ADDRESS> <53>
       -- <ALU> <13>
       -- <OriginalLine> <LESS_FALSE_1:	setalu ZERO; load_ptos; goto Main>
       -- <LOAD_TOS> <1>

"00000000000000000000000000000000000000000" when (input = "100000000") else 
"00000000000000000000000000000000000000000" when (input = "100000001") else 
"00000000000000000000000000000000000000000" when (input = "100000010") else 
"00000000000000000000000000000000000000000" when (input = "100000011") else 
"00000000000000000000000000000000000000000" when (input = "100000100") else 
"00000000000000000000000000000000000000000" when (input = "100000101") else 
"00000000000000000000000000000000000000000" when (input = "100000110") else 
"00000000000000000000000000000000000000000" when (input = "100000111") else 
"00000000000000000000000000000000000000000" when (input = "100001000") else 
"00000000000000000000000000000000000000000" when (input = "100001001") else 
"00000000000000000000000000000000000000000" when (input = "100001010") else 
"00000000000000000000000000000000000000000" when (input = "100001011") else 
"00000000000000000000000000000000000000000" when (input = "100001100") else 
"00000000000000000000000000000000000000000" when (input = "100001101") else 
"00000000000000000000000000000000000000000" when (input = "100001110") else 
"00000000000000000000000000000000000000000" when (input = "100001111") else 
"00000000000000000000000000000000000000000" when (input = "100010000") else 
"00000000000000000000000000000000000000000" when (input = "100010001") else 
"00000000000000000000000000000000000000000" when (input = "100010010") else 
"00000000000000000000000000000000000000000" when (input = "100010011") else 
"00000000000000000000000000000000000000000" when (input = "100010100") else 
"00000000000000000000000000000000000000000" when (input = "100010101") else 
"00000000000000000000000000000000000000000" when (input = "100010110") else 
"00000000000000000000000000000000000000000" when (input = "100010111") else 
"00000000000000000000000000000000000000000" when (input = "100011000") else 
"00000000000000000000000000000000000000000" when (input = "100011001") else 
"00000000000000000000000000000000000000000" when (input = "100011010") else 
"00000000000000000000000000000000000000000" when (input = "100011011") else 
"00000000000000000000000000000000000000000" when (input = "100011100") else 
"00000000000000000000000000000000000000000" when (input = "100011101") else 
"00000000000000000000000000000000000000000" when (input = "100011110") else 
"00000000000000000000000000000000000000000" when (input = "100011111") else 
"00000000000000000000000000000000000000000" when (input = "100100000") else 
"00000000000000000000000000000000000000000" when (input = "100100001") else 
"00000000000000000000000000000000000000000" when (input = "100100010") else 
"00000000000000000000000000000000000000000" when (input = "100100011") else 
"00000000000000000000000000000000000000000" when (input = "100100100") else 
"00000000000000000000000000000000000000000" when (input = "100100101") else 
"00000000000000000000000000000000000000000" when (input = "100100110") else 
"00000000000000000000000000000000000000000" when (input = "100100111") else 
"00000000000000000000000000000000000000000" when (input = "100101000") else 
"00000000000000000000000000000000000000000" when (input = "100101001") else 
"00000000000000000000000000000000000000000" when (input = "100101010") else 
"00000000000000000000000000000000000000000" when (input = "100101011") else 
"00000000000000000000000000000000000000000" when (input = "100101100") else 
"00000000000000000000000000000000000000000" when (input = "100101101") else 
"00000000000000000000000000000000000000000" when (input = "100101110") else 
"00000000000000000000000000000000000000000" when (input = "100101111") else 
"00000000000000000000000000000000000000000" when (input = "100110000") else 
"00000000000000000000000000000000000000000" when (input = "100110001") else 
"00000000000000000000000000000000000000000" when (input = "100110010") else 
"00000000000000000000000000000000000000000" when (input = "100110011") else 
"00000000000000000000000000000000000000000" when (input = "100110100") else 
"00000000000000000000000000000000000000000" when (input = "100110101") else 
"00000000000000000000000000000000000000000" when (input = "100110110") else 
"00000000000000000000000000000000000000000" when (input = "100110111") else 
"00000100111001000000011110000100000000000" when (input = "100111000") else 
    -- 312 	setalu MINUS_1; load_rsp
       -- <LineNum> <31>
       -- <NEXT_ADDRESS> <313>
       -- <ALU> <15>
       -- <OriginalLine> <	setalu MINUS_1; load_rsp>
       -- <LOAD_LV> <1>

"00000100111010000010100000000100000000101" when (input = "100111001") else 
    -- 313 	ena_rsp; setalu DECA; setshifter SLL8; load_rsp
       -- <B> <5>
       -- <LOAD_LV> <1>
       -- <LineNum> <32>
       -- <OriginalLine> <	ena_rsp; setalu DECA; setshifter SLL8; load_rsp>
       -- <Shifter> <1>
       -- <NEXT_ADDRESS> <314>
       -- <ALU> <16>

"00000100111011000000011010000001000010000" when (input = "100111010") else 
    -- 314 	setalu ZERO; load_pc; fetch;
       -- <LineNum> <37>
       -- <OriginalLine> <	setalu ZERO; load_pc; fetch;>
       -- <NEXT_ADDRESS> <315>
       -- <ALU> <13>
       -- <FETCH> <1>
       -- <LOAD_PC> <1>

"00000000110101000000000000000000000000000" when (input = "100111011") else 
    -- 315 	goto Main
       -- <LineNum> <38>
       -- <NEXT_ADDRESS> <53>
       -- <OriginalLine> <	goto Main>

"00000100111101000000000000000000011000100" when (input = "100111100") else 
    -- 316 	ena_psp; setalu A; load_mar; write
       -- <B> <4>
       -- <LOAD_MAR> <1>
       -- <WRITE> <1>
       -- <LineNum> <68>
       -- <OriginalLine> <	ena_psp; setalu A; load_mar; write>
       -- <NEXT_ADDRESS> <317>
       -- <ALU> <0>

"00000100111110000000000000010000000000010" when (input = "100111101") else 
    -- 317 	ena_mbr; setalu A; load_ptos
       -- <B> <2>
       -- <LineNum> <73>
       -- <LOAD_TOS> <1>
       -- <OriginalLine> <	ena_mbr; setalu A; load_ptos>
       -- <NEXT_ADDRESS> <318>
       -- <ALU> <0>

"00000100111111000000001100000001000010001" when (input = "100111110") else 
    -- 318 	ena_pc; setalu INCA; load_pc; fetch
       -- <B> <1>
       -- <LineNum> <78>
       -- <OriginalLine> <	ena_pc; setalu INCA; load_pc; fetch>
       -- <NEXT_ADDRESS> <319>
       -- <ALU> <6>
       -- <FETCH> <1>
       -- <LOAD_PC> <1>

"00000000110101000000001100000010000000100" when (input = "100111111") else 
    -- 319 	ena_psp; setalu INCA; load_psp; goto Main
       -- <B> <4>
       -- <LOAD_SP> <1>
       -- <LineNum> <80>
       -- <OriginalLine> <	ena_psp; setalu INCA; load_psp; goto Main>
       -- <NEXT_ADDRESS> <53>
       -- <ALU> <6>

"00000101000001000000000000000001000010010" when (input = "101000000") else 
    -- 320 	ena_mbr; setalu A; load_pc; fetch
       -- <B> <2>
       -- <LineNum> <101>
       -- <OriginalLine> <	ena_mbr; setalu A; load_pc; fetch>
       -- <NEXT_ADDRESS> <321>
       -- <ALU> <0>
       -- <FETCH> <1>
       -- <LOAD_PC> <1>

"00000000110101000000000000000000000000000" when (input = "101000001") else 
    -- 321 	goto Main
       -- <LineNum> <102>
       -- <NEXT_ADDRESS> <53>
       -- <OriginalLine> <	goto Main>

"00000101000011000000000001000000000000111" when (input = "101000010") else 
    -- 322 	ena_ptos; setalu A; load_h
       -- <B> <7>
       -- <LineNum> <123>
       -- <OriginalLine> <	ena_ptos; setalu A; load_h>
       -- <LOAD_H> <1>
       -- <NEXT_ADDRESS> <323>
       -- <ALU> <0>

"00000101000100000000000000000000000000000" when (input = "101000011") else 
    -- 323 	micronop
       -- <LineNum> <127>
       -- <NEXT_ADDRESS> <324>
       -- <OriginalLine> <	micronop>

"00000101000101000000000000000000000000000" when (input = "101000100") else 
    -- 324 	micronop
       -- <LineNum> <128>
       -- <NEXT_ADDRESS> <325>
       -- <OriginalLine> <	micronop>

"00000011111111010000100100000000000001001" when (input = "101000101") else 
    -- 325 	ena_mdr; setalu A_MINUS_B; jmpn LESS_TRUE_1 LESS_FALSE_1
       -- <B> <9>
       -- <LineNum> <130>
       -- <JMPN> <1>
       -- <OriginalLine> <	ena_mdr; setalu A_MINUS_B; jmpn LESS_TRUE_1 LESS_FALSE_1>
       -- <NEXT_ADDRESS> <255>
       -- <ALU> <18>

"00000101000111000000000000000000000000000" when (input = "101000110") else 
    -- 326 	micronop
       -- <LineNum> <165>
       -- <NEXT_ADDRESS> <327>
       -- <OriginalLine> <	micronop>

"00000101001000000000001100000000101001001" when (input = "101000111") else 
    -- 327 	ena_mdr; setalu INCA; load_mdr; write
       -- <B> <9>
       -- <WRITE> <1>
       -- <LineNum> <166>
       -- <LOAD_MDR> <1>
       -- <OriginalLine> <	ena_mdr; setalu INCA; load_mdr; write>
       -- <NEXT_ADDRESS> <328>
       -- <ALU> <6>

"00000101001001000000100000000010010100100" when (input = "101001000") else 
    -- 328 	ena_psp; setalu DECA; load_mar; load_psp; read
       -- <B> <4>
       -- <READ> <1>
       -- <LOAD_SP> <1>
       -- <LOAD_MAR> <1>
       -- <LineNum> <169>
       -- <OriginalLine> <	ena_psp; setalu DECA; load_mar; load_psp; read>
       -- <NEXT_ADDRESS> <329>
       -- <ALU> <16>

"00000101001010000000000000000000000000000" when (input = "101001001") else 
    -- 329 	micronop
       -- <LineNum> <170>
       -- <NEXT_ADDRESS> <330>
       -- <OriginalLine> <	micronop>

"00000000110101000000000000010000000001001" when (input = "101001010") else 
    -- 330 	ena_mdr; setalu A; load_ptos; goto Main
       -- <B> <9>
       -- <LineNum> <171>
       -- <LOAD_TOS> <1>
       -- <OriginalLine> <	ena_mdr; setalu A; load_ptos; goto Main>
       -- <NEXT_ADDRESS> <53>
       -- <ALU> <0>

"00000101001100000000000000000000000000000" when (input = "101001011") else 
    -- 331 	micronop
       -- <LineNum> <186>
       -- <NEXT_ADDRESS> <332>
       -- <OriginalLine> <	micronop>

"00000000110101000000000000010000000001001" when (input = "101001100") else 
    -- 332 	ena_mdr; setalu A; load_ptos; goto Main
       -- <B> <9>
       -- <LineNum> <188>
       -- <LOAD_TOS> <1>
       -- <OriginalLine> <	ena_mdr; setalu A; load_ptos; goto Main>
       -- <NEXT_ADDRESS> <53>
       -- <ALU> <0>

"00000101001110000000000000000000011000111" when (input = "101001101") else 
    -- 333 	ena_tos; setalu A; load_mar; write
       -- <B> <7>
       -- <LOAD_MAR> <1>
       -- <WRITE> <1>
       -- <LineNum> <209>
       -- <OriginalLine> <	ena_tos; setalu A; load_mar; write>
       -- <NEXT_ADDRESS> <334>
       -- <ALU> <0>

"00000101001111000000100000000010010100100" when (input = "101001110") else 
    -- 334 	ena_psp; setalu DECA; load_mar; load_psp; read
       -- <B> <4>
       -- <READ> <1>
       -- <LOAD_SP> <1>
       -- <LOAD_MAR> <1>
       -- <LineNum> <212>
       -- <OriginalLine> <	ena_psp; setalu DECA; load_mar; load_psp; read>
       -- <NEXT_ADDRESS> <335>
       -- <ALU> <16>

"00000101010000000000000000000000000000000" when (input = "101001111") else 
    -- 335 	micronop
       -- <LineNum> <213>
       -- <NEXT_ADDRESS> <336>
       -- <OriginalLine> <	micronop>

"00000000110101000000000000010000000001001" when (input = "101010000") else 
    -- 336 	ena_mdr; setalu A; load_ptos; goto Main
       -- <B> <9>
       -- <LineNum> <214>
       -- <LOAD_TOS> <1>
       -- <OriginalLine> <	ena_mdr; setalu A; load_ptos; goto Main>
       -- <NEXT_ADDRESS> <53>
       -- <ALU> <0>

"00000101010010000000000000000000000000000" when (input = "101010001") else 
    -- 337 	micronop
       -- <LineNum> <228>
       -- <NEXT_ADDRESS> <338>
       -- <OriginalLine> <	micronop>

"00000000110101000000000000010000000001001" when (input = "101010010") else 
    -- 338 	ena_mdr; setalu A; load_ptos; goto Main
       -- <B> <9>
       -- <LineNum> <229>
       -- <LOAD_TOS> <1>
       -- <OriginalLine> <	ena_mdr; setalu A; load_ptos; goto Main>
       -- <NEXT_ADDRESS> <53>
       -- <ALU> <0>

"00000101010100000000000000000000011000101" when (input = "101010011") else 
    -- 339 	ena_rsp; setalu A; load_mar; write
       -- <B> <5>
       -- <LOAD_MAR> <1>
       -- <WRITE> <1>
       -- <LineNum> <245>
       -- <OriginalLine> <	ena_rsp; setalu A; load_mar; write>
       -- <NEXT_ADDRESS> <340>
       -- <ALU> <0>

"00000101010101000000001100000100000000101" when (input = "101010100") else 
    -- 340 	ena_rsp; setalu INCA; load_rsp
       -- <B> <5>
       -- <LOAD_LV> <1>
       -- <LineNum> <246>
       -- <OriginalLine> <	ena_rsp; setalu INCA; load_rsp>
       -- <NEXT_ADDRESS> <341>
       -- <ALU> <6>

"00000101010110000000001100001000000000001" when (input = "101010101") else 
    -- 341 	ena_pc; setalu INCA; load_rtos
       -- <LOAD_CPP> <1>
       -- <B> <1>
       -- <LineNum> <252>
       -- <OriginalLine> <	ena_pc; setalu INCA; load_rtos>
       -- <NEXT_ADDRESS> <342>
       -- <ALU> <6>

"00000101010111000000000000000001000010010" when (input = "101010110") else 
    -- 342 	ena_mbr; setalu A; load_pc; fetch
       -- <B> <2>
       -- <LineNum> <257>
       -- <OriginalLine> <	ena_mbr; setalu A; load_pc; fetch>
       -- <NEXT_ADDRESS> <343>
       -- <ALU> <0>
       -- <FETCH> <1>
       -- <LOAD_PC> <1>

"00000000110101000000000000000000000000000" when (input = "101010111") else 
    -- 343 	goto Main
       -- <LineNum> <258>
       -- <NEXT_ADDRESS> <53>
       -- <OriginalLine> <	goto Main>

"00000101011001000000000000000001000010110" when (input = "101011000") else 
    -- 344 	ena_rtos; setalu A; load_pc; fetch
       -- <B> <6>
       -- <LineNum> <272>
       -- <OriginalLine> <	ena_rtos; setalu A; load_pc; fetch>
       -- <NEXT_ADDRESS> <345>
       -- <ALU> <0>
       -- <FETCH> <1>
       -- <LOAD_PC> <1>

"00000000110101000000000000001000000001001" when (input = "101011001") else 
    -- 345 	ena_mdr; setalu A; load_rtos; goto Main
       -- <LOAD_CPP> <1>
       -- <B> <9>
       -- <LineNum> <273>
       -- <OriginalLine> <	ena_mdr; setalu A; load_rtos; goto Main>
       -- <NEXT_ADDRESS> <53>
       -- <ALU> <0>

"00000101011011000000000000000001000010010" when (input = "101011010") else 
    -- 346 	ena_mbr; setalu A; load_pc; fetch
       -- <B> <2>
       -- <LineNum> <293>
       -- <OriginalLine> <	ena_mbr; setalu A; load_pc; fetch>
       -- <NEXT_ADDRESS> <347>
       -- <ALU> <0>
       -- <FETCH> <1>
       -- <LOAD_PC> <1>

"00000000110101000000000000010000000001001" when (input = "101011011") else 
    -- 347 	ena_mdr; setalu A; load_ptos; goto Main
       -- <B> <9>
       -- <LineNum> <294>
       -- <LOAD_TOS> <1>
       -- <OriginalLine> <	ena_mdr; setalu A; load_ptos; goto Main>
       -- <NEXT_ADDRESS> <53>
       -- <ALU> <0>

"00000101011101000000001100000001000010001" when (input = "101011100") else 
    -- 348 	ena_pc; setalu INCA; load_pc; fetch
       -- <B> <1>
       -- <LineNum> <299>
       -- <OriginalLine> <	ena_pc; setalu INCA; load_pc; fetch>
       -- <NEXT_ADDRESS> <349>
       -- <ALU> <6>
       -- <FETCH> <1>
       -- <LOAD_PC> <1>

"00000000110101000000000000010000000001001" when (input = "101011101") else 
    -- 349 	ena_mdr; setalu A; load_ptos; goto Main
       -- <B> <9>
       -- <LineNum> <300>
       -- <LOAD_TOS> <1>
       -- <OriginalLine> <	ena_mdr; setalu A; load_ptos; goto Main>
       -- <NEXT_ADDRESS> <53>
       -- <ALU> <0>

"00000101011111000000000000000000011000101" when (input = "101011110") else 
    -- 350 	ena_rsp; setalu A; load_mar; write
       -- <B> <5>
       -- <LOAD_MAR> <1>
       -- <WRITE> <1>
       -- <LineNum> <318>
       -- <OriginalLine> <	ena_rsp; setalu A; load_mar; write>
       -- <NEXT_ADDRESS> <351>
       -- <ALU> <0>

"00000101100000000000001100000100000000101" when (input = "101011111") else 
    -- 351 	ena_rsp; setalu INCA; load_rsp
       -- <B> <5>
       -- <LOAD_LV> <1>
       -- <LineNum> <319>
       -- <OriginalLine> <	ena_rsp; setalu INCA; load_rsp>
       -- <NEXT_ADDRESS> <352>
       -- <ALU> <6>

"00000101100001000000000000001000000000111" when (input = "101100000") else 
    -- 352 	ena_ptos; setalu A; load_rtos
       -- <LOAD_CPP> <1>
       -- <B> <7>
       -- <LineNum> <321>
       -- <OriginalLine> <	ena_ptos; setalu A; load_rtos>
       -- <NEXT_ADDRESS> <353>
       -- <ALU> <0>

"00000101100010000000100000000010010100100" when (input = "101100001") else 
    -- 353 	ena_psp; setalu DECA; load_psp; load_mar; read
       -- <B> <4>
       -- <READ> <1>
       -- <LOAD_SP> <1>
       -- <LOAD_MAR> <1>
       -- <LineNum> <324>
       -- <OriginalLine> <	ena_psp; setalu DECA; load_psp; load_mar; read>
       -- <NEXT_ADDRESS> <354>
       -- <ALU> <16>

"00000101100011000000000000000000000000000" when (input = "101100010") else 
    -- 354 	micronop
       -- <LineNum> <325>
       -- <NEXT_ADDRESS> <355>
       -- <OriginalLine> <	micronop>

"00000000110101000000000000010000000001001" when (input = "101100011") else 
    -- 355 	ena_mdr; setalu A; load_ptos; goto Main
       -- <B> <9>
       -- <LineNum> <326>
       -- <LOAD_TOS> <1>
       -- <OriginalLine> <	ena_mdr; setalu A; load_ptos; goto Main>
       -- <NEXT_ADDRESS> <53>
       -- <ALU> <0>

"00000101100101000000000000000000011000100" when (input = "101100100") else 
    -- 356 	ena_psp; setalu A; load_mar; write
       -- <B> <4>
       -- <LOAD_MAR> <1>
       -- <WRITE> <1>
       -- <LineNum> <342>
       -- <OriginalLine> <	ena_psp; setalu A; load_mar; write>
       -- <NEXT_ADDRESS> <357>
       -- <ALU> <0>

"00000101100110000000001100000010000000100" when (input = "101100101") else 
    -- 357 	ena_psp; setalu INCA; load_psp
       -- <B> <4>
       -- <LOAD_SP> <1>
       -- <LineNum> <343>
       -- <OriginalLine> <	ena_psp; setalu INCA; load_psp>
       -- <NEXT_ADDRESS> <358>
       -- <ALU> <6>

"00000101100111000000000000010000000000110" when (input = "101100110") else 
    -- 358 	ena_rtos; setalu A; load_ptos
       -- <B> <6>
       -- <LineNum> <345>
       -- <LOAD_TOS> <1>
       -- <OriginalLine> <	ena_rtos; setalu A; load_ptos>
       -- <NEXT_ADDRESS> <359>
       -- <ALU> <0>

"00000101101000000000100000000100010100101" when (input = "101100111") else 
    -- 359 	ena_rsp; setalu DECA; load_rsp; load_mar; read
       -- <B> <5>
       -- <READ> <1>
       -- <LOAD_MAR> <1>
       -- <LOAD_LV> <1>
       -- <LineNum> <348>
       -- <OriginalLine> <	ena_rsp; setalu DECA; load_rsp; load_mar; read>
       -- <NEXT_ADDRESS> <360>
       -- <ALU> <16>

"00000101101001000000000000000000000000000" when (input = "101101000") else 
    -- 360 	micronop
       -- <LineNum> <349>
       -- <NEXT_ADDRESS> <361>
       -- <OriginalLine> <	micronop>

"00000000110101000000000000001000000001001" when (input = "101101001") else 
    -- 361 	ena_mdr; setalu A; load_rtos; goto Main
       -- <LOAD_CPP> <1>
       -- <B> <9>
       -- <LineNum> <350>
       -- <OriginalLine> <	ena_mdr; setalu A; load_rtos; goto Main>
       -- <NEXT_ADDRESS> <53>
       -- <ALU> <0>

"00000101101011000000000000000000011000100" when (input = "101101010") else 
    -- 362 	ena_psp; setalu A; load_mar; write
       -- <B> <4>
       -- <LOAD_MAR> <1>
       -- <WRITE> <1>
       -- <LineNum> <365>
       -- <OriginalLine> <	ena_psp; setalu A; load_mar; write>
       -- <NEXT_ADDRESS> <363>
       -- <ALU> <0>

"00000101101100000000000000010000000000101" when (input = "101101011") else 
    -- 363 	ena_rsp; setalu A; load_ptos
       -- <B> <5>
       -- <LineNum> <366>
       -- <LOAD_TOS> <1>
       -- <OriginalLine> <	ena_rsp; setalu A; load_ptos>
       -- <NEXT_ADDRESS> <364>
       -- <ALU> <0>

"00000000110101000000001100000010000000100" when (input = "101101100") else 
    -- 364 	ena_psp; setalu INCA; load_psp; goto Main
       -- <B> <4>
       -- <LOAD_SP> <1>
       -- <LineNum> <367>
       -- <OriginalLine> <	ena_psp; setalu INCA; load_psp; goto Main>
       -- <NEXT_ADDRESS> <53>
       -- <ALU> <6>

"00000101101110000000000000000100000000111" when (input = "101101101") else 
    -- 365 	ena_ptos; setalu A; load_rsp
       -- <B> <7>
       -- <LOAD_LV> <1>
       -- <LineNum> <381>
       -- <OriginalLine> <	ena_ptos; setalu A; load_rsp>
       -- <NEXT_ADDRESS> <366>
       -- <ALU> <0>

"00000000110101000000000000010000000001001" when (input = "101101110") else 
    -- 366 	ena_mdr; setalu A; load_ptos; goto Main
       -- <B> <9>
       -- <LineNum> <382>
       -- <LOAD_TOS> <1>
       -- <OriginalLine> <	ena_mdr; setalu A; load_ptos; goto Main>
       -- <NEXT_ADDRESS> <53>
       -- <ALU> <0>

"00000101110000000000000000000000011000100" when (input = "101101111") else 
    -- 367 	ena_psp; setalu A; load_mar; write
       -- <B> <4>
       -- <LOAD_MAR> <1>
       -- <WRITE> <1>
       -- <LineNum> <397>
       -- <OriginalLine> <	ena_psp; setalu A; load_mar; write>
       -- <NEXT_ADDRESS> <368>
       -- <ALU> <0>

"00000101110001000000001100000010000000100" when (input = "101110000") else 
    -- 368 	ena_psp; setalu INCA; load_psp
       -- <B> <4>
       -- <LOAD_SP> <1>
       -- <LineNum> <398>
       -- <OriginalLine> <	ena_psp; setalu INCA; load_psp>
       -- <NEXT_ADDRESS> <369>
       -- <ALU> <6>

"00000000110101000000000000010000000000110" when (input = "101110001") else 
    -- 369 	ena_rtos; setalu A; load_ptos; goto Main
       -- <B> <6>
       -- <LineNum> <399>
       -- <LOAD_TOS> <1>
       -- <OriginalLine> <	ena_rtos; setalu A; load_ptos; goto Main>
       -- <NEXT_ADDRESS> <53>
       -- <ALU> <0>

"00000101110011000000000000000000011000100" when (input = "101110010") else 
    -- 370 	ena_psp; setalu A; load_mar; write
       -- <B> <4>
       -- <LOAD_MAR> <1>
       -- <WRITE> <1>
       -- <LineNum> <411>
       -- <OriginalLine> <	ena_psp; setalu A; load_mar; write>
       -- <NEXT_ADDRESS> <371>
       -- <ALU> <0>

"00000000110101000000001100000010000000100" when (input = "101110011") else 
    -- 371 	ena_psp; setalu INCA; load_psp; goto Main
       -- <B> <4>
       -- <LOAD_SP> <1>
       -- <LineNum> <412>
       -- <OriginalLine> <	ena_psp; setalu INCA; load_psp; goto Main>
       -- <NEXT_ADDRESS> <53>
       -- <ALU> <6>

"00000101110101000000000000000000011000100" when (input = "101110100") else 
    -- 372 	ena_psp; setalu A; load_mar; write
       -- <B> <4>
       -- <LOAD_MAR> <1>
       -- <WRITE> <1>
       -- <LineNum> <426>
       -- <OriginalLine> <	ena_psp; setalu A; load_mar; write>
       -- <NEXT_ADDRESS> <373>
       -- <ALU> <0>

"00000101110110000000000000010000000000100" when (input = "101110101") else 
    -- 373 	ena_psp; setalu A; load_ptos
       -- <B> <4>
       -- <LineNum> <427>
       -- <LOAD_TOS> <1>
       -- <OriginalLine> <	ena_psp; setalu A; load_ptos>
       -- <NEXT_ADDRESS> <374>
       -- <ALU> <0>

"00000000110101000000001100000010000000100" when (input = "101110110") else 
    -- 374 	ena_psp; setalu INCA; load_psp; goto Main
       -- <B> <4>
       -- <LOAD_SP> <1>
       -- <LineNum> <428>
       -- <OriginalLine> <	ena_psp; setalu INCA; load_psp; goto Main>
       -- <NEXT_ADDRESS> <53>
       -- <ALU> <6>

"00000101111000000000000001000000000000111" when (input = "101110111") else 
    -- 375 	ena_ptos; setalu A; load_h
       -- <B> <7>
       -- <LineNum> <440>
       -- <OriginalLine> <	ena_ptos; setalu A; load_h>
       -- <LOAD_H> <1>
       -- <NEXT_ADDRESS> <376>
       -- <ALU> <0>

"00000101111001000000000000010000000001001" when (input = "101111000") else 
    -- 376 	ena_mdr; setalu A; load_ptos;
       -- <B> <9>
       -- <LineNum> <441>
       -- <LOAD_TOS> <1>
       -- <OriginalLine> <	ena_mdr; setalu A; load_ptos;>
       -- <NEXT_ADDRESS> <377>
       -- <ALU> <0>

"00000000110101000000000010000000101000000" when (input = "101111001") else 
    -- 377 	setalu B; load_mdr; write; goto Main
       -- <WRITE> <1>
       -- <LineNum> <445>
       -- <LOAD_MDR> <1>
       -- <OriginalLine> <	setalu B; load_mdr; write; goto Main>
       -- <NEXT_ADDRESS> <53>
       -- <ALU> <1>

"00000101111011000000000000000000011000100" when (input = "101111010") else 
    -- 378 	ena_psp; setalu A; load_mar; write
       -- <B> <4>
       -- <LOAD_MAR> <1>
       -- <WRITE> <1>
       -- <LineNum> <485>
       -- <OriginalLine> <	ena_psp; setalu A; load_mar; write>
       -- <NEXT_ADDRESS> <379>
       -- <ALU> <0>

"00000101111100000000100000000000010100100" when (input = "101111011") else 
    -- 379 	ena_psp; setalu DECA; load_mar; read
       -- <B> <4>
       -- <READ> <1>
       -- <LOAD_MAR> <1>
       -- <LineNum> <489>
       -- <OriginalLine> <	ena_psp; setalu DECA; load_mar; read>
       -- <NEXT_ADDRESS> <380>
       -- <ALU> <16>

"00000101111101000000001100000010000000100" when (input = "101111100") else 
    -- 380 	ena_psp; setalu INCA; load_psp
       -- <B> <4>
       -- <LOAD_SP> <1>
       -- <LineNum> <490>
       -- <OriginalLine> <	ena_psp; setalu INCA; load_psp>
       -- <NEXT_ADDRESS> <381>
       -- <ALU> <6>

"00000101111110000000000000010000000001001" when (input = "101111101") else 
    -- 381 	ena_mdr; setalu A; load_ptos
       -- <B> <9>
       -- <LineNum> <491>
       -- <LOAD_TOS> <1>
       -- <OriginalLine> <	ena_mdr; setalu A; load_ptos>
       -- <NEXT_ADDRESS> <382>
       -- <ALU> <0>

"00000101111111000000000000000000000000000" when (input = "101111110") else 
    -- 382 	micronop
       -- <LineNum> <493>
       -- <NEXT_ADDRESS> <383>
       -- <OriginalLine> <	micronop>

"00000000110101000000000000000000000000000" when (input = "101111111") else 
    -- 383 	goto Main
       -- <LineNum> <495>
       -- <NEXT_ADDRESS> <53>
       -- <OriginalLine> <	goto Main>

"00000110000001000000000001000000000000111" when (input = "110000000") else 
    -- 384 	ena_ptos; setalu A; load_h
       -- <B> <7>
       -- <LineNum> <519>
       -- <OriginalLine> <	ena_ptos; setalu A; load_h>
       -- <LOAD_H> <1>
       -- <NEXT_ADDRESS> <385>
       -- <ALU> <0>

"00000000110101000000001000010000000001001" when (input = "110000001") else 
    -- 385 	ena_mdr; setalu ADD; load_ptos; goto Main
       -- <B> <9>
       -- <LineNum> <520>
       -- <LOAD_TOS> <1>
       -- <OriginalLine> <	ena_mdr; setalu ADD; load_ptos; goto Main>
       -- <NEXT_ADDRESS> <53>
       -- <ALU> <4>

"00000110000011000000000001000000000000111" when (input = "110000010") else 
    -- 386 	ena_ptos; setalu A; load_h
       -- <B> <7>
       -- <LineNum> <533>
       -- <OriginalLine> <	ena_ptos; setalu A; load_h>
       -- <LOAD_H> <1>
       -- <NEXT_ADDRESS> <387>
       -- <ALU> <0>

"00000000110101000000100100010000000001001" when (input = "110000011") else 
    -- 387 	ena_mdr; setalu A_MINUS_B; load_ptos; goto Main
       -- <B> <9>
       -- <LineNum> <534>
       -- <LOAD_TOS> <1>
       -- <OriginalLine> <	ena_mdr; setalu A_MINUS_B; load_ptos; goto Main>
       -- <NEXT_ADDRESS> <53>
       -- <ALU> <18>

"00000110000101000000000001000000000000111" when (input = "110000100") else 
    -- 388 	ena_ptos; setalu A; load_h
       -- <B> <7>
       -- <LineNum> <564>
       -- <OriginalLine> <	ena_ptos; setalu A; load_h>
       -- <LOAD_H> <1>
       -- <NEXT_ADDRESS> <389>
       -- <ALU> <0>

"00000000110101000000010110010000000001001" when (input = "110000101") else 
    -- 389 	ena_mdr; setalu A_AND_B; load_ptos; goto Main
       -- <B> <9>
       -- <LineNum> <565>
       -- <LOAD_TOS> <1>
       -- <OriginalLine> <	ena_mdr; setalu A_AND_B; load_ptos; goto Main>
       -- <NEXT_ADDRESS> <53>
       -- <ALU> <11>

"00000110000111000000000001000000000000111" when (input = "110000110") else 
    -- 390 	ena_ptos; setalu A; load_h
       -- <B> <7>
       -- <LineNum> <576>
       -- <OriginalLine> <	ena_ptos; setalu A; load_h>
       -- <LOAD_H> <1>
       -- <NEXT_ADDRESS> <391>
       -- <ALU> <0>

"00000000110101000000011000010000000001001" when (input = "110000111") else 
    -- 391 	ena_mdr; setalu A_OR_B; load_ptos; goto Main
       -- <B> <9>
       -- <LineNum> <577>
       -- <LOAD_TOS> <1>
       -- <OriginalLine> <	ena_mdr; setalu A_OR_B; load_ptos; goto Main>
       -- <NEXT_ADDRESS> <53>
       -- <ALU> <12>

"00000110001001000000000001000000000000111" when (input = "110001000") else 
    -- 392 	ena_ptos; setalu A; load_h
       -- <B> <7>
       -- <LineNum> <589>
       -- <OriginalLine> <	ena_ptos; setalu A; load_h>
       -- <LOAD_H> <1>
       -- <NEXT_ADDRESS> <393>
       -- <ALU> <0>

"00000000110101000000100010010000000001001" when (input = "110001001") else 
    -- 393 	ena_mdr; setalu A_XOR_B; load_ptos; goto Main
       -- <B> <9>
       -- <LineNum> <590>
       -- <LOAD_TOS> <1>
       -- <OriginalLine> <	ena_mdr; setalu A_XOR_B; load_ptos; goto Main>
       -- <NEXT_ADDRESS> <53>
       -- <ALU> <17>

"00000110001011000000000001000000000000111" when (input = "110001010") else 
    -- 394 	ena_ptos; setalu A; load_h
       -- <B> <7>
       -- <LineNum> <602>
       -- <OriginalLine> <	ena_ptos; setalu A; load_h>
       -- <LOAD_H> <1>
       -- <NEXT_ADDRESS> <395>
       -- <ALU> <0>

"00000000110101000000100110010000000001001" when (input = "110001011") else 
    -- 395 	ena_mdr; setalu A_MUL_B; load_ptos; goto Main
       -- <B> <9>
       -- <LineNum> <603>
       -- <LOAD_TOS> <1>
       -- <OriginalLine> <	ena_mdr; setalu A_MUL_B; load_ptos; goto Main>
       -- <NEXT_ADDRESS> <53>
       -- <ALU> <19>

"00000110001101000000000001000000000000111" when (input = "110001100") else 
    -- 396 	ena_ptos; setalu A; load_h
       -- <B> <7>
       -- <LineNum> <622>
       -- <OriginalLine> <	ena_ptos; setalu A; load_h>
       -- <LOAD_H> <1>
       -- <NEXT_ADDRESS> <397>
       -- <ALU> <0>

"00000011111100001000010000000000000001001" when (input = "110001101") else 
    -- 397 	ena_mdr; setalu B_MINUS_A; jmpz EQUAL_TRUE_1 EQUAL_FALSE_1
       -- <B> <9>
       -- <JMPZ> <1>
       -- <LineNum> <627>
       -- <OriginalLine> <	ena_mdr; setalu B_MINUS_A; jmpz EQUAL_TRUE_1 EQUAL_FALSE_1>
       -- <NEXT_ADDRESS> <252>
       -- <ALU> <8>

"00000110001111000000000001000000000000111" when (input = "110001110") else 
    -- 398 	ena_ptos; setalu A; load_h
       -- <B> <7>
       -- <LineNum> <655>
       -- <OriginalLine> <	ena_ptos; setalu A; load_h>
       -- <LOAD_H> <1>
       -- <NEXT_ADDRESS> <399>
       -- <ALU> <0>

"00000110010000000000001100000010000000100" when (input = "110001111") else 
    -- 399 	ena_psp; setalu INCA; load_psp;
       -- <B> <4>
       -- <LOAD_SP> <1>
       -- <LineNum> <656>
       -- <OriginalLine> <	ena_psp; setalu INCA; load_psp;>
       -- <NEXT_ADDRESS> <400>
       -- <ALU> <6>

"00001011111011000000001000000000101001001" when (input = "110010000") else 
    -- 400 	ena_mdr; setalu ADD; load_mdr; write; jmpy UM_PLUS_TRUE_1 UM_PLUS_FALSE_1
       -- <B> <9>
       -- <JMPY> <1>
       -- <WRITE> <1>
       -- <LineNum> <657>
       -- <LOAD_MDR> <1>
       -- <OriginalLine> <	ena_mdr; setalu ADD; load_mdr; write; jmpy UM_PLUS_TRUE_1 UM_PLUS_FALSE_1>
       -- <NEXT_ADDRESS> <251>
       -- <ALU> <4>

"00000110010010000000000000000000101001011" when (input = "110010001") else 
    -- 401 	ena_ds; setalu A; load_mdr; write
       -- <B> <11>
       -- <WRITE> <1>
       -- <LineNum> <684>
       -- <LOAD_MDR> <1>
       -- <OriginalLine> <	ena_ds; setalu A; load_mdr; write>
       -- <NEXT_ADDRESS> <402>
       -- <ALU> <0>

"00000110010011000000001100000100010000101" when (input = "110010010") else 
    -- 402 	ena_rsp; setalu INCA; load_rsp; load_mar
       -- <B> <5>
       -- <LOAD_MAR> <1>
       -- <LOAD_LV> <1>
       -- <LineNum> <687>
       -- <OriginalLine> <	ena_rsp; setalu INCA; load_rsp; load_mar>
       -- <NEXT_ADDRESS> <403>
       -- <ALU> <6>

"00000110010100000000000000000000101001000" when (input = "110010011") else 
    -- 403 	ena_cs; setalu A; load_mdr; write
       -- <B> <8>
       -- <WRITE> <1>
       -- <LineNum> <688>
       -- <LOAD_MDR> <1>
       -- <OriginalLine> <	ena_cs; setalu A; load_mdr; write>
       -- <NEXT_ADDRESS> <404>
       -- <ALU> <0>

"00000110010101000000001100000100010000101" when (input = "110010100") else 
    -- 404 	ena_rsp; setalu INCA; load_rsp; load_mar
       -- <B> <5>
       -- <LOAD_MAR> <1>
       -- <LOAD_LV> <1>
       -- <LineNum> <691>
       -- <OriginalLine> <	ena_rsp; setalu INCA; load_rsp; load_mar>
       -- <NEXT_ADDRESS> <405>
       -- <ALU> <6>

"00000110010110000000000000000000101000011" when (input = "110010101") else 
    -- 405 	ena_es; setalu A; load_mdr; write
       -- <B> <3>
       -- <WRITE> <1>
       -- <LineNum> <692>
       -- <LOAD_MDR> <1>
       -- <OriginalLine> <	ena_es; setalu A; load_mdr; write>
       -- <NEXT_ADDRESS> <406>
       -- <ALU> <0>

"00000110010111000000001100000100010000101" when (input = "110010110") else 
    -- 406 	ena_rsp; setalu INCA; load_rsp; load_mar
       -- <B> <5>
       -- <LOAD_MAR> <1>
       -- <LOAD_LV> <1>
       -- <LineNum> <695>
       -- <OriginalLine> <	ena_rsp; setalu INCA; load_rsp; load_mar>
       -- <NEXT_ADDRESS> <407>
       -- <ALU> <6>

"00000110011000000000000000000000101000100" when (input = "110010111") else 
    -- 407 	ena_psp; setalu A; load_mdr; write
       -- <B> <4>
       -- <WRITE> <1>
       -- <LineNum> <696>
       -- <LOAD_MDR> <1>
       -- <OriginalLine> <	ena_psp; setalu A; load_mdr; write>
       -- <NEXT_ADDRESS> <408>
       -- <ALU> <0>

"00000110011001000000001100000100010000101" when (input = "110011000") else 
    -- 408 	ena_rsp; setalu INCA; load_rsp; load_mar
       -- <B> <5>
       -- <LOAD_MAR> <1>
       -- <LOAD_LV> <1>
       -- <LineNum> <699>
       -- <OriginalLine> <	ena_rsp; setalu INCA; load_rsp; load_mar>
       -- <NEXT_ADDRESS> <409>
       -- <ALU> <6>

"00000110011010000000000000000000101000111" when (input = "110011001") else 
    -- 409 	ena_ptos; setalu A; load_mdr; write
       -- <B> <7>
       -- <WRITE> <1>
       -- <LineNum> <700>
       -- <LOAD_MDR> <1>
       -- <OriginalLine> <	ena_ptos; setalu A; load_mdr; write>
       -- <NEXT_ADDRESS> <410>
       -- <ALU> <0>

"00000110011011000000001100000100010000101" when (input = "110011010") else 
    -- 410 	ena_rsp; setalu INCA; load_rsp; load_mar
       -- <B> <5>
       -- <LOAD_MAR> <1>
       -- <LOAD_LV> <1>
       -- <LineNum> <705>
       -- <OriginalLine> <	ena_rsp; setalu INCA; load_rsp; load_mar>
       -- <NEXT_ADDRESS> <411>
       -- <ALU> <6>

"00000110011100000000100000000000101000001" when (input = "110011011") else 
    -- 411 	ena_pc; setalu DECA; load_mdr; write
       -- <B> <1>
       -- <WRITE> <1>
       -- <LineNum> <706>
       -- <LOAD_MDR> <1>
       -- <OriginalLine> <	ena_pc; setalu DECA; load_mdr; write>
       -- <NEXT_ADDRESS> <412>
       -- <ALU> <16>

"00000110011101000000001100000100010000101" when (input = "110011100") else 
    -- 412 	ena_rsp; setalu INCA; load_rsp; load_mar
       -- <B> <5>
       -- <LOAD_MAR> <1>
       -- <LOAD_LV> <1>
       -- <LineNum> <709>
       -- <OriginalLine> <	ena_rsp; setalu INCA; load_rsp; load_mar>
       -- <NEXT_ADDRESS> <413>
       -- <ALU> <6>

"00000110011110000000000000000000101001010" when (input = "110011101") else 
    -- 413 	ena_intctl; setalu A; load_mdr; write
       -- <B> <10>
       -- <WRITE> <1>
       -- <LineNum> <710>
       -- <LOAD_MDR> <1>
       -- <OriginalLine> <	ena_intctl; setalu A; load_mdr; write>
       -- <NEXT_ADDRESS> <414>
       -- <ALU> <0>

"00000110011111000000001100000100010000101" when (input = "110011110") else 
    -- 414 	ena_rsp; setalu INCA; load_rsp; load_mar
       -- <B> <5>
       -- <LOAD_MAR> <1>
       -- <LOAD_LV> <1>
       -- <LineNum> <716>
       -- <OriginalLine> <	ena_rsp; setalu INCA; load_rsp; load_mar>
       -- <NEXT_ADDRESS> <415>
       -- <ALU> <6>

"00000110100000000000000010000000101000000" when (input = "110011111") else 
    -- 415 	setalu B; load_mdr; write
       -- <WRITE> <1>
       -- <LineNum> <717>
       -- <LOAD_MDR> <1>
       -- <OriginalLine> <	setalu B; load_mdr; write>
       -- <NEXT_ADDRESS> <416>
       -- <ALU> <1>

"00000110100001000000001100000100000000101" when (input = "110100000") else 
    -- 416 	ena_rsp; setalu INCA; load_rsp
       -- <B> <5>
       -- <LOAD_LV> <1>
       -- <LineNum> <719>
       -- <OriginalLine> <	ena_rsp; setalu INCA; load_rsp>
       -- <NEXT_ADDRESS> <417>
       -- <ALU> <6>

"00110110100010000000011010000000000000000" when (input = "110100001") else 
    -- 417 	setalu ZERO; load_cs; load_es
       -- <LOAD_ES> <1>
       -- <LineNum> <728>
       -- <OriginalLine> <	setalu ZERO; load_cs; load_es>
       -- <NEXT_ADDRESS> <418>
       -- <ALU> <13>
       -- <LOAD_CS> <1>

"00000110100011000000011110000001000000000" when (input = "110100010") else 
    -- 418 	setalu MINUS_1; load_pc
       -- <LineNum> <730>
       -- <NEXT_ADDRESS> <419>
       -- <ALU> <15>
       -- <OriginalLine> <	setalu MINUS_1; load_pc>
       -- <LOAD_PC> <1>

"00000110100100000000100000000001000000001" when (input = "110100011") else 
    -- 419 	ena_pc; setalu DECA; load_pc
       -- <B> <1>
       -- <LineNum> <731>
       -- <OriginalLine> <	ena_pc; setalu DECA; load_pc>
       -- <NEXT_ADDRESS> <420>
       -- <ALU> <16>
       -- <LOAD_PC> <1>

"00000110100101000010100000000001000010001" when (input = "110100100") else 
    -- 420 	ena_pc; setalu DECA; setshifter SLL8; load_pc; fetch
       -- <B> <1>
       -- <LineNum> <732>
       -- <OriginalLine> <	ena_pc; setalu DECA; setshifter SLL8; load_pc; fetch>
       -- <Shifter> <1>
       -- <NEXT_ADDRESS> <421>
       -- <ALU> <16>
       -- <FETCH> <1>
       -- <LOAD_PC> <1>

"00000000110101000000011010100000000000000" when (input = "110100101") else 
    -- 421 	setalu ZERO; load_intctl_low; goto Main
       -- <LineNum> <737>
       -- <NEXT_ADDRESS> <53>
       -- <ALU> <13>
       -- <OriginalLine> <	setalu ZERO; load_intctl_low; goto Main>
       -- <LOAD_OPC> <1>

"00000110100111000000000000000000000000000" when (input = "110100110") else 
    -- 422 	micronop;
       -- <LineNum> <754>
       -- <NEXT_ADDRESS> <423>
       -- <OriginalLine> <	micronop;>

"00000110101000000000000001000000000001001" when (input = "110100111") else 
    -- 423 	ena_mdr; setalu A; load_h
       -- <B> <9>
       -- <LineNum> <755>
       -- <OriginalLine> <	ena_mdr; setalu A; load_h>
       -- <LOAD_H> <1>
       -- <NEXT_ADDRESS> <424>
       -- <ALU> <0>

"00000110101001000000100000000100010100101" when (input = "110101000") else 
    -- 424 	ena_rsp; setalu DECA; load_rsp; load_mar; read
       -- <B> <5>
       -- <READ> <1>
       -- <LOAD_MAR> <1>
       -- <LOAD_LV> <1>
       -- <LineNum> <758>
       -- <OriginalLine> <	ena_rsp; setalu DECA; load_rsp; load_mar; read>
       -- <NEXT_ADDRESS> <425>
       -- <ALU> <16>

"00000110101010000000000000000000000000000" when (input = "110101001") else 
    -- 425 	micronop;
       -- <LineNum> <759>
       -- <NEXT_ADDRESS> <426>
       -- <OriginalLine> <	micronop;>

"00000110101011000000000000100000000001001" when (input = "110101010") else 
    -- 426 	ena_mdr; setalu A; load_intctl_low
       -- <B> <9>
       -- <LineNum> <760>
       -- <OriginalLine> <	ena_mdr; setalu A; load_intctl_low>
       -- <NEXT_ADDRESS> <427>
       -- <ALU> <0>
       -- <LOAD_OPC> <1>

"00000110101100000000100000000100010100101" when (input = "110101011") else 
    -- 427 	ena_rsp; setalu DECA; load_rsp; load_mar; read
       -- <B> <5>
       -- <READ> <1>
       -- <LOAD_MAR> <1>
       -- <LOAD_LV> <1>
       -- <LineNum> <763>
       -- <OriginalLine> <	ena_rsp; setalu DECA; load_rsp; load_mar; read>
       -- <NEXT_ADDRESS> <428>
       -- <ALU> <16>

"00000110101101000000000000000000000000000" when (input = "110101100") else 
    -- 428 	micronop;
       -- <LineNum> <764>
       -- <NEXT_ADDRESS> <429>
       -- <OriginalLine> <	micronop;>

"00000110101110000000000000000001000001001" when (input = "110101101") else 
    -- 429 	ena_mdr; setalu A; load_pc
       -- <B> <9>
       -- <LineNum> <765>
       -- <OriginalLine> <	ena_mdr; setalu A; load_pc>
       -- <NEXT_ADDRESS> <430>
       -- <ALU> <0>
       -- <LOAD_PC> <1>

"00000110101111000000100000000100010100101" when (input = "110101110") else 
    -- 430 	ena_rsp; setalu DECA; load_rsp; load_mar; read
       -- <B> <5>
       -- <READ> <1>
       -- <LOAD_MAR> <1>
       -- <LOAD_LV> <1>
       -- <LineNum> <768>
       -- <OriginalLine> <	ena_rsp; setalu DECA; load_rsp; load_mar; read>
       -- <NEXT_ADDRESS> <431>
       -- <ALU> <16>

"00000110110000000000000000000000000000000" when (input = "110101111") else 
    -- 431 	micronop;
       -- <LineNum> <769>
       -- <NEXT_ADDRESS> <432>
       -- <OriginalLine> <	micronop;>

"00000110110001000000000000010000000001001" when (input = "110110000") else 
    -- 432 	ena_mdr; setalu A; load_ptos
       -- <B> <9>
       -- <LineNum> <770>
       -- <LOAD_TOS> <1>
       -- <OriginalLine> <	ena_mdr; setalu A; load_ptos>
       -- <NEXT_ADDRESS> <433>
       -- <ALU> <0>

"00000110110010000000100000000100010100101" when (input = "110110001") else 
    -- 433 	ena_rsp; setalu DECA; load_rsp; load_mar; read
       -- <B> <5>
       -- <READ> <1>
       -- <LOAD_MAR> <1>
       -- <LOAD_LV> <1>
       -- <LineNum> <773>
       -- <OriginalLine> <	ena_rsp; setalu DECA; load_rsp; load_mar; read>
       -- <NEXT_ADDRESS> <434>
       -- <ALU> <16>

"00000110110011000000000000000000000000000" when (input = "110110010") else 
    -- 434 	micronop;
       -- <LineNum> <774>
       -- <NEXT_ADDRESS> <435>
       -- <OriginalLine> <	micronop;>

"00000110110100000000000000000010000001001" when (input = "110110011") else 
    -- 435 	ena_mdr; setalu A; load_psp
       -- <B> <9>
       -- <LOAD_SP> <1>
       -- <LineNum> <775>
       -- <OriginalLine> <	ena_mdr; setalu A; load_psp>
       -- <NEXT_ADDRESS> <436>
       -- <ALU> <0>

"00000110110101000000100000000100010100101" when (input = "110110100") else 
    -- 436 	ena_rsp; setalu DECA; load_rsp; load_mar; read
       -- <B> <5>
       -- <READ> <1>
       -- <LOAD_MAR> <1>
       -- <LOAD_LV> <1>
       -- <LineNum> <778>
       -- <OriginalLine> <	ena_rsp; setalu DECA; load_rsp; load_mar; read>
       -- <NEXT_ADDRESS> <437>
       -- <ALU> <16>

"00000110110110000000000000000000000000000" when (input = "110110101") else 
    -- 437 	micronop;
       -- <LineNum> <779>
       -- <NEXT_ADDRESS> <438>
       -- <OriginalLine> <	micronop;>

"00010110110111000000000000000000000001001" when (input = "110110110") else 
    -- 438 	ena_mdr; setalu A; load_es
       -- <LOAD_ES> <1>
       -- <B> <9>
       -- <LineNum> <780>
       -- <OriginalLine> <	ena_mdr; setalu A; load_es>
       -- <NEXT_ADDRESS> <439>
       -- <ALU> <0>

"00000110111000000000100000000100010100101" when (input = "110110111") else 
    -- 439 	ena_rsp; setalu DECA; load_rsp; load_mar; read
       -- <B> <5>
       -- <READ> <1>
       -- <LOAD_MAR> <1>
       -- <LOAD_LV> <1>
       -- <LineNum> <783>
       -- <OriginalLine> <	ena_rsp; setalu DECA; load_rsp; load_mar; read>
       -- <NEXT_ADDRESS> <440>
       -- <ALU> <16>

"00000110111001000000000000000000000000000" when (input = "110111000") else 
    -- 440 	micronop;
       -- <LineNum> <784>
       -- <NEXT_ADDRESS> <441>
       -- <OriginalLine> <	micronop;>

"00100110111010000000000000000000000001001" when (input = "110111001") else 
    -- 441 	ena_mdr; setalu A; load_cs
       -- <B> <9>
       -- <LineNum> <785>
       -- <OriginalLine> <	ena_mdr; setalu A; load_cs>
       -- <NEXT_ADDRESS> <442>
       -- <ALU> <0>
       -- <LOAD_CS> <1>

"00000110111011000000100000000100010100101" when (input = "110111010") else 
    -- 442 	ena_rsp; setalu DECA; load_rsp; load_mar; read
       -- <B> <5>
       -- <READ> <1>
       -- <LOAD_MAR> <1>
       -- <LOAD_LV> <1>
       -- <LineNum> <788>
       -- <OriginalLine> <	ena_rsp; setalu DECA; load_rsp; load_mar; read>
       -- <NEXT_ADDRESS> <443>
       -- <ALU> <16>

"00000110111100000000000000000000000000000" when (input = "110111011") else 
    -- 443 	micronop;
       -- <LineNum> <789>
       -- <NEXT_ADDRESS> <444>
       -- <OriginalLine> <	micronop;>

"01000110111101000000000000000000000011001" when (input = "110111100") else 
    -- 444 	ena_mdr; setalu A; load_ds; fetch
       -- <LOAD_DS> <1>
       -- <LineNum> <790>
       -- <OriginalLine> <	ena_mdr; setalu A; load_ds; fetch>
       -- <B> <9>
       -- <NEXT_ADDRESS> <445>
       -- <ALU> <0>
       -- <FETCH> <1>

"00000000110101000000000010000100000000000" when (input = "110111101") else 
    -- 445 	setalu B; load_rsp; goto Main
       -- <LineNum> <792>
       -- <NEXT_ADDRESS> <53>
       -- <ALU> <1>
       -- <OriginalLine> <	setalu B; load_rsp; goto Main>
       -- <LOAD_LV> <1>

"00010110111111000000000000000000000000111" when (input = "110111110") else 
    -- 446 	ena_ptos; setalu A; load_es
       -- <LOAD_ES> <1>
       -- <B> <7>
       -- <LineNum> <842>
       -- <OriginalLine> <	ena_ptos; setalu A; load_es>
       -- <NEXT_ADDRESS> <447>
       -- <ALU> <0>

"00000000110101000000000000010000000001001" when (input = "110111111") else 
    -- 447 	ena_mdr; setalu A; load_ptos; goto Main
       -- <B> <9>
       -- <LineNum> <843>
       -- <LOAD_TOS> <1>
       -- <OriginalLine> <	ena_mdr; setalu A; load_ptos; goto Main>
       -- <NEXT_ADDRESS> <53>
       -- <ALU> <0>

"01000111000001000000000000000000000000111" when (input = "111000000") else 
    -- 448 	ena_ptos; setalu A; load_ds
       -- <LOAD_DS> <1>
       -- <LineNum> <851>
       -- <OriginalLine> <	ena_ptos; setalu A; load_ds>
       -- <B> <7>
       -- <NEXT_ADDRESS> <449>
       -- <ALU> <0>

"00000000110101000000000000010000000001001" when (input = "111000001") else 
    -- 449 	ena_mdr; setalu A; load_ptos; goto Main
       -- <B> <9>
       -- <LineNum> <852>
       -- <LOAD_TOS> <1>
       -- <OriginalLine> <	ena_mdr; setalu A; load_ptos; goto Main>
       -- <NEXT_ADDRESS> <53>
       -- <ALU> <0>

"00000111000011000000000000000000011000100" when (input = "111000010") else 
    -- 450 	ena_psp; setalu A; load_mar; write
       -- <B> <4>
       -- <LOAD_MAR> <1>
       -- <WRITE> <1>
       -- <LineNum> <862>
       -- <OriginalLine> <	ena_psp; setalu A; load_mar; write>
       -- <NEXT_ADDRESS> <451>
       -- <ALU> <0>

"00000111000100000000001100000010000000100" when (input = "111000011") else 
    -- 451 	ena_psp; setalu INCA; load_psp
       -- <B> <4>
       -- <LOAD_SP> <1>
       -- <LineNum> <863>
       -- <OriginalLine> <	ena_psp; setalu INCA; load_psp>
       -- <NEXT_ADDRESS> <452>
       -- <ALU> <6>

"00000000110101000000000000010000000000011" when (input = "111000100") else 
    -- 452 	ena_es; setalu A; load_ptos; goto Main
       -- <B> <3>
       -- <LineNum> <864>
       -- <LOAD_TOS> <1>
       -- <OriginalLine> <	ena_es; setalu A; load_ptos; goto Main>
       -- <NEXT_ADDRESS> <53>
       -- <ALU> <0>

"00000111000110000000000000000000011000100" when (input = "111000101") else 
    -- 453 	ena_psp; setalu A; load_mar; write
       -- <B> <4>
       -- <LOAD_MAR> <1>
       -- <WRITE> <1>
       -- <LineNum> <874>
       -- <OriginalLine> <	ena_psp; setalu A; load_mar; write>
       -- <NEXT_ADDRESS> <454>
       -- <ALU> <0>

"00000111000111000000001100000010000000100" when (input = "111000110") else 
    -- 454 	ena_psp; setalu INCA; load_psp
       -- <B> <4>
       -- <LOAD_SP> <1>
       -- <LineNum> <875>
       -- <OriginalLine> <	ena_psp; setalu INCA; load_psp>
       -- <NEXT_ADDRESS> <455>
       -- <ALU> <6>

"00000000110101000000000000010000000001011" when (input = "111000111") else 
    -- 455 	ena_ds; setalu A; load_ptos; goto Main
       -- <B> <11>
       -- <LineNum> <876>
       -- <LOAD_TOS> <1>
       -- <OriginalLine> <	ena_ds; setalu A; load_ptos; goto Main>
       -- <NEXT_ADDRESS> <53>
       -- <ALU> <0>

"00000111001001000000000000000000011000100" when (input = "111001000") else 
    -- 456 	ena_psp; setalu A; load_mar; write
       -- <B> <4>
       -- <LOAD_MAR> <1>
       -- <WRITE> <1>
       -- <LineNum> <886>
       -- <OriginalLine> <	ena_psp; setalu A; load_mar; write>
       -- <NEXT_ADDRESS> <457>
       -- <ALU> <0>

"00000111001010000000001100000010000000100" when (input = "111001001") else 
    -- 457 	ena_psp; setalu INCA; load_psp
       -- <B> <4>
       -- <LOAD_SP> <1>
       -- <LineNum> <887>
       -- <OriginalLine> <	ena_psp; setalu INCA; load_psp>
       -- <NEXT_ADDRESS> <458>
       -- <ALU> <6>

"00000000110101000000000000010000000001000" when (input = "111001010") else 
    -- 458 	ena_cs; setalu A; load_ptos; goto Main
       -- <B> <8>
       -- <LineNum> <888>
       -- <LOAD_TOS> <1>
       -- <OriginalLine> <	ena_cs; setalu A; load_ptos; goto Main>
       -- <NEXT_ADDRESS> <53>
       -- <ALU> <0>

"00000111001100000000000000000000000000000" when (input = "111001011") else 
    -- 459 	micronop
       -- <LineNum> <896>
       -- <NEXT_ADDRESS> <460>
       -- <OriginalLine> <	micronop>

"00000000110101000000000000010000000001001" when (input = "111001100") else 
    -- 460 	ena_mdr; setalu A; load_ptos; goto Main
       -- <B> <9>
       -- <LineNum> <897>
       -- <LOAD_TOS> <1>
       -- <OriginalLine> <	ena_mdr; setalu A; load_ptos; goto Main>
       -- <NEXT_ADDRESS> <53>
       -- <ALU> <0>

"10000111001110000000000000000000011000111" when (input = "111001101") else 
    -- 461 	ena_tos; setalu A; load_mar; write; use_es
       -- <B> <7>
       -- <USE_ES> <1>
       -- <LOAD_MAR> <1>
       -- <WRITE> <1>
       -- <LineNum> <915>
       -- <OriginalLine> <	ena_tos; setalu A; load_mar; write; use_es>
       -- <NEXT_ADDRESS> <462>
       -- <ALU> <0>

"00000111001111000000100000000010010100100" when (input = "111001110") else 
    -- 462 	ena_psp; setalu DECA; load_mar; load_psp; read
       -- <B> <4>
       -- <READ> <1>
       -- <LOAD_SP> <1>
       -- <LOAD_MAR> <1>
       -- <LineNum> <918>
       -- <OriginalLine> <	ena_psp; setalu DECA; load_mar; load_psp; read>
       -- <NEXT_ADDRESS> <463>
       -- <ALU> <16>

"00000111010000000000000000000000000000000" when (input = "111001111") else 
    -- 463 	micronop
       -- <LineNum> <919>
       -- <NEXT_ADDRESS> <464>
       -- <OriginalLine> <	micronop>

"00000000110101000000000000010000000001001" when (input = "111010000") else 
    -- 464 	ena_mdr; setalu A; load_ptos; goto Main
       -- <B> <9>
       -- <LineNum> <920>
       -- <LOAD_TOS> <1>
       -- <OriginalLine> <	ena_mdr; setalu A; load_ptos; goto Main>
       -- <NEXT_ADDRESS> <53>
       -- <ALU> <0>

"00000111010010000000000000000000101001011" when (input = "111010001") else 
    -- 465 	ena_ds; setalu A; load_mdr; write
       -- <B> <11>
       -- <WRITE> <1>
       -- <LineNum> <937>
       -- <LOAD_MDR> <1>
       -- <OriginalLine> <	ena_ds; setalu A; load_mdr; write>
       -- <NEXT_ADDRESS> <466>
       -- <ALU> <0>

"00000111010011000000001100000100010000101" when (input = "111010010") else 
    -- 466 	ena_rsp; setalu INCA; load_rsp; load_mar
       -- <B> <5>
       -- <LOAD_MAR> <1>
       -- <LOAD_LV> <1>
       -- <LineNum> <940>
       -- <OriginalLine> <	ena_rsp; setalu INCA; load_rsp; load_mar>
       -- <NEXT_ADDRESS> <467>
       -- <ALU> <6>

"00000111010100000000000000000000101001000" when (input = "111010011") else 
    -- 467 	ena_cs; setalu A; load_mdr; write
       -- <B> <8>
       -- <WRITE> <1>
       -- <LineNum> <941>
       -- <LOAD_MDR> <1>
       -- <OriginalLine> <	ena_cs; setalu A; load_mdr; write>
       -- <NEXT_ADDRESS> <468>
       -- <ALU> <0>

"00000111010101000000001100000100010000101" when (input = "111010100") else 
    -- 468 	ena_rsp; setalu INCA; load_rsp; load_mar
       -- <B> <5>
       -- <LOAD_MAR> <1>
       -- <LOAD_LV> <1>
       -- <LineNum> <944>
       -- <OriginalLine> <	ena_rsp; setalu INCA; load_rsp; load_mar>
       -- <NEXT_ADDRESS> <469>
       -- <ALU> <6>

"00000111010110000000000000000000101000011" when (input = "111010101") else 
    -- 469 	ena_es; setalu A; load_mdr; write
       -- <B> <3>
       -- <WRITE> <1>
       -- <LineNum> <945>
       -- <LOAD_MDR> <1>
       -- <OriginalLine> <	ena_es; setalu A; load_mdr; write>
       -- <NEXT_ADDRESS> <470>
       -- <ALU> <0>

"00000111010111000000001100000100010000101" when (input = "111010110") else 
    -- 470 	ena_rsp; setalu INCA; load_rsp; load_mar
       -- <B> <5>
       -- <LOAD_MAR> <1>
       -- <LOAD_LV> <1>
       -- <LineNum> <948>
       -- <OriginalLine> <	ena_rsp; setalu INCA; load_rsp; load_mar>
       -- <NEXT_ADDRESS> <471>
       -- <ALU> <6>

"00000111011000000000000000000000101000100" when (input = "111010111") else 
    -- 471 	ena_psp; setalu A; load_mdr; write
       -- <B> <4>
       -- <WRITE> <1>
       -- <LineNum> <949>
       -- <LOAD_MDR> <1>
       -- <OriginalLine> <	ena_psp; setalu A; load_mdr; write>
       -- <NEXT_ADDRESS> <472>
       -- <ALU> <0>

"00000111011001000000001100000100010000101" when (input = "111011000") else 
    -- 472 	ena_rsp; setalu INCA; load_rsp; load_mar
       -- <B> <5>
       -- <LOAD_MAR> <1>
       -- <LOAD_LV> <1>
       -- <LineNum> <952>
       -- <OriginalLine> <	ena_rsp; setalu INCA; load_rsp; load_mar>
       -- <NEXT_ADDRESS> <473>
       -- <ALU> <6>

"00000111011010000000000000000000101000111" when (input = "111011001") else 
    -- 473 	ena_ptos; setalu A; load_mdr; write
       -- <B> <7>
       -- <WRITE> <1>
       -- <LineNum> <953>
       -- <LOAD_MDR> <1>
       -- <OriginalLine> <	ena_ptos; setalu A; load_mdr; write>
       -- <NEXT_ADDRESS> <474>
       -- <ALU> <0>

"00000111011011000000001100000100010000101" when (input = "111011010") else 
    -- 474 	ena_rsp; setalu INCA; load_rsp; load_mar
       -- <B> <5>
       -- <LOAD_MAR> <1>
       -- <LOAD_LV> <1>
       -- <LineNum> <956>
       -- <OriginalLine> <	ena_rsp; setalu INCA; load_rsp; load_mar>
       -- <NEXT_ADDRESS> <475>
       -- <ALU> <6>

"00000111011100000000000000000000101000001" when (input = "111011011") else 
    -- 475 	ena_pc; setalu A; load_mdr; write
       -- <B> <1>
       -- <WRITE> <1>
       -- <LineNum> <957>
       -- <LOAD_MDR> <1>
       -- <OriginalLine> <	ena_pc; setalu A; load_mdr; write>
       -- <NEXT_ADDRESS> <476>
       -- <ALU> <0>

"00000111011101000000001100000100010000101" when (input = "111011100") else 
    -- 476 	ena_rsp; setalu INCA; load_rsp; load_mar
       -- <B> <5>
       -- <LOAD_MAR> <1>
       -- <LOAD_LV> <1>
       -- <LineNum> <960>
       -- <OriginalLine> <	ena_rsp; setalu INCA; load_rsp; load_mar>
       -- <NEXT_ADDRESS> <477>
       -- <ALU> <6>

"00000111011110000000000000000000101001010" when (input = "111011101") else 
    -- 477 	ena_intctl; setalu A; load_mdr; write
       -- <B> <10>
       -- <WRITE> <1>
       -- <LineNum> <961>
       -- <LOAD_MDR> <1>
       -- <OriginalLine> <	ena_intctl; setalu A; load_mdr; write>
       -- <NEXT_ADDRESS> <478>
       -- <ALU> <0>

"00000111011111000000001100000100010000101" when (input = "111011110") else 
    -- 478 	ena_rsp; setalu INCA; load_rsp; load_mar
       -- <B> <5>
       -- <LOAD_MAR> <1>
       -- <LOAD_LV> <1>
       -- <LineNum> <967>
       -- <OriginalLine> <	ena_rsp; setalu INCA; load_rsp; load_mar>
       -- <NEXT_ADDRESS> <479>
       -- <ALU> <6>

"00000111100000000000000010000000101000000" when (input = "111011111") else 
    -- 479 	setalu B; load_mdr; write
       -- <WRITE> <1>
       -- <LineNum> <968>
       -- <LOAD_MDR> <1>
       -- <OriginalLine> <	setalu B; load_mdr; write>
       -- <NEXT_ADDRESS> <480>
       -- <ALU> <1>

"00000111100001000000001100000100000000101" when (input = "111100000") else 
    -- 480 	ena_rsp; setalu INCA; load_rsp
       -- <B> <5>
       -- <LOAD_LV> <1>
       -- <LineNum> <970>
       -- <OriginalLine> <	ena_rsp; setalu INCA; load_rsp>
       -- <NEXT_ADDRESS> <481>
       -- <ALU> <6>

"00110111100010000000011010000000000000000" when (input = "111100001") else 
    -- 481 	setalu ZERO; load_cs; load_es
       -- <LOAD_ES> <1>
       -- <LineNum> <979>
       -- <OriginalLine> <	setalu ZERO; load_cs; load_es>
       -- <NEXT_ADDRESS> <482>
       -- <ALU> <13>
       -- <LOAD_CS> <1>

"00000111100011000000011110000001000000000" when (input = "111100010") else 
    -- 482 	setalu MINUS_1; load_pc
       -- <LineNum> <981>
       -- <NEXT_ADDRESS> <483>
       -- <ALU> <15>
       -- <OriginalLine> <	setalu MINUS_1; load_pc>
       -- <LOAD_PC> <1>

"00000111100100000000100000000001000000001" when (input = "111100011") else 
    -- 483 	ena_pc; setalu DECA; load_pc
       -- <B> <1>
       -- <LineNum> <982>
       -- <OriginalLine> <	ena_pc; setalu DECA; load_pc>
       -- <NEXT_ADDRESS> <484>
       -- <ALU> <16>
       -- <LOAD_PC> <1>

"00000111100101000010100000000001000000001" when (input = "111100100") else 
    -- 484 	ena_pc; setalu DECA; setshifter SLL8; load_pc
       -- <B> <1>
       -- <LineNum> <983>
       -- <OriginalLine> <	ena_pc; setalu DECA; setshifter SLL8; load_pc>
       -- <Shifter> <1>
       -- <NEXT_ADDRESS> <485>
       -- <ALU> <16>
       -- <LOAD_PC> <1>

"00000111100110000000001100000001000000001" when (input = "111100101") else 
    -- 485 	ena_pc; setalu INCA; load_pc
       -- <B> <1>
       -- <LineNum> <985>
       -- <OriginalLine> <	ena_pc; setalu INCA; load_pc>
       -- <NEXT_ADDRESS> <486>
       -- <ALU> <6>
       -- <LOAD_PC> <1>

"00000111100111000000001100000001000010001" when (input = "111100110") else 
    -- 486 	ena_pc; setalu INCA; load_pc; fetch
       -- <B> <1>
       -- <LineNum> <986>
       -- <OriginalLine> <	ena_pc; setalu INCA; load_pc; fetch>
       -- <NEXT_ADDRESS> <487>
       -- <ALU> <6>
       -- <FETCH> <1>
       -- <LOAD_PC> <1>

"00000000110101000000011010100000000000000" when (input = "111100111") else 
    -- 487 	setalu ZERO; load_intctl_low; goto Main
       -- <LineNum> <991>
       -- <NEXT_ADDRESS> <53>
       -- <ALU> <13>
       -- <OriginalLine> <	setalu ZERO; load_intctl_low; goto Main>
       -- <LOAD_OPC> <1>

"00000000110101000000000000000010000000111" when (input = "111101000") else 
    -- 488 	ena_ptos; setalu A; load_psp; goto Main
       -- <B> <7>
       -- <LOAD_SP> <1>
       -- <LineNum> <1004>
       -- <OriginalLine> <	ena_ptos; setalu A; load_psp; goto Main>
       -- <NEXT_ADDRESS> <53>
       -- <ALU> <0>

"00000111101010000000000000000000011000100" when (input = "111101001") else 
    -- 489 	ena_psp; setalu A; load_mar; write
       -- <B> <4>
       -- <LOAD_MAR> <1>
       -- <WRITE> <1>
       -- <LineNum> <1015>
       -- <OriginalLine> <	ena_psp; setalu A; load_mar; write>
       -- <NEXT_ADDRESS> <490>
       -- <ALU> <0>

"00000111101011000000000000010000000001010" when (input = "111101010") else 
    -- 490 	ena_intctl; setalu A; load_ptos
       -- <B> <10>
       -- <LineNum> <1017>
       -- <LOAD_TOS> <1>
       -- <OriginalLine> <	ena_intctl; setalu A; load_ptos>
       -- <NEXT_ADDRESS> <491>
       -- <ALU> <0>

"00000000110101000000001100000010000000100" when (input = "111101011") else 
    -- 491 	ena_psp; setalu INCA; load_psp; goto Main
       -- <B> <4>
       -- <LOAD_SP> <1>
       -- <LineNum> <1019>
       -- <OriginalLine> <	ena_psp; setalu INCA; load_psp; goto Main>
       -- <NEXT_ADDRESS> <53>
       -- <ALU> <6>

"00000111101101000000000000100000000000111" when (input = "111101100") else 
    -- 492 	ena_ptos; setalu A; load_intctl_low
       -- <B> <7>
       -- <LineNum> <1031>
       -- <OriginalLine> <	ena_ptos; setalu A; load_intctl_low>
       -- <NEXT_ADDRESS> <493>
       -- <ALU> <0>
       -- <LOAD_OPC> <1>

"00000000110101000000000000010000000001001" when (input = "111101101") else 
    -- 493 	ena_mdr; setalu A; load_ptos; goto Main
       -- <B> <9>
       -- <LineNum> <1033>
       -- <LOAD_TOS> <1>
       -- <OriginalLine> <	ena_mdr; setalu A; load_ptos; goto Main>
       -- <NEXT_ADDRESS> <53>
       -- <ALU> <0>

"00000111101111000000000001000000000000111" when (input = "111101110") else 
    -- 494 	ena_ptos; setalu A; load_h
       -- <B> <7>
       -- <LineNum> <1051>
       -- <OriginalLine> <	ena_ptos; setalu A; load_h>
       -- <LOAD_H> <1>
       -- <NEXT_ADDRESS> <495>
       -- <ALU> <0>

"00000000110101000000101010010000000001001" when (input = "111101111") else 
    -- 495 	ena_mdr; setalu S_LESS; load_ptos; goto Main
       -- <B> <9>
       -- <LineNum> <1055>
       -- <LOAD_TOS> <1>
       -- <OriginalLine> <	ena_mdr; setalu S_LESS; load_ptos; goto Main>
       -- <NEXT_ADDRESS> <53>
       -- <ALU> <21>

"00000111110001000000000000000000011000100" when (input = "111110000") else 
    -- 496 	ena_psp; setalu A; load_mar; write
       -- <B> <4>
       -- <LOAD_MAR> <1>
       -- <WRITE> <1>
       -- <LineNum> <1076>
       -- <OriginalLine> <	ena_psp; setalu A; load_mar; write>
       -- <NEXT_ADDRESS> <497>
       -- <ALU> <0>

"00000111110010000000000001000000000000010" when (input = "111110001") else 
    -- 497 	ena_mbr; setalu A; load_h
       -- <B> <2>
       -- <LineNum> <1083>
       -- <OriginalLine> <	ena_mbr; setalu A; load_h>
       -- <LOAD_H> <1>
       -- <NEXT_ADDRESS> <498>
       -- <ALU> <0>

"00000111110011000000001000010000000000110" when (input = "111110010") else 
    -- 498 	ena_rtos; setalu ADD; load_ptos
       -- <B> <6>
       -- <LineNum> <1084>
       -- <LOAD_TOS> <1>
       -- <OriginalLine> <	ena_rtos; setalu ADD; load_ptos>
       -- <NEXT_ADDRESS> <499>
       -- <ALU> <4>

"00000111110100000000001100000001000010001" when (input = "111110011") else 
    -- 499 	ena_pc; setalu INCA; load_pc; fetch
       -- <B> <1>
       -- <LineNum> <1089>
       -- <OriginalLine> <	ena_pc; setalu INCA; load_pc; fetch>
       -- <NEXT_ADDRESS> <500>
       -- <ALU> <6>
       -- <FETCH> <1>
       -- <LOAD_PC> <1>

"00000000110101000000001100000010000000100" when (input = "111110100") else 
    -- 500 	ena_psp; setalu INCA; load_psp; goto Main
       -- <B> <4>
       -- <LOAD_SP> <1>
       -- <LineNum> <1091>
       -- <OriginalLine> <	ena_psp; setalu INCA; load_psp; goto Main>
       -- <NEXT_ADDRESS> <53>
       -- <ALU> <6>

"00000111110110000000100000000010000000100" when (input = "111110101") else 
    -- 501 	ena_psp; setalu DECA; load_psp
       -- <B> <4>
       -- <LOAD_SP> <1>
       -- <LineNum> <1115>
       -- <OriginalLine> <	ena_psp; setalu DECA; load_psp>
       -- <NEXT_ADDRESS> <502>
       -- <ALU> <16>

"00000111110111000000000000000000010001001" when (input = "111110110") else 
    -- 502     ena_mdr; setalu A; load_mar
       -- <B> <9>
       -- <LOAD_MAR> <1>
       -- <LineNum> <1119>
       -- <OriginalLine> <    ena_mdr; setalu A; load_mar>
       -- <NEXT_ADDRESS> <503>
       -- <ALU> <0>

"00000111111000000000000000000000101000111" when (input = "111110111") else 
    -- 503     ena_ptos; setalu A; load_mdr; write
       -- <B> <7>
       -- <WRITE> <1>
       -- <LineNum> <1124>
       -- <LOAD_MDR> <1>
       -- <OriginalLine> <    ena_ptos; setalu A; load_mdr; write>
       -- <NEXT_ADDRESS> <504>
       -- <ALU> <0>

"00000111111001000000000000000000010100100" when (input = "111111000") else 
    -- 504     ena_psp; setalu A; load_mar; read
       -- <B> <4>
       -- <READ> <1>
       -- <LOAD_MAR> <1>
       -- <LineNum> <1128>
       -- <OriginalLine> <    ena_psp; setalu A; load_mar; read>
       -- <NEXT_ADDRESS> <505>
       -- <ALU> <0>

"00000111111010000000000000000000000000000" when (input = "111111001") else 
    -- 505     micronop
       -- <LineNum> <1131>
       -- <NEXT_ADDRESS> <506>
       -- <OriginalLine> <    micronop>

"00000000110101000000000000010000000001001" when (input = "111111010") else 
    -- 506     ena_mdr; setalu A; load_ptos; goto Main
       -- <B> <9>
       -- <LineNum> <1134>
       -- <LOAD_TOS> <1>
       -- <OriginalLine> <    ena_mdr; setalu A; load_ptos; goto Main>
       -- <NEXT_ADDRESS> <53>
       -- <ALU> <0>

"00000000110101000000011100010000000000000" when (input = "111111011") else 
    -- 507 UM_PLUS_TRUE_1:	setalu ONE; load_ptos; goto Main
       -- <LineNum> <663>
       -- <NEXT_ADDRESS> <53>
       -- <ALU> <14>
       -- <OriginalLine> <UM_PLUS_TRUE_1:	setalu ONE; load_ptos; goto Main>
       -- <LOAD_TOS> <1>

"00000000110101000000011110010000000000000" when (input = "111111100") else 
    -- 508 EQUAL_TRUE_1:	setalu MINUS_1; load_ptos; goto Main
       -- <LineNum> <637>
       -- <NEXT_ADDRESS> <53>
       -- <ALU> <15>
       -- <OriginalLine> <EQUAL_TRUE_1:	setalu MINUS_1; load_ptos; goto Main>
       -- <LOAD_TOS> <1>

"00000000110101000000011110010000000000000" when (input = "111111101") else 
    -- 509 NEG_TRUE_1:	setalu MINUS_1; load_ptos; goto Main
       -- <LineNum> <549>
       -- <NEXT_ADDRESS> <53>
       -- <ALU> <15>
       -- <OriginalLine> <NEG_TRUE_1:	setalu MINUS_1; load_ptos; goto Main>
       -- <LOAD_TOS> <1>

"00000101011010000000100000000010010100100" when (input = "111111110") else 
    -- 510 dowhile_true_1:	ena_psp; setalu DECA; load_psp; load_mar; read
       -- <B> <4>
       -- <READ> <1>
       -- <LOAD_SP> <1>
       -- <LOAD_MAR> <1>
       -- <LineNum> <292>
       -- <OriginalLine> <dowhile_true_1:	ena_psp; setalu DECA; load_psp; load_mar; read>
       -- <NEXT_ADDRESS> <346>
       -- <ALU> <16>

"00000000110101000000011110010000000000000" when (input = "111111111") else 
    -- 511 LESS_TRUE_1:	setalu MINUS_1; load_ptos;	goto Main
       -- <LineNum> <140>
       -- <NEXT_ADDRESS> <53>
       -- <ALU> <15>
       -- <OriginalLine> <LESS_TRUE_1:	setalu MINUS_1; load_ptos;	goto Main>
       -- <LOAD_TOS> <1>

"00000000000000000000000000000000000000000";

end Behavioral;
