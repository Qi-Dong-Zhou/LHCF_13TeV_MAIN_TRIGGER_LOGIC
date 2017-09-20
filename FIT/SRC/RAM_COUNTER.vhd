library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity RAM_COUNTER is 
port(
	CLK1				: in std_logic;
	CLK2				: in std_logic;
	COUNTER_SIGNAL	: in std_logic;     
	BUF_INC			: in std_logic;     
	BUF_RESET		: in std_logic;     
	CLEAR				: in std_logic;
	READ_RESET		: in std_logic;  -- syncronized with CLK2 
	READ_INC			: in std_logic;  -- syncronized with CLK2 
	DATA_OUT			: out std_logic_vector(31 downto 0) :=(others=>'0')
);
end RAM_COUNTER;

architecture Behavioral of RAM_COUNTER is
	component INTERNALCOUNTER is 
		generic(N : integer := 4);
		port (
			CLK           : in std_logic;
			START         : in std_logic;
			PRESET        : in std_logic_vector (N-1 downto 0);
			STAT          : out std_logic;
			ENDMARK       : out std_logic);
	end component;

	component LATCH_M is 
		port (
			CLK           : in std_logic;
			START         : in std_logic;
			STOP          : in std_logic;
			OUTPUT        : out std_logic;
			STARTMARK     : out std_logic;
			ENDMARK       : out std_logic);
	end component;

	component SCOUNTER is 
		generic (N : integer := 31);
		port (
			CLK     : in  std_logic;
			INPUT   : in  std_logic;  -- input width must be 25 nsec.
			CLR     : in  std_logic;
			INHIBIT : in  std_logic;
			COUNT   : out std_logic_vector(N-1 downto 0));
	end component;
	
	component RAM_DPORT_A6D32
	PORT
	(
		address_a		: IN STD_LOGIC_VECTOR (5 DOWNTO 0);
		address_b		: IN STD_LOGIC_VECTOR (5 DOWNTO 0);
		clock_a		: IN STD_LOGIC  := '1';
		clock_b		: IN STD_LOGIC ;
		data_a		: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		data_b		: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		wren_a		: IN STD_LOGIC  := '0';
		wren_b		: IN STD_LOGIC  := '0';
		q_a		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
		q_b		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
	);
	end component;
	
	signal C_SIGNAL		: std_logic;     
	signal C_INC			: std_logic;     
	signal C_RESET			: std_logic;     
	signal C_ADDRESS		: std_logic_vector(5 downto 0):= (others=>'0');
	signal C_INPUT			: std_logic_vector(31 downto 0):= (others=>'0'); 
	signal C_DATA			: std_logic_vector(31 downto 0):= (others=>'0');
	signal C_WE				: std_logic := '0';
	signal R_INC			: std_logic := '0';
	signal R_ADDRESS		: std_logic_vector(5 downto 0);
	signal TMP_COUNT		: std_logic_vector(31 downto 0) := (others=>'0');
	signal FLAG_CLEAR_1	: std_logic :='0';
	signal FLAG_CLEAR		: std_logic :='0';	

---------------------------------------------------------------------	
begin

	-- SIGNAL WIDTH -> 1CLK
	WIDTH_C_SIGNAL: INTERNALCOUNTER generic map(1) port map(
		CLK		=> CLK1,
		START		=> COUNTER_SIGNAL,
		PRESET	=> "0",
		STAT		=> open,
		ENDMARK	=> C_SIGNAL
	);
	
	WIDTH_C_INC: INTERNALCOUNTER generic map(1) port map(
		CLK		=> CLK1,
		START		=> BUF_INC,
		PRESET	=> "0",
		STAT		=> open,
		ENDMARK	=> C_INC
	);
	
	WIDTH_C_RESET: INTERNALCOUNTER generic map(1) port map(
		CLK		=> CLK1,
		START		=> BUF_RESET,
		PRESET	=> "0",
		STAT		=> open,
		ENDMARK	=> C_RESET
	);

	-- READ
	WIDTH_R_INC: INTERNALCOUNTER generic map(3) port map(
		CLK		=> CLK2,
		START		=> READ_INC,
		PRESET	=> "101",
		STAT		=> open,
		ENDMARK	=> R_INC
	);
	
	COUNTER_RADDRESS : SCOUNTER generic map(6) port map(
		CLK		=> CLK2,
		INPUT		=> R_INC,
		CLR		=> READ_RESET,
		INHIBIT	=> '0',
		COUNT		=> R_ADDRESS
	);
	
	-- RAM ACCESS 
	RAM_CONT : RAM_DPORT_A6D32 port map (
		address_a 	=>  C_ADDRESS,
		address_b 	=>  R_ADDRESS,
		clock_a		=>  CLK1,
		clock_b		=>  CLK2,
		data_a		=>  C_INPUT,
		data_b		=>  (others=>'0'),
		wren_a		=>  C_WE,
		wren_b		=>  '0',
		q_a			=>  C_DATA,
		q_b			=>  DATA_OUT
	);
	
	-- MAKE FLAG_CLEAR WITH LONG PULSE WIDTH 
	FIRST_LATCH : LATCH_M port map (
		CLK     	=>  CLK1,
		START		=>  CLEAR,
		STOP		=>  C_RESET,
		OUTPUT	=>  open,
		STARTMARK=>	 open,
		ENDMARK	=>  FLAG_CLEAR_1
		);
	SECOND_LATCH : LATCH_M port map (
		CLK     	=>  CLK1,
		START		=>  FLAG_CLEAR_1,
		STOP		=>  C_RESET,
		OUTPUT	=>  FLAG_CLEAR,
		STARTMARK=>	 open,
		ENDMARK	=>  open
		);
	
	-- COUNTER 
	process (CLK1) 
		type S_type is (ST0, ST1, ST2, ST3, ST4, ST5, ST6, ST7);
		variable STAT : S_type := ST0; 
		type SC_type is (SC_ON, SC_OFF);
		variable STAT_CLEAR : SC_type := SC_OFF;
	begin
		if(CLK1'event and CLK1='1') then
				
			-- RESTORE AND LOAD COUNTER VALUES
			case STAT is
				when ST0 => 
					-- START PROCEDURE TO WRITE COUNTE(N)
					if(C_RESET='1') then
						C_ADDRESS <= (others => '0');
					end if;
					
					if(FLAG_CLEAR='1') then
						TMP_COUNT <= (others => '0');
					elsif(C_SIGNAL='1') then
						TMP_COUNT <= TMP_COUNT + 1;
					end if;
					
					if(C_INC='1') then
						C_INPUT <= TMP_COUNT; 
						STAT := ST1;
					end if;
				when ST1 =>
					-- SET WE "ON"
					C_WE <= '1';
					STAT := ST2;
				when ST2 =>
					-- WAIT FOR ONE CLOCK
					STAT := ST3;
				when ST3 =>
					-- SET WE "OFF"
					C_WE <= '0';
					STAT := ST4;
				when ST4 =>
					-- INCREMENT ADDRESS
					C_ADDRESS <= C_ADDRESS + 1;
					STAT := ST5;
				when ST5 =>
					-- WAIT FOR ONE CLOCK 
					STAT := ST6;
				when ST6 =>
					-- WAIT FOR ANOTHER ONE CLOCK 
					STAT := ST7;
				when ST7 => 
					-- READ COUNTER VALUE(N+1)
					TMP_COUNT <= C_DATA;
					STAT := ST0;
				when others =>
			end case;
		end if;
	end process;
	
end Behavioral;