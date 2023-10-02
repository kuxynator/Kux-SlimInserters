
--i don't know which mod always changes this, but i need allow_custom_vectors = false
for name, inserter in pairs(data.raw["inserter"]) do
	if(name:match("%-loader%-slim%-inserter")) then
		inserter.allow_custom_vectors = false
	end
end

--print(serpent.block(data.raw["inserter"]["basic-loader-slim-inserter"]))