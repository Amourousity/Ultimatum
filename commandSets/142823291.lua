return {
	ExtrasensoryPerception_extrasensoryp_esensoryperception_esperception_extrasp_esp = {
		Function = function(Variables, Enabled)
			if Enabled then
				Variables.Time, Variables.Connection =
					0, connect(service("Run").Heartbeat, function()
						if not Variables.Calculating and 1 < os.clock() - Variables.Time or 5 < os.clock() - Variables.Time then
							Variables.Time, Variables.Calculating = os.clock(), true
							local PlayerData = Variables.PlayerDataRemote:InvokeServer()
							destroy(Variables.ESPs)
							if workspace:FindFirstChild("GunDrop") then
								Variables:CreateESP(workspace.GunDrop, "Gun")
							end
							for _, Player in service("Players"):GetPlayers() do
								local Data = PlayerData[Player.Name]
								if Data and not Data.Dead and Player.Name ~= owner.Name then
									Variables:CreateESP(Player.Character:FindFirstChild("HumanoidRootPart") or Player.Character:FindFirstChildWhichIsA("BasePart"), Data.Role)
								end
							end
							Variables.Calculating = false
						end
					end)
				addConnections({ Variables.Connection })
			else
				removeConnections({ Variables.Connection })
				destroy(Variables.ESPs)
			end
		end,
		Toggles = "SensoryPerception_sensoryp_sperception_sp_unextrasensoryperception_unextrasensoryp_unesperception_unextrasp_unesp_uesp",
		ToggleCheck = true,
		Variables = {
			ESPs = {},
			PlayerDataRemote = waitForSequence(service("ReplicatedStorage"), "Remotes", "Extras", "GetPlayerData"),
			CreateESP = function(Variables, Object, Role)
				local LargestAxis = math.max(Object.Size.X, Object.Size.Y, Object.Size.Z)
				table.insert(
					Variables.ESPs,
					create({
						espHolder = {
							Parent = gui.holder,
							ClassName = "BillboardGui",
							Properties = {
								Active = false,
								Adornee = Object,
								AlwaysOnTop = true,
								LightInfluence = 0,
								ResetOnSpawn = false,
								Size = UDim2.new(LargestAxis, 0, LargestAxis, 0),
							},
						},
						main = {
							Parent = "espHolder",
							ClassName = "Frame",
							Properties = {
								Size = UDim2.new(1, 0, 1, 0),
								BackgroundColor3 = ({
									Gun = Color3.new(0.5, 0, 1),
									Hero = Color3.new(1, 1, 0),
									Sheriff = Color3.new(0, 0, 1),
									Zombie = Color3.new(0, 0.5, 0),
									Innocent = Color3.new(0, 1, 0),
									Murderer = Color3.new(1, 0, 0),
									Survivor = Color3.new(0, 0, 1),
								})[Role],
							},
						},
						gradient = {
							Parent = "main",
							ClassName = "UIGradient",
							Properties = {
								Rotation = 90,
								Transparency = NumberSequence.new(0, 1),
							},
						},
						corner = {
							Parent = "main",
							ClassName = "UICorner",
							Properties = { CornerRadius = UDim.new(0.5, 0) },
						},
					})
				)
			end,
		},
		Description = "Locates all players and tells you what role they are. Also shows where the gun is, if it's dropped",
	},
	AutoFarm_autoplay_autop_autof_farm_af = {
		Function = function(Variables, Enabled)
			if Enabled then
				runCommand("AntiAFK")
				Variables.Delta, Variables.LastFrame, Variables.Coins, Variables.IgnoreCoins, Variables.Position =
					0, os.clock(), {}, {}, workspace.CurrentCamera.Focus.Position
				Variables.CoinAdded = connect(workspace.DescendantAdded, function(Coin)
					if Coin:IsA("BasePart") and Coin.Name == "Coin_Server" then
						table.insert(Variables.Coins, Coin)
						local Connection
						Connection = connect(Coin.AncestryChanged, function()
							if not Coin:IsDescendantOf(workspace) then
								table.remove(Variables.Coins, table.find(Variables.Coins, Coin))
								removeConnections({ Connection })
							end
						end)
						addConnections({ Connection })
					end
				end)
				Variables.CharacterAdded = connect(owner.CharacterAdded, function(Character)
					Variables.Collecting = true
					Variables.Position = Character:GetPivot().Position
					wait(5)
					Variables.Collecting = false
					runCommand("Invisible")
					wait(
						waitForSequence(playerGui, "MainGUI", "Game", "CashBag", "Full"):GetPropertyChangedSignal(
							"Visible"
						)
					)
					Character:BreakJoints()
				end)
				Variables.Stepped = connect(service("Run").Stepped, function()
					if not Variables.FoundCoin then
						return
					end
					for _, BasePart in valid.table(character and character:GetChildren()) do
						if valid.instance(BasePart, "BasePart") then
							BasePart.AssemblyLinearVelocity, BasePart.CanCollide, BasePart.CanTouch, BasePart.CanQuery =
								Vector3.zero,
								BasePart.Name == "HumanoidRootPart" and Variables.Collecting,
								Variables.Collecting,
								Variables.Collecting
						end
					end
				end)
				Variables.Connection = connect(service("Run").Heartbeat, function()
					Variables.Delta, Variables.LastFrame =
						math.min(os.clock() - Variables.LastFrame, 1 / 15) * 60, os.clock()
					for Coin, Time in Variables.IgnoreCoins do
						if not Coin:IsDescendantOf(workspace) or 3 < Variables.LastFrame - Time then
							Variables.IgnoreCoins[Coin] = nil
						end
					end
					Variables.FoundCoin = false
					if not Variables.Collecting then
						local Distance, Coin = math.huge, nil
						for _, NewCoin in Variables.Coins do
							local Magnitude = (NewCoin.Position - Variables.Position).Magnitude
							if
								not Variables.IgnoreCoins[NewCoin]
								and not NewCoin:FindFirstChildWhichIsA("Model")
								and NewCoin:FindFirstChild("Coin")
								and Magnitude < Distance
								and NewCoin.CoinType ~= "Coin"
							then
								Coin, Distance = NewCoin, Magnitude
							end
						end
						if Coin and Distance < 250 and Variables.Position ~= Coin.Position then
							Variables.FoundCoin = true
							Variables.Position = CFrame.lookAt(Variables.Position, Coin.Position)
								* CFrame.new(0, 0, -math.min(Variables.Delta * 5 / 12, Distance)).Position
							character:PivotTo(
								CFrame.new(Variables.Position - Vector3.yAxis * 2) * CFrame.Angles(math.pi / 2, 0, 0)
							)
							if (Variables.Position - Coin.Position).Magnitude < 0.01 then
								Variables.Collecting = true
								Variables.IgnoreCoins[Coin] = os.clock()
								repeat
									wait()
									character:PivotTo(CFrame.new(Variables.Position) * CFrame.Angles(math.pi / 2, 0, 0))
									for _, object in character:GetChildren() do
										if object:IsA("BasePart") then
											object.AssemblyLinearVelocity, object.AssemblyAngularVelocity =
												Vector3.zero, Vector3.zero
										end
									end
								until 0.25 < os.clock() - Variables.IgnoreCoins[Coin]
								Variables.Collecting = false
							end
						else
							Variables.Position = character:GetPivot().Position
						end
					end
				end)
				addConnections({
					Variables.Stepped,
					Variables.CoinAdded,
					Variables.Connection,
					Variables.CharacterAdded,
				})
			else
				runCommand("AllowAFK")
				removeConnections({
					Variables.Stepped,
					Variables.CoinAdded,
					Variables.Connection,
					Variables.CharacterAdded,
				})
			end
		end,
		Toggles = "Unfarm_unautofarm_unautoplay_stopplaying_unautp_stopp_unautof_unf_uaf_uf",
		ToggleCheck = true,
		Variables = {},
		Description = "Automatically collects currency (depends on event) during rounds",
	},
}
