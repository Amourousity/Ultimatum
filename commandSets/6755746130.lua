return {
	AutoFarm_autoplay_autop_autof_farm_af = {
		Function = function(Variables, Enabled)
			if Enabled then
				runCommand("AntiAFK")
				Variables.Debounce = false
				service("StarterGui"):SetCoreGuiEnabled("Backpack", false)
				Variables.Connection = connect(service("Run").Heartbeat, function()
					if not character then
						return
					end
					local Toucher = character:FindFirstChildWhichIsA("BasePart")
					if not Toucher then
						return
					end
					character:PivotTo(Variables.Position)
					for _, BasePart in character:GetChildren() do
						if valid.instance(BasePart, "BasePart") then
							BasePart.AssemblyLinearVelocity = Vector3.zero
						end
					end
					if playerGui:FindFirstChild("HintGui") then
						playerGui.HintGui.Enabled = false
					end
					for _, BasePart in Variables.Ignored:GetDescendants() do
						if valid.instance(BasePart, "BasePart") then
							BasePart.LocalTransparencyModifier = 1
						end
					end
					if not Variables.Debounce then
						Variables.Debounce = true
						if not valid.instance(Variables.OwnedTycoon.Value, "Model") then
							for _, Tycoon in Variables.Tycoons:GetChildren() do
								if not valid.instance(Tycoon:WaitForChild("Owner").Value, "Player") then
									fireTouchInterest(Toucher, waitForSequence(Tycoon, "Essentials", "Entrance"))
									wait(1)
									break
								end
							end
						end
						if not valid.instance(Variables.Tycoon, "Model") then
							Variables.Tycoon = Variables.OwnedTycoon.Value
							Variables.Essentials = Variables.Tycoon:WaitForChild("Essentials")
							local PromptAttachment = waitForSequence(
								Variables.Essentials,
								"JuiceMaker",
								"AddFruitButton",
								"PromptAttachment"
							)
							Variables.Position = CFrame.new(PromptAttachment.WorldPosition - Vector3.yAxis * 8)
								* CFrame.Angles(math.pi / 2, 0, 0)
							Variables.AddPrompt = PromptAttachment:WaitForChild("AddPrompt")
							Variables.Drops = Variables.Tycoon:WaitForChild("Drops")
							Variables.Buttons = Variables.Tycoon:WaitForChild("Buttons")
							Variables.Purchased = Variables.Tycoon:WaitForChild("Purchased")
							Variables.Spawn = Variables.Essentials:WaitForChild("SpawnLocation")
						end
						if Variables.Purchased:FindFirstChild("Golden Tree Statue") then
							Variables.RequestPrestige:FireServer()
							Variables.Tycoon = nil
							wait(3)
						end
						if backpack then
							for _, Tool in backpack:GetChildren() do
								Tool.Parent = character
							end
							local Collect
							for _, Drop in Variables.Drops:GetChildren() do
								if not Drop:GetAttribute("Collected") then
									Collect = true
									Drop:SetAttribute("Collected", true)
									Variables.CollectFruit:FireServer(Drop)
								end
							end
							if Collect then
								if fireproximityprompt then
									fireproximityprompt(Variables.AddPrompt)
								elseif keypress then
									keypress(69)
									task.defer(keyrelease, 69)
								end
							end
						end
						if
							Toucher
							and playerGui:FindFirstChild("ObbyBillboards")
							and playerGui.ObbyBillboards:FindFirstChild("ObbySignBillBoard")
							and playerGui.ObbyBillboards.ObbySignBillBoard:FindFirstChild("TopText")
							and playerGui.ObbyBillboards.ObbySignBillBoard.TopText.Text == "Start Obby"
						then
							fireTouchInterest(Toucher, Variables.RealObbyStartPart)
							wait(0.5)
							fireTouchInterest(Toucher, Variables.VictoryPart)
							wait(1)
						end
						local LowestPrice, ChosenButton = math.huge, nil
						for _, Button in Variables.Buttons:GetDescendants() do
							if
								valid.instance(Button, "BasePart")
								and 0 < #Button:GetChildren()
								and Button.Name ~= "AutoCollect"
								and not Button:GetAttribute("CostValue")
								and not Button:GetAttribute("AchievementNeeded")
							then
								local Price = Button:GetAttribute("Cost")
								if Price <= Variables.Money.Value and Price < LowestPrice then
									LowestPrice, ChosenButton = Price, Button
								end
							end
						end
						if ChosenButton and Toucher then
							fireTouchInterest(Toucher, ChosenButton)
						end
						Variables.Debounce = false
					end
				end)
				Variables.RenderStepped = connect(service("Run").RenderStepped, function()
					if Variables.Spawn then
						workspace.CurrentCamera.Focus, workspace.CurrentCamera.CFrame =
							Variables.Spawn.CFrame,
							Variables.Spawn.CFrame * CFrame.Angles(-math.pi / 4, 0, 0) * CFrame.new(0, 0, 75)
					end
				end)
				addConnections({
					Variables.Connection,
					Variables.RenderStepped,
				})
			else
				runCommand("AllowAFK")
				if character and backpack then
					for _, Tool in character:GetChildren() do
						if valid.instance(Tool, "Tool") then
							Tool.Parent = backpack
						end
					end
				end
				character:PivotTo(Variables.Spawn.CFrame * CFrame.new(0, 3.5, 0))
				service("StarterGui"):SetCoreGuiEnabled("Backpack", true)
				removeConnections({
					Variables.Connection,
					Variables.RenderStepped,
				})
			end
		end,
		Toggles = "Unfarm_unautofarm_unautoplay_stopplaying_unautp_stopp_unautof_unf_uaf_uf",
		ToggleCheck = true,
		Variables = {
			Position = workspace.CurrentCamera.Focus,
			Ignored = workspace:WaitForChild("Ignored"),
			Tycoons = workspace:WaitForChild("Tycoons"),
			HeldFruits = owner:WaitForChild("HeldFruits"),
			OwnedTycoon = owner:WaitForChild("OwnedTycoon"),
			Money = waitForSequence(owner, "leaderstats", "Money"),
			Prestige = waitForSequence(owner, "leaderstats", "Prestige"),
			CollectFruit = service("ReplicatedStorage"):WaitForChild("CollectFruit"),
			RequestPrestige = service("ReplicatedStorage"):WaitForChild("RequestPrestige"),
			RealObbyStartPart = waitForSequence(workspace, "ObbyParts", "RealObbyStartPart"),
			VictoryPart = waitForSequence(workspace, "ObbyParts", "Stages", "Hard", "VictoryPart"),
		},
		Description = "Automatically collects and sells fruit, buys upgrades, activates frenzy and prestiges",
	},
}
