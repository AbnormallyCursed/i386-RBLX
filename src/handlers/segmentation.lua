--!strict
--!native
local types: {} = require(game:GetService("ServerScriptService"):WaitForChild("i386"):WaitForChild("types"))

local SegmentDescriptorCache: types._segment_description_cache = {}

return function(self: types._i386): any
	return {
		SegmentDescriptorCache = SegmentDescriptorCache,
		
		decode_segment_descriptor = @native function(byte_table: types._segment_bytes): types._segment_descriptor
			-- Ensure the descriptor is 8 bytes
			assert(#byte_table == 8, "Descriptor must be 8 bytes");
			local b0: number, b1: number, b2: number, b3: number, b4: number, b5: number, b6: number, b7: number = table.unpack(byte_table);
			local type_attr: number = b5 + (b6 // 16 % 16) * 256; -- Type and Attributes
			-- Extract individual attributes
			return {
				limit = b0 + b1 * 256 + (type_attr % 16) * 65536, -- Segment Limit (20 bits)
				base = b2 + b3 * 256 + b4 * 65536 + b7 * 16777216, -- Base Address (32 bits)
				accessed = type_attr % 2,
				readable_writable = type_attr // 2 % 4,
				conforming_expand_down =  type_attr // 4 % 2,
				executable = type_attr // 8 % 2,
				descriptor_type = type_attr // 16 % 2,
				dpl = type_attr // 32 % 4,
				present = type_attr // 128 % 2,
				available = type_attr // 4096 % 2,
				long_mode = type_attr // 8192 % 2,
				default_big = type_attr // 16384 % 2,
				granularity = type_attr // 32768 % 2,
			} :: types._segment_descriptor
		end,
		
		get_segment_descriptor_at = @native function(target: number): types._segment_descriptor
			local result: types._segment_descriptor = SegmentDescriptorCache[target];
			if not result then
				local bytes: types._segment_bytes = {};
				for i: number = 0, 7 do
					bytes[i + 1] = self.read8(target + i);
				end;
				result = self.decode_segment_descriptor(bytes);
				SegmentDescriptorCache[target] = result;
			end;
			return result;
		end,
		
		a_b_getPhysicalAddress = function(a: number, b: number): number
			-- (A * 0x10) + B or A+B
			local seg_descriptor: types._segment_descriptor = self.get_segment_descriptor_at(a)
			return seg_descriptor.base + b
		end,
	}
end