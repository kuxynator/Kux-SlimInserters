require("modules/Utils")
TechnologyBuilder ={}

function TechnologyBuilder.add_to_tech(preset)
	local base_name = preset.base_name or error("Argument Exception. preset.base_name must not be nil.")
	local name = Utils.create_name(preset)

	local found = false
	local logTech =""
	for _, tech in pairs(data.raw.technology) do
		if found then break end
		if tech.effect ~= nil or tech.effects ~= nil then
			if tech.effect ~= nil then
				if tech.effect.type == "unlock-recipe" and tech.effect.recipe == base_name then
					tech.effects = { tech.effect, { type = "unlock-recipe", recipe = name } }
					tech.effect = nil
					found = true
					logTech = tech.name
				end
			else
				for _, effect in pairs(tech.effects) do
					if effect.type == "unlock-recipe" and effect.recipe == base_name then
						table.insert(tech.effects, { type = "unlock-recipe", recipe = name })
						found = true
						logTech = tech.name
					end
				end
			end
		end
	end
	local logFound="found in "..logTech; if not found then logFound = "not found" end
	log("add_to_tech: "..name.." ["..logFound.."]")
end

return TechnologyBuilder
