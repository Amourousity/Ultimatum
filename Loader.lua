   --[[]    [|] [|]    [|||||||||] [|||||||||] [||]    [||]      [|] [|||||||||] [|]    [|] [||]    [||]
    [|]    [|] [|]        [|]         [|]     [||||] [||||]   [|] [|]   [|]     [|]    [|] [||||] [||||]
   [|]    [|] [|]        [|]         [|]     [|] [|||] [|]  [|]   [|]  [|]     [|]    [|] [|] [|||] [|]
  [|]    [|] [|]        [|]         [|]     [|]  [|]  [|] [|||||||||] [|]     [|]    [|] [|]  [|]  [|]
 [|]    [|] [|]        [|]         [|]     [|]       [|] [|]     [|] [|]     [|]    [|] [|]       [|]
[|]    [|] [|]        [|]         [|]     [|]       [|] [|]     [|] [|]     [|]    [|] [|]       [|]
[||||||]  [||||||||] [|]     [|||||||||] [|]       [|] [|]     [|] [|]      [||||||]  [|]       []]
local Success,Result = pcall(game.HttpGet,game,'https://raw.githubusercontent.com/Amourousity/Ultimatum/main/Source',true)
if isfile then
	if Success and (not isfile'Source.Ultimatum' or Result ~= readfile'Source.Ultimatum') then
		writefile('Source.Ultimatum',Result)
	elseif not Success and not isfile'Source.Ultimatum' then
		error('Ultimatum |',Result)
	end
	loadstring(readfile'Source.Ultimatum','Ultimatum')
else
	assert(Success,("Ultimatum | %s"):format(tostring(Result)))
	loadstring(Result,"Ultimatum")()
end
