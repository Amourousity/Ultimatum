do
	local Missing = {}
	for _,Names in pairs{
		"isfile",
		"getgenv",
		"readfile",
		"writefile",
		"getcustomasset/getsynasset"
	} do
		Names = Names:split("/")
		local Exists
		for _,FunctionName in pairs(Names) do
			if (getgenv and getgenv() or getfenv())[FunctionName] then
				(getgenv and getgenv() or getfenv())[Names[1]] = (getgenv and getgenv() or getfenv())[FunctionName]
				Exists = true
				break
			end
		end
		if not Exists then
			table.insert(Missing,Names[1])
		end
	end
	if 0 < #Missing then
		error(("Missing function%s '%s'"):format(1 < #Missing and "s" or "",table.concat(Missing,"', '")),0)
	end
end
for _,FileName in pairs{
	"Logo.png",
	"Source.lua",
	"Version.ver"
} do
	task.spawn(function()
		local Success,Result = pcall(game.HttpGet,game,("https://raw.githubusercontent.com/Amourousity/Ultimatum/main/%s"):format(FileName),true)
		if Success and (not isfile(("Ultimatum%s"):format(FileName)) or Result:gsub("%s","") ~= readfile(("Ultimatum%s"):format(FileName))) then
			writefile(("Ultimatum%s"):format(FileName),Result)
		elseif not Success and not isfile(("Ultimatum%s"):format(FileName)) then
			error(Result)
		end
	end)
end
loadstring(readfile("UltimatumSource.lua"),"Ultimatum")()
