---@class GenericOnOffControlBehavior
local GenericOnOffControlBehavior = {}
local ControlBehavior = require("lib/ControlBehavior")
local LuaObjectUtil = require("lib/LuaObjectUtil")

GenericOnOffControlBehavior.members = {
	--help
	disabled                    = {canRead=true, canWrite=false},
	circuit_condition           = {canRead=true, canWrite=true},
	logistic_condition          = {canRead=true, canWrite=true},
	connect_to_logistic_network = {canRead=true, canWrite=true},
	valid                       = {canRead=true, canWrite=false},
	object_name                 = {canRead=true, canWrite=false},
}

---Copies the properties to a table
---@param behavior LuaGenericOnOffControlBehavior
---@param t LuaGenericOnOffControlBehavior
function GenericOnOffControlBehavior.copyToTable(behavior, t)
	LuaObjectUtil.copyToTable(behavior, t, GenericOnOffControlBehavior.members)
	ControlBehavior.copyToTable(behavior, t)
end

---Converts th behavior to a table
---@param behavior LuaGenericOnOffControlBehavior
---@return LuaGenericOnOffControlBehavior
function GenericOnOffControlBehavior.asTable(behavior)
	local t = LuaObjectUtil.asTable(behavior, GenericOnOffControlBehavior.members)
	ControlBehavior.copyToTable(behavior, t)
	return t
end

return GenericOnOffControlBehavior