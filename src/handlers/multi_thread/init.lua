--!native
--!strict
local types: {} = require(game:GetService("ServerScriptService"):WaitForChild("i386"):WaitForChild("types"))

local CoresCount: number = 1
local Cores: {Actor} = {};
local _1: number = 1;
local _actor: "actor" = "actor";
local _Folder: "Folder" = "Folder";
local _core: "core" = "core";
local _script: ModuleScript = script;
local thread_actor: Actor = _script:WaitForChild(_actor) :: Actor;
local _insert: (<V>({V}, V) -> ()) & (<V>({V}, number, V) -> ()) = table.insert;
local Folder: Folder?
return {
	addCurrentCoreToActor = @native function(self: types._i386): ()
		local folder: Folder = Folder or Instance.new(_Folder, ((self.services.RunService :: (RunService)):IsServer() and self.services.ServerStorage :: (ServerStorage)) or self.services.ReplicatedStorage :: (ReplicatedStorage)) :: Folder;
		if folder then
			Folder = folder;
		end;
		local thread: Actor = thread_actor:Clone();
		thread.Parent = folder;
		thread.Name = _core..self.coreIndex;
		(require(thread:WaitForChild(_core) :: ModuleScript) :: any)(self);
		Cores[CoresCount] = thread
		CoresCount += 1
	end,
	runCore = @native function(coreIndex: number, func, ...): ()
		Cores[coreIndex]:SendMessage(0x01, func, ...);
	end,
	runSequential = @native @checked function(coreIndex: number, func, ...): ()
		Cores[coreIndex]:SendMessage(0x02, func, ...);
	end,
};