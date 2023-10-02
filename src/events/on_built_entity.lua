require("modules/Utils")
---@class on_built_entity
local this = {}

local InserterUtils = require("modules/InserterUtils") --[[@as InserterUtils]]

local function dump_entities(surface, pos)
	xpcall(function()
		trace.append("  entities at "..pos.x..","..pos.y.." ("..surface.name..")")
		local entites = surface.find_entities_filtered { position = pos}
		for _, entity in ipairs(entites) do
			local name = entity.name
			if(name=="entity-ghost") then name=name.." ("..entity.ghost_name.."/"..entity.ghost_type.. ")"
			else name=name.." ("..entity.type..")" end
			local valid = entity.valid and "" or " [not valid]"
			trace.append("    ? "..name..valid.." ("..(entity.unit_number or "")..")")
		end
	end, function(err) trace.append("  error: dump_entities failed. "..err) end)
end

-- on_built_entity
-- on_robot_built_entity
-- script_raised_built
-- script_raised_revive
function this.on_built_entity(evt)
	local new_entity = Utils.get_entity[evt.name](evt)
	--trace("on_built_entity ", function() return trace.formatEntityEvent(evt) end)
	if(new_entity.name=="entity-ghost") then
		if(not new_entity.prototype.name:match("%-slim%-inserter")) then --[[trace.append("  skip: not an slim-inserter ghost");]] return end
	elseif not string.match(new_entity.name, "%-slim%-inserter") then --[[trace.append("  skip: not an slim-inserter");]] return end

	if(evt.name=="script_raised_built" or evt.name=="script_raised_revive") then return end --TODO: when do we need this?

	-- xpcall(function()
		dump_entities(new_entity.surface, new_entity.position)

		if(new_entity.name=="entity-ghost") then this.on_built_inserter_ghost(evt, new_entity);return end
		if(new_entity.name:match("%-double%-slim%-inserter$")) then this.on_built_double_inserter(evt, new_entity); return end
		if(new_entity.name:match("%-loader%-slim%-inserter$")) then this.on_built_loader_inserter(evt, new_entity); return end
		this.on_built_slim_inserter(evt, new_entity)

	-- end, function(err)
	-- 	trace.append("  error: on_built_entity failed.\n" .. debug.traceback(err,2))
	-- 	ErrorHandler.createReport(evt, err, {mod = mod.name, point_to={type="entity", entity = new_entity}})
	-- end)
end

---------------------------------------------------------------------------------------------------

function this.on_built_slim_inserter(evt, new_entity)
	-- Check if there is already an inserter on the tile
	local existingEntities = new_entity.surface.find_entities_filtered{position = new_entity.position}
	local existingInserters={};
	for _, ee in ipairs(existingEntities) do
		local c = "? "; if(ee.unit_number==new_entity.unit_number) then c="* " end
		trace.append("  "..c..ee.name.." ("..(ee.unit_number or "-")..")")
		if(ee.type~="inserter") then ;--skip arrows and non inserters
		elseif(ee.unit_number == new_entity.unit_number) then ; --skip self
		else table.insert(existingInserters,ee) end
	end

	--TODO: bots could set slim-inserter_part-a/b from blueprint

	if #existingInserters == 0 then
		trace.append("  on empty tile")
		this.remove_remnants(new_entity)
		this.create_arrow(new_entity)
	elseif #existingInserters == 1 then
		trace.append("  over existing: "..new_entity.name)
		local force = new_entity.force
		local position = new_entity.position;
		local direction_a = new_entity.direction;
		local surface = new_entity.surface
		local new_prefix = new_entity.name:match("(.-%-)slim%-inserter$") or new_entity.name:match("(.-%-)slim%-inserter_part%-[ab]$")
		local existing_prefix = existingInserters[1].name:match("(.-%-)slim%-inserter$") or existingInserters[1].name:match("(.-%-)slim%-inserter_part%-[ab]$")
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
			trace.append("  over double") -- existing inserter is an double inserter
			Entity.deconstruct(new_entity, evt) --cancel build
			--TODO: replace double inserter
		else
			trace.append("  over dual") -- existing inserter is an dual inserter (or unknown type!)
			local surface = new_entity.surface
			local position = new_entity.position;
			local name = new_entity.name
			Entity.deconstruct(new_entity, evt) --cancel build
			--TODO: replace existing inserter
		end
	end
