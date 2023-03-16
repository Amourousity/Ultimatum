  --[[]    [|] [|]    [|||||||||] [|||||||||] [||]    [||]      [|] [|||||||||] [|]    [|] [||]    [||]
   [|]    [|] [|]        [|]         [|]     [||||] [||||]   [|] [|]   [|]     [|]    [|] [||||] [||||]
  [|]    [|] [|]        [|]         [|]     [|] [|||] [|]  [|]   [|]  [|]     [|]    [|] [|] [|||] [|]
 [|]    [|] [|]        [|]         [|]     [|]  [|]  [|] [|||||||||] [|]     [|]    [|] [|]  [|]  [|]
[|]    [|] [|]        [|]         [|]     [|]       [|] [|]     [|] [|]     [|]    [|] [|]       [|]
[|]  [|]  [|]        [|]         [|]     [|]       [|] [|]     [|] [|]      [|]  [|]  [|]       [|]
[||||]   [||||||||] [|]     [|||||||||] [|]       [|] [|]     [|] [|]       [||||]   [|]       []]

if not game:IsLoaded() then
	game.Loaded:Wait()
end
local function load(name: string)
	local sourceName, success, result =
		`{name}.lua`,
		pcall(game.HttpGet, game, `https://raw.githubusercontent.com/Amourousity/{name}/main/Source.lua`, true)
	if success then
		if writefile then
			writefile(sourceName, result)
		else
			return loadstring(result, name)
		end
	end
	if isfile and isfile(sourceName) then
		return loadstring(readfile(sourceName), name)
	end
end
load("Conversio")()
for name: string, func: (...any) -> ...any in load("Utilitas")({}) do
	getfenv()[name] = func
end
local hiddenGui: Folder | CoreGui = if gethui
	then waitForSignal(function()
		wait()
		return gethui()
	end)
	else service("CoreGui")
