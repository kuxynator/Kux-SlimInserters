
---@class LuaObjectUtil
local LuaObjectUtil = {}

function LuaObjectUtil.copyToTable(obj, t, properties)
	if(not obj) then return end
		for k,v in pairs(properties) do
		if(v.canRead) then t[k] = obj[k] end
	end
	return t

end

function LuaObjectUtil.asTable(obj, properties)
	local t = {}
	LuaObjectUtil.copyToTable(obj, t, properties)
	return t
end

return LuaObjectUtil