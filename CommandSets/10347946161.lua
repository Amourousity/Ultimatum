return {
	AutoFarm_autoplay_autop_autof_farm_af = {
		Function = function(Variables, Enabled)
			if Enabled then
				runCommand("AntiAFK")
				Variables.Debounce = false
				Variables.Connection = connect(service("Run").Heartbeat, function()
					if not character then
						return
					end
					if not Variables.Debounce then
						Variables.Debounce = true
						if not valid.instance(Variables.Tycoon, "Folder") then
							Variables.Tycoon = owner.RespawnLocation.Parent
							Variables.Rats = Variables.Tycoon:WaitForChild("Rats")
							Variables.Buttons = Variables.Tycoon:WaitForChild("Buttons")
						end
						if not Variables.Wall.CanCollide then
							Variables:MoveTo(Vector3.yAxis * 55)
							wait(0.2)
						end
						local Wash = false
						for _, Rat in Variables.Rats:GetChildren() do
							Wash = true
							Variables.CollectRat:FireServer(tonumber(Rat.Name))
						end
						if Wash then
							Variables.SellRats:FireServer()
						end
						local LowestPrice, ChosenButton = math.huge, nil
						for _, Button in Variables.Buttons:GetChildren() do
							if Button:GetAttribute("Enabled") and not Button:GetAttribute("Gamepass") then
								if
									Button:GetAttribute("Price") <= Variables.Cash.Value
									and Button:GetAttribute("Price") < LowestPrice
								then
									LowestPrice, ChosenButton = Button:GetAttribute("Price"), Button
								end
							end
						end
						if ChosenButton then
							Variables:MoveTo(ChosenButton:WaitForChild("Hitbox").Position)
							Variables.PurchaseButton:FireServer(ChosenButton.Name)
							wait(0.2)
						end
						Variables.Debounce = false
					end
				end)
				addConnections({ Variables.Connection })
			else
				runCommand("AllowAFK")
				removeConnections({ Variables.Connection })
			end
		end,
		Toggles = "Unfarm_unautofarm_unautoplay_stopplaying_unautp_stopp_unautof_unf_uaf_uf",
		ToggleCheck = true,
		Variables = {
			Cash = waitForSequence(owner, "leaderstats", "Cash"),
			Rebirth = waitForSequence(owner, "leaderstats", "Rebirth"),
			Wall = waitForSequence(workspace, "Obby", "Sign", "Forcefield", "Wall"),
			SellRats = waitForSequence(
				service("ReplicatedStorage"),
				"Knit",
				"Services",
				"TycoonService",
				"RE",
				"SellRats"
			),
			CollectRat = waitForSequence(
				service("ReplicatedStorage"),
				"Knit",
				"Services",
				"TycoonService",
				"RE",
				"CollectRat"
			),
			PurchaseButton = waitForSequence(
				service("ReplicatedStorage"),
				"Knit",
				"Services",
				"TycoonService",
				"RE",
				"PurchaseButton"
			),
			MoveTo = function(_, Position)
				character:PivotTo(if typeof(Position) == "Vector3" then CFrame.new(Position) else Position)
			end,
		},
		Description = "Automatically collects and washes rats, buys new rat types, activates washing frenzy, and rebirths",
	},
}
