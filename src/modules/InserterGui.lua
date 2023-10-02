---@class InserterGui
local this = {}

local InserterEntity = require("lib/InserterEntity") --[[@as InserterEntity]]
local InserterUtils = require("modules/InserterUtils") --[[@as InserterUtils]]
ErrorHandler = KuxCoreLib.ErrorHandler

local _relPick, _relDrop
function this.on_gui_opened(evt)
	local entity = evt.entity
	if not entity or entity.type ~= "inserter" or not string.match(entity.name, "%-slim%-inserter$") then return end

	local entity = evt.entity
	_relPick = InserterEntity.get_relative_pickup_position(entity)
	_relDrop = InserterEntity.get_relative_drop_position(entity)

	-- local p = this.get_relative_pickup_position(entity)
	-- local x,y = p.x, p.y
	-- x=Qp(x); y=Qp(y)
	-- entity.pickup_position = { entity.position.x + x, entity.position.y + y }
	-- local d = this.get_relative_drop_position(entity)
	-- x,y = d.x, d.y
	-- x=Qp(x); y=Qp(y)
	-- entity.drop_position = { entity.position.x + x, entity.position.y + y }

	--entity.operable = false
end

function this.on_gui_closed(evt)
	if not evt.entity or evt.entity.type ~= "inserter" or not string.match(evt.entity.name, "%-slim%-inserter") then return end
	trace("on_gui_closed: "..evt.entity.name)
	xpcall(function ()
		local inserter = evt.entity --[[@as LuaEntity]]

		if(InserterConfiguration.is_workaround_required()) then this.auto_correction(inserter) end

		if(inserter.name:match("%-loader")) then
			this.on_gui_closed_for_loader(inserter)
		end
	end,function (err)
		log(debug.traceback(err,2))
		ErrorHandler.createReport(evt,err,{})
	end)
end

---------------------------------------------------------------------------------------------------

function this.on_gui_closed_for_loader(inserter)
	local part = this.find_loaderpart(inserter)
	InserterUtils.connect_loaderpart(inserter, part)
end

---@param inserter LuaEntity
---@return LuaEntity?
function this.find_loaderpart(inserter)
	local parts = inserter.surface.find_entities_filtered { position = inserter.position, name=inserter.name.."_loaderpart" }
	return parts[1]
end

function this.auto_correction(entity)
	--- NOTE: _relDrop, _relPick could be nil, if the game was loaded while the UI was open.
	if(not _relDrop or not _relPick) then return end

	-- HACK: temporary workaround for bobinserters 1.1.7 and other configuration mods

	local p = InserterEntity.get_relative_pickup_position(entity)
	local d = InserterEntity.get_relative_drop_position(entity)
	local look = (entity.orientation * 4 )
	print("on_gui_closed: {"..p.x..", "..p.y.."} => {"..d.x..", "..d.y.."} look="..look)

	local x,y = d.x, d.y

	if(_relDrop.x ~= x or _relDrop.y ~= y) then
		x=this.Q(x); y=this.Q(y)
		-- local a,b = get_directional_position(x,y)
		-- if    (look==0) then x= b; y= a
		-- elseif(look==1) then x=-a; y= b
		-- elseif(look==2) then x= b; y=-a
		-- else                 x= a; y= b end
		entity.drop_position = { entity.position.x + x, entity.position.y + y }
	end

	x,y = p.x, p.y
	if(_relPick.x ~= x or _relPick.y ~= y) then
		x=this.Q(x); y=this.Q(y)
		local a = InserterEntity.get_directional_position(x,y)
		if    (look==0) then x= 0; y=-a
		elseif(look==1) then x= a; y= 0
		elseif(look==2) then x= 0; y= a
		else                 x=-a; y= 0 end
		entity.pickup_position = { entity.position.x + x, entity.position.y + y }
	end
end

function this.Qp(v)
	if(v<-0.25) then return -this.Qp(-v) end

	if(v>3.25 -0.5-0.1) then return 3.0 + 0.2 end
	if(v>=3.0 -0.5-0.1) then return 3.0 end
	if(v>=2.75-0.5-0.1) then return 3.0 - 0.2 end

	if(v>2.25 -0.5-0.1) then return 2.0 + 0.2 end
	if(v>=2.0 -0.5-0.1) then return 2.0 end
	if(v>=1.75-0.5-0.1) then return 2.0 - 0.2 end

	if(v>1.25 -0.5-0.1) then return 1.0 + 0.2 end
	if(v>=1.0 -0.5-0.1) then return 1.0 end
	if(v>=0.75-0.5-0.1) then return 1.0 - 0.2 end

	return v
end

function this.Q(v)
	if(v<-0.25) then return -this.Q(-v) end

	if(v>3.25 ) then return 2.5 + 0.2 end
	if(v>=3.0 ) then return 2.5 end
	if(v>=2.75) then return 2.5 - 0.2 end

	if(v>2.25 ) then return 1.5 + 0.2 end
	if(v>=2.0 ) then return 1.5 end
	if(v>=1.75) then return 1.5 - 0.2 end

	if(v>1.25 ) then return 0.5 + 0.2 end
	if(v>=1.0 ) then return 0.5 end
	if(v>=0.75) then return 0.5 - 0.2 end

	return v
end
---------------------------------------------------------------------------------------------------
Events.on_event(defines.events.on_gui_opened, this.on_gui_opened)
Events.on_event(defines.events.on_gui_closed, this.on_gui_closed)