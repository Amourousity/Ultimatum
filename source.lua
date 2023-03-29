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
for name, func in load("Utilitas")({}) do
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
					`All settings for Ultimatum.\nDo not edit this file unless you know what you're doing.\nEvery setting can be changed in-game using the "Settings" command.\n\x7B\n{table.concat(
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
	holder = {
		Parent = hiddenGui,
		ClassName = "ScreenGui",
		Properties = {
			ResetOnSpawn = false,
			IgnoreGuiInset = true,
			OnTopOfCoreBlur = true,
			DisplayOrder = 0x7FFFFFFF,
			ZIndexBehavior = Enum.ZIndexBehavior.Global,
		},
	},
	screenCover = {
		Parent = "holder",
		ClassName = "Frame",
		Properties = {
			ZIndex = -1,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundColor3 = Color3.new(),
		},
	},
	main = {
		Parent = "holder",
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
	mainCorner = {
		Parent = "main",
		ClassName = "UICorner",
		Properties = { CornerRadius = UDim.new(0.5, 0) },
	},
	mainGradient = {
		Parent = "main",
		ClassName = "UIGradient",
		Properties = {
			Rotation = 90,
			Color = ColorSequence.new(Color3.new(1, 1, 1), Color3.new(0.5, 0.5, 0.5)),
		},
	},
	mainAspectRatioConstraint = {
		Parent = "main",
		ClassName = "UIAspectRatioConstraint",
		Properties = { DominantAxis = Enum.DominantAxis.Height },
	},
	mainListLayout = {
		Parent = "main",
		ClassName = "UIListLayout",
		Properties = { SortOrder = Enum.SortOrder.LayoutOrder },
	},
	commandBarSection = {
		Parent = "main",
		ClassName = "Frame",
		Properties = {
			LayoutOrder = 1,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0),
		},
	},
	commandBarListLayout = {
		Parent = "commandBarSection",
		ClassName = "UIListLayout",
		Properties = {
			Padding = UDim.new(0, 4),
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Horizontal,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
		},
	},
	logo = {
		Parent = "commandBarSection",
		ClassName = "ImageLabel",
		Properties = {
			Rotation = 90,
			ImageTransparency = 1,
			BackgroundTransparency = 1,
			Size = UDim2.new(0.8, 0, 0.8, 0),
			Image = "rbxassetid://0X24024E438",
		},
	},
	commandBarBackground = {
		Parent = "commandBarSection",
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
	commandBar = {
		Parent = "commandBarBackground",
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
			PlaceholderText = `Enter a command (Keybind:\u{200A}{service("UserInput"):GetStringForKeyCode(
				Enum.KeyCode[settings.keybind]
			)}\u{200A})`,
		},
	},
	commandBarCorner = {
		Parent = "commandBarBackground",
		ClassName = "UICorner",
		Properties = { CornerRadius = UDim.new(0, 4) },
	},
	suggestionsSection = {
		Parent = "main",
		ClassName = "Frame",
		Properties = {
			ClipsDescendants = true,
			BackgroundTransparency = 1,
		},
	},
	suggestionsScroll = {
		Parent = "suggestionsSection",
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
	suggestionsGridLayout = {
		Parent = "suggestionsScroll",
		ClassName = "UIGridLayout",
		Properties = {
			CellPadding = UDim2.new(),
			CellSize = UDim2.new(1, 0, 0, 20),
			SortOrder = Enum.SortOrder.LayoutOrder,
		},
	},
	suggestionSelector = {
		Parent = "suggestionsSection",
		ClassName = "Frame",
		Properties = {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, -2, 0, 20),
		},
	},
	selectorCorner = {
		Parent = "suggestionSelector",
		ClassName = "UICorner",
		Properties = { CornerRadius = UDim.new(0, 2) },
	},
	selectorBorder = {
		Parent = "suggestionSelector",
		ClassName = "UIStroke",
		Properties = {
			Enabled = false,
			Color = Color3.new(1, 1, 1),
		},
	},
	notificationHolder = {
		Parent = "holder",
		ClassName = "Frame",
		Properties = {
			AnchorPoint = Vector2.one,
			BackgroundTransparency = 1,
			Size = UDim2.new(1 / 3, 0, 1, -20),
			Position = UDim2.new(1, -10, 1, -10),
		},
	},
	notificationListLayout = {
		Parent = "notificationHolder",
		ClassName = "UIListLayout",
		Properties = {
			Padding = UDim.new(0, 10),
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Bottom,
			HorizontalAlignment = Enum.HorizontalAlignment.Right,
		},
	},
}) :: {
	holder: ScreenGui,
	screenCover: Frame,
	main: Frame,
	mainCorner: UICorner,
	mainGradient: UIGradient,
	mainAspectRatioConstraint: UIAspectRatioConstraint,
	mainListLayout: UIListLayout,
	commandBarSection: Frame,
	commandBarListLayout: UIListLayout,
	logo: ImageLabel,
	commandBarBackground: Frame,
	commandBar: TextBox,
	commandBarCorner: UICorner,
	suggestionsSection: Frame,
	suggestionsScroll: ScrollingFrame,
	suggestionsGridLayout: UIGridLayout,
	suggestionSelector: Frame,
	selectorCorner: UICorner,
	selectorBorder: UIStroke,
	notificationHolder: Frame,
	notificationListLayout: UIListLayout,
}
local notificationIds = {}
local function notify(options: {
	text: string,
	title: string,
	yields: boolean,
	duration: number,
	important: boolean,
	calculateDuration: boolean,
})
	options = valid.table(options, {
		duration = 5,
		yields = false,
		important = false,
		text = "(no text)",
		title = "Ultimatum",
		calculateDuration = true,
	})
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
	local notification: {
		main: Frame,
		mainCorner: UICorner,
		mainGradient: UIGradient,
		content: TextLabel,
	} = create({
		main = {
			Parent = gui.notificationHolder,
			ClassName = "Frame",
			Properties = {
				ClipsDescendants = true,
				AnchorPoint = Vector2.one,
				BackgroundTransparency = 1,
				BackgroundColor3 = Color3.fromHex("505064"),
			},
		},
		mainCorner = {
			Parent = "main",
			ClassName = "UICorner",
			Properties = { CornerRadius = UDim.new(0, 4) },
		},
		mainGradient = {
			Parent = "main",
			ClassName = "UIGradient",
			Properties = {
				Rotation = 90,
				Color = ColorSequence.new(Color3.new(1, 1, 1), Color3.new(0.5, 0.5, 0.5)),
			},
		},
		content = {
			Parent = "main",
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
		for _ in utf8.graphemes(notification.content.ContentText) do
			options.duration += 0.06
		end
	end
	options.duration += 0.25
	local Size = service("Text"):GetTextSize(
		notification.content.ContentText,
		14,
		Enum.Font.Arial,
		Vector2.new(gui.notificationHolder.AbsoluteSize.X, gui.notificationHolder.AbsoluteSize.Y)
	)
	notification.main.Size = UDim2.new(0, Size.X + 22, 0, Size.Y + 20)
	Size = notification.main.Size
	notification.main.Size = UDim2.new(Size.X.Scale, Size.X.Offset, 0, 0)
	animate(
		notification.main,
		{
			secondsTime = 0.25,
			properties = {
				Size = Size,
				BackgroundTransparency = 0,
			},
		},
		notification.content,
		{
			secondsTime = 0.25,
			properties = { TextTransparency = 0 },
			easingStyle = Enum.EasingStyle.Linear,
		}
	)
	task.delay(
		options.duration,
		animate,
		notification.main,
		{
			secondsTime = 1,
			properties = { BackgroundTransparency = 1 },
		},
		notification.content,
		{
			secondsTime = 1,
			yields = true,
			properties = { TextTransparency = 1 },
			easingStyle = Enum.EasingStyle.Linear,
		},
		notification.main,
		{
			secondsTime = 0.25,
			properties = { Size = UDim2.new(Size.X.Scale, Size.X.Offset, 0, 0) },
		}
	)
	options.duration += 1.25
	task.spawn(function()
		local Start = os.clock()
		repeat
			notification.main.LayoutOrder = table.find(notificationIds, id)
			wait()
		until options.duration < os.clock() - Start
		table.remove(notificationIds, table.find(notificationIds, id))
	end)
	if options.yields then
		wait(options.duration)
		destroy(notification)
	else
		task.delay(options.duration, destroy, notification)
	end
end
local function checkAxis(axis)
	return workspace.CurrentCamera.ViewportSize[axis] / 2
		< gui.logo.AbsolutePosition[axis] + gui.logo.AbsoluteSize[axis] / 2
end
local lastCheck, debounce, lastLeft = 0, true, 0
local function resizeMain(x, y)
	x = if settings.stayOpen then 400 else valid.number(x, 400)
	y = valid.number(y, 40)
	gui.commandBarBackground.LayoutOrder = if checkAxis("X") then -1 else 1
	gui.commandBarSection.LayoutOrder = if checkAxis("Y") then 1 else -1
	animate(
		gui.main,
		{
			secondsTime = 0.25,
			properties = {
				Size = UDim2.new(0, x, 0, y),
				Position = gui.main.Position + UDim2.new(
					0,
					if checkAxis("X") then gui.main.AbsoluteSize.X - x else 0,
					0,
					if checkAxis("Y") then gui.main.AbsoluteSize.Y - y else 0
				),
			},
		},
		gui.commandBarBackground,
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
								title = "Missing Argument",
								text = `The command "{commandNames[1]}" requires you to enter the argument "{argumentProperties.Name}"`,
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
									title = `Already {enabled}sabled`,
									text = `The command is already {enabled:lower()}abled`,
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
				title = "Not a Command",
				text = `There are not any commands named "{command}"`,
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
local function enableDrag(frame, isMain)
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
					local screenSize, frameSize, anchorPoint = gui.holder.AbsoluteSize, frame.AbsoluteSize, frame.AnchorPoint
					mousePosition = UDim2.new(math.round(math.clamp(mousePosition.X - frameSize.X / 2 + frameSize.X * anchorPoint.X, frameSize.X * anchorPoint.X, screenSize.X - frameSize.X * (1 - anchorPoint.X))) / screenSize.X, 0, math.round(math.clamp(mousePosition.Y - frameSize.Y / 2 + frameSize.Y * anchorPoint.Y, frameSize.Y * anchorPoint.Y, screenSize.Y - frameSize.Y * (1 - anchorPoint.Y))) / screenSize.Y, 0)
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
local function createWindow(title: string, dataList)
	local window = create({
		{
			Name = "Main",
			Parent = gui.holder,
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
				Text = valid.string(title, "Ultimatum"),
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
	local windowConnections = {}
	for index, data in dataList do
		local main = newInstance("TextLabel", nil, {
			LayoutOrder = index,
			Font = Enum.Font.Arial,
			Text = `  {data.Text}`,
			BackgroundTransparency = 1,
			TextStrokeTransparency = 0.8,
			Size = UDim2.new(1, 0, 0, 20),
			TextXAlignment = Enum.TextXAlignment.Left,
		});		({
			slider = function() end,
		})[data.Type]()
	end
	animate(window.Main, {
		yields = true,
		properties = { Position = UDim2.new(0.5, 0, 0.5, 0) },
	})
	enableDrag(window.Main)
	table.insert(windowConnections, connect(window.Minimize.MouseButton1Click, function() end))
	table.insert(
		windowConnections,
		connect(window.Close.MouseButton1Click, function()
			removeConnections(windowConnections)
			animate(window.Main, {
				yields = true,
				easingDirection = Enum.EasingDirection.In,
				properties = { Position = UDim2.new(window.Main.Position.X.Scale, 0, 1, 125) },
			})
			destroy(window)
		end)
	)
	return window
end
local function fireTouchInterest(toucher: BasePart, touched: BasePart, touchTime: number?)
	touchTime = valid.number(touchTime, 0)
	if firetouchinterest then
		for on = 0, 1 do
			firetouchinterest(toucher, touched, on)
			if on == 0 then
				wait(touchTime)
			end
		end
	else
		local oldCanCollide, oldCanTouch, oldCFrame = touched.CanCollide, touched.CanTouch, touched.CFrame
		touched.CanCollide, touched.CanTouch, touched.CFrame = true, true, toucher.CFrame
		wait(touchTime)
		touched.CFrame, touched.CanTouch, touched.CanCollide = oldCFrame, oldCanTouch, oldCanCollide
	end
end
local ignoreUpdate, selected
local suggestions = {}
local function scrollSuggestions(input: "Up" | "Down")
	if 0 < #suggestions then
		selected = (selected + (if input == "Up" then -1 elseif input == "Down" then 1 else 0) - 1) % #suggestions + 1
		local oldCanvasPosition = gui.suggestionsScroll.CanvasPosition
		gui.suggestionsScroll.CanvasPosition = Vector2.new(0, 20 * (selected - 3))
		animate(gui.suggestionSelector, {
			secondsTime = 0.25,
			properties = {
				Position = UDim2.new(
					0,
					1,
					0,
					4 + suggestions[selected].UI.AbsolutePosition.Y - gui.suggestionsScroll.AbsolutePosition.Y
				),
			},
		})
		local canvasPosition = gui.suggestionsScroll.CanvasPosition
		gui.suggestionsScroll.CanvasPosition = oldCanvasPosition
		animate(gui.suggestionsScroll, {
			secondsTime = 0.25,
			properties = { CanvasPosition = canvasPosition },
		})
	end
end
local function updateSuggestions()
	if service("UserInput"):GetFocusedTextBox() == gui.commandBar and not ignoreUpdate then
		ignoreUpdate = true
		gui.commandBar.Text = gui.commandBar.Text:gsub("^%W+", ""):gsub("\t", "")
		ignoreUpdate = false
		gui.commandBar.TextXAlignment = Enum.TextXAlignment[if gui.commandBar.TextFits then "Left" else "Right"]
		local command = gui.commandBar.Text:split("/")
		command = ((command[#command] or ""):split(" ")[1] or ""):lower()
		gui.suggestionsScroll.CanvasSize = UDim2.new()
		gui.suggestionsGridLayout.Parent = nil
		destroy(suggestions)
		for commandNames, commandInfo in commands do
			commandNames = (if commandInfo.Toggles then `{commandNames}_{commandInfo.Toggles}` else commandNames):split(
				"_"
			)
			for _, commandName in commandNames do
				if commandName:lower():find(command, 1, true) then
					local displayName = if commandInfo.Toggles and commandInfo.Enabled
						then commandInfo.Toggles:split("_")[1]
						else commandNames[1]
					table.insert(suggestions, {
						Command = displayName,
						CommandNames = commandNames,
						Display = ("<font color = '#FFFFFF'>%s</font>%s%s"):format(
							displayName,
							if commandInfo.Arguments
								then (function()
									local arguments = {}
									for _, argumentInfo in commandInfo.Arguments do
										table.insert(
											arguments,
											`{argumentInfo.Name}: {argumentInfo.Type}{if argumentInfo.Required then "" else "?"}`
										)
									end
									return ` <i>{table.concat(arguments, " ")}</i>`
								end)()
								else "",
							if commandInfo.Toggles then " [Toggles]" else ""
						),
					})
					break
				end
			end
		end
		if #command < 2 then
			table.sort(suggestions, function(suggestion0, suggestion1)
				suggestion0 = service("Text"):GetTextSize(suggestion0.Command, 14, Enum.Font.Arial, Vector2.one * 1e6).X
				suggestion1 = service("Text"):GetTextSize(suggestion1.Command, 14, Enum.Font.Arial, Vector2.one * 1e6).X
				return if checkAxis("Y") then suggestion0 < suggestion1 else suggestion1 < suggestion0
			end)
		else
			local function matchRate(suggestion)
				local highestMatch = 0
				for _, name in suggestion.CommandNames do
					local matchPercent = 1 - #name:lower():gsub(command, "") / #name
					if highestMatch < matchPercent then
						highestMatch = matchPercent
					end
				end
				return highestMatch
			end
			table.sort(suggestions, function(suggestion0, suggestion1)
				return if checkAxis("Y")
					then matchRate(suggestion1) < matchRate(suggestion0)
					else matchRate(suggestion0) < matchRate(suggestion1)
			end)
		end
		for index, suggestion in suggestions do
			suggestion.UI = newInstance("TextLabel", gui.suggestionsScroll, {
				TextSize = 14,
				RichText = true,
				BorderSizePixel = 0,
				LayoutOrder = index,
				Font = Enum.Font.Arial,
				Text = suggestion.Display,
				BackgroundTransparency = 1,
				TextStrokeTransparency = 0.8,
				BackgroundColor3 = Color3.new(1, 1, 1),
				TextColor3 = Color3.fromHex("A0A0A0"),
				TextXAlignment = Enum.TextXAlignment.Left,
			})
		end
		if 0 < #suggestions then
			selected = if checkAxis("Y") then 1 else #suggestions
			gui.selectorBorder.Enabled = true
		else
			selected = nil
			gui.selectorBorder.Enabled = false
		end
		gui.suggestionsGridLayout.Parent = gui.suggestionsScroll
		local commandNumber = #gui.suggestionsScroll:GetChildren() - 1
		gui.suggestionsScroll.CanvasSize = UDim2.new(0, 0, 0, 20 * commandNumber)
		gui.suggestionsScroll.CanvasPosition = Vector2.yAxis * (if checkAxis("Y") then 0 else 20 * commandNumber)
		gui.suggestionSelector.Position = if checkAxis("Y") then UDim2.new(0, 1, 0, 4) else UDim2.new(0, 1, 1, -24)
		resizeMain(nil, if 0 < commandNumber then 48 + 20 * math.min(commandNumber, 5) else 40)
	end
end
local sendValue = newInstance("BindableEvent")
local removing
connections = {
	connect(owner.CharacterAdded, function(NewCharacter: Model)
		sendValue:Fire("Character", NewCharacter)
	end),
	connect(owner.ChildAdded, function(Object: Backpack | PlayerGui)
		if valid.instance(Object, "Backpack") then
			sendValue:Fire("Backpack", Object)
		elseif valid.instance(Object, "PlayerGui") then
			sendValue:Fire("PlayerGui", Object)
		end
	end),
	isfile and connect(service("Run").Heartbeat, function()
		if not valid.instance(gui.holder, "ScreenGui") or not gui.holder:IsDescendantOf(hiddenGui) and not removing then
			removing = true
			local unfinished = 0
			for _, info in commands do
				if info.ToggleCheck and info.Enabled then
					task.spawn(function()
						unfinished += 1
						runCommand(info.Toggles:split("_")[1])
						unfinished -= 1
					end)
				end
			end
			waitForSignal(function()
				wait()
				return unfinished < 1
			end, 10)
			destroy(connections, gui, sendValue)
		end
		if settings.autoUpdate and 60 < os.clock() - lastCheck then
			lastCheck = os.clock()
			local success, result = pcall(
				game.HttpGet,
				game,
				"https://raw.githubusercontent.com/Amourousity/Ultimatum/main/Source.lua",
				true
			)
			if success and (not isfile("Ultimatum.lua") or result ~= readfile("Ultimatum.lua")) then
				writefile("Ultimatum.lua", result)
				notify({
					yields = true,
					title = "Out of Date",
					text = "Your version of Ultimatum is outdated! Updating to newest version...",
				})
				loadstring(result, "Ultimatum")()
			elseif not success and not isfile("Ultimatum.lua") then
				notify({
					text = result,
					important = true,
					title = "Error",
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
	connect(gui.main.MouseEnter, function()
		if not debounce then
			service("UserInput").OverrideMouseIconBehavior = Enum.OverrideMouseIconBehavior.ForceShow
			lastLeft = os.clock()
			resizeMain()
		end
	end),
	connect(gui.main.MouseLeave, function()
		if not debounce then
			lastLeft = os.clock()
			wait(1)
			if 1 < os.clock() - lastLeft and not debounce then
				service("UserInput").OverrideMouseIconBehavior = Enum.OverrideMouseIconBehavior.None
				resizeMain(40)
			end
		end
	end),
	connect(gui.commandBar.Focused, function()
		if not debounce then
			debounce = true
			gui.commandBar.PlaceholderText = "Enter a command..."
			service("UserInput").OverrideMouseIconBehavior = Enum.OverrideMouseIconBehavior.ForceShow
			resizeMain()
			task.delay(0.25, updateSuggestions)
		end
	end),
	connect(gui.commandBar.FocusLost, function(sent)
		wait()
		gui.commandBar.PlaceholderText = "Enter a command"
		if sent and 0 < #gui.commandBar.Text then
			task.spawn(runCommand, gui.commandBar.Text)
		end
		gui.commandBar.Text = ""
		gui.commandBar.TextXAlignment = Enum.TextXAlignment[if gui.commandBar.TextFits then "Left" else "Right"]
		service("UserInput").OverrideMouseIconBehavior = Enum.OverrideMouseIconBehavior.None
		resizeMain()
		task.delay(0.25, function()
			hiddenGui.Parent = nil
			hiddenGui.Parent = hiddenGuiParent
			if service("UserInput"):GetFocusedTextBox() ~= gui.commandBar then
				resizeMain(40)
				wait(0.25)
				gui.commandBar.PlaceholderText =
					`Enter a command (Keybind:\u{200A}{service("UserInput"):GetStringForKeyCode(
						Enum.KeyCode[settings.keybind]
					)}\u{200A})`
			end
		end)
		debounce = false
	end),
	connect(service("UserInput").InputBegan, function(input: InputObject, ignore: boolean)
		if input.UserInputType.Name == "Keyboard" then
			input = input.KeyCode.Name
			if not ignore and input == settings.keybind and not debounce then
				task.defer(gui.commandBar.CaptureFocus, gui.commandBar)
			elseif service("UserInput"):GetFocusedTextBox() == gui.commandBar and 0 < #suggestions then
				if input == "Up" or input == "Down" then
					scrollSuggestions(input)
					local start = os.clock()
					while service("UserInput"):IsKeyDown(Enum.KeyCode[input]) and os.clock() - start < 0.5 do
						wait()
					end
					if 0.25 < os.clock() - start then
						repeat
							scrollSuggestions(input)
							wait(1 / 30)
						until not service("UserInput"):IsKeyDown(Enum.KeyCode[input])
					end
				elseif input == "Tab" then
					gui.commandBar.Text = suggestions[selected].Command
					gui.commandBar.CursorPosition = #gui.commandBar.Text
				end
			end
		end
	end),
	connect(gui.commandBar:GetPropertyChangedSignal("Text"), updateSuggestions),
}
if not globalEnvironment.ultimatumGuis then
	globalEnvironment.ultimatumGuis = {}
end
destroy(globalEnvironment.ultimatumGuis)
table.insert(globalEnvironment.ultimatumGuis, gui)
local function loadCommands(luau: string, name: string?)
	name = valid.string(name, "Custom Command Set")
	local commandSet, errorMessage = loadstring(
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
			addConnections({
				connect(receiveValue.Event, function(Type, Object)
					if Type == "Character" then
						character = Object
					elseif Type == "Backpack" then
						backpack = Object
					elseif Type == "PlayerGui" then
						playerGui = Object
					end
				end),
			})
		%s]]):gsub("\n\t*", " "):format(luau),
		name
	)
	if not commandSet then
		warn(errorMessage)
		notify({
			title = `{name} Failed`,
			text = "The command set failed to load. Check the Developer Console for any error messages",
		})
		return
	end
	setfenv(commandSet, getfenv())
	local success, result = pcall(
		commandSet,
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
	if not success then
		warn(result)
		notify({
			title = `{name} Failed`,
			text = "The command set failed to load. Check the Developer Console for any error messages",
		})
		return
	end
	for commandName, info in result do
		if commands[commandName] and commands[commandName].ToggleCheck and commands[commandName].Enabled then
			runCommand(commands[commandName].Toggles:split("_")[1])
		end
		commands[commandName] = info
	end
end
globalEnvironment.addUltimatumCommands = loadCommands
local function getCommandSet(id)
	id = valid.number(id, 0)
	local success, result = pcall(
		game.HttpGet,
		game,
		`https://raw.githubusercontent.com/Amourousity/Ultimatum/main/CommandSets/{id}.lua`,
		true
	)
	if isfolder and not isfolder("UltimatumCommandSets") then
		makefolder("UltimatumCommandSets")
	end
	if success then
		if isfolder then
			writefile(`UltimatumCommandSets/{id}.lua`, result)
		end
	elseif isfolder and isfile and isfile(`UltimatumCommandSets/{id}.lua`) then
		success, result = true, readfile(`UltimatumCommandSets/{id}.lua`)
	end
	if success then
		loadCommands(result, `Command Set {id}`)
	elseif result ~= "HTTP 404 (Not Found)" then
		notify({
			title = "Failed to Load",
			text = `Command set {id} failed to download; is GitHub down?`,
		})
	end
