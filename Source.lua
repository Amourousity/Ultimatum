   --[[]    [|] [|]    [|||||||||] [|||||||||] [||]    [||]      [|] [|||||||||] [|]    [|] [||]    [||]
    [|]    [|] [|]        [|]         [|]     [||||] [||||]   [|] [|]   [|]     [|]    [|] [||||] [||||]
   [|]    [|] [|]        [|]         [|]     [|] [|||] [|]  [|]   [|]  [|]     [|]    [|] [|] [|||] [|]
  [|]    [|] [|]        [|]         [|]     [|]  [|]  [|] [|||||||||] [|]     [|]    [|] [|]  [|]  [|]
 [|]    [|] [|]        [|]         [|]     [|]       [|] [|]     [|] [|]     [|]    [|] [|]       [|]
[|]    [|] [|]        [|]         [|]     [|]       [|] [|]     [|] [|]     [|]    [|] [|]       [|]
[||||||]  [||||||||] [|]     [|||||||||] [|]       [|] [|]     [|] [|]      [||||||]  [|]       []]
local ScriptEnvironment = getfenv()
for _,Table in pairs{
	[3] = "http",
	[4] = "crypt",
	[5] = {
		"cache",
		"cache_%s"
	},
	[6] = {
		"base64",
		"base64%s"
	},
	[7] = {
		"custom",
		"custom_%s"
	},
	[2] = "\x73\x79\x6E",
	[1] = "\x66\x6C\x75\x78\x75\x73"
} do
	local LibraryName,Interpret = unpack(type(Table) == "table" and Table or {Table})
	for FunctionName,Function in pairs(ScriptEnvironment[LibraryName] or {}) do
		ScriptEnvironment[(Interpret or "%s"):format(FunctionName)] = Function
	end
end
for FunctionName,Function in pairs(debug) do
	if not table.find({
		"info",
		"traceback",
		"profileend",
		"profilebegin",
		"setmemorycategory",
		"resetmemorycategory"
	},FunctionName) then
		ScriptEnvironment[ScriptEnvironment[FunctionName] and ("debug_%s"):format(FunctionName) or FunctionName] = Function
	end
