require("modules/Utils")
local this = {}

local function dump_entities(surface, pos)
	xpcall(function()
		print("  entities at "..pos.x..","..pos.y.." ("..surface.name..")")
		local entites = surface.find_entities_filtered { position = pos}
		for _, entity in ipairs(entites) do
			local name = entity.name
			if(name=="entity-ghost") then name=name.." ("..entity.ghost_name.."/"..entity.ghost_type.. ")"
			else name=name.." ("..entity.type..")" end
			local valid = entity.valid and "" or " [not valid]"
			print("    ? "..name..valid.." ("..(entity.unit_number or "")..")")
		end
	end, function(err) print("  error: "..err) end)
end

-- on_built_entity
-- on_robot_built_entity
-- script_raised_built
-- script_raised_revive
function this.on_built_entity(evt)
	local new_entity = Utils.get_entity[evt.name](evt)
	print("on_built_entity "..new_entity.name.." ("..(new_entity.unit_number or "-")..") ["..Utils.evt_displaynames[evt.name].."]")
	if(new_entity.name=="entity-ghost") then
		if(not new_entity.prototype.name:match("%-slim%-inserter")) then --[[print("  skip: not an slim-inserter ghost");]] return end
	elseif not string.match(new_entity.name, "%-slim%-inserter") then --[[print("  skip: not an slim-inserter");]] return end

	dump_entities(new_entity.surface, new_entity.position)
	
	if(new_entity.name=="entity-ghost") then this.on_built_inserter_ghost(evt);return end
	if(new_entity.name:match("%-double%-slim%-inserter$")) then this.on_built_double_inserter(evt); return end

	-- Check if there is already an inserter on the tile
	local existingEntities = new_entity.surface.find_entities_filtered{position = new_entity.position}
	local existingInserters={};
	for _, ee in ipairs(existingEntities) do
		local c = "? "; if(ee.unit_number==new_entity.unit_number) then c="* " end
		print("  "..c..ee.name.." ("..(ee.unit_number or "-")..")")
		if(ee.type~="inserter") then ;--skip arrows and non inserters
		elseif(ee.unit_number == new_entity.unit_number) then ; --skip self
		else table.insert(existingInserters,ee) end
	end

	if #existingInserters == 0 then
		print("  on empty tile")
		this.remove_remnants(new_entity)
		this.create_arrow(new_entity)
	elseif #existingInserters == 1 then
		print("  over existing: "..new_entity.name)
		local force = new_entity.force
		local position = new_entity.position;
		local direction_a = new_entity.direction;
		local surface = new_entity.surface
		local new_prefix = new_entity.name:gsub("slim%-inserter$","")
		local existing_prefix = existingInserters[1].name:gsub("slim%-inserter$","")
		local existing_direction = existingInserters[1].direction;

		this.remove_matching_arrow(existingInserters[1]);
		new_entity.destroy()
		local entity_a = surface.create_entity { name = new_prefix.."slim-inserter_part-a", position = position, direction = direction_a, fast_replace = true, force = force, spill = false }
		this.create_arrow(entity_a)
		local t = "slim-inserter_part-b"; if (direction_a~=existing_direction) then t="slim-inserter_part-a" end
		local entity_b = surface.create_entity { name = existing_prefix..t, position = position, direction = existing_direction, fast_replace = true, force = force, spill = false }
		Entity.copy_inserter_properties(existingInserters[1], entity_b)
		this.create_arrow(entity_b)
		existingInserters[1].destroy();
	elseif #existingInserters >= 2 then
		local existing_prefix = existingInserters[1].name:match("(.-%-)slim%-inserter")
		if(existing_prefix:match("%-double$")) then
			print("  over double") -- existing inserter is an double inserter
			Entity.deconstruct(new_entity, evt) --cancel build
			--TODO: replace double inserter
		else
			print("  over dual") -- existing inserter is an dual inserter (or unknown type!)
			local surface = new_entity.surface
			local position = new_entity.position;
			local name = new_entity.name
			Entity.deconstruct(new_entity, evt) --cancel build
			--TODO: replace existing inserter
		end
	end

	--- HACK: Kuxynator
	--- blacklist the inserter if no filter is defined
	--- draw back: inserter without filter which is intentionally whitelisted will be changed
	-- HACK: no longer necessary --
	-- local hasFilter=false
	-- for i = 1, entity.prototype.filter_count do
	-- 	local filter = entity.get_filter(i)
	-- 	if(filter) then hasFilter=true;break end
	-- end
	-- if(not hasFilter) then entity.inserter_filter_mode="blacklist" end
    ::continue::
end

---------------------------------------------------------------------------------------------------

function this.on_built_double_inserter(evt)
	local new_entity = Utils.get_entity[evt.name](evt)
	print("on_built_double_inserter")

	local part=this.find_part_ghost(new_entity) or this.find_part(new_entity)

	this.remove_any_other({new_entity,part}, evt)
	this.create_double_part(new_entity, part)
	this.create_arrow(new_entity)

	dump_entities(new_entity.surface, new_entity.position)
end