end
enableDrag(gui.main, true)
pcall(function()
	hiddenGui.Parent = nil
	hiddenGui.Parent = hiddenGuiParent
end)
while service("CoreGui"):FindFirstChild("RobloxLoadingGUI") do
	service("CoreGui").ChildRemoved:Wait()
end
pcall(function()
	if settings.playIntro == "always" or settings.playIntro == "once" and not globalEnvironment.ultimatumLoaded then
		globalEnvironment.ultimatumLoaded = true
		service("UserInput").OverrideMouseIconBehavior = Enum.OverrideMouseIconBehavior.ForceHide
		task.delay(1.5, function()
			service("UserInput").OverrideMouseIconBehavior = Enum.OverrideMouseIconBehavior.None
		end)
		service("Run"):SetRobloxGuiFocused(true)
		task.delay(1.5, service("Run").SetRobloxGuiFocused, service("Run"), false)
		animate(
			gui.screenCover,
			{
				secondsTime = 0.25,
				easingStyle = Enum.EasingStyle.Linear,
				properties = { BackgroundTransparency = 0.2 },
			},
			gui.main,
			{
				yields = true,
				properties = {
					BackgroundTransparency = 0,
					Position = UDim2.new(0.5, 0, 0.5, 0),
				},
			},
			gui.logo,
			{
				properties = {
					Rotation = 0,
					ImageTransparency = 0,
				},
			},
			gui.mainCorner,
			{
				yields = true,
				finishDelay = 0.5,
				properties = { CornerRadius = UDim.new(0, 4) },
			},
			gui.screenCover,
			{
				secondsTime = 0.25,
				easingStyle = Enum.EasingStyle.Linear,
				properties = { BackgroundTransparency = 1 },
			},
			gui.main,
			{
				properties = {
					Rotation = 180,
					Size = UDim2.new(),
				},
				easingStyle = Enum.EasingStyle.Back,
				easingDirection = Enum.EasingDirection.In,
			},
			gui.mainCorner,
			{
				properties = { CornerRadius = UDim.new(0.5, 0) },
			},
			gui.logo,
			{
				yields = true,
				properties = { ImageTransparency = 1 },
			}
		)
	else
		globalEnvironment.ultimatumLoaded = true
	end
	wait()
	destroy(gui.screenCover, gui.mainListLayout)
	gui.screenCover, gui.mainListLayout = nil, nil
	for objectName, properties in
		{
			logo = {
				Rotation = 0,
				ImageTransparency = 0,
			},
			main = {
				Rotation = 0,
				AnchorPoint = Vector2.zero,
				BackgroundTransparency = 0,
				Size = UDim2.new(0, 40, 0, 40),
				Position = UDim2.new(0, 0, 1, 0),
			},
			mainCorner = { CornerRadius = UDim.new(0, 4) },
			mainAspectRatioConstraint = { Parent = gui.logo },
			commandBarSection = { Size = UDim2.new(1, 0, 0, 40) },
			suggestionsSection = { Size = UDim2.new(1, 0, 1, -40) },
		}
	do
		for name, value in properties do
			gui[objectName][name] = value
		end
	end
	resizeMain(40)
	animate(gui.main, {
		yields = true,
		properties = { Position = UDim2.new(0, 0, 1, -40) },
	})
	debounce = false
	getCommandSet()
	getCommandSet(game.PlaceId)
end)