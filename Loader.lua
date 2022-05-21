if isfile then
	for _,FileName in pairs{
		"Logo.png",
		"Source.lua",
		"Version.ver"
	} do
		local Success,Result = pcall(game.HttpGet,game,("https://raw.githubusercontent.com/Amourousity/Ultimatum/main/%s"):format(FileName),true)
		if Success and (not isfile(("Ultimatum%s"):format(FileName)) or Result:gsub("%s","") ~= readfile(("Ultimatum%s"):format(FileName)):gsub("%s","")) then
			writefile(("Ultimatum%s"):format(FileName),Result)
		elseif not Success and not isfile(("Ultimatum%s"):format(FileName)) then
			error(("\nUltimatum | %s"):format(tostring(Result)))
		end
	end
	loadstring(readfile("UltimatumSource.lua"),"Ultimatum")()
else
	local Success,Result = pcall(game.HttpGet,game,"https://raw.githubusercontent.com/Amourousity/Ultimatum/main/Source.lua",true)
	assert(Success,("\nUltimatum | %s"):format(tostring(Result)))
	loadstring(Result,"Ultimatum")()
end
