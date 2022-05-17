--[[ :::    ::: :::    ::::::::::: ::::::::::: ::::    ::::      ::: ::::::::::: :::    ::: ::::    ::::
    :+:    :+: :+:        :+:         :+:     +:+:+: :+:+:+   :+: :+:   :+:     :+:    :+: +:+:+: :+:+:+
   +:+    +:+ +:+        +:+         +:+     +:+ +:+:+ +:+  +:+   +:+  +:+     +:+    +:+ +:+ +:+:+ +:+
  +#+    +:+ +#+        +#+         +#+     +#+  +:+  +#+ +#++:++#++: +#+     +#+    +:+ +#+  +:+  +#+
 +#+    +#+ +#+        +#+         +#+     +#+       +#+ +#+     +#+ +#+     +#+    +#+ +#+       +#+
#+#    #+# #+#        #+#         #+#     #+#       #+# #+#     #+# #+#     #+#    #+# #+#       #+#
########  ########## ###     ########### ###       ### ###     ### ###      ########  ###       ###   ]]
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
	assert(#Missing < 1,("Ultimatum | Missing function%s '%s'"):format(1 < #Missing and "s" or "",table.concat(Missing,"', '")))
end
pcall(Ultimatum)
local Type,Nil = typeof,{}
if not game:IsLoaded() then
	game.Loaded:Wait()
end
local Services = setmetatable({},{
	__index = function(Services,ServiceName)
		assert(pcall(game.GetService,game,ServiceName),("Ultimatum | Invalid ServiceName (%s '%s')"):format(Type(ServiceName),tostring(ServiceName)))
		if not rawget(Services,ServiceName) or rawget(Services,ServiceName) ~= game:GetService(ServiceName) then
			rawset(Services,ServiceName,game:GetService(ServiceName))
		end
		return rawget(Services,ServiceName)
	end,
	__newindex = function()
	end,
	__metatable = "nil"
})
local function EscapeTable(Value,Escape)
	if not Escape and Value == Nil then
		return nil
	elseif Escape and Value == nil then
		return Nil
	end
	return Value
end
local Valid
Valid = {
	String = function(String,Substitute)
		return Type(String) == "string" and String or Type(Substitute) == "string" and Substitute or ""
	end,
	Instance = function(Instance_,ClassName)
		return Type(Instance_) == "Instance" and select(2,pcall(game.IsA,Instance_,Valid.String(ClassName,"Instance"))) == true and Instance_ or nil
	end,
	Number = function(Number,Substitute)
		return tonumber(Number) == tonumber(Number) and tonumber(Number) or tonumber(Substitute) == tonumber(Substitute) and tonumber(Substitute) or 0
	end,
	Table = function(Table,Substitute)
		Table = Type(Table) == "table" and Table or {}
		for Index,Value in pairs(Type(Substitute) == "table" and Substitute or {}) do
			Table[Index] = Type(Table[Index]) == Type(Value) and Table[Index] or Value
		end
		return Table
	end
}
table.freeze(Valid)
local Random = {String = function(Settings)
	Settings = Valid.Table(Settings,{
		CharacterSet = {
			NumberRange.new(48,57),
			NumberRange.new(65,90),
			NumberRange.new(97,122)
		},
		Format = "\0%s",
		Length = math.random(5,99)
	})
	return Settings.Format:format(("A"):rep(Settings.Length):gsub(".",function(Character)
		local Range = Settings.CharacterSet[math.random(1,#Settings.CharacterSet)]
		return string.char(math.random(Range.Min,Range.Max))
	end))
end,Bool = function(Chance)
	return math.random(1,1/Valid.Number(Chance,.5)) == 1
end}
table.freeze(Random)
local function NewInstance(ClassName,Parent,Properties)
	local NewInstance = select(2,pcall(Instance.new,ClassName))
	if Type(NewInstance) == "Instance" then
		Properties = Valid.Table(Properties,{
			Archivable = Random.Bool(),
			Name = Random.String()
		})
		for Property,Value in pairs(Properties) do
			pcall(function()
				NewInstance[Property] = EscapeTable(Value)
			end)
		end
		NewInstance.Parent = Type(Parent) == "Instance" and Parent or nil
		return NewInstance
	end
end
local function Create(Data)
	local Instances = {Destroy = function(Instances,Name)
		if Type(Name) == "string" then
			pcall(game.Destroy,Instances[Name])
			Instances[Name] = nil
		else
			for _,Instance_ in pairs(Instances) do
				pcall(game.Destroy,Instance_)
			end
			table.clear(Instances)
		end
	end}
	for _,InstanceData in pairs(Valid.Table(Data)) do
		Instances[InstanceData.Name] = NewInstance(InstanceData.ClassName,Type(InstanceData.Parent) == "string" and Instances[InstanceData.Parent] or InstanceData.Parent,InstanceData.Properties)
	end
	return Instances
end
local Gui = Create{
	{
		Name = "Holder",
		ClassName = "ScreenGui",
		Properties = {
			DisplayOrder = 0x7FFFFFFF,
			IgnoreGuiInset = true,
			OnTopOfCoreBlur = true,
			ResetOnSpawn = false,
			ZIndexBehavior = Enum.ZIndexBehavior.Global
		}
	},
	{
		Name = "Main",
		ClassName = "Frame",
		Parent = "Holder",
		Properties = {
			AnchorPoint = Vector2.new(.5,.5),
			BackgroundColor3 = Color3.fromHex("505064"),
			Position = UDim2.new(.5,0,0,-50),
			Size = UDim2.new(0,100,0,100)
		}
	},
	{
		Name = "MainCorner",
		ClassName = "UICorner",
		Parent = "Main",
		Properties = {
			CornerRadius = UDim.new(.5,0)
		}
	},
	{
		Name = "MainGradient",
		ClassName = "UIGradient",
		Parent = "Main",
		Properties = {
			Color = ColorSequence.new(Color3.new(1,1,1),Color3.new(.5,.5,.5)),
			Rotation = 90
		}
	},
	{
		Name = "Logo",
		ClassName = "ImageLabel",
		Parent = "Main",
		Properties = {
			BackgroundTransparency = 1,
			Image = getcustomasset("UltimatumLogo.png",false),
			ImageTransparency = 1,
			Position = UDim2.new(0,10,0,10),
			Size = UDim2.new(0,80,0,80)
		}
	}
}
if not is_sirhurt_closure and (syn and syn.protect_gui or protect_gui) then 
	(syn.protect_gui or protect_gui)(Gui.Holder)
	Gui.Holder.Parent = Services.CoreGui
else
	Gui.Holder.Parent = get_hidden_gui and get_hidden_gui() or gethui and gethui() or Services.CoreGui
end
local function Animate(Instance_,Data)
	if Valid.Instance(Instance_) then
		Data = Valid.Table(Data,{
			Time = 1,
			EasingStyle = Enum.EasingStyle.Quad,
			EasingDirection = Enum.EasingDirection.Out,
			RepeatCount = 0,
			Reverses = false,
			Delay = 0,
			Yields = false,
			Properties = {}
		})
		Services.TweenService:Create(Instance_,TweenInfo.new(Data.Time,Data.EasingStyle,Data.EasingDirection,Data.RepeatCount,Data.Reverses,Data.Delay),Data.Properties):Play()
		if Data.Yields then
			task.wait((Data.Time+Data.Delay)*(1+Data.RepeatCount))
		end
	end
end
local LastCheck = 0
local Connections = {
	Services.RunService.Heartbeat:Connect(function()
		if 60 < os.clock()-LastCheck then
			LastCheck = os.clock()
			local Reload
			for _,FileName in pairs{
				"Logo.png",
				"Source.lua",
				"Version.ver"
			} do
				local Success,Result = pcall(game.HttpGet,game,("https://raw.githubusercontent.com/Amourousity/Ultimatum/main/%s"):format(FileName),true)
				if Success and (not isfile(("Ultimatum%s"):format(FileName)) or Result:gsub("%s","") ~= readfile(("Ultimatum%s"):format(FileName)):gsub("%s","")) then
					writefile(("Ultimatum%s"):format(FileName),Result)
					Reload = true
				elseif not Success and not isfile(("Ultimatum%s"):format(FileName)) then
					local cprint = consoleprint or rconsoleprint;
					(cprint or string.len)("@@YELLOW@@");
					(cprint or warn)(("\nUltimatum | %s"):format(Result));
					(cprint or string.len)("@@WHITE@@");
				end
			end
			if Reload then
				loadstring(readfile("UltimatumSource.lua"),"Ultimatum")()
			end
		end
	end),
	Services.Players.LocalPlayer.OnTeleport:Connect(function(TeleportState)
		if TeleportState == Enum.TeleportState.Started then
			(queue_on_teleport or syn and syn.queue_on_teleport or string.len)(readfile("UltimatumSource.lua"))
		end
	end)
}
--[[local function GetHumanoid(Target)
	Target = ValidInstance(Target,"Model") or ValidInstance(Target,"Player") and (Target.Character or Target.CharacterAdded:Wait())
	if Target then
		return Target:FindFirstChildOfClass("Humanoid")
	end
end
local Commands
Commands = {
	["SpoofWalkSpeed/SpoofWS/HookWalkSpeed/HookWS"] = function()
		local Humanoid = Owner.Character.Humanoid
		local FakeWalkSpeed = Humanoid.WalkSpeed
		local OldIndex,OldNewIndex
		OldIndex = hookmetamethod(game,"__index",function(...)
			if not checkcaller() and ... == Humanoid and select(2,...) == "WalkSpeed" then
				return FakeWalkSpeed
			end
			return OldIndex(...)
		end)
		Humanoid.WalkSpeed = 100
		OldNewIndex = hookmetamethod(game,"__newindex",function(...)
			if not checkcaller() and ... == Humanoid and select(2,...) == "WalkSpeed" then
				FakeWalkSpeed = tonumber(select(3,...)) or 0
				return
			end
			return OldNewIndex(...)
		end)
	end
}]]
--[[
   # #### 
  ##     #
   #  ### 
   # #
   # #####
]]
getgenv().Ultimatum = function()
	for _,Connection in pairs(Connections) do
		pcall(Connection.Disconnect,Connection)
	end
	Gui:Destroy()
	getgenv().Ultimatum = nil
end
print("\n     :::    ::: :::    ::::::::::: ::::::::::: ::::    ::::      ::: ::::::::::: :::    ::: ::::    ::::\n    :+:    :+: :+:        :+:         :+:     +:+:+: :+:+:+   :+: :+:   :+:     :+:    :+: +:+:+: :+:+:+\n   +:+    +:+ +:+        +:+         +:+     +:+ +:+:+ +:+  +:+   +:+  +:+     +:+    +:+ +:+ +:+:+ +:+\n  +#+    +:+ +#+        +#+         +#+     +#+  +:+  +#+ +#++:++#++: +#+     +#+    +:+ +#+  +:+  +#+\n +#+    +#+ +#+        +#+         +#+     +#+       +#+ +#+     +#+ +#+     +#+    +#+ +#+       +#+\n#+#    #+# #+#        #+#         #+#     #+#       #+# #+#     #+# #+#     #+#    #+# #+#       #+#\n########  ########## ###     ########### ###       ### ###     ### ###      ########  ###       ###\n")
Animate(Gui.Main,{
	EasingStyle = Enum.EasingStyle.Back,
	Properties = {
		Position = UDim2.new(.5,0,.5,0)
	},
	Time = .5
})
Animate(Gui.Logo,{
	Delay = .25,
	Properties = {
		ImageTransparency = 0
	},
	Time = .25
})
Animate(Gui.MainCorner,{
	Delay = .25,
	Properties = {
		CornerRadius = UDim.new(0,5)
	},
	Time = .25
})
