local CoreGui = cloneref(game:GetService("CoreGui"))
local HttpService = cloneref(game:GetService("HttpService"))
local ScriptContext = cloneref(game:GetService("ScriptContext"))

local robloxGui = CoreGui.RobloxGui
local modules = robloxGui.Modules

local requirements = loadstring(game:HttpGet("https://raw.githubusercontent.com/Monkemodder99/requirements/refs/heads/main/lua", true))()

local Utilities : UtilitiesModule = {} :: UtilitiesModule

local oldIndex = nil
local oldNamecall = nil

local newInstance = requirements:Call("NewLClosure", Instance.new)

local protectedInstances = {}

function Utilities:ProtectInstance(instance : Instance)
	if not table.find(protectedInstances, instance, 1) then
		table.insert(protectedInstances, instance)
	end
end

function Utilities:UnprotectInstance(instance : Instance)
	if table.find(protectedInstances, instance, 1) then
		table.remove(protectedInstances, table.find(protectedInstances, instance, 1))
	end
end

function Utilities:DisableLogs() : boolean
	local success, result = pcall(function()
		for index, signal in {ScriptContext.Error} do
			for index, connection in requirements:Call("GetConnections", signal) do
				connection:Disable()
			end
		end
	end)
	if not success then
		warn("Failed to disable logs! Error: " .. result)
		return false
	end
	return true
end

function Utilities:Create(className : string, instanceType : "Instance", protected : boolean, properties : {[string] : any}) : Instance?
	if instanceType == "Instance" then
		local instance = newInstance(className)
		if protected then
			Utilities:ProtectInstance(instance)
		end
		for propertieName, propertieValue in properties do
			instance[propertieName] = propertieValue
		end
		return instance
	end
	return nil
end
