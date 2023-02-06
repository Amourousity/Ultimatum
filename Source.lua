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
for Name,Function in Load"Utilitas"{} do
	getfenv()[Name] = Function
end
local HiddenUI = gethui and WaitForSignal(function()
	Wait()
	return gethui()
end) or Service"CoreGui"
local HiddenUIParent = HiddenUI.Parent
local GlobalEnvironment = getgenv and getgenv() or shared
local Settings
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
	local SettingsTable = DecodeJSON(isfile and isfile"UltimatumSettings.json" and readfile"UltimatumSettings.json":gsub("^%bA{","{"),DefaultSettings)
	for SettingName in SettingsTable do
		if DefaultSettings[SettingName] == nil then
			SettingsTable[SettingName] = nil
		end
	end
	Settings = setmetatable({},{
		__index = function(_,Index)
			return SettingsTable[Index]
		end,
		__newindex = function(_,Index,Value)
			SettingsTable[Index] = Value
			if writefile then
				local FormattedSettings = {}
				for SettingName,SettingValue in SettingsTable do
					table.insert(FormattedSettings,("\t%s: %s,"):format(("%q"):format(SettingName),type(SettingValue) == "string" and ("%q"):format(SettingValue) or tostring(SettingValue)))
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
Settings._ = nil
local function Holiday(String)
	local Emoji = os.date"%m%w" == "114" and math.clamp(tonumber(os.date"%d"),22,28) == tonumber(os.date"%d") and "\u{1F983}" or ({
		_0101 = "\u{1F386}",
		_0214 = "\u{1F495}",
		_0317 = "\u{1F340}",
		[(function(Year)
			local A = math.floor(Year/100)
			local B = math.floor((13+8*A)/25)
			local C = (15-B+A-math.floor(A/4))%30
			local D = (4+A-math.floor(A/4))%7
			local E = (19*(Year%19)+C)%30
			local F = (2*(Year%4)+4*(Year%7)+6*E+D)%7
			local G = (22+E+F)
			if F == 6 and (E == 29 or E == 28) then
				return ("_041%s"):format(tostring(E):sub(2))
			elseif 31 < G then
				return ("_04%02d"):format(G-31)
			end
			return ("_03%02d"):format(G)
		end)(tonumber(os.date"%Y"))] = "\u{1F95A}",
		_0704 = "\u{1F1FA}\u{1F1F8}",
		_0931 = "\u{1F383}",
		_1225 = "\u{1F384}"
	})[os.date"_%m%d"]
	return Emoji and ("%s %s %s"):format(Emoji,String,Emoji) or String
end
local Gui = Create{
	{
		Name = "Holder",
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
		ClassName = "Frame",
		Properties = {
			ZIndex = -1,
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
			ZIndex = 1,
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
			PlaceholderText = ("Enter a command (Keybind:\u{200A}%s\u{200A})"):format(Service"UserInput":GetStringForKeyCode(Enum.KeyCode[Settings.Keybind]))
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
			ScrollingEnabled = false,
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
		Name = "SuggestionSelector",
		Parent = "SuggestionsSection",
		ClassName = "Frame",
		Properties = {
			BackgroundTransparency = 1,
			Size = UDim2.new(1,-2,0,20)
		}
	},
	{
		Name = "SelectorCorner",
		Parent = "SuggestionSelector",
		ClassName = "UICorner",
		Properties = {CornerRadius = UDim.new(0,2)}
	},
	{
		Name = "SelectorBorder",
		Parent = "SuggestionSelector",
		ClassName = "UIStroke",
		Properties = {
			Enabled = false,
			Color = Color3.new(1,1,1)
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
local function Notify(Options)
	Options = Valid.Table(Options,{
		Duration = 5,
		Urgent = false,
		Yields = false,
		Text = "(no text)",
		Title = "Ultimatum",
		CalculateDuration = true
	})
	Options.Text = ("<b>%s</b>\n%s"):format(Options.Title,Options.Text)
	if Settings.Notifications == "Off" or Settings.Notifications == "Urgent" and not Options.Urgent then
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
				Text = Options.Text,
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
	if Options.CalculateDuration then
		for _ in utf8.graphemes(Notification.Content.ContentText) do
			Options.Duration += .06
		end
	end
	Options.Duration += .25
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
	task.delay(Options.Duration,Animate,Notification.Main,{
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
	Options.Duration += 1.25
	task.spawn(function()
		local Start = os.clock()
		repeat
			Notification.Main.LayoutOrder = table.find(NotificationIDs,ID)
			Wait()
		until Options.Duration < os.clock()-Start
		table.remove(NotificationIDs,table.find(NotificationIDs,ID))
	end)
	if Options.Yields then
		Wait(Options.Duration)
		Destroy(Notification)
	else
		task.delay(Options.Duration,Destroy,Notification)
	end
end
local function CheckAxis(Axis)
	return workspace.CurrentCamera.ViewportSize[Axis]/2 < Gui.Logo.AbsolutePosition[Axis]+Gui.Logo.AbsoluteSize[Axis]/2
end
local LastCheck,Debounce,LastLeft = 0,true,0
local function ResizeMain(X,Y)
	X = Settings.StayOpen and 400 or Valid.Number(X,400)
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
						end
						CommandInfo.Enabled = Enabled
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
		if not Frame:IsDescendantOf(HiddenUI) then
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
local function CreateWindow(Title,DataList)
	local Window = Create{
		{
			Name = "Main",
			Parent = Gui.Holder,
			ClassName = "Frame",
			Properties = {
				Active = true,
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
		},
		{
			Name = "Display",
			Parent = "Main",
			ClassName = "ScrollingFrame",
			Properties = {
				BorderSizePixel = 0,
				ScrollBarThickness = 0,
				BackgroundTransparency = 1,
				Size = UDim2.new(1,-8,1,-24),
				Position = UDim2.new(0,4,0,20)
			}
		},
		{
			Name = "DisplayListLayout",
			Parent = "Display",
			ClassName = "UIListLayout",
			Properties = {SortOrder = Enum.SortOrder.LayoutOrder}
		}
	}
	local WindowConnections = {}
	for Index,Data in DataList do
		local Main = NewInstance("TextLabel",nil,{
			LayoutOrder = Index,
			Font = Enum.Font.Arial,
			BackgroundTransparency = 1,
			Size = UDim2.new(1,0,0,20),
			TextStrokeTransparency = .8,
			Text = ("  %s"):format(Data.Text),
			TextXAlignment = Enum.TextXAlignment.Left
		});
		({
			Slider = function()
			end
		})[Data.Type]()
	end
	Animate(Window.Main,{
		Yields = true,
		Properties = {Position = UDim2.new(.5,0,.5,0)}
	})
	EnableDrag(Window.Main)
	table.insert(WindowConnections,Connect(Window.Minimize.MouseButton1Click,function()
	end))
	table.insert(WindowConnections,Connect(Window.Close.MouseButton1Click,function()
		RemoveConnections(WindowConnections)
		Animate(Window.Main,{
			Yields = true,
			EasingDirection = Enum.EasingDirection.In,
			Properties = {Position = UDim2.new(Window.Main.Position.X.Scale,0,1,125)}
		})
		Destroy(Window)
	end))
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
		local OldCanCollide,OldCanTouch,OldCFrame = Touched.CanCollide,Touched.CanTouch,Touched.CFrame
		Touched.CanCollide,Touched.CanTouch,Touched.CFrame = true,true,Toucher.CFrame
		Wait(TouchTime)
		Touched.CFrame,Touched.CanTouch,Touched.CanCollide = OldCFrame,OldCanTouch,OldCanCollide
	end
end
local IgnoreUpdate,Selected
local Suggestions = {}
local function ScrollSuggestions(Input)
	if 0 < #Suggestions then
		Selected = (Selected+(Input == "Up" and -1 or Input == "Down" and 1 or 0)-1)%#Suggestions+1
		local OldCanvasPosition = Gui.SuggestionsScroll.CanvasPosition
		Gui.SuggestionsScroll.CanvasPosition = Vector2.new(0,20*(Selected-3))
		Animate(Gui.SuggestionSelector,{
			Time = .25,
			Properties = {Position = UDim2.new(0,1,0,4+Suggestions[Selected].UI.AbsolutePosition.Y-Gui.SuggestionsScroll.AbsolutePosition.Y)}
		})
		local CanvasPosition = Gui.SuggestionsScroll.CanvasPosition
		Gui.SuggestionsScroll.CanvasPosition = OldCanvasPosition
		Animate(Gui.SuggestionsScroll,{
			Time = .25,
			Properties = {CanvasPosition = CanvasPosition}
		})
	end
end
local function UpdateSuggestions()
	if Service"UserInput":GetFocusedTextBox() == Gui.CommandBar and not IgnoreUpdate then
		IgnoreUpdate = true
		Gui.CommandBar.Text = Gui.CommandBar.Text:gsub("^%W+",""):gsub("\t","")
		IgnoreUpdate = false
		Gui.CommandBar.TextXAlignment = Enum.TextXAlignment[Gui.CommandBar.TextFits and "Left" or "Right"]
		local Command = Gui.CommandBar.Text:split"/"
		Command = ((Command[#Command] or ""):split" "[1] or ""):lower()
		Gui.SuggestionsScroll.CanvasSize = UDim2.new()
		Gui.SuggestionsGridLayout.Parent = nil
		Destroy(Suggestions)
		for CommandNames,CommandInfo in Commands do
			CommandNames = (CommandInfo.Toggles and ("%s_%s"):format(CommandNames,CommandInfo.Toggles) or CommandNames):split"_"
			for _,CommandName in CommandNames do
				if CommandName:lower():find(Command,1,true) then
					local DisplayName = CommandInfo.Toggles and CommandInfo.Enabled and CommandInfo.Toggles:split"_"[1] or CommandNames[1]
					table.insert(Suggestions,{
						Command = DisplayName,
						CommandNames = CommandNames,
						Display = ("<font color = '#FFFFFF'>%s</font>%s%s"):format(DisplayName,CommandInfo.Arguments and (function()
							local Arguments = {}
							for _,ArgumentInfo in CommandInfo.Arguments do
								table.insert(Arguments,("%s:%s%s"):format(ArgumentInfo.Name,ArgumentInfo.Type,ArgumentInfo.Required and "" or "?"))
							end
							return (" <i>%s</i>"):format(table.concat(Arguments," "))
						end)() or "",CommandInfo.Toggles and " [Toggles]" or "")
					})
					break
				end
			end
		end
		if #Command < 2 then
			table.sort(Suggestions,function(Suggestion1,Suggestion2)
				Suggestion1 = Service"Text":GetTextSize(Suggestion1.Command,14,Enum.Font.Arial,Vector2.one*1e6).X
				Suggestion2 = Service"Text":GetTextSize(Suggestion2.Command,14,Enum.Font.Arial,Vector2.one*1e6).X
				return if CheckAxis"Y" then Suggestion1 < Suggestion2 else Suggestion2 < Suggestion1
			end)
		else
			local function MatchRate(Suggestion)
				local HighestMatch = 0
				for _,Name in Suggestion.CommandNames do
					local MatchPercent = 1-#Name:lower():gsub(Command,"")/#Name
					if HighestMatch < MatchPercent then
						HighestMatch = MatchPercent
					end
				end
				return HighestMatch
			end
			table.sort(Suggestions,function(Suggestion1,Suggestion2)
				return if CheckAxis"Y" then MatchRate(Suggestion2) < MatchRate(Suggestion1) else MatchRate(Suggestion1) < MatchRate(Suggestion2)
			end)
		end
		for Index,Suggestion in Suggestions do
			Suggestion.UI = NewInstance("TextLabel",Gui.SuggestionsScroll,{
				TextSize = 14,
				RichText = true,
				BorderSizePixel = 0,
				LayoutOrder = Index,
				Font = Enum.Font.Arial,
				Text = Suggestion.Display,
				BackgroundTransparency = 1,
				TextStrokeTransparency = .8,
				BackgroundColor3 = Color3.new(1,1,1),
				TextColor3 = Color3.fromHex"A0A0A0",
				TextXAlignment = Enum.TextXAlignment.Left
			})
		end
		if 0 < #Suggestions then
			Selected = CheckAxis"Y" and 1 or #Suggestions
			Gui.SelectorBorder.Enabled = true
		else
			Selected = nil
			Gui.SelectorBorder.Enabled = false
		end
		Gui.SuggestionsGridLayout.Parent = Gui.SuggestionsScroll
		local CommandNumber = #Gui.SuggestionsScroll:GetChildren()-1
		Gui.SuggestionsScroll.CanvasSize = UDim2.new(0,0,0,20*CommandNumber)
		Gui.SuggestionsScroll.CanvasPosition = Vector2.yAxis*(CheckAxis"Y" and 0 or 20*CommandNumber)
		Gui.SuggestionSelector.Position = CheckAxis"Y" and UDim2.new(0,1,0,4) or UDim2.new(0,1,1,-24)
		ResizeMain(nil,0 < CommandNumber and 48+20*math.min(CommandNumber,5) or 40)
	end
end
Gui.Holder.Parent = HiddenUI
local SendValue = NewInstance"BindableEvent"
local Removing
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
	isfile and Connect(Service"Run".Heartbeat,function()
		if not Valid.Instance(Gui.Holder,"ScreenGui") or not Gui.Holder:IsDescendantOf(HiddenUI) and not Removing then
			Removing = true
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
			Destroy(Connections,Gui,SendValue)
		end
		if Settings.AutoUpdate and 60 < os.clock()-LastCheck then
			LastCheck = os.clock()
			local Success,Result = pcall(game.HttpGet,game,"https://raw.githubusercontent.com/Amourousity/Ultimatum/main/Source.lua",true)
			if Success and (not isfile"Ultimatum.lua" or Result ~= readfile"Ultimatum.lua") then
				writefile("Ultimatum.lua",Result)
				Notify{
					Yields = true,
					Title = "Out of Date",
					Text = "Your version of Ultimatum is outdated! Updating to newest version..."
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
	queue_on_teleport and Connect(Owner.OnTeleport,isfile and function()
		if Settings.LoadOnRejoin then
			queue_on_teleport(isfile"Ultimatum.lua" and readfile"Ultimatum.lua" or "warn'Ultimatum.lua missing from workspace folder (Ultimatum cannot run)'")
		end
	end or function()
		if Settings.LoadOnRejoin then
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
		Gui.CommandBar.PlaceholderText = "Enter a command"
		if Sent and 0 < #Gui.CommandBar.Text then
			task.spawn(RunCommand,Gui.CommandBar.Text)
		end
		Gui.CommandBar.Text = ""
		Gui.CommandBar.TextXAlignment = Enum.TextXAlignment[Gui.CommandBar.TextFits and "Left" or "Right"]
		Service"UserInput".OverrideMouseIconBehavior = Enum.OverrideMouseIconBehavior.None
		ResizeMain()
		task.delay(.25,function()
			if Service"UserInput":GetFocusedTextBox() ~= Gui.CommandBar then
				ResizeMain(40)
				Wait(.25)
				Gui.CommandBar.PlaceholderText = ("Enter a command (Keybind:\u{200A}%s\u{200A})"):format(Service"UserInput":GetStringForKeyCode(Enum.KeyCode[Settings.Keybind]))
			end
		end)
		pcall(function()
			HiddenUI.Parent = nil
			HiddenUI.Parent = HiddenUIParent
		end)
		Debounce = false
	end),
	Connect(Service"UserInput".InputBegan,function(Input,Ignore)
		if Input.UserInputType.Name == "Keyboard" then
			Input = Input.KeyCode.Name
			if not Ignore and Input == Settings.Keybind and not Debounce then
				task.defer(Gui.CommandBar.CaptureFocus,Gui.CommandBar)
			elseif Service"UserInput":GetFocusedTextBox() == Gui.CommandBar and 0 < #Suggestions then
				if Input == "Up" or Input == "Down" then
					ScrollSuggestions(Input)
					local Start = os.clock()
					while Service"UserInput":IsKeyDown(Enum.KeyCode[Input]) and os.clock()-Start < .5 do
						Wait()
					end
					if .25 < os.clock()-Start then
						repeat
							ScrollSuggestions(Input)
							Wait(1/30)
						until not Service"UserInput":IsKeyDown(Enum.KeyCode[Input])
					end
				elseif Input == "Tab" then
					Gui.CommandBar.Text = Suggestions[Selected].Command
					Gui.CommandBar.CursorPosition = #Gui.CommandBar.Text
				end
			end
		end
	end),
	Connect(Gui.CommandBar:GetPropertyChangedSignal"Text",UpdateSuggestions)
}
if not GlobalEnvironment.UltimatumUIs then
	GlobalEnvironment.UltimatumUIs = {}
end
Destroy(GlobalEnvironment.UltimatumUIs)
table.insert(GlobalEnvironment.UltimatumUIs,Gui)
local function LoadCommands(Lua,Name)
	Name = Valid.String(Name,"Custom Command Set")
	local CommandSet,ErrorMessage = loadstring(([[
		local ReceiveValue,Notify,RunCommand,AddConnections,RemoveConnections,CreateWindow,FireTouchInterest,Gui,Character,Backpack,PlayerGui = ...
		AddConnections{
			Connect(ReceiveValue.Event,function(Type,Object)
				if Type == "Character" then
					Character = Object
				elseif Type == "Backpack" then
					Backpack = Object
				elseif Type == "PlayerGui" then
					PlayerGui = Object
				end
			end)
		}
	%s]]):gsub("\n\t*"," "):format(Lua),Name)
	if not CommandSet then
		warn(ErrorMessage)
		Notify{
			Title = ("%s Failed"):format(Name),
			Text = "The command set failed to load. Check the Developer Console for any error messages"
		}
		return
	end
	setfenv(CommandSet,getfenv())
	for CommandName,Info in CommandSet(SendValue,Notify,RunCommand,AddConnections,RemoveConnections,CreateWindow,FireTouchInterest,Gui,GetCharacter(Owner,.5),WaitForChildOfClass(Owner,"Backpack"),WaitForChildOfClass(Owner,"PlayerGui")) do
		if Commands[CommandName] and Commands[CommandName].ToggleCheck and Commands[CommandName].Enabled then
			RunCommand(Commands[CommandName].Toggles:split"_"[1])
		end
		Commands[CommandName] = Info
	end
end
GlobalEnvironment.AddUltimatumCommands = LoadCommands
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
		LoadCommands(Result,("Command Set %d"):format(ID))
	elseif Result ~= "HTTP 404 (Not Found)" then
		Notify{
			Title = "Failed to Load",
			Text = ("Command set %d failed to download; is GitHub down?"):format(ID)
		}
	end
end
EnableDrag(Gui.Main,true)
pcall(function()
	HiddenUI.Parent = nil
	HiddenUI.Parent = HiddenUIParent
end)
while Service"CoreGui":FindFirstChild"RobloxLoadingGUI" do
	Service"CoreGui".ChildRemoved:Wait()
end
pcall(function()
	if Settings.PlayIntro == "Always" or Settings.PlayIntro == "Once" and not GlobalEnvironment.UltimatumLoaded then
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
	Gui.ScreenCover = nil
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
	GetCommandSet()
	GetCommandSet(game.PlaceId)
end)