local hiddenGuiParent = hiddenGui.Parent
local globalEnvironment = if getgenv then getgenv() else shared
local settings
do
	local defaultSettings = {
		scale = 1,
		stayOpen = false,
		autoUpdate = true,
		loadOnRejoin = true,
		playIntro = "always",
		notifications = "all",
		keybind = "LeftBracket",
	}
	local settingsTable = jsonDecode(
		isfile and isfile("UltimatumSettings.json") and readfile("UltimatumSettings.json"):gsub("^%bA{", "{"),
		defaultSettings
	)
	for settingName in settingsTable do
		if defaultSettings[settingName] == nil then
			settingsTable[settingName] = nil
		end
	end
	settings = setmetatable({}, {
		__index = function(_, index)
			return settingsTable[index]
		end,
		__newindex = function(_, index, value)
			settingsTable[index] = value
			if writefile then
				local formattedSettings = {}
				for settingName, settingValue in settingsTable do
					table.insert(
						formattedSettings,
						`\t{("%q"):format(settingName)}: {if type(settingValue) == "string"
							then ("%q"):format(settingValue)
							else tostring(settingValue)},`
					)
				end
				table.sort(formattedSettings, function(string0, string1)
					if #string0 < #string1 then
						return true
					elseif #string1 < #string0 then
						return false
					end
					string0, string1 = { string0:byte(1, -2) }, { string1:byte(1, -2) }
					for Integer = 1, math.max(#string0, #string1) do
						if (string0[Integer] or -1) < (string1[Integer] or -1) then
							return true
						elseif (string1[Integer] or -1) < (string0[Integer] or -1) then
							return false
						end
					end
					return false
				end)
				formattedSettings[#formattedSettings] = formattedSettings[#formattedSettings]:sub(1, -2)
				writefile(
					"UltimatumSettings.json",
					`All settings for Ultimatum.\n\z
					Do not edit this file unless you know what you're doing.\n\z
					Every setting can be changed in-game using the "Settings" command.\n\z
					\x7B\n{table.concat(
						formattedSettings,
						"\n"
					)}\n\x7D`
				)
			end
		end,
	}) :: {
		_: any,
		scale: number,
		keybind: string,
		stayOpen: boolean,
		autoUpdate: boolean,
		loadOnRejoin: boolean,
		playIntro: "always" | "once" | "never",
		notifications: "all" | "important" | "none",
	}
end
settings._ = nil
local gui = create({
	{
		Name = "Holder",
		ClassName = "ScreenGui",
		Properties = {
			ResetOnSpawn = false,
			IgnoreGuiInset = true,
			OnTopOfCoreBlur = true,
			DisplayOrder = 0x7FFFFFFF,
			ZIndexBehavior = Enum.ZIndexBehavior.Global,
		},
	},
	{
		Name = "ScreenCover",
		Parent = "Holder",
		ClassName = "Frame",
		Properties = {
			ZIndex = -1,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundColor3 = Color3.new(),
		},
	},
	{
		Name = "Main",
		Parent = "Holder",
		ClassName = "Frame",
		Properties = {
			ZIndex = 1,
			ClipsDescendants = true,
			BackgroundTransparency = 1,
			Size = UDim2.new(0.25, 0, 0.25, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 0, 0.4, 0),
			BackgroundColor3 = Color3.fromHex("505064"),
		},
	},
	{
		Name = "MainCorner",
		Parent = "Main",
		ClassName = "UICorner",
		Properties = { CornerRadius = UDim.new(0.5, 0) },
	},
	{
		Name = "MainGradient",
		Parent = "Main",
		ClassName = "UIGradient",
		Properties = {
			Rotation = 90,
			Color = ColorSequence.new(Color3.new(1, 1, 1), Color3.new(0.5, 0.5, 0.5)),
		},
	},
	{
		Name = "MainAspectRatioConstraint",
		Parent = "Main",
		ClassName = "UIAspectRatioConstraint",
		Properties = { DominantAxis = Enum.DominantAxis.Height },
	},
	{
		Name = "MainListLayout",
		Parent = "Main",
		ClassName = "UIListLayout",
		Properties = { SortOrder = Enum.SortOrder.LayoutOrder },
	},
	{
		Name = "CommandBarSection",
		Parent = "Main",
		ClassName = "Frame",
		Properties = {
			LayoutOrder = 1,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0),
		},
	},
	{
		Name = "CommandBarListLayout",
		Parent = "CommandBarSection",
		ClassName = "UIListLayout",
		Properties = {
			Padding = UDim.new(0, 4),
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Horizontal,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
		},
	},
	{
		Name = "Logo",
		Parent = "CommandBarSection",
		ClassName = "ImageLabel",
		Properties = {
			Rotation = 90,
			ImageTransparency = 1,
			BackgroundTransparency = 1,
			Size = UDim2.new(0.8, 0, 0.8, 0),
			Image = "rbxassetid://0X24024E438",
		},
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
			Size = UDim2.new(1, -44, 0.8, 0),
			BackgroundColor3 = Color3.fromHex("191932"),
		},
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
			Size = UDim2.new(1, -20, 1, 0),
			Position = UDim2.new(0, 10, 0, 0),
			TextColor3 = Color3.new(1, 1, 1),
			TextXAlignment = Enum.TextXAlignment.Left,
			PlaceholderColor3 = Color3.fromHex("A0A0A0"),
			PlaceholderText = `Enter a command (Keybind:\u{200A}{
				service("UserInput"):GetStringForKeyCode(Enum.KeyCode[settings.keybind])
			}\u{200A})`,
		},
	},
	{
		Name = "CommandBarCorner",
		Parent = "CommandBarBackground",
		ClassName = "UICorner",
		Properties = { CornerRadius = UDim.new(0, 4) },
	},
	{
		Name = "SuggestionsSection",
		Parent = "Main",
		ClassName = "Frame",
		Properties = {
			ClipsDescendants = true,
			BackgroundTransparency = 1,
		},
	},
	{
		Name = "SuggestionsScroll",
		Parent = "SuggestionsSection",
		ClassName = "ScrollingFrame",
		Properties = {
			BorderSizePixel = 0,
			ScrollBarThickness = 0,
			ScrollingEnabled = false,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, -8, 1, -8),
			Position = UDim2.new(0, 4, 0, 4),
		},
	},
	{
		Name = "SuggestionsGridLayout",
		Parent = "SuggestionsScroll",
		ClassName = "UIGridLayout",
		Properties = {
			CellPadding = UDim2.new(),
			CellSize = UDim2.new(1, 0, 0, 20),
			SortOrder = Enum.SortOrder.LayoutOrder,
		},
	},
	{
		Name = "SuggestionSelector",
		Parent = "SuggestionsSection",
		ClassName = "Frame",
		Properties = {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, -2, 0, 20),
		},
	},
	{
		Name = "SelectorCorner",
		Parent = "SuggestionSelector",
		ClassName = "UICorner",
		Properties = { CornerRadius = UDim.new(0, 2) },
	},
	{
		Name = "SelectorBorder",
		Parent = "SuggestionSelector",
		ClassName = "UIStroke",
		Properties = {
			Enabled = false,
			Color = Color3.new(1, 1, 1),
		},
	},
	{
		Name = "NotificationHolder",
		Parent = "Holder",
		ClassName = "Frame",
		Properties = {
			AnchorPoint = Vector2.one,
			BackgroundTransparency = 1,
			Size = UDim2.new(1 / 3, 0, 1, -20),
			Position = UDim2.new(1, -10, 1, -10),
		},
	},
	{
		Name = "NotificationlistLayout",
		Parent = "NotificationHolder",
		ClassName = "UIListLayout",
		Properties = {
			Padding = UDim.new(0, 10),
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Bottom,
			HorizontalAlignment = Enum.HorizontalAlignment.Right,
		},
	},
})
local notificationIds = {}
local function notify(options)
	options = valid.table(options, {
		duration = 5,
		yields = false,
		important = false,
		text = "(no text)",
		title = "Ultimatum",
		calculateDuration = true,
	}) :: {
		text: string,
		title: string,
		yields: boolean,
		duration: number,
		important: boolean,
		calculateDuration: boolean,
	}
	options.text = `<b>{options.title}</b>\n{options.text}`
	if settings.notifications == "none" or settings.notifications == "important" and not options.important then
		return
	end
	local id
	repeat
		id = randomString({
			Length = 5,
			Format = "%s",
		})
	until not table.find(notificationIds, id)
	table.insert(notificationIds, id)
	local Notification = create({
		{
			Name = "Main",
			Parent = gui.NotificationHolder,
			ClassName = "Frame",
			Properties = {
				ClipsDescendants = true,
				AnchorPoint = Vector2.one,
				BackgroundTransparency = 1,
				BackgroundColor3 = Color3.fromHex("505064"),
			},
		},
		{
			Name = "MainCorner",
			Parent = "Main",
			ClassName = "UICorner",
			Properties = { CornerRadius = UDim.new(0, 4) },
		},
		{
			Name = "MainGradient",
			Parent = "Main",
			ClassName = "UIGradient",
			Properties = {
				Rotation = 90,
				Color = ColorSequence.new(Color3.new(1, 1, 1), Color3.new(0.5, 0.5, 0.5)),
			},
		},
		{
			Name = "Content",
			Parent = "Main",
			ClassName = "TextLabel",
			Properties = {
				TextSize = 14,
				RichText = true,
				TextWrapped = true,
				Text = options.text,
				TextTransparency = 1,
				Font = Enum.Font.Arial,
				BackgroundTransparency = 1,
				Size = UDim2.new(1, -20, 1, -20),
				Position = UDim2.new(0, 10, 0, 10),
				TextColor3 = Color3.new(1, 1, 1),
				TextXAlignment = Enum.TextXAlignment.Left,
			},
		},
	})
	if options.calculateDuration then
		for _ in utf8.graphemes(Notification.Content.ContentText) do
			options.duration += 0.06
		end
	end
	options.duration += 0.25
	local Size = service("Text"):GetTextSize(
		Notification.Content.ContentText,
		14,
		Enum.Font.Arial,
		Vector2.new(gui.NotificationHolder.AbsoluteSize.X, gui.NotificationHolder.AbsoluteSize.Y)
	)
	Notification.Main.Size = UDim2.new(0, Size.X + 22, 0, Size.Y + 20)
	Size = Notification.Main.Size
	Notification.Main.Size = UDim2.new(Size.X.Scale, Size.X.Offset, 0, 0)
	animate(
		Notification.Main,
		{
			secondsTime = 0.25,
			properties = {
				Size = Size,
				BackgroundTransparency = 0,
			},
		},
		Notification.Content,
		{
			secondsTime = 0.25,
			properties = { TextTransparency = 0 },
			easingStyle = Enum.EasingStyle.Linear,
		}
	)
	task.delay(
		options.duration,
		animate,
		Notification.Main,
		{
			secondsTime = 1,
			properties = { BackgroundTransparency = 1 },
		},
		Notification.Content,
		{
			secondsTime = 1,
			yields = true,
			properties = { TextTransparency = 1 },
			easingStyle = Enum.EasingStyle.Linear,
		},
		Notification.Main,
		{
			secondsTime = 0.25,
			properties = { Size = UDim2.new(Size.X.Scale, Size.X.Offset, 0, 0) },
		}
	)
	options.duration += 1.25
	task.spawn(function()
		local Start = os.clock()
		repeat
			Notification.Main.LayoutOrder = table.find(notificationIds, id)
			wait()
		until options.duration < os.clock() - Start
		table.remove(notificationIds, table.find(notificationIds, id))
	end)
	if options.yields then
		wait(options.duration)
		destroy(Notification)
	else
		task.delay(options.duration, destroy, Notification)
	end
