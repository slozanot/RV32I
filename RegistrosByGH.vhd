library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

library work;
use work.constants.all;

entity registers is
	Port(
		I_clk: in std_logic; --Reloj
		I_en: in std_logic; --Enable
		I_op: in regops_t; --Operaciones son Lectura y Escritura
		I_selS1: in std_logic_vector(4 downto 0); -- Seleccion de registros
		I_selS2: in std_logic_vector(4 downto 0); -- Seleccion de registros
		I_selD: in std_logic_vector(4 downto 0); -- NO SE QUE HACE ESTO EN VERDA
		I_data: in std_logic_vector(XLEN-1 downto 0); -- Datos de entrada a los registros
		O_dataS1: out std_logic_vector(XLEN-1 downto 0) := XLEN_ZERO; -- Datos de salida de los registros
		O_dataS2: out std_logic_vector(XLEN-1 downto 0) := XLEN_ZERO  -- Datos de salida de los registros
	);
end registers;


architecture Behavioral of registers is
	type store_t is array(0 to 31) of std_logic_vector(XLEN-1 downto 0); --array de 32 posiciones (32 bits) de dimension que se indique.
	signal regs: store_t := (others => X"00000000"); --Señal que guarda en registro.
	--attribute ramstyle : string; -- No hace falta. Por si la ram admite Lectura y Escritura a la vez
	--attribute ramstyle of regs : signal is "no_rw_check"; -- Tampoco hace falta. Complemento del anterior
begin
   --Se crea process
	process(I_clk, I_en, I_op, I_selS1, I_selS2, I_selD, I_data)
		--Variable data ¿Para que se usa? No es necesario, es como algo intermedio
		variable data: std_logic_vector(XLEN-1 downto 0);
	begin
	   -- Si no hay reloj, solo se controla el enable.
		if rising_edge(I_clk) and I_en = '1' then
			data := X"00000000";
			-- Si la operacion es de escritura
				if I_op = REGOP_WRITE and I_selD /= "00000" then
					data := I_data;
				end if;
			  
				
			-- this is a pattern that Quartus RAM synthesis understands
			-- as *not* being read-during-write (with no_rw_check attribute)
			if I_op = REGOP_WRITE then
				regs(to_integer(unsigned(I_selD))) <= data;
			else
				O_dataS1 <= regs(to_integer(unsigned(I_selS1)));
				O_dataS2 <= regs(to_integer(unsigned(I_selS2)));
			end if;
		end if;
	end process;
	
end Behavioral;