end
local GlobalEnvironment = getgenv and getgenv() or shared
local Nil,Delta,LastFrame = {},10,os.clock()
local Services = setmetatable({},{
	__index = function(Services,ServiceName)
		(GlobalEnvironment.UltimatumDebug and assert or function() end)(pcall(game.GetService,game,ServiceName),("Ultimatum | Invalid ServiceName (%s '%s')"):format(typeof(ServiceName),tostring(ServiceName)))
		if not rawget(Services,ServiceName) or rawget(Services,ServiceName) ~= game:GetService(ServiceName) then
			rawset(Services,ServiceName,game:GetService(ServiceName))
		end
		return rawget(Services,ServiceName)
	end,
	__newindex = function() end,
	__metatable = "nil"
})
do
	local function CheckCompatibility(FunctionNames)
		FunctionNames = FunctionNames:split()
		local Function
		for _,FunctionName in pairs(FunctionNames) do
			Function = ScriptEnvironment[FunctionName]
			if Function then
				for _,FunctionName_ in pairs(FunctionNames) do
					ScriptEnvironment[FunctionName_] = Function
				end
				break
			end
		end
		return Function
	end
	for _,FunctionNames in pairs{
		"getsenv,getmenv",
		"getupval,getupvalue",
		"setupvalue,setupval",
		"getconst,getconstant",
		"getgc,get_gc_objects",
		"setconstant,setconst",
		"getupvals,getupvalues",
		"getconsts,getconstants",
		"isreadonly,is_readonly",
		"consoleclear,rconsoleclear",
		"consoleinput,rconsoleinput",
		"isrbxactive,iswindowactive",
		"setclipboard,writeclipboard",
		"dumpstring,getscriptbytecode",
		"hookfunction,detour_function",
		"getconnections,get_signal_cons",
		"getrawmetatable,debug_getmetatable",
		"getcallingscript,get_calling_script",
		"getcustomasset,get\x73\x79\x6Easset",
		"getloadedmodules,get_loaded_modules",
		"getscriptclosure,get_script_function",
		"getnamecallmethod,get_namecall_method",
		"consoleprint,writeconsole,rconsoleprint",
		"consolecreate,createconsole,rconsolecreate",
		"closeconsole,consoledestroy,rconsoledestroy",
		"rconsolename,consolesettitle,rconsolesettitle",
		"getidentity,getthreadcontext,getthreadidentity,get_thread_identity",
		"setidentity,setthreadcontext,setthreadidentity,set_thread_identity",
		"checkclosure,is\x74\x65\x6D\x70\x6C\x65closure,is\x73\x65\x6E\x74\x69\x6E\x65\x6Cclosure,is\x65\x6C\x65\99\x74\x72\x6F\x6Efunction,is_\x73\x79\x6E\97\x70\x73\x65_function,is_\x70\x72\x6F\x74\x6F\x73\x6D\97\x73\x68\x65\x72_closure"
	} do
		CheckCompatibility(FunctionNames)
	end
	--- @diagnostic disable undefined-global
	for FunctionNames,Replacement in pairs{
		setreadonly = (make_writeable or makewriteable) and function(Table,ReadOnly)
			(ReadOnly and (make_readonly or makereadonly) or (make_writeable or makewriteable))(Table)
		end or 0,
		hootmetamethod = hookfunction and getrawmetatable and function(Object,Method,Hook)
			return hookfunction(getrawmetatable(Object)[Method],Hook)
		end or 0,
		setparentinternal = protect_gui and function(Object,Parent)
			protect_gui(Object)
			Object.Parent = Parent
		end or 0,
		["gethui,get_hidden_gui"] = protect_gui and (function()
			local HiddenUI = Instance.new"Folder"
			protect_gui(HiddenUI)
			HiddenUI.Parent = Services.CoreGui
			return function()
				return HiddenUI
			end
		end)() or function()
			return Services.CoreGui
		end,
		["islclosure,is_l_closure"] = (iscclosure or is_c_closure) and function(Closure)
			return not (iscclosure or is_c_closure)(Closure)
		end or 0
	} do
		local Function = CheckCompatibility(FunctionNames)
		if not Function and type(Replacement) == "function" then
			for _,FunctionName in pairs(FunctionNames:split()) do
				ScriptEnvironment[FunctionName] = Replacement
			end
		end
	end
	--- @diagnostic enable undefined-global
