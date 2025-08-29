library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package csi2_pkg is
    constant C_MAX_LANES : natural := 4;

    type avst_t is record
        data  : std_logic_vector(7 downto 0);
        valid : std_logic;
        ready : std_logic;
        sop   : std_logic;
        eop   : std_logic;
    end record avst_t;
end package csi2_pkg;

package body csi2_pkg is
end package body csi2_pkg;