end
local function checkAxis(axis)
	return workspace.CurrentCamera.ViewportSize[axis] / 2
		< gui.Logo.AbsolutePosition[axis] + gui.Logo.AbsoluteSize[axis] / 2
end
local lastCheck, debounce, lastLeft = 0, true, 0
local function resizeMain(x, y)
	x = if settings.stayOpen then 400 else valid.number(x, 400)
	y = valid.number(y, 40)
	gui.CommandBarBackground.LayoutOrder = if checkAxis("X") then -1 else 1
	gui.CommandBarSection.LayoutOrder = if checkAxis("Y") then 1 else -1
	animate(
		gui.Main,
		{
			secondsTime = 0.25,
			properties = {
				Size = UDim2.new(0, x, 0, y),
				Position = gui.Main.Position + UDim2.new(
					0,
					if checkAxis("X") then gui.Main.AbsoluteSize.X - x else 0,
					0,
					if checkAxis("Y") then gui.Main.AbsoluteSize.Y - y else 0
				),
			},
		},
		gui.CommandBarBackground,
		{
			secondsTime = 0.25,
			properties = { Visible = 40 < x },
		}
	)
end
local commands = {}
local connections
local function runCommand(text)
	for _, input in text:split("/") do
		local arguments = input:split(" ")
		local command = arguments[1]
		table.remove(arguments, 1)
		local ranCommand
		for commandNames, commandInfo in commands do
			if commandInfo.Toggles then
				commandNames = `{commandNames}_{commandInfo.Toggles}`
			end
			commandNames = commandNames:split("_")
			local resume
			for _, commandName in commandNames do
				if commandName:lower() == command:lower() then
					commandInfo.Arguments = valid.table(commandInfo.Arguments)
					for argumentIndex, argumentProperties in commandInfo.Arguments do
						if argumentProperties.Required and not arguments[argumentIndex] then
							notify({
								Title = "Missing Argument",
								Text = `The command "{commandNames[1]}" requires you to enter the argument "{argumentProperties.Name}"`,
							})
							break
						end
						if argumentProperties.Concatenate then
							arguments[argumentIndex] = table.concat(arguments, " ", argumentIndex)
							for index = argumentIndex + 1, #arguments do
								arguments[index] = nil
							end
						end
						arguments[argumentIndex] = valid[argumentProperties.Type:lower()](
							arguments[argumentIndex],
							argumentProperties.Substitute
						)
					end
					if commandInfo.Toggles then
						local enabled = true
						for _, Toggle in commandInfo.Toggles:lower():split("_") do
							if Toggle == command:lower() then
								enabled = false
								break
							end
						end
						if commandInfo.ToggleCheck then
							if (commandInfo.Enabled or false) == enabled then
								enabled = if enabled then "En" else "Dis"
								notify({
									Title = `Already {enabled}sabled`,
									Text = `The command is already {enabled:lower()}abled`,
								})
								return
							end
						end
						commandInfo.Enabled = enabled
						table.insert(arguments, 1, enabled)
					end
					if commandInfo.Variables then
						table.insert(arguments, 1, commandInfo.Variables)
					end
					commandInfo.Function(unpack(arguments))
					resume, ranCommand = true, true
					break
				end
			end
			if resume then
				break
			end
		end
		if not ranCommand then
			notify({
				Title = "Not a Command",
				Text = `There are not any commands named "{command}"`,
			})
		end
	end
