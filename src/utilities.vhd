library ieee;
use ieee.math_real.all;
use ieee.numeric_std.all;

package utilities is
	function bit_width (
		n: integer
	) return integer;
end package utilities;

package body utilities is
	function bit_width (
		n: integer
	) return integer is
	begin
		return integer(ceil(log2(real(n))));
	end function bit_width;
end package body utilities;