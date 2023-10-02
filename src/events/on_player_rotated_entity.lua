require("modules/Utils")
local this = {}

--TODO: support rotating double inserter

function this.on_player_rotated_entity(evt)
	local entity = evt.entity
	if string.match(entity.name, "%-double%-slim%-inserter$") then
		local name = entity.name .. "_part"
		local part = entity.surface.find_entity(name, entity.position)
		if(not part) then log("Counterpart not found. "..name); return end
		part.direction = entity.direction
		entity.surface.find_entity(entity.name .. "_arrow", entity.position).direction = (entity.direction + 4) % 8
	elseif string.match(entity.name, "%-double%-slim%-inserter_part$") then
		local name = entity.name:gsub("_part$", "")
		local main =  entity.surface.find_entity(name, entity.position)
		if(not main) then log("Counterpart not found. "..name); return end
		main.direction = entity.direction
		entity.surface.find_entity(name .. "_arrow", entity.position).direction = (entity.direction + 4) % 8
	elseif string.match(entity.name, "%-loader%-slim%-inserter_loaderpart$") then
		local name = entity.name:gsub("_loaderpart$", "")
		local main =  entity.surface.find_entity(name, entity.position)
		if(not main) then log("Counterpart not found. "..name); return end
		main.direction = entity.direction
		entity.surface.find_entity(name .. "_arrow", entity.position).direction = (entity.direction + 4) % 8
	elseif string.match(entity.name, "%-slim%-inserter$") then
		--HACK: always rotate
		entity.surface.find_entity(entity.name .. "_arrow", entity.position).direction = (entity.direction + 4) % 8

		--HACK: feature disabled
		if false and not game.active_mods["bobinserters"] then
			entity.surface.find_entity(entity.name .. "_arrow", entity.position).direction = (entity.direction + 4) % 8
			return
		end
		if(false) then --HACK: feature disabled
			entity.direction = (entity.direction + 4) % 8
			local is_long = entity.name:find("long")
			local is_stack = entity.name:find("stack")
			if not is_long and not is_stack then this.norm_next(entity) return end
			if is_long and not is_stack then this.long_next(entity); return end
			if not is_long and is_stack then this.stack_next(entity); return end
			if is_long and is_stack then this.long_stack_next(entity) return end
		end
	end
end

---------------------------------------------------------------------------------------------------

function this.long_stack_next(entity)
	local eName = entity.prototype.items_to_place_this[1].name
	local direction = entity.direction
	local position = entity.position
	local force = entity.force
	local surface = entity.surface
	surface.create_entity { name = "" .. eName, position = position, direction = direction, fast_replace = true,
		force = force, spill = false }
end

function this.norm_next(entity)
	if entity.force.technologies["long-inserters-1"].researched then
		local eName = entity.prototype.items_to_place_this[1].name
		local direction = entity.direction
		local position = entity.position
		local force = entity.force
		local surface = entity.surface
		surface.create_entity { name = "long-" .. eName, position = position, direction = direction, fast_replace = true,
			force = force, spill = false }
	else
		this.long_stack_next(entity)
	end
end

function this.long_next(entity)
	if entity.force.technologies["more-inserters-1"].researched then
		local eName = entity.prototype.items_to_place_this[1].name
		local direction = entity.direction
		local position = entity.position
		local force = entity.force
		local surface = entity.surface
		surface.create_entity { name = "stack-" .. eName, position = position, direction = direction, fast_replace = true,
			force = force, spill = false }
	else
		this.long_stack_next(entity)
	end
end

function this.stack_next(entity)
	if entity.force.technologies["long-inserters-2"].researched then
		local eName = entity.prototype.items_to_place_this[1].name
		local direction = entity.direction
		local position = entity.position
		local force = entity.force
		local surface = entity.surface
		surface.create_entity { name = "stack-long-" .. eName, position = position, direction = direction, fast_replace = true,
			force = force, spill = false }
	else
		this.long_stack_next(entity)
	end
end

---------------------------------------------------------------------------------------------------

script.on_event(defines.events.on_player_rotated_entity, this.on_player_rotated_entity)