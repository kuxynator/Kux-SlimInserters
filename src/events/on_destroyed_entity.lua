require("modules/Utils")
local this = {}

local function destroy_matching_arrow(entity)
	--destroy only the _arrow for the matching entity
	local arrows = entity.surface.find_entities_filtered { position = entity.position, name=entity.name.."_arrow" }
	for _, arr in ipairs(arrows) do
		print("  x "..arr.name)
		arr.destroy()
	end
end

local function destroy(surface, pos, name)
	local list = surface.find_entities_filtered { position = pos, name=name }
	for _, inserter in ipairs(list) do
		print("  x "..inserter.name)
		inserter.destroy()
	end

	local list = surface.find_entities_filtered { position = pos, name=name.."_arrow" }
	for _, arrow in ipairs(list) do
		print("  x "..arrow.name)
		arrow.destroy()
	end
end

local function deconstruct(evt,surface, pos, name)
	local list = surface.find_entities_filtered { position = pos, name=name }
	for _, inserter in ipairs(list) do
		print("  ⊠ "..inserter.name)
		Entity.deconstruct(inserter,evt)
	end

	list = surface.find_entities_filtered { position = pos, name=name.."_arrow" }
	for _, arrow in ipairs(list) do
		print("  x "..arrow.name)
		arrow.destroy()
	end
end

function this.on_destroyed_entity(evt)
	local old_entity = Utils.get_entity[evt.name](evt)
	--print("on_destroyed_entity "..old_entity.name) -- unit_number is not available
	--if not old_entity.name:match("%-slim%-inserter$") then print("  not an slim-inserter") return end
	if not old_entity.name:match("%-slim%-inserter") then return end
	local surface = old_entity.surface
	print("on_destroyed_entity (filtered) "..old_entity.name.." ["..Utils.evt_displaynames[evt.name].."]") -- unit_number is not available	
	pcall(function()
		local entites = surface.find_entities_filtered { position = old_entity.position}
		for _, entity in ipairs(entites) do
			local name = entity.name
			if(name=="entity-ghost") then name=name.." ("..entity.ghost_name.."/"..entity.ghost_type.. ")"
			else name=name.." ("..entity.type..")" end
			local valid = entity.valid and "" or " [not valid]"
			print("  ? "..name..valid.." ("..(entity.unit_number or "")..")")
		end
	end)

	if(evt.name == defines.events.on_entity_died) then return end

	-- on_player_mined_entity, on_robot_mined_entity,script_raised_destroy
	destroy_matching_arrow(old_entity)

	if(old_entity.name:match("%-double%-slim%-inserter_part$")) then		
		destroy_matching_arrow(old_entity)
		local double_name = old_entity.name:match("^(.-%-slim%-inserter)_part$")
		destroy(old_entity.surface, old_entity.position, double_name)
		return
	end
	if(old_entity.name:match("%-double%-slim%-inserter$")) then
		destroy_matching_arrow(old_entity)
		destroy(old_entity.surface, old_entity.position, old_entity.name.."_part")
		return
	end

	local double_part_name = old_entity.name:match("^(.-%-slim%-inserter)_part$")
	local dual_a_name = old_entity.name:match("^(.-%-slim%-inserter)_part%-a$")
	local dual_b_name = old_entity.name:match("^(.-%-slim%-inserter)_part%-b$")
	if(double_part_name) then -- is double inserter part
		destroy(old_entity.surface, old_entity.position, double_part_name)
	elseif(dual_a_name) then -- is dual inserter part a
		deconstruct(evt, old_entity.surface, old_entity.position, dual_a_name.."_part-b")
	elseif(dual_b_name) then -- is dual inserter part b
		deconstruct(evt, old_entity.surface, old_entity.position, dual_b_name.."_part-a")
	else -- is double inserter
		destroy(old_entity.surface, old_entity.position, old_entity.name.."_part")
	end	
	
	--TODO: support multiple inserters of same type?
end

--TODO: use filter!
script.on_event(defines.events.on_player_mined_entity, this.on_destroyed_entity)
script.on_event(defines.events.on_robot_mined_entity, this.on_destroyed_entity)
script.on_event(defines.events.on_entity_died, this.on_destroyed_entity)
script.on_event(defines.events.script_raised_destroy, this.on_destroyed_entity)
