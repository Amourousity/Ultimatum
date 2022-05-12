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
pcall(Ultimatum)
local Type,Nil,LastCheck = typeof,{},os.clock()
if not game:IsLoaded() then
	game.Loaded:Wait()
end
local Services = setmetatable({},{
	__index = function(Services,ServiceName)
		assert(pcall(game.GetService,game,ServiceName),"Invalid ServiceName")
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
		Length = math.random(5,99),
		CharacterSet = {
			NumberRange.new(48,57),
			NumberRange.new(65,90),
			NumberRange.new(97,122)
		},
		Format = "\0%s"
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
	for _,InstanceData in pairs(Data) do
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
			BackgroundColor3 = Color3.fromRGB(80,80,100),
			Position = UDim2.new(0.5,0,.5,0),
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
			ImageTransparency = 1,
			Position = UDim2.new(0,10,0,10),
			Size = UDim2.new(0,80,0,80),
			Image = getcustomasset("UltimatumLogo.png",false)
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
			task.wait((Data.Time+Data.Delay)*(1+Data.RepeatCout))
		end
	end
end
local Connections = {
	Services.RunService.Heartbeat:Connect(function()
		if 60 < os.clock()-LastCheck then
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
					warn(Result)
				end
			end
			if Reload then
				print("Ultimatum: Detected update! Updating...")
				loadstring(readfile("UltimatumSource.lua"),"Ultimatum")()
			end
			LastCheck = os.clock()
		end
	end),
	Services.Players.LocalPlayer.OnTeleport:Connect(function(TeleportState)
		if TeleportState == Enum.TeleportState.Started then
			(queue_on_teleport or syn and syn.queue_on_teleport or warn)(readfile("UltimatumSource.lua"))
		end
	end)
}
getgenv().Ultimatum = function()
	for _,Connection in pairs(Connections) do
		pcall(Connection.Disconnect,Connection)
	end
	Gui:Destroy()
	getgenv().Ultimatum = nil
end
print("Ultimatum: Successfully loaded!")
Animate(Gui.MainCorner,{
	Properties = {
		CornerRadius = UDim.new(0,5)
	}
})
Animate(Gui.Logo,{
	Properties = {
		ImageTransparency = 0
	}
})
