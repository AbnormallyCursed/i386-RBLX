--!strict
local types: {} = require(game:GetService("ServerScriptService"):WaitForChild("i386"):WaitForChild("types"))

local PrefixLookupTableKEY: {[number]: string} = {
	[0xF0] = "LOCK",
	[0xF1] = "BND", 
	--
	--— BND prefix is encoded using F2H if the following conditions are true:
	--• CPUID.(EAX=07H, ECX=0):EBX.MPX[bit 14] is set.
	--• BNDCFGU.EN and/or IA32_BNDCFGS.EN is set.
	--• When the F2 prefix precedes a near CALL, a near RET, a near JMP, a short Jcc, or a near Jcc instruction
	--(see Appendix E, “Intel® Memory Protection Extensions,” of the Intel® 64 and IA-32 Architectures
	--Software Developer’s Manual, Volume 1).
	--
	[0xF2] = "REPNE/REPN",
	[0xF3] = "REPE/REPZ",
	-- Segment Override Prefixes: 
	-- segment override (use with any branch instruction is reserved).
	[0x2E] = "CS",
	[0x36] = "SS",
	[0x3E] = "DS",
	[0x26] = "ES",
	[0x64] = "FS",
	[0x65] = "GS",
	-- Branch Hints:
	-- 0x2E, used in CS
	-- 0x3E, used in DS
	[0x66] = "OSOP", -- Operand-size override prefix is encoded using 66H (66H is also used as a mandatory prefix for some instructions).
	[0x67] = "ASOP", -- Address-size override prefix.

	-- REX Prefixes:
	[0x40] = "REX",
	[0x41] = "REX.B",
	[0x42] = "REX.X",
	[0x43] = "REX.XB",
	[0x44] = "REX.R",
	[0x45] = "REX.RB",
	[0x46] = "REX.RX",
	[0x47] = "REX.RXB",
	[0x48] = "REX.W",
	[0x49] = "REX.WB",
	[0x4A] = "REX.WX",
	[0x4B] = "REX.WXB",
	[0x4C] = "REX.WR",
	[0x4D] = "REX.WRB",
	[0x4E] = "REX.WRX",
	[0x4F] = "REX.WRXB",

	[0x0F] = "MultiByteGroup",

	-- Unknown:
	[0x9B] = "?",
};
local newPrefix: types._prefixArray = table.create(256, false)
for i: number in PrefixLookupTableKEY do
	newPrefix[i] = true
end
table.clear(PrefixLookupTableKEY)
return {directArrayPrefix = newPrefix}


