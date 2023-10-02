---@class ControlBehavior
local ControlBehavior = {}
local LuaObjectUtil = require("lib/LuaObjectUtil")

ControlBehavior.properties = {
	get_circuit_network = {canRead=false, canWrite=false, canCall = true, type = "LuaCircuitNetwork"},
	type				= {canRead=true, canWrite=false}, -- defines.control_behavior.type
	entity				= {canRead=true, canWrite=false}, -- LuaEntity 
}

function ControlBehavior.copyToTable(behavior, t)
	LuaObjectUtil.copyToTable(behavior, t, ControlBehavior.properties)
end

function ControlBehavior.asTable(behavior)
	return LuaObjectUtil.asTable(behavior, ControlBehavior.properties)
end

return ControlBehavior