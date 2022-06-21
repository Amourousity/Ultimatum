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
local Nil = {}
local Destroy
do
	local DestroyInstance = game.Destroy
	Destroy = function(Object)
		for Type,Function in pairs{
			Instance = function()
				pcall(DestroyInstance,Object)
			end,
			RBXScriptConnection = function()
				if Object.Connected then
					Object:Disconnect()
				end
			end,
			table = function()
				for Index,Value in pairs(Object) do
					Object[Index] = nil
					Destroy(Index)
					Destroy(Value)
				end
			end
		} do
			if typeof(Object) == Type then
				Function()
			end
		end
	end
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
			HiddenUI.Parent = cloneref and cloneref(game:GetService"CoreGui") or game:GetService"CoreGui"
			return function()
				return HiddenUI
			end
		end)() or function()
			return cloneref and cloneref(game:GetService"CoreGui") or game:GetService"CoreGui"
		end,
		["islclosure,is_l_closure"] = (iscclosure or is_c_closure) and function(Closure)
			return not (iscclosure or is_c_closure)(Closure)
		end or 0,
		cloneref = getreg and (function()
			local TestPart = Instance.new"Part"
			local InstanceList
			for _,InstanceTable in pairs(getreg()) do
				if type(InstanceTable) == "table" and #InstanceTable then
					if rawget(InstanceTable,"__mode") == "kvs" then
						for _,PartCheck in pairs(InstanceTable) do
							if PartCheck == TestPart then
								InstanceList = InstanceTable
								Destroy(TestPart)
								break
							end
						end
					end
				end
			end
			if InstanceList then
				return function(Object)
					for Index,Value in pairs(InstanceList) do
						if Value == Object then
							InstanceList[Index] = nil
							return Object
						end
					end
				end
			end
		end)() or 0,
		["setclipboard,writeclipboard,toclipboard,set_clipboard"] = Clipboard and Clipboard.set or 0
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
local Services = setmetatable({},{
	__index = function(Services,ServiceName)
		(GlobalEnvironment.UltimatumDebug and assert or function() end)(pcall(game.GetService,game,ServiceName),("Ultimatum | Invalid ServiceName (%s '%s')"):format(typeof(ServiceName),tostring(ServiceName)))
		if not rawget(Services,ServiceName) or rawget(Services,ServiceName) ~= game:GetService(ServiceName) then
			rawset(Services,ServiceName,game:GetService(ServiceName))
		end
		return cloneref and rawget(Services,ServiceName) and cloneref(rawget(Services,ServiceName)) or rawget(Services,ServiceName)
	end,
	__newindex = function() end,
	__metatable = "nil"
})
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
local Owner = Services.Players.LocalPlayer or Services.Players.PlayerAdded:Wait()
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
	end,
	Boolean = function(Boolean,Substitute)
		Boolean = tostring(Boolean)
		for Names,Value in pairs{
			true_yes_on_positive_1 = true,
			false_no_off_negative_0 = false
		} do
			for _,Name in pairs(Names:split"_") do
				if Boolean == Name then
					return Value
				end
			end
		end
		return Substitute
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
local function Create(Data)
	local Instances = {
		Destroy = function(Instances,Name)
			if type(Name) == "string" then
				Destroy(Instances[Name])
				Instances[Name] = nil
			else
				Destroy(Instances)
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
		CommandSeperator = "/",
		ArgumentSeperator = " ",
		Keybind = "LeftBracket",
		ExpressionSeperator = ",",
		EdgeDetect = "GuiAndMouse"
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
		Destroy(Connection)
		LoadStart = 0
	end)
	repeat
		task.wait()
	until 3 < os.clock()-LoadStart
