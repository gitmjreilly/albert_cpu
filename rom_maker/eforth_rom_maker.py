if __name__ == '__main__':
    fi = open('loader_from_zero.txt','rt').readlines()
    data = []
    cnt = 0
    fout = open("rom.vhd","wt")


    header = '''
        library IEEE; 

        use IEEE.STD_LOGIC_1164.ALL;
        use IEEE.STD_LOGIC_ARITH.ALL;
        use IEEE.STD_LOGIC_UNSIGNED.ALL;

        entity rom is
            Port ( addr : in std_logic_vector(15 downto 0);
                   data : out std_logic_vector(15 downto 0);
                   cs : in std_logic);
        end rom;

        architecture Behavioral of rom is

          signal output : std_logic_vector(15 downto 0);

        begin
           output <= 
'''
    print(header,file=fout)
    for row in fi:
        print('x"%s" when (addr=x"%s") else' %  (row.strip(),hex(cnt)[2:]),file=fout)
        cnt += 1
        if cnt == 6 * 1024 - 1:
            print('x"0000" when (addr=x"17ff");',file=fout)
            break
    endit = '''
        data <= output when cs = '0' else "ZZZZZZZZZZZZZZZZ";
        end Behavioral;
    '''
    print(endit,file=fout)
    fout.close()
        
        
