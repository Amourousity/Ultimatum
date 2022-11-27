local Utilitas,ReceiveValue,Notify,RunCommand,AddConnections,RemoveConnections,CreateWindow,FireTouchInterest,Gui,Character,Backpack,PlayerGui = ...
local Owner,Nil,Connect,Destroy,Wait,Service,Valid,WaitForSequence,RandomString,RandomBool,NilConvert,NewInstance,Create,DecodeJSON,WaitForSignal,Animate,Assert,GetCharacter,GetHumanoid,ConvertTime,GetContentText,WaitForChildOfClass = unpack(Utilitas)
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
return {
	AutoFarm_autoplay_autop_autof_farm_af = {
		Function = function(Variables,Enabled,FocusOnKills)
			if Enabled then
				RunCommand"AntiAFK"
				Variables.Debounce = false
				Variables.LastInventoryCheck,Variables.LastShot = 0,0
				Variables.Connection = Connect(Service"Run".Heartbeat,function()
					if 3 < os.clock()-Variables.LastInventoryCheck then
						Variables.LastInventoryCheck = os.clock()
						for _,Gun in Variables.GunSelection:GetChildren() do
							if Gun:FindFirstChild"Unlocked" and Gun.Unlocked.Value and not table.find(Variables.AvailableGuns,Gun.Name) and Variables.DPS[Gun.Name] then
								table.insert(Variables.AvailableGuns,Gun.Name)
							end
						end
						for _,Gun in Variables.AvailableGuns do
							if Variables.DPS[Variables.Selection] < Variables.DPS[Gun] then
								Variables.Selection = Gun
							end
						end
					end
					if Character then
						if workspace.CurrentCamera.CameraSubject:IsDescendantOf(Character) then
							local Subject = NewInstance("Part",nil,{CFrame = CFrame.new(0,-1e4,0)})
							Destroy(Subject)
							workspace.CurrentCamera.CameraSubject = Subject
						end
						Character:PivotTo(CFrame.new())
						for _,BasePart in Character:GetChildren() do
							if Valid.Instance(BasePart,"BasePart") then
								BasePart.AssemblyLinearVelocity = Vector3.zero
							end
						end
					end
					if not Variables.Debounce and Character then
						Variables.Debounce = true
						if Variables.CurrentGun.Value ~= Variables.Selection then
							pcall(Variables.Equip.InvokeServer,Variables.Equip,"Primary",Variables.Primary:WaitForChild(Variables.Selection))
							Wait(.1)
						end
						local Gun = Character:FindFirstChild(Variables.Selection) or Backpack:FindFirstChild(Variables.Selection)
						if Gun then
							local Stats = Gun:WaitForChild"Configuration"
							if Gun.Parent == Backpack then
								for _,Name in {
									"Range",
									"Burst",
									"Firerate"
								} do
									Variables[Name] = Stats:WaitForChild(Name).Value
								end
								pcall(Variables.BackpackEvent.FireServer,Variables.BackpackEvent,"Equip",Variables.Selection)
								Wait(1)
							elseif 1/Variables.Firerate < os.clock()-Variables.LastShot then
								Variables.LastShot = os.clock()
								local Target,Hit
								if FocusOnKills then
									local LowestHealth = math.huge
									for _,Zombie in Variables.Zombies:GetChildren() do
										local Humanoid = Zombie:FindFirstChildOfClass"Humanoid"
										if Humanoid and 0 < Humanoid.Health and Humanoid.Health < LowestHealth then
											Target,Hit,LowestHealth = Humanoid,Zombie:GetPivot().Position,Humanoid.Health
										end
									end
								else
									local Targets = {}
									for _,Zombie in Variables.Zombies:GetChildren() do
										local Humanoid = Zombie:FindFirstChildOfClass"Humanoid"
										if Humanoid and 0 < Humanoid.Health and Zombie:FindFirstChild"Configuration" and Zombie.Configuration:FindFirstChild"XPReward" then
											table.insert(Targets,{
												Humanoid = Humanoid,
												Hit = Zombie:GetPivot().Position,
												XPReward = Zombie.Configuration.XPReward.Value
											})
										end
									end
									local HighestWorth = 0
									for _,Zombie in Targets do
										local XPWorth = Zombie.XPReward/math.max(Zombie.Humanoid.Health,Variables.DPS[Variables.Selection])
										if HighestWorth < XPWorth then
											Target,Hit,HighestWorth = Zombie.Humanoid,Zombie.Hit,XPWorth
										end
									end
								end
								if Target then
									local LaserProperties = {}
									for _ = 1,Variables.Burst do
										table.insert(LaserProperties,{
											"Neon",
											BrickColor.new"Really black",
											-Vector3.yAxis,
											CFrame.lookAt(Hit,Hit-Vector3.yAxis),
											Hit,
											Variables.Range,
											true,
											-Vector3.yAxis
										})
									end
									workspace.CurrentCamera.CameraSubject = Target
									Variables.WeaponEvent:FireServer{
										Tool = Gun,
										RealTool = Gun,
										HumanoidTables = {
											{
												BodyHits = 0,
												THumanoid = Target,
												HeadHits = Variables.Burst,
											}
										},
										LaserProperties = LaserProperties
									}
								end
							end
						end
						Variables.Debounce = false
					end
				end)
				Variables.WaveChanged = Connect(Variables.CurrentWave:GetPropertyChangedSignal"Value",function()
					if 49 < Variables.CurrentWave.Value and Variables.CurrentWave.Value%10 == 0 and Character then
						Character:BreakJoints()
					end
				end)
				AddConnections{
					Variables.Connection,
					Variables.WaveChanged
				}
			else
				RunCommand"AllowAFK"
				RemoveConnections{
					Variables.Connection,
					Variables.WaveChanged
				}
				if Character then
					Character:PivotTo(workspace.CurrentCamera.Focus)
					workspace.CurrentCamera.CameraSubject = GetHumanoid(Character,1)
				end
			end
		end,
		Toggles = "Unfarm_unautofarm_unautoplay_stopplaying_unautp_stopp_unautof_unf_uaf_uf",
		ToggleCheck = true,
		Arguments = {
			{
				Name = "FocusOnKills",
				Type = "Boolean",
				Substitute = false
			}
		},
		Variables = {
			DPS = {
				BlueMinigun = 2700,
				Atmoblaster = 360,
				GhostBlaster = 459,
				EgoExpander = 693,
				PigsBoson = 840,
				EclecticRifle = 1875,
				FlakCannon = 2550,
				Sniper = 115.5,
				GatlingLaser = 2250,
				FireBlaster = 2325,
				Luger = 585,
				SpacePirateGun = 148.5,
				BlastGun = 2028,
				Bow = 125.25,
				DarkMatterPistol = 2484,
				M1Garand = 660,
				MarsBlaster = 369,
				HotChocolateGun = 2100,
				Pistol = 150.75,
				IceCannon = 2400,
				Sterling = 600,
				GoldenPistol = 735,
				SuperDisruptor = 1648.5,
				Shotgun = 165,
				TarydiumPistol = 840,
				HeatLauncher = 2174.25,
				TX08 = 1026,
				Sviper = 800.25,
				Zapper = 870,
				TrenchGun = 637.5,
				PartyRocker = 393.75,
				SuperFreezeRay = 420,
				SMG = 126,
				Spitter = 2853,
				FreezeRay = 975,
				LaserRifle = 222,
				AssaultRifle = 183,
				["LaserRobot-DanceGun"] = 720,
				ShrinkRay = 930,
				PurpleLaserRifle = 765,
				BlowDryer = 3000,
				ReapersVoid = 1512,
				ScatterBlaster = 1950,
				PewPewGun = 1800,
				TeslaElectricGun = 900,
				LaserSniper = 487.5,
				AlienRaygun = 1575,
				["8BitCrossbow"] = 4650,
				LavaGun = 1125,
				LaserPistol = 160.125
			},
			AvailableGuns = {},
			Selection = "Pistol",
			Zombies = workspace:WaitForChild"Zombie Storage",
			CurrentGun = WaitForSequence(Owner,"EquipStorage","Primary"),
			Equip = WaitForSequence(Service"ReplicatedStorage","Remotes","StoreEquip"),
			WeaponEvent = WaitForSequence(Service"ReplicatedStorage","Remotes","WeaponEvent"),
			Primary = WaitForSequence(Service"ReplicatedStorage","WeaponRequirements","Primary"),
			BackpackEvent = WaitForSequence(Service"ReplicatedStorage","Remotes","BackpackEvent"),
			GunSelection = WaitForSequence(PlayerGui,"MainGui","Menu","Tab1Frame","ScrollingFrame"),
			CurrentWave = WaitForSequence(Service"ReplicatedStorage","GameProperties","CurrentWave")
		}
	}
}