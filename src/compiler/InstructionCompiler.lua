--!native

-- NOTE: we might wanna compute modr/m from segemnt register on memory:
--[[A ModR/M byte follows the opcode and specifies the operand. The operand is either a general-purpose register or a memory address.
If it is a memory address, the address is computed from a segment register and any of the following values: a base register, an index register, 
a scaling factor, or a displacement.]]
local SILENCE_WARNS: boolean = false
local SILENCE_DUMP: boolean = false

type TjsonInstruction = {
	["pf"]: string,
	["0F"]: string,
	["po"]: string,
	["so"]: string,
	["flds"]: string,
	["o"]: string,
	["proc"]: string,
	["st"]: string,
	["m"]: string,
	["rl"]: string,
	["x"]: string,
	["mnemonic"]: string,
	["op1"]: string,
	["op2"]: string,
	["op3"]: string,
	["op4"]: string,
	["iext"]: string,
	["grp1"]: string,
	["grp2"]: string,
	["grp3"]: string,
	["tested f"]: string,
	["modif f"]: string,
	["def f"]: string,
	["undef f"]: string,
	["f values"]: string,
}

local register_conv = {
	["AL"] = 0,
	["BH"] = 1,
	["DH"] = 2,
	["CH"] = 3,
	["AH"] = 4,
	["BL"] = 5,
	["DL"] = 6,
	["CL"] = 7,
	["AX"] = 0,
	["DI"] = 1,
	["SI"] = 2,
	["BP"] = 3,
	["SP"] = 4,
	["BX"] = 5,
	["DX"] = 6,
	["CX"] = 7,
	["EAX"] = 0,
	["EDI"] = 1,
	["ESI"] = 2,
	["EBP"] = 3,
	["ESP"] = 4,
	["EBX"] = 5,
	["EDX"] = 6,
	["ECX"] = 7
	-- add more regs mayb??
}
local InstructionFileHeader = [[
self.construct_single_instruction = nil :: never;
local registers: buffer;
coroutine.wrap(function()
	repeat task.wait() until self.registers;
	registers = self.registers;
end)();
local pre1GBRam: buffer = self.pre1gb;
local defaultRead: (buffer, number) -> number = buffer.readu32;
local defaultWrite: (buffer, number, number) -> number = buffer.writeu32;
local cpu_buffer: buffer = self.cpu_buffer;
]]
-- TODO: critical note modulo for bit size could be a concern
local writemodrm = function(): string
	return [[local valueWrite: number = COMPILER_WRITE_OPERAND_TARGET;
			local mod: number = modrm // 64;
			if mod == 0b11 then
				defaultWrite(registers, (modrm -mod- 8) * 4, valueWrite); 
			elseif mod == 0b00 then
				local rm: number = modrm -mod- 8;
				if rm == 0b100 then
					local sibByte: number = buffer.readu8(pre1GBRam, EIP)
					defaultWrite(pre1GBRam, 2 ^ (sibByte // 64) * defaultRead(registers, (sibByte -mod- 8) * 4) + defaultRead(registers, (sibByte // 8 -mod- 8) * 4), valueWrite);
					EIP += 1;
				elseif rm == 0b101 then
					defaultWrite(pre1GBRam, defaultRead(pre1GBRam, EIP), valueWrite);
					EIP += 1;
				else
					defaultWrite(pre1GBRam, defaultRead(registers, rm * 4), valueWrite);
				end
			else
				local rm: number = modrm -mod- 8;
				if rm == 0b100 then
					local sibByte: number = buffer.readu8(pre1GBRam, EIP);
					EIP += 1;
					defaultWrite(pre1GBRam, (((2 ^ (sibByte // 64) * defaultRead(registers, (sibByte -mod- 8) * 4)) + defaultRead(registers, (sibByte // 8 -mod- 8) * 4)) + ((mod == 0b10 and buffer.readi32) or buffer.readi8)(pre1GBRam, EIP)), valueWrite);
				else
					defaultWrite(pre1GBRam, ((defaultRead(registers, rm * 4)) + ((mod == 0b10 and buffer.readi32) or buffer.readi8)(pre1GBRam, EIP)), valueWrite);
				end;
				EIP += (mod -mod- 3) ^ 2;
			end;]]
end
local readmodrm = function(): string
	return [[local value: number = 0;
			local mod: number = modrm // 64;
			if mod == 0b11 then
				local offsetRM: number = (modrm -mod- 8) * 4;
				value = defaultRead(registers, offsetRM)
			elseif mod == 0b00 then
				local rm: number = modrm -mod- 8;
				if rm == 0b100 then
					local sibByte: number = buffer.readu8(pre1GBRam, EIP)
					value = defaultRead(pre1GBRam, 2 ^ (sibByte // 64) * defaultRead(registers, (sibByte -mod- 8) * 4) + defaultRead(registers, (sibByte // 8 -mod- 8) * 4));
					EIP += 1;
				elseif rm == 0b101 then
					value = defaultRead(pre1GBRam, buffer.readu8(pre1GBRam, EIP));
					EIP += 1;
				else
					value = defaultRead(pre1GBRam, defaultRead(registers, rm * 4))
				end
			else
				local rm: number = modrm -mod- 8;
				if rm == 0b100 then
					local sibByte: number = buffer.readu8(pre1GBRam, EIP);
					EIP += 1;
					value = defaultRead(pre1GBRam, ((2 ^ (sibByte // 64) * defaultRead(registers, (sibByte -mod- 8) * 4)) + defaultRead(registers, (sibByte // 8 -mod- 8) * 4) + ((mod == 0b10 and buffer.readi32) or buffer.readi8)(pre1GBRam, EIP)));
				else
					value = defaultRead(pre1GBRam, defaultRead(registers, rm * 4) + ((mod == 0b10 and buffer.readi32) or buffer.readi8)(pre1GBRam, EIP))
				end;
				EIP += (mod -mod- 3) ^ 2;
			end;]]
end
if SILENCE_WARNS then
	getfenv().warn = function()
		
	end
end
return {
	compileInstructions = function(self)

		local compile_operand = function(Operand: string)
			if Operand == nil or Operand == "" then return end
			local OperandType
			local AddressingMethod
			local Part1, Part2 = string.match(Operand, "(%l+)(%u+)")
			local OperandNumberSize = 0

			if Part1 == nil then
				Part1, Part2 = string.match(Operand, "(%u+)(%l+)")
				OperandType = Part2
				AddressingMethod = Part1
			else
				OperandType = Part1
				AddressingMethod = Part2
			end

			Operand = tostring(Operand):upper()
			if register_conv[Operand] ~= nil then
				return { -- note: using u32 while knowing lower size registers like AL/AX are frequently using this operand method sucks
					output = `defaultWrite(registers, {register_conv[Operand] * 4}, COMPILER_WRITE_OPERAND_TARGET)`,
					input = `defaultRead(registers, {register_conv[Operand] * 4})`,
					sizeof = "32" -- ok ig its 32 for now lol
				}
			end

			local output: string = "error('"..Operand.." output not available')";
			local input: string = "error('"..Operand.." input not available')";
			local sizeof: string = "error('"..Operand.." sizeof not available')";
			local post_operand:string = "";
			
			if OperandType == "a" then
				return {
					output = "error('the -a- operand type should be done manually')",
					input = "error('the -a- operand type should be done manually')"
				}
			elseif OperandType == "b" then
				sizeof = "8"
			elseif OperandType == "bcd" then
				-- Packed-BCD. Only x87 FPU instructions (for example, FBLD).
			elseif OperandType == "bs" then
				sizeof = "8" -- sign extension I think has no implementation for us because it's about preserving sign and value
			elseif OperandType == "bss" then
				sizeof = "8"
			elseif OperandType == "c" then
				-- nuh uh
			elseif OperandType == "d" then
				sizeof ="32"
			elseif OperandType == "di" then
				sizeof ="32"
			elseif OperandType == "dq" then
				sizeof = "128"-- sadness
			elseif OperandType == "dqp" then
				sizeof = "(prefix[0x48] and ".."64".."or".."32)"
			elseif OperandType == "dr" then
				sizeof ="64"
			elseif OperandType == "ds" then
				sizeof ="32"
			elseif OperandType == "e" then
				-- ree
			elseif OperandType == "er" then
				-- 80 bits in lua? nah
				sizeof = "80"
			elseif OperandType == "p" then
				sizeof = "(self.osa and 48 or 32)"
			elseif OperandType == "pi" then
				sizeof = "64"
			elseif OperandType == "pd" then
				sizeof = "128" -- sadness
			elseif OperandType == "ps" then
				sizeof = "128" -- sadness
			elseif OperandType == "psq" then
				sizeof ="64"
			elseif OperandType == "pt" then
				sizeof = "80" -- sadness -- guh..
			elseif OperandType == "ptp" then
				sizeof = "(self.osa and 48 or 32)" -- REX.W 80 bit far pointer silliness, not doin cuz even 48 doesn't exist lol
			elseif OperandType == "q" then
				sizeof ="64"
			elseif OperandType == "qi" then
				sizeof ="32"
			elseif OperandType == "qp" then
				sizeof ="64"
			elseif OperandType == "s" then
				sizeof = "error('idk what s is yet lol')"
			elseif OperandType == "sd" then
				sizeof = "128" -- sadness
			elseif OperandType == "si" then
				-- not used lol
			elseif OperandType == "sr" then
				sizeof ="32"
			elseif OperandType == "ss" then
				sizeof = "128"
			elseif OperandType == "st" then
				-- 98/108 bits nah
			elseif OperandType == "stx" then
				sizeof = "512" -- big sad
			elseif OperandType == "t" then
				-- not even used anymore
			elseif OperandType == "v" then
				sizeof = "(self.osa and 32 or 16)"
			elseif OperandType == "vds" then
				sizeof = "(self.osa and 32 or 16)"
			elseif OperandType == "vq" then
				sizeof = "(self.prefix[0x66] and 16 or 64)"
			elseif OperandType == "vqp" then
				-- no lol
			elseif OperandType == "vs" then
				sizeof = "(self.osa and 32 or 16)"
			elseif OperandType == "w" then
				sizeof = "16"
			elseif OperandType == "wi" then
				sizeof = "16"

				-- these need to be checked:
			elseif OperandType == "va" then
				sizeof = "(self.asa and 32 or 16)"
			elseif OperandType == "dqa" then
				sizeof = "(self.asa and 64 or 32)"
			elseif OperandType == "wa" then
				sizeof = "16" -- I think?
			elseif OperandType == "wo" then
				sizeof = "16"
			elseif OperandType == "ws" then
				sizeof = "16"
			elseif OperandType == "da" then
				sizeof = "32"
			elseif OperandType == "do" then
				sizeof = "32"
			elseif OperandType == "qa" then
				sizeof = "64"
			elseif OperandType == "qs" then
				sizeof = "64"
			else
				if Operand == "FS" then
					return {
						input = "defaultRead(registers, 234)",
						output = "defaultWrite(registers, 234, COMPILER_WRITE_OPERAND_TARGET)",
						sizeof = "32"
					}
				elseif Operand == "GS" then
					return {
						input = "defaultRead(registers, 232)",
						output = "defaultWrite(registers, 232, COMPILER_WRITE_OPERAND_TARGET)",
						sizeof = "32"
					}
				elseif Operand == "ES" then
					return {
						input = "defaultRead(registers, 228)",
						output = "defaultWrite(registers, 228, COMPILER_WRITE_OPERAND_TARGET)",
						sizeof = "32"
					}
				elseif Operand == "CS" then
					return {
						input = "defaultRead(registers, 224)",
						output = "defaultWrite(registers, 224, COMPILER_WRITE_OPERAND_TARGET)",
						sizeof = "32"
					}
				elseif Operand == "SS" then
					return {
						input = "defaultRead(registers, 196)",
						output = "defaultWrite(registers, 196, COMPILER_WRITE_OPERAND_TARGET)",
						sizeof = "32"
					}
				elseif Operand == "DS" then
					return {
						input = "defaultRead(registers, 230)",
						output = "defaultWrite(registers, 230, COMPILER_WRITE_OPERAND_TARGET)",
						sizeof = "32"
					}
				end
				local newop = tonumber(Operand);
				if newop then
					return {
						input = newop,
						output = newop,
						sizeof = "32"
					}
				else
					error("Instruction Compiler: "..Operand..": operand type fault")
				end
			end

			local implicit_memory: boolean = true
			if tonumber(sizeof) then
				implicit_memory = false
			end

			if AddressingMethod == "A" then
				if implicit_memory then
					input = `defaultRead(pre1GBRam, EIP)` -- goofus
					output = `defaultWrite(pre1GBRam, EIP, COMPILER_WRITE_OPERAND_TARGET -mod- (2 ^ {sizeof}))`
					post_operand = `EIP += {(sizeof)} / 8`
				else
					input = `buffer.readu{sizeof}(pre1GBRam, EIP)`
					output = `buffer.writeu{sizeof}(pre1GBRam, EIP, COMPILER_WRITE_OPERAND_TARGET)`
					post_operand = `EIP += {(sizeof / 8)}`
				end
			elseif AddressingMethod == "BA" then
				if implicit_memory then
					input = `defaultRead(pre1GBRam, a_b_getPhysicalAddress(defaultRead(registers, 230), defaultRead(registers, 0))) // (2 ^ ({sizeof}))`
					output = `defaultWrite(pre1GBRam, a_b_getPhysicalAddress(defaultRead(registers, 230), defaultRead(registers, 0)), COMPILER_WRITE_OPERAND_TARGET -mod- (2 ^ ({sizeof})))`
				else
					input = `buffer.readu{sizeof}(pre1GBRam, a_b_getPhysicalAddress(defaultRead(registers, 230), defaultRead(registers, 0)))`
					output = `buffer.writeu{sizeof}pre1GBRam, (a_b_getPhysicalAddress(defaultRead(registers, 230), defaultRead(registers, 0)), COMPILER_WRITE_OPERAND_TARGET)`
				end
			elseif AddressingMethod == "BB" then
				if implicit_memory then
					input = `defaultRead(pre1GBRam, a_b_getPhysicalAddress(defaultRead(registers, 230), readu32(registers, 0))) // (2 ^ ({sizeof}))`
					output = `defaultWrite(pre1GBRam, a_b_getPhysicalAddress(defaultRead(registers, 230), readu32(registers, 0)), COMPILER_WRITE_OPERAND_TARGET -mod- (2 ^ ({sizeof})))`
				else
					input = `buffer.readu{sizeof}(pre1GBRam, a_b_getPhysicalAddress(defaultRead(registers, 230), defaultRead(registers, 12) + buffer.readu8(registers, 0)) )`
					output = `buffer.writeu{sizeof}(pre1GBRam, a_b_getPhysicalAddress(defaultRead(registers, 230), defaultRead(registers, 12) + buffer.readu8(registers, 0)), COMPILER_WRITE_OPERAND_TARGET )`
				end
			elseif AddressingMethod == "BD" then
				if implicit_memory then
					input = `defaultRead(pre1GBRam, a_b_getPhysicalAddress(defaultRead(registers, 230), defaultRead(registers, 28))) // (2 ^ ({sizeof}))`
					output = `defaultWrite(pre1GBRam, a_b_getPhysicalAddress(defaultRead(registers, 230), defaultRead(registers, 28)), COMPILER_WRITE_OPERAND_TARGET -mod- (2 ^ ({sizeof})))`
				else
					input = `buffer.readu{sizeof}(pre1GBRam, a_b_getPhysicalAddress(defaultRead(registers, 230), defaultRead(registers, 28)) )`
					output = `buffer.writeu{sizeof}(pre1GBRam, a_b_getPhysicalAddress(defaultRead(registers, 230), defaultRead(registers, 28)), COMPILER_WRITE_OPERAND_TARGET )`
				end
			elseif AddressingMethod == "C" then
				input = `defaultRead(registers, 128 + (((modrm // 8) -mod- 8) * 4))`
				output = `defaultWrite(registers, 128 + (((modrm // 8) -mod- 8) * 4), COMPILER_WRITE_OPERAND_TARGET)`
			elseif AddressingMethod == "D" then
				input = `defaultRead(registers, 64 + (((modrm // 8) -mod- 8) * 4))`
				output = `defaultWrite(registers, 64 + (((modrm // 8) -mod- 8) * 4), COMPILER_WRITE_OPERAND_TARGET)`
			elseif AddressingMethod == "E" then
				input = `-MODRMREAD-`
				output = writemodrm()
			elseif AddressingMethod == "ES" then
				input = `fp_modrmRead[modrm]()`
				output = `fp_modrmWrite[modrm](COMPILER_WRITE_OPERAND_TARGET)`
			elseif AddressingMethod == "EST" then
				-- ?? (Implies original E). A ModR/M byte follows the opcode and specifies the x87 FPU stack register. 
				input = `fp_modrmRead[modrm]()`
				output = `fp_modrmWrite[modrm](COMPILER_WRITE_OPERAND_TARGET)`
			elseif AddressingMethod == "F" then
				input = `defaultRead(registers, 202)`
				output = `defaultWrite(registers, 202, COMPILER_WRITE_OPERAND_TARGET)`
			elseif AddressingMethod == "G" then
				input = `defaultRead(registers, (((modrm // 8) -mod- 8) * 4))`
				output = `defaultWrite(registers, (((modrm // 8) -mod- 8) * 4), COMPILER_WRITE_OPERAND_TARGET)`
			elseif AddressingMethod == "H" then
				input = `defaultRead(registers, (modrm -mod- 8) * 4)`
				input = `defaultWrite(registers, (modrm -mod- 8) * 4, COMPILER_WRITE_OPERAND_TARGET)`
			elseif AddressingMethod == "I" then
				if implicit_memory then
					input = `defaultRead(pre1GBRam, EIP)` -- goofus
					output = `defaultWrite(pre1GBRam, EIP, COMPILER_WRITE_OPERAND_TARGET -mod- (2 ^ ({sizeof})))`
					post_operand = `EIP += {(sizeof)} / 8`
				else
					input = `buffer.readu{sizeof}(pre1GBRam, EIP)` 
					output = `buffer.writeu{sizeof}(pre1GBRam, EIP, COMPILER_WRITE_OPERAND_TARGET)`
					post_operand = `EIP += {(sizeof / 8)}`
				end
			elseif AddressingMethod == "J" then
				if implicit_memory then
					input = `defaultRead(pre1GBRam, EIP)` -- goofus
					output = `defaultWrite(pre1GBRam, EIP, COMPILER_WRITE_OPERAND_TARGET -mod- (2 ^ ({sizeof})))`
					post_operand = `EIP += {(sizeof)} / 8`
				else
					input = `buffer.readu{sizeof}(pre1GBRam, EIP)`
					output = `buffer.writeu{sizeof}(pre1GBRam, EIP, COMPILER_WRITE_OPERAND_TARGET)`
					post_operand = `EIP += {(sizeof / 8)}`
				end
			elseif AddressingMethod == "M" then
				input = `-MODRMREAD-`
				output = writemodrm()
			elseif AddressingMethod == "N" then
				input = `defaultRead(registers, 244 + ((modrm -mod- 8) * 4))`
				input = `defaultWrite(registers, 244 + ((modrm -mod- 8) * 4), COMPILER_WRITE_OPERAND_TARGET)`
			elseif AddressingMethod == "O" then
				if implicit_memory then
					input = `defaultRead(pre1GBRam, EIP)` -- goofus
					output = `defaultWrite(pre1GBRam, EIP, COMPILER_WRITE_OPERAND_TARGET -mod- (2 ^ ({sizeof})))`
					post_operand = `EIP += ({sizeof}) / 8`
				else
					input = `buffer.readu{sizeof}(pre1GBRam, EIP)`
					output = `buffer.writeu{sizeof}(pre1GBRam, EIP, COMPILER_WRITE_OPERAND_TARGET)`
					post_operand = `EIP += {(sizeof / 8)}`
				end
			elseif AddressingMethod == "P" then
				input = `defaultRead(registers, 244 + ((modrm // 8) -mod- 8) * 4)`
				input = `defaultWrite(registers, 244 + ((modrm // 8) -mod- 8) * 4, COMPILER_WRITE_OPERAND_TARGET)`
			elseif AddressingMethod == "Q" then
				input = `mmx_modrmRead[modrm]()`
				output = `mmx_modrmWrite[modrm](COMPILER_WRITE_OPERAND_TARGET)`
			elseif AddressingMethod == "R" then
				input = `-MODRMREAD-`
				output = writemodrm()
			elseif AddressingMethod == "S" then
				-- reeeee
			elseif AddressingMethod == "SC" then
				-- aaaaaa
			elseif AddressingMethod == "T" then
				input = `defaultRead(registers, 308 + (((modrm // 8) -mod- 8) * 4))`
				output = `defaultWrite(registers, 308 + (((modrm // 8) -mod- 8) * 4), COMPILER_WRITE_OPERAND_TARGET)`
			elseif AddressingMethod == "U" then
				-- no 128 bit
			elseif AddressingMethod == "V" then
				-- again, no 128 bit
			elseif AddressingMethod == "W" then
				-- you guessed it
			elseif AddressingMethod == "X" then
				if implicit_memory then
					input = `defaultRead(pre1GBRam, a_b_getPhysicalAddress(defaultRead(registers, 230), defaultRead(registers, 0))) // (2 ^ ({sizeof}))`
					output = `defaultWrite(pre1GBRam, a_b_getPhysicalAddress(defaultRead(registers, 230), defaultRead(registers, 0)), COMPILER_WRITE_OPERAND_TARGET -mod- (2 ^ ({sizeof})))`
				else
					input = `buffer.readu{sizeof}(pre1GBRam, a_b_getPhysicalAddress(defaultRead(registers, 230), defaultRead(registers, 0)))`
					output = `buffer.writeu{sizeof}(pre1GBRam, a_b_getPhysicalAddress(defaultRead(registers, 230), defaultRead(registers, 0)), COMPILER_WRITE_OPERAND_TARGET)`
				end
			elseif AddressingMethod == "Y" then
				if implicit_memory then
					input = `defaultRead(pre1GBRam, a_b_getPhysicalAddress(defaultRead(registers, 230), defaultRead(registers, 0))) // (2 ^ ({sizeof}))`
					output = `defaultWrite(pre1GBRam, a_b_getPhysicalAddress(defaultRead(registers, 230), defaultRead(registers, 0)), COMPILER_WRITE_OPERAND_TARGET -mod- (2 ^ ({sizeof})))`
				else
					input = `buffer.readu{sizeof}(pre1GBRam, a_b_getPhysicalAddress(defaultRead(registers, 230), defaultRead(registers, 0)))`
					output = `buffer.writeu{sizeof}(pre1GBRam, a_b_getPhysicalAddress(defaultRead(registers, 230), defaultRead(registers, 0)), COMPILER_WRITE_OPERAND_TARGET)`
				end
			elseif AddressingMethod == "Z" then
				input = `defaultRead(registers, -OPCODE_LEAST_SIGNIFICANT_BIT-)`
				output = `defaultWrite(registers, -OPCODE_LEAST_SIGNIFICANT_BIT-, COMPILER_WRITE_OPERAND_TARGET)`
			else
				error("Instruction Compiler: "..Operand..": addressing method fault")
			end

			return {
				output = output,
				input = input,
				sizeof = sizeof,
				post_operand = post_operand,
			}
		end;
		coroutine.wrap(function()
			repeat task.wait() until self.compilerDataMaster
			local data_result = {};
			local formatBytes = function(po: number, so: number?, o: number?): number
				if so then
					so += 1
				end
				if o then
					o += 1
				end
				return po + (so or 0) * 256 + (o or 0) * 65536;
			end;

			local sort_per_mnemonic = {}

			for _: number, v: TjsonInstruction in self.compilerDataMaster :: {TjsonInstruction} do
				if v.mnemonic == nil then
					table.clear(v);
					continue;
				end;
				local instr_array = sort_per_mnemonic[v.mnemonic] or {};
				sort_per_mnemonic[v.mnemonic] = instr_array;
				table.insert(instr_array, v);
			end;
			
			self.compilerDataMaster = nil;
			local instruction_file_result_multi = "return {\n";
			local instruction_file_result_single = "return {\n";
			
			for mnemonic, definition in self.compiler_instr_proto do
				if not sort_per_mnemonic[mnemonic] then
					warn(mnemonic, "failed mnemonic sorting check")
					continue
				end
				for _,v:TjsonInstruction in sort_per_mnemonic[mnemonic] do
					if typeof(v) ~= "table" or v.po == nil or v.po == "" or v.mnemonic == "NOP" then
						continue
					end;
					local real_operands = {
						{pcall(compile_operand or print, v.op1)},
						{pcall(compile_operand or print, v.op2)},
						{pcall(compile_operand or print, v.op3)},
						{pcall(compile_operand or print, v.op4)},
					};
					local operands = {};
					
					if v.po == nil or tonumber(v.po, 16) == nil then
						continue
					end
					local silliness: string = ""
					for i,v in real_operands do
						if v[1] == false then
							print(mnemonic, v.po, v[2])
							error(`Operand Compilation Fault at:\nMNEMONIC: {mnemonic}\nPRIMARY-OPCODE(po): {v.po}\n\nOperand Error: {v[2]}`)
						else
							operands[i] = v[2]
						end
					end
					
					local new_definition = definition;
					if v.o ~= "" or v.o == nil then
						silliness = "local modrm: number = buffer.readu8(pre1GBRam, EIP);\nEIP += 1;\n"
					end
					
					for mode, operand in string.gmatch(new_definition, "(%a+):(%d+)") do
						if not mode or not operand then continue end;
						local index = operands[tonumber(operand)];
						if index == nil then
							warn(`unexpected null with operand, attempting to set to 0\nMNEMONIC: {mnemonic}\nPRIMARY-OPCODE(po): {v.po}` )
						end
						
						new_definition = string.gsub(new_definition, `{mode}:{operand}`, index ~= nil and index[mode] or "0");
					end;
					
					if new_definition:match("-MODRMREAD-") then
						new_definition = silliness..readmodrm().."\n"..new_definition
						new_definition = new_definition:gsub("%-MODRMREAD%-", "value")
					else
						new_definition = silliness..new_definition
					end
					
					for code in string.gmatch(new_definition, "%b$$") do -- tis this one
						new_definition = new_definition:gsub("%b$$", "", 1)
						new_definition = new_definition:gsub("COMPILER_WRITE_OPERAND_TARGET", code, 1);
						new_definition = new_definition:gsub("%$", "")
					end;
					for _, v in operands do
						if v.post_operand == nil or v.post_operand == "" then
							continue
						end;
						new_definition = string.gsub(new_definition, "%-postop%-", v.post_operand, 1)
					end
					new_definition = new_definition:gsub("%-OPCODE_LEAST_SIGNIFICANT_BIT%-", tonumber("0x"..v.po) % 8 * 4);
					new_definition = new_definition:gsub("%-postop%-", "")
					new_definition = new_definition:gsub("%-mod%-", "%%")
					
					local op: number? = tonumber("0x"..(v.po or ""), 16) -- TODO: use format bytes soon
					local so: number? = tonumber("0x"..(v.so or ""), 16)
					local o: number? = tonumber("0x"..(v.o or ""), 16)
					if op == nil then
						continue
					end
					
					local completed_op: number? = formatBytes(op, so, o);
					
					if completed_op == nil then
						warn(op, so, o)
					end
					
					completed_op += 1
					
					local comment_formation: string = `{v.mnemonic}: {v.po}`
					if v.so ~= "" and v.so ~= nil then
						comment_formation ..= ` {v.so}`
					end;
					if v.o ~= "" and v.o ~= nil then
						comment_formation ..= ` /{v.o}`
					end
					
					if v["0F"] == "0F" then
						instruction_file_result_multi ..= `[{completed_op}] = @native function(EIP: number, prefix: number): number-- {comment_formation}\n{new_definition}\n return EIP;\nend,\n`
					else
						instruction_file_result_single ..= `[{completed_op}] = @native function(EIP: number, prefix: number): number-- {comment_formation}\n{new_definition}\n return EIP;\nend,\n`
					end;
					
				end;
			end;
			
			table.clear(sort_per_mnemonic)
			
			local mk_table = function(str)
				str ..= `}`
				str = `return function(self) {InstructionFileHeader} {str} end`
				local result = loadstring(str)
				if SILENCE_DUMP == false or result == nil then
					local dmp_str = `\n\n\n\n\n\n\n\n-- DUMP BEGIN --\n{str}\n-- DUMP END --\n\n\n\n\n\n\n\n`;
					
					for i = 0, math.floor(dmp_str:len() / 199_999) do
						local new = string.sub(dmp_str, 199_999 * i, 199_999 * (i+1))
						local str = Instance.new("StringValue")
						str.Value = new
						str.Parent = game.ReplicatedStorage
						str.Name = i
						warn(`DUMP SEGMENT {i}\n\t{str:GetFullName()}\n\t{new:len()} bytes`)
					end;
					
					warn(`-- dumped {dmp_str:len()} bytes total --`)
				end
				if result == nil then
					error(`RESULT: {result}\n\n- Instruction Compiler loadstring fault -`)
				end
				result = result()
				if result == nil then
					error(`{result}\n\n- Instruction Compiler post-loadstring fault -`)
				end
				result = result(self)
				
				local cached_func = function()
					error(`opcode not implemented`)
				end

				local instruction_table = table.create(formatBytes(256, 256, 8), nil);
				
				for i,v in result do
					task.wait()
					instruction_table[i] = v
				end
				
				return instruction_table;
			end;
			
			print(instruction_file_result_single:len())
			self.instruction_definitions_single = mk_table(instruction_file_result_single);
			self.instruction_definitions_multi = mk_table(instruction_file_result_multi);
			for i: number, v: number in self.instruction_definitions_single do
				if i < 256 then
					self.singleByteDecoders[i] = v
				end
			end
			for i: number, v: number in self.instruction_definitions_multi do
				if i < 256 then
					self.multiByteDecoders[i] = v
				end
			end
			self.initializedCores += 1
		end)();
	end,
}