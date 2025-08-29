library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.csi2_pkg.all;

entity csi2_decoder is
    generic (
        LANES : positive := 1
    );
    port (
        clk        : in  std_logic;
        rst        : in  std_logic;
        byte_data  : in  std_logic_vector(8*LANES-1 downto 0);
        byte_valid : in  std_logic;
        avst_data  : out std_logic_vector(7 downto 0);
        avst_valid : out std_logic;
        avst_ready : in  std_logic;
        avst_sop   : out std_logic;
        avst_eop   : out std_logic
    );
end entity csi2_decoder;

architecture rtl of csi2_decoder is
    type state_t is (S_IDLE, S_HEADER, S_PAYLOAD);
    signal state       : state_t := S_IDLE;
    signal header      : std_logic_vector(31 downto 0) := (others => '0');
    signal byte_cnt    : integer range 0 to 3 := 0;
    signal payload_cnt : unsigned(15 downto 0) := (others => '0');
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                state       <= S_IDLE;
                header      <= (others => '0');
                byte_cnt    <= 0;
                payload_cnt <= (others => '0');
                avst_data   <= (others => '0');
                avst_valid  <= '0';
                avst_sop    <= '0';
                avst_eop    <= '0';
            else
                avst_sop   <= '0';
                avst_eop   <= '0';
                avst_valid <= '0';

                case state is
                    when S_IDLE =>
                        if byte_valid = '1' then
                            header(7 downto 0) <= byte_data(7 downto 0);
                            byte_cnt <= 1;
                            state    <= S_HEADER;
                        end if;

                    when S_HEADER =>
                        if byte_valid = '1' then
                            header(byte_cnt*8+7 downto byte_cnt*8) <= byte_data(7 downto 0);
                            if byte_cnt = 3 then
                                payload_cnt <= unsigned(header(23 downto 8));
                                avst_sop    <= '1';
                                byte_cnt    <= 0;
                                state       <= S_PAYLOAD;
                            else
                                byte_cnt <= byte_cnt + 1;
                            end if;
                        end if;

                    when S_PAYLOAD =>
                        if byte_valid = '1' and avst_ready = '1' then
                            avst_data  <= byte_data(7 downto 0);
                            avst_valid <= '1';
                            if payload_cnt = 1 then
                                avst_eop <= '1';
                                state    <= S_IDLE;
                            end if;
                            payload_cnt <= payload_cnt - 1;
                        end if;
                end case;
            end if;
        end if;
    end process;
end architecture rtl;
