   --[[]    [|] [|]    [|||||||||] [|||||||||] [||]    [||]      [|] [|||||||||] [|]    [|] [||]    [||]
    [|]    [|] [|]        [|]         [|]     [||||] [||||]   [|] [|]   [|]     [|]    [|] [||||] [||||]
   [|]    [|] [|]        [|]         [|]     [|] [|||] [|]  [|]   [|]  [|]     [|]    [|] [|] [|||] [|]
  [|]    [|] [|]        [|]         [|]     [|]  [|]  [|] [|||||||||] [|]     [|]    [|] [|]  [|]  [|]
 [|]    [|] [|]        [|]         [|]     [|]       [|] [|]     [|] [|]     [|]    [|] [|]       [|]
[|]    [|] [|]        [|]         [|]     [|]       [|] [|]     [|] [|]     [|]    [|] [|]       [|]
[||||||]  [||||||||] [|]     [|||||||||] [|]       [|] [|]     [|] [|]      [||||||]  [|]       []]
for LibraryName,Interpret in pairs{
	syn = false,
	http = false,
	crypt = false,
	base64 = 'base64%s',
	custom = 'custom_%s',
	cache = 'cache_%s'
} do
	for FunctionName,Function in pairs(getfenv()[LibraryName] or {}) do
		getfenv()[(Interpret or '%s'):format(FunctionName)] = Function
	end
end
do
	local DebugBlacklist = {
		'info',
		'traceback',
		'profileend',
		'profilebegin',
		'setmemorycategory',
		'resetmemorycategory'
	}
	for FunctionName,Function in pairs(debug) do
		if not table.find(DebugBlacklist,FunctionName) then
			getfenv()[getfenv()[FunctionName] and ('debug_%s'):format(FunctionName) or FunctionName] = Function
		end
	end
end
local Nil,Delta,LastFrame = {},10,os.clock()
local Services = setmetatable({},{
	__index = function(Services,ServiceName)
		assert(pcall(game.GetService,game,ServiceName),('Ultimatum | Invalid ServiceName (%s "%s")'):format(typeof(ServiceName),tostring(ServiceName)))
		if not rawget(Services,ServiceName) or rawget(Services,ServiceName) ~= game:GetService(ServiceName) then
			rawset(Services,ServiceName,game:GetService(ServiceName))
		end
		return rawget(Services,ServiceName)
	end,
	__newindex = function() end,
	__metatable = 'nil'
})
for ReplacementFunction,FunctionNames in pairs{
	'getsenv/getmenv',
	'getupval/getupvalue',
	'setupvalue/setupval',
	'getconst/getconstant',
	'getgc/get_gc_objects',
	'setconstant/setconst',
	'getupvals/getupvalues',
	'getconsts/getconstants',
	'isreadonly/is_readonly',
	'consoleclear/rconsoleclear',
	'consoleinput/rconsoleinput',
	'getcustomasset/getsynasset',
	'isrbxactive/iswindowactive',
	'setclipboard/writeclipboard',
	'dumpstring/getscriptbytecode',
	'hookfunction/detour_function',
	'getconnections/get_signal_cons',
	'getrawmetatable/debug_getmetatable',
	'getcallingscript/get_calling_script',
	'getloadedmodules/get_loaded_modules',
	'getscriptclosure/get_script_function',
	'getnamecallmethod/get_namecall_method',
	'consolecreate/createconsole/rconsolecreate',
	'closeconsole/consoledestroy/rconsoledestroy',
	'rconsolename/consolesettitle/rconsolesettitle',
	'getidentity/getthreadcontext/getthreadidentity/get_thread_identity',
	'setidentity/setthreadcontext/setthreadidentity/set_thread_identity',
	'consoleprint/writeconsole/rconsoleprint/rconsoleerr/rconsoleinfo/rconsolewarn',
	'checkclosure/istempleclosure/issentinelclosure/iselectronfunction/is_synapse_function/is_protosmasher_closure',
	--- @diagnostic disable:undefined-global
	[(make_writeable or makewriteable) and function(Table,ReadOnly)
		(ReadOnly and (make_readonly or makereadonly) or (make_writeable or makewriteable))(Table)
	end or 0] = 'setreadonly',
	[hookfunction and getrawmetatable and function(Object,Method,Hook)
		return hookfunction(getrawmetatable(Object)[Method],Hook)
	end or -1] = 'hookmetamethod',
	[(iscclosure or is_c_closure) and function(Closure)
		return not (iscclosure or is_c_closure)(Closure)
	end or -2] = 'islclosure/is_l_closure',
	[protect_gui and (function()
		local HiddenUI = Instance.new'Folder'
		protect_gui(HiddenUI)
		HiddenUI.Parent = Services.CoreGui
		return function()
			return HiddenUI
		end
	end)() or function()
		return Services.CoreGui
	end] = 'gethui/get_hidden_gui'
	--- @diagnostic enable:undefined-global
} do
	FunctionNames = FunctionNames:split'/'
	local Function
	for _,FunctionName in pairs(FunctionNames) do
		Function = getfenv()[FunctionName]
		if Function then
			for _,FunctionName_ in pairs(FunctionNames) do
				getfenv()[FunctionName_] = Function
			end
			break
		end
	end
	if not Function and type(ReplacementFunction) == 'function' then
		for _,FunctionName in pairs(FunctionNames) do
			getfenv()[FunctionName] = ReplacementFunction
		end
	end
