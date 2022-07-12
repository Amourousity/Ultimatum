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
		for Count,Path in pairs(Paths) do
			Path = Path:split"."
			Function = Environment[Path[1]]
			for Depth = 2,#Path do
				if Function then
					Function = Function[Path[Depth]]
				end
			end
			if Function or Replacement and Count == #Paths then
				for _,NewPathName in pairs(Paths) do
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
	for _,FunctionNames in pairs{
		"getsenv,getmenv",
		"getreg,getregistry",
		"getgc,get_gc_objects",
		"getinfo,debug.getinfo",
		"isreadonly,is_readonly",
		"getproto,debug.getproto",
		"getstack,debug.getstack",
		"setstack,debug.setstack",
		"getprotos,debug.getprotos",
		"consoleclear,rconsoleclear",
		"consoleinput,rconsoleinput",
		"getcustomasset,getsynasset",
		"isrbxactive,iswindowactive",
		"dumpstring,getscriptbytecode",
		"hookfunction,detour_function",
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
	for Paths,Replacement in pairs{
		setreadonly = (make_writeable or makewriteable) and function(Table,ReadOnly)
			(ReadOnly and (make_readonly or makereadonly) or (make_writeable or makewriteable))(Table)
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
								pcall(game.Destroy,TestPart)
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
		end)() or 0
	} do
		CheckCompatibility(Paths,type(Replacement) == "function" and Replacement or nil)
	end
	--- @diagnostic enable undefined-global
end
local GlobalEnvironment = getgenv and getgenv() or shared
pcall(GlobalEnvironment.Ultimatum)
local Nil = {}
local Destroy
do
	local DestroyInstance = game.Destroy
	Destroy = function(...)
		for _,Object in pairs{
			...
		} do
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
	end
end
local Services = setmetatable({},{
	__index = function(Services,ServiceName)
		(GlobalEnvironment.UltimatumDebug and assert or function() end)(pcall(game.GetService,game,ServiceName),("Ultimatum | Invalid ServiceName (%s '%s')"):format(typeof(ServiceName),tostring(ServiceName)))
		if not rawget(Services,ServiceName) then
			rawset(Services,ServiceName,game:GetService(ServiceName))
		end
		return cloneref and rawget(Services,ServiceName) and cloneref(rawget(Services,ServiceName)) or rawget(Services,ServiceName)
	end,
	__newindex = function() end,
	__metatable = "nil"
})
pcall(GlobalEnvironment.Ultimatum)
local Owner = Services.Players.LocalPlayer
while not Owner do
	Services.Players.PlayerAdded:Wait()
	Owner = Services.Players.LocalPlayer
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
		for Index,Value in pairs(type(Substitute) == "table" and Substitute or {}) do
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
		for Names,Value in pairs{
			true_yes_on_positive_1_i = true,
			false_no_off_negative_0_o = false
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
			return AvailableCharacters[math.random(#AvailableCharacters)]
		end))
	end,
	Bool = function(Chance)
		return math.random(math.round(1/math.min(Valid.Number(Chance,.5),1))) == 1
	end
}
table.freeze(Randomized)
local function NewInstance(ClassName,Parent,Properties)
	local NewObject = select(2,pcall(Instance.new,ClassName))
	if typeof(NewObject) == "Instance" then
		Properties = Valid.Table(Properties,{
			Name = Randomized.String(),
			Archivable = Randomized.Bool()
		})
		for Property,Value in pairs(Properties) do
			pcall(function()
				NewObject[Property] = NilConvert(Value)
			end)
		end
		NewObject.Parent = typeof(Parent) == "Instance" and Parent or nil
		return NewObject
	end
end
local function Create(Data)
	local Instances = {}
	for _,InstanceData in pairs(Valid.Table(Data)) do
		Instances[InstanceData.Name] = NewInstance(InstanceData.ClassName,type(InstanceData.Parent) == "string" and Instances[InstanceData.Parent] or InstanceData.Parent,InstanceData.Properties)
	end
	return Instances
