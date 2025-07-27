local Loaded = 0

for k, Module in pairs(file.Find("tac/*.lua")) do 
	include("tac/" .. Module)
	Loaded = Loaded + 1
end

-- TODO