end
local function addConnections(givenConnections)
	for name, connection in valid.table(givenConnections) do
		if typeof(connection) == "RBXScriptConnection" and connection.Connected then
			connections[if type(name) ~= "number" then name else #connections + 1] = connection
			table.insert(connections, connection)
		end
	end
end
local function removeConnections(givenConnections)
	for _, connection in valid.table(givenConnections) do
		if typeof(connection) == "RBXScriptConnection" then
			destroy(connection)
			pcall(table.remove, connections, table.find(connections, connection))
		end
	end
end
local function EnableDrag(frame, isMain)
	local dragConnection
	local inputBegan, inputEnded, removed =
		connect(frame.InputBegan, function(input, ignore)
			if not ignore and not debounce and input.UserInputType.Name == "MouseButton1" then
				if isMain then
					resizeMain(40)
				end
				debounce = true
				dragConnection = connect(service("Run").RenderStepped, function()
					service("UserInput").OverrideMouseIconBehavior = Enum.OverrideMouseIconBehavior.ForceHide
					local mousePosition = service("UserInput"):GetMouseLocation()
					local screenSize, frameSize, anchorPoint = gui.Holder.AbsoluteSize, frame.AbsoluteSize, frame.AnchorPoint
					mousePosition = UDim2.new(
						math.round(
							math.clamp(
								mousePosition.X - frameSize.X / 2 + frameSize.X * anchorPoint.X,
								frameSize.X * anchorPoint.X, screenSize.X - frameSize.X * (1 - anchorPoint.X)
							)
						) / screenSize.X,
						0,
						math.round(
							math.clamp(
								mousePosition.Y - frameSize.Y / 2 + frameSize.Y * anchorPoint.Y,
								frameSize.Y * anchorPoint.Y, screenSize.Y - frameSize.Y * (1 - anchorPoint.Y)
							)
						) / screenSize.Y,
						0
					)
					animate(frame, {
						secondsTime = 0,
						properties = { Position = mousePosition },
					})
				end)
				addConnections({ dragConnection })
			end
		end), connect(service("UserInput").InputEnded, function(Input)
			if dragConnection and Input.UserInputType.Name == "MouseButton1" then
				service("UserInput").OverrideMouseIconBehavior = Enum.OverrideMouseIconBehavior.None
				removeConnections({ dragConnection })
				dragConnection = nil
				debounce = false
				if isMain then
					resizeMain()
				end
			end
		end)
	removed = connect(frame.AncestryChanged, function()
		if not frame:IsDescendantOf(hiddenGui) then
			removeConnections({
				removed,
				inputBegan,
				inputEnded,
				dragConnection,
			})
		end
	end)
	addConnections({
		removed,
		inputBegan,
		inputEnded,
	})
end
local function createWindow(Title, DataList)
	local Window = create({
		{
			Name = "Main",
			Parent = gui.Holder,
			ClassName = "Frame",
			Properties = {
				Active = true,
				ClipsDescendants = true,
				Size = UDim2.new(0, 500, 0, 250),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.new(0.5, 0, 1, 125),
				BackgroundColor3 = Color3.fromHex("505064"),
			},
		},
		{
			Name = "MainCorner",
			Parent = "Main",
			ClassName = "UICorner",
			Properties = { CornerRadius = UDim.new(0, 4) },
		},
		{
			Name = "MainGradient",
			Parent = "Main",
			ClassName = "UIGradient",
			Properties = {
				Rotation = 90,
				Color = ColorSequence.new(Color3.new(1, 1, 1), Color3.new(0.5, 0.5, 0.5)),
			},
		},
		{
			Name = "Title",
			Parent = "Main",
			ClassName = "TextLabel",
			Properties = {
				TextSize = 14,
				Font = Enum.Font.Arial,
				BackgroundTransparency = 1,
				Size = UDim2.new(1, -45, 0, 20),
				Position = UDim2.new(0, 5, 0, 0),
				TextColor3 = Color3.new(1, 1, 1),
				Text = valid.string(Title, "Ultimatum"),
				TextXAlignment = Enum.TextXAlignment.Left,
			},
		},
		{
			Name = "TitleGradient",
			Parent = "Title",
			ClassName = "UIGradient",
			Properties = {
				Transparency = NumberSequence.new({
					NumberSequenceKeypoint.new(0, 0),
					NumberSequenceKeypoint.new(0.95, 0),
					NumberSequenceKeypoint.new(1, 1),
				}),
			},
		},
		{
			Name = "Close",
			Parent = "Main",
			ClassName = "ImageButton",
			Properties = {
				Modal = true,
				AutoButtonColor = false,
				BackgroundTransparency = 1,
				Size = UDim2.new(0, 14, 0, 14),
				Position = UDim2.new(1, -17, 0, 3),
				Image = "rbxasset://textures/DevConsole/Close.png",
			},
		},
		{
			Name = "Minimize",
			Parent = "Main",
			ClassName = "ImageButton",
			Properties = {
				Modal = true,
				AutoButtonColor = false,
				BackgroundTransparency = 1,
				Size = UDim2.new(0, 14, 0, 14),
				Position = UDim2.new(1, -37, 0, 3),
				Image = "rbxasset://textures/DevConsole/Minimize.png",
			},
		},
		{
			Name = "Display",
			Parent = "Main",
			ClassName = "ScrollingFrame",
			Properties = {
				BorderSizePixel = 0,
				ScrollBarThickness = 0,
				BackgroundTransparency = 1,
				Size = UDim2.new(1, -8, 1, -24),
				Position = UDim2.new(0, 4, 0, 20),
			},
		},
		{
			Name = "DisplayListLayout",
			Parent = "Display",
			ClassName = "UIListLayout",
			Properties = { SortOrder = Enum.SortOrder.LayoutOrder },
		},
	})
	local WindowConnections = {}
	for Index, Data in DataList do
		local Main = newInstance("TextLabel", nil, {
			LayoutOrder = Index,
			Font = Enum.Font.Arial,
			Text = `  {Data.Text}`,
			BackgroundTransparency = 1,
			TextStrokeTransparency = 0.8,
			Size = UDim2.new(1, 0, 0, 20),
			TextXAlignment = Enum.TextXAlignment.Left,
		});
		({
			Slider = function() end,
		})[Data.Type]()
	end
	animate(Window.Main, {
		yields = true,
		properties = { Position = UDim2.new(0.5, 0, 0.5, 0) },
	})
	EnableDrag(Window.Main)
	table.insert(WindowConnections, connect(Window.Minimize.MouseButton1Click, function() end))
	table.insert(
		WindowConnections,
		connect(Window.Close.MouseButton1Click, function()
			removeConnections(WindowConnections)
			animate(Window.Main, {
				yields = true,
				easingDirection = Enum.EasingDirection.In,
				properties = { Position = UDim2.new(Window.Main.Position.X.Scale, 0, 1, 125) },
			})
			destroy(Window)
		end)
	)
	return Window
end
local function fireTouchInterest(Toucher, Touched, TouchTime)
	TouchTime = valid.number(TouchTime, 0)
	if firetouchinterest then
		for On = 0, 1 do
			firetouchinterest(Toucher, Touched, On)
			if On == 0 then
				wait(TouchTime)
			end
		end
	else
		local OldCanCollide, OldCanTouch, OldCFrame = Touched.CanCollide, Touched.CanTouch, Touched.CFrame
		Touched.CanCollide, Touched.CanTouch, Touched.CFrame = true, true, Toucher.CFrame
		wait(TouchTime)
		Touched.CFrame, Touched.CanTouch, Touched.CanCollide = OldCFrame, OldCanTouch, OldCanCollide
	end
end
local IgnoreUpdate, Selected
local Suggestions = {}
local function ScrollSuggestions(Input)
	if 0 < #Suggestions then
		Selected = (Selected + (if Input == "Up" then -1 elseif Input == "Down" then 1 else 0) - 1) % #Suggestions + 1
		local OldCanvasPosition = gui.SuggestionsScroll.CanvasPosition
		gui.SuggestionsScroll.CanvasPosition = Vector2.new(0, 20 * (Selected - 3))
		animate(gui.SuggestionSelector, {
			secondsTime = 0.25,
			properties = {
				Position = UDim2.new(
					0,
					1,
					0,
					4 + Suggestions[Selected].UI.AbsolutePosition.Y - gui.SuggestionsScroll.AbsolutePosition.Y
				),
			},
		})
		local CanvasPosition = gui.SuggestionsScroll.CanvasPosition
		gui.SuggestionsScroll.CanvasPosition = OldCanvasPosition
		animate(gui.SuggestionsScroll, {
			secondsTime = 0.25,
			properties = { CanvasPosition = CanvasPosition },
		})
	end
end
local function UpdateSuggestions()
	if service("UserInput"):GetFocusedTextBox() == gui.CommandBar and not IgnoreUpdate then
		IgnoreUpdate = true
		gui.CommandBar.Text = gui.CommandBar.Text:gsub("^%W+", ""):gsub("\t", "")
		IgnoreUpdate = false
		gui.CommandBar.TextXAlignment = Enum.TextXAlignment[if gui.CommandBar.TextFits then "Left" else "Right"]
		local Command = gui.CommandBar.Text:split("/")
		Command = ((Command[#Command] or ""):split(" ")[1] or ""):lower()
		gui.SuggestionsScroll.CanvasSize = UDim2.new()
		gui.SuggestionsGridLayout.Parent = nil
		destroy(Suggestions)
		for CommandNames, CommandInfo in commands do
			CommandNames = (if CommandInfo.Toggles then `{CommandNames}_{CommandInfo.Toggles}` else CommandNames):split(
				"_"
			)
			for _, CommandName in CommandNames do
				if CommandName:lower():find(Command, 1, true) then
					local DisplayName = CommandInfo.Toggles
							and CommandInfo.Enabled
							and CommandInfo.Toggles:split("_")[1]
						or CommandNames[1]
					table.insert(Suggestions, {
						Command = DisplayName,
						CommandNames = CommandNames,
						Display = ("<font color = '#FFFFFF'>%s</font>%s%s"):format(
							DisplayName,
							if CommandInfo.Arguments
								then (function()
									local Arguments = {}
									for _, ArgumentInfo in CommandInfo.Arguments do
										table.insert(
											Arguments,
											`{ArgumentInfo.Name}: {ArgumentInfo.Type}{if ArgumentInfo.Required then "" else "?"}`
										)
									end
									return ` <i>{table.concat(Arguments, " ")}</i>`
								end)()
								else "",
							if CommandInfo.Toggles then " [Toggles]" else ""
						),
					})
					break
				end
			end
		end
		if #Command < 2 then
			table.sort(Suggestions, function(Suggestion1, Suggestion2)
				Suggestion1 = service("Text"):GetTextSize(Suggestion1.Command, 14, Enum.Font.Arial, Vector2.one * 1e6).X
				Suggestion2 = service("Text"):GetTextSize(Suggestion2.Command, 14, Enum.Font.Arial, Vector2.one * 1e6).X
				return if checkAxis("Y") then Suggestion1 < Suggestion2 else Suggestion2 < Suggestion1
			end)
		else
			local function MatchRate(Suggestion)
				local HighestMatch = 0
				for _, Name in Suggestion.CommandNames do
					local MatchPercent = 1 - #Name:lower():gsub(Command, "") / #Name
					if HighestMatch < MatchPercent then
						HighestMatch = MatchPercent
					end
				end
				return HighestMatch
			end
			table.sort(Suggestions, function(Suggestion1, Suggestion2)
				return if checkAxis("Y")
					then MatchRate(Suggestion2) < MatchRate(Suggestion1)
					else MatchRate(Suggestion1) < MatchRate(Suggestion2)
			end)
		end
		for Index, Suggestion in Suggestions do
			Suggestion.UI = newInstance("TextLabel", gui.SuggestionsScroll, {
				TextSize = 14,
				RichText = true,
				BorderSizePixel = 0,
				LayoutOrder = Index,
				Font = Enum.Font.Arial,
				Text = Suggestion.Display,
				BackgroundTransparency = 1,
				TextStrokeTransparency = 0.8,
				BackgroundColor3 = Color3.new(1, 1, 1),
				TextColor3 = Color3.fromHex("A0A0A0"),
				TextXAlignment = Enum.TextXAlignment.Left,
			})
		end
		if 0 < #Suggestions then
			Selected = if checkAxis("Y") then 1 else #Suggestions
			gui.SelectorBorder.Enabled = true
		else
			Selected = nil
			gui.SelectorBorder.Enabled = false
		end
		gui.SuggestionsGridLayout.Parent = gui.SuggestionsScroll
		local CommandNumber = #gui.SuggestionsScroll:GetChildren() - 1
		gui.SuggestionsScroll.CanvasSize = UDim2.new(0, 0, 0, 20 * CommandNumber)
		gui.SuggestionsScroll.CanvasPosition = Vector2.yAxis * (if checkAxis("Y") then 0 else 20 * CommandNumber)
		gui.SuggestionSelector.Position = if checkAxis("Y") then UDim2.new(0, 1, 0, 4) else UDim2.new(0, 1, 1, -24)
		resizeMain(nil, if 0 < CommandNumber then 48 + 20 * math.min(CommandNumber, 5) else 40)
	end
end
gui.Holder.Parent = hiddenGui
local sendValue = newInstance("BindableEvent")
local Removing
connections = {
	connect(owner.CharacterAdded, function(NewCharacter)
		sendValue:Fire("Character", NewCharacter)
	end),
	connect(owner.ChildAdded, function(Object)
		if valid.instance(Object, "Backpack") then
			sendValue:Fire("Backpack", Object)
		elseif valid.instance(Object, "PlayerGui") then
			sendValue:Fire("PlayerGui", Object)
		end
	end),
	isfile and connect(service("Run").Heartbeat, function()
		if not valid.instance(gui.Holder, "ScreenGui") or not gui.Holder:IsDescendantOf(hiddenGui) and not Removing then
			Removing = true
			local Unfinished = 0
			for _, Info in commands do
				if Info.ToggleCheck and Info.Enabled then
					task.spawn(function()
						Unfinished += 1
						runCommand(Info.Toggles:split("_")[1])
						Unfinished -= 1
					end)
				end
			end
			waitForSignal(function()
				wait()
				return Unfinished < 1
			end, 10)
			destroy(connections, gui, sendValue)
		end
		if settings.autoUpdate and 60 < os.clock() - lastCheck then
			lastCheck = os.clock()
			local Success, Result = pcall(
				game.HttpGet,
				game,
				"https://raw.githubusercontent.com/Amourousity/Ultimatum/main/Source.lua",
				true
			)
			if Success and (not isfile("Ultimatum.lua") or Result ~= readfile("Ultimatum.lua")) then
				writefile("Ultimatum.lua", Result)
				notify({
					Yields = true,
					Title = "Out of Date",
					Text = "Your version of Ultimatum is outdated! Updating to newest version...",
				})
				loadstring(Result, "Ultimatum")()
			elseif not Success and not isfile("Ultimatum.lua") then
				notify({
					Text = Result,
					Important = true,
					Title = "Error",
				})
			end
		end
	end),
	queue_on_teleport and connect(
		owner.OnTeleport,
		if isfile
			then function()
				if settings.loadOnRejoin then
					queue_on_teleport(
						if isfile("Ultimatum.lua")
							then readfile("Ultimatum.lua")
							else "warn('Ultimatum.lua missing from workspace folder (Ultimatum cannot run)')"
					)
				end
			end
			else function()
				if settings.loadOnRejoin then
					local Success, Result = pcall(
						game.HttpGet,
						game,
						"https://raw.githubusercontent.com/Amourousity/Ultimatum/main/Source.lua",
						true
					)
					queue_on_teleport(
						if Success then Result else `warn("HttpGet failed: {Result} (Ultimatum cannot run)")`
					)
				end
			end
	),
	connect(gui.Main.MouseEnter, function()
		if not debounce then
			service("UserInput").OverrideMouseIconBehavior = Enum.OverrideMouseIconBehavior.ForceShow
			lastLeft = os.clock()
			resizeMain()
		end
	end),
	connect(gui.Main.MouseLeave, function()
		if not debounce then
			lastLeft = os.clock()
			wait(1)
			if 1 < os.clock() - lastLeft and not debounce then
				service("UserInput").OverrideMouseIconBehavior = Enum.OverrideMouseIconBehavior.None
				resizeMain(40)
			end
		end
	end),
	connect(gui.CommandBar.Focused, function()
		if not debounce then
			debounce = true
			gui.CommandBar.PlaceholderText = "Enter a command..."
			service("UserInput").OverrideMouseIconBehavior = Enum.OverrideMouseIconBehavior.ForceShow
			resizeMain()
			task.delay(0.25, UpdateSuggestions)
		end
	end),
	connect(gui.CommandBar.FocusLost, function(Sent)
		wait()
		gui.CommandBar.PlaceholderText = "Enter a command"
		if Sent and 0 < #gui.CommandBar.Text then
			task.spawn(runCommand, gui.CommandBar.Text)
		end
		gui.CommandBar.Text = ""
		gui.CommandBar.TextXAlignment = Enum.TextXAlignment[if gui.CommandBar.TextFits then "Left" else "Right"]
		service("UserInput").OverrideMouseIconBehavior = Enum.OverrideMouseIconBehavior.None
		resizeMain()
		task.delay(0.25, function()
			hiddenGui.Parent = nil
			hiddenGui.Parent = hiddenGuiParent
			if service("UserInput"):GetFocusedTextBox() ~= gui.CommandBar then
				resizeMain(40)
				wait(0.25)
				gui.CommandBar.PlaceholderText =
					`Enter a command (Keybind:\u{200A}{service("UserInput"):GetStringForKeyCode(
						Enum.KeyCode[settings.keybind]
					)}\u{200A})`
			end
		end)
		debounce = false
	end),
	connect(service("UserInput").InputBegan, function(Input, Ignore)
		if Input.UserInputType.Name == "Keyboard" then
			Input = Input.KeyCode.Name
			if not Ignore and Input == settings.keybind and not debounce then
				task.defer(gui.CommandBar.CaptureFocus, gui.CommandBar)
			elseif service("UserInput"):GetFocusedTextBox() == gui.CommandBar and 0 < #Suggestions then
				if Input == "Up" or Input == "Down" then
					ScrollSuggestions(Input)
					local Start = os.clock()
					while service("UserInput"):IsKeyDown(Enum.KeyCode[Input]) and os.clock() - Start < 0.5 do
						wait()
					end
					if 0.25 < os.clock() - Start then
						repeat
							ScrollSuggestions(Input)
							wait(1 / 30)
						until not service("UserInput"):IsKeyDown(Enum.KeyCode[Input])
					end
				elseif Input == "Tab" then
					gui.CommandBar.Text = Suggestions[Selected].Command
					gui.CommandBar.CursorPosition = #gui.CommandBar.Text
				end
			end
		end
	end),
	connect(gui.CommandBar:GetPropertyChangedSignal("Text"), UpdateSuggestions),
}
if not globalEnvironment.UltimatumUIs then
	globalEnvironment.UltimatumUIs = {}
end
destroy(globalEnvironment.UltimatumUIs)
table.insert(globalEnvironment.UltimatumUIs, gui)
local function LoadCommands(Lua, Name)
	Name = valid.string(Name, "Custom Command Set")
	local CommandSet, ErrorMessage = loadstring(
		([[
			local
				receiveValue,
				notify,
				runCommand,
				addConnections,
				removeConnections,
				createWindow,
				fireTouchInterest,
				gui,
				character,
				backpack,
				playerGui
			= ...
			AddConnections({
				Connect(receiveValue.Event, function(Type, Object)
					if Type == "Character" then
						character = Object
					elseif Type == "Backpack" then
						backpack = Object
					elseif Type == "PlayerGui" then
						playerGui = Object
					end
				end),
			})
		%s]]):gsub("\n\t*", " "):format(Lua),
		Name
	)
	if not CommandSet then
		warn(ErrorMessage)
		notify({
			Title = `{Name} Failed`,
			Text = "The command set failed to load. Check the Developer Console for any error messages",
		})
		return
	end
	setfenv(CommandSet, getfenv())
	for CommandName, Info in
		CommandSet(
			sendValue,
			notify,
			runCommand,
			addConnections,
			removeConnections,
			createWindow,
			fireTouchInterest,
			gui,
			getCharacter(owner, 0.5),
			waitForChildOfClass(owner, "Backpack"),
			waitForChildOfClass(owner, "PlayerGui")
		)
	do
		if commands[CommandName] and commands[CommandName].ToggleCheck and commands[CommandName].Enabled then
			runCommand(commands[CommandName].Toggles:split("_")[1])
		end
		commands[CommandName] = Info
	end
end
globalEnvironment.AddUltimatumCommands = LoadCommands
local function GetCommandSet(ID)
	ID = valid.number(ID, 0)
	local Success, Result = pcall(
		game.HttpGet,
		game,
		`https://raw.githubusercontent.com/Amourousity/Ultimatum/main/CommandSets/{ID}.lua`,
		true
	)
	if isfolder and not isfolder("UltimatumCommandSets") then
		makefolder("UltimatumCommandSets")
	end
	if Success then
		if isfolder then
			writefile(`UltimatumCommandSets/{ID}.lua`, Result)
		end
	elseif isfolder and isfile and isfile(`UltimatumCommandSets/{ID}.lua`) then
		Success, Result = true, readfile(`UltimatumCommandSets/{ID}.lua`)
	end
	if Success then
		LoadCommands(Result, `Command Set {ID}`)
	elseif Result ~= "HTTP 404 (Not Found)" then
		notify({
			Title = "Failed to Load",
			Text = `Command set {ID} failed to download; is GitHub down?`,
		})
	end
end
EnableDrag(gui.Main, true)
pcall(function()
	hiddenGui.Parent = nil
	hiddenGui.Parent = hiddenGuiParent
end)
while service("CoreGui"):FindFirstChild("RobloxLoadingGUI") do
	service("CoreGui").ChildRemoved:Wait()
end
pcall(function()
	if settings.playIntro == "always" or settings.playIntro == "once" and not globalEnvironment.UltimatumLoaded then
		globalEnvironment.UltimatumLoaded = true
		service("UserInput").OverrideMouseIconBehavior = Enum.OverrideMouseIconBehavior.ForceHide
		task.delay(1.5, function()
			service("UserInput").OverrideMouseIconBehavior = Enum.OverrideMouseIconBehavior.None
		end)
		service("Run"):SetRobloxGuiFocused(true)
		task.delay(1.5, service("Run").SetRobloxGuiFocused, service("Run"), false)
		print("animatign")
		animate(
			gui.ScreenCover,
			{
				secondsTime = 0.25,
				easingStyle = Enum.EasingStyle.Linear,
				properties = { BackgroundTransparency = 0.2 },
			},
			gui.Main,
			{
				yields = true,
				properties = {
					BackgroundTransparency = 0,
					Position = UDim2.new(0.5, 0, 0.5, 0),
				},
			},
			gui.Logo,
			{
				properties = {
					Rotation = 0,
					ImageTransparency = 0,
				},
			},
			gui.MainCorner,
			{
				yields = true,
				finishDelay = 0.5,
				properties = { CornerRadius = UDim.new(0, 4) },
			},
			gui.ScreenCover,
			{
				secondsTime = 0.25,
				easingStyle = Enum.EasingStyle.Linear,
				properties = { BackgroundTransparency = 1 },
			},
			gui.Main,
			{
				properties = {
					Rotation = 180,
					Size = UDim2.new(),
				},
				easingStyle = Enum.EasingStyle.Back,
				easingDirection = Enum.EasingDirection.In,
			},
			gui.MainCorner,
			{
				properties = { CornerRadius = UDim.new(0.5, 0) },
			},
			gui.Logo,
			{
				yields = true,
				properties = { ImageTransparency = 1 },
			}
		)
		print("don animatign")
	else
		globalEnvironment.UltimatumLoaded = true
	end
	wait()
	destroy(gui.ScreenCover)
	gui.ScreenCover = nil
	for Name, Properties in
		{
			Logo = {
				Rotation = 0,
				ImageTransparency = 0,
			},
			Main = {
				Rotation = 0,
				AnchorPoint = Vector2.zero,
				BackgroundTransparency = 0,
				Size = UDim2.new(0, 40, 0, 40),
				Position = UDim2.new(0, 0, 1, 0),
			},
			MainListLayout = { Parent = gui.MainSection },
			MainCorner = { CornerRadius = UDim.new(0, 4) },
			MainAspectRatioConstraint = { Parent = gui.Logo },
			CommandBarSection = { Size = UDim2.new(1, 0, 0, 40) },
			SuggestionsSection = { Size = UDim2.new(1, 0, 1, -40) },
		}
	do
		for Property, Value in Properties do
			gui[Name][Property] = Value
		end
	end
	resizeMain(40)
	animate(gui.Main, {
		yields = true,
		properties = { Position = UDim2.new(0, 0, 1, -40) },
	})
	debounce = false
	GetCommandSet()
	GetCommandSet(game.PlaceId)
end)
