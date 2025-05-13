--!native
--!strict
local formatBytes = function(po: number, so: number?, o: number?): number
	local reg: number = (o or 0) // 8 % 8
	return po + (so or reg) * 256 + ((so and reg) or 0) * 65536
end

return {
	multi_instruction_constructor = @native function<self>(self): ()
		self.multi_instruction_constructor = nil :: never
		local modrmWrite: {any}
		local modrmRead: {any}
		local registers: buffer
		coroutine.wrap(function()
			repeat task.wait() until self.modrmWrite and self.registers and self.modrmRead
			modrmWrite = self.modrmWrite
			modrmRead = self.modrmRead
			registers = self.registers
		end)()
		self.instruction_definitions_multi = {

		};
	end;
};