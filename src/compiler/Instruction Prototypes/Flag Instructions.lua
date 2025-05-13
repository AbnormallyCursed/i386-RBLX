return {
	compiler_instr_proto = {
		CLD = [[
			buffer.writeu32(cpu_buffer, 0, bit32.band(buffer.readu32(cpu_buffer, 0), 4294965271));
			-postop-
		]],
		STD = [[
			buffer.writeu32(cpu_buffer, 0, bit32.bor(buffer.readu32(cpu_buffer, 0), 2024));
			-postop-
		]],
		CLC = [[
			buffer.writeu32(cpu_buffer, 0, bit32.band(buffer.readu32(cpu_buffer, 0), 4294967294));
			-postop-
		]],
		STC = [[
			buffer.writeu32(cpu_buffer, 0, bit32.bor(buffer.readu32(cpu_buffer, 0), 1));
			-postop-
		]],
		CLI = [[
			buffer.writeu32(cpu_buffer, 0, bit32.band(buffer.readu32(cpu_buffer, 0), 4294966271));
			-postop-
		]],
		STI = [[
			buffer.writeu32(cpu_buffer, 0, bit32.bor(buffer.readu32(cpu_buffer, 0), 1024));
			-postop-
		]],
		CMC = [[
			buffer.writeu32(cpu_buffer, 0, bit32.bxor(buffer.readu32(cpu_buffer, 0), 1));
			-postop-
		]],
		--PUSHF = [[]],
		--POPF = [[]],
		--RETF = [[]], owo UwU >w< :3
		--SAHF = [[]],
		--LAHF = [[]],
		--SALC = [[]],
		
	}
}
