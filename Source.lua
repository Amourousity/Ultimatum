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
local function Load(Name)
	local SourceName,Success,Result = ("%s.lua"):format(Name),pcall(game.HttpGet,game,("https://raw.githubusercontent.com/Amourousity/%s/main/Source.lua"):format(Name),true)
	if Success then
		if writefile then
			writefile(SourceName,Result)
		else
			return loadstring(Result,Name)
		end
	end
	if isfile and isfile(SourceName) then
		return loadstring(readfile(SourceName),Name)
	end
end
Load"Conversio"()
local Utilitas = Load"Utilitas""All"
local Owner,Nil,Connect,Destroy,Wait,Service,Valid,WaitForSequence,RandomString,RandomBool,NilConvert,NewInstance,Create,DecodeJSON,WaitForSignal,Animate,Assert,GetCharacter,GetHumanoid,ConvertTime,GetContentText,WaitForChildOfClass = unpack(Utilitas)
local GlobalEnvironment = getgenv and getgenv() or shared
pcall(GlobalEnvironment.Ultimatum)
local OwnerSettings
do
	local DefaultSettings = {
		Scale = 1,
		StayOpen = false,
		AutoUpdate = true,
		LoadOnRejoin = true,
		PlayIntro = "Always",
		Notifications = "All",
		Keybind = "LeftBracket"
	}
	local Settings = DecodeJSON(isfile and isfile"UltimatumSettings.json" and readfile"UltimatumSettings.json":gsub("^%bA{","{"),DefaultSettings)
	for SettingName in Settings do
		if DefaultSettings[SettingName] == nil then
			Settings[SettingName] = nil
		end
	end
	OwnerSettings = setmetatable({},{
		__index = function(_,Index)
			return Settings[Index]
		end,
		__newindex = function(_,Index,Value)
			Settings[Index] = Value
			if writefile then
				local FormattedSettings = {}
				for SettingName,SettingValue in Settings do
					table.insert(FormattedSettings,("\t%s : %s,"):format(("%q"):format(SettingName),type(SettingValue) == "string" and ("%q"):format(SettingValue) or tostring(SettingValue)))
				end
				table.sort(FormattedSettings,function(String1,String2)
					if #String1 < #String2 then
						return true
					elseif #String2 < #String1 then
						return false
					end
					String1,String2 = {String1:byte(1,-2)},{String2:byte(1,-2)}
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
				writefile("UltimatumSettings.json",("All settings for Ultimatum.\nDo not edit this file unless you know what you're doing.\nEvery setting can be changed in-game using the \"Settings\" command.\n{\n%s\n}"):format(table.concat(FormattedSettings,"\n")))
			end
		end,
		__metatable = "nil"
	})
end
OwnerSettings._ = nil
if Service"CoreGui":FindFirstChild"RobloxLoadingGui" and Service"CoreGui".RobloxLoadingGui:FindFirstChild"BlackFrame" and Service"CoreGui".RobloxLoadingGui.BlackFrame.BackgroundTransparency <= 0 then
	WaitForSignal(Service"CoreGui".RobloxLoadingGui.BlackFrame:GetPropertyChangedSignal"BackgroundTransparency",3)
	Wait(math.random())
end
pcall(GlobalEnvironment.Ultimatum)
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
		Name = "ScreenCover",
		Parent = "Holder",
		ClassName = "TextButton",
		Properties = {
			ZIndex = -1,
			Modal = true,
			Active = true,
			TextTransparency = 1,
			AutoButtonColor = false,
			Size = UDim2.new(1,0,1,0),
			BackgroundTransparency = 1,
			BackgroundColor3 = Color3.new()
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
		Properties = {CornerRadius = UDim.new(.5,0)}
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
		Properties = {DominantAxis = Enum.DominantAxis.Height}
	},
	{
		Name = "MainListLayout",
		Parent = "Main",
		ClassName = "UIListLayout",
		Properties = {SortOrder = Enum.SortOrder.LayoutOrder}
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
			Size = UDim2.new(1,-44,.8,0)
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
			Size = UDim2.new(1,-20,1,0),
			Position = UDim2.new(0,10,0,0),
			TextColor3 = Color3.new(1,1,1),
			TextXAlignment = Enum.TextXAlignment.Left,
			PlaceholderColor3 = Color3.fromHex"A0A0A0",
			PlaceholderText = ("Enter a command (Keybind:\u{200A}%s\u{200A})"):format(Service"UserInput":GetStringForKeyCode(Enum.KeyCode[OwnerSettings.Keybind]))
		}
	},
	{
		Name = "CommandBarCorner",
		Parent = "CommandBarBackground",
		ClassName = "UICorner",
		Properties = {CornerRadius = UDim.new(0,4)}
	},
	{
		Name = "SuggestionsSection",
		Parent = "Main",
		ClassName = "Frame",
		Properties = {
			ClipsDescendants = true,
			BackgroundTransparency = 1
		}
	},
	{
		Name = "SuggestionsScroll",
		Parent = "SuggestionsSection",
		ClassName = "ScrollingFrame",
		Properties = {
			BorderSizePixel = 0,
			ScrollBarThickness = 0,
			BackgroundTransparency = 1,
			Size = UDim2.new(1,-8,1,-8),
			Position = UDim2.new(0,4,0,4)
		}
	},
	{
		Name = "SuggestionsGridLayout",
		Parent = "SuggestionsScroll",
		ClassName = "UIGridLayout",
		Properties = {
			CellPadding = UDim2.new(),
			CellSize = UDim2.new(1,0,0,20),
			SortOrder = Enum.SortOrder.LayoutOrder
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
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Bottom,
			HorizontalAlignment = Enum.HorizontalAlignment.Right
		}
	}
}
local NotificationIDs = {}
local function Notify(Settings)
	Settings = Valid.Table(Settings,{
		Buttons = {},
		Duration = 5,
		Urgent = false,
		Yields = false,
		Text = "(no text)",
		Title = "Ultimatum",
		CalculateDuration = true
	})
	Settings.Text = ("<b>%s</b>\n%s"):format(Settings.Title,Settings.Text)
	if OwnerSettings.Notifications == "Off" or OwnerSettings.Notifications == "Urgent" and not Settings.Urgent then
		return
	end
	local ID
	repeat
		ID = RandomString{
			Length = 5,
			Format = "%s"
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
			Properties = {CornerRadius = UDim.new(0,4)}
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
		Properties = {TextTransparency = 0},
		EasingStyle = Enum.EasingStyle.Linear
	})
	task.delay(Settings.Duration,Animate,Notification.Main,{
		Time = 1,
		Properties = {BackgroundTransparency = 1}
	},Notification.Content,{
		Time = 1,
		Yields = true,
		Properties = {TextTransparency = 1},
		EasingStyle = Enum.EasingStyle.Linear
	},Notification.Main,{
		Time = .25,
		Properties = {Size = UDim2.new(Size.X.Scale,Size.X.Offset,0,0)}
	})
	Settings.Duration += 1.25
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
local LastCheck,Debounce,LastLeft = 0,true,0
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
		Properties = {Visible = 40 < X}
	})
