--!strict
--!native
local types: {} = require(game:GetService("ServerScriptService"):WaitForChild("i386"):WaitForChild("types"));
return {
	construct_cores = @native function(self: types._i386): ()
		self.construct_cores = nil :: never;
		local cpu_cores: {types._i386} = table.create(self.cores);
		local _table_clone: ({}) -> {} = table.clone;
		for index: number = 1, self.cores do
			local core: types._i386 = ((index == self.cores and self) or _table_clone(self)) :: types._i386;
			core.coreIndex = index;
			core.cpu_cores = cpu_cores;
			core:initModrmSilliness();
			core:constructRegisters();
			core:initInstructionDecoder();
			core:compileInstructions();
			core:single_instruction_constructor();
			core:multi_instruction_constructor();
			core:decodeData();
			core:addCurrentCoreToActor();
			cpu_cores[index] = core;
		end;
	end;
}
