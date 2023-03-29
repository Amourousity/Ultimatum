  --[[]    [|] [|]    [|||||||||] [|||||||||] [||]    [||]      [|] [|||||||||] [|]    [|] [||]    [||]
   [|]    [|] [|]        [|]         [|]     [||||] [||||]   [|] [|]   [|]     [|]    [|] [||||] [||||]
  [|]    [|] [|]        [|]         [|]     [|] [|||] [|]  [|]   [|]  [|]     [|]    [|] [|] [|||] [|]
 [|]    [|] [|]        [|]         [|]     [|]  [|]  [|] [|||||||||] [|]     [|]    [|] [|]  [|]  [|]
[|]    [|] [|]        [|]         [|]     [|]       [|] [|]     [|] [|]     [|]    [|] [|]       [|]
[|]  [|]  [|]        [|]         [|]     [|]       [|] [|]     [|] [|]      [|]  [|]  [|]       [|]
[||||]   [||||||||] [|]     [|||||||||] [|]       [|] [|]     [|] [|]       [||||]   [|]       []]

local function cache(name: string)
	local success, result =
		pcall(game.HttpGet, game, `https://raw.githubusercontent.com/Amourousity/{name}/main/source.lua`)
	if success then
		writefile(`{name}.lua`, result)
	end
end
if isfile then
	local success, result =
		pcall(game.HttpGet, game, "https://raw.githubusercontent.com/Amourousity/Ultimatum/main/version.ver", true)
	if success and (not isfile("ultimatumVersion.ver") or readfile("ultimatumVersion.ver") ~= result) then
		writefile("ultimatumVersion.ver", result)
		for _, dependancy: string in { "Ultimatum", "Utilitas", "Conversio" } do
			cache(dependancy)
		end
	end
end
loadstring(readfile("Ultimatum.lua"), "Ultimatum")()