end
local Gui = Create{
	{
		Name = "Holder",
		Parent = Services.CoreGui,
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
		Name = "MainListLayout",
		Parent = "Main",
		ClassName = "UIListLayout",
		Properties = {
			SortOrder = Enum.SortOrder.LayoutOrder
		}
	},
	{
		Name = "CommandBarSection",
		Parent = "Main",
		ClassName = "Frame",
		Properties = {
			LayoutOrder = 1,
			BackgroundTransparency = 1,
			Size = UDim2.new(1,0,1,0)
		}
	},
	{
		Name = "CommandBarListLayout",
		Parent = "CommandBarSection",
		ClassName = "UIListLayout",
		Properties = {
			Padding = UDim.new(0,4),
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Horizontal,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			HorizontalAlignment = Enum.HorizontalAlignment.Center
		}
	},
	{
		Name = "Logo",
		Parent = "CommandBarSection",
		ClassName = "ImageLabel",
		Properties = {
			Rotation = 90,
			ImageTransparency = 1,
			BackgroundTransparency = 1,
			Size = UDim2.new(.8,0,.8,0),
			Image = "rbxassetid://9666094136"
		}
	},
	{
		Name = "CommandBarBackground",
		Parent = "CommandBarSection",
		ClassName = "Frame",
		Properties = {
			LayoutOrder = 1,
			Visible = false,
			ClipsDescendants = true,
			AnchorPoint = Vector2.xAxis,
			BackgroundColor3 = Color3.fromHex"191932",
			Size = UDim2.new(1,-44,.8,0),
		}
	},
	{
		Name = "CommandBar",
		Parent = "CommandBarBackground",
		ClassName = "TextBox",
		Properties = {
			Text = "",
			Font = Enum.Font.Arial,
			ClearTextOnFocus = false,
			BackgroundTransparency = 1,
			Position = UDim2.new(0,10,0,0),
			TextColor3 = Color3.new(1,1,1),
			TextXAlignment = Enum.TextXAlignment.Left,
			PlaceholderColor3 = Color3.fromHex"A0A0A0",
			TextSize = 14,
			Size = UDim2.new(1,-10,1,0),
			PlaceholderText = ("Enter a command (Keybind:\u{200A}%s\u{200A})"):format(Services.UserInputService:GetStringForKeyCode(Enum.KeyCode[OwnerSettings.Keybind]))
		}
	},
	{
		Name = "CommandBarCorner",
		Parent = "CommandBarBackground",
		ClassName = "UICorner",
		Properties = {
			CornerRadius = UDim.new(0,4)
		}
	},
	{
		Name = "SuggestionsSection",
		Parent = "Main",
		ClassName = "Frame",
		Properties = {
			BackgroundTransparency = 1,
		}
	},
	{
		Name = "SuggestionsScroll",
		Parent = "SuggestionsSection",
		ClassName = "ScrollingFrame",
		Properties = {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Position = UDim2.new(0,4,0,4),
			Size = UDim2.new(1,-8,1,-8),
			ScrollBarThickness = 0,
		}
	},
	{
		Name = "SuggestionsGridLayout",
		Parent = "SuggestionsScroll",
		ClassName = "UIGridLayout",
		Properties = {
			CellPadding = UDim2.new(),
			CellSize = UDim2.new(1,0,0,20)
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
				CornerRadius = UDim.new(0,4)
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
		task.wait(Settings.Duration+1)
		Notification:Destroy()
	else
		task.delay(Settings.Duration+1,Notification.Destroy,Notification)
	end
end
local function CheckAxis(Axis)
	return workspace.CurrentCamera.ViewportSize[Axis]/2 < Gui.Logo.AbsolutePosition[Axis]+Gui.Logo.AbsoluteSize[Axis]/2
end
local LastCheck,Focused,Debounce,LastLeft = 0,isrbxactive and isrbxactive() or true,true,0
local ExpandGui
do
	local Expanded
	ExpandGui = function(Expand,Ignore)
		if Expanded ~= Expand and not Debounce and (Ignore or not OwnerSettings.StayOpen) then
			Expanded = Expand
			if Expand then
				Gui.CommandBarBackground.LayoutOrder = CheckAxis"X" and -1 or 1
				Gui.CommandBarSection.LayoutOrder = CheckAxis"Y" and 1 or -1
			end
			local Size = UDim2.new(0,Expand and 400 or 40,0,40)
			Animate(Gui.Main,{
				Time = Expand and .25 or .5,
				Properties = {
					Size = Size,
					Position = CheckAxis"X" and Gui.Main.Position+UDim2.new(0,Gui.Main.AbsoluteSize.X-math.round(Size.X.Offset*OwnerSettings.Scale),0,0) or Gui.Main.Position
				}
			})
			Animate(Gui.CommandBarBackground,{
				Time = Expand and .25 or .48,
				Properties = {
					Visible = Expand
				}
			})
		end
	end
end
--- @diagnostic disable undefined-global
local Commands = { -- Currently only safe commands are included until I write a system for metamethod hooks
	Exit_close_leave_shutdown = {
		Function = function()
			game:Shutdown()
		end,
		Description = "Closes the current Roblox window/proccess"
	},
	CopyJoinScript_copyjoincode_copyjoin_copyjcode_copyjscript_copyj_cjoin_copyjs_cj_cjs_cjc = {
		Function = function()
			local JoinScript = ('javascript:Roblox.GameLauncher.joinGameInstance(%.0f,"%s")'):format(game.PlaceId,game.JobId)
			if setclipboard then
				setclipboard(JoinScript)
				Notify{
					CalculateDuration = true,
					Text = "<b>Successfully Copied</b>\nPaste the copied script into your brower's URL bar and press Enter"
				}
			else
				Notify{
					CalculateDuration = true,
					Text = ("<b>Copy to Clipboard</b>\n%s\nPaste the above script into your brower's URL bar and press Enter"):format(JoinScript)
				}
			end
		end,
		Description = setclipboard and "Copies JavaScript to your clipboard used to join the same server" or "Notifies JavaScript to be copied to your clipboard used to join the same server"
	},
	DisableRendering_disablerender_drendering_derender_drender_dr_norendering_norender = {
		Function = function(Disabled)
			Services.RunService:Set3dRenderingEnabled(not Disabled)
		end,
		Arguments = {
			{
				Name = "Disabled",
				Type = "Boolean",
				Substitute = true,
				Required = false
			}
		},
		Description = "Disables 3D rendering (everything except for GUIs are invisible), boosting FPS. Usually used with auto-farms to improve their efficiency"
	},
	Rejoin_rejoinserver_rejoingame_rej_rj = {
		Function = function()
			pcall(Services.TeleportService.TeleportToPlaceInstance,Services.TeleportService,game.PlaceId,game.JobId)
			task.delay(3,pcall,Services.TeleportService.Teleport,Services.TeleportService,game.PlaceId)
		end,
		Description = "Rejoins the current server you're in"
	},
	CloseRobloxMessage_closerobloxerror_closemessage_closeerror_cmessage_cerror_closermessage_closererror_crobloxmessage_crobloxerror_clearrobloxmessage_clearrobloxerror_clearrerror_clearrmessage_clearmessage_clearerror_cm_crm_cre_ce_closekickmessage_clearkickmessage_clearkick_closekick_ckm_ck_closekickerror_clearkickerror_cke = {
		Function = function()
			Services.GuiService:ClearError()
		end,
		Description = "Closes any messages/errors (the grey containers with the blurred background) displayed by Roblox"
	},
}
--- @diagnostic enable undefined-global
local function UpdateSuggestions()
	if Services.UserInputService:GetFocusedTextBox() == Gui.CommandBar then
		local Command = Gui.CommandBar.Text:split(OwnerSettings.CommandSeperator)
		Command = ((Command[#Command] or ""):split(OwnerSettings.ArgumentSeperator)[1] or ""):lower()
		Gui.SuggestionsScroll.CanvasSize = UDim2.new()
		for _,TextLabel in pairs(Gui.SuggestionsScroll:GetChildren()) do
			if TextLabel:IsA"TextLabel" then
				Destroy(TextLabel)
			end
		end
		local CommandDisplays = {}
		for CommandNames,CommandInfo in pairs(Commands) do
			CommandNames = CommandNames:split"_"
			for _,CommandName in pairs(CommandNames) do
				if CommandName:lower():find((Command:gsub("%p",function(Punctuation)
					return ("%%%s"):format(Punctuation)
				end))) then
					table.insert(CommandDisplays,("<font color = '#FFFFFF'>%s</font><i>%s</i>"):format(CommandNames[1],CommandInfo.Arguments and (function()
						local Arguments = {}
						for _,ArgumentInfo in pairs(CommandInfo.Arguments) do
							table.insert(Arguments,(ArgumentInfo.Required and "<font color = '#FFFFFF'>%s:%s</font>" or "%s:%s"):format(ArgumentInfo.Name,ArgumentInfo.Type))
						end
						return ("%s%s"):format(OwnerSettings.ArgumentSeperator,table.concat(Arguments,OwnerSettings.ArgumentSeperator))
					end)() or ""))
					break
				end
			end
		end
		table.sort(CommandDisplays,function(Value1,Value2)
			if #Value1 < #Value2 then
				return true
			elseif #Value2 < #Value1 then
				return false
			end
			Value1,Value2 = table.pack(Value1:byte(1,-1)),table.pack(Value2:byte(1,-1))
			for Integer = 1,math.max(#Value1,#Value2) do
				if (Value1[Integer] or -1) < (Value2[Integer] or -1) then
					return true
				elseif (Value2[Integer] or -1) < (Value1[Integer] or -1) then
					return false
				end
			end
			return false
		end)
		for _,Text in pairs(CommandDisplays) do
			NewInstance("TextLabel",Gui.SuggestionsScroll,{
				TextSize = 14,
				RichText = true,
				Font = Enum.Font.Arial,
				BackgroundTransparency = 1,
				TextStrokeTransparency = .8,
				TextColor3 = Color3.fromHex"A0A0A0",
				TextXAlignment = Enum.TextXAlignment.Left,
				Text = Text
			})
		end
		local CommandNumber = #Gui.SuggestionsScroll:GetChildren()-1
		Gui.SuggestionsScroll.CanvasSize = UDim2.new(0,0,0,20*CommandNumber)
		local Size = UDim2.new(0,400,0,0 < CommandNumber and 48+20*CommandNumber or 40)
		Animate(Gui.Main,{
			Time = .25,
			Properties = {
				Size = Size,
				Position = CheckAxis"Y" and Gui.Main.Position+UDim2.new(0,0,0,Gui.Main.AbsoluteSize.Y-Size.Y.Offset) or Gui.Main.Position
			}
		})
end
end
local Connections = {
	not GlobalEnvironment.UltimatumDebug and isfile and Services.RunService.Heartbeat:Connect(function()
		if OwnerSettings.AutoUpdate and 60 < os.clock()-LastCheck then
			LastCheck = os.clock()
			local Success,Result = pcall(game.HttpGet,game,"https://raw.githubusercontent.com/Amourousity/Ultimatum/main/Source.lua",true)
			if Success and (not isfile"Source.Ultimatum" or Result ~= readfile"Source.Ultimatum") then
				writefile("Source.Ultimatum",Result)
				Notify{
					Yields = true,
					Duration = .75,
					Text = "<b>Update Detected</b>\nUltimatum will now update..."
				}
				loadstring(Result,"Ultimatum")()
			elseif not Success and not isfile"Source.Ultimatum" then
				Notify{
					Urgent = true,
					CalculateDuration = true,
					Text = ("<b>Error</b>\n%s"):format(Result)
				}
			end
		end
	end),
	not GlobalEnvironment.UltimatumDebug and queue_on_teleport and isfile and Services.Players.LocalPlayer.OnTeleport:Connect(function(TeleportState)
		if OwnerSettings.LoadOnRejoin and TeleportState == Enum.TeleportState.Started then
			queue_on_teleport(isfile"Source.Ultimatum" and readfile"Source.Ultimatum" or "error('Source.Ultimatum missing from workspace folder',0)")
			pcall(GlobalEnvironment.Ultimatum)
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
		Gui.CommandBar.PlaceholderText = "Enter a command..."
		ExpandGui(true)
		task.delay(.25,UpdateSuggestions)
		Debounce = true
	end),
	Gui.CommandBar.FocusLost:Connect(function(Sent)
		task.wait()
		Gui.CommandBar.PlaceholderText = ("Enter a command (Keybind:\u{200A}%s\u{200A})"):format(Services.UserInputService:GetStringForKeyCode(Enum.KeyCode[OwnerSettings.Keybind]))
		if Sent and 0 < #Gui.CommandBar.Text then
			for _,Input in pairs(Gui.CommandBar.Text:split(OwnerSettings.CommandSeperator)) do
				local Arguments = Input:split(OwnerSettings.ArgumentSeperator)
				local Command = Arguments[1]
				table.remove(Arguments,1)
				local RanCommand
				for CommandNames,CommandInfo in pairs(Commands) do
					CommandNames = CommandNames:split"_"
					local Continue
					for _,CommandName in pairs(CommandNames) do
						if CommandName:lower() == Command:lower() then
							CommandInfo.Arguments = Valid.Table(CommandInfo.Arguments)
							for ArgumentNumber,ArgumentProperties in pairs(CommandInfo.Arguments) do
								if ArgumentProperties.Required and not Arguments[ArgumentNumber] then
									Notify{
										CalculateDuration = true,
										Text = ("<b>Missing Argument</b>\nThe command <i><b>%s</b></i> requires you to enter the argument <i><b>%s</b></i> of type <i><b>%s</b></i>"):format(CommandNames[1],ArgumentProperties.Name,ArgumentProperties.Type)
									}
									break
								end
								Arguments[ArgumentNumber] = Valid[ArgumentProperties.Type](Arguments[ArgumentNumber],ArgumentProperties.Substitute)
							end
							CommandInfo.Function(unpack(Arguments))
							Continue,RanCommand = true,true
							break
						end
					end
					if Continue then
						break
					end
				end
				if not RanCommand then
					Notify{
						CalculateDuration = true,
						Text = ('<b>Not a Command</b>\nThere are not any commands named "%s"'):format(Command)
					}
				end
			end
			Gui.CommandBar.Text = ""
		elseif Services.UserInputService:IsKeyDown(Enum.KeyCode.Escape) then
			Gui.CommandBar.Text = ""
		end
		Debounce = false
		Animate(Gui.Main,{
			Time = .25,
			Properties = {
				Size = UDim2.new(0,400,0,40),
				Position = CheckAxis"Y" and Gui.Main.Position+UDim2.new(0,0,0,Gui.Main.AbsoluteSize.Y-math.round(40*OwnerSettings.Scale)) or Gui.Main.Position
			}
		})
		task.delay(.25,function()
			if Services.UserInputService:GetFocusedTextBox() ~= Gui.CommandBar then
				ExpandGui(false)
			end
		end)
	end),
	Services.UserInputService.InputBegan:Connect(function(Input,Ignore)
		if not Ignore and Input.UserInputType == Enum.UserInputType.Keyboard and Input.KeyCode.Name == OwnerSettings.Keybind then
			task.defer(Gui.CommandBar.CaptureFocus,Gui.CommandBar)
		end
	end),
	Gui.CommandBar:GetPropertyChangedSignal"Text":Connect(UpdateSuggestions)
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
			Destroy(Connection)
			pcall(table.remove,Connections,table.find(Connections,Connection))
		end
	end
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
				local NewPosition = OwnerSettings.EdgeDetect ~= "None" and Vector2.new(math.clamp(MousePosition.X,CardSize.X/2,ScreenSize.X-CardSize.X/2),math.clamp(MousePosition.Y,CardSize.Y/2,ScreenSize.Y-CardSize.Y/2)) or MousePosition
				if NewPosition ~= MousePosition then
					if OwnerSettings.EdgeDetect == "GuiAndMouse" and mousemoverel and Focused then
						mousemoverel(NewPosition.X-MousePosition.X,NewPosition.Y-MousePosition.Y)
					end
					MousePosition = NewPosition
				end
				FinalPosition = UDim2.new(math.round(MousePosition.X-CardSize.X/2)/ScreenSize.X,0,math.round(MousePosition.Y-CardSize.Y/2)/ScreenSize.Y,0)
				Animate(Frame,{
					Time = OwnerSettings.FancyDragging and .1 or 0,
					Properties = {
						Position = FinalPosition
					}
				})
			end)
			AddConnections{
				DragConnection
			}
		end
	end),Services.UserInputService.InputEnded:Connect(function(Input)
		if DragConnection and Input.UserInputType == Enum.UserInputType.MouseButton1 then
			RemoveConnections{
				DragConnection
			}
			DragConnection = nil
			Animate(Frame,{
				Time = .5,
				Properties = {
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
	Destroy(Connections)
	GlobalEnvironment.Ultimatum = nil
	Gui:Destroy()
	--- @diagnostic disable-next-line undefined-global
	if protect_gui then
		Destroy(gethui())
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
			CornerRadius = UDim.new(0,4)
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
	},
	Main = {
		Rotation = 0,
		AnchorPoint = Vector2.zero,
		BackgroundTransparency = 0,
		Size = UDim2.new(0,40,0,40),
		Position = UDim2.new(0,0,1,0),
	},
	MainCorner = {
		CornerRadius = UDim.new(0,4)
	},
	MainAspectRatioConstraint = {
		Parent = Gui.Logo
	},
	MainListLayout = {
		Parent = Gui.MainSection
	},
	SuggestionsSection = {
		Size = UDim2.new(1,0,1,-40)
	},
	CommandBarSection = {
		Size = UDim2.new(1,0,0,40)
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
	Yields = true,
	Properties = {
		Position = UDim2.new(0,0,1,-40*OwnerSettings.Scale)
	}
})
Debounce = false
if OwnerSettings.StayOpen then
	ExpandGui(true,true)
end
