library IEEE;
use IEEE.std_logic_1164.ALL;
use work.constants.all;

entity left_XLEN_barrel_shifter is
    port(   i	: in	std_logic_vector(XLEN -1 downto 0);
	    s	: in	std_logic_vector(4 downto 0);
	    o	: out	std_logic_vector(XLEN -1 downto 0)
    );
end left_XLEN_barrel_shifter;

architecture structural of left_XLEN_barrel_shifter is

component muxXLEN2a1
    port(   i0, i1  : in    std_logic_vector(XLEN -1 downto 0);
	    s	    : in    std_logic;
	    o	    : out   std_logic_vector(XLEN -1 downto 0)
    );
end component;

signal s1, s2, s3, s4		    : std_logic_vector(XLEN -1 downto 0);
signal aux0, aux1, aux2, aux3, aux4 : std_logic_vector(XLEN -1 downto 0);

begin
    aux0 <= i	(30 downto 0) & '0';
    ins0: muxXLEN2a1 port map(i , aux0, s(0), s1);
    aux1 <= s1	(29 downto 0) & "00";
    ins1: muxXLEN2a1 port map(s1, aux1, s(1), s2);
    aux2 <= s2	(27 downto 0) & "0000";
    ins2: muxXLEN2a1 port map(s2, aux2, s(2), s3);
    aux3 <= s3	(23 downto 0) & "00000000";
    ins3: muxXLEN2a1 port map(s3, aux3, s(3), s4);
    aux4 <= s4	(15 downto 0) & "0000000000000000";
    ins4: muxXLEN2a1 port map(s4, aux4, s(4), o );

end structural;
