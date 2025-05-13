return {
	compiler_instr_proto = {
		NOP = [[
			-postop-
		]],
		MOV = [[
			$input:2 -mod- (2 ^ sizeof:1)$
			output:1 
			-postop-
		]],
		PUSH = [[
			local size: number = sizeof:1
			local esp: number = defaultRead(registers, 16) - size / 8;
			defaultWrite(pre1GBRam, esp, input:1 -mod- (2 ^ size));
			defaultWrite(registers, 16, esp);
			-postop-
		]],
		POP = [[
			local size: number = sizeof:1
			local esp: number = defaultRead(registers, 16);
			$defaultRead(pre1GBRam, esp) -mod- (2 ^ size)$
			output:1
			defaultWrite(registers, 16, esp + (size / 8));
			-postop-
		]],
		--XLAT = [[]],
		--INT = [[]],
		--INTO = [[]],
		--IRET = [[]],
		--IRETD = [[]],
		--CALLF = [[]],
		-- NOTE: goobus instructions!!!!, MIGHT need to figure segmentation & ringlevel stuff
		CALL = [[
			local esp: number = defaultRead(registers, 16) - 4;
			local size: number = sizeof:1;
			local sizesqrt: number = (2 ^ size);
			local operand: number = (input:1 -mod- sizesqrt);
			defaultWrite(pre1GBRam, esp, EIP + (size / 8));
			EIP += (((operand >= (sizesqrt / 2)) and (operand - sizesqrt - 1)) or operand + (size / 8));
		]],
		RETN = [[
			local esp: number = defaultRead(registers, 16);
			EIP = defaultRead(pre1GBRam, esp);
			esp += 4;
			-- handle 0xC2, 0xCA braindead
			defaultWrite(registers, 16, esp + input:1 or 0);
		]],
		--XCHG = [[]],
		--LEA = [[]],
		--PAUSE = [[]],
		--CBW = [[]],
		--CWDE = [[]],
		--CWD = [[]],
		--CDQ = [[]],
		--LEAVE = [[]],
		--ENTER = [[]],
	}
}
