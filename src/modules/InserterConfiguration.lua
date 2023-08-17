local Version = KuxCoreLib.Version

---@class InserterConfiguration
InserterConfiguration = {}

function InserterConfiguration.is_workaround_required()
	if(game.active_mods["bobinserters"]) then
		if(Version.compare(game.active_mods["bobinserters"], "1.1.8")>=0) then return false end
	elseif(game.active_mods["Smart_Inserters"]) then return false -- support is pending
		--
	elseif(game.active_mods["Inserter_Config"]) then
		-- seems abandoned, last change over 2 years ago
	end

	-- defaul: all other cases
	return true
end

return InserterConfiguration