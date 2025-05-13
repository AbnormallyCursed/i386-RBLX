--!native
--!strict
local types: {} = require(game:GetService("ServerScriptService"):WaitForChild("i386"):WaitForChild("types"));

return {
	single_instruction_constructor = @native function(self: types._i386): ()
		self.single_instruction_constructor = nil :: never;
		local registers: buffer;
		coroutine.wrap(function()
			repeat task.wait() until self.registers
			registers = self.registers
		end)()
		local pre1GBRam: buffer = self.pre1gb
		self.instruction_definitions_single = {
			--[[0x02 + 1] = @native function(EIP: number, prefix: number, opcode: number): number
				local modrm: number = buffer.readu8(pre1GBRam, EIP);
				EIP += 1
				local mod: number = modrm // 64;
				if mod == 0b11 then
					local offsetRM: number = (modrm % 8) * 4;
					buffer.writeu32(registers, offsetRM, (buffer.readu32(registers, offsetRM) + buffer.readu32(registers, (modrm // 8 % 8) * 4)) % 256); -- ADD Operation
				elseif mod == 0b00 then
					local rm: number = modrm % 8;
					if rm == 0b100 then -- SIB byte
						local sibByte: number = buffer.readu8(pre1GBRam, EIP)
						local address: number = 2 ^ (sibByte // 64) * buffer.readu32(registers, (sibByte % 8) * 4) + buffer.readu32(registers, (sibByte // 8 % 8) * 4)
						buffer.writeu32(pre1GBRam, address, (buffer.readu32(pre1GBRam, address) + buffer.readu32(registers, (modrm // 8 % 8) * 4)) % 256);
						EIP += 1;
					elseif rm == 0b101 then -- Displacemenet
						local address: number = buffer.readu32(pre1GBRam, EIP);
						buffer.writeu32(pre1GBRam, address, (buffer.readu32(pre1GBRam, address) + buffer.readu32(registers, (modrm // 8 % 8) * 4)) % 256); -- ADD Operation
						EIP += 1;
					else
						local address: number = buffer.readu32(registers, rm * 4);
						buffer.writeu32(pre1GBRam, address, (buffer.readu32(pre1GBRam, address) + buffer.readu32(registers, (modrm // 8 % 8) * 4)) % 256); -- ADD Operation
					end
				else
					local rm: number = modrm % 8;
					local mask: number = mod % 3;
					if rm == 0b100 then
						local sibByte: number = buffer.readu8(pre1GBRam, EIP);
						local address: number = ((2 ^ (sibByte // 64) * buffer.readu32(registers, (sibByte % 8) * 4)) + buffer.readu32(registers, (sibByte // 8 % 8) * 4)) + buffer.readu32(pre1GBRam, EIP) % (2 ^ (mask * 8));
						buffer.writeu32(pre1GBRam, address, (buffer.readu32(pre1GBRam, address) + buffer.readu32(registers, (modrm // 8 % 8) * 4)) % 256); -- ADD Operation
						EIP += mask ^ 2 + 1;
					else
						local address: number = (buffer.readu32(registers, rm * 4)) + buffer.readu32(pre1GBRam, EIP) % (2 ^ (mask * 8));
						buffer.writeu32(pre1GBRam, address, (buffer.readu32(pre1GBRam, address) + buffer.readu32(registers, (modrm // 8 % 8) * 4)) % 256); -- ADD Operation
						EIP += mask ^ 2;
					end
				end;
				return EIP;
			end,
			[0x89 + 1] = @native function(EIP: number, prefix: number, opcode: number): number
				local modrm: number = buffer.readu8(pre1GBRam, EIP);
				EIP += 1;
				local mod: number = modrm // 64;
				if mod == 0b11 then
					buffer.writeu32(registers, (modrm // 8 % 8) * 4, buffer.readu32(registers, (modrm % 8) * 4) % 256); -- MOV Operation
				elseif mod == 0b00 then
					local rm: number = modrm % 8;
					if rm == 0b101 then -- Displacemenet
						local address: number = buffer.readu32(pre1GBRam, EIP);
						buffer.writeu32(pre1GBRam, address, buffer.readu32(registers, (modrm // 8 % 8) * 4) % 256); -- MOV Operation
						EIP += 1;
					elseif rm == 0b100 then -- SIB byte
						local sibByte: number = buffer.readu8(pre1GBRam, EIP)
						local address: number = 2 ^ (sibByte // 64) * buffer.readu32(registers, (sibByte // 8 % 8) * 4) + buffer.readu32(registers, (sibByte % 8) * 4)
						buffer.writeu32(pre1GBRam, address, buffer.readu32(registers, (modrm // 8 % 8) * 4) % 256);
						EIP += 1;
					else
						local address: number = buffer.readu32(registers, rm * 4);
						buffer.writeu32(pre1GBRam, address, buffer.readu32(registers, (modrm // 8 % 8) * 4) % 256); -- MOV Operation
					end
				else
					local rm: number = modrm % 8;
					local mask: number = mod % 3;
					if rm == 0b100 then -- SIB byte
						local sibByte: number = buffer.readu8(pre1GBRam, EIP);
						local address: number = ((2 ^ (sibByte // 64) * buffer.readu32(registers, (sibByte // 8 % 8) * 4)) + buffer.readu32(registers, (sibByte % 8) * 4)) + buffer.readu32(pre1GBRam, EIP) % (2 ^ (mask * 8));
						buffer.writeu32(pre1GBRam, address, buffer.readu32(registers, (modrm // 8 % 8) * 4) % 256); -- MOV Operation
						EIP += mask ^ 2 + 1;
					else
						local address: number = (buffer.readu32(registers, rm * 4)) + buffer.readu32(pre1GBRam, EIP) % (2 ^ (mask * 8));
						buffer.writeu32(pre1GBRam, address, buffer.readu32(registers, (modrm // 8 % 8) * 4) % 256); -- MOV Operation
						EIP += mask ^ 2;
					end
				end;
				return EIP;
			end,
			[0xB8 + 1] = @native function(EIP: number, prefix: number, opcode: number): number
				buffer.writeu32(registers, 0, buffer.readu32(pre1GBRam, EIP));
				EIP += 4;
				return EIP;
			end,
			[0xB9 + 1] = @native function(EIP: number, prefix: number, opcode: number): number
				buffer.writeu32(registers, 4, buffer.readu32(pre1GBRam, EIP));
				EIP += 4;
				return EIP;
			end,
			[0xBA + 1] = @native function(EIP: number, prefix: number, opcode: number): number
				buffer.writeu32(registers, 8, buffer.readu32(pre1GBRam, EIP));
				EIP += 4;
				return EIP;
			end,
			[0xBB + 1] = @native function(EIP: number, prefix: number, opcode: number): number
				buffer.writeu32(registers, 12, buffer.readu32(pre1GBRam, EIP));
				EIP += 4;
				return EIP;
			end,
			[0xBC + 1] = @native function(EIP: number, prefix: number, opcode: number): number
				buffer.writeu32(registers, 16, buffer.readu32(pre1GBRam, EIP));
				EIP += 4;
				return EIP;
			end,
			[0xBD + 1] = @native function(EIP: number, prefix: number, opcode: number): number
				buffer.writeu32(registers, 20, buffer.readu32(pre1GBRam, EIP));
				EIP += 4;
				return EIP;
			end,
			[0xBE + 1] = @native function(EIP: number, prefix: number, opcode: number): number
				buffer.writeu32(registers, 24, buffer.readu32(pre1GBRam, EIP));
				EIP += 4;
				return EIP;
			end,
			[0xBF + 1] = @native function(EIP: number, prefix: number, opcode: number): number
				buffer.writeu32(registers, 28, buffer.readu32(pre1GBRam, EIP));
				EIP += 4;
				return EIP;
			end,]]
			[0x02 + 1] = @native function(EIP: number, prefix: number, opcode: number)-- ADD: 02 /r
				local modrm: number = buffer.readu8(pre1GBRam, EIP);
				EIP += 1;
				local value: number = 0
				local mod: number = modrm // 64;
				if mod == 0b11 then
					value = buffer.readu32(registers, (modrm % 8) * 4)
				elseif mod == 0b00 then
					local rm: number = modrm % 8;
					if rm == 0b100 then
						local sibByte: number = buffer.readu8(pre1GBRam, EIP)
						value = buffer.readu32(pre1GBRam, 2 ^ (sibByte // 64) * buffer.readu32(registers, (sibByte % 8) * 4) + buffer.readu32(registers, (sibByte // 8 % 8) * 4));
						EIP += 1;
					elseif rm == 0b101 then
						value = buffer.readu32(pre1GBRam, buffer.readu8(pre1GBRam, EIP));
						EIP += 1;
					else
						value = buffer.readu32(pre1GBRam, buffer.readu32(registers, rm * 4))
					end
				else
					local rm: number = modrm % 8;
					local mask: number = mod % 3;
					if rm == 0b100 then
						local sibByte: number = buffer.readu8(pre1GBRam, EIP);
						value = buffer.readu32(pre1GBRam, ((2 ^ (sibByte // 64) * buffer.readu32(registers, (sibByte % 8) * 4)) + buffer.readu32(registers, (sibByte // 8 % 8) * 4)) + buffer.readu32(pre1GBRam, EIP) % (2 ^ (mask * 8)));
						EIP += mask ^ 2 + 1;
					else
						value = buffer.readu32(pre1GBRam, buffer.readu32(registers, rm * 4)) + buffer.readu32(pre1GBRam, EIP) % (2 ^ (mask * 8))
						EIP += mask ^ 2;
					end
				end;
				buffer.writeu32(registers, (((modrm // 8) % 8) * 4), (buffer.readu32(registers, (((modrm // 8) % 8) * 4)) + value) % 256 ) 
				return EIP;
			end,
			[188] = function(EIP: number, prefix: number, opcode: number)-- MOV: BB
				print(buffer.readu32(pre1GBRam, EIP) % (2 ^ (self.osa and 32 or 16)) )
				print(opcode % 8 * 4)
				buffer.writeu32(registers, opcode % 8 * 4,  buffer.readu32(pre1GBRam, EIP) % (2 ^ (self.osa and 32 or 16)) ) 
				EIP += (self.osa and 32 or 16) / 8
				return EIP;
			end,
		}
	end,
}
