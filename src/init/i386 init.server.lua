--!strict
--!native
task.wait()
local script_: Script = script;
local _game: DataModel = game;
local types: {} = require(_game:GetService("ServerScriptService"):WaitForChild("i386"):WaitForChild("types"));

local constructor_self: any = {
	services = setmetatable({} :: types._services, {
		__index = function(self: types._services, index: string): Instance
			local service: Instance = _game:GetService(index);
			self[index] = service;
			return service
		end,
	} :: {
		__index: (types._services, string) -> Instance	
	}),
	instruction_definitions_multi = {};
	instruction_definitions_single = {},
	buffer_max_size = 1073741824,
	buffer_segment = {},
	cores = 1,
	initializedCores = 0,
	coreIndex = 0,
	debugPrintEnabled = true,
	osa = true,
	asa = false,
};
do
	local network_directories: {Folder} = {
		_game:GetService("ServerScriptService"):WaitForChild("i386") :: Folder
	};
	local _table_type: "table" = "table";
	local _function_type: "function" = "function";
	local _module_type: "ModuleScript" = "ModuleScript";
	local _function_type: "function" = "function";
	local _type: <T>(T) -> string = type;
	local _require: (any) -> any = require;
	local merge_table; merge_table = @native function(container: any, category: any, array: any): ()
		for index, value in array do
			if not category[index] then
				category[index] = value;
			elseif typeof(value) == _table_type then
				merge_table(index, category[index], value);
			else
				error(`\n[self index overwrite collision]\nIndex container: {container}\nCollision index: {index}\nCurrent value: {category[index]}\nAttempted overwrite value: {value}`);
			end;
		end;
	end;
	local load_path = function(path: Instance): ()
		local descendants: {Instance} = path:GetDescendants()
		for _, instance: Instance in descendants do
			if instance:IsA(_module_type) and not (instance == script_) then
				local returned_data: any = _require(instance);
				if _type(returned_data) == _function_type then
					returned_data = returned_data(constructor_self);
				end;
				instance = nil :: never;
				if typeof(returned_data) == _table_type then
					for index, value in returned_data do
						local category = constructor_self[index];
						if category then
							merge_table(index, category, value);
						else
							constructor_self[index] = value;
						end;
						category = nil :: never;
					end;
				end;
			end;
		end;
	end;
	for _, instance_path: Folder in network_directories do
		load_path(instance_path);
	end;
	table.clear(network_directories);
	network_directories = nil :: never;
	load_path = nil :: never;
	merge_table = nil :: never;
	_table_type = nil :: never;
	_module_type = nil :: never;
	script_ = nil :: never;
end;

local self: types._i386 = constructor_self :: types._i386; -- now be quiet luau type check
self.cpu_buffer = buffer.create(8); -- 0-7 reserved for cpu flags goobly, if need more add more e
buffer.writeu32(self.cpu_buffer, 0, 0x3000)

self:construct_cores();
repeat task.wait() until self.initializedCores == self.cores

-- EAX 0 (b: 000)
-- ECX 4 (b: 001)
-- EDX 8 (b: 010)
-- EBX 12 (b: 011)
-- ESP 16 (b: 100)
-- EBP 20 (b: 101)
-- ESI 24 (b: 110)
-- EDI 28 (b: 111)
local instructionAmount: number = 1;
local cycleAmount: number = 200_000;

--[[0xE8, 0xF8, 0x00, 0x00, 0x00, -- CALL 0xFE
	0xB8, 0x84,	-- MOV EAX, 132
	
	[0xFE] = 0x04, [0xFF] = 0xFF, -- ADD AL, 255
	[0x100] = 0xC3 -- RET]]

local machineCode: types._machineCode = {
	0xBC, 0xFC, 0xFF, 0xFF, 0x3F, -- MOV ESP, 1073741820 this initializes the ESP
	-- la C test:
	0xE8, 0x13, 0x00, 0x00, 0x00, -- CALL 20 this calls the main() function
	
	                              -- square:
	0x55,                         -- PUSH RBP (NOTE: address 5)
	0x48, 0x89, 0xe5,             -- MOV RBP, RSP
	0x89, 0x7d, 0xfc,             -- MOV DWORD PTR [RBP-0x4], EDI 
	0x8b, 0x45, 0xfc,             -- MOV EAX, DWORD PTR [RBP-0x4]
	0x0F, 0xaf, 0xc0,             -- IMUL EAX, EAX
	0x5d,                         -- POP RBP
	0xc3,                         -- RET
	
	                              -- main:
	0x55,                         -- PUSH RBP (NOTE: address 20)
	0x48, 0x89, 0xe5,             -- MOV RBP, RSP
	0xbf, 0x05, 0x00, 0x00, 0x00, -- MOV EDI, 0x5
	0xe8, 0xE8, 0xFF, 0xFF, 0xFF, -- CALL 5 <square>
	-- 0xb8, 0x00, 0x00, 0x00, 0x00, -- MOV EAX, 0x0
	0x5d,                         -- POP RBP
	0xc3,                     -- RET(N)

	--0xB0, 0xFA,
	--0x88, 0b01_000_101, 0xFC
	
	--0xBC, 0xFC, 0xFF, 0xFF, 0x3F,	-- MOV ESP, 1073741820
	--[[0x31, 0b11_001_001,				-- XOR ECX, ECX
	0xBB, 0x64, 0x00, 0x00, 0x00,	-- MOV EBX, 100
	0xB8, 0x08, 0x00, 0x00, 0x00,	-- MOV EAX, 8
	0x89, 0b11_011_001,				-- MOV ECX, EBX
	0x50,							-- PUSH EAX
	0x02, 0b11_000_011,				-- ADD EAX, EBX
	0x58,							-- POP EAX
	0xE9, 0x0A, 0x00, 0x00, 0x00,	-- JMP 10
	
	0xB8, 0x0F, 0x00, 0x00, 0x00,	-- MOV EAX, 15
	0xE9, 0x0C, 0x00, 0x00, 0x00,	-- JMP 12
	
	0xBB, 0xFF, 0x00, 0x00, 0x00,	-- MOV EBX, 255
	0x3B, 0xC3,						-- CMP EAX, EBX
	0x72, 0xEF, 0xFF, 0xFF, 0xFF,	-- JC -17
	0xBF, 0xFF, 0xFF, 0x00, 0x00,	-- MOV EDI, 65535]]
}; 

print(machineCode)
self:loadMachineCodeToMemory(machineCode);
self.runBenchmark(self, instructionAmount, cycleAmount // instructionAmount + 1);
for i, v in {"EAX", "ECX", "EDX", "EBX", "ESP", "EBP", "ESI", "EDI"} do
	print(v..":", buffer.readu32(self.registers, (i - 1) * 4))
end