end
local Commands = {}
local Connections
local function RunCommand(Text)
	for _,Input in Text:split"/" do
		local Arguments = Input:split" "
		local Command = Arguments[1]
		table.remove(Arguments,1)
		local RanCommand
		for CommandNames,CommandInfo in Commands do
			if CommandInfo.Toggles then
				CommandNames = ("%s_%s"):format(CommandNames,CommandInfo.Toggles)
			end
			CommandNames = CommandNames:split"_"
			local Continue
			for _,CommandName in CommandNames do
				if CommandName:lower() == Command:lower() then
					CommandInfo.Arguments = Valid.Table(CommandInfo.Arguments)
					for ArgumentNumber,ArgumentProperties in CommandInfo.Arguments do
						if ArgumentProperties.Required and not Arguments[ArgumentNumber] then
							Notify{
								Title = "Missing Argument",
								Text = ('The command "%s" requires you to enter the argument "%s"'):format(CommandNames[1],ArgumentProperties.Name)
							}
							break
						end
						if ArgumentProperties.Concatenate then
							Arguments[ArgumentNumber] = table.concat(Arguments," ",ArgumentNumber)
							for Index = ArgumentNumber+1,#Arguments do
								Arguments[Index] = nil
							end
						end
						Arguments[ArgumentNumber] = Valid[ArgumentProperties.Type](Arguments[ArgumentNumber],ArgumentProperties.Substitute)
					end
					if CommandInfo.Toggles then
						local Enabled = true
						for _,Toggle in CommandInfo.Toggles:lower():split"_" do
							if Toggle == Command:lower() then
								Enabled = false
								break
							end
						end
						if CommandInfo.ToggleCheck then
							if (CommandInfo.Enabled or false) == Enabled then
								Enabled = Enabled and "En" or "Dis"
								Notify{
									Title = ("Already %sabled"):format(Enabled),
									Text = ("The command is already %sabled"):format(Enabled:lower())
								}
								return
							end
							CommandInfo.Enabled = Enabled
						end
						table.insert(Arguments,1,Enabled)
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
	for Name,Connection in Valid.Table(GivenConnections) do
		if typeof(Connection) == "RBXScriptConnection" and Connection.Connected then
			Connections[if type(Name) ~= "number" then Name else #Connections+1] = Connection
			table.insert(Connections,Connection)
		end
	end
end
local function RemoveConnections(GivenConnections)
	for _,Connection in Valid.Table(GivenConnections) do
		if typeof(Connection) == "RBXScriptConnection" then
			Destroy(Connection)
			pcall(table.remove,Connections,table.find(Connections,Connection))
		end
	end
end
local function EnableDrag(Frame,IsMain)
	local DragConnection
	local InputBegan,InputEnded,Removed = Connect(Frame.InputBegan,function(Input,Ignore)
		if not Ignore and not Debounce and Input.UserInputType.Name == "MouseButton1" then
			if IsMain then
				ResizeMain(40)
			end
			Debounce = true
			DragConnection = Connect(Service"Run".RenderStepped,function()
				Service"UserInput".OverrideMouseIconBehavior = Enum.OverrideMouseIconBehavior.ForceHide
				local MousePosition = Service"UserInput":GetMouseLocation()
				local ScreenSize,FrameSize,AnchorPoint = Gui.Holder.AbsoluteSize,Frame.AbsoluteSize,Frame.AnchorPoint
				MousePosition = UDim2.new(math.round(math.clamp(MousePosition.X-FrameSize.X/2+FrameSize.X*AnchorPoint.X,FrameSize.X*AnchorPoint.X,ScreenSize.X-FrameSize.X*(1-AnchorPoint.X)))/ScreenSize.X,0,math.round(math.clamp(MousePosition.Y-FrameSize.Y/2+FrameSize.Y*AnchorPoint.Y,FrameSize.Y*AnchorPoint.Y,ScreenSize.Y-FrameSize.Y*(1-AnchorPoint.Y)))/ScreenSize.Y,0)
				Animate(Frame,{
					Time = 0,
					Properties = {Position = MousePosition}
				})
			end)
			AddConnections{DragConnection}
		end
	end),Connect(Service"UserInput".InputEnded,function(Input)
		if DragConnection and Input.UserInputType.Name == "MouseButton1" then
			Service"UserInput".OverrideMouseIconBehavior = Enum.OverrideMouseIconBehavior.None
			RemoveConnections{DragConnection}
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
local function CreateWindow(Title)
	local Window = Create{
		{
			Name = "Main",
			Parent = Gui.Holder,
			ClassName = "Frame",
			Properties = {
				ClipsDescendants = true,
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
			Properties = {CornerRadius = UDim.new(0,4)}
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
				Font = Enum.Font.Arial,
				BackgroundTransparency = 1,
				Size = UDim2.new(1,-45,0,20),
				Position = UDim2.new(0,5,0,0),
				TextColor3 = Color3.new(1,1,1),
				Text = Valid.String(Title,"Ultimatum"),
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
			Name = "Close",
			Parent = "Main",
			ClassName = "ImageButton",
			Properties = {
				Modal = true,
				AutoButtonColor = false,
				BackgroundTransparency = 1,
				Size = UDim2.new(0,14,0,14),
				Position = UDim2.new(1,-17,0,3),
				Image = "rbxasset://textures/DevConsole/Close.png"
			}
		},
		{
			Name = "Minimize",
			Parent = "Main",
			ClassName = "ImageButton",
			Properties = {
				Modal = true,
				AutoButtonColor = false,
				BackgroundTransparency = 1,
				Size = UDim2.new(0,14,0,14),
				Position = UDim2.new(1,-37,0,3),
				Image = "rbxasset://textures/DevConsole/Minimize.png"
			}
		}
	}
	task.defer(function()
		Animate(Window.Main,{
			Yields = true,
			Properties = {Position = UDim2.new(.5,0,.5,0)}
		})
		EnableDrag(Window.Main)
		local Minimize,Close = Connect(Window.Minimize.MouseButton1Click,function()
		end)
		AddConnections{
			Close,
			Minimize
		}
		Close = Connect(Window.Close.MouseButton1Click,function()
			RemoveConnections{
				Close,
				Minimize
			}
			Animate(Window.Main,{
				Yields = true,
				EasingDirection = Enum.EasingDirection.In,
				Properties = {Position = UDim2.new(Window.Main.Position.X.Scale,0,1,125)}
			})
			Destroy(Window)
		end)
	end)
	return Window
end
local function FireTouchInterest(Toucher,Touched,TouchTime)
	TouchTime = Valid.Number(TouchTime,0)
	if firetouchinterest then
		for On = 0,1 do
			firetouchinterest(Toucher,Touched,On)
			if On == 0 then
				Wait(TouchTime)
			end
		end
	else
		local OldCFrame = Touched.CFrame
		Touched.CFrame = Toucher.CFrame
		Wait(TouchTime)
		Touched.CFrame = OldCFrame
	end
end
local IgnoreUpdate
local function UpdateSuggestions()
	if Service"UserInput":GetFocusedTextBox() == Gui.CommandBar and not IgnoreUpdate then
		IgnoreUpdate = true
		Gui.CommandBar.Text = Gui.CommandBar.Text:gsub("^%W+","")
		IgnoreUpdate = false
		Gui.CommandBar.TextXAlignment = Enum.TextXAlignment[Gui.CommandBar.TextFits and "Left" or "Right"]
		local Command = Gui.CommandBar.Text:split"/"
		Command = ((Command[#Command] or ""):split" "[1] or ""):lower()
		Gui.SuggestionsScroll.CanvasSize = UDim2.new()
		for _,TextLabel in Gui.SuggestionsScroll:GetChildren() do
			if Valid.Instance(TextLabel,"TextLabel") then
				Destroy(TextLabel)
			end
		end
		local CommandDisplays = {}
		for CommandNames,CommandInfo in Commands do
			if CommandInfo.Toggles then
				CommandNames = ("%s_%s"):format(CommandNames,CommandInfo.Toggles)
			end
			CommandNames = CommandNames:split"_"
			for _,CommandName in CommandNames do
				if CommandName:lower():find(Command,1,true) then
					table.insert(CommandDisplays,("<font color = '#FFFFFF'>%s</font>%s%s"):format(CommandNames[1],CommandInfo.Arguments and (function()
						local Arguments = {}
						for _,ArgumentInfo in CommandInfo.Arguments do
							table.insert(Arguments,("%s:%s"):format(ArgumentInfo.Name,ArgumentInfo.Type))
						end
						return (" <i>%s</i>"):format(table.concat(Arguments," "))
					end)() or "",CommandInfo.Toggles and " [Toggles]" or ""))
					break
				end
			end
		end
		table.sort(CommandDisplays,function(String1,String2)
			String1 = Service"Text":GetTextSize(GetContentText(String1):split" "[1],14,Enum.Font.Arial,Vector2.new(1e6,1e6)).X
			String2 = Service"Text":GetTextSize(GetContentText(String2):split" "[1],14,Enum.Font.Arial,Vector2.new(1e6,1e6)).X
			return if CheckAxis"Y" then String1 < String2 else String2 < String1
		end)
		for Index,Text in CommandDisplays do
			NewInstance("TextLabel",Gui.SuggestionsScroll,{
				Text = Text,
				TextSize = 14,
				RichText = true,
				LayoutOrder = Index,
				Font = Enum.Font.Arial,
				BackgroundTransparency = 1,
				TextStrokeTransparency = .8,
				TextColor3 = Color3.fromHex"A0A0A0",
				TextXAlignment = Enum.TextXAlignment.Left
			})
		end
		local CommandNumber = #Gui.SuggestionsScroll:GetChildren()-1
		Gui.SuggestionsScroll.CanvasSize = UDim2.new(0,0,0,20*CommandNumber)
		ResizeMain(nil,0 < CommandNumber and 48+20*math.min(CommandNumber,5) or 40)
	end
end
local SendValue = NewInstance"BindableEvent"
Connections = {
	Connect(Owner.CharacterAdded,function(NewCharacter)
		SendValue:Fire("Character",NewCharacter)
	end),
	Connect(Owner.ChildAdded,function(Object)
		if Valid.Instance(Object,"Backpack") then
			SendValue:Fire("Backpack",Object)
		elseif Valid.Instance(Object,"PlayerGui") then
			SendValue:Fire("PlayerGui",Object)
		end
	end),
	not GlobalEnvironment.UltimatumDebug and isfile and Connect(Service"Run".Heartbeat,function()
		if OwnerSettings.AutoUpdate and 60 < os.clock()-LastCheck then
			LastCheck = os.clock()
			local Success,Result = pcall(game.HttpGet,game,"https://raw.githubusercontent.com/Amourousity/Ultimatum/main/Source.lua",true)
			if Success and (not isfile"Ultimatum.lua" or Result ~= readfile"Ultimatum.lua") then
				writefile("Ultimatum.lua",Result)
				Notify{
					Yields = true,
					Duration = .75,
					CalculateDuration = false,
					Title = "Update Detected",
					Text = "Ultimatum will now update..."
				}
				loadstring(Result,"Ultimatum")()
			elseif not Success and not isfile"Ultimatum.lua" then
				Notify{
					Text = Result,
					Urgent = true,
					Title = "Error"
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
	Connect(Gui.Main.MouseEnter,function()
		if not Debounce then
			Service"UserInput".OverrideMouseIconBehavior = Enum.OverrideMouseIconBehavior.ForceShow
			LastLeft = os.clock()
			ResizeMain()
		end
	end),
	Connect(Gui.Main.MouseLeave,function()
		if not Debounce then
			LastLeft = os.clock()
			Wait(1)
			if 1 < os.clock()-LastLeft and not Debounce then
				Service"UserInput".OverrideMouseIconBehavior = Enum.OverrideMouseIconBehavior.None
				ResizeMain(40)
			end
		end
	end),
	Connect(Gui.CommandBar.Focused,function()
		if not Debounce then
			Debounce = true
			Gui.CommandBar.PlaceholderText = "Enter a command..."
			Service"UserInput".OverrideMouseIconBehavior = Enum.OverrideMouseIconBehavior.ForceShow
			ResizeMain()
			task.delay(.25,UpdateSuggestions)
		end
	end),
	Connect(Gui.CommandBar.FocusLost,function(Sent)
		Wait()
		Gui.CommandBar.PlaceholderText = ("Enter a command (Keybind:\u{200A}%s\u{200A})"):format(Service"UserInput":GetStringForKeyCode(Enum.KeyCode[OwnerSettings.Keybind]))
		if Sent and 0 < #Gui.CommandBar.Text then
			task.spawn(RunCommand,Gui.CommandBar.Text)
			Gui.CommandBar.Text = ""
		elseif Service"UserInput":IsKeyDown(Enum.KeyCode.Escape) then
			Gui.CommandBar.Text = ""
		end
		Gui.CommandBar.TextXAlignment = Enum.TextXAlignment[Gui.CommandBar.TextFits and "Left" or "Right"]
		Service"UserInput".OverrideMouseIconBehavior = Enum.OverrideMouseIconBehavior.None
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
local function GetCommandSet(ID)
	ID = Valid.Number(ID,0)
	local Success,Result = pcall(game.HttpGet,game,("https://raw.githubusercontent.com/Amourousity/Ultimatum/main/CommandSets/%d.lua"):format(ID),true)
	if isfolder and not isfolder"UltimatumCommandSets" then
		makefolder"UltimatumCommandSets"
	end
	if Success then
		if isfolder then
			writefile(("UltimatumCommandSets/%d.lua"):format(ID),Result)
		end
	elseif isfolder and isfile and isfile(("UltimatumCommandSets/%d.lua"):format(ID)) then
		Success,Result = true,readfile(("UltimatumCommandSets/%d.lua"):format(ID))
	end
	if Success then
		for Name,Info in loadstring(Result,("Command Set %d"):format(ID))(Utilitas,SendValue,Notify,RunCommand,AddConnections,RemoveConnections,CreateWindow,FireTouchInterest,Gui,GetCharacter(Owner,.5),WaitForChildOfClass(Owner,"Backpack"),WaitForChildOfClass(Owner,"PlayerGui")) do
			if printuiconsole then
				printuiconsole(("Loaded %s"):format(Name:split"_"[1]))
			end
			Commands[Name] = Info
		end
	end
end
GetCommandSet()
GetCommandSet(game.PlaceId)
pcall(GlobalEnvironment.Ultimatum)
GlobalEnvironment.Ultimatum = function()
	local Unfinished = 0
	for _,Info in Commands do
		if Info.ToggleCheck and Info.Enabled then
			task.spawn(function()
				Unfinished += 1
				RunCommand(Info.Toggles:split"_"[1])
				Unfinished -= 1
			end)
		end
	end
	WaitForSignal(function()
		Wait()
		return Unfinished < 1
	end,10)
	Destroy(Connections,Gui)
	GlobalEnvironment.Ultimatum = nil
end
EnableDrag(Gui.Main,true)
if OwnerSettings.PlayIntro == "Always" or OwnerSettings.PlayIntro == "Once" and not GlobalEnvironment.UltimatumLoaded then
	GlobalEnvironment.UltimatumLoaded = true
	Service"UserInput".OverrideMouseIconBehavior = Enum.OverrideMouseIconBehavior.ForceHide
	task.delay(1.5,function()
		Service"UserInput".OverrideMouseIconBehavior = Enum.OverrideMouseIconBehavior.None
	end)
	Service"Run":SetRobloxGuiFocused(true)
	task.delay(1.5,Service"Run".SetRobloxGuiFocused,Service"Run",false)
	Animate(Gui.ScreenCover,{
		Time = .25,
		EasingStyle = Enum.EasingStyle.Linear,
		Properties = {BackgroundTransparency = .2}
	},Gui.Main,{
		Yields = true,
		Properties = {
			BackgroundTransparency = 0,
			Position = UDim2.new(.5,0,.5,0)
		}
	},Gui.Logo,{
		Properties = {
			Rotation = 0,
			ImageTransparency = 0
		}
	},Gui.MainCorner,{
		Yields = true,
		FinishDelay = .5,
		Properties = {CornerRadius = UDim.new(0,4)}
	},Gui.ScreenCover,{
		Time = .25,
		EasingStyle = Enum.EasingStyle.Linear,
		Properties = {BackgroundTransparency = 1}
	},Gui.Main,{
		Properties = {
			Rotation = 180,
			Size = UDim2.new()
		},
		EasingStyle = Enum.EasingStyle.Back,
		EasingDirection = Enum.EasingDirection.In
	},Gui.MainCorner,{
		Properties = {CornerRadius = UDim.new(.5,0)}
	},Gui.Logo,{
		Yields = true,
		Properties = {ImageTransparency = 1}
	})
else
	GlobalEnvironment.UltimatumLoaded = true
end
Wait()
Destroy(Gui.ScreenCover)
for Name,Properties in {
	Logo = {
		Rotation = 0,
		ImageTransparency = 0
	},
	Main = {
		Rotation = 0,
		AnchorPoint = Vector2.zero,
		BackgroundTransparency = 0,
		Size = UDim2.new(0,40,0,40),
		Position = UDim2.new(0,0,1,0)
	},
	MainListLayout = {Parent = Gui.MainSection},
	MainCorner = {CornerRadius = UDim.new(0,4)},
	MainAspectRatioConstraint = {Parent = Gui.Logo},
	CommandBarSection = {Size = UDim2.new(1,0,0,40)},
	SuggestionsSection = {Size = UDim2.new(1,0,1,-40)}
} do
	if not Gui or not Gui[Name] then
		pcall(GlobalEnvironment.Ultimatum)
		error(not Gui and "Ultimatum's Gui was never instantiated!" or ("Gui object \"%s\" was deleted or never instantiated!"):format(Name))
		return
	end
	for Property,Value in Properties do
		Gui[Name][Property] = Value
	end
end
ResizeMain(40)
Animate(Gui.Main,{
	Yields = true,
	Properties = {Position = UDim2.new(0,0,1,-40)}
})
Debounce = false
