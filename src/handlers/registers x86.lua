--!strict
--!native
local types: {} = require(game:GetService("ServerScriptService"):WaitForChild("i386"):WaitForChild("types"));

type _registerEntry = {
	encoding: {number}?,
	size: number,
	alias: {{string}}?,
}

type _registerEncoding = {
	[string]: _registerEntry
}
local registerCombinedSize: number = -1;
local str: "" = "";
local predef: ", " = ", ";
local _stringType: "string" = "string";
local _tableType: "table" = "table";
local _type: <T>(T) -> string = type;
local createBuffer: (number) -> buffer = buffer.create;
return {
	constructRegisters = function(self: types._i386): ()
		self.constructRegisters = nil :: never
		local fullSize: number = 0;
		local debugPrintEnabled: boolean = self.debugPrintEnabled
		if registerCombinedSize == -1 then
			for _, key: string in self.register_priority do
				local value: _registerEntry = self.registerEncoding[key]
				local regEncoding: {number}? = value.encoding;
				local registerSize: number = value.size / 8;
				local alias: {{string}}? = value.alias;
				if regEncoding and alias then
					if debugPrintEnabled then
						for i: number = regEncoding[1], regEncoding[2] do
							local aliases: string = str;
							for _: number, v: {string} in alias do
								local aliasKey: any = v[i + 1];
								if not aliasKey or _type(aliasKey) == _tableType then
									continue;
								end;
								aliases ..= aliasKey..predef
							end;
							if aliases ~= str then
								print("[", string.sub(aliases, 1, -3), "]: ", fullSize.."-"..(fullSize + registerSize - 1));
							else
								warn(key, ": ", fullSize.."-"..(fullSize + registerSize - 1));
							end;
							fullSize += registerSize;
						end;
					else
						fullSize += registerSize * (regEncoding[2] + 1);
					end;
				else
					if debugPrintEnabled then
						print(key, ": ", fullSize.."-"..(fullSize + registerSize - 1));
					end;
					fullSize += registerSize;
				end;
			end;
			registerCombinedSize = fullSize;
		else
			fullSize = registerCombinedSize;
		end;
		self.registers = createBuffer(fullSize);
		if debugPrintEnabled then
			warn("Register created size of ", fullSize, " bytes");
		end
	end,
};