end
if not GlobalEnvironment.UltimatumLoaded then
	print((("!!_5#_4#_#_4#9_#9_#2_4#2_6#_#9_#_4#_#2_4#2!_4#_4#_#_8#_9#_5#4_#4_3#_#_3#_5#_4#_#4_#4!_3#_4#_#_8#_9#_5#_#3_#_2#_3#_2#_5#_4#_#_#3_#!_2#_4#_#_8#_9#_5#_2#_2#_#9_#_5#_4#_#_2#_2#!_#_4#_#_8#_9#_5#_7#_#_5#_#_5#_4#_#_7#!#_4#_#_8#_9#_5#_7#_#_5#_#_5#_4#_#_7#!#6_2#8_#_5#9_#_7#_#_5#_#_6#6_2#_7#!"):gsub("%p%d?",function(Input)
		for Character,Format in pairs{
			["!"] = "\n",
			_ = (" "):rep(1 < #Input and Input:sub(2,2) or 1),
			["#"] = ("[%s]"):format(("|"):rep(1 < #Input and Input:sub(2,2) or 1))
		} do
			if Input:sub(1,1) == Character then
				return Format
			end
		end
	end)))
end
pcall(GlobalEnvironment.Ultimatum)
local function NilConvert(Value)
	if Value == nil then
		return Nil
	elseif Value == Nil then
		return nil
	end
	return Value
end
local Valid
Valid = {
	Table = function(Table,Substitute)
		Table = type(Table) == "table" and Table or {}
		for Index,Value in pairs(type(Substitute) == "table" and Substitute or {}) do
			Table[Index] = typeof(Table[Index]) == typeof(Value) and Table[Index] or Value
		end
		return Table
	end,
	Number = function(Number,Substitute)
		return tonumber(Number) == tonumber(Number) and tonumber(Number) or tonumber(Substitute) == tonumber(Substitute) and tonumber(Substitute) or 0
	end,
	String = function(String,Substitute)
		return type(String) == "string" and String or type(Substitute) == "string" and Substitute or ""
	end,
	Instance = function(Instance_,ClassName)
		return typeof(Instance_) == "Instance" and select(2,pcall(game.IsA,Instance_,Valid.String(ClassName,"Instance"))) == true and Instance_ or nil
	end
}
table.freeze(Valid)
local Randomized = {
	String = function(Settings)
		Settings = Valid.Table(Settings,{
			Format = "\0%s",
			Length = math.random(5,99),
			CharacterSet = {
				NumberRange.new(48,57),
				NumberRange.new(65,90),
				NumberRange.new(97,122)
			}
		})
		local AvailableCharacters = {}
		for _,Set in pairs(Settings.CharacterSet) do
			for Character = Set.Min,Set.Max do
				table.insert(AvailableCharacters,string.char(Character))
			end
		end
		return Settings.Format:format(("A"):rep(Settings.Length):gsub(".",function()
			return AvailableCharacters[math.random(1,#AvailableCharacters)]
		end))
	end,
	Bool = function(Chance)
		return math.random(1,1/Valid.Number(Chance,.5)) == 1
	end
}
table.freeze(Randomized)
local function NewInstance(ClassName,Parent,Properties)
	local NewInstance_ = select(2,pcall(Instance.new,ClassName))
	if typeof(NewInstance_) == "Instance" then
		Properties = Valid.Table(Properties,{
			Name = Randomized.String(),
			Archivable = Randomized.Bool()
		})
		for Property,Value in pairs(Properties) do
			pcall(function()
				NewInstance_[Property] = NilConvert(Value)
			end)
		end
		NewInstance_.Parent = typeof(Parent) == "Instance" and Parent or nil
		return NewInstance_
	end
end
local Destroy
do
	local DestroyInstance = game.Destroy
	Destroy = function(Object)
		for Type,Function in pairs{
			Instance = function()
				pcall(DestroyInstance,Object)
			end
		} do
			if typeof(Object) == Type then
				Function()
			end
		end
	end
end
Destroy()
local function Create(Data)
	local Instances = {
		Destroy = function(Instances,Name)
			if type(Name) == "string" then
				pcall(game.Destroy,Instances[Name])
				Instances[Name] = nil
			else
				for _,Instance_ in pairs(Instances) do
					pcall(game.Destroy,Instance_)
				end
				table.clear(Instances)
			end
		end
	}
	for _,InstanceData in pairs(Valid.Table(Data)) do
		Instances[InstanceData.Name] = NewInstance(InstanceData.ClassName,type(InstanceData.Parent) == "string" and Instances[InstanceData.Parent] or InstanceData.Parent,InstanceData.Properties)
	end
	return Instances
end
local OwnerSettings
do
	local Success,Output = pcall(Services.HttpService.JSONDecode,Services.HttpService,isfile and isfile"Settings.Ultimatum" and readfile"Settings.Ultimatum" or "[]")
	local Settings = Valid.Table(Success and Output or {},{
		Scale = 1,
		Blur = true,
		StayOpen = false,
		AutoUpdate = true,
		LoadOnRejoin = true,
		FancyDragging = true,
		PlayIntro = "Always",
		Notifications = "All",
		EdgeDetect = "Gui & Mouse"
	})
	OwnerSettings = setmetatable({},{
		__index = function(_,Index)
			return Settings[Index]
		end,
		__newindex = function(_,Index,Value)
			Settings[Index] = Value
			if writefile then
				writefile("Settings.Ultimatum",Services.HttpService:JSONEncode(Settings))
			end
		end,
		__metatable = "nil"
	})
end
OwnerSettings._ = nil
if Services.CoreGui:FindFirstChild"RobloxLoadingGui" and Services.CoreGui.RobloxLoadingGui:FindFirstChild"BlackFrame" then
	local LoadStart,Connection = os.clock()
	Connection = Services.CoreGui.RobloxLoadingGui.BlackFrame:GetPropertyChangedSignal"BackgroundTransparency":Connect(function()
		Connection:Disconnect()
		LoadStart = 0
	end)
	repeat
		task.wait()
	until 3 < os.clock()-LoadStart
end
local Gui = Create{
	{
		Name = "Holder",
		Parent = gethui(),
		ClassName = "ScreenGui",
		Properties = {
			ResetOnSpawn = false,
			IgnoreGuiInset = true,
			OnTopOfCoreBlur = true,
			DisplayOrder = 0x7FFFFFFF,
			ZIndexBehavior = Enum.ZIndexBehavior.Global
		}
	},
	{
		Name = "Main",
		Parent = "Holder",
		ClassName = "Frame",
		Properties = {
			BackgroundTransparency = 1,
			Size = UDim2.new(.25,0,.25,0),
			Position = UDim2.new(.5,0,.4,0),
			AnchorPoint = Vector2.new(.5,.5),
			BackgroundColor3 = Color3.fromHex"505064"
		}
	},
	{
		Name = "MainCorner",
		Parent = "Main",
		ClassName = "UICorner",
		Properties = {
			CornerRadius = UDim.new(.5,0)
		}
	},
	{
		Name = "MainGradient",
		Parent = "Main",
		ClassName = "UIGradient",
		Properties = {
			Rotation = 90,
			Color = ColorSequence.new(Color3.new(1,1,1),Color3.new(.5,.5,.5))
		}
	},
	{
		Name = "MainAspectRatioConstraint",
		Parent = "Main",
		ClassName = "UIAspectRatioConstraint",
		Properties = {
			DominantAxis = Enum.DominantAxis.Height
		}
	},
	{
		Name = "Logo",
		Parent = "Main",
		ClassName = "ImageLabel",
		Properties = {
			Rotation = 90,
			ImageTransparency = 1,
			BackgroundTransparency = 1,
			Size = UDim2.new(.8,0,.8,0),
			Position = UDim2.new(.1,0,.1,0),
			Image = "rbxassetid://9666094136"
		}
	},
	{
		Name = "CommandBarBackground",
		Parent = "Main",
		ClassName = "Frame",
		Properties = {
			Visible = false,
			ClipsDescendants = true,
			AnchorPoint = Vector2.xAxis,
			BackgroundColor3 = Color3.fromHex"191932",
			Size = UDim2.new(1,-38.5*OwnerSettings.Scale,.8,0),
			Position = UDim2.new(1,-3.5*OwnerSettings.Scale,.1,0)
		}
	},
	{
		Name = "CommandBar",
		Parent = "CommandBarBackground",
		ClassName = "TextBox",
		Properties = {
			Text = "",
			RichText = true,
			Font = Enum.Font.Arial,
			ClearTextOnFocus = false,
			BackgroundTransparency = 1,
			Position = UDim2.new(0,10,0,0),
			TextColor3 = Color3.new(1,1,1),
			TextSize = 13*OwnerSettings.Scale,
			PlaceholderText = "Enter a command...",
			TextXAlignment = Enum.TextXAlignment.Left,
			PlaceholderColor3 = Color3.fromHex"A0A0A0",
			Size = UDim2.new(1,-10*OwnerSettings.Scale,1,0)
		}
	},
	{
		Name = "CommandBarCorner",
		Parent = "CommandBarBackground",
		ClassName = "UICorner",
		Properties = {
			CornerRadius = UDim.new(0,5)
		}
	}
}
local function Animate(Instance_,Data)
	if Valid.Instance(Instance_) then
		Data = Valid.Table(Data,{
			Time = 1,
			Delay = 0,
			Yields = false,
			Properties = {},
			RepeatCount = 0,
			Reverses = false,
			EasingStyle = Enum.EasingStyle.Quad,
			EasingDirection = Enum.EasingDirection.Out
		})
		Services.TweenService:Create(Instance_,TweenInfo.new(Data.Time,Data.EasingStyle,Data.EasingDirection,Data.RepeatCount,Data.Reverses,Data.Delay),Data.Properties):Play()
		if Data.Yields then
			task.wait((Data.Time+Data.Delay)*(1+Data.RepeatCount))
		end
	end
end
local function Notify(Settings)
	Settings = Valid.Table(Settings,{
		Buttons = {},
		Duration = 5,
		Urgent = false,
		Yields = false,
		CalculateDuration = false,
		Text = "<b>Ultimatum</b>\n(no text)"
	})
	if OwnerSettings.Notifications == "Off" or OwnerSettings.Notifications == "Urgent" and not Settings.Urgent then
		return
	end
	local Notification = Create{
		{
			Name = "Main",
			Parent = Gui.Holder,
			ClassName = "Frame",
			Properties = {
				ClipsDescendants = true,
				AnchorPoint = Vector2.one,
				BackgroundTransparency = 1,
				Position = UDim2.new(1,-10,1,0),
				BackgroundColor3 = Color3.fromHex"505064"
			}
		},
		{
			Name = "MainCorner",
			Parent = "Main",
			ClassName = "UICorner",
			Properties = {
				CornerRadius = UDim.new(0,5)
			}
		},
		{
			Name = "MainGradient",
			Parent = "Main",
			ClassName = "UIGradient",
			Properties = {
				Rotation = 90,
				Color = ColorSequence.new(Color3.new(1,1,1),Color3.new(.5,.5,.5))
			}
		},
			{
			Name = "Content",
			Parent = "Main",
			ClassName = "TextLabel",
			Properties = {
				TextSize = 13,
				RichText = true,
				TextWrapped = true,
				Text = Settings.Text,
				TextTransparency = 1,
				Font = Enum.Font.Arial,
				BackgroundTransparency = 1,
				Size = UDim2.new(1,-20,1,-20),
				TextColor3 = Color3.new(1,1,1),
				Position = UDim2.new(0,10,0,10),
				TextXAlignment = Enum.TextXAlignment.Left
			}
		}
	}
	if Settings.CalculateDuration then
		local Length = 0
		for _ in utf8.graphemes(Notification.Content.ContentText) do
			Length += 1
		end
		Settings.Duration += Length*.06
	end
	Settings.Duration += .25
	local Size = Services.TextService:GetTextSize(Notification.Content.ContentText,13,Enum.Font.Arial,Vector2.new(workspace.CurrentCamera.ViewportSize.X/3,workspace.CurrentCamera.ViewportSize.Y-40))
	Notification.Main.Size = UDim2.new(0,Size.X,0,Size.Y+20)
	repeat
		Notification.Main.Size -= UDim2.new(0,1,0,0)
	until not Notification.Content.TextFits
	Notification.Main.Size += UDim2.new(0,1,0,0)
	Animate(Notification.Main,{
		Time = .25,
		Properties = {
			Position = UDim2.new(1,-10,1,-10),
			BackgroundTransparency = 0
		}
	})
	Animate(Notification.Content,{
		Time = .25,
		Properties = {
			TextTransparency = 0
		},
		EasingStyle = Enum.EasingStyle.Linear
	})
	task.spawn(function()
		task.wait(Settings.Duration)
		Animate(Notification.Main,{
			Time = 1,
			Properties = {
				BackgroundTransparency = 1
			}
		})
		Animate(Notification.Content,{
			Time = 1,
			Properties = {
				TextTransparency = 1
			},
			EasingStyle = Enum.EasingStyle.Linear
		})
	end)
	if Settings.Yields then
		task.wait(Settings.Duration)
		Notification:Destroy()
	else
		task.delay(Settings.Duration,Notification.Destroy,Notification)
	end
end
local LastCheck,Focused,Debounce,LastLeft = 0,isrbxactive and isrbxactive() or true,true,0
local ExpandGui
do
	local LastPosition,Expanded
	ExpandGui = function(Expand,Ignore)
		if Expanded ~= Expand and not Debounce and (Ignore or not OwnerSettings.StayOpen) then
			Expanded = Expand
			LastPosition = Expand and Gui.Main.Position or LastPosition
			Animate(Gui.Main,{
				Time = Expand and .25 or .5,
				Properties = {
					Size = UDim2.new(0,math.floor((Expand and 350 or 35)*OwnerSettings.Scale),0,math.floor(35*OwnerSettings.Scale)),
					Position = Expand and workspace.CurrentCamera.ViewportSize.X/2 < Gui.Main.AbsolutePosition.X+Gui.Main.AbsoluteSize.X/2 and UDim2.new((Gui.Main.AbsolutePosition.X-(350*OwnerSettings.Scale-Gui.Main.AbsoluteSize.X))/workspace.CurrentCamera.ViewportSize.X,0,(Gui.Main.AbsolutePosition.Y+36)/workspace.CurrentCamera.ViewportSize.Y,0) or LastPosition
				}
			})
			Animate(Gui.CommandBarBackground,{
				Time = Expand and .25 or .45,
				Properties = {
					Visible = Expand
				}
			})
		end
	end
end
local Connections = {
	not GlobalEnvironment.UltimatumDebug and isfile and Services.RunService.Heartbeat:Connect(function()
		Delta,LastFrame = (os.clock()-LastFrame)*60,os.clock()
		if OwnerSettings.AutoUpdate and 60 < os.clock()-LastCheck then
			LastCheck = os.clock()
			local Success,Result = pcall(game.HttpGet,game,"https://raw.githubusercontent.com/Amourousity/Ultimatum/main/Source.lua",true)
			if Success and (not isfile"Source.Ultimatum" or Result ~= readfile"Source.Ultimatum") then
				writefile("Source.Ultimatum",Result)
				loadstring(Result,"Ultimatum")()
			elseif not Success and not isfile"Source.Ultimatum" then
				Notify{
					Urgent = true,
					CalculateDuration = true,
					Text = ("<b>Error</b>\n%s"):format(Result)
				}
			end
		end
	end) or Services.RunService.Heartbeat:Connect(function()
		Delta,LastFrame = (os.clock()-LastFrame)*60,os.clock()
	end),
	not GlobalEnvironment.UltimatumDebug and queue_on_teleport and isfile and Services.Players.LocalPlayer.OnTeleport:Connect(function(TeleportState)
		if OwnerSettings.LoadOnRejoin and TeleportState == Enum.TeleportState.Started then
			queue_on_teleport(isfile"Source.Ultimatum" and readfile"Source.Ultimatum" or "error('Source.Ultimatum missing from workspace folder',0)")
		end
	end),
	Services.UserInputService.WindowFocused:Connect(function()
		Focused = true
	end),
	Services.UserInputService.WindowFocusReleased:Connect(function()
		Focused = false
	end),
	Gui.Main.MouseEnter:Connect(function()
		LastLeft = os.clock()
		ExpandGui(true)
	end),
	Gui.Main.MouseLeave:Connect(function()
		LastLeft = os.clock()
		task.wait(1)
		if 1 < os.clock()-LastLeft then
			ExpandGui(false)
		end
	end),
	Gui.CommandBar.Focused:Connect(function()
		Debounce = true
	end),
	Gui.CommandBar.FocusLost:Connect(function()
		Debounce = false
		ExpandGui(false)
	end)
}
local function AddConnections(Connections_)
	for _,Connection in pairs(Valid.Table(Connections_)) do
		if typeof(Connection) == "RBXScriptConnection" and Connection.Connected then
			table.insert(Connections,Connection)
		end
	end
end
local function RemoveConnections(Connections_)
	for _,Connection in pairs(Valid.Table(Connections_)) do
		if typeof(Connection) == "RBXScriptConnection" then
			if Connection.Connected then
				Connection:Disconnect()
			end
			pcall(table.remove,Connections,table.find(Connections,Connection))
		end
	end
end
local function DeltaLerp(Start,Goal,Alpha)
	return type(Start) == "number" and type(Goal) == "number" and Goal+(Start-Goal)*math.clamp((1-Alpha)^Delta,0,1) or Goal:Lerp(Start,math.clamp((1-Alpha)^Delta,0,1))
end
local function EnableDrag(Frame,Expand)
	local DragConnection
	local FinalPosition = UDim2.new()
	local InputBegan,InputEnded,Removed = Frame.InputBegan:Connect(function(Input,Ignore)
		if not Ignore and not Debounce and Input.UserInputType == Enum.UserInputType.MouseButton1 then
			if Expand then
				ExpandGui(false)
			end
			Debounce = true
			DragConnection = Services.RunService.RenderStepped:Connect(function()
				local MousePosition = Services.UserInputService:GetMouseLocation()
				local ScreenSize,CardSize = workspace.CurrentCamera.ViewportSize,Frame.AbsoluteSize
				local XVelocity = MousePosition.X-(Frame.AbsolutePosition.X+CardSize.X/2)
				local NewPosition = OwnerSettings.EdgeDetect ~= "None" and Vector2.new(math.clamp(MousePosition.X,CardSize.X/2,ScreenSize.X-CardSize.X/2),math.clamp(MousePosition.Y,CardSize.Y/2,ScreenSize.Y-CardSize.Y/2)) or MousePosition
				if NewPosition ~= MousePosition then
					if OwnerSettings.EdgeDetect == "Gui & Mouse" and mousemoverel and Focused then
						mousemoverel(NewPosition.X-MousePosition.X,NewPosition.Y-MousePosition.Y)
					end
					MousePosition = NewPosition
				end
				FinalPosition = UDim2.new((MousePosition.X-CardSize.X/2)/ScreenSize.X,0,(MousePosition.Y-CardSize.Y/2)/ScreenSize.Y,0)
				Animate(Frame,{
					Time = OwnerSettings.FancyDragging and .1 or 0,
					Properties = {
						Position = FinalPosition
					}
				})
				Frame.Rotation = OwnerSettings.FancyDragging and (DeltaLerp(math.abs(Frame.Rotation) < .1 and 0 or Frame.Rotation,0,.5)+math.clamp(XVelocity/(.065*CardSize.X),-1500/CardSize.X,1500/CardSize.X)) or 0
			end)
			AddConnections{
				DragConnection
			}
		end
	end),Services.UserInputService.InputEnded:Connect(function(Input,Ignore)
		if DragConnection and Input.UserInputType == Enum.UserInputType.MouseButton1 then
			RemoveConnections{
				DragConnection
			}
			DragConnection = nil
			Animate(Frame,{
				Time = .5,
				Properties = {
					Rotation = 0,
					Position = FinalPosition
				},
				EasingDirection = Enum.EasingDirection.InOut
			})
			Debounce = false
			if Expand then
				ExpandGui(true)
			end
		end
	end)
	Removed = Frame.AncestryChanged:Connect(function()
		if not Frame:IsDescendantOf(gethui()) then
			RemoveConnections{
				Removed,
				InputBegan,
				InputEnded,
				DragConnection
			}
		end
	end)
	AddConnections{
		Removed,
		InputBegan,
		InputEnded
	}
end
local function CloneTable(Table)
	local NewTable = {}
	for Key,Value in pairs(Valid.Table(Table)) do
		NewTable[Key] = Value
	end
	return NewTable
end
--[[```lua
local function GetHumanoid(Target)
	Target = ValidInstance(Target,"Model") or ValidInstance(Target,"Player") and (Target.Character or Target.CharacterAdded:Wait())
	if Target then
		return Target:FindFirstChildOfClass"Humanoid"
	end
end
local Commands
Commands = {
	["SpoofWalkSpeed/SpoofWS/HookWalkSpeed/HookWS"] = function()
		local Humanoid = Owner.Character.Humanoid
		local FakeWalkSpeed = Humanoid.WalkSpeed
		local OldIndex,OldNewIndex
		OldIndex = hookmetamethod(game,"__index",newcclosure(function(...)
			if not checkcaller() and ... == Humanoid and select(2,...) == "WalkSpeed" then
				return FakeWalkSpeed
			end
			return OldIndex(...)
		end))
		Humanoid.WalkSpeed = 100
		OldNewIndex = hookmetamethod(game,"__newindex",newcclosure(function(...)
			if not checkcaller() and ... == Humanoid and select(2,...) == "WalkSpeed" then
				FakeWalkSpeed = tonumber(select(3,...)) or 0
				return
			end
			return OldNewIndex(...)
		end))
	end
}
------------------------------------------------------------------------------------------------------------------------------------------------
local Owner = game:GetService"Players".LocalPlayer
local Spoofed = {}
local Humanoid
local function Check(Character)
	local Humanoid_ = Character:FindFirstChildOfClass"Humanoid"
	while not Humanoid_ do
		Character.ChildAdded:Wait()
		Humanoid_ = Character:FindFirstChildOfClass"Humanoid"
	end
	Spoofed.WalkSpeed = Humanoid_.WalkSpeed
end
if Owner.Character then
	Check(Owner.Character)
end
Owner.CharacterAdded:Connect(Check)
local OldIndex
local function CheckProperties(Properties,Property)
	if type(Property) == "string" then
		for _,PropertyNames in pairs(Properties) do
			PropertyNames = PropertyNames:split()
			for _,PropertyName in pairs(PropertyNames) do
				if Property == PropertyName then
					return true,Spoofed[PropertyNames[1] ]
				end
			end
		end
	end
	return false
end
OldIndex = hookmetamethod(game,"__index",function(...)
	local Object,Property = ...
	if not checkcaller() and typeof(Object) == "Instance" then
		for Properties,Instance_ in pairs{
			[{
				"WalkSpeed,walkSpeed",
				"FloorMaterial",
				"MoveDirection"
			}] = Humanoid,
			[{
				"Velocity,AssemblyLinearVelocity",
				"RotVelocity,AssemblyAngularVelocity",
				"CFrame"
			}] = RootPart
		} do
			if Instance_ == Object then
				local Passed,Spoof = CheckProperties(Properties,Property)
				if Passed then
					return Spoof
				end
				break
			end
		end
	end
	return OldIndex(...)
end)
local OldNewIndex
OldNewIndex = hookmetamethod(game,"__newindex",function(...)
	if not checkcaller() and typeof((...)) == "Instance" then
		if Humanoid and ... == Humanoid and (select(2,...) == "WalkSpeed" or select(2,...) == "walkSpeed") then
			Spoofed.WalkSpeed = tonumber((select(3,...))) or 0
		end
	end
	return OldIndex(...)
end)
```]]
GlobalEnvironment.Ultimatum = function()
	RemoveConnections(CloneTable(Connections))
	GlobalEnvironment.Ultimatum = nil
	Gui:Destroy()
	--- @diagnostic disable-next-line undefined-global
	if protect_gui then
		pcall(game.Destroy,gethui())
	end
end
EnableDrag(Gui.Main,true)
task.defer(function()
	GlobalEnvironment.UltimatumLoaded = true
end)
if OwnerSettings.PlayIntro == "Always" or OwnerSettings.PlayIntro == "Once" and not GlobalEnvironment.UltimatumLoaded then
	if OwnerSettings.Blur then
		Services.RunService:SetRobloxGuiFocused(true)
		task.delay(1.5,Services.RunService.SetRobloxGuiFocused,Services.RunService,false)
	end
	Animate(Gui.Main,{
		Time = .5,
		Yields = true,
		Properties = {
			Position = UDim2.new(.5,0,.5,0),
			BackgroundTransparency = 0
		}
	})
	Animate(Gui.Logo,{
		Time = .5,
		Properties = {
			ImageTransparency = 0,
			Rotation = 0
		}
	})
	Animate(Gui.MainCorner,{
		Time = .5,
		Yields = true,
		Properties = {
			CornerRadius = UDim.new(0,5)
		}
	})
	task.wait(.5)
	Animate(Gui.Main,{
		Time = .5,
		Properties = {
			Rotation = 180,
			Size = UDim2.new()
		},
		EasingStyle = Enum.EasingStyle.Back,
		EasingDirection = Enum.EasingDirection.In
	})
	Animate(Gui.MainCorner,{
		Time = .5,
		Properties = {
			CornerRadius = UDim.new(.5,0)
		}
	})
	Animate(Gui.Logo,{
		Time = .5,
		Yields = true,
		Properties = {
			ImageTransparency = 1
		}
	})
end
for Name,Properties in pairs{
	Logo = {
		Rotation = 0,
		ImageTransparency = 0,
		Position = UDim2.new(0,3.5*OwnerSettings.Scale,.1,0)
	},
	Main = {
		Rotation = 0,
		AnchorPoint = Vector2.zero,
		BackgroundTransparency = 0,
		Size = UDim2.new(0,35*OwnerSettings.Scale,0,35*OwnerSettings.Scale),
		Position = UDim2.new(0,0,1,0),
	},
	MainCorner = {
		CornerRadius = UDim.new(0,5)
	},
	MainAspectRatioConstraint = {
		Parent = Gui.Logo
	}
} do
	if not Gui or not Gui[Name] then
		return
	end
	for Property,Value in pairs(Properties) do
		Gui[Name][Property] = Value
	end
end
Animate(Gui.Main,{
	Time = .5,
	Properties = {
		Position = UDim2.new(0,0,1,math.floor(-35*OwnerSettings.Scale))
	}
})
Debounce = false
if OwnerSettings.StayOpen then
	task.delay(.5,ExpandGui,true,true)
end
