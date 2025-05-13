--!strict
--!native
local types: {} = require(game:GetService("ServerScriptService"):WaitForChild("i386"):WaitForChild("types"));
local physical_memory_count: number = 1; -- 2 GB :3
local address_hi: number = 256 ^ physical_memory_count;
return function(self: types._i386)
	self.init_buffer_physical_memory = nil :: never
	local buffer_segment: {buffer} = self.buffer_segment;
	local buffer_max_size: number = self.buffer_max_size;
	local createbuffer: (number) -> buffer = buffer.create;
	for i: number = 1, physical_memory_count do
		buffer_segment[i] = createbuffer(buffer_max_size);
	end;
	local pre1gb: buffer = buffer_segment[1]	
	self.pre1gb = pre1gb
		--[[local get_memory_segment_high = function(address: number): (buffer, number)
			for i: number, real_buffer: buffer in buffer_segment do
				if address <= buffer_max_size * i then
					return real_buffer, address - buffer_max_size * (i - 1);
				end;
			end;
			error("get_memory_segment_high could not decode address: "..string.format("0x%08X", address));
		end;]]

	--[[self.get_memory_segment_high = @native function(address: number): (buffer, number)
		local segment_index: number = address // buffer_max_size
		return pre1gb or error("get_memory_segment_high could not decode address: "..string.format("0x%08X", address)),
		address
	end;]]

	-- Generic:
	return {
		read8 = @native function(address: number): number
			
			return buffer.readu8(pre1gb, address);
		end;
		read16 = @native function(address: number): number
			
			return buffer.readu16(pre1gb, address);
		end;
		read32 = @native function(address: number): number
			
			return buffer.readu32(pre1gb, address);
		end;
		write8 = @native function(address: number, value: number): ()
			
			return buffer.writeu8(pre1gb, address, value);
		end;
		write16 = @native function(address: number, value: number): ()
			
			return buffer.writeu16(pre1gb, address, value);
		end;
		write32 = @native function(address: number, value: number): ()
			
			return buffer.writeu32(pre1gb, address, value);
		end;

		-- Signed:
		read8s = @native function(address: number): number
			
			return buffer.readi8(pre1gb, address);
		end;
		read16s = @native function(address: number): number
			
			return buffer.readi16(pre1gb, address);
		end;
		read32s = @native function(address: number): number
			
			return buffer.readi32(pre1gb, address);
		end;
		write8s = @native function(address: number, value: number): ()
			return buffer.writei8(pre1gb, address, value);
		end;
		write16s = @native function(address: number, value: number): ()
			
			return buffer.writei16(pre1gb, address, value);
		end;
		write32s = @native function(address: number, value: number): ()
			
			return buffer.writei32(pre1gb, address, value);
		end;

		-- Float:
		read32f = @native function(address: number): number
			
			return buffer.readf32(pre1gb, address);
		end;
		write32f = @native function(address: number, value: number): ()
			
			return buffer.writef32(pre1gb, address, value);
		end;
	}
end;