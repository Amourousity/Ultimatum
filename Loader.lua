   --[[]    [|] [|]    [|||||||||] [|||||||||] [||]    [||]      [|] [|||||||||] [|]    [|] [||]    [||]
    [|]    [|] [|]        [|]         [|]     [||||] [||||]   [|] [|]   [|]     [|]    [|] [||||] [||||]
   [|]    [|] [|]        [|]         [|]     [|] [|||] [|]  [|]   [|]  [|]     [|]    [|] [|] [|||] [|]
  [|]    [|] [|]        [|]         [|]     [|]  [|]  [|] [|||||||||] [|]     [|]    [|] [|]  [|]  [|]
 [|]    [|] [|]        [|]         [|]     [|]       [|] [|]     [|] [|]     [|]    [|] [|]       [|]
[|]    [|] [|]        [|]         [|]     [|]       [|] [|]     [|] [|]     [|]    [|] [|]       [|]
[||||||]  [||||||||] [|]     [|||||||||] [|]       [|] [|]     [|] [|]      [||||||]  [|]       []]
local UltimatumStart,Ultimatum = os.clock()
local function Set(Source)
	Ultimatum = loadstring(Source or readfile"Source.Ultimatum","Ultimatum")
end
if isfile and isfile"Source.Ultimatum" then
	Set()
else
	local Success,Result = pcall(game.HttpGet,game,"https://raw.githubusercontent.com/Amourousity/Ultimatum/main/Source.lua",true)
	if Success then
		if isfile then
			writefile("Source.Ultimatum",Result)
			Set()
		else
			Set(Result)
		end
	end
end
local Environment = getfenv(Ultimatum)
Environment.UltimatumStart = UltimatumStart
setfenv(Ultimatum,Environment)()
