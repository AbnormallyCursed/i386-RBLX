--!native
return {
	initModrmSilliness = function(self): ()
		self.initModrmSilliness = nil :: never
		-- lazy rn:
		local read8: (number) -> (number) = self.read8;
		local read16: (number) -> (number) = self.read16;
		local read32: (number) -> (number) = self.read32;
		local write32: (number, number) -> (number) = self.write32;
		local readu32: (buffer, number) -> number = buffer.readu32; -- idk if it matters the size of the register used REEEE
		local writeu32: (buffer, number, number) -> () = buffer.writeu32;
		local registers: buffer;
		local buffer_max_size: number = self.buffer_max_size;
		local buffer_segment: {buffer} = self.buffer_segment;
		coroutine.wrap(function()
			repeat task.wait() until self.registers;
			registers = self.registers;
		end)()
		local decode_sib = @native function(): number
			local sibByte: number = read8(self[0x1])
			self[0x1] += 1
			return ((1 * 2 ^ sibByte // 64) * readu32(registers, sibByte // 8 % 8)) + readu32(registers, sibByte % 8) -- TODO: new buffer for registers, test is required to see if it works
		end
		
		self.modrmRead = {
			[0b00000000] = @native function(): number
				return read32(readu32(registers, 4));
			end,
			[0b00000001] = @native function(): number
				return read32(readu32(registers, 8))
			end,
			[0b00000010] = @native function(): number
				return read32(readu32(registers, 12))
			end,
			[0b00000011] = @native function(): number
				return read32(readu32(registers, 16))
			end,
			[0b00000100] = @native function(): number
				return read32(decode_sib()) -- SIB needed
			end,
			[0b00000101] = @native function(): number
				self[0x1] += 1
				return read32(read32(self[0x1] - 1)) -- displacement only mode
			end,
			[0b00000110] = @native function(): number
				return read32(readu32(registers, 28))
			end,
			[0b00000111] = @native function(): number
				return read32(readu32(registers, 32))
			end,

			[0b01000000] = @native function(): number
				self[0x1] += 1
				return read32(readu32(registers, 4) + read8(self[0x1] - 1))
			end,
			[0b01000001] = @native function(): number
				self[0x1] += 1
				return read32(readu32(registers, 8) + read8(self[0x1] - 1))
			end,
			[0b01000010] = @native function(): number
				self[0x1] += 1
				return read32(readu32(registers, 12) + read8(self[0x1] - 1))
			end,
			[0b01000011] = @native function(): number
				self[0x1] += 1
				return read32(readu32(registers, 16) + read8(self[0x1] - 1))
			end,
			[0b01000100] = @native function(): number 
				self[0x1] += 1
				return read32(decode_sib() + read8(self[0x1] - 1))
			end,
			[0b01000101] = @native function(): number
				self[0x1] += 1
				return read32(readu32(registers, 24) + read8(self[0x1] - 1))
			end,
			[0b01000110] = @native function(): number
				self[0x1] += 1
				return read32(readu32(registers, 28) + read8(self[0x1] - 1))
			end,
			[0b01000111] = @native function(): number
				self[0x1] += 1
				return read32(readu32(registers, 32) + read8(self[0x1] - 1))
			end,

			[0b10000000] = @native function(): number
				self[0x1] += 4
				return read32(readu32(registers, 4) + read32(self[0x1] - 4))
			end,
			[0b10000001] = @native function(): number
				self[0x1] += 4
				return read32(readu32(registers, 8) + read32(self[0x1] - 4))
			end,
			[0b10000010] = @native function(): number
				self[0x1] += 4
				return read32(readu32(registers, 12) + read32(self[0x1] - 4))
			end,
			[0b10000011] = @native function(): number
				self[0x1] += 4
				return read32(readu32(registers, 16) + read32(self[0x1] - 4))
			end,
			[0b10000100] = @native function(): number 
				self[0x1] += 4
				return read32(decode_sib() + read32(self[0x1] - 4))
			end,
			[0b10000101] = @native function(): number
				self[0x1] += 4
				return read32(readu32(registers, 24) + read32(self[0x1] - 4))
			end,
			[0b10000110] = @native function(): number
				self[0x1] += 4
				return read32(readu32(registers, 28) + read32(self[0x1] - 4))
			end,
			[0b10000111] = @native function(): number
				self[0x1] += 4
				return read32(readu32(registers, 32) + read32(self[0x1] - 4))
			end,

			[0b11000000] = @native function(): number
				return readu32(registers, 4)
			end,
			[0b11000001] = @native function(): number
				return readu32(registers, 8)
			end,
			[0b11000010] = @native function(): number
				return readu32(registers, 12)
			end,
			[0b11000011] = @native function(): number
				return readu32(registers, 16)
			end,
			[0b11000100] = @native function(): number
				return readu32(registers, 20)
			end,
			[0b11000101] = @native function(): number
				return readu32(registers, 24)
			end,
			[0b11000110] = @native function(): number
				return readu32(registers, 28)
			end,
			[0b11000111] = @native function(): number
				return readu32(registers, 32)
			end,

			[0b00001000] = @native function(): number
				return read32(readu32(registers, 4))
			end,
			[0b00001001] = @native function(): number
				return read32(readu32(registers, 8))
			end,
			[0b00001010] = @native function(): number
				return read32(readu32(registers, 12))
			end,
			[0b00001011] = @native function(): number
				return read32(readu32(registers, 16))
			end,
			[0b00001100] = @native function(): number
				return read32(decode_sib()) -- SIB needed
			end,
			[0b00001101] = @native function(): number
				self[0x1] += 1
				return read32(read32(self[0x1] - 1)) -- displacement only mode
			end,
			[0b00001110] = @native function(): number
				return read32(readu32(registers, 28))
			end,
			[0b00001111] = @native function(): number
				return read32(readu32(registers, 32))
			end,

			[0b01001000] = @native function(): number
				self[0x1] += 1
				return read32(readu32(registers, 4) + read8(self[0x1] - 1))
			end,
			[0b01001001] = @native function(): number
				self[0x1] += 1
				return read32(readu32(registers, 8) + read8(self[0x1] - 1))
			end,
			[0b01001010] = @native function(): number
				self[0x1] += 1
				return read32(readu32(registers, 12) + read8(self[0x1] - 1))
			end,
			[0b01001011] = @native function(): number
				self[0x1] += 1
				return read32(readu32(registers, 16) + read8(self[0x1] - 1))
			end,
			[0b01001100] = @native function(): number 
				self[0x1] += 1
				return read32(decode_sib() + read8(self[0x1] - 1) )
			end,
			[0b01001101] = @native function(): number
				self[0x1] += 1
				return read32(readu32(registers, 24) + read8(self[0x1] - 1))
			end,
			[0b01001110] = @native function(): number
				self[0x1] += 1
				return read32(readu32(registers, 28) + read8(self[0x1] - 1))
			end,
			[0b01001111] = @native function(): number
				self[0x1] += 1
				return read32(readu32(registers, 32) + read8(self[0x1] - 1))
			end,

			[0b10001000] = @native function(): number
				self[0x1] += 4
				return read32(readu32(registers, 4) + read32(self[0x1] - 4))
			end,
			[0b10001001] = @native function(): number
				self[0x1] += 4
				return read32(readu32(registers, 8) + read32(self[0x1] - 4))
			end,
			[0b10001010] = @native function(): number
				self[0x1] += 4
				return read32(readu32(registers, 12) + read32(self[0x1] - 4))
			end,
			[0b10001011] = @native function(): number
				self[0x1] += 4
				return read32(readu32(registers, 16) + read32(self[0x1] - 4))
			end,
			[0b10001100] = @native function(): number 
				self[0x1] += 4
				return read32(decode_sib() + read32(self[0x1] - 4))
			end,
			[0b10001101] = @native function(): number
				self[0x1] += 4
				return read32(readu32(registers, 24) + read32(self[0x1] - 4))
			end,
			[0b10001110] = @native function(): number
				self[0x1] += 4
				return read32(readu32(registers, 28) + read32(self[0x1] - 4))
			end,
			[0b10001111] = @native function(): number
				self[0x1] += 4
				return read32(readu32(registers, 32) + read32(self[0x1] - 4))
			end,

			[0b11001000] = @native function(): number
				return readu32(registers, 4)
			end,
			[0b11001001] = @native function(): number
				return readu32(registers, 8)
			end,
			[0b11001010] = @native function(): number
				return readu32(registers, 12)
			end,
			[0b11001011] = @native function(): number
				return readu32(registers, 16)
			end,
			[0b11001100] = @native function(): number
				return readu32(registers, 20)
			end,
			[0b11001101] = @native function(): number
				return readu32(registers, 24)
			end,
			[0b11001110] = @native function(): number
				return readu32(registers, 28)
			end,
			[0b11001111] = @native function(): number
				return readu32(registers, 32)
			end,

			[0b00010000] = @native function(): number
				return read32(readu32(registers, 4))
			end,
			[0b00010001] = @native function(): number
				return read32(readu32(registers, 8))
			end,
			[0b00010010] = @native function(): number
				return read32(readu32(registers, 12))
			end,
			[0b00010011] = @native function(): number
				return read32(readu32(registers, 16))
			end,
			[0b00010100] = @native function(): number
				return read32(decode_sib()) -- SIB needed
			end,
			[0b00010101] = @native function(): number
				self[0x1] += 1
				return read32(read32(self[0x1] - 1)) -- displacement only mode
			end,
			[0b00010110] = @native function(): number
				return read32(readu32(registers, 28))
			end,
			[0b00010111] = @native function(): number
				return read32(readu32(registers, 32))
			end,

			[0b01010000] = @native function(): number
				self[0x1] += 1
				return read32(readu32(registers, 4) + read8(self[0x1] - 1))
			end,
			[0b01010001] = @native function(): number
				self[0x1] += 1
				return read32(readu32(registers, 8) + read8(self[0x1] - 1))
			end,
			[0b01010010] = @native function(): number
				self[0x1] += 1
				return read32(readu32(registers, 12) + read8(self[0x1] - 1))
			end,
			[0b01010011] = @native function(): number
				self[0x1] += 1
				return read32(readu32(registers, 16) + read8(self[0x1] - 1))
			end,
			[0b01010100] = @native function(): number 
				self[0x1] += 1
				return read32(decode_sib() + read8(self[0x1] - 1) )
			end,
			[0b01010101] = @native function(): number
				self[0x1] += 1
				return read32(readu32(registers, 24) + read8(self[0x1] - 1))
			end,
			[0b01010110] = @native function(): number
				self[0x1] += 1
				return read32(readu32(registers, 28) + read8(self[0x1] - 1))
			end,
			[0b01010111] = @native function(): number
				self[0x1] += 1
				return read32(readu32(registers, 32) + read8(self[0x1] - 1))
			end,

			[0b10010000] = @native function(): number
				self[0x1] += 4
				return read32(readu32(registers, 4) + read32(self[0x1] - 4))
			end,
			[0b10010001] = @native function(): number
				self[0x1] += 4
				return read32(readu32(registers, 8) + read32(self[0x1] - 4))
			end,
			[0b10010010] = @native function(): number
				self[0x1] += 4
				return read32(readu32(registers, 12) + read32(self[0x1] - 4))
			end,
			[0b10010011] = @native function(): number
				self[0x1] += 4
				return read32(readu32(registers, 16) + read32(self[0x1] - 4))
			end,
			[0b10010100] = @native function(): number 
				self[0x1] += 4
				return read32(decode_sib() + read32(self[0x1] - 4))
			end,
			[0b10010101] = @native function(): number
				self[0x1] += 4
				return read32(readu32(registers, 24) + read32(self[0x1] - 4))
			end,
			[0b10010110] = @native function(): number
				self[0x1] += 4
				return read32(readu32(registers, 28) + read32(self[0x1] - 4))
			end,
			[0b10010111] = @native function(): number
				self[0x1] += 4
				return read32(readu32(registers, 32) + read32(self[0x1] - 4))
			end,

			[0b11010000] = @native function(): number
				return readu32(registers, 4)
			end,
			[0b11010001] = @native function(): number
				return readu32(registers, 8)
			end,
			[0b11010010] = @native function(): number
				return readu32(registers, 12)
			end,
			[0b11010011] = @native function(): number
				return readu32(registers, 16)
			end,
			[0b11010100] = @native function(): number
				return readu32(registers, 20)
			end,
			[0b11010101] = @native function(): number
				return readu32(registers, 24)
			end,
			[0b11010110] = @native function(): number
				return readu32(registers, 28)
			end,
			[0b11010111] = @native function(): number
				return readu32(registers, 32)
			end,

			[0b00011000] = @native function(): number
				return read32(readu32(registers, 4))
			end,
			[0b00011001] = @native function(): number
				return read32(readu32(registers, 8))
			end,
			[0b00011010] = @native function(): number
				return read32(readu32(registers, 12))
			end,
			[0b00011011] = @native function(): number
				return read32(readu32(registers, 16))
			end,
			[0b00011100] = @native function(): number
				return read32(decode_sib()) -- SIB needed
			end,
			[0b00011101] = @native function(): number
				self[0x1] += 1
				return read32(read32(self[0x1] - 1)) -- displacement only mode
			end,
			[0b00011110] = @native function(): number
				return read32(readu32(registers, 28))
			end,
			[0b00011111] = @native function(): number
				return read32(readu32(registers, 32))
			end,

			[0b01011000] = @native function(): number
				self[0x1] += 1
				return read32(readu32(registers, 4) + read8(self[0x1] - 1))
			end,
			[0b01011001] = @native function(): number
				self[0x1] += 1
				return read32(readu32(registers, 8) + read8(self[0x1] - 1))
			end,
			[0b01011010] = @native function(): number
				self[0x1] += 1
				return read32(readu32(registers, 12) + read8(self[0x1] - 1))
			end,
			[0b01011011] = @native function(): number
				self[0x1] += 1
				return read32(readu32(registers, 16) + read8(self[0x1] - 1))
			end,
			[0b01011100] = @native function(): number 
				self[0x1] += 1
				return read32(decode_sib() + read8(self[0x1] - 1) )
			end,
			[0b01011101] = @native function(): number
				self[0x1] += 1
				return read32(readu32(registers, 24) + read8(self[0x1] - 1))
			end,
			[0b01011110] = @native function(): number
				self[0x1] += 1
				return read32(readu32(registers, 28) + read8(self[0x1] - 1))
			end,
			[0b01011111] = @native function(): number
				self[0x1] += 1
				return read32(readu32(registers, 32) + read8(self[0x1] - 1))
			end,

			[0b10011000] = @native function(): number
				self[0x1] += 4
				return read32(readu32(registers, 4) + read32(self[0x1] - 4))
			end,
			[0b10011001] = @native function(): number
				self[0x1] += 4
				return read32(readu32(registers, 8) + read32(self[0x1] - 4))
			end,
			[0b10011010] = @native function(): number
				self[0x1] += 4
				return read32(readu32(registers, 12) + read32(self[0x1] - 4))
			end,
			[0b10011011] = @native function(): number
				self[0x1] += 4
				return read32(readu32(registers, 16) + read32(self[0x1] - 4))
			end,
			[0b10011100] = @native function(): number 
				self[0x1] += 4
				return read32(decode_sib() + read32(self[0x1] - 4))
			end,
			[0b10011101] = @native function(): number
				self[0x1] += 4
				return read32(readu32(registers, 24) + read32(self[0x1] - 4))
			end,
			[0b10011110] = @native function(): number
				self[0x1] += 4
				return read32(readu32(registers, 28) + read32(self[0x1] - 4))
			end,
			[0b10011111] = @native function(): number
				self[0x1] += 4
				return read32(readu32(registers, 32) + read32(self[0x1] - 4))
			end,

			[0b11011000] = @native function(): number
				return readu32(registers, 4)
			end,
			[0b11011001] = @native function(): number
				return readu32(registers, 8)
			end,
			[0b11011010] = @native function(): number
				return readu32(registers, 12)
			end,
			[0b11011011] = @native function(): number
				return readu32(registers, 16)
			end,
			[0b11011100] = @native function(): number
				return readu32(registers, 20)
			end,
			[0b11011101] = @native function(): number
				return readu32(registers, 24)
			end,
			[0b11011110] = @native function(): number
				return readu32(registers, 28)
			end,
			[0b11011111] = @native function(): number
				return readu32(registers, 32)
			end,

			[0b00100000] = @native function(): number
				return read32(readu32(registers, 4))
			end,
			[0b00100001] = @native function(): number
				return read32(readu32(registers, 8))
			end,
			[0b00100010] = @native function(): number
				return read32(readu32(registers, 12))
			end,
			[0b00100011] = @native function(): number
				return read32(readu32(registers, 16))
			end,
			[0b00100100] = @native function(): number
				return read32(decode_sib()) -- SIB needed
			end,
			[0b00100101] = @native function(): number
				self[0x1] += 1
				return read32(read32(self[0x1] - 1)) -- displacement only mode
			end,
			[0b00100110] = @native function(): number
				return read32(readu32(registers, 28))
			end,
			[0b00100111] = @native function(): number
				return read32(readu32(registers, 32))
			end,

			[0b01100000] = @native function(): number
				self[0x1] += 1
				return read32(readu32(registers, 4) + read8(self[0x1] - 1))
			end,
			[0b01100001] = @native function(): number
				self[0x1] += 1
				return read32(readu32(registers, 8) + read8(self[0x1] - 1))
			end,
			[0b01100010] = @native function(): number
				self[0x1] += 1
				return read32(readu32(registers, 12) + read8(self[0x1] - 1))
			end,
			[0b01100011] = @native function(): number
				self[0x1] += 1
				return read32(readu32(registers, 16) + read8(self[0x1] - 1))
			end,
			[0b01100100] = @native function(): number 
				self[0x1] += 1
				return read32(decode_sib() + read8(self[0x1] - 1) )
			end,
			[0b01100101] = @native function(): number
				self[0x1] += 1
				return read32(readu32(registers, 24) + read8(self[0x1] - 1))
			end,
			[0b01100110] = @native function(): number
				self[0x1] += 1
				return read32(readu32(registers, 28) + read8(self[0x1] - 1))
			end,
			[0b01100111] = @native function(): number
				self[0x1] += 1
				return read32(readu32(registers, 32) + read8(self[0x1] - 1))
			end,

			[0b10100000] = @native function(): number
				self[0x1] += 4
				return read32(readu32(registers, 4) + read32(self[0x1] - 4))
			end,
			[0b10100001] = @native function(): number
				self[0x1] += 4
				return read32(readu32(registers, 8) + read32(self[0x1] - 4))
			end,
			[0b10100010] = @native function(): number
				self[0x1] += 4
				return read32(readu32(registers, 12) + read32(self[0x1] - 4))
			end,
			[0b10100011] = @native function(): number
				self[0x1] += 4
				return read32(readu32(registers, 16) + read32(self[0x1] - 4))
			end,
			[0b10100100] = @native function(): number 
				self[0x1] += 4
				return read32(decode_sib() + read32(self[0x1] - 4))
			end,
			[0b10100101] = @native function(): number
				self[0x1] += 4
				return read32(readu32(registers, 24) + read32(self[0x1] - 4))
			end,
			[0b10100110] = @native function(): number
				self[0x1] += 4
				return read32(readu32(registers, 28) + read32(self[0x1] - 4))
			end,
			[0b10100111] = @native function(): number
				self[0x1] += 4
				return read32(readu32(registers, 32) + read32(self[0x1] - 4))
			end,

			[0b11100000] = @native function(): number
				return readu32(registers, 4)
			end,
			[0b11100001] = @native function(): number
				return readu32(registers, 8)
			end,
			[0b11100010] = @native function(): number
				return readu32(registers, 12)
			end,
			[0b11100011] = @native function(): number
				return readu32(registers, 16)
			end,
			[0b11100100] = @native function(): number
				return readu32(registers, 20)
			end,
			[0b11100101] = @native function(): number
				return readu32(registers, 24)
			end,
			[0b11100110] = @native function(): number
				return readu32(registers, 28)
			end,
			[0b11100111] = @native function(): number
				return readu32(registers, 32)
			end,

			[0b00101000] = @native function(): number
				return read32(readu32(registers, 4))
			end,
			[0b00101001] = @native function(): number
				return read32(readu32(registers, 8))
			end,
			[0b00101010] = @native function(): number
				return read32(readu32(registers, 12))
			end,
			[0b00101011] = @native function(): number
				return read32(readu32(registers, 16))
			end,
			[0b00101100] = @native function(): number
				return read32(decode_sib()) -- SIB needed
			end,
			[0b00101101] = @native function(): number
				self[0x1] += 1
				return read32(read32(self[0x1] - 1)) -- displacement only mode
			end,
			[0b00101110] = @native function(): number
				return read32(readu32(registers, 28))
			end,
			[0b00101111] = @native function(): number
				return read32(readu32(registers, 32))
			end,

			[0b01101000] = @native function(): number
				self[0x1] += 1
				return read32(readu32(registers, 4) + read8(self[0x1] - 1))
			end,
			[0b01101001] = @native function(): number
				self[0x1] += 1
				return read32(readu32(registers, 8) + read8(self[0x1] - 1))
			end,
			[0b01101010] = @native function(): number
				self[0x1] += 1
				return read32(readu32(registers, 12) + read8(self[0x1] - 1))
			end,
			[0b01101011] = @native function(): number
				self[0x1] += 1
				return read32(readu32(registers, 16) + read8(self[0x1] - 1))
			end,
			[0b01101100] = @native function(): number 
				self[0x1] += 1
				return read32(decode_sib() + read8(self[0x1] - 1) )
			end,
			[0b01101101] = @native function(): number
				self[0x1] += 1
				return read32(readu32(registers, 24) + read8(self[0x1] - 1))
			end,
			[0b01101110] = @native function(): number
				self[0x1] += 1
				return read32(readu32(registers, 28) + read8(self[0x1] - 1))
			end,
			[0b01101111] = @native function(): number
				self[0x1] += 1
				return read32(readu32(registers, 32) + read8(self[0x1] - 1))
			end,

			[0b10101000] = @native function(): number
				self[0x1] += 4
				return read32(readu32(registers, 4) + read32(self[0x1] - 4))
			end,
			[0b10101001] = @native function(): number
				self[0x1] += 4
				return read32(readu32(registers, 8) + read32(self[0x1] - 4))
			end,
			[0b10101010] = @native function(): number
				self[0x1] += 4
				return read32(readu32(registers, 12) + read32(self[0x1] - 4))
			end,
			[0b10101011] = @native function(): number
				self[0x1] += 4
				return read32(readu32(registers, 16) + read32(self[0x1] - 4))
			end,
			[0b10101100] = @native function(): number 
				self[0x1] += 4
				return read32(decode_sib() + read32(self[0x1] - 4))
			end,
			[0b10101101] = @native function(): number
				self[0x1] += 4
				return read32(readu32(registers, 24) + read32(self[0x1] - 4))
			end,
			[0b10101110] = @native function(): number
				self[0x1] += 4
				return read32(readu32(registers, 28) + read32(self[0x1] - 4))
			end,
			[0b10101111] = @native function(): number
				self[0x1] += 4
				return read32(readu32(registers, 32) + read32(self[0x1] - 4))
			end,

			[0b11101000] = @native function(): number
				return readu32(registers, 4)
			end,
			[0b11101001] = @native function(): number
				return readu32(registers, 8)
			end,
			[0b11101010] = @native function(): number
				return readu32(registers, 12)
			end,
			[0b11101011] = @native function(): number
				return readu32(registers, 16)
			end,
			[0b11101100] = @native function(): number
				return readu32(registers, 20)
			end,
			[0b11101101] = @native function(): number
				return readu32(registers, 24)
			end,
			[0b11101110] = @native function(): number
				return readu32(registers, 28)
			end,
			[0b11101111] = @native function(): number
				return readu32(registers, 32)
			end,

			[0b00110000] = @native function(): number
				return read32(readu32(registers, 4))
			end,
			[0b00110001] = @native function(): number
				return read32(readu32(registers, 8))
			end,
			[0b00110010] = @native function(): number
				return read32(readu32(registers, 12))
			end,
			[0b00110011] = @native function(): number
				return read32(readu32(registers, 16))
			end,
			[0b00110100] = @native function(): number
				return read32(decode_sib()) -- SIB needed
			end,
			[0b00110101] = @native function(): number
				self[0x1] += 1
				return read32(read32(self[0x1] - 1)) -- displacement only mode
			end,
			[0b00110110] = @native function(): number
				return read32(readu32(registers, 28))
			end,
			[0b00110111] = @native function(): number
				return read32(readu32(registers, 32))
			end,

			[0b01110000] = @native function(): number
				self[0x1] += 1
				return read32(readu32(registers, 4) + read8(self[0x1] - 1))
			end,
			[0b01110001] = @native function(): number
				self[0x1] += 1
				return read32(readu32(registers, 8) + read8(self[0x1] - 1))
			end,
			[0b01110010] = @native function(): number
				self[0x1] += 1
				return read32(readu32(registers, 12) + read8(self[0x1] - 1))
			end,
			[0b01110011] = @native function(): number
				self[0x1] += 1
				return read32(readu32(registers, 16) + read8(self[0x1] - 1))
			end,
			[0b01110100] = @native function(): number 
				self[0x1] += 1
				return read32(decode_sib() + read8(self[0x1] - 1) )
			end,
			[0b01110101] = @native function(): number
				self[0x1] += 1
				return read32(readu32(registers, 24) + read8(self[0x1] - 1))
			end,
			[0b01110110] = @native function(): number
				self[0x1] += 1
				return read32(readu32(registers, 28) + read8(self[0x1] - 1))
			end,
			[0b01110111] = @native function(): number
				self[0x1] += 1
				return read32(readu32(registers, 32) + read8(self[0x1] - 1))
			end,

			[0b10110000] = @native function(): number
				self[0x1] += 4
				return read32(readu32(registers, 4) + read32(self[0x1] - 4))
			end,
			[0b10110001] = @native function(): number
				self[0x1] += 4
				return read32(readu32(registers, 8) + read32(self[0x1] - 4))
			end,
			[0b10110010] = @native function(): number
				self[0x1] += 4
				return read32(readu32(registers, 12) + read32(self[0x1] - 4))
			end,
			[0b10110011] = @native function(): number
				self[0x1] += 4
				return read32(readu32(registers, 16) + read32(self[0x1] - 4))
			end,
			[0b10110100] = @native function(): number 
				self[0x1] += 4
				return read32(decode_sib() + read32(self[0x1] - 4))
			end,
			[0b10110101] = @native function(): number
				self[0x1] += 4
				return read32(readu32(registers, 24) + read32(self[0x1] - 4))
			end,
			[0b10110110] = @native function(): number
				self[0x1] += 4
				return read32(readu32(registers, 28) + read32(self[0x1] - 4))
			end,
			[0b10110111] = @native function(): number
				self[0x1] += 4
				return read32(readu32(registers, 32) + read32(self[0x1] - 4))
			end,

			[0b11110000] = @native function(): number
				return readu32(registers, 4)
			end,
			[0b11110001] = @native function(): number
				return readu32(registers, 8)
			end,
			[0b11110010] = @native function(): number
				return readu32(registers, 12)
			end,
			[0b11110011] = @native function(): number
				return readu32(registers, 16)
			end,
			[0b11110100] = @native function(): number
				return readu32(registers, 20)
			end,
			[0b11110101] = @native function(): number
				return readu32(registers, 24)
			end,
			[0b11110110] = @native function(): number
				return readu32(registers, 28)
			end,
			[0b11110111] = @native function(): number
				return readu32(registers, 32)
			end,

			[0b00111000] = @native function(): number
				return read32(readu32(registers, 4))
			end,
			[0b00111001] = @native function(): number
				return read32(readu32(registers, 8))
			end,
			[0b00111010] = @native function(): number
				return read32(readu32(registers, 12))
			end,
			[0b00111011] = @native function(): number
				return read32(readu32(registers, 16))
			end,
			[0b00111100] = @native function(): number
				return read32(decode_sib()) -- SIB needed
			end,
			[0b00111101] = @native function(): number
				self[0x1] += 1
				return read32(read32(self[0x1] - 1)) -- displacement only mode
			end,
			[0b00111110] = @native function(): number
				return read32(readu32(registers, 28))
			end,
			[0b00111111] = @native function(): number
				return read32(readu32(registers, 32))
			end,

			[0b01111000] = @native function(): number
				self[0x1] += 1
				return read32(readu32(registers, 4) + read8(self[0x1] - 1))
			end,
			[0b01111001] = @native function(): number
				self[0x1] += 1
				return read32(readu32(registers, 8) + read8(self[0x1] - 1))
			end,
			[0b01111010] = @native function(): number
				self[0x1] += 1
				return read32(readu32(registers, 12) + read8(self[0x1] - 1))
			end,
			[0b01111011] = @native function(): number
				self[0x1] += 1
				return read32(readu32(registers, 16) + read8(self[0x1] - 1))
			end,
			[0b01111100] = @native function(): number 
				self[0x1] += 1
				return read32(decode_sib() + read8(self[0x1] - 1) )
			end,
			[0b01111101] = @native function(): number
				self[0x1] += 1
				return read32(readu32(registers, 24) + read8(self[0x1] - 1))
			end,
			[0b01111110] = @native function(): number
				self[0x1] += 1
				return read32(readu32(registers, 28) + read8(self[0x1] - 1))
			end,
			[0b01111111] = @native function(): number
				self[0x1] += 1
				return read32(readu32(registers, 32) + read8(self[0x1] - 1))
			end,

			[0b10111000] = @native function(): number
				self[0x1] += 4
				return read32(readu32(registers, 4) + read32(self[0x1] - 4))
			end,
			[0b10111001] = @native function(): number
				self[0x1] += 4
				return read32(readu32(registers, 8) + read32(self[0x1] - 4))
			end,
			[0b10111010] = @native function(): number
				self[0x1] += 4
				return read32(readu32(registers, 12) + read32(self[0x1] - 4))
			end,
			[0b10111011] = @native function(): number
				self[0x1] += 4
				return read32(readu32(registers, 16) + read32(self[0x1] - 4))
			end,
			[0b10111100] = @native function(): number 
				self[0x1] += 4
				return read32(decode_sib() + read32(self[0x1] - 4))
			end,
			[0b10111101] = @native function(): number
				self[0x1] += 4
				return read32(readu32(registers, 24) + read32(self[0x1] - 4))
			end,
			[0b10111110] = @native function(): number
				self[0x1] += 4
				return read32(readu32(registers, 28) + read32(self[0x1] - 4))
			end,
			[0b10111111] = @native function(): number
				self[0x1] += 4
				return read32(readu32(registers, 32) + read32(self[0x1] - 4))
			end,

			[0b11111000] = @native function(): number
				return readu32(registers, 4)
			end,
			[0b11111001] = @native function(): number
				return readu32(registers, 8)
			end,
			[0b11111010] = @native function(): number
				return readu32(registers, 12)
			end,
			[0b11111011] = @native function(): number
				return readu32(registers, 16)
			end,
			[0b11111100] = @native function(): number
				return readu32(registers, 20)
			end,
			[0b11111101] = @native function(): number
				return readu32(registers, 24)
			end,
			[0b11111110] = @native function(): number
				return readu32(registers, 28)
			end,
			[0b11111111] = @native function(): number
				return readu32(registers, 32)
			end,

		}
		
		self.modrmWrite = {

			[0b00000000] = @native function(value: number): number
				write32(readu32(registers, 4), value)
			end,
			[0b00000001] = @native function(value: number): number
				write32(readu32(registers, 8), value)
			end,
			[0b00000010] = @native function(value: number): number
				write32(readu32(registers, 12), value)
			end,
			[0b00000011] = @native function(value: number): number
				write32(readu32(registers, 16), value)
			end,
			[0b00000100] = @native function(value: number): number
				write32(decode_sib(), value) -- SIB needed
			end,
			[0b00000101] = @native function(value: number): number
				self[0x1] += 1
				write32(read32(self[0x1] - 1), value) -- displacement only mode
			end,
			[0b00000110] = @native function(value: number): number
				write32(readu32(registers, 28), value)
			end,
			[0b00000111] = @native function(value: number): number
				write32(readu32(registers, 32), value)
			end,

			[0b01000000] = @native function(value: number): number
				self[0x1] += 1
				write32(readu32(registers, 4) + read8(self[0x1] - 1), value)
			end,
			[0b01000001] = @native function(value: number): number
				self[0x1] += 1
				write32(readu32(registers, 8) + read8(self[0x1] - 1), value)
			end,
			[0b01000010] = @native function(value: number): number
				self[0x1] += 1
				write32(readu32(registers, 12) + read8(self[0x1] - 1), value)
			end,
			[0b01000011] = @native function(value: number): number
				self[0x1] += 1
				write32(readu32(registers, 16) + read8(self[0x1] - 1), value)
			end,
			[0b01000100] = @native function(value: number): number 
				self[0x1] += 1
				read32(decode_sib() + read8(self[0x1] - 1), value )
			end,
			[0b01000101] = @native function(value: number): number
				self[0x1] += 1
				write32(readu32(registers, 24) + read8(self[0x1] - 1), value)
			end,
			[0b01000110] = @native function(value: number): number
				self[0x1] += 1
				write32(readu32(registers, 28) + read8(self[0x1] - 1), value)
			end,
			[0b01000111] = @native function(value: number): number
				self[0x1] += 1
				write32(readu32(registers, 32) + read8(self[0x1] - 1), value)
			end,

			[0b10000000] = @native function(value: number): number
				self[0x1] += 4
				write32(readu32(registers, 4) + read32(self[0x1] - 4), value)
			end,
			[0b10000001] = @native function(value: number): number
				self[0x1] += 4
				write32(readu32(registers, 8) + read32(self[0x1] - 4), value)
			end,
			[0b10000010] = @native function(value: number): number
				self[0x1] += 4
				write32(readu32(registers, 12) + read32(self[0x1] - 4), value)
			end,
			[0b10000011] = @native function(value: number): number
				self[0x1] += 4
				write32(readu32(registers, 16) + read32(self[0x1] - 4), value)
			end,
			[0b10000100] = @native function(value: number): number 
				self[0x1] += 4
				write32(decode_sib() + read32(self[0x1] - 4), value)
			end,
			[0b10000101] = @native function(value: number): number
				self[0x1] += 4
				write32(readu32(registers, 24) + read32(self[0x1] - 4), value)
			end,
			[0b10000110] = @native function(value: number): number
				self[0x1] += 4
				write32(readu32(registers, 28) + read32(self[0x1] - 4), value)
			end,
			[0b10000111] = @native function(value: number): number
				self[0x1] += 4
				write32(readu32(registers, 32) + read32(self[0x1] - 4), value)
			end,

			[0b11000000] = @native function(value: number): number
				writeu32(registers, 4, value)
			end,
			[0b11000001] = @native function(value: number): number
				writeu32(registers, 8, value)
			end,
			[0b11000010] = @native function(value: number): number
				writeu32(registers, 12, value)
			end,
			[0b11000011] = @native function(value: number): number
				writeu32(registers, 16, value)
			end,
			[0b11000100] = @native function(value: number): number
				writeu32(registers, 20, value)
			end,
			[0b11000101] = @native function(value: number): number
				writeu32(registers, 24, value)
			end,
			[0b11000110] = @native function(value: number): number
				writeu32(registers, 28, value)
			end,
			[0b11000111] = @native function(value: number): number
				writeu32(registers, 32, value)
			end,

			[0b00001000] = @native function(value: number): number
				write32(readu32(registers, 4), value)
			end,
			[0b00001001] = @native function(value: number): number
				write32(readu32(registers, 8), value)
			end,
			[0b00001010] = @native function(value: number): number
				write32(readu32(registers, 12), value)
			end,
			[0b00001011] = @native function(value: number): number
				write32(readu32(registers, 16), value)
			end,
			[0b00001100] = @native function(value: number): number
				write32(decode_sib(), value) -- SIB needed
			end,
			[0b00001101] = @native function(value: number): number
				self[0x1] += 1
				write32(read32(self[0x1] - 1), value) -- displacement only mode
			end,
			[0b00001110] = @native function(value: number): number
				write32(readu32(registers, 28), value)
			end,
			[0b00001111] = @native function(value: number): number
				write32(readu32(registers, 32), value)
			end,

			[0b01001000] = @native function(value: number): number
				self[0x1] += 1
				write32(readu32(registers, 4) + read8(self[0x1] - 1), value)
			end,
			[0b01001001] = @native function(value: number): number
				self[0x1] += 1
				write32(readu32(registers, 8) + read8(self[0x1] - 1), value)
			end,
			[0b01001010] = @native function(value: number): number
				self[0x1] += 1
				write32(readu32(registers, 12) + read8(self[0x1] - 1), value)
			end,
			[0b01001011] = @native function(value: number): number
				self[0x1] += 1
				write32(readu32(registers, 16) + read8(self[0x1] - 1), value)
			end,
			[0b01001100] = @native function(value: number): number 
				self[0x1] += 1
				read32(decode_sib() + read8(self[0x1] - 1), value )
			end,
			[0b01001101] = @native function(value: number): number
				self[0x1] += 1
				write32(readu32(registers, 24) + read8(self[0x1] - 1), value)
			end,
			[0b01001110] = @native function(value: number): number
				self[0x1] += 1
				write32(readu32(registers, 28) + read8(self[0x1] - 1), value)
			end,
			[0b01001111] = @native function(value: number): number
				self[0x1] += 1
				write32(readu32(registers, 32) + read8(self[0x1] - 1), value)
			end,

			[0b10001000] = @native function(value: number): number
				self[0x1] += 4
				write32(readu32(registers, 4) + read32(self[0x1] - 4), value)
			end,
			[0b10001001] = @native function(value: number): number
				self[0x1] += 4
				write32(readu32(registers, 8) + read32(self[0x1] - 4), value)
			end,
			[0b10001010] = @native function(value: number): number
				self[0x1] += 4
				write32(readu32(registers, 12) + read32(self[0x1] - 4), value)
			end,
			[0b10001011] = @native function(value: number): number
				self[0x1] += 4
				write32(readu32(registers, 16) + read32(self[0x1] - 4), value)
			end,
			[0b10001100] = @native function(value: number): number 
				self[0x1] += 4
				write32(decode_sib() + read32(self[0x1] - 4), value)
			end,
			[0b10001101] = @native function(value: number): number
				self[0x1] += 4
				write32(readu32(registers, 24) + read32(self[0x1] - 4), value)
			end,
			[0b10001110] = @native function(value: number): number
				self[0x1] += 4
				write32(readu32(registers, 28) + read32(self[0x1] - 4), value)
			end,
			[0b10001111] = @native function(value: number): number
				self[0x1] += 4
				write32(readu32(registers, 32) + read32(self[0x1] - 4), value)
			end,

			[0b11001000] = @native function(value: number): number
				writeu32(registers, 4, value)
			end,
			[0b11001001] = @native function(value: number): number
				writeu32(registers, 8, value)
			end,
			[0b11001010] = @native function(value: number): number
				writeu32(registers, 12, value)
			end,
			[0b11001011] = @native function(value: number): number
				writeu32(registers, 16, value)
			end,
			[0b11001100] = @native function(value: number): number
				writeu32(registers, 20, value)
			end,
			[0b11001101] = @native function(value: number): number
				writeu32(registers, 24, value)
			end,
			[0b11001110] = @native function(value: number): number
				writeu32(registers, 28, value)
			end,
			[0b11001111] = @native function(value: number): number
				writeu32(registers, 32, value)
			end,

			[0b00010000] = @native function(value: number): number
				write32(readu32(registers, 4), value)
			end,
			[0b00010001] = @native function(value: number): number
				write32(readu32(registers, 8), value)
			end,
			[0b00010010] = @native function(value: number): number
				write32(readu32(registers, 12), value)
			end,
			[0b00010011] = @native function(value: number): number
				write32(readu32(registers, 16), value)
			end,
			[0b00010100] = @native function(value: number): number
				write32(decode_sib(), value) -- SIB needed
			end,
			[0b00010101] = @native function(value: number): number
				self[0x1] += 1
				write32(read32(self[0x1] - 1), value) -- displacement only mode
			end,
			[0b00010110] = @native function(value: number): number
				write32(readu32(registers, 28), value)
			end,
			[0b00010111] = @native function(value: number): number
				write32(readu32(registers, 32), value)
			end,

			[0b01010000] = @native function(value: number): number
				self[0x1] += 1
				write32(readu32(registers, 4) + read8(self[0x1] - 1), value)
			end,
			[0b01010001] = @native function(value: number): number
				self[0x1] += 1
				write32(readu32(registers, 8) + read8(self[0x1] - 1), value)
			end,
			[0b01010010] = @native function(value: number): number
				self[0x1] += 1
				write32(readu32(registers, 12) + read8(self[0x1] - 1), value)
			end,
			[0b01010011] = @native function(value: number): number
				self[0x1] += 1
				write32(readu32(registers, 16) + read8(self[0x1] - 1), value)
			end,
			[0b01010100] = @native function(value: number): number 
				self[0x1] += 1
				read32(decode_sib() + read8(self[0x1] - 1), value )
			end,
			[0b01010101] = @native function(value: number): number
				self[0x1] += 1
				write32(readu32(registers, 24) + read8(self[0x1] - 1), value)
			end,
			[0b01010110] = @native function(value: number): number
				self[0x1] += 1
				write32(readu32(registers, 28) + read8(self[0x1] - 1), value)
			end,
			[0b01010111] = @native function(value: number): number
				self[0x1] += 1
				write32(readu32(registers, 32) + read8(self[0x1] - 1), value)
			end,

			[0b10010000] = @native function(value: number): number
				self[0x1] += 4
				write32(readu32(registers, 4) + read32(self[0x1] - 4), value)
			end,
			[0b10010001] = @native function(value: number): number
				self[0x1] += 4
				write32(readu32(registers, 8) + read32(self[0x1] - 4), value)
			end,
			[0b10010010] = @native function(value: number): number
				self[0x1] += 4
				write32(readu32(registers, 12) + read32(self[0x1] - 4), value)
			end,
			[0b10010011] = @native function(value: number): number
				self[0x1] += 4
				write32(readu32(registers, 16) + read32(self[0x1] - 4), value)
			end,
			[0b10010100] = @native function(value: number): number 
				self[0x1] += 4
				write32(decode_sib() + read32(self[0x1] - 4), value)
			end,
			[0b10010101] = @native function(value: number): number
				self[0x1] += 4
				write32(readu32(registers, 24) + read32(self[0x1] - 4), value)
			end,
			[0b10010110] = @native function(value: number): number
				self[0x1] += 4
				write32(readu32(registers, 28) + read32(self[0x1] - 4), value)
			end,
			[0b10010111] = @native function(value: number): number
				self[0x1] += 4
				write32(readu32(registers, 32) + read32(self[0x1] - 4), value)
			end,

			[0b11010000] = @native function(value: number): number
				writeu32(registers, 4, value)
			end,
			[0b11010001] = @native function(value: number): number
				writeu32(registers, 8, value)
			end,
			[0b11010010] = @native function(value: number): number
				writeu32(registers, 12, value)
			end,
			[0b11010011] = @native function(value: number): number
				writeu32(registers, 16, value)
			end,
			[0b11010100] = @native function(value: number): number
				writeu32(registers, 20, value)
			end,
			[0b11010101] = @native function(value: number): number
				writeu32(registers, 24, value)
			end,
			[0b11010110] = @native function(value: number): number
				writeu32(registers, 28, value)
			end,
			[0b11010111] = @native function(value: number): number
				writeu32(registers, 32, value)
			end,

			[0b00011000] = @native function(value: number): number
				write32(readu32(registers, 4), value)
			end,
			[0b00011001] = @native function(value: number): number
				write32(readu32(registers, 8), value)
			end,
			[0b00011010] = @native function(value: number): number
				write32(readu32(registers, 12), value)
			end,
			[0b00011011] = @native function(value: number): number
				write32(readu32(registers, 16), value)
			end,
			[0b00011100] = @native function(value: number): number
				write32(decode_sib(), value) -- SIB needed
			end,
			[0b00011101] = @native function(value: number): number
				self[0x1] += 1
				write32(read32(self[0x1] - 1), value) -- displacement only mode
			end,
			[0b00011110] = @native function(value: number): number
				write32(readu32(registers, 28), value)
			end,
			[0b00011111] = @native function(value: number): number
				write32(readu32(registers, 32), value)
			end,

			[0b01011000] = @native function(value: number): number
				self[0x1] += 1
				write32(readu32(registers, 4) + read8(self[0x1] - 1), value)
			end,
			[0b01011001] = @native function(value: number): number
				self[0x1] += 1
				write32(readu32(registers, 8) + read8(self[0x1] - 1), value)
			end,
			[0b01011010] = @native function(value: number): number
				self[0x1] += 1
				write32(readu32(registers, 12) + read8(self[0x1] - 1), value)
			end,
			[0b01011011] = @native function(value: number): number
				self[0x1] += 1
				write32(readu32(registers, 16) + read8(self[0x1] - 1), value)
			end,
			[0b01011100] = @native function(value: number): number 
				self[0x1] += 1
				read32(decode_sib() + read8(self[0x1] - 1), value)
			end,
			[0b01011101] = @native function(value: number): number
				self[0x1] += 1
				write32(readu32(registers, 24) + read8(self[0x1] - 1), value)
			end,
			[0b01011110] = @native function(value: number): number
				self[0x1] += 1
				write32(readu32(registers, 28) + read8(self[0x1] - 1), value)
			end,
			[0b01011111] = @native function(value: number): number
				self[0x1] += 1
				write32(readu32(registers, 32) + read8(self[0x1] - 1), value)
			end,

			[0b10011000] = @native function(value: number): number
				self[0x1] += 4
				write32(readu32(registers, 4) + read32(self[0x1] - 4), value)
			end,
			[0b10011001] = @native function(value: number): number
				self[0x1] += 4
				write32(readu32(registers, 8) + read32(self[0x1] - 4), value)
			end,
			[0b10011010] = @native function(value: number): number
				self[0x1] += 4
				write32(readu32(registers, 12) + read32(self[0x1] - 4), value)
			end,
			[0b10011011] = @native function(value: number): number
				self[0x1] += 4
				write32(readu32(registers, 16) + read32(self[0x1] - 4), value)
			end,
			[0b10011100] = @native function(value: number): number 
				self[0x1] += 4
				write32(decode_sib() + read32(self[0x1] - 4), value)
			end,
			[0b10011101] = @native function(value: number): number
				self[0x1] += 4
				write32(readu32(registers, 24) + read32(self[0x1] - 4), value)
			end,
			[0b10011110] = @native function(value: number): number
				self[0x1] += 4
				write32(readu32(registers, 28) + read32(self[0x1] - 4), value)
			end,
			[0b10011111] = @native function(value: number): number
				self[0x1] += 4
				write32(readu32(registers, 32) + read32(self[0x1] - 4), value)
			end,

			[0b11011000] = @native function(value: number): number
				writeu32(registers, 4, value)
			end,
			[0b11011001] = @native function(value: number): number
				writeu32(registers, 8, value)
			end,
			[0b11011010] = @native function(value: number): number
				writeu32(registers, 12, value)
			end,
			[0b11011011] = @native function(value: number): number
				writeu32(registers, 16, value)
			end,
			[0b11011100] = @native function(value: number): number
				writeu32(registers, 20, value)
			end,
			[0b11011101] = @native function(value: number): number
				writeu32(registers, 24, value)
			end,
			[0b11011110] = @native function(value: number): number
				writeu32(registers, 28, value)
			end,
			[0b11011111] = @native function(value: number): number
				writeu32(registers, 32, value)
			end,

			[0b00100000] = @native function(value: number): number
				write32(readu32(registers, 4), value)
			end,
			[0b00100001] = @native function(value: number): number
				write32(readu32(registers, 8), value)
			end,
			[0b00100010] = @native function(value: number): number
				write32(readu32(registers, 12), value)
			end,
			[0b00100011] = @native function(value: number): number
				write32(readu32(registers, 16), value)
			end,
			[0b00100100] = @native function(value: number): number
				write32(decode_sib(), value) -- SIB needed
			end,
			[0b00100101] = @native function(value: number): number
				self[0x1] += 1
				write32(read32(self[0x1] - 1), value) -- displacement only mode
			end,
			[0b00100110] = @native function(value: number): number
				write32(readu32(registers, 28), value)
			end,
			[0b00100111] = @native function(value: number): number
				write32(readu32(registers, 32), value)
			end,

			[0b01100000] = @native function(value: number): number
				self[0x1] += 1
				write32(readu32(registers, 4) + read8(self[0x1] - 1), value)
			end,
			[0b01100001] = @native function(value: number): number
				self[0x1] += 1
				write32(readu32(registers, 8) + read8(self[0x1] - 1), value)
			end,
			[0b01100010] = @native function(value: number): number
				self[0x1] += 1
				write32(readu32(registers, 12) + read8(self[0x1] - 1), value)
			end,
			[0b01100011] = @native function(value: number): number
				self[0x1] += 1
				write32(readu32(registers, 16) + read8(self[0x1] - 1), value)
			end,
			[0b01100100] = @native function(value: number): number 
				self[0x1] += 1
				read32(decode_sib() + read8(self[0x1] - 1), value )
			end,
			[0b01100101] = @native function(value: number): number
				self[0x1] += 1
				write32(readu32(registers, 24) + read8(self[0x1] - 1), value)
			end,
			[0b01100110] = @native function(value: number): number
				self[0x1] += 1
				write32(readu32(registers, 28) + read8(self[0x1] - 1), value)
			end,
			[0b01100111] = @native function(value: number): number
				self[0x1] += 1
				write32(readu32(registers, 32) + read8(self[0x1] - 1), value)
			end,

			[0b10100000] = @native function(value: number): number
				self[0x1] += 4
				write32(readu32(registers, 4) + read32(self[0x1] - 4), value)
			end,
			[0b10100001] = @native function(value: number): number
				self[0x1] += 4
				write32(readu32(registers, 8) + read32(self[0x1] - 4), value)
			end,
			[0b10100010] = @native function(value: number): number
				self[0x1] += 4
				write32(readu32(registers, 12) + read32(self[0x1] - 4), value)
			end,
			[0b10100011] = @native function(value: number): number
				self[0x1] += 4
				write32(readu32(registers, 16) + read32(self[0x1] - 4), value)
			end,
			[0b10100100] = @native function(value: number): number 
				self[0x1] += 4
				write32(decode_sib() + read32(self[0x1] - 4), value)
			end,
			[0b10100101] = @native function(value: number): number
				self[0x1] += 4
				write32(readu32(registers, 24) + read32(self[0x1] - 4), value)
			end,
			[0b10100110] = @native function(value: number): number
				self[0x1] += 4
				write32(readu32(registers, 28) + read32(self[0x1] - 4), value)
			end,
			[0b10100111] = @native function(value: number): number
				self[0x1] += 4
				write32(readu32(registers, 32) + read32(self[0x1] - 4), value)
			end,

			[0b11100000] = @native function(value: number): number
				writeu32(registers, 4, value)
			end,
			[0b11100001] = @native function(value: number): number
				writeu32(registers, 8, value)
			end,
			[0b11100010] = @native function(value: number): number
				writeu32(registers, 12, value)
			end,
			[0b11100011] = @native function(value: number): number
				writeu32(registers, 16, value)
			end,
			[0b11100100] = @native function(value: number): number
				writeu32(registers, 20, value)
			end,
			[0b11100101] = @native function(value: number): number
				writeu32(registers, 24, value)
			end,
			[0b11100110] = @native function(value: number): number
				writeu32(registers, 28, value)
			end,
			[0b11100111] = @native function(value: number): number
				writeu32(registers, 32, value)
			end,

			[0b00101000] = @native function(value: number): number
				write32(readu32(registers, 4), value)
			end,
			[0b00101001] = @native function(value: number): number
				write32(readu32(registers, 8), value)
			end,
			[0b00101010] = @native function(value: number): number
				write32(readu32(registers, 12), value)
			end,
			[0b00101011] = @native function(value: number): number
				write32(readu32(registers, 16), value)
			end,
			[0b00101100] = @native function(value: number): number
				write32(decode_sib(), value) -- SIB needed
			end,
			[0b00101101] = @native function(value: number): number
				self[0x1] += 1
				write32(read32(self[0x1] - 1), value) -- displacement only mode
			end,
			[0b00101110] = @native function(value: number): number
				write32(readu32(registers, 28), value)
			end,
			[0b00101111] = @native function(value: number): number
				write32(readu32(registers, 32), value)
			end,

			[0b01101000] = @native function(value: number): number
				self[0x1] += 1
				write32(readu32(registers, 4) + read8(self[0x1] - 1), value)
			end,
			[0b01101001] = @native function(value: number): number
				self[0x1] += 1
				write32(readu32(registers, 8) + read8(self[0x1] - 1), value)
			end,
			[0b01101010] = @native function(value: number): number
				self[0x1] += 1
				write32(readu32(registers, 12) + read8(self[0x1] - 1), value)
			end,
			[0b01101011] = @native function(value: number): number
				self[0x1] += 1
				write32(readu32(registers, 16) + read8(self[0x1] - 1), value)
			end,
			[0b01101100] = @native function(value: number): number 
				self[0x1] += 1
				read32(decode_sib() + read8(self[0x1] - 1), value)
			end,
			[0b01101101] = @native function(value: number): number
				self[0x1] += 1
				write32(readu32(registers, 24) + read8(self[0x1] - 1), value)
			end,
			[0b01101110] = @native function(value: number): number
				self[0x1] += 1
				write32(readu32(registers, 28) + read8(self[0x1] - 1), value)
			end,
			[0b01101111] = @native function(value: number): number
				self[0x1] += 1
				write32(readu32(registers, 32) + read8(self[0x1] - 1), value)
			end,

			[0b10101000] = @native function(value: number): number
				self[0x1] += 4
				write32(readu32(registers, 4) + read32(self[0x1] - 4), value)
			end,
			[0b10101001] = @native function(value: number): number
				self[0x1] += 4
				write32(readu32(registers, 8) + read32(self[0x1] - 4), value)
			end,
			[0b10101010] = @native function(value: number): number
				self[0x1] += 4
				write32(readu32(registers, 12) + read32(self[0x1] - 4), value)
			end,
			[0b10101011] = @native function(value: number): number
				self[0x1] += 4
				write32(readu32(registers, 16) + read32(self[0x1] - 4), value)
			end,
			[0b10101100] = @native function(value: number): number 
				self[0x1] += 4
				write32(decode_sib() + read32(self[0x1] - 4), value)
			end,
			[0b10101101] = @native function(value: number): number
				self[0x1] += 4
				write32(readu32(registers, 24) + read32(self[0x1] - 4), value)
			end,
			[0b10101110] = @native function(value: number): number
				self[0x1] += 4
				write32(readu32(registers, 28) + read32(self[0x1] - 4), value)
			end,
			[0b10101111] = @native function(value: number): number
				self[0x1] += 4
				write32(readu32(registers, 32) + read32(self[0x1] - 4), value)
			end,

			[0b11101000] = @native function(value: number): number
				writeu32(registers, 4, value)
			end,
			[0b11101001] = @native function(value: number): number
				writeu32(registers, 8, value)
			end,
			[0b11101010] = @native function(value: number): number
				writeu32(registers, 12, value)
			end,
			[0b11101011] = @native function(value: number): number
				writeu32(registers, 16, value)
			end,
			[0b11101100] = @native function(value: number): number
				writeu32(registers, 20, value)
			end,
			[0b11101101] = @native function(value: number): number
				writeu32(registers, 24, value)
			end,
			[0b11101110] = @native function(value: number): number
				writeu32(registers, 28, value)
			end,
			[0b11101111] = @native function(value: number): number
				writeu32(registers, 32, value)
			end,

			[0b00110000] = @native function(value: number): number
				write32(readu32(registers, 4), value)
			end,
			[0b00110001] = @native function(value: number): number
				write32(readu32(registers, 8), value)
			end,
			[0b00110010] = @native function(value: number): number
				write32(readu32(registers, 12), value)
			end,
			[0b00110011] = @native function(value: number): number
				write32(readu32(registers, 16), value)
			end,
			[0b00110100] = @native function(value: number): number
				write32(decode_sib(), value) -- SIB needed
			end,
			[0b00110101] = @native function(value: number): number
				self[0x1] += 1
				write32(read32(self[0x1] - 1), value) -- displacement only mode
			end,
			[0b00110110] = @native function(value: number): number
				write32(readu32(registers, 28), value)
			end,
			[0b00110111] = @native function(value: number): number
				write32(readu32(registers, 32), value)
			end,

			[0b01110000] = @native function(value: number): number
				self[0x1] += 1
				write32(readu32(registers, 4) + read8(self[0x1] - 1), value)
			end,
			[0b01110001] = @native function(value: number): number
				self[0x1] += 1
				write32(readu32(registers, 8) + read8(self[0x1] - 1), value)
			end,
			[0b01110010] = @native function(value: number): number
				self[0x1] += 1
				write32(readu32(registers, 12) + read8(self[0x1] - 1), value)
			end,
			[0b01110011] = @native function(value: number): number
				self[0x1] += 1
				write32(readu32(registers, 16) + read8(self[0x1] - 1), value)
			end,
			[0b01110100] = @native function(value: number): number 
				self[0x1] += 1
				read32(decode_sib() + read8(self[0x1] - 1), value )
			end,
			[0b01110101] = @native function(value: number): number
				self[0x1] += 1
				write32(readu32(registers, 24) + read8(self[0x1] - 1), value)
			end,
			[0b01110110] = @native function(value: number): number
				self[0x1] += 1
				write32(readu32(registers, 28) + read8(self[0x1] - 1), value)
			end,
			[0b01110111] = @native function(value: number): number
				self[0x1] += 1
				write32(readu32(registers, 32) + read8(self[0x1] - 1), value)
			end,

			[0b10110000] = @native function(value: number): number
				self[0x1] += 4
				write32(readu32(registers, 4) + read32(self[0x1] - 4), value)
			end,
			[0b10110001] = @native function(value: number): number
				self[0x1] += 4
				write32(readu32(registers, 8) + read32(self[0x1] - 4), value)
			end,
			[0b10110010] = @native function(value: number): number
				self[0x1] += 4
				write32(readu32(registers, 12) + read32(self[0x1] - 4), value)
			end,
			[0b10110011] = @native function(value: number): number
				self[0x1] += 4
				write32(readu32(registers, 16) + read32(self[0x1] - 4), value)
			end,
			[0b10110100] = @native function(value: number): number 
				self[0x1] += 4
				write32(decode_sib() + read32(self[0x1] - 4), value)
			end,
			[0b10110101] = @native function(value: number): number
				self[0x1] += 4
				write32(readu32(registers, 24) + read32(self[0x1] - 4), value)
			end,
			[0b10110110] = @native function(value: number): number
				self[0x1] += 4
				write32(readu32(registers, 28) + read32(self[0x1] - 4), value)
			end,
			[0b10110111] = @native function(value: number): number
				self[0x1] += 4
				write32(readu32(registers, 32) + read32(self[0x1] - 4), value)
			end,

			[0b11110000] = @native function(value: number): number
				writeu32(registers, 4, value)
			end,
			[0b11110001] = @native function(value: number): number
				writeu32(registers, 8, value)
			end,
			[0b11110010] = @native function(value: number): number
				writeu32(registers, 12, value)
			end,
			[0b11110011] = @native function(value: number): number
				writeu32(registers, 16, value)
			end,
			[0b11110100] = @native function(value: number): number
				writeu32(registers, 20, value)
			end,
			[0b11110101] = @native function(value: number): number
				writeu32(registers, 24, value)
			end,
			[0b11110110] = @native function(value: number): number
				writeu32(registers, 28, value)
			end,
			[0b11110111] = @native function(value: number): number
				writeu32(registers, 32, value)
			end,

			[0b00111000] = @native function(value: number): number
				write32(readu32(registers, 4), value)
			end,
			[0b00111001] = @native function(value: number): number
				write32(readu32(registers, 8), value)
			end,
			[0b00111010] = @native function(value: number): number
				write32(readu32(registers, 12), value)
			end,
			[0b00111011] = @native function(value: number): number
				write32(readu32(registers, 16), value)
			end,
			[0b00111100] = @native function(value: number): number
				write32(decode_sib(), value) -- SIB needed
			end,
			[0b00111101] = @native function(value: number): number
				self[0x1] += 1
				write32(read32(self[0x1] - 1), value) -- displacement only mode
			end,
			[0b00111110] = @native function(value: number): number
				write32(readu32(registers, 28), value)
			end,
			[0b00111111] = @native function(value: number): number
				write32(readu32(registers, 32), value)
			end,

			[0b01111000] = @native function(value: number): number
				self[0x1] += 1
				write32(readu32(registers, 4) + read8(self[0x1] - 1), value)
			end,
			[0b01111001] = @native function(value: number): number
				self[0x1] += 1
				write32(readu32(registers, 8) + read8(self[0x1] - 1), value)
			end,
			[0b01111010] = @native function(value: number): number
				self[0x1] += 1
				write32(readu32(registers, 12) + read8(self[0x1] - 1), value)
			end,
			[0b01111011] = @native function(value: number): number
				self[0x1] += 1
				write32(readu32(registers, 16) + read8(self[0x1] - 1), value)
			end,
			[0b01111100] = @native function(value: number): number 
				self[0x1] += 1
				read32(decode_sib() + read8(self[0x1] - 1), value )
			end,
			[0b01111101] = @native function(value: number): number
				self[0x1] += 1
				write32(readu32(registers, 24) + read8(self[0x1] - 1), value)
			end,
			[0b01111110] = @native function(value: number): number
				self[0x1] += 1
				write32(readu32(registers, 28) + read8(self[0x1] - 1), value)
			end,
			[0b01111111] = @native function(value: number): number
				self[0x1] += 1
				write32(readu32(registers, 32) + read8(self[0x1] - 1), value)
			end,

			[0b10111000] = @native function(value: number): number
				self[0x1] += 4
				write32(readu32(registers, 4) + read32(self[0x1] - 4), value)
			end,
			[0b10111001] = @native function(value: number): number
				self[0x1] += 4
				write32(readu32(registers, 8) + read32(self[0x1] - 4), value)
			end,
			[0b10111010] = @native function(value: number): number
				self[0x1] += 4
				write32(readu32(registers, 12) + read32(self[0x1] - 4), value)
			end,
			[0b10111011] = @native function(value: number): number
				self[0x1] += 4
				write32(readu32(registers, 16) + read32(self[0x1] - 4), value)
			end,
			[0b10111100] = @native function(value: number): number 
				self[0x1] += 4
				write32(decode_sib() + read32(self[0x1] - 4), value)
			end,
			[0b10111101] = @native function(value: number): number
				self[0x1] += 4
				write32(readu32(registers, 24) + read32(self[0x1] - 4), value)
			end,
			[0b10111110] = @native function(value: number): number
				self[0x1] += 4
				write32(readu32(registers, 28) + read32(self[0x1] - 4), value)
			end,
			[0b10111111] = @native function(value: number): number
				self[0x1] += 4
				write32(readu32(registers, 32) + read32(self[0x1] - 4), value)
			end,

			[0b11111000] = @native function(value: number): number
				writeu32(registers, 4, value)
			end,
			[0b11111001] = @native function(value: number): number
				writeu32(registers, 8, value)
			end,
			[0b11111010] = @native function(value: number): number
				writeu32(registers, 12, value)
			end,
			[0b11111011] = @native function(value: number): number
				writeu32(registers, 16, value)
			end,
			[0b11111100] = @native function(value: number): number
				writeu32(registers, 20, value)
			end,
			[0b11111101] = @native function(value: number): number
				writeu32(registers, 24, value)
			end,
			[0b11111110] = @native function(value: number): number
				writeu32(registers, 28, value)
			end,
			[0b11111111] = @native function(value: number): number
				writeu32(registers, 32, value)
			end,

		}
		
		
	end,
}