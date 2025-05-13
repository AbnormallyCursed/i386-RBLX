return {
	compiler_instr_proto = {
		ADD = [[
			local result: number = (input:1 + input:2) -mod- (2 ^ sizeof:1);
			buffer.writeu32(cpu_buffer, 0, bit32.bor(bit32.bxor(bit32.bor(buffer.readu32(cpu_buffer, 0), 0x8D5), 0x8D5),
				(result % 2) + 						-- Carry Flag
				((result % 256 + 1) % 2) * 4 + 		-- Parity Flag
				(result % 16 == 0 and 16 or 0) + 	-- Auxiliary Carry Flag
				(result == 0 and 64 or 0) + 		-- Zero Flag
				(result < 0 and 128 or 0) +  		-- Sign Flag
				(result > 1000 and 2048 or 0) 		-- Overflow Flag
			));
			$result$
			output:1
			-postop-
		]],
		SUB = [[
			local result: number = (input:1 - input:2) -mod- (2 ^ sizeof:1);
			buffer.writeu32(cpu_buffer, 0, bit32.bor(bit32.bxor(bit32.bor(buffer.readu32(cpu_buffer, 0), 0x8D5), 0x8D5),
				(result % 2) + 						-- Carry Flag
				((result % 256 + 1) % 2) * 4 + 		-- Parity Flag
				(result % 16 == 0 and 16 or 0) +	-- Auxiliary Carry Flag
				(result == 0 and 64 or 0) + 		-- Zero Flag
				(result < 0 and 128 or 0) +  		-- Sign Flag
				(result > 1000 and 2048 or 0) 		-- Overflow Flag
			));
			$result$
			output:1
			-postop-
		]],
		MUL = [[
			local result: number = (input:1 * input:2) -mod- (2 ^ sizeof:1)
			buffer.writeu32(cpu_buffer, 0, bit32.bor(bit32.bxor(bit32.bor(buffer.readu32(cpu_buffer, 0), 0x8D5), 0x8D5),
				(result % 2) + 						-- Carry Flag
				((result % 256 + 1) % 2) * 4 + 		-- Parity Flag
				(result % 16 == 0 and 16 or 0) + 	-- Auxiliary Carry Flag
				(result == 0 and 64 or 0) + 		-- Zero Flag
				(result < 0 and 128 or 0) +  		-- Sign Flag
				(result > 1000 and 2048 or 0) 		-- Overflow Flag
			));
			$result$
			output:1 
			-postop-
		]],
		XOR = [[
			local result: number = bit32.bxor(input:1, input:2) -mod- (2 ^ sizeof:1);
			buffer.writeu32(cpu_buffer, 0, bit32.bor(bit32.bxor(bit32.bor(buffer.readu32(cpu_buffer, 0), 0x8D5), 0x8D5),
				(result % 2) + 						-- Carry Flag
				((result % 256 + 1) % 2) * 4 + 		-- Parity Flag
				(result % 16 == 0 and 16 or 0) + 	-- Auxiliary Carry Flag
				(result == 0 and 64 or 0) + 		-- Zero Flag
				(result < 0 and 128 or 0) +  		-- Sign Flag
				(result > 1000 and 2048 or 0) 		-- Overflow Flag
			));
			$result$
			output:1
			-postop-
		]],
		NOT = [[
			local result: number = bit32.bnot(input:1, input:2) -mod- (2 ^ sizeof:1);
			buffer.writeu32(cpu_buffer, 0, bit32.bor(bit32.bxor(bit32.bor(buffer.readu32(cpu_buffer, 0), 0x8D5), 0x8D5),
				(result % 2) + 						-- Carry Flag
				((result % 256 + 1) % 2) * 4 + 		-- Parity Flag
				(result % 16 == 0 and 16 or 0) + 	-- Auxiliary Carry Flag
				(result == 0 and 64 or 0) + 		-- Zero Flag
				(result < 0 and 128 or 0) +  		-- Sign Flag
				(result > 1000 and 2048 or 0) 		-- Overflow Flag
			));
			$result$
			output:1
			-postop-
		]],
		OR = [[
			local result: number = bit32.bor(input:1, input:2) -mod- (2 ^ sizeof:1);
			buffer.writeu32(cpu_buffer, 0, bit32.bor(bit32.bxor(bit32.bor(buffer.readu32(cpu_buffer, 0), 0x8D5), 0x8D5),
				(result % 2) + 						-- Carry Flag
				((result % 256 + 1) % 2) * 4 + 		-- Parity Flag
				(result % 16 == 0 and 16 or 0) + 	-- Auxiliary Carry Flag
				(result == 0 and 64 or 0) + 		-- Zero Flag
				(result < 0 and 128 or 0) +  		-- Sign Flag
				(result > 1000 and 2048 or 0) 		-- Overflow Flag
			));
			$result$
			output:1
			-postop-
		]],
		AND = [[
			local result: number = bit32.band(input:1, input:2) -mod- (2 ^ sizeof:1);
			buffer.writeu32(cpu_buffer, 0, bit32.bor(bit32.bxor(bit32.bor(buffer.readu32(cpu_buffer, 0), 0x8D5), 0x8D5),
				(result % 2) + 						-- Carry Flag
				((result % 256 + 1) % 2) * 4 + 		-- Parity Flag
				(result % 16 == 0 and 16 or 0) + 	-- Auxiliary Carry Flag
				(result == 0 and 64 or 0) + 		-- Zero Flag
				(result < 0 and 128 or 0) +  		-- Sign Flag
				(result > 1000 and 2048 or 0) 		-- Overflow Flag
			));
			$result$
			output:1
			-postop-
		]],
		DIV = [[
			local result: number = (input:1 // input:2) -mod- (2 ^ sizeof:1);
			buffer.writeu32(cpu_buffer, 0, bit32.bor(bit32.bxor(bit32.bor(buffer.readu32(cpu_buffer, 0), 0x8D5), 0x8D5),
				(result % 2) + 						-- Carry Flag
				((result % 256 + 1) % 2) * 4 + 		-- Parity Flag
				(result % 16 == 0 and 16 or 0) + 	-- Auxiliary Carry Flag
				(result == 0 and 64 or 0) + 		-- Zero Flag
				(result < 0 and 128 or 0) +  		-- Sign Flag
				(result > 1000 and 2048 or 0) 		-- Overflow Flag
			));
			$result$
			output:1
			-postop-
		]],
		SHR = [[
			local result: number = (input:1 // (2 ^ input:2)) -mod- (2 ^ sizeof:1);
			buffer.writeu32(cpu_buffer, 0, bit32.bor(bit32.bxor(bit32.bor(buffer.readu32(cpu_buffer, 0), 0x8D5), 0x8D5),
				(result % 2) + 						-- Carry Flag
				((result % 256 + 1) % 2) * 4 + 		-- Parity Flag
				(result % 16 == 0 and 16 or 0) + 	-- Auxiliary Carry Flag
				(result == 0 and 64 or 0) + 		-- Zero Flag
				(result < 0 and 128 or 0) +  		-- Sign Flag
				(result > 1000 and 2048 or 0) 		-- Overflow Flag
			));
			$result$
			output:1
			-postop-
		]],
		SHL = [[
			local result: number = (input:1 * (2 ^ input:2)) -mod- (2 ^ sizeof:1);
			buffer.writeu32(cpu_buffer, 0, bit32.bor(bit32.bxor(bit32.bor(buffer.readu32(cpu_buffer, 0), 0x8D5), 0x8D5),
				(result % 2) + 						-- Carry Flag
				((result % 256 + 1) % 2) * 4 + 		-- Parity Flag
				(result % 16 == 0 and 16 or 0) + 	-- Auxiliary Carry Flag
				(result == 0 and 64 or 0) + 		-- Zero Flag
				(result < 0 and 128 or 0) +  		-- Sign Flag
				(result > 1000 and 2048 or 0) 		-- Overflow Flag
			));
			$result$
			output:1
			-postop-
		]],
		ADC = [[
			local result: number = (input:1 + input:2 + cpu_flags % 2) -mod- (2 ^ sizeof:1);
			buffer.writeu32(cpu_buffer, 0, bit32.bor(bit32.bxor(bit32.bor(buffer.readu32(cpu_buffer, 0), 0x8D5), 0x8D5),
				(result % 2) + 						-- Carry Flag
				((result % 256 + 1) % 2) * 4 + 		-- Parity Flag
				(result % 16 == 0 and 16 or 0) + 	-- Auxiliary Carry Flag
				(result == 0 and 64 or 0) + 		-- Zero Flag
				(result < 0 and 128 or 0) +  		-- Sign Flag
				(result > 1000 and 2048 or 0) 		-- Overflow Flag
			));
			$result$
			output:1
			-postop-
		]],
		SBB = [[
			local result: number = (input:1 - input:2 + cpu_flags % 2) -mod- (2 ^ sizeof:1);
			buffer.writeu32(cpu_buffer, 0, bit32.bor(bit32.bxor(bit32.bor(buffer.readu32(cpu_buffer, 0), 0x8D5), 0x8D5),
				(result % 2) + 						-- Carry Flag
				((result % 256 + 1) % 2) * 4 + 		-- Parity Flag
				(result % 16 == 0 and 16 or 0) + 	-- Auxiliary Carry Flag
				(result == 0 and 64 or 0) + 		-- Zero Flag
				(result < 0 and 128 or 0) +  		-- Sign Flag
				(result > 1000 and 2048 or 0) 		-- Overflow Flag
			));
			$result$
			output:1
			-postop-
		]],
		SAL = [[
			local result: number = (input:1 * (2 ^ input:2)) -mod- (2 ^ sizeof:1);
			buffer.writeu32(cpu_buffer, 0, bit32.bor(bit32.bxor(bit32.bor(buffer.readu32(cpu_buffer, 0), 0x8D5), 0x8D5),
				(result % 2) + 						-- Carry Flag
				((result % 256 + 1) % 2) * 4 + 		-- Parity Flag
				(result % 16 == 0 and 16 or 0) + 	-- Auxiliary Carry Flag
				(result == 0 and 64 or 0) + 		-- Zero Flag
				(result < 0 and 128 or 0) +  		-- Sign Flag
				(result > 1000 and 2048 or 0) 		-- Overflow Flag
			));
			$result$
			output:1
			-postop-
		]],
		ROL = [[
			local result: number = (input:1 * (2 ^ input:2) + cpu_flags % 2) -mod- (2 ^ sizeof:1);
			buffer.writeu32(cpu_buffer, 0, bit32.bor(bit32.bxor(bit32.bor(buffer.readu32(cpu_buffer, 0), 0x8D5), 0x8D5),
				(result % 2) + 						-- Carry Flag
				((result % 256 + 1) % 2) * 4 + 		-- Parity Flag
				(result % 16 == 0 and 16 or 0) + 	-- Auxiliary Carry Flag
				(result == 0 and 64 or 0) + 		-- Zero Flag
				(result < 0 and 128 or 0) +  		-- Sign Flag
				(result > 1000 and 2048 or 0) 		-- Overflow Flag
			));
			$result$
			output:1
			-postop-
		]],
		ROR = [[
			local result: number = (input:1 // (2 ^ input:2) + cpu_flags % 2) -mod- (2 ^ sizeof:1);
			buffer.writeu32(cpu_buffer, 0, bit32.bor(bit32.bxor(bit32.bor(buffer.readu32(cpu_buffer, 0), 0x8D5), 0x8D5),
				(result % 2) + 						-- Carry Flag
				((result % 256 + 1) % 2) * 4 + 		-- Parity Flag
				(result % 16 == 0 and 16 or 0) + 	-- Auxiliary Carry Flag
				(result == 0 and 64 or 0) + 		-- Zero Flag
				(result < 0 and 128 or 0) +  		-- Sign Flag
				(result > 1000 and 2048 or 0) 		-- Overflow Flag
			));
			$result$
			output:1
			-postop-
		]],
		RCL = [[
			-- TODO la rotate
			-postop-
		]],
		RCR = [[
			-- TODO la rotate
			-postop-
		]],
		BTC = [[
			local size: number = sizeof:1; --silly instruction???
			local operand1: number = input:1 -mod- size;
			local operand2: number = (2 ^ input:2) -mod- size;
			local isbitSet: boolean = bit32.band(operand1, operand2) ~= 0;
			if isbitSet then
				buffer.writeu32(cpu_buffer, 0, bit32.bor(buffer.readu32(cpu_buffer, 0), 1));
			else
				buffer.writeu32(cpu_buffer, 0, bit32.band(buffer.readu32(cpu_buffer, 0), 4294967294));
			end;
			$bit32.bxor(operand1, operand2)$
		]],
		BTR = [[
			local size: number = sizeof:1; --silly instruction???
			local operand1: number = input:1 -mod- size;
			local operand2: number = (2 ^ input:2) -mod- size;
			local isbitSet: boolean = bit32.band(operand1, operand2) ~= 0;
			if isbitSet then
				buffer.writeu32(cpu_buffer, 0, bit32.bor(buffer.readu32(cpu_buffer, 0), 1));
			else
				buffer.writeu32(cpu_buffer, 0, bit32.band(buffer.readu32(cpu_buffer, 0), 4294967294));
			end;
			$bit32.band(operand1, bit32.bnot(operand2))$
		]],
		BTS = [[
			local size: number = sizeof:1; --silly instruction???
			local operand1: number = input:1 -mod- size;
			local operand2: number = (2 ^ (input:2 -mod- size)) -mod- size;
			buffer.writeu32(cpu_buffer, 0, bit32.bor(buffer.readu32(cpu_buffer, 0), bit32.band(operand1, operand2) ~= 0 and 1 or 0))
			$bit32.bor(operand1, operand2)$
		]],
		BSWAP = [[
			local operand: number = input:1; -- myb fix required TODO
			local result: number = bit32.bor(
				bit32.band(operand, 0xFF) -mod- 16777216,
				bit32.band(operand, 0xFF00) -mod- 256,
				bit32.band(operand, 0xFF0000) // 256,
				bit32.band(operand, 0xFF000000) // 16777216
			);
			$result$
			output:1
			-postop-
		]],
		LZCNT = [[
			local result: number = bit32.countlz(input:1); -- TODO: fix silly 16 bit OSA
			$result$
			buffer.writeu32(cpu_buffer, 0, bit32.bor(bit32.bxor(bit32.bor(buffer.readu32(cpu_buffer, 0), 0x8D5), 0x8D5),
				(result % 2) + 						-- Carry Flag
				((result % 256 + 1) % 2) * 4 + 		-- Parity Flag
				(result % 16 == 0 and 16 or 0) + 	-- Auxiliary Carry Flag
				(result == 0 and 64 or 0) + 		-- Zero Flag
				(result < 0 and 128 or 0) +  		-- Sign Flag
				(result > 1000 and 2048 or 0) 		-- Overflow Flag
			));
			output:1
			-postop-
		]],
		IMUL = [[
			local sizesqrt: number = 2 ^ sizeof:1;
			local operand1: number = input:1 -mod- sizesqrt;
			local operand2: number = input:2 -mod- sizesqrt;
			print("IMUL operands", operand1, operand2)
			local result: number = ((((operand1 >= sizesqrt / 2) and (operand1 - sizesqrt)) or operand1) * (((operand2 >= sizesqrt / 2) and (operand2 - sizesqrt)) or operand2));
			$result$
			output:1
			-postop-
		]],
		IDIV = [[
			local sizesqrt: number = 2 ^ sizeof:1;
			local operand1: number = input:1 -mod- sizesqrt;
			local operand2: number = input:2 -mod- sizesqrt;
			local result: number = ((((operand1 >= sizesqrt / 2) and (operand1 - sizesqrt)) or operand1) // (((operand2 >= sizesqrt / 2) and (operand2 - sizesqrt)) or operand2));
			buffer.writeu32(cpu_buffer, 0, bit32.bor(bit32.bxor(bit32.bor(buffer.readu32(cpu_buffer, 0), 0x8D5), 0x8D5),
				(result % 2) + 						-- Carry Flag
				((result % 256 + 1) % 2) * 4 + 		-- Parity Flag
				(result % 16 == 0 and 16 or 0) + 	-- Auxiliary Carry Flag
				(result == 0 and 64 or 0) + 		-- Zero Flag
				(result < 0 and 128 or 0) +  		-- Sign Flag
				(result > 1000 and 2048 or 0) 		-- Overflow Flag
			));
			$result$
			output:1
			-postop-
		]],
		INC = [[
			local result: number = (input:1 + 1) -mod- (2 ^ sizeof:1);
			buffer.writeu32(cpu_buffer, 0, bit32.bor(bit32.bxor(bit32.bor(buffer.readu32(cpu_buffer, 0), 0x8D5), 0x8D5),
				(result % 2) + 						-- Carry Flag
				((result % 256 + 1) % 2) * 4 + 		-- Parity Flag
				(result % 16 == 0 and 16 or 0) + 	-- Auxiliary Carry Flag
				(result == 0 and 64 or 0) + 		-- Zero Flag
				(result < 0 and 128 or 0) +  		-- Sign Flag
				(result > 1000 and 2048 or 0) 		-- Overflow Flag
			));
			$result$
			output:1
			-postop-
		]],
		DEC = [[
			local result: number = (input:1 - 1) -mod- (2 ^ sizeof:1);
			buffer.writeu32(cpu_buffer, 0, bit32.bor(bit32.bxor(bit32.bor(buffer.readu32(cpu_buffer, 0), 0x8D5), 0x8D5),
				(result % 2) + 						-- Carry Flag
				((result % 256 + 1) % 2) * 4 + 		-- Parity Flag
				(result % 16 == 0 and 16 or 0) + 	-- Auxiliary Carry Flag
				(result == 0 and 64 or 0) + 		-- Zero Flag
				(result < 0 and 128 or 0) +  		-- Sign Flag
				(result > 1000 and 2048 or 0) 		-- Overflow Flag
			));
			$result$
			output:1
			-postop-
		]],
		NEG = [[
			local result: number = -(input:1 -mod- (2 ^ sizeof:1));
			buffer.writeu32(cpu_buffer, 0, bit32.bor(bit32.bxor(bit32.bor(buffer.readu32(cpu_buffer, 0), 0x8D5), 0x8D5),
				(result % 2) + 						-- Carry Flag
				((result % 256 + 1) % 2) * 4 + 		-- Parity Flag
				(result % 16 == 0 and 16 or 0) + 	-- Auxiliary Carry Flag
				(result == 0 and 64 or 0) + 		-- Zero Flag
				(result < 0 and 128 or 0) +  		-- Sign Flag
				(result > 1000 and 2048 or 0) 		-- Overflow Flag
			));
			$result$
			output:1
			-postop-
		]],
		TEST = [[
			local result: number = bit32.band(input:1, input:2);
			buffer.writeu32(cpu_buffer, 0, bit32.bor(bit32.bxor(bit32.bor(buffer.readu32(cpu_buffer, 0), 0x8D5), 0x8D5),
				(result % 2) + 						-- Carry Flag
				((result % 256 + 1) % 2) * 4 + 		-- Parity Flag
				(result % 16 == 0 and 16 or 0) +	-- Auxiliary Carry Flag
				(result == 0 and 64 or 0) + 		-- Zero Flag
				(result < 0 and 128 or 0) +  		-- Sign Flag
				(result > 1000 and 2048 or 0) 		-- Overflow Flag
			));
			-postop-
		]],
		CMP = [[
			local result: number = defaultRead(registers, opcode % 8 * 4) - input:1;
			buffer.writeu32(cpu_buffer, 0, bit32.bor(bit32.bxor(bit32.bor(buffer.readu32(cpu_buffer, 0), 0x8D5), 0x8D5),
				(result % 2) + 						-- Carry Flag
				((result % 256 + 1) % 2) * 4 + 		-- Parity Flag
				(result % 16 == 0 and 16 or 0) + 	-- Auxiliary Carry Flag
				(result == 0 and 64 or 0) + 		-- Zero Flag
				(result < 0 and 128 or 0) +  		-- Sign Flag
				(result > 1000 and 2048 or 0) 		-- Overflow Flag
			));
			-postop-
		]],
		--DAA = [[]],
		--DAS = [[]],
		--AAM = [[]],
		--AMX = [[]],
		--AAD = [[]],
		--ADX = [[]],
		
	}
}