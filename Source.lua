  --[[]    [|] [|]    [|||||||||] [|||||||||] [||]    [||]      [|] [|||||||||] [|]    [|] [||]    [||]
   [|]    [|] [|]        [|]         [|]     [||||] [||||]   [|] [|]   [|]     [|]    [|] [||||] [||||]
  [|]    [|] [|]        [|]         [|]     [|] [|||] [|]  [|]   [|]  [|]     [|]    [|] [|] [|||] [|]
 [|]    [|] [|]        [|]         [|]     [|]  [|]  [|] [|||||||||] [|]     [|]    [|] [|]  [|]  [|]
[|]    [|] [|]        [|]         [|]     [|]       [|] [|]     [|] [|]     [|]    [|] [|]       [|]
[|]  [|]  [|]        [|]         [|]     [|]       [|] [|]     [|] [|]      [|]  [|]  [|]       [|]
[||||]   [||||||||] [|]     [|||||||||] [|]       [|] [|]     [|] [|]       [||||]   [|]       []]
local UltimatumStart = getfenv().UltimatumStart or os.clock()
do
	local Environment = getfenv()
	local function CheckCompatibility(Paths,Replacement)
		Paths = Paths:split()
		local Function
		for Count,Path in next,(Paths) do
			Path = Path:split"."
			Function = Environment[Path[1]]
			for Depth = 2,#Path do
				if Function then
					Function = Function[Path[Depth]]
				end
			end
			if Function or Replacement and Count == #Paths then
				for _,NewPathName in next,Paths do
					NewPathName = NewPathName:split"."
					local NewPath = Environment
					for Depth = 1,#NewPathName-1 do
						if not NewPath[NewPathName[Depth]] then
							NewPath[NewPathName[Depth]] = {}
						end
						NewPath = NewPath[NewPathName[Depth]]
					end
					if not NewPath[NewPathName[#NewPathName]] then
						NewPath[NewPathName[#NewPathName]] = Function or Replacement
					end
				end
				break
			end
		end
	end
	for _,FunctionNames in next,{
		"getsenv,getmenv",
		"getreg,getregistry",
		"getgc,get_gc_objects",
		"getinfo,debug.getinfo",
		"isreadonly,is_readonly",
		"getproto,debug.getproto",
		"getstack,debug.getstack",
		"iscclosure,is_c_closure",
		"setstack,debug.setstack",
		"getprotos,debug.getprotos",
		"consoleinput,rconsoleinput",
		"getcustomasset,getsynasset",
		"isrbxactive,iswindowactive",
		"makereadonly,make_readonly",
		"dumpstring,getscriptbytecode",
		"hookfunction,detour_function",
		"makewriteable,make_writeable",
		"getconnections,get_signal_cons",
		"request,http.request,syn.request",
		"getrawmetatable,debug_getmetatable",
		"getcallingscript,get_calling_script",
		"getloadedmodules,get_loaded_modules",
		"getscriptclosure,get_script_function",
		"getupvalue,getupval,debug.getupvalue",
		"setupvalue,setupval,debug.setupvalue",
		"getnamecallmethod,get_namecall_method",
		"getconstant,getconst,debug.getconstant",
		"is_cached,cache.iscached,syn.is_cached",
		"protectgui,protect_gui,syn.protect_gui",
		"setconstant,setconst,debug.setconstant",
		"consoleprint,writeconsole,rconsoleprint",
		"getupvalues,getupvals,debug.getupvalues",
		"queue_on_teleport,syn.queue_on_teleport",
		"WebSocket.connect,syn.websocket.connect",
		"crypt.hash,syn.crypt.hash,syn.crypto.hash",
		"getconstants,getconsts,debug.getconstants",
		"consolecreate,createconsole,rconsolecreate",
		"closeconsole,consoledestroy,rconsoledestroy",
		"unprotectgui,unprotect_gui,syn.unprotect_gui",
		"cache_replace,cache.replace,syn.cache_replace",
		"rconsolename,consolesettitle,rconsolesettitle",
		"cache_invalidate,cache.invalidate,syn.cache_invalidate",
		"crypt.generatebytes,syn.crypt.random,syn.crypto.random",
		"crypt.hash,syn.crypt.custom.hash,syn.crypto.custom.cash",
		"decrypt,crypt.decrypt,syn.crypt.decrypt,syn.crypto.decrypt",
		"encrypt,crypt.encrypt,syn.crypt.encrypt,syn.crypto.encrypt",
		"crypt.custom_encrypt,syn.crypt.custom.encrypt,syn.crypto.custom.encrypt",
		"crypt.custom_decrypt,syn.crypt.custom.decrypt,syn.crypto.custom.decrypt",
		"base64encode,crypt.base64encode,syn.crypt.base64.encode,syn.crypto.base64.encode",
		"base64decode,crypt.base64decode,syn.crypt.base64.decode,syn.crypto.base64.decode",
		"getidentity,getthreadcontext,getthreadidentity,get_thread_identity,syn.get_thread_identity",
		"setidentity,setthreadcontext,setthreadidentity,set_thread_identity,syn.set_thread_identity",
		"setclipboard,writeclipboard,write_clipboard,toclipboard,set_clipboard,Clipboard.set,syn.write_clipboard",
		"checkclosure,istempleclosure,issentinelclosure,iselectronfunction,is_synapse_function,is_protosmasher_closure"
	} do
		CheckCompatibility(FunctionNames)
	end
	--- @diagnostic disable undefined-global
	for Paths,Replacement in next,{
		setreadonly = makewriteable and function(Table,ReadOnly)
			(ReadOnly and makereadonly or makewriteable)(Table)
		end or 0,
		hootmetamethod = hookfunction and getrawmetatable and function(Object,Method,Hook)
			return hookfunction(getrawmetatable(Object)[Method],Hook)
		end or 0,
		setparentinternal = protectgui and function(Object,Parent)
			protectgui(Object)
			Object.Parent = Parent
		end or 0,
		["gethui,get_hidden_gui"] = protectgui and (function()
			local HiddenUI = Instance.new"Folder"
			protectgui(HiddenUI)
			HiddenUI.Parent = cloneref and cloneref(game:GetService"CoreGui") or game:GetService"CoreGui"
			return function()
				return HiddenUI
			end
		end)() or function()
			return cloneref and cloneref(game:GetService"CoreGui") or game:GetService"CoreGui"
		end,
		["islclosure,is_l_closure"] = iscclosure and function(Closure)
			return not iscclosure(Closure)
		end or 0,
		cloneref = getreg and (function()
			local TestPart = Instance.new"Part"
			local InstanceList
			for _,InstanceTable in next,getreg() do
				if type(InstanceTable) == "table" and #InstanceTable then
					if rawget(InstanceTable,"__mode") == "kvs" then
						for _,PartCheck in next,InstanceTable do
							if PartCheck == TestPart then
								InstanceList = InstanceTable
								pcall(game.Destroy,TestPart)
								break
							end
						end
					end
				end
			end
			if InstanceList then
				return function(Object)
					for Index,Value in next,InstanceList do
						if Value == Object then
							InstanceList[Index] = nil
							return Object
						end
					end
				end
			end
		end)() or 0,
		["consoleclear,rconsoleclear"] = consoleprint and function()
			consoleprint(("\b"):rep(1e6))
		end or 0
	} do
		CheckCompatibility(Paths,type(Replacement) == "function" and Replacement or nil)
	end
	--- @diagnostic enable undefined-global
end
local GlobalEnvironment = getgenv and getgenv() or shared
pcall(GlobalEnvironment.Ultimatum)
local Nil = {}
local Connect = game.Changed.Connect
local Destroy
do
	local DestroyObject = game.Destroy
	local DisconnectObject
	do
		local Connection = Connect(game.Changed,function() end)
		DisconnectObject = Connection.Disconnect
		DisconnectObject(Connection)
	end
	Destroy = function(...)
		for _,Object in next,{
			...
		} do
			for Type,Function in next,{
				Instance = function()
					pcall(DestroyObject,Object)
				end,
				RBXScriptConnection = function()
					if Object.Connected then
						pcall(DisconnectObject,Object)
					end
				end,
				table = function()
					for Index,Value in next,Object do
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
	end
end
pcall(GlobalEnvironment.Ultimatum)
local Wait,Service
do
	local SignalWait,Services = game.Changed.Wait,{}
	for _,Name in next,{
		"Ad",
		"VR",
		"Gui",
		"Log",
		"Run",
		"Http",
		"Test",
		"Text",
		"Asset",
		"Badge",
		"Chat.",
		"Group",
		"Mouse",
		"Sound",
		"Timer",
		"Tween",
		"Drafts",
		"Friend",
		"Haptic",
		"Insert",
		"Joints",
		"LuaWeb",
		"Points",
		"Policy",
		"Script",
		"Stats.",
		"Studio",
		"Teams.",
		"Visit.",
		"Browser",
		"Cookies",
		"Debris.",
		"Dragger",
		"Gamepad",
		"Package",
		"Physics",
		"Publish",
		"Spawner",
		"TextBox",
		"CoreGui.",
		"GamePass",
		"Keyboard",
		"Language",
		"Material",
		"Players.",
		"Teleport",
		"Analytics",
		"DataStore",
		"Geometry.",
		"Lighting.",
		"PluginGui",
		"UserInput",
		"Collection",
		"Controller",
		"HttpRbxApi",
		"MemStorage",
		"Selection.",
		"TouchInput",
		"Workspace.",
		"Marketplace",
		"Pathfinding",
		"Permissions",
		"PluginDebug",
		"StarterGui.",
		"Localization",
		"Notification",
		"ScriptEditor",
		"ServerScript",
		"StarterPack.",
		"ChangeHistory",
		"ContextAction",
		"UGCValidation",
		"ScriptContext.",
		"ServerStorage.",
		"StarterPlayer.",
		"ProximityPrompt",
		"ContentProvider.",
		"DebuggerManager.",
		"ReplicatedFirst.",
		"ReplicatedStorage.",
		"MeshContentProvider.",
		"VirtualInputManager.",
		"AnimationClipProvider.",
		"ProcessInstancePhysics",
		"HSRDataContentProvider.",
		"KeyframeSequenceProvider.",
		"SolidModelContentProvider."
	} do
		Services[Name:gsub("%.$","")] = select(2,pcall(game.GetService,game,Name:sub(-1) == "." and Name:sub(1,-2) or ("%sService"):format(Name)))
	end
	Wait,Service = function(Value)
		if typeof(Value) == "RBXScriptSignal" then
			return SignalWait(Value)
		end
		return task.wait(Value)
	end,function(Name)
		return Services[Name] or error(('Ultimatum | Failed to get service "%s"'):format(Name),0)
	end
end
local Owner = Service"Players".LocalPlayer
while not Owner do
	Wait(Service"Players".PlayerAdded)
	Owner = Service"Players".LocalPlayer
end
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
		for Index,Value in next,type(Substitute) == "table" and Substitute or {} do
			Table[Index] = typeof(Table[Index]) == typeof(Value) and Table[Index] or Value
		end
		return Table
	end,
	Number = function(Number,Substitute)
		Number,Substitute = tonumber(Number),tonumber(Substitute)
		return Number == Number and Number or Substitute == Substitute and Substitute or nil
	end,
	String = function(String,Substitute)
		return type(String) == "string" and String or type(Substitute) == "string" and Substitute or nil
	end,
	Instance = function(Object,ClassName)
		return typeof(Object) == "Instance" and select(2,pcall(game.IsA,Object,Valid.String(ClassName,"Instance"))) == true and Object or nil
	end,
	Boolean = function(Boolean,Substitute)
		Boolean = tostring(Boolean):lower()
		for Names,Value in next,{
			true_yes_on_positive_1_i = true,
			false_no_off_negative_0_o = false
		} do
			for _,Name in next,Names:split"_" do
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
		for _,Set in next,Settings.CharacterSet do
			for Character = Set.Min,Set.Max do
				table.insert(AvailableCharacters,string.char(Character))
			end
		end
		return Settings.Format:format(("A"):rep(Settings.Length):gsub(".",function()
			return AvailableCharacters[math.random(#AvailableCharacters)]
		end))
	end,
	Bool = function(Chance)
		return math.random(math.round(1/math.min(Valid.Number(Chance,.5),1))) == 1
	end
}
table.freeze(Randomized)
local function NewInstance(ClassName,Parent,Properties)
	local _,NewObject = pcall(Instance.new,ClassName)
	if typeof(NewObject) == "Instance" then
		Properties = Valid.Table(Properties,{
			Name = Randomized.String(),
			Archivable = Randomized.Bool()
		})
		for Property,Value in next,Properties do
			local Success,Error = pcall(function()
				NewObject[Property] = NilConvert(Value)
			end)
			if not Success then
				error(("Ultimatum | %s"):format(Error))
			end
		end
		NewObject.Parent = typeof(Parent) == "Instance" and Parent or nil
		return NewObject
	else
		error(("Ultimatum | %s"):format(NewObject))
	end
end
local function Create(Data)
	local Instances = {}
	for _,InstanceData in next,Valid.Table(Data) do
		if not Valid.String(InstanceData.ClassName) then
			error"Ultimatum | Missing ClassName in InstanceData for function Create"
		elseif not Valid.String(InstanceData.Name) then
			warn"Ultimatum | Missing Name in InstanceData for function Create, substituting with ClassName"
			InstanceData.Name = InstanceData.ClassName
		end
		Instances[InstanceData.Name] = NewInstance(InstanceData.ClassName,Valid.String(InstanceData.Parent) and Instances[InstanceData.Parent] or InstanceData.Parent,InstanceData.Properties)
	end
	return Instances
end
local OwnerSettings
do
	local Success,Output = pcall(Service"Http".JSONDecode,Service"Http",isfile and isfile"Settings.Ultimatum" and readfile"Settings.Ultimatum":gsub("^%bA{","{") or "[]")
	local Settings = Valid.Table(Success and Output or {},{
		Scale = 1,
		Blur = true,
		StayOpen = false,
		AutoUpdate = true,
		LoadOnRejoin = true,
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
				local FormattedSettings = {}
				for SettingName,SettingValue in next,Settings do
					table.insert(FormattedSettings,("\t%s : %s,"):format(("%q"):format(SettingName),type(SettingValue) == "string" and ("%q"):format(SettingValue) or tostring(SettingValue)))
				end
				table.sort(FormattedSettings,function(String1,String2)
					if #String1 < #String2 then
						return true
					elseif #String2 < #String1 then
						return false
					end
					String1,String2 = {
						String1:byte(1,-2)
					},{
						String2:byte(1,-2)
					}
					for Integer = 1,math.max(#String1,#String2) do
						if (String1[Integer] or -1) < (String2[Integer] or -1) then
							return true
						elseif (String2[Integer] or -1) < (String1[Integer] or -1) then
							return false
						end
					end
					return false
				end)
				FormattedSettings[#FormattedSettings] = FormattedSettings[#FormattedSettings]:sub(1,-2)
				writefile("Settings.Ultimatum",('All settings for Ultimatum.\nDo not edit this file unless you know what you\'re doing.\nEvery setting can be changed in-game using the "Settings" command.\n{\n%s\n}'):format(table.concat(FormattedSettings,"\n")))
			end
		end,
		__metatable = "nil"
	})
end
OwnerSettings._ = nil
local function WaitForSignal(Signal,MaxYield)
	local Return = NewInstance"BindableEvent"
	Destroy(Return)
	if Valid.Number(MaxYield) then
		task.delay(MaxYield,Return.Fire,Return)
	end
	local SignalStart,Ready = os.clock()
	for Type,Functionality in next,{
		RBXScriptSignal = function()
			Return:Fire(Wait(Signal))
		end,
		["function"] = function()
			local Continue
			repeat
				(function(Success,...)
					if Success and ... then
						Continue = true
						if not Ready then
							Wait()
						end
						Return:Fire(...)
					end
				end)(pcall(Signal))
			until Continue or Valid.Number(MaxYield) and MaxYield < os.clock()-SignalStart
		end
	} do
		if typeof(Signal) == Type then
			task.spawn(Functionality)
			break
		end
	end
	Ready = true
	return Wait(Return.Event)
end
pcall(GlobalEnvironment.Ultimatum)
if Service"CoreGui":FindFirstChild"RobloxLoadingGui" and Service"CoreGui".RobloxLoadingGui:FindFirstChild"BlackFrame" and Service"CoreGui".RobloxLoadingGui.BlackFrame.BackgroundTransparency <= 0 then
	local Start = os.clock()
	WaitForSignal(Service"CoreGui".RobloxLoadingGui.BlackFrame:GetPropertyChangedSignal"BackgroundTransparency",3)
	Wait(math.random())
	UltimatumStart += os.clock()-Start
end
pcall(GlobalEnvironment.Ultimatum)
local LogoId = writefile and getcustomasset and (isfile"UltimatumLogo.png" or (function()
	local Success,Output = pcall(game.HttpGet,game,"https://raw.githubusercontent.com/Amourousity/Ultimatum/main/Logo.png")
	if Success then
		writefile("UltimatumLogo.png",Output)
	end
end)()) and getcustomasset"UltimatumLogo.png" or "rbxassetid://9666094136"
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
			ClipsDescendants = true,
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
			Image = LogoId
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
			TextSize = 14,
			Font = Enum.Font.Arial,
			ClearTextOnFocus = false,
			BackgroundTransparency = 1,
			Size = UDim2.new(1,-10,1,0),
			Position = UDim2.new(0,10,0,0),
			TextColor3 = Color3.new(1,1,1),
			TextXAlignment = Enum.TextXAlignment.Left,
			PlaceholderColor3 = Color3.fromHex"A0A0A0",
			PlaceholderText = ("Enter a command (Keybind:\226\128\138%s\226\128\138)"):format(Service"UserInput":GetStringForKeyCode(Enum.KeyCode[OwnerSettings.Keybind]))
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
	},
	{
		Name = "NotificationHolder",
		Parent = "Holder",
		ClassName = "Frame",
		Properties = {
			AnchorPoint = Vector2.one,
			BackgroundTransparency = 1,
			Size = UDim2.new(1/3,0,1,-20),
			Position = UDim2.new(1,-10,1,-10)
		}
	},
	{
		Name = "NotificationlistLayout",
		Parent = "NotificationHolder",
		ClassName = "UIListLayout",
		Properties = {
			Padding = UDim.new(0,10),
			VerticalAlignment = Enum.VerticalAlignment.Bottom,
			HorizontalAlignment = Enum.HorizontalAlignment.Right
		}
	}
}
local function Animate(...)
	for Index = 1,select("#",...),2 do
		local Object,Data = select(Index,...)
		if Valid.Instance(Object) then
			Data = Valid.Table(Data,{
				Time = .5,
				DelayTime = 0,
				Yields = false,
				FinishDelay = 0,
				Properties = {},
				RepeatCount = 0,
				Reverses = false,
				EasingStyle = Enum.EasingStyle.Quad,
				EasingDirection = Enum.EasingDirection.Out
			})
			Service"Tween":Create(Object,TweenInfo.new(Data.Time,Data.EasingStyle,Data.EasingDirection,Data.RepeatCount,Data.Reverses,Data.DelayTime),Data.Properties):Play()
			if Data.Yields then
				Wait((Data.Time+Data.DelayTime)*(1+Data.RepeatCount))
			end
			if 0 < Data.FinishDelay then
				Wait(Data.FinishDelay)
			end
		end
	end
end
local NotificationIDs = {}
local function Notify(Settings)
	Settings = Valid.Table(Settings,{
		Buttons = {},
		Duration = 5,
		Urgent = false,
		Yields = false,
		Title = "Ultimatum",
		CalculateDuration = true,
		Text = "(no text)"
	})
	Settings.Text = ("<b>%s</b>\n%s"):format(Settings.Title,Settings.Text)
	if OwnerSettings.Notifications == "Off" or OwnerSettings.Notifications == "Urgent" and not Settings.Urgent then
		return
	end
	local ID
	repeat
		ID = Randomized.String{
			Format = "%s",
			Length = 5
		}
	until not table.find(NotificationIDs,ID)
	table.insert(NotificationIDs,ID)
	local Notification = Create{
		{
			Name = "Main",
			Parent = Gui.NotificationHolder,
			ClassName = "Frame",
			Properties = {
				ClipsDescendants = true,
				AnchorPoint = Vector2.one,
				BackgroundTransparency = 1,
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
				TextSize = 14,
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
		for _ in utf8.graphemes(Notification.Content.ContentText) do
			Settings.Duration += .06
		end
	end
	Settings.Duration += .25
	local Size = Service"Text":GetTextSize(Notification.Content.ContentText,14,Enum.Font.Arial,Vector2.new(Gui.NotificationHolder.AbsoluteSize.X,Gui.NotificationHolder.AbsoluteSize.Y))
	Notification.Main.Size = UDim2.new(0,Size.X+22,0,Size.Y+20)
	Size = Notification.Main.Size
	Notification.Main.Size = UDim2.new(Size.X.Scale,Size.X.Offset,0,0)
	Animate(Notification.Main,{
		Time = .25,
		Properties = {
			Size = Size,
			BackgroundTransparency = 0
		}
	},Notification.Content,{
		Time = .25,
		Properties = {
			TextTransparency = 0
		},
		EasingStyle = Enum.EasingStyle.Linear
	})
	task.delay(Settings.Duration,Animate,Notification.Main,{
		Time = 1,
		Properties = {
			BackgroundTransparency = 1
		}
	},Notification.Content,{
		Time = 1,
		Properties = {
			TextTransparency = 1
		},
		EasingStyle = Enum.EasingStyle.Linear
	})
	Settings.Duration += 1
	task.spawn(function()
		local Start = os.clock()
		repeat
			Notification.Main.LayoutOrder = table.find(NotificationIDs,ID)
			Wait()
		until Settings.Duration < os.clock()-Start
		table.remove(NotificationIDs,table.find(NotificationIDs,ID))
	end)
	if Settings.Yields then
		Wait(Settings.Duration)
		Destroy(Notification)
	else
		task.delay(Settings.Duration,Destroy,Notification)
	end
end
local function CheckAxis(Axis)
	return workspace.CurrentCamera.ViewportSize[Axis]/2 < Gui.Logo.AbsolutePosition[Axis]+Gui.Logo.AbsoluteSize[Axis]/2
end
local LastCheck,Focused,Debounce,LastLeft = 0,not isrbxactive and true or isrbxactive(),true,0
local function ResizeMain(X,Y)
	X = OwnerSettings.StayOpen and 400 or Valid.Number(X,400)
	Y = Valid.Number(Y,40)
	Gui.CommandBarBackground.LayoutOrder = CheckAxis"X" and -1 or 1
	Gui.CommandBarSection.LayoutOrder = CheckAxis"Y" and 1 or -1
	Animate(Gui.Main,{
		Time = .25,
		Properties = {
			Size = UDim2.new(0,X,0,Y),
			Position = Gui.Main.Position+UDim2.new(0,CheckAxis"X" and Gui.Main.AbsoluteSize.X-X or 0,0,CheckAxis"Y" and Gui.Main.AbsoluteSize.Y-Y or 0)
		}
	},Gui.CommandBarBackground,{
		Time = .25,
		Properties = {
			Visible = 40 < X
		}
	})
end
local function Assert(...)
	for Index = 1,select("#",...),2 do
		local Assertion,FailureMessage = select(Index,...)
		if not Assertion then
			Notify{
				Title = "Command Failed",
				Text = Valid.String(FailureMessage,"The command failed to run. No further information provided")
			}
			return false
		end
	end
	return true
end
local function GetCharacter(Player,MaxYield)
	Player = Valid.Instance(Player,"Player")
	if not Assert(Player,"Specified player does not exist or left") then
		return
	end
	if Valid.Instance(Player.Character,"Model") then
		return Player.Character
	end
	local Character = WaitForSignal(Player.CharacterAdded,MaxYield)
	if Assert(Character,"The player's character took too long to load") then
		return Character
	end
end
local function GetHumanoid(Character,MaxYield)
	MaxYield = Valid.Number(MaxYield,10)
	if Valid.Instance(Character,"Player") then
		local Duration = os.clock()
		local NewCharacter = GetCharacter(Character,MaxYield)
		if NewCharacter then
			Character = NewCharacter
			MaxYield -= os.clock()-Duration
		else
			return
		end
	elseif not Assert(Valid.Instance(Character,"Model"),"The player's character isn't valid") then
		return
	end
	local Humanoid = WaitForSignal(function()
		local Humanoid = Character:FindFirstChildOfClass"Humanoid" or Wait(Character.ChildAdded)
		if Valid.Instance(Humanoid,"Humanoid") then
			return Humanoid
		end
	end,MaxYield)
	if Assert(Humanoid,"The player's humanoid took too long to load") then
		return Humanoid
	end
end
local function ConvertTime(Time)
	for _,Values in next,{
		{
			31536000,
			"year"
		},
		{
			2628003,
			"month"
		},
		{
			604800,
			"week"
		},
		{
			86400,
			"day"
		},
		{
			3600,
			"hour"
		},
		{
			60,
			"minute"
		},
		{
			1,
			"second"
		},
		{
			.001,
			"millisecond"
		},
		{
			.000001,
			"microsecond"
		},
		{
			.000000001,
			"nanosecond"
		}
	} do
		if Values[1] <= Time then
			Time = math.round(Time/Values[1]*10)/10
			return ("%s %s%s"):format(tostring(Time),Values[2],Time ~= 1 and "s" or "")
		end
	end
end
local Commands,Connections
local function RunCommand(Text)
	for _,Input in next,Text:split(OwnerSettings.CommandSeperator) do
		local Arguments = Input:split(OwnerSettings.ArgumentSeperator)
		local Command = Arguments[1]
		table.remove(Arguments,1)
		local RanCommand
		for CommandNames,CommandInfo in next,Commands do
			CommandNames = CommandNames:split"_"
			local Continue
			for _,CommandName in next,CommandNames do
				if CommandName:lower() == Command:lower() then
					CommandInfo.Arguments = Valid.Table(CommandInfo.Arguments)
					for ArgumentNumber,ArgumentProperties in next,CommandInfo.Arguments do
						if ArgumentProperties.Required and not Arguments[ArgumentNumber] then
							Notify{
								Title = "Missing Argument",
								Text = ('The command "%s" requires you to enter the argument "%s"'):format(CommandNames[1],ArgumentProperties.Name)
							}
							break
						end
						if ArgumentProperties.Concatenate then
							Arguments[ArgumentNumber] = table.concat(Arguments,OwnerSettings.ArgumentSeperator,ArgumentNumber)
							for Index = ArgumentNumber+1,#Arguments do
								Arguments[Index] = nil
							end
						end
						Arguments[ArgumentNumber] = Valid[ArgumentProperties.Type](Arguments[ArgumentNumber],ArgumentProperties.Substitute)
					end
					if CommandInfo.Variables then
						table.insert(Arguments,1,CommandInfo.Variables)
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
				Title = "Not a Command",
				Text = ('There are not any commands named "%s"'):format(Command)
			}
		end
	end
end
local function AddConnections(GivenConnections)
	for Name,Connection in next,Valid.Table(GivenConnections) do
		if typeof(Connection) == "RBXScriptConnection" and Connection.Connected then
			Connections[type(Name) ~= "number" and Name or #Connections+1] = Connection
			table.insert(Connections,Connection)
		end
	end
end
local function RemoveConnections(GivenConnections)
	for _,Connection in next,Valid.Table(GivenConnections) do
		if typeof(Connection) == "RBXScriptConnection" then
			Destroy(Connection)
			pcall(table.remove,Connections,table.find(Connections,Connection))
		end
	end
end
Commands = {
	Exit_close_leave_shutdown = {
		Function = function()
			game:Shutdown()
		end,
		Description = "Closes the current Roblox window/proccess"
	},
	CopyJoinScript_copyjoincode_copyjoin_copyjcode_copyjscript_copyj_cjoin_copyjs_cj_cjs_cjc = {
		Function = function()
			local JoinScript = ('javascript:Roblox.GameLauncher.joinGameInstance(%d,"%s")'):format(game.PlaceId,game.JobId)
			if setclipboard then
				setclipboard(JoinScript)
				Notify{
					Title = "Successfully Copied",
					Text = "Paste the copied script into your brower's URL bar and press Enter"
				}
			else
				Notify{
					Title = "Copy to Clipboard",
					Text = ("%s\nPaste the above script into your brower's URL bar and press Enter"):format(JoinScript)
				}
			end
		end,
		Description = setclipboard and "Copies JavaScript to your clipboard used to join the same server" or "Notifies JavaScript to be copied to your clipboard used to join the same server"
	},
	DisableRendering_disablerender_drendering_derender_drender_dr_norendering_norender = {
		Function = function(Disabled)
			Service"Run":Set3dRenderingEnabled(not Disabled)
		end,
		Arguments = {
			{
				Name = "Disabled",
				Type = "Boolean",
				Substitute = true
			}
		},
		Description = "Disables 3D rendering (everything except for GUIs are invisible), boosting FPS. Usually used with auto-farms to improve their efficiency"
	},
	Rejoin_rejoinserver_rejoingame_rej_rj = {
		Function = function()
			if 1 < #Service"Players":GetPlayers() then
				pcall(Service"Teleport".TeleportToPlaceInstance,Service"Teleport",game.PlaceId,game.JobId)
			else
				Owner:Kick()
				RunCommand"CloseRobloxMessage"
				Notify{
					Title = "Rejoining",
					Text = "You will be rejoined shortly..."
				}
				task.delay(3,pcall,Service"Teleport".Teleport,Service"Teleport",game.PlaceId)
			end
		end,
		Description = "Rejoins the current server you're in"
	},
	CloseRobloxMessage_closerobloxerror_closemessage_closeerror_cmessage_cerror_closermessage_closererror_crobloxmessage_crobloxerror_clearrobloxmessage_clearrobloxerror_clearrerror_clearrmessage_clearmessage_clearerror_cm_crm_cre_ce_closekickmessage_clearkickmessage_clearkick_closekick_ckm_ck_closekickerror_clearkickerror_cke = {
		Function = function()
			Service"Gui":ClearError()
		end,
		Description = "Closes any messages/errors (the grey containers with the blurred background) displayed by Roblox"
	},
	WalkSpeed_speed_wspeed_walks_runspeed_rspeed_runs_spoofwalkspeed_spoofspeed_spoofwspeed_spoofwalks_spoofrunspeed_spoofrspeed_spoofruns_swalkspeed_sspeed_swspeed_swalks_srunspeed_srspeed_sruns_fakewalkspeed_fakewspeed_fakewalks_fakerunspeed_fakerspeed_fakeruns_ws_frs_srs = {
		Function = function(Variables,Speed)
			Variables.Speed = Speed
			if not Variables.Enabled then
				local Character = GetCharacter(Owner,5)
				if not Character then
					return
				end
				local Humanoid = GetHumanoid(Character,5)
				if not Humanoid then
					return
				end
				Variables.Connection = Connect(Service"Run".Heartbeat,function(Delta)
					if not Character:IsDescendantOf(workspace) or Humanoid:GetState().Name == "Dead" then
						RemoveConnections{
							Variables.Connection
						}
						Variables.Enabled,Variables.Connection = false,nil
					end
					if 0 < Humanoid.MoveDirection.Magnitude and table.find({
						"Landed",
						"Jumping",
						"Running",
						"Freefall",
						"Swimming"
					},Humanoid:GetState().Name) then
						Character:TranslateBy(Humanoid.MoveDirection*math.min(Delta,1/15)*(Variables.Speed-Humanoid.WalkSpeed))
					end
				end)
				AddConnections{
					Variables.Connection
				}
				Variables.Enabled = true
			end
		end,
		Arguments = {
			{
				Name = "Speed",
				Type = "Number",
				Substitute = 16
			}
		},
		Variables = {},
		Description = "Changes the speed you walk at. Allows negative numbers, but you walk backwards. Your walking animation speed doesn't change"
	},
	Magic8Ball_8ball_magicball_magic8_8b_m8b_m8_8_magiceightball_eightball_meb_mb_eightballpu_eightballpr = {
		Function = function()
			Notify{
				Title = "Magic 8 Ball",
				Text = ({
					"Yes.",
					"Most likely.",
					"Outlook good.",
					"It is certain.",
					"Very doubtful.",
					"My reply is no.",
					"Yes definitely.",
					"Ask again later.",
					"Without a doubt.",
					"As I see it, yes.",
					"Don't count on it.",
					"My sources say no.",
					"Cannot predict now.",
					"It is decidedly so.",
					"Signs point to yes.",
					"You may rely on it.",
					"Outlook not so good.",
					"Reply hazy, try again.",
					"Better not tell you now.",
					"Concentrate and ask again.",
				})[math.random(20)]
			}
		end,
		Description = "Notifies the Magic 8 Ball's response to your yes-or-no question"
	},
	ServerHop_serverh_sh_hopserver_hops_hserver_newserver_nserver_ns_news_shop = {
		Function = function()
			local Page,UnfilteredServers,Servers,Start,ServerCount,ViableServerCount = "",{},{},os.clock(),0,0
			while #Servers <= 0 do
				local Success,Result = pcall(game.HttpGet,game,("https://games.roblox.com/v1/games/%s/servers/Public?limit=100%s%s"):format(game.PlaceId,0 < #Page and "&cursor=" or "",Page),true)
				if not Assert(Success,Valid.String(Result,"An unknown error has occurred")) then
					return
				end
				Result = Service"Http":JSONDecode(Result)
				Page,UnfilteredServers = Result.nextPageCursor,Result.data
				if not Assert(0 < #UnfilteredServers,"No servers found") then
					return
				end
				Servers = {}
				for _,ServerInfo in next,UnfilteredServers do
					ServerCount += 1
					if ServerInfo.playing < ServerInfo.maxPlayers and 0 < ServerInfo.playing and ServerInfo.id ~= game.JobId then
						table.insert(Servers,ServerInfo)
						ViableServerCount += 1
					end
				end
			end
			local Server = Servers[math.random(#Servers)]
			Notify{
				Title = "Joining Server",
				Text = ("Took %s to search %d servers (%d viable). Server <i>%s</i> has %d/%d players"):format(ConvertTime(os.clock()-Start),ServerCount,ViableServerCount,Server.id,Server.playing,Server.maxPlayers)
			}
			task.delay(2,Service"Teleport".TeleportToPlaceInstance,Service"Teleport",game.PlaceId,Server.id)
		end,
		Description = "Joins a random server that you weren't previously in"
	},
	Invisible_invis_iv = {
		Function = function(Variables)
			if not Variables.Enabled then
				local Character = GetCharacter(Owner,5)
				if not Character then
					return
				end
				local Humanoid = GetHumanoid(Character,5)
				if not Humanoid then
					return
				end
				local HumanoidRootPart = Character:FindFirstChild"HumanoidRootPart"
				if not Assert(HumanoidRootPart,"Player does not have a HumanoidRootPart") then
					return
				end
				local R6 = Humanoid.RigType.Name == "R6"
				if not Assert(not R6,"R6 invisibility is not supported yet") then
					return
				end
				local LowerTorso = Character:FindFirstChild"LowerTorso"
				if not Assert(LowerTorso,"Player does not have a LowerTorso") then
					return
				end
				local Root = LowerTorso:FindFirstChild"Root"
				if not Assert(Root,"Player does not have a Root") then
					return
				end
				local OldCFrame,NewRoot = HumanoidRootPart.CFrame,Root:Clone()
				HumanoidRootPart.Parent,Character.PrimaryPart = workspace,HumanoidRootPart
				Character:MoveTo(Vector3.new(OldCFrame.X,1e9,OldCFrame.Z))
				HumanoidRootPart.Parent = Character
				task.delay(.5,function()
					NewRoot.Parent,HumanoidRootPart.CFrame = LowerTorso,OldCFrame
				end)
				Variables.Connection = Connect(Service"Run".RenderStepped,function()
					if not Character:IsDescendantOf(workspace) or Humanoid:GetState().Name == "Dead" then
						RemoveConnections{
							Variables.Connection
						}
						Variables.Enabled,Variables.Connection = false,nil
						return
					end
					for _,Object in next,Character:GetDescendants() do
						if not Object:IsDescendantOf(HumanoidRootPart) then
							for Types,Properties in next,{
								BasePart_Decal = {
									LocalTransparencyModifier = 1
								},
								LayerCollector_Fire_Sparkles_ParticleEmitter = {
									Enabled = false
								},
								Sound = {
									RollOffMaxDistance = 0,
									RollOffMinDistance = 0
								},
								Decal = {
									Transparency = 1
								}
							} do
								for _,Type in next,Types:split"_" do
									if Object:IsA(Type) then
										for Property,Value in next,Properties do
											pcall(function()
												Object[Property] = Value
											end)
										end
									end
								end
							end
						end
					end
				end)
				AddConnections{
					Variables.Connection
				}
				Variables.Enabled = true
			end
		end,
		Variables = {},
		Description = "Makes you invisible to other players"
	}
}
for Replace,Info in next,({
	_142823291 = {
		ExtrasensoryPerception_extrasensoryp_esensoryperception_esperception_extrasp_esp = {
			Function = function(Variables,Enabled)
				if not Assert(not (Variables.Enabled and Enabled),"Extrasensory perception is already enabled",not (not Variables.Enabled and not Enabled),"Extrasensory perception is already disabled") then
					return
				end
				if Enabled then
					Variables.Time,Variables.Connection = os.clock(),Connect(Service"Run".Heartbeat,function()
						if not Variables.Calculating or 5 < os.clock()-Variables.Time then
							Variables.Time,Variables.Calculating = os.clock(),true
							local PlayerData = Variables.PlayerDataRemote:InvokeServer()
							if not Variables.Enabled then
								return
							end
							Destroy(Variables.ExtrasensoryPerceptions)
							if workspace:FindFirstChild"GunDrop" then
								Variables:CreateExtrasensoryPerception(workspace.GunDrop,"Gun")
							end
							for _,Player in next,Service"Players":GetPlayers() do
								local Data = PlayerData[Player.Name]
								if Data and not Data.Dead and Player.Name ~= Owner.Name then
									Variables:CreateExtrasensoryPerception(Player.Character:FindFirstChild"HumanoidRootPart" or Player.Character:FindFirstChildWhichIsA"BasePart",Data.Role)
								end
							end
							Variables.Calculating = false
						end
					end)
					AddConnections{
						Variables.Connection
					}
					Variables.Enabled = true
				else
					RemoveConnections{
						Variables.Connection
					}
					Destroy(Variables.ExtrasensoryPerceptions)
					Variables.Enabled = false
				end
			end,
			Arguments = {
				{
					Name = "Enabled",
					Type = "Boolean",
					Substitute = true
				}
			},
			Variables = {
				ExtrasensoryPerceptions = {},
				PlayerDataRemote = game.PlaceId == 142823291 and Service"ReplicatedStorage":WaitForChild"Remotes":WaitForChild"Extras":WaitForChild"GetPlayerData",
				CreateExtrasensoryPerception = function(Variables,Object,Role)
					local LargestAxis = math.max(Object.Size.X,Object.Size.Y,Object.Size.Z)
					table.insert(Variables.ExtrasensoryPerceptions,Create{
						{
							Name = "ExtrasensoryPerceptionHolder",
							Parent = Gui.Holder,
							ClassName = "BillboardGui",
							Properties = {
								Active = false,
								Adornee = Object,
								AlwaysOnTop = true,
								LightInfluence = 0,
								ResetOnSpawn = false,
								Size = UDim2.new(LargestAxis,0,LargestAxis,0)
							}
						},
						{
							Name = "Main",
							Parent = "ExtrasensoryPerceptionHolder",
							ClassName = "Frame",
							Properties = {
								Size = UDim2.new(1,0,1,0),
								BackgroundColor3 = ({
									Gun = Color3.new(.5,0,1),
									Hero = Color3.new(1,1,0),
									Sheriff = Color3.new(0,0,1),
									Innocent = Color3.new(0,1,0),
									Murderer = Color3.new(1,0,0),
								})[Role]
							}
						},
						{
							Name = "Gradient",
							Parent = "Main",
							ClassName = "UIGradient",
							Properties = {
								Rotation = 90,
								Transparency = NumberSequence.new(0,1)
							}
						},
						{
							Name = "Corner",
							Parent = "Main",
							ClassName = "UICorner",
							Properties = {
								CornerRadius = UDim.new(.5,0)
							}
						}
					})
				end
			}
		}
	},
	_6755746130 = {
		AutoFarm_autoplay_autop_autof_farm_af = {
			Function = function(Variables,Enabled)
				if not Assert(not (Variables.Enabled and Enabled),"Auto-farm is already enabled",not (not Variables.Enabled and not Enabled),"Auto-farm is already disabled") then
					return
				end
				if Enabled then
					Variables.AvoidZones = NewInstance("Folder",workspace)
					for _,X in next,{
						94.1,
						-49.9,
						238.1,
						382.1,
						-193.9,
						-337.9,
						-481.9,
					} do
						Create{
							{
								Name = "AvoidPart",
								Parent = Variables.AvoidZones,
								ClassName = "Part",
								Properties = {
									Anchored = true,
									Transparency = 1,
									CanCollide = false,
									Size = Vector3.new(12.2,10,24),
									Position = Vector3.new(X,5,-12)
								}
							},
							{
								Name = "AvoidPathfinding",
								Parent = "AvoidPart",
								ClassName = "PathfindingModifier"
							}
						}
					end
					for _,Killbrick in next,Variables.Killbricks:GetChildren() do
						Killbrick.CanTouch = false
					end
					Variables.Debounce = false
					Variables.Connection = Connect(Service"Run".Stepped,function()
						if not Variables.Debounce then
							Variables.Debounce = true
							if not Valid.Instance(Variables.OwnedTycoon.Value,"Model") then
								for _,Tycoon in next,Variables.Tycoons:GetChildren() do
									if not Valid.Instance(Tycoon:WaitForChild"Owner".Value,"Player") then
										Variables:WalkTo(Tycoon:WaitForChild"Essentials":WaitForChild"Entrance".Position)
									end
								end
							end
							if not Valid.Instance(Variables.Tycoon,"Model") then
								Variables.Tycoon = Variables.OwnedTycoon.Value
								Variables.Essentials = Variables.Tycoon:WaitForChild"Essentials"
								Variables.HolderPosition = Variables.Essentials:WaitForChild"FruitHolder":WaitForChild"HolderBottom".Position
								Variables.JuicePosition = Variables.Essentials:WaitForChild"JuiceMaker":WaitForChild"StartJuiceMakerButton".Position+Vector3.new(5,0,0)
								Variables.JuicePrompt = Variables.Essentials.JuiceMaker.StartJuiceMakerButton:WaitForChild"PromptAttachment":WaitForChild"StartPrompt"
								Variables.PlayerGui = Owner:WaitForChild"PlayerGui"
								Variables.Drops = Variables.Tycoon:WaitForChild"Drops"
								Variables.Buttons = Variables.Tycoon:WaitForChild"Buttons"
								Variables.Purchased = Variables.Tycoon:WaitForChild"Purchased"
							end
							if Variables.Purchased:FindFirstChild"Golden Tree Statue" then
								Variables:WalkTo(Variables.Purchased["Golden Tree Statue"].StatueBottom.Position)
								if fireproximityprompt then
									fireproximityprompt(Variables.Purchased["Golden Tree Statue"].StatueBottom.PrestigePrompt)
								elseif keypress then
									keypress(69)
									task.defer(keyrelease,69)
								end
								Wait(3)
							end
							if not Variables.Purchased:FindFirstChild"Auto Collector" then
								for _,Drop in next,Variables.Drops:GetChildren() do
									if (Drop.Position-Variables.HolderPosition).Magnitude < 5 then
										Variables.CollectFruit:FireServer(Drop)
									end
								end
							end
							if Variables.PlayerGui:FindFirstChild"ObbyInfoBillBoard" and Variables.PlayerGui.ObbyInfoBillBoard:FindFirstChild"TopText" and Variables.PlayerGui.ObbyInfoBillBoard.TopText.Text == "Start Obby" then
								Variables:WalkTo(Vector3.new(0,1,408))
								Wait(1.5)
							end
							if Variables.Money.Value < 1e5 then
								Variables:WalkTo(Variables.JuicePosition)
								if fireproximityprompt then
									fireproximityprompt(Variables.JuicePrompt)
								elseif keypress then
									keypress(69)
									task.defer(keyrelease,69)
								end
								Wait(.25)
							end
							local LowestPrice,ChosenButton = math.huge,nil
							for _,Button in next,Variables.Buttons:GetChildren() do
								Button.CanTouch = false
								local Price = tonumber((Button:WaitForChild"ButtonLabel":WaitForChild"CostLabel".Text:gsub("%D",""))) or 0
								if Price <= Variables.Money.Value and Price < LowestPrice then
									LowestPrice,ChosenButton = Price,Button
								end
							end
							if ChosenButton then
								ChosenButton.CanTouch = true
								Variables:WalkTo(ChosenButton.Position)
								Wait(.5)
							end
							Variables.Debounce = false
						end
					end)
					AddConnections{
						Variables.Connection
					}
					Variables.Enabled = true
				else
					Destroy(Variables.AvoidZones)
					for _,Killbrick in next,Variables.Killbricks:GetChildren() do
						Killbrick.CanTouch = true
					end
					RemoveConnections{
						Variables.Connection
					}
					Variables.Enabled = false
				end
			end,
			Arguments = {
				{
					Name = "Enable",
					Type = "Boolean",
					Substitute = true
				}
			},
			Variables = game.PlaceId == 6755746130 and {
				CollectFruit = Service"ReplicatedStorage":WaitForChild"CollectFruit",
				Killbricks = workspace:WaitForChild"ObbyParts":WaitForChild"Killbricks",
				Money = Owner:WaitForChild"leaderstats":WaitForChild"Money",
				OwnedTycoon = Owner:WaitForChild"OwnedTycoon",
				Tycoons = workspace:WaitForChild"Tycoons",
				Path = Service"Pathfinding":CreatePath{
					AgentRadius = 3,
					WaypointSpacing = math.huge,
					Costs = {
						AvoidZones = math.huge
					}
				},
				WalkTo = function(Variables,Position)
					local Success,Error = pcall(Variables.Path.ComputeAsync,Variables.Path,workspace.CurrentCamera.Focus.Position,Position)
					if Success and Variables.Path.Status.Name == "Success" then
						local Humanoid = GetHumanoid(Owner)
						if Humanoid then
							for _,InflectionPoint in next,Variables.Path:GetWaypoints() do
								if InflectionPoint.Action.Name == "Walk" then
									repeat
										Humanoid:MoveTo(InflectionPoint.Position)
									until Wait(Humanoid.MoveToFinished) == true
								else
									Wait(Service"Run".RenderStepped)
									Humanoid.Jump = true
								end
							end
						end
					end
				end
			}
		}
	}
})[("_%d"):format(game.PlaceId)] or {} do
	Commands[Replace] = Info
end
local function GetContentText(String)
	local CheckTextBox = NewInstance("TextBox",nil,{
		Text = String,
		RichText = true
	})
	Destroy(CheckTextBox)
	return CheckTextBox.ContentText
end
local IgnoreUpdate
local function UpdateSuggestions()
	if Service"UserInput":GetFocusedTextBox() == Gui.CommandBar and not IgnoreUpdate then
		IgnoreUpdate = true
		Gui.CommandBar.Text = Gui.CommandBar.Text:gsub("^%W+","")
		IgnoreUpdate = false
		local Command = Gui.CommandBar.Text:split(OwnerSettings.CommandSeperator)
		Command = ((Command[#Command] or ""):split(OwnerSettings.ArgumentSeperator)[1] or ""):lower()
		Gui.SuggestionsScroll.CanvasSize = UDim2.new()
		for _,TextLabel in next,Gui.SuggestionsScroll:GetChildren() do
			if TextLabel:IsA"TextLabel" then
				Destroy(TextLabel)
			end
		end
		local CommandDisplays = {}
		for CommandNames,CommandInfo in next,Commands do
			CommandNames = CommandNames:split"_"
			for _,CommandName in next,CommandNames do
				if CommandName:lower():find((Command:gsub("%p",function(Punctuation)
					return ("%%%s"):format(Punctuation)
				end))) then
					table.insert(CommandDisplays,("%s<i>%s</i>"):format(CommandNames[1],CommandInfo.Arguments and (function()
						local Arguments = {}
						for _,ArgumentInfo in next,CommandInfo.Arguments do
							table.insert(Arguments,(ArgumentInfo.Required and "%s:%s" or "<font color = '#A0A0A0'>%s:%s</font>"):format(ArgumentInfo.Name,ArgumentInfo.Type))
						end
						return ("%s%s"):format(OwnerSettings.ArgumentSeperator,table.concat(Arguments,OwnerSettings.ArgumentSeperator))
					end)() or ""))
					break
				end
			end
		end
		table.sort(CommandDisplays,function(String1,String2)
			return Service"Text":GetTextSize(GetContentText(String1),14,Enum.Font.Arial,Vector2.new(1e6,1e6)).X < Service"Text":GetTextSize(GetContentText(String2),14,Enum.Font.Arial,Vector2.new(1e6,1e6)).X and true or false
		end)
		for _,Text in next,CommandDisplays do
			NewInstance("TextLabel",Gui.SuggestionsScroll,{
				Text = Text,
				TextSize = 14,
				RichText = true,
				Font = Enum.Font.Arial,
				BackgroundTransparency = 1,
				TextStrokeTransparency = .8,
				TextColor3 = Color3.new(1,1,1),
				TextXAlignment = Enum.TextXAlignment.Left
			})
		end
		local CommandNumber = #Gui.SuggestionsScroll:GetChildren()-1
		Gui.SuggestionsScroll.CanvasSize = UDim2.new(0,0,0,20*CommandNumber)
		ResizeMain(nil,0 < CommandNumber and 48+20*math.min(CommandNumber,5) or 40)
	end
end
local EnableDrag
local function CreateWindow(Settings)
	Settings = Valid.Table(Settings,{
		Title = "Ultimatum",
		Content = {
			"(no content)"
		}
	})
	local Window = Create{
		{
			Name = "Main",
			Parent = Gui.Holder,
			ClassName = "Frame",
			Properties = {
				Size = UDim2.new(0,500,0,250),
				Position = UDim2.new(.5,0,1,125),
				AnchorPoint = Vector2.new(.5,.5),
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
			Name = "Title",
			Parent = "Main",
			ClassName = "TextLabel",
			Properties = {
				TextSize = 14,
				Text = Settings.Title,
				BackgroundTransparency = 1,
				Font = Enum.Font.ArialBold,
				Size = UDim2.new(1,-45,0,20),
				Position = UDim2.new(0,5,0,0),
				TextColor3 = Color3.new(1,1,1),
				TextXAlignment = Enum.TextXAlignment.Left
			}
		},
		{
			Name = "TitleGradient",
			Parent = "Title",
			ClassName = "UIGradient",
			Properties = {
				Transparency = NumberSequence.new{
					NumberSequenceKeypoint.new(0,0),
					NumberSequenceKeypoint.new(.95,0),
					NumberSequenceKeypoint.new(1,1)
				}
			}
		},
		{
			Name = "Exit",
			Parent = "Main",
			ClassName = "TextButton",
			Properties = {
				Text = "x",
				Modal = true,
				TextSize = 40,
				AutoButtonColor = false,
				Font = Enum.Font.Nunito,
				BackgroundTransparency = 1,
				Size = UDim2.new(0,20,0,20),
				TextColor3 = Color3.new(1,1,1),
				Position = UDim2.new(1,-20,0,0)
			}
		},
		{
			Name = "Minimize",
			Parent = "Main",
			ClassName = "TextButton",
			Properties = {
				Text = "-",
				Modal = true,
				TextSize = 40,
				Font = Enum.Font.Arial,
				AutoButtonColor = false,
				BackgroundTransparency = 1,
				Size = UDim2.new(0,20,0,20),
				TextColor3 = Color3.new(1,1,1),
				Position = UDim2.new(1,-40,0,0)
			}
		}
	}
	--[[for _,Line in next,Settings.Content) do

	end]]
end
CreateWindow()
Connections = {
	not GlobalEnvironment.UltimatumDebug and isfile and Connect(Service"Run".Heartbeat,function()
		if OwnerSettings.AutoUpdate and 60 < os.clock()-LastCheck then
			LastCheck = os.clock()
			local Success,Result = pcall(game.HttpGet,game,"https://raw.githubusercontent.com/Amourousity/Ultimatum/main/Source.lua",true)
			if Success and (not isfile"Source.Ultimatum" or Result ~= readfile"Source.Ultimatum") then
				writefile("Source.Ultimatum",Result)
				Notify{
					Yields = true,
					Duration = .75,
					CalculateDuration = false,
					Title = "Update Detected",
					Text = "Ultimatum will now update..."
				}
				local Ultimatum = loadstring(Result,"Ultimatum")
				local Environment = getfenv(Ultimatum)
				Environment.UltimatumStart = os.clock()
				setfenv(Ultimatum,Environment)()
			elseif not Success and not isfile"Source.Ultimatum" then
				Notify{
					Text = Result,
					Urgent = true,
					Title = "Error",
				}
			end
		end
	end),
	not GlobalEnvironment.UltimatumDebug and queue_on_teleport and Connect(Owner.OnTeleport,isfile and function(TeleportState)
		if OwnerSettings.LoadOnRejoin and TeleportState.Name == "Started" then
			queue_on_teleport(isfile"Source.Ultimatum" and readfile"Source.Ultimatum" or "warn'Source.Ultimatum missing from workspace folder (Ultimatum cannot run)'")
		end
	end or function(TeleportState)
		if OwnerSettings.LoadOnRejoin and TeleportState.Name == "Started" then
			local Success,Result = pcall(game.HttpGet,game,"https://raw.githubusercontent.com/Amourousity/Ultimatum/main/Source.lua",true)
			queue_on_teleport(Success and Result or ("warn'HttpGet failed: %s (Ultimatum cannot run)'"):format(Result))
		end
	end),
	Connect(Service"UserInput".WindowFocused,function()
		Focused = true
	end),
	Connect(Service"UserInput".WindowFocusReleased,function()
		Focused = false
	end),
	Connect(Gui.Main.MouseEnter,function()
		if not Debounce then
			LastLeft = os.clock()
			ResizeMain()
		end
	end),
	Connect(Gui.Main.MouseLeave,function()
		if not Debounce then
			LastLeft = os.clock()
			Wait(1)
			if 1 < os.clock()-LastLeft and not Debounce then
				ResizeMain(40)
			end
		end
	end),
	Connect(Gui.CommandBar.Focused,function()
		if not Debounce then
			Debounce = true
			Gui.CommandBar.PlaceholderText = "Enter a command..."
			ResizeMain()
			task.delay(.25,UpdateSuggestions)
		end
	end),
	Connect(Gui.CommandBar.FocusLost,function(Sent)
		Wait()
		Gui.CommandBar.PlaceholderText = ("Enter a command (Keybind:\226\128\138%s\226\128\138)"):format(Service"UserInput":GetStringForKeyCode(Enum.KeyCode[OwnerSettings.Keybind]))
		if Sent and 0 < #Gui.CommandBar.Text then
			task.spawn(RunCommand,Gui.CommandBar.Text)
			Gui.CommandBar.Text = ""
		elseif Service"UserInput":IsKeyDown(Enum.KeyCode.Escape) then
			Gui.CommandBar.Text = ""
		end
		ResizeMain()
		task.delay(.25,function()
			if Service"UserInput":GetFocusedTextBox() ~= Gui.CommandBar then
				ResizeMain(40)
			end
		end)
		Debounce = false
	end),
	Connect(Service"UserInput".InputBegan,function(Input,Ignore)
		if not Ignore and Input.UserInputType.Name == "Keyboard" and Input.KeyCode.Name == OwnerSettings.Keybind and not Debounce then
			task.defer(Gui.CommandBar.CaptureFocus,Gui.CommandBar)
		end
	end),
	Connect(Gui.CommandBar:GetPropertyChangedSignal"Text",UpdateSuggestions)
}
EnableDrag = function(Frame,IsMain)
	local DragConnection
	local FinalPosition,OldEnabled = UDim2.new()
	local InputBegan,InputEnded,Removed = Connect(Frame.InputBegan,function(Input,Ignore)
		if not Ignore and not Debounce and Input.UserInputType.Name == "MouseButton1" then
			if IsMain then
				ResizeMain(40)
			end
			Debounce = true
			OldEnabled = Service"UserInput".MouseIconEnabled
			DragConnection = Connect(Service"Run".RenderStepped,function()
				Service"UserInput".MouseIconEnabled = false
				local MousePosition = Service"UserInput":GetMouseLocation()
				local ScreenSize,CardSize = workspace.CurrentCamera.ViewportSize,Frame.AbsoluteSize
				local NewPosition = OwnerSettings.EdgeDetect ~= "None" and Vector2.new(math.clamp(MousePosition.X,math.floor(CardSize.X/2),math.ceil(ScreenSize.X-CardSize.X/2)),math.clamp(MousePosition.Y,math.floor(CardSize.Y/2),math.ceil(ScreenSize.Y-CardSize.Y/2))) or MousePosition
				if NewPosition ~= MousePosition then
					if OwnerSettings.EdgeDetect == "GuiAndMouse" and mousemoverel and Focused then
						mousemoverel(NewPosition.X-MousePosition.X,NewPosition.Y-MousePosition.Y)
					end
					MousePosition = NewPosition
				end
				FinalPosition = UDim2.new(math.round(MousePosition.X-CardSize.X/2)/ScreenSize.X,0,math.round(MousePosition.Y-CardSize.Y/2)/ScreenSize.Y,0)
				Animate(Frame,{
					Time = 0,
					Properties = {
						Position = FinalPosition
					}
				})
			end)
			AddConnections{
				DragConnection
			}
		end
	end),Connect(Service"UserInput".InputEnded,function(Input)
		if DragConnection and Input.UserInputType.Name == "MouseButton1" then
			Service"UserInput".MouseIconEnabled = OldEnabled
			RemoveConnections{
				DragConnection
			}
			DragConnection = nil
			Debounce = false
			if IsMain then
				ResizeMain()
			end
		end
	end)
	Removed = Connect(Frame.AncestryChanged,function()
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
pcall(GlobalEnvironment.Ultimatum)
GlobalEnvironment.Ultimatum = function()
	--- @diagnostic disable-next-line undefined-global
	Destroy(Connections,Gui,protect_gui and gethui())
	GlobalEnvironment.Ultimatum = nil
end
EnableDrag(Gui.Main,true)
UltimatumStart = os.clock()-UltimatumStart
if not GlobalEnvironment.UltimatumLoaded then
	print((("!!_5#_4#_#_4#9_#9_#2_4#2_6#_#9_#_4#_#2_4#2!_4#_4#_#_8#_9#_5#4_#4_3#_#_3#_5#_4#_#4_#4!_3#_4#_#_8#_9#_5#_#3_#_2#_3#_2#_5#_4#_#_#3_#!_2#_4#_#_8#_9#_5#_2#_2#_#9_#_5#_4#_#_2#_2#!_#_4#_#_8#_9#_5#_7#_#_5#_#_5#_4#_#_7#!#_4#_#_8#_9#_5#_7#_#_5#_#_5#_4#_#_7#!#6_2#8_#_5#9_#_7#_#_5#_#_6#6_2#_7#!"):gsub("%p%d?",function(Input)
		for Character,Format in next,{
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
if OwnerSettings.PlayIntro == "Always" or OwnerSettings.PlayIntro == "Once" and not GlobalEnvironment.UltimatumLoaded then
	GlobalEnvironment.UltimatumLoaded = true
	if OwnerSettings.Blur then
		Service"Run":SetRobloxGuiFocused(true)
		task.delay(1.5,Service"Run".SetRobloxGuiFocused,Service"Run",false)
	end
	Animate(Gui.Main,{
		Yields = true,
		Properties = {
			Position = UDim2.new(.5,0,.5,0),
			BackgroundTransparency = 0
		}
	},Gui.Logo,{
		Properties = {
			ImageTransparency = 0,
			Rotation = 0
		}
	},Gui.MainCorner,{
		Yields = true,
		Properties = {
			CornerRadius = UDim.new(0,4)
		},
		FinishDelay = .5
	},Gui.Main,{
		Properties = {
			Rotation = 180,
			Size = UDim2.new()
		},
		EasingStyle = Enum.EasingStyle.Back,
		EasingDirection = Enum.EasingDirection.In
	},Gui.MainCorner,{
		Properties = {
			CornerRadius = UDim.new(.5,0)
		}
	},Gui.Logo,{
		Yields = true,
		Properties = {
			ImageTransparency = 1
		}
	})
else
	GlobalEnvironment.UltimatumLoaded = true
end
for Name,Properties in next,{
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
	for Property,Value in next,Properties do
		Gui[Name][Property] = Value
	end
end
ResizeMain(40)
Animate(Gui.Main,{
	Yields = true,
	Properties = {
		Position = UDim2.new(0,0,1,-40)
	}
})
Notify{
	Title = "Loaded",
	Text = ("Ultimatum took %s to load"):format(ConvertTime(UltimatumStart))
}
Debounce = false
