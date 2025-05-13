return {
	compiler_instr_proto = {
		JO = [[
			local size: number = sizeof:1;
			local sizesqrt: number = (2 ^ size);
			local operand: number = (input:1 -mod- sizesqrt);
			EIP += ((buffer.readu32(cpu_buffer, 0) // 4096 % 2 == 1) and (((operand >= (sizesqrt / 2)) and (operand - sizesqrt - 1)) or operand + (size / 8)));
		]],
		JNO = [[
			local size: number = sizeof:1;
			local sizesqrt: number = (2 ^ size);
			local operand: number = (input:1 -mod- sizesqrt);
			EIP += ((buffer.readu32(cpu_buffer, 0) // 4096 % 2 == 0) and (((operand >= (sizesqrt / 2)) and (operand - sizesqrt - 1)) or operand + (size / 8)));
		]],
		JMP = [[
			local size: number = sizeof:1;
			local sizesqrt: number = (2 ^ size);
			local operand: number = (input:1 -mod- sizesqrt);
			EIP += (((operand >= (sizesqrt / 2)) and (operand - sizesqrt - 1)) or operand + (size / 8));
		]],
		JE = [[
			local size: number = sizeof:1;
			local sizesqrt: number = (2 ^ size);
			local operand: number = (input:1 -mod- sizesqrt);
			EIP += ((buffer.readu32(cpu_buffer, 0) // 128 % 2 == 1) and (((operand >= (sizesqrt / 2)) and (operand - sizesqrt - 1)) or operand + (size / 8)));
		]],
		JG = [[
			local size: number = sizeof:1;
			local sizesqrt: number = (2 ^ size);
			local operand: number = (input:1 -mod- sizesqrt);
			EIP = ((buffer.readu32(cpu_buffer, 0) // 128 % 2 == 0) and ((buffer.readu32(cpu_buffer, 0) // 256 % 2) == (buffer.readu32(cpu_buffer, 0) // 4096 % 2)) and (((operand >= (sizesqrt / 2)) and (operand - sizesqrt - 1)) or operand + (size / 8)));
		]],
		JL = [[
			local size: number = sizeof:1;
			local sizesqrt: number = (2 ^ size);
			local operand: number = (input:1 -mod- sizesqrt);
			EIP += (((buffer.readu32(cpu_buffer, 0) // 256 % 2) ~= (buffer.readu32(cpu_buffer, 0) // 4096 % 2)) and (((operand >= (sizesqrt / 2)) and (operand - sizesqrt - 1)) or operand + (size / 8)));
		]],
		JNL = [[
			local size: number = sizeof:1;
			local sizesqrt: number = (2 ^ size);
			local operand: number = (input:1 -mod- sizesqrt);
			EIP += (((buffer.readu32(cpu_buffer, 0) // 256 % 2) == (buffer.readu32(cpu_buffer, 0) // 4096 % 2)) and (((operand >= (sizesqrt / 2)) and (operand - sizesqrt - 1)) or operand + (size / 8)));
		]],
		JLE = [[
			local size: number = sizeof:1;
			local sizesqrt: number = (2 ^ size);
			local operand: number = (input:1 -mod- sizesqrt);
			EIP += ((buffer.readu32(cpu_buffer, 0) % 2 == 1) or ((buffer.readu32(cpu_buffer, 0) // 256 % 2) ~= (buffer.readu32(cpu_buffer, 0) // 4096 % 2)) and (((operand >= (sizesqrt / 2)) and (operand - sizesqrt - 1)) or operand + (size / 8)));
		]],
		JA = [[
			local size: number = sizeof:1;
			local sizesqrt: number = (2 ^ size);
			local operand: number = (input:1 -mod- sizesqrt);
			EIP += ((buffer.readu32(cpu_buffer, 0) % 2 == 0) and (buffer.readu32(cpu_buffer, 0) // 128 % 2 == 0) and (((operand >= (sizesqrt / 2)) and (operand - sizesqrt - 1)) or operand + (size / 8)));
		]],
		JAE = [[
			local size: number = sizeof:1;
			local sizesqrt: number = (2 ^ size);
			local operand: number = (input:1 -mod- sizesqrt);
			EIP += ((buffer.readu32(cpu_buffer, 0) % 2 == 0) and (((operand >= (sizesqrt / 2)) and (operand - sizesqrt - 1)) or operand + (size / 8)));
		]],
		JB = [[
			local size: number = sizeof:1;
			local sizesqrt: number = (2 ^ size);
			local operand: number = (input:1 -mod- sizesqrt);
			EIP += (((buffer.readu32(cpu_buffer, 0) % 2 == 1) and (buffer.readu32(cpu_buffer, 0) // 128 % 2)) and (((operand >= (sizesqrt / 2)) and (operand - sizesqrt - 1)) or operand + (size / 8)));
		]],
		JBE = [[
			local size: number = sizeof:1;
			local sizesqrt: number = (2 ^ size);
			local operand: number = (input:1 -mod- sizesqrt);
			EIP += (((buffer.readu32(cpu_buffer, 0) % 2 == 1) or (buffer.readu32(cpu_buffer, 0) // 128 % 2)) and (((operand >= (sizesqrt / 2)) and (operand - sizesqrt - 1)) or operand + (size / 8)));
		]],
		JP = [[
			local size: number = sizeof:1;
			local sizesqrt: number = (2 ^ size);
			local operand: number = (input:1 -mod- sizesqrt);
			EIP += ((buffer.readu32(cpu_buffer, 0) // 8 % 2 == 1) and (((operand >= (sizesqrt / 2)) and (operand - sizesqrt - 1)) or operand + (size / 8)));
		]],
		JNP = [[
			local size: number = sizeof:1;
			local sizesqrt: number = (2 ^ size);
			local operand: number = (input:1 -mod- sizesqrt);
			EIP += ((buffer.readu32(cpu_buffer, 0) // 8 % 2 == 0) and (((operand >= (sizesqrt / 2)) and (operand - sizesqrt - 1)) or operand + (size / 8)));
		]],
		JC = [[
			local size: number = sizeof:1;
			local sizesqrt: number = (2 ^ size);
			local operand: number = (input:1 -mod- sizesqrt);
			EIP += ((buffer.readu32(cpu_buffer, 0) % 2 == 1) and (((operand >= (sizesqrt / 2)) and (operand - sizesqrt - 1)) or operand + (size / 8)));
		]],
		JNC = [[
			local size: number = sizeof:1;
			local sizesqrt: number = (2 ^ size);
			local operand: number = (input:1 -mod- sizesqrt);
			EIP += ((buffer.readu32(cpu_buffer, 0) % 2 == 0) and (((operand >= (sizesqrt / 2)) and (operand - sizesqrt - 1)) or operand + (size / 8)));
		]],
		JNZ = [[
			local size: number = sizeof:1;
			local sizesqrt: number = (2 ^ size);
			local operand: number = (input:1 -mod- sizesqrt);
			EIP = ((buffer.readu32(cpu_buffer, 0) // 128 % 2 == 0) and (((operand >= (sizesqrt / 2)) and (operand - sizesqrt - 1)) or operand + (size / 8)));
		]],
		JPO = [[
			local size: number = sizeof:1;
			local sizesqrt: number = (2 ^ size);
			local operand: number = (input:1 -mod- sizesqrt);
			EIP += ((buffer.readu32(cpu_buffer, 0) // 8 % 2 == 0) and (((operand >= (sizesqrt / 2)) and (operand - sizesqrt - 1)) or operand + (size / 8)));
		]],
		JPE = [[
			local size: number = sizeof:1;
			local sizesqrt: number = (2 ^ size);
			local operand: number = (input:1 -mod- sizesqrt);
			EIP += ((buffer.readu32(cpu_buffer, 0) // 8 % 2 == 1) and (((operand >= (sizesqrt / 2)) and (operand - sizesqrt - 1)) or operand + (size / 8)));
		]],
		JS = [[
			local size: number = sizeof:1;
			local sizesqrt: number = (2 ^ size);
			local operand: number = (input:1 -mod- sizesqrt);
			EIP += ((buffer.readu32(cpu_buffer, 0) // 256 % 2 == 1) and (((operand >= (sizesqrt / 2)) and (operand - sizesqrt - 1)) or operand + (size / 8)));
		]],
		JNS = [[
			local size: number = sizeof:1;
			local sizesqrt: number = (2 ^ size);
			local operand: number = (input:1 -mod- sizesqrt);
			EIP += ((buffer.readu32(cpu_buffer, 0) // 256 % 2 == 0) and (((operand >= (sizesqrt / 2)) and (operand - sizesqrt - 1)) or operand + (size / 8)));
		]],
	}
}