end
--- @diagnostic disable-next-line:undefined-global
pcall(Ultimatum)
if not game:IsLoaded() then
	game.Loaded:Wait()
end
local function EscapeTable(Value,Escape)
	if not Escape and Value == nil then
		return nil
	elseif Escape and Value == nil then
		return nil
	end
	return Value
end
local Valid
Valid = {
	String = function(String,Substitute)
		return type(String) == 'string' and String or type(Substitute) == 'string' and Substitute or ''
	end,
	Instance = function(Instance_,ClassName)
		return typeof(Instance_) == 'Instance' and select(2,pcall(game.IsA,Instance_,Valid.String(ClassName,'Instance'))) == true and Instance_ or nil
	end,
	Number = function(Number,Substitute)
		return tonumber(Number) == tonumber(Number) and tonumber(Number) or tonumber(Substitute) == tonumber(Substitute) and tonumber(Substitute) or 0
	end,
	Table = function(Table,Substitute)
		Table = type(Table) == 'table' and Table or {}
		for Index,Value in pairs(type(Substitute) == 'table' and Substitute or {}) do
			Table[Index] = typeof(Table[Index]) == typeof(Value) and Table[Index] or Value
		end
		return Table
	end
}
table.freeze(Valid)
local Randomized = {
	String = function(Settings)
		Settings = Valid.Table(Settings,{
			CharacterSet = {
				NumberRange.new(48,57),
				NumberRange.new(65,90),
				NumberRange.new(97,122)
			},
			Format = '\0%s',
			Length = math.random(5,99)
		})
		local AvailableCharacters = {}
		for _,Set in pairs(Settings.CharacterSet) do
			for Character = Set.Min,Set.Max do
				table.insert(AvailableCharacters,string.char(Character))
			end
		end
		return Settings.Format:format(('A'):rep(Settings.Length):gsub('.',function()
			local Range = Settings.CharacterSet[math.random(1,#Settings.CharacterSet)]
			return string.char(math.random(Range.Min,Range.Max))
		end))
	end,
	Bool = function(Chance)
		return math.random(1,1/Valid.Number(Chance,.5)) == 1
	end
}
table.freeze(Randomized)
local function NewInstance(ClassName,Parent,Properties)
	local NewInstance_ = select(2,pcall(Instance.new,ClassName))
	if typeof(NewInstance_) == 'Instance' then
		Properties = Valid.Table(Properties,{
			Archivable = Randomized.Bool(),
			Name = Randomized.String()
		})
		for Property,Value in pairs(Properties) do
			pcall(function()
				NewInstance_[Property] = EscapeTable(Value)
			end)
		end
		NewInstance_.Parent = typeof(Parent) == 'Instance' and Parent or nil
		return NewInstance_
	end
end
local function Create(Data)
	local Instances = {
		Destroy = function(Instances,Name)
			if type(Name) == 'string' then
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
		Instances[InstanceData.Name] = NewInstance(InstanceData.ClassName,type(InstanceData.Parent) == 'string' and Instances[InstanceData.Parent] or InstanceData.Parent,InstanceData.Properties)
	end
	return Instances
end
local Gui = Create{
	{
		Name = 'Holder',
		ClassName = 'ScreenGui',
		Parent = gethui(),
		Properties = {
			DisplayOrder = 0x7FFFFFFF,
			IgnoreGuiInset = true,
			OnTopOfCoreBlur = true,
			ResetOnSpawn = false,
			ZIndexBehavior = Enum.ZIndexBehavior.Global
		}
	},
	{
		Name = 'Main',
		ClassName = 'Frame',
		Parent = 'Holder',
		Properties = {
			AnchorPoint = Vector2.new(.5,.5),
			BackgroundColor3 = Color3.fromHex'505064',
			BackgroundTransparency = 1,
			Position = UDim2.new(.5,0,.4,0),
			Size = UDim2.new(0,100,0,100)
		}
	},
	{
		Name = 'MainCorner',
		ClassName = 'UICorner',
		Parent = 'Main',
		Properties = {
			CornerRadius = UDim.new(.5,0)
		}
	},
	{
		Name = 'MainGradient',
		ClassName = 'UIGradient',
		Parent = 'Main',
		Properties = {
			Color = ColorSequence.new(Color3.new(1,1,1),Color3.new(.5,.5,.5)),
			Rotation = 90
		}
	},
	{
		Name = 'Logo',
		ClassName = 'ImageLabel',
		Parent = 'Main',
		Properties = {
			BackgroundTransparency = 1,
			Image = getcustomasset and getcustomasset('UltimatumLogo.png',false) or 'rbxassetid://9666094136',
			ImageTransparency = 1,
			Position = UDim2.new(0,10,0,10),
			Rotation = 90,
			Size = UDim2.new(0,80,0,80)
		}
	}
}
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
local function Notify(Settings)
	Settings = Valid.Table(Settings,{
		Text = '(no text)',
		Title = 'Ultimatum',
		Buttons = {},
		Duration = 5,
		CalculateDuration = false
	})
	if Settings.CalculateDuration then
		local Length = 0
		for _,Name in pairs{
			'Title',
			'Text'
		} do
			for _ in utf8.graphemes(Settings[Name]) do
				Length += 1
			end
		end
		Settings.Duration += Length*.06
	end
	Create{
		Name = 'Main',
		ClassName = 'Frame',
		Parent = Gui.Holder,
		Properties = {
			AnchorPoint = Vector2.xAxis,
			Position = UDim2.new(1,0,0,0)
		}
	}
end
local LastCheck,Focused,Debounce = 0,isrbxactive and isrbxactive() or true,true
local Connections = {
	isfile and Services.RunService.Heartbeat:Connect(function()
		Delta,LastFrame = (os.clock()-LastFrame)*60,os.clock()
		if 60 < os.clock()-LastCheck then
			LastCheck = os.clock()
			local Reload
			for _,FileName in pairs{
				'Logo.png',
				'Source.lua',
				'Version.ver'
			} do
				local Success,Result = pcall(game.HttpGet,game,('https://raw.githubusercontent.com/Amourousity/Ultimatum/main/%s'):format(FileName),true)
				if Success and (not isfile(('Ultimatum%s'):format(FileName)) or Result:gsub('%s','') ~= readfile(('Ultimatum%s'):format(FileName)):gsub('%s','')) then
					writefile(('Ultimatum%s'):format(FileName),Result)
					Reload = true
				elseif not Success and not isfile(('Ultimatum%s'):format(FileName)) then
					if consoleprint then
						consoleprint'@@YELLOW@@'
						consoleprint(('\nUltimatum | %s'):format(Result))
						consoleprint'@@WHITE@@'
					else
						warn('Ultimatum |',Result)
					end
				end
			end
			if Reload then
				loadstring(readfile'UltimatumSource.lua','Ultimatum')()
			end
		end
	end) or Services.RunService.Heartbeat:Connect(function()
		Delta,LastFrame = (os.clock()-LastFrame)*60,os.clock()
	end),
	queue_on_teleport and readfile and Services.Players.LocalPlayer.OnTeleport:Connect(function(TeleportState)
		if TeleportState == Enum.TeleportState.Started then
			queue_on_teleport(readfile'UltimatumSource.lua')
		end
	end),
	Services.UserInputService.WindowFocused:Connect(function()
		Focused = true
	end),
	Services.UserInputService.WindowFocusReleased:Connect(function()
		Focused = false
	end)
}
local function DeltaLerp(Start,Goal,Alpha)
	return type(Start) == 'number' and type(Goal) == 'number' and Goal+(Start-Goal)*math.clamp((1-Alpha)^Delta,0,1) or Goal:Lerp(Start,math.clamp((1-Alpha)^Delta,0,1))
end
---@diagnostic disable-next-line: unused-function
local function EnableDrag(Frame)
	local DragConnection
	local FinalPosition = UDim2.new()
	local InputBegan,InputEnded,Removed = Frame.InputBegan:Connect(function(Input,Ignore)
		if not Ignore and not Debounce and Input.UserInputType == Enum.UserInputType.MouseButton1 then
			DragConnection = Services.RunService.RenderStepped:Connect(function()
				local MousePosition = Services.UserInputService:GetMouseLocation()
				local ScreenSize,CardSize = workspace.CurrentCamera.ViewportSize,Frame.AbsoluteSize
				local XVelocity = MousePosition.X-(Frame.AbsolutePosition.X+CardSize.X/2)
				local NewMousePosition = Vector2.new(math.clamp(MousePosition.X,CardSize.X/2,ScreenSize.X-CardSize.X/2),math.clamp(MousePosition.Y,CardSize.Y/2,ScreenSize.Y-CardSize.Y/2))
				if NewMousePosition ~= MousePosition then
					MousePosition = NewMousePosition
					if mousemoveabs and Focused then
						mousemoveabs(0,0)
						mousemoverel(MousePosition.X,MousePosition.Y)
					end
				end
				FinalPosition = UDim2.fromScale((MousePosition.X-CardSize.X/2)/ScreenSize.X,(MousePosition.Y-CardSize.Y/2)/ScreenSize.Y)
				Frame.Position = DeltaLerp(Frame.Position,FinalPosition,.5)
				Frame.Rotation = DeltaLerp(math.abs(Frame.Rotation) < .1 and 0 or Frame.Rotation,0,.5)+math.clamp(XVelocity/(.065*CardSize.X),-1500/CardSize.X,1500/CardSize.X)
			end)
			table.insert(Connections,DragConnection)
		end
	end),Services.UserInputService.InputEnded:Connect(function(Input,Ignore)
		if DragConnection and Input.UserInputType == Enum.UserInputType.MouseButton1 then
			DragConnection:Disconnect()
			table.remove(Connections,table.find(Connections,DragConnection))
			DragConnection = nil
			Animate(Frame,{
				Time = .1,
				Properties = {
					Rotation = 0,
					Position = FinalPosition
				}
			})
		end
	end)
	Removed = Frame.AncestryChanged:Connect(function()
		if not Frame:IsDescendantOf(gethui()) then
			for _,Connection in pairs{
				Removed,
				InputEnded,
				InputBegan,
				DragConnection
			} do
				pcall(Connection.Disconnect,Connection)
				table.remove(Connections,table.find(Connections,Connection))
			end
		end
	end)
end
--[[local function GetHumanoid(Target)
	Target = ValidInstance(Target,'Model') or ValidInstance(Target,'Player') and (Target.Character or Target.CharacterAdded:Wait())
	if Target then
		return Target:FindFirstChildOfClass'Humanoid'
	end
end
local Commands
Commands = {
	['SpoofWalkSpeed/SpoofWS/HookWalkSpeed/HookWS'] = function()
		local Humanoid = Owner.Character.Humanoid
		local FakeWalkSpeed = Humanoid.WalkSpeed
		local OldIndex,OldNewIndex
		OldIndex = hookmetamethod(game,'__index',function(...)
			if not checkcaller() and ... == Humanoid and select(2,...) == 'WalkSpeed' then
				return FakeWalkSpeed
			end
			return OldIndex(...)
		end)
		Humanoid.WalkSpeed = 100
		OldNewIndex = hookmetamethod(game,'__newindex',function(...)
			if not checkcaller() and ... == Humanoid and select(2,...) == 'WalkSpeed' then
				FakeWalkSpeed = tonumber(select(3,...)) or 0
				return
			end
			return OldNewIndex(...)
		end)
	end
}]]
do
	local ScriptEnvironment = getgenv and getgenv() or shared
	ScriptEnvironment.Ultimatum = function()
		for _,Connection in pairs(Connections) do
			pcall(Connection.Disconnect,Connection)
		end
		ScriptEnvironment.Ultimatum = nil
		Gui:Destroy()
		--- @diagnostic disable-next-line:undefined-global
		if protect_gui then
			pcall(game.Destroy,gethui())
		end
	end
end
print'\
     [|]    [|] [|]    [|||||||||] [|||||||||] [||]    [||]      [|] [|||||||||] [|]    [|] [||]    [||]\
    [|]    [|] [|]        [|]         [|]     [||||] [||||]   [|] [|]   [|]     [|]    [|] [||||] [||||]\
   [|]    [|] [|]        [|]         [|]     [|] [|||] [|]  [|]   [|]  [|]     [|]    [|] [|] [|||] [|]\
  [|]    [|] [|]        [|]         [|]     [|]  [|]  [|] [|||||||||] [|]     [|]    [|] [|]  [|]  [|]\
 [|]    [|] [|]        [|]         [|]     [|]       [|] [|]     [|] [|]     [|]    [|] [|]       [|]\
[|]    [|] [|]        [|]         [|]     [|]       [|] [|]     [|] [|]     [|]    [|] [|]       [|]\
[||||||]  [||||||||] [|]     [|||||||||] [|]       [|] [|]     [|] [|]      [||||||]  [|]       [|]\
'
EnableDrag(Gui.Main)
Animate(Gui.Main,{
	Properties = {
		Position = UDim2.new(.5,0,.5,0),
		BackgroundTransparency = 0
	},
	Time = .5,
	Yields = true
})
Animate(Gui.Logo,{
	Properties = {
		ImageTransparency = 0,
		Rotation = 0
	},
	Time = .5
})
Animate(Gui.MainCorner,{
	Properties = {
		CornerRadius = UDim.new(0,5)
	},
	Time = .5,
	Yields = true
})
task.wait(.5)
Animate(Gui.Main,{
	EasingDirection = Enum.EasingDirection.In,
	EasingStyle = Enum.EasingStyle.Back,
	Properties = {
		Rotation = 180,
		Size = UDim2.new()
	},
	Time = .5
})
Animate(Gui.MainCorner,{
	Properties = {
		CornerRadius = UDim.new(.5,0)
	},
	Time = .5
})
Animate(Gui.Logo,{
	Properties = {
		ImageTransparency = 1
	},
	Time = .5,
	Yields = true
})
for Name,Properties in pairs{
	Main = {
		Rotation = 0,
		Size = UDim2.new(0,35,0,35),
		Position = UDim2.new(0,-17.5,1,0),
		AnchorPoint = Vector2.zero
	},
	MainCorner = {
		CornerRadius = UDim.new(0,5)
	},
	Logo = {
		ImageTransparency = 0,
		Position = UDim2.new(0,5,0,5),
		Size = UDim2.new(0,25,0,25)
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
	Properties = {
		Position = UDim2.new(0,0,1,-35)
	},
	Time = .5
})
Debounce = false
