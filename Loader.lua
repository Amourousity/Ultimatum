   --[[]    [|] [|]    [|||||||||] [|||||||||] [||]    [||]      [|] [|||||||||] [|]    [|] [||]    [||]
    [|]    [|] [|]        [|]         [|]     [||||] [||||]   [|] [|]   [|]     [|]    [|] [||||] [||||]
   [|]    [|] [|]        [|]         [|]     [|] [|||] [|]  [|]   [|]  [|]     [|]    [|] [|] [|||] [|]
  [|]    [|] [|]        [|]         [|]     [|]  [|]  [|] [|||||||||] [|]     [|]    [|] [|]  [|]  [|]
 [|]    [|] [|]        [|]         [|]     [|]       [|] [|]     [|] [|]     [|]    [|] [|]       [|]
[|]    [|] [|]        [|]         [|]     [|]       [|] [|]     [|] [|]     [|]    [|] [|]       [|]
[||||||]  [||||||||] [|]     [|||||||||] [|]       [|] [|]     [|] [|]      [||||||]  [|]       []]
if isfile and isfile"Source.Ultimatum" then
	loadstring(readfile"Source.Ultimatum","Ultimatum")()
	return
end
local Success,Result = pcall(game.HttpGet,game,"https://raw.githubusercontent.com/Amourousity/Ultimatum/main/Source.lua",true)
if Success then
	if isfile then
		writefile("Source.Ultimatum",Result)
		loadstring(readfile"Source.Ultimatum","Ultimatum")()
	else
		loadstring(Result,"Ultimatum")()
	end
end
