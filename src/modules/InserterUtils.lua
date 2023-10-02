---@class InserterUtils
local InserterUtils = {}

local InserterEntity = require("lib/InserterEntity") --[[@as InserterEntity]]


---@param inserter LuaEntity
---@param part LuaEntity
function InserterUtils.connect_loaderpart(inserter, part)
	trace("connect_loaderpart: "..inserter.name)
	local hastBehavior = inserter.get_control_behavior() ~= nil

	if(not hastBehavior) then
		local behavior = inserter.get_or_create_control_behavior() --[[@as LuaInserterControlBehavior]]
		trace.append(InserterEntity.dump_circuit_behavior(inserter))
		behavior.circuit_mode_of_operation = defines.control_behavior.inserter.circuit_mode_of_operation.none
		trace.append("set circuit_mode_of_operation = none")
	end

	part.inserter_stack_size_override = inserter.inserter_stack_size_override
	InserterEntity.copy_filter(inserter, part)
	InserterEntity.connect_green_wire(inserter, part)
	InserterEntity.copy_behavior(inserter, part)

end

function InserterEntity.set_default_behavior(inserter)
	local behavior = inserter.get_control_behavior() --[[@as LuaInserterControlBehavior]]
	if(not behavior) then return end

	behavior.circuit_mode_of_operation    = defines.control_behavior.inserter.circuit_mode_of_operation.enable_disable
    behavior.circuit_hand_read_mode       = defines.control_behavior.inserter.hand_read_mode.pulse
    behavior.circuit_read_hand_contents   = false
    behavior.circuit_set_stack_size       = false
    behavior.circuit_stack_control_signal = nil
    behavior.circuit_condition            = {condition = {comparator = "<", constant = 0, first_signal = {type = "item"}}, fulfilled = false}
end

return InserterUtils