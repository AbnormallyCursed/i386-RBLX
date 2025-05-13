--!native
local types: {} = require(game:GetService("ServerScriptService"):WaitForChild("i386"):WaitForChild("types"));

return {
	runx86Test = function(self)
		
	end,
	loadMachineCodeToMemory = @native function(self: types._i386, machineCode: types._machineCode): ()
		for i: number, v: number in machineCode do
			buffer.writeu8(self.pre1gb, i - 1, v)
		end
	end,
}
