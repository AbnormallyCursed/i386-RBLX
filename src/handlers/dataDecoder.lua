--!strict
--!native
local types: {} = require(game:GetService("ServerScriptService"):WaitForChild("i386"):WaitForChild("types"))

local checkFor: {string} = {"iext", "proc", "st", "m", "grp1", "grp2", "grp3", "tested f", "modif f", "def f", "undef f", "f values"}
local _nil: nil = nil
local _true: true = true
local _false: false = false
local _find: <V>({V}, V, number?) -> number? = table.find
local _tonumber: <T>(T, number?) -> number? = tonumber
local _0F: "0F" = "0F";
local _o: "o" = "o";
local _0x: "0x" = "0x";
local _emptyStr: "" = "";
local _so: "so" = "so";
local _tonumber: <T>(T, number?) -> number? = tonumber;
local compilerDataCount: number = 1;
local compilerDataMaster: {any} = {};
local notImplemented = @native function(EIP: number, prefix: number, opcode: number, ...: number): number
	warn("Not implemented you goober", "EIP:", EIP, "Prefix:", prefix, "OPCODE:", "0x"..string.format("%X", opcode))
	return EIP
end
local invalidInstruction = @native function(EIP: number, ...: number): number
	warn("Invalid instruction you silly")
	return EIP
end
local lazy = @native function(self: types._i386, data: string): {any}
	local decodedData: {any} = self.services.HttpService:JSONDecode(data);
	local decoderTable: {any} = {}
	local sub_decode_func_single: {[string]: any} = self.sub_decode_func_single
	local sub_decode_func_multi: {[string]: (number, number, number) -> number} = self.sub_decode_func_multi
	local instruction_definitions_multi: {any} = self.instruction_definitions_multi
	local instruction_definitions_single: {any} = self.instruction_definitions_single
	for i: number, instructionJSON: types._jsonInstruction in decodedData do
		local so: string? = instructionJSON.so
		if so ~= _emptyStr then
			continue;
		end;
		for _: number, v: string in checkFor do
			instructionJSON[v] = _nil;
		end;
		local primaryOpcode: number? = _tonumber(_0x..instructionJSON.po, 16);
		if not primaryOpcode then
			continue;
		end;
		
		local isMultiByte: boolean = instructionJSON[_0F] == _0F;
		compilerDataMaster[compilerDataCount] = instructionJSON;
		
		local field: string = ((_tonumber(_0x..so, 16) and _so) or _emptyStr)..((_tonumber(_0x..(instructionJSON.o or _emptyStr)) and _o) or _emptyStr)
		local targetDecoderFunction = ((isMultiByte and sub_decode_func_multi) or sub_decode_func_single)[field];
		
		compilerDataCount += 1;
		primaryOpcode += 1;
		
		if targetDecoderFunction then
			decoderTable[primaryOpcode] = decoderTable[primaryOpcode] or targetDecoderFunction;
		else
			decoderTable[primaryOpcode] = ((isMultiByte and instruction_definitions_multi or instruction_definitions_single)[primaryOpcode]) or decoderTable[primaryOpcode] --or notImplemented;
		end;
		
		instructionJSON.op1 = instructionJSON.op1 or "";
		instructionJSON.op2 = instructionJSON.op2 or "";
		instructionJSON.op3 = instructionJSON.op3 or "";
		instructionJSON.op4 = instructionJSON.op4 or "";
		if instructionJSON.op1:find("Z") or instructionJSON.op2:find("Z") or instructionJSON.op3:find("Z") or instructionJSON.op4:find("Z") then
			for i = 1, 7 do
				decoderTable[primaryOpcode + i] = decoderTable[primaryOpcode];
			end;
		end;
	end;
	for i: number = 1, 257 do
		if not decoderTable[i] then
			decoderTable[i] = nil;
		end;
	end;
	return decoderTable;
end
return {
	decodeData = function(self: types._i386): ()
		local multiByteDecoder: {any} = lazy(self, self.jsonMultiByte);
		local singleByteDecoder: {any} = lazy(self, self.jsonSingleByte);
		self.compilerDataMaster = compilerDataMaster;
		self.multiByteDecoders = multiByteDecoder;
		self.singleByteDecoders = singleByteDecoder;		
		self.decodeData = nil :: never;
		self.jsonMultiByte = nil :: never;
		self.jsonSingleByte = nil :: never;
	end,
}
