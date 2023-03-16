return {
	AutoFarm_autoplay_autop_autof_farm_af = {
		Function = function(Variables, Enabled, TargetMethod)
			if Enabled then
				TargetMethod = math.clamp(TargetMethod, 1, 3)
				runCommand("AntiAFK")
				Variables.Debounce = false
				Variables.LastInventoryCheck, Variables.LastShot = 0, 0
				Variables.Connection = connect(service("Run").Heartbeat, function()
					if 3 < os.clock() - Variables.LastInventoryCheck then
						Variables.LastInventoryCheck = os.clock()
						table.clear(Variables.AvailableGuns)
						Variables.Selection = "Pistol"
						for _, Gun in Variables.GunSelection:GetChildren() do
							if
								Gun:FindFirstChild("Unlocked")
								and Gun.Unlocked.Value
								and Variables[TargetMethod == 3 and "Firerates" or "DPS"][Gun.Name]
							then
								table.insert(Variables.AvailableGuns, Gun.Name)
							end
						end
						for _, Gun in Variables.AvailableGuns do
							if
								if TargetMethod == 3
									then Variables.Firerates[Variables.Selection] < Variables.Firerates[Gun]
									else Variables.DPS[Variables.Selection] < Variables.DPS[Gun]
							then
								Variables.Selection = Gun
							end
						end
					end
					if character then
						if workspace.CurrentCamera.CameraSubject:IsDescendantOf(character) then
							workspace.CurrentCamera.CameraSubject = Variables.Spawns[math.random(#Variables.Spawns)]
						end
						character:PivotTo(CFrame.new())
						for _, BasePart in character:GetChildren() do
							if valid.instance(BasePart, "BasePart") then
								BasePart.AssemblyLinearVelocity = Vector3.zero
							end
						end
					end
					for Zombie, TaggedAt in Variables.TaggedZombies do
						if not Zombie:IsDescendantOf(Variables.Zombies) or 10 < os.clock() - TaggedAt then
							Variables.TaggedZombies[Zombie] = nil
						end
					end
					if not Variables.Debounce and character then
						Variables.Debounce = true
						if Variables.CurrentGun.Value ~= Variables.Selection then
							pcall(
								Variables.Equip.InvokeServer,
								Variables.Equip,
								"Primary",
								Variables.Primary:WaitForChild(Variables.Selection)
							)
							wait(0.1)
						end
						local Gun = character:FindFirstChild(Variables.Selection)
							or backpack:FindFirstChild(Variables.Selection)
						if Gun then
							local Stats = Gun:WaitForChild("Configuration")
							if Gun.Parent == backpack then
								for _, Name in
									{
										"Burst",
										"Range",
										"Damage",
										"Firerate",
									}
								do
									Variables[Name] = Stats:WaitForChild(Name).Value
								end
								pcall(
									Variables.BackpackEvent.FireServer,
									Variables.BackpackEvent,
									"Equip",
									Variables.Selection
								)
								wait(1)
							elseif 1 / Variables.Firerate < os.clock() - Variables.LastShot then
								Variables.LastShot = os.clock()
								local Target, Hit;
								({
									function()
										local Targets = {}
										for _, Zombie in Variables.Zombies:GetChildren() do
											local Humanoid = Zombie:FindFirstChildOfClass("Humanoid")
											if
												Humanoid
												and 0 < Humanoid.Health
												and Zombie:FindFirstChild("Configuration")
												and Zombie.Configuration:FindFirstChild("XPReward")
											then
												table.insert(Targets, {
													Humanoid = Humanoid,
													Hit = Zombie:GetPivot().Position,
													XPReward = Zombie.Configuration.XPReward.Value,
												})
											end
										end
										local HighestWorth = 0
										for _, Zombie in Targets do
											local XPWorth = Zombie.XPReward
												/ math.max(Zombie.Humanoid.Health, Variables.DPS[Variables.Selection])
											if HighestWorth < XPWorth then
												Target, Hit, HighestWorth = Zombie.Humanoid, Zombie.Hit, XPWorth
											end
										end
									end,
									function()
										local LowestHealth = math.huge
										for _, Zombie in Variables.Zombies:GetChildren() do
											local Humanoid = Zombie:FindFirstChildOfClass("Humanoid")
											if Humanoid and 0 < Humanoid.Health and Humanoid.Health < LowestHealth then
												Target, Hit, LowestHealth =
													Humanoid, Zombie:GetPivot().Position, Humanoid.Health
											end
										end
									end,
									function()
										for _, Zombie in Variables.Zombies:GetChildren() do
											local Humanoid = Zombie:FindFirstChildOfClass("Humanoid")
											if
												Humanoid
												and Variables.Damage < Humanoid.Health
												and not Variables.TaggedZombies[Humanoid]
											then
												Target, Hit = Humanoid, Zombie:GetPivot().Position
												Variables.TaggedZombies[Humanoid] = os.clock()
											end
										end
									end,
								})[TargetMethod]()
								if Target then
									local LaserProperties = {}
									for _ = 1, Variables.Burst do
										table.insert(LaserProperties, {
											"Neon",
											BrickColor.new("Really black"),
											-Vector3.yAxis,
											CFrame.lookAt(Hit, Hit - Vector3.yAxis),
											Hit,
											Variables.Range,
											true,
											-Vector3.yAxis,
										})
									end
									workspace.CurrentCamera.CameraSubject = Target
									Variables.WeaponEvent:FireServer({
										Tool = Gun,
										RealTool = Gun,
										HumanoidTables = {
											{
												BodyHits = if TargetMethod == 3 then Variables.Burst else 0,
												THumanoid = Target,
												HeadHits = if TargetMethod == 3 then 0 else Variables.Burst,
											},
										},
										LaserProperties = LaserProperties,
									})
								end
							end
						end
						Variables.Debounce = false
					end
				end)
				Variables.WaveChanged = connect(Variables.CurrentWave:GetPropertyChangedSignal("Value"), function()
					if 49 < Variables.CurrentWave.Value and Variables.CurrentWave.Value % 10 == 0 and character then
						character:BreakJoints()
					end
				end)
				addConnections({
					Variables.Connection,
					Variables.WaveChanged,
				})
			else
				runCommand("AllowAFK")
				removeConnections({
					Variables.Connection,
					Variables.WaveChanged,
				})
				if character then
					character:PivotTo(workspace.CurrentCamera.Focus)
					workspace.CurrentCamera.CameraSubject = getHumanoid(character, 1)
				end
			end
		end,
		Toggles = "Unfarm_unautofarm_unautoplay_stopplaying_unautp_stopp_unautof_unf_uaf_uf",
		ToggleCheck = true,
		Arguments = {
			{
				Name = "TargetMethod",
				Type = "Number",
				Substitute = 1,
			},
		},
		Variables = {
			DPS = {
				Pistol = 150.75,
				Shotgun = 165,
				AssaultRifle = 183,
				LaserRifle = 222,
				MarsBlaster = 369,
				PartyRocker = 393.75,
				SuperFreezeRay = 420,
				GhostBlaster = 459,
				LaserSniper = 487.5,
				Luger = 585,
				Sterling = 600,
				TrenchGun = 637.5,
				M1Garand = 660,
				EgoExpander = 693,
				["LaserRobot-DanceGun"] = 720,
				PurpleLaserRifle = 765,
				Sviper = 800.25,
				PigsBoson = 840,
				TarydiumPistol = 840,
				Zapper = 870,
				TeslaElectricGun = 900,
				ShrinkRay = 930,
				FreezeRay = 975,
				TX08 = 1026,
				LavaGun = 1125,
				GoldenPistol = 735,
				ReapersVoid = 1512,
				AlienRaygun = 1575,
				SuperDisruptor = 1648.5,
				PewPewGun = 1800,
				EclecticRifle = 1875,
				ScatterBlaster = 1950,
				BlastGun = 2028,
				HotChocolateGun = 2100,
				HeatLauncher = 2174.25,
				GatlingLaser = 2250,
				FireBlaster = 2325,
				IceCannon = 2400,
				DarkMatterPistol = 2484,
				FlakCannon = 2550,
				BlueMinigun = 2700,
				Spitter = 2853,
				BlowDryer = 3000,
				["8BitCrossbow"] = 4650,
				-- Haven't gotten past this so some stats are missing
				-- Also I won't be adding any of the paid weapons 'cause they literally cost like $300 total
			},
			Firerates = {
				Pistol = 6,
				SMG = 14,
				Sterling = 16,
			},
			AvailableGuns = {},
			TaggedZombies = {},
			Selection = "Pistol",
			Zombies = workspace:WaitForChild("Zombie Storage"),
			CurrentGun = waitForSequence(owner, "EquipStorage", "Primary"),
			Equip = waitForSequence(service("ReplicatedStorage"), "Remotes", "StoreEquip"),
			WeaponEvent = waitForSequence(service("ReplicatedStorage"), "Remotes", "WeaponEvent"),
			Primary = waitForSequence(service("ReplicatedStorage"), "WeaponRequirements", "Primary"),
			BackpackEvent = waitForSequence(service("ReplicatedStorage"), "Remotes", "BackpackEvent"),
			GunSelection = waitForSequence(playerGui, "MainGui", "Menu", "Tab1Frame", "ScrollingFrame"),
			CurrentWave = waitForSequence(service("ReplicatedStorage"), "GameProperties", "CurrentWave"),
			Spawns = waitForSequence(workspace, "SafehouseLobby", ".Functional", "SpawnLocations"):GetChildren(),
		},
		Description = "Automatically shoots at zombies via 1 of 3 targetting methods:\n1. XP : Health ratio\n2. Lowest health\n3. Assists only",
	},
}
