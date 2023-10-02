-- https://lua-api.factorio.com/latest/classes/LuaInserterControlBehavior.html

---@class InserterControlBehavior
local InserterControlBehavior = {}
local GenericOnOffControlBehavior = require("lib/GenericOnOffControlBehavior")
local LuaObjectUtil = require("lib/LuaObjectUtil")

InserterControlBehavior.members = {
	--help
	circuit_read_hand_contents   = {canRead=true, canWrite=true},
	circuit_mode_of_operation    = {canRead=true, canWrite=true},
	circuit_hand_read_mode       = {canRead=true, canWrite=true},
	circuit_set_stack_size       = {canRead=true, canWrite=true},
	circuit_stack_control_signal = {canRead=true, canWrite=true},
	valid                        = {canRead=true, canWrite=false},
	object_name                  = {canRead=true, canWrite=false},
}

---Copies the properties to a table
---@param behavior LuaInserterControlBehavior
---@param t LuaInserterControlBehavior A table into which the properties are copied
function InserterControlBehavior.copyToTable(behavior, t)
	LuaObjectUtil.copyToTable(behavior, t, InserterControlBehavior.members)
	GenericOnOffControlBehavior.copyToTable(behavior, t)
end

---Converts the behavior to a table
---@param behavior LuaInserterControlBehavior
---@return LuaInserterControlBehavior #A table that contains LuaInserterControlBehavior members
function InserterControlBehavior.asTable(behavior)
	local t = LuaObjectUtil.asTable(behavior, InserterControlBehavior.members)
	GenericOnOffControlBehavior.copyToTable(behavior, t)
	return t
end

return InserterControlBehavior