function this.on_built_inserter_ghost(evt)
	local new_entity = Utils.get_entity[evt.name](evt)
	print("  ghost: "..new_entity.ghost_name)
	--print("  "..Entity.dump(new_entity))

	if(new_entity.ghost_name:match("%-slim%-inserter_part%-[ab]$")) then
		new_entity.destroy()
		return
	end

	--if(new_entity.ghost_name:match("%-double%-slim%-inserter$")) then return end --nothing to do

	-- local prefix = new_entity.ghost_name:match("^(.-%-)slim%-inserter_part%-[ab]$")
	-- if(prefix) then -- prefix- (l-slim-inserter|r-slim-inserter)
	-- 	print("  sub inserter")
	-- 	this.create_slim_inserter_ghost(new_entity)
	-- 	new_entity.destroy()
	-- end
end

---------------------------------------------------------------------------------------------------
this.create_arrow = Utils.create_arrow

---Creates a new inserter part, using the properties from the ghost if specified.
---@param inserter LuaEntity
---@param part_template LuaEntity?
function this.create_double_part(inserter, part_template)
	local name = inserter.name
	---@diagnostic disable-next-line: missing-fields
	local part = inserter.surface.create_entity {
		name      = name .. "_part",
		position  = inserter.position,
		direction = inserter.direction,
		force     = inserter.force,
		type      = "inserter"
	}
	if(part_template) then
		Entity.copy_inserter_properties(part_template, part)
		part_template.destroy()
	end
	return part
end

function this.create_slim_inserter_ghost(new_entity)
	local prefix = new_entity.ghost_name:match("^(.-%-)slim%-inserter_part%-[ab]$")
	if(prefix) then
		-- dual slim inserter ghost
		local replacement = {
			name         = "entity-ghost",
			position     = new_entity.position,
			direction    = new_entity.direction,
			force        = new_entity.force.name,
			fast_replace = false, -- If true, building will attempt to simulate fast-replace building. If false, it will fail if any non-colliding entities would be destroyed.
			spill        = false, -- If false while fast_replace is true and player is nil any items from fast-replacing will be deleted instead of dropped on the ground.
			raise_built  = false, -- If true; defines.events.script_raised_built will be fired on successful entity creation.
			inner_name   = prefix.."slim-inserter",
		}
		if(new_entity.surface.can_place_entity(replacement) == false) then print("  can't place entity"); return end
		local ghost = new_entity.surface.create_entity(replacement)
		Entity.copy_inserter_properties(new_entity, ghost)
		--print("  ghost: "..Entity.dump(ghost))
	end
end


---@param entity LuaEntity
---@return LuaEntity?
function this.find_part_ghost(entity)
	assert(entity.name:match("double%-slim%-inserter$"), "not a double slim-inserter. "..entity.name)
	local list = entity.surface.find_entities_filtered { position = entity.position, name = "entity-ghost" }
	for _, ghost in ipairs(list) do
		if(ghost.valid and ghost.ghost_name==entity.name.."_part") then return ghost end
	end
	return nil
end

---@param entity LuaEntity
---@return LuaEntity?
function this.find_part(entity)
	assert(entity.name:match("double%-slim%-inserter$"), "not a double slim-inserter. "..entity.name)
	local list = entity.surface.find_entities_filtered { position = entity.position, name = entity.name.."_part" }
	for _, e in ipairs(list) do
		if(e.valid) then return e end
	end
	return nil
end

function this.remove_matching_arrow(inserter)
	local arrow_list = inserter.surface.find_entities_filtered {
		position  = inserter.position,
		type      = "constant-combinator",
		name      = inserter.name.."_arrow",
		direction = (inserter.direction + 4) % 8 -- matchig arrow is rotated 180°
	}
	for _, arrow in ipairs(arrow_list) do
		arrow.destroy()
	end
end

function this.remove_remnants(inserter)
	local list = inserter.surface.find_entities_filtered { position = inserter.position, name = "inserter-remnants" }
	for _, entity in ipairs(list) do
		print("  x "..entity.name)
		entity.destroy()
	end
end

function this.remove_any_other(inserter, e)
	if(type(inserter)=="string") then inserter={inserter} end
	assert(type(inserter)=="table", "Invalid Argumen. 'inserter' must be a string or a string-array")

	local function destroy(entity)
		print("  x "..entity.name)
		entity.destroy()
	end

	local unit_numbers_to_keep = {}
	for _, entity in ipairs(inserter) do unit_numbers_to_keep[entity.unit_number]=true end

	local list = inserter[1].surface.find_entities_filtered { position = inserter[1].position }
	for _, entity in ipairs(list) do
		if(unit_numbers_to_keep[entity.unit_number]) then ;--skip
		elseif(entity.name=="entity-ghost") then destroy(entity)
		elseif(entity.name=="inserter-remnants") then destroy(entity)
		elseif(entity.name:match("%-slim%-inserter_arrow$")) then destroy(entity)
		elseif(entity.name:match("%-double%-slim%-inserter_part$")) then destroy(entity)
		elseif(entity.name:match("%-slim%-inserter$")) then Entity.deconstruct(entity, e)
		else print("  ? "..entity.name) end
	end
end

---------------------------------------------------------------------------------------------------

--TODO: use filter!
script.on_event(defines.events.on_built_entity, this.on_built_entity)
script.on_event(defines.events.on_robot_built_entity, this.on_built_entity)
script.on_event(defines.events.script_raised_built, this.on_built_entity)
script.on_event(defines.events.script_raised_revive, this.on_built_entity)
