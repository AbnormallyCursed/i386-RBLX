--!strict
local types: {} = require(game:GetService("ServerScriptService"):WaitForChild("i386"):WaitForChild("types"))
return {
	runBenchmark = @native function(self: types._i386, instructionAmount: number, cycleAmount: number): ()
		self.initInstructionDecoder = nil :: never
		local directArrayPrefix: types._prefixArray = self.directArrayPrefix;
		local directMultiByte: types._instructionByteSwitch = self.multiByteDecoders;
		local directSingleByte: types._instructionByteSwitch = self.singleByteDecoders;
		local pre1GBRam: buffer = self.pre1gb;
		local benchmark = @native function(instructionAmount: number, cycleAmount: number): number
			local t: number = os.clock();
			for _: number = 1, cycleAmount do
				-- Master decoder
				local EIP: number = 0;
				for _: number = 1, instructionAmount do
					local directMode: types._instructionByteSwitch = directSingleByte;
					local EIPQuadByte: number = buffer.readu32(pre1GBRam, EIP);
					local byte: number = EIPQuadByte % 256;
					if byte >= 0x0F and directArrayPrefix[byte] then
						if byte == 0x0F then
							directMode = directMultiByte;
						end;
						byte = EIPQuadByte // 256 % 256;
						if byte >= 0x0F and directArrayPrefix[byte] then
							if byte == 0x0F then
								directMode = directMultiByte;
							end;
							byte = EIPQuadByte // 65536 % 256;
							if byte >= 0x0F and directArrayPrefix[byte] then
								if byte == 0x0F then
									directMode = directMultiByte;
								end;
								byte = EIPQuadByte // 16777216 % 256;
								if byte >= 0x0F and directArrayPrefix[byte] then
									if byte == 0x0F then
										directMode = directMultiByte;
									end;
								else
									EIP = directMode[byte + 1](EIP + 4, EIPQuadByte // 16777216);
								end;
							else
								EIP = directMode[byte + 1](EIP + 3, EIPQuadByte // 65536);
							end;
						else
							EIP = directMode[byte + 1](EIP + 2, EIPQuadByte // 256);
						end;
					else
						EIP = directMode[byte + 1](EIP + 1, 0);
					end;
				end;
				
				-- End of master decoder --
			end;
			return (instructionAmount * cycleAmount) // (os.clock() - t)
		end
		local herz: number = benchmark(instructionAmount, cycleAmount)
		print("Current core: "..self.coreIndex.."\n".."Avg Mhz: "..(((herz / 1000000) * 100) // 1) / 100)
	end,
}