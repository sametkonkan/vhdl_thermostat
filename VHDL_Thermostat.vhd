library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity T_THERMO is
end T_THERMO;

architecture test of T_THERMO is 
    component THERMO 
        port( 
            CLK : in std_logic;
            current_temp : in std_logic_vector(6 downto 0);
            desired_temp : in std_logic_vector(6 downto 0);
            display_select: in std_logic;
            cool : in std_logic;
            heat : in std_logic;
            RESET : in std_logic;
            temp_display: out std_logic_vector(7 downto 0);
            A_C_ON : out std_logic;
            FURNACE_ON : out std_logic
        );
    end component;

    -- Sinyal tanımlamaları
    signal current_temp, desired_temp : std_logic_vector(6 downto 0) := (others => '0');
    signal temp_display : std_logic_vector(7 downto 0);
    signal display_select, heat, cool, A_C_ON, FURNACE_ON : std_logic := '0';
    signal CLK, RESET : std_logic := '0';

begin
    -- Saat sinyali oluşturma (10 ns periyot)
    CLK <= not CLK after 5 ns;

    -- Component instance (UUT - Unit Under Test)
    UUT: THERMO 
        port map (
            CLK => CLK,
            current_temp => current_temp,
            desired_temp => desired_temp,
            display_select => display_select,
            cool => cool,
            heat => heat,
            RESET => RESET,
            temp_display => temp_display,
            A_C_ON => A_C_ON,
            FURNACE_ON => FURNACE_ON
        );

    -- Test süreci
    process
    begin
        -- Test başlangıcı: RESET sinyali aktif
        RESET <= '0';
        wait for 10 ns;
        RESET <= '1';
        wait for 10 ns;

        -- Test senaryosu 1: Başlangıç sıcaklık ve hedef sıcaklık ayarları
        current_temp <= "0000000";
        desired_temp <= "1111111";
        display_select <= '0';
        wait for 50 ns;
        
        -- Display select değişimi
        display_select <= '1';
        wait for 50 ns;

        -- Isıtma işlemi başlatma
        heat <= '1';
        wait for 50 ns;
        heat <= '0';
        wait for 50 ns;

        -- Yeni sıcaklık değerleri
        current_temp <= "1000000";
        desired_temp <= "0100000";
        wait for 50 ns;

        -- Soğutma işlemi başlatma
        cool <= '1';
        wait for 50 ns;
        cool <= '0';
        wait for 50 ns;

        -- Test bitişi
        wait;
    end process;
end test;