end

function this.on_built_double_inserter(evt, new_entity)
	trace("on_built_double_inserter")

	if(evt.name=="script_raised_built" or evt.name=="script_raised_revive") then
		--TODO: not implemented
		return
	end

	local part=this.find_part_ghost(new_entity) or this.find_part(new_entity)

	this.remove_any_other({new_entity,part}, evt)
	this.create_double_part(new_entity, part)
	this.create_arrow(new_entity)

	dump_entities(new_entity.surface, new_entity.position)
end

function this.on_built_loader_inserter(evt, new_entity)
	trace("on_built_loader_inserter ")

	if(evt.name=="script_raised_built" or evt.name=="script_raised_revive") then
		--TODO: not implemented
		return
	end
	local partghost=this.find_loaderpart_ghost(new_entity) or this.find_loaderpart(new_entity)

	--trace.append(InserterEntity.dump_circuit_behavior(new_entity))

	this.remove_any_other({new_entity,partghost}, evt)
	local part = this.create_loader_part(new_entity, partghost)
	this.create_arrow(new_entity)	
	InserterUtils.connect_loaderpart(new_entity, part)

	--dump_entities(new_entity.surface, new_entity.position)
end

function this.on_built_inserter_ghost(evt, new_entity)
	trace.append("  ghost: "..new_entity.ghost_name)
	--trace.append("  "..Entity.dump(new_entity))

	if(evt.name=="script_raised_built" or evt.name=="script_raised_revive") then
		--TODO: not implemented
		return
	end

	if(new_entity.ghost_name:match("%-slim%-inserter_part%-[ab]$")) then
		new_entity.destroy()
		return
	end

	--if(new_entity.ghost_name:match("%-double%-slim%-inserter$")) then return end --nothing to do

	-- local prefix = new_entity.ghost_name:match("^(.-%-)slim%-inserter_part%-[ab]$")
	-- if(prefix) then -- prefix- (l-slim-inserter|r-slim-inserter)
	-- 	trace.append("  sub inserter")
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

---Creates a new inserter part, using the properties from the ghost if specified.
---@param inserter LuaEntity
---@param part_template LuaEntity?
function this.create_loader_part(inserter, part_template)
	local name = inserter.name
	---@diagnostic disable-next-line: missing-fields
	local part = inserter.surface.create_entity {
		name      = name .. "_loaderpart",
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
		if(new_entity.surface.can_place_entity(replacement) == false) then trace.append("  can't place entity"); return end
		local ghost = new_entity.surface.create_entity(replacement)
		Entity.copy_inserter_properties(new_entity, ghost)
		--trace.append("  ghost: "..Entity.dump(ghost))
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
function this.find_loaderpart_ghost(entity)
	assert(entity.name:match("loader%-slim%-inserter$"), "not a loader slim-inserter. "..entity.name)
	local list = entity.surface.find_entities_filtered { position = entity.position, name = "entity-ghost" }
	for _, ghost in ipairs(list) do
		if(ghost.valid and ghost.ghost_name==entity.name.."_loaderpart") then return ghost end
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

---@param entity LuaEntity
---@return LuaEntity?
function this.find_loaderpart(entity)
	assert(entity.name:match("loader%-slim%-inserter$"), "not a loader slim-inserter. "..entity.name)
	local list = entity.surface.find_entities_filtered { position = entity.position, name = entity.name.."_loaderpart" }
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
		trace.append("  x "..entity.name)
		entity.destroy()
	end
end

function this.remove_any_other(inserter, e)
	if(type(inserter)=="string") then inserter={inserter} end
	assert(type(inserter)=="table", "Invalid Argumen. 'inserter' must be a string or a string-array")

	local function destroy(entity)
		trace.append("  x "..entity.name)
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
		else trace.append("  ? "..entity.name) end
	end
end

---------------------------------------------------------------------------------------------------

--TODO: use filter!
script.on_event(defines.events.on_built_entity, this.on_built_entity)
script.on_event(defines.events.on_robot_built_entity, this.on_built_entity)
script.on_event(defines.events.script_raised_built, this.on_built_entity)
script.on_event(defines.events.script_raised_revive, this.on_built_entity)