end
local OwnerSettings
do
	local Success,Output = pcall(Services.HttpService.JSONDecode,Services.HttpService,isfile and isfile"Settings.Ultimatum" and readfile"Settings.Ultimatum":gsub("^%bA{","{") or "[]")
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
				for SettingName,SettingValue in pairs(Settings) do
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
	for Type,Functionality in pairs{
		RBXScriptSignal = function()
			Return:Fire(Signal:Wait())
		end,
		["function"] = function()
			local Continue
			repeat
				(function(Success,...)
					if Success and ... then
						Continue = true
						if not Ready then
							task.wait()
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
	return Return.Event:Wait()
end
pcall(GlobalEnvironment.Ultimatum)
if Services.CoreGui:FindFirstChild"RobloxLoadingGui" and Services.CoreGui.RobloxLoadingGui:FindFirstChild"BlackFrame" and Services.CoreGui.RobloxLoadingGui.BlackFrame.BackgroundTransparency <= 0 then
	local Start = os.clock()
	WaitForSignal(Services.CoreGui.RobloxLoadingGui.BlackFrame:GetPropertyChangedSignal"BackgroundTransparency",3)
	task.wait(math.random())
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
			Services.TweenService:Create(Object,TweenInfo.new(Data.Time,Data.EasingStyle,Data.EasingDirection,Data.RepeatCount,Data.Reverses,Data.DelayTime),Data.Properties):Play()
			if Data.Yields then
				task.wait((Data.Time+Data.DelayTime)*(1+Data.RepeatCount))
			end
			if 0 < Data.FinishDelay then
				task.wait(Data.FinishDelay)
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
	local Size = Services.TextService:GetTextSize(Notification.Content.ContentText,14,Enum.Font.Arial,Vector2.new(Gui.NotificationHolder.AbsoluteSize.X,Gui.NotificationHolder.AbsoluteSize.Y))
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
			task.wait()
		until Settings.Duration < os.clock()-Start
		table.remove(NotificationIDs,table.find(NotificationIDs,ID))
	end)
	if Settings.Yields then
		task.wait(Settings.Duration)
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
	MaxYield = Valid.Number(MaxYield)
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
		local Humanoid = Character:FindFirstChildOfClass"Humanoid" or Character.ChildAdded:Wait()
		if Valid.Instance(Humanoid,"Humanoid") then
			return Humanoid
		end
	end,MaxYield)
	if Assert(Humanoid,"The player's humanoid took too long to load") then
		return Humanoid
	end
