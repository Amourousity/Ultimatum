--[[]    [|] [|]    [|||||||||] [|||||||||] [||]    [||]      [|] [|||||||||] [|]    [|] [||]    [||]
   [|]    [|] [|]        [|]         [|]     [||||] [||||]   [|] [|]   [|]     [|]    [|] [||||] [||||]
  [|]    [|] [|]        [|]         [|]     [|] [|||] [|]  [|]   [|]  [|]     [|]    [|] [|] [|||] [|]
 [|]    [|] [|]        [|]         [|]     [|]  [|]  [|] [|||||||||] [|]     [|]    [|] [|]  [|]  [|]
[|]    [|] [|]        [|]         [|]     [|]       [|] [|]     [|] [|]     [|]    [|] [|]       [|]
[|]  [|]  [|]        [|]         [|]     [|]       [|] [|]     [|] [|]      [|]  [|]  [|]       [|]
[||||]   [||||||||] [|]     [|||||||||] [|]       [|] [|]     [|] [|]       [||||]   [|]       []]

local function cache(path: string, url: string)
	local success, result = pcall(game.HttpGet, game, url)
	if success then
		writefile(path, result)
	end
end
local success, result =
	pcall(game.HttpGet, game, "https://raw.githubusercontent.com/Amourousity/Ultimatum/main/version.ver", true)
if success and (not isfile("ultimatumVersion.ver") or readfile("ultimatumVersion.ver") ~= result) then
	writefile("ultimatumVersion.ver", result)
	for _, dependancy: string in { "Ultimatum", "Utilitas", "Conversio" } do
		cache(`{dependancy}.lua`, `https://raw.githubusercontent.com/Amourousity/{dependancy}/main/source.lua`)
	end
	if not isfolder("ultimatumCommandSets") then
		makefolder("ultimatumCommandSets")
	end
	success, result =
		pcall(game.HttpGet, game, "https://api.github.com/repos/Amourousity/Ultimatum/contents/commandSets", true)
	if success then
		result = jsonDecode(result)
		for _, file in result do
			cache(`ultimatumCommandSets/{file.name}`, file.download_url)
		end
	end
end
loadstring(readfile("Ultimatum.lua"), "Ultimatum")()
