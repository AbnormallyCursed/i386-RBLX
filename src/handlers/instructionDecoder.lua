--!strict
--!native
local types: {} = require(game:GetService("ServerScriptService"):WaitForChild("i386"):WaitForChild("types"));
return {
	initInstructionDecoder = @native function(self: types._i386): ()
		self.initInstructionDecoder = nil :: never;
		local buffer_max_size: number = self.buffer_max_size;
		local instruction_definitions_single: types._instructionArray;
		local instruction_definitions_multi: types._instructionArray;
		local directArrayPrefix: types._prefixArray = self.directArrayPrefix;
		local directMultiByte: types._instructionByteSwitch;
		local directSingleByte: types._instructionByteSwitch;
		local pre1gbRAM: buffer = self.pre1gb
		coroutine.wrap(function()
			repeat task.wait() until self.multiByteDecoders and self.instruction_definitions_single;
			directMultiByte = self.multiByteDecoders;
			directSingleByte = self.singleByteDecoders;
			instruction_definitions_single = self.instruction_definitions_single;
			instruction_definitions_multi = self.instruction_definitions_multi;
		end)();
		local EIP: number = 0;
		self.master_decode = @native function(): ()
			local EIPQuadByte: number = buffer.readu32(pre1gbRAM, EIP);
			local directMode: types._instructionByteSwitch = directSingleByte;
			for index: number = 0, 3 do
				local byte: number = (EIPQuadByte // 2 ^ (index * 8)) % 256;
				if byte >= 0x0F and directArrayPrefix[byte] then
					if byte == 0x0F then
						directMode = directMultiByte;
					end;
				else
					byte += 1;
					EIP = directMode[byte](EIP + index + 1, EIPQuadByte % 2 ^ (index * 8), byte);
					print(EIP)
					return;
				end;
			end;
		end;
		self.sub_decode_func_single = {
			["soo"] = @native function(EIP: number, binaryPrefix: number, opcode: number, flags: number): number
				local multiByte: number = buffer.readu16(pre1gbRAM, EIP);
				local modRM_byte: number = multiByte // 256 % 256;
				return instruction_definitions_single[opcode + (multiByte % 256 + 1) * 256 + (modRM_byte // 8 % 8 + 1) * 65536](EIP + 2, binaryPrefix, opcode);
			end,
			["so"] = @native function(EIP: number, binaryPrefix: number, opcode: number): number
				return instruction_definitions_single[opcode + (buffer.readu8(pre1gbRAM, EIP) % 256 + 1) * 256](EIP + 1, binaryPrefix, opcode);
			end,
			["o"] = @native function(EIP: number, binaryPrefix: number, opcode: number): number
				local modRM_byte: number = buffer.readu8(pre1gbRAM, EIP);
				print(opcode, EIP)
				return instruction_definitions_single[opcode + (modRM_byte // 8 % 8 + 1) * 65536](EIP + 1, binaryPrefix, opcode);
			end,
		} :: types._subDecode

		self.sub_decode_func_multi = {
			["soo"] = @native function(EIP: number, binaryPrefix: number, opcode: number): number
				local multiByte: number = buffer.readu16(pre1gbRAM, EIP);
				local modRM_byte: number = multiByte // 256 % 256;
				return instruction_definitions_multi[opcode + (multiByte % 256 + 1) * 256 + (modRM_byte // 8 % 8 + 1) * 65536](EIP + 2, binaryPrefix, opcode);
			end,
			["so"] = @native function(EIP: number, binaryPrefix: number, opcode: number): number
				return instruction_definitions_multi[opcode + (buffer.readu8(pre1gbRAM, EIP) % 256 + 1) * 256](EIP + 1, binaryPrefix, opcode);
			end,
			["o"] = @native function(EIP: number, binaryPrefix: number, opcode: number): number
				local modRM_byte: number = buffer.readu8(pre1gbRAM, EIP);
				return instruction_definitions_multi[opcode + (modRM_byte // 8 % 8 + 1) * 65536](EIP + 1, binaryPrefix, opcode);
			end,
		} :: types._subDecode
	end,
}