end
local function ConvertTime(Time)
	for _,Values in pairs{
		{
			31536000000,
			"millennium"
		},
		{
			3153600000,
			"century"
		},
		{
			315360000,
			"decade"
		},
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
	for _,Input in pairs(Text:split(OwnerSettings.CommandSeperator)) do
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
	for Name,Connection in pairs(Valid.Table(GivenConnections)) do
		if typeof(Connection) == "RBXScriptConnection" and Connection.Connected then
			Connections[type(Name) ~= "number" and Name or #Connections+1] = Connection
			table.insert(Connections,Connection)
		end
	end
end
local function RemoveConnections(GivenConnections)
	for _,Connection in pairs(Valid.Table(GivenConnections)) do
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
			Services.RunService:Set3dRenderingEnabled(not Disabled)
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
			if 1 < #Services.Players:GetPlayers() then
				pcall(Services.TeleportService.TeleportToPlaceInstance,Services.TeleportService,game.PlaceId,game.JobId)
			else
				Owner:Kick()
				RunCommand"CloseRobloxMessage"
				Notify{
					Title = "Rejoining",
					Text = "You will be rejoined shortly..."
				}
				task.delay(3,pcall,Services.TeleportService.Teleport,Services.TeleportService,game.PlaceId)
			end
		end,
		Description = "Rejoins the current server you're in"
	},
	CloseRobloxMessage_closerobloxerror_closemessage_closeerror_cmessage_cerror_closermessage_closererror_crobloxmessage_crobloxerror_clearrobloxmessage_clearrobloxerror_clearrerror_clearrmessage_clearmessage_clearerror_cm_crm_cre_ce_closekickmessage_clearkickmessage_clearkick_closekick_ckm_ck_closekickerror_clearkickerror_cke = {
		Function = function()
			Services.GuiService:ClearError()
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
				Variables.Connection = Services.RunService.Heartbeat:Connect(function(Delta)
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
				Result = Services.HttpService:JSONDecode(Result)
				Page,UnfilteredServers = Result.nextPageCursor,Result.data
				if not Assert(0 < #UnfilteredServers,"No servers found") then
					return
				end
				Servers = {}
				for _,ServerInfo in pairs(UnfilteredServers) do
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
			task.delay(2,Services.TeleportService.TeleportToPlaceInstance,Services.TeleportService,game.PlaceId,Server.id)
		end,
		Description = "Joins a random server that you weren't previously in"
	}
}
for Replace,Info in pairs(({
	_142823291 = {
		ExtrasensoryPerception_extrasensoryp_esensoryperception_esperception_extrasp_esp = {
			Function = function(Variables,Enabled)
				if not Assert(not (Variables.Enabled and Enabled),"Extrasensory perception is already enabled",not (not Variables.Enabled and not Enabled),"Extrasensory perception is already disabled") then
					return
				end
				if Enabled then
					Variables.Time,Variables.Connection = os.clock(),Services.RunService.Heartbeat:Connect(function()
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
							for _,Player in pairs(Services.Players:GetPlayers()) do
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
				PlayerDataRemote = game.PlaceId == 142823291 and Services.ReplicatedStorage:WaitForChild"Remotes":WaitForChild"Extras":WaitForChild"GetPlayerData",
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
	}
})[("_%d"):format(game.PlaceId)] or {}) do
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
	if Services.UserInputService:GetFocusedTextBox() == Gui.CommandBar and not IgnoreUpdate then
		IgnoreUpdate = true
		Gui.CommandBar.Text = Gui.CommandBar.Text:gsub("^%W+","")
		IgnoreUpdate = false
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
					table.insert(CommandDisplays,("%s<i>%s</i>"):format(CommandNames[1],CommandInfo.Arguments and (function()
						local Arguments = {}
						for _,ArgumentInfo in pairs(CommandInfo.Arguments) do
							table.insert(Arguments,(ArgumentInfo.Required and "%s:%s" or "<font color = '#A0A0A0'>%s:%s</font>"):format(ArgumentInfo.Name,ArgumentInfo.Type))
						end
						return ("%s%s"):format(OwnerSettings.ArgumentSeperator,table.concat(Arguments,OwnerSettings.ArgumentSeperator))
					end)() or ""))
					break
				end
			end
		end
		table.sort(CommandDisplays,function(String1,String2)
			return Services.TextService:GetTextSize(GetContentText(String1),14,Enum.Font.Arial,Vector2.new(1e6,1e6)).X < Services.TextService:GetTextSize(GetContentText(String2),14,Enum.Font.Arial,Vector2.new(1e6,1e6)).X and true or false
		end)
		for _,Text in pairs(CommandDisplays) do
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
		ResizeMain(nil,0 < CommandNumber and 48+20*CommandNumber or 40)
	end
end
local function CreateWindow(Settings)
	Settings = Valid.Table(Settings,{
		Title = "Ultimatum",
		Content = {
			"(no content)"
		}
	})
	Create{
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
				Transparency = NumberSequence.new(NumberSequenceKeypoint.new(0,0),NumberSequenceKeypoint.new(.95,0),NumberSequenceKeypoint.new(1,1))
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
end
Connections = {
	not GlobalEnvironment.UltimatumDebug and isfile and Services.RunService.Heartbeat:Connect(function()
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
	not GlobalEnvironment.UltimatumDebug and queue_on_teleport and (isfile and Owner.OnTeleport:Connect(function(TeleportState)
		if OwnerSettings.LoadOnRejoin and TeleportState.Name == "Started" then
			queue_on_teleport(isfile"Source.Ultimatum" and readfile"Source.Ultimatum" or "warn'Source.Ultimatum missing from workspace folder (Ultimatum cannot run)'")
		end
	end) or Owner.OnTeleport:Connect(function(TeleportState)
		if OwnerSettings.LoadOnRejoin and TeleportState.Name == "Started" then
			local Success,Result = pcall(game.HttpGet,game,"https://raw.githubusercontent.com/Amourousity/Ultimatum/main/Source.lua",true)
			queue_on_teleport(Success and Result or ("warn'HttpGet failed: %s (Ultimatum cannot run)'"):format(Result))
		end
	end)),
	Services.UserInputService.WindowFocused:Connect(function()
		Focused = true
	end),
	Services.UserInputService.WindowFocusReleased:Connect(function()
		Focused = false
	end),
	Gui.Main.MouseEnter:Connect(function()
		if not Debounce then
			LastLeft = os.clock()
			ResizeMain()
		end
	end),
	Gui.Main.MouseLeave:Connect(function()
		if not Debounce then
			LastLeft = os.clock()
			task.wait(1)
			if 1 < os.clock()-LastLeft and not Debounce then
				ResizeMain(40)
			end
		end
	end),
	Gui.CommandBar.Focused:Connect(function()
		if not Debounce then
			Debounce = true
			Gui.CommandBar.PlaceholderText = "Enter a command..."
			ResizeMain()
			task.delay(.25,UpdateSuggestions)
		end
	end),
	Gui.CommandBar.FocusLost:Connect(function(Sent)
		task.wait()
		Gui.CommandBar.PlaceholderText = ("Enter a command (Keybind:\u{200A}%s\u{200A})"):format(Services.UserInputService:GetStringForKeyCode(Enum.KeyCode[OwnerSettings.Keybind]))
		if Sent and 0 < #Gui.CommandBar.Text then
			task.spawn(RunCommand,Gui.CommandBar.Text)
			Gui.CommandBar.Text = ""
		elseif Services.UserInputService:IsKeyDown(Enum.KeyCode.Escape) then
			Gui.CommandBar.Text = ""
		end
		ResizeMain()
		task.delay(.25,function()
			if Services.UserInputService:GetFocusedTextBox() ~= Gui.CommandBar then
				ResizeMain(40)
			end
		end)
		Debounce = false
	end),
	Services.UserInputService.InputBegan:Connect(function(Input,Ignore)
		if not Ignore and Input.UserInputType.Name == "Keyboard" and Input.KeyCode.Name == OwnerSettings.Keybind and not Debounce then
			task.defer(Gui.CommandBar.CaptureFocus,Gui.CommandBar)
		end
	end),
	Gui.CommandBar:GetPropertyChangedSignal"Text":Connect(UpdateSuggestions)
}
local function EnableDrag(Frame,IsMain)
	local DragConnection
	local FinalPosition,OldEnabled = UDim2.new()
	local InputBegan,InputEnded,Removed = Frame.InputBegan:Connect(function(Input,Ignore)
		if not Ignore and not Debounce and Input.UserInputType.Name == "MouseButton1" then
			if IsMain then
				ResizeMain(40)
			end
			Debounce = true
			OldEnabled = Services.UserInputService.MouseIconEnabled
			DragConnection = Services.RunService.RenderStepped:Connect(function()
				Services.UserInputService.MouseIconEnabled = false
				local MousePosition = Services.UserInputService:GetMouseLocation()
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
	end),Services.UserInputService.InputEnded:Connect(function(Input)
		if DragConnection and Input.UserInputType.Name == "MouseButton1" then
			Services.UserInputService.MouseIconEnabled = OldEnabled
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
if OwnerSettings.PlayIntro == "Always" or OwnerSettings.PlayIntro == "Once" and not GlobalEnvironment.UltimatumLoaded then
	GlobalEnvironment.UltimatumLoaded = true
	if OwnerSettings.Blur then
		Services.RunService:SetRobloxGuiFocused(true)
		task.delay(1.5,Services.RunService.SetRobloxGuiFocused,Services.RunService,false)
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
