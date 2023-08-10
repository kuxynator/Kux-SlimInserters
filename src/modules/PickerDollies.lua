PickerDollies = {}

local this = {}

function this.destroy_arrow(filter)
	local surface = filter.surface or game.surfaces[1]
	filter.surface = nil
	filter.type = "constant-combinator"
	local list = surface.find_entities_filtered(filter)
	for _,a in ipairs(list) do a.destroy() end
	--this.on_built_entity { name = defines.events.on_entity_died, entity = entity } --TODO why on_entity_died ??
end

---Teleports other inserter parts
---@param entity LuaEntity The entity that has been moved
---@param old_pos MapPosition The old position of the entity
function this.move_other_inserter_parts(entity, old_pos)
	local list = entity.surface.find_entities_filtered{ position = old_pos } --[[@as LuaEntity[] ]]
	for _,other_entity in ipairs(list) do
		if other_entity.name:match("%-slim%-inserter") then
			print("  > "..other_entity.name)
			other_entity.teleport(entity.position)
		else
			print("  ? "..other_entity.name)
		end
	end
end

function this.on_dolly_moved_entity(e)
	local entity = e.moved_entity
	if entity.name:match("%-slim%-inserter$") then
		-- this.destroy_arrow{ position = e.start_pos, name=entity.name.."_arrow" }
		-- Utils.create_arrow(entity)
		this.move_other_inserter_parts(entity, e.start_pos)
	elseif entity.name:match("double%-%-slim%-inserter$") then
		this.move_other_inserter_parts(entity, e.start_pos)
	elseif entity.name:match("double%-%-slim%-inserter_part$") then
		this.move_other_inserter_parts(entity, e.start_pos)
	end
end

function PickerDollies.init()
	if not remote.interfaces["PickerDollies"] or not remote.interfaces["PickerDollies"]["dolly_moved_entity_id"] then return end
	script.on_event(remote.call("PickerDollies", "dolly_moved_entity_id"), this.on_dolly_moved_entity)
end

--- @param entity_name string
--- @return boolean?
function PickerDollies.add_blacklist_name(entity_name)
	if remote.interfaces["PickerDollies"] and remote.interfaces["PickerDollies"]["add_blacklist_name"] then
		return remote.call("PickerDollies", "add_blacklist_name", entity_name)
	end
end

--- @param entity_name string
--- @return boolean?
function PickerDollies.remove_blacklist_name(entity_name)
	if remote.interfaces["PickerDollies"] and remote.interfaces["PickerDollies"]["remove_blacklist_name"] then
		return remote.call("PickerDollies", "remove_blacklist_name", entity_name)
	end
end

--- @return {[string]: true}?
function PickerDollies.get_blacklist_names()
	if remote.interfaces["PickerDollies"] and remote.interfaces["PickerDollies"]["get_blacklist_names"] then
		return remote.call("PickerDollies", "get_blacklist_names")
	end
end

--- @param entity_name string
--- @return boolean?
function PickerDollies.add_oblong_name(entity_name)
	if remote.interfaces["PickerDollies"] and remote.interfaces["PickerDollies"]["add_oblong_name"] then
		return remote.call("PickerDollies", "add_oblong_name", entity_name)
	end
end

--- @param entity_name string
--- @return boolean?
function PickerDollies.remove_oblong_name(entity_name)
	if remote.interfaces["PickerDollies"] and remote.interfaces["PickerDollies"]["remove_oblong_name"] then
		return remote.call("PickerDollies", "remove_oblong_name", entity_name)
	end
end

--- @return {[string]: true}?
function PickerDollies.get_oblong_names()
	if remote.interfaces["PickerDollies"] and remote.interfaces["PickerDollies"]["get_oblong_names"] then
		return remote.call("PickerDollies", "get_oblong_names")
	end
end
