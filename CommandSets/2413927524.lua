return {
	ExtrasensoryPerception_extrasensoryp_esensoryperception_esperception_extrasp_esp = {
		Function = function(Variables,Enabled)
			if Enabled then
				Variables.Time,Variables.Connection = 0,Connect(Service"Run".Heartbeat,function()
					if 1 < os.clock()-Variables.Time then
						Variables.Time = os.clock()
						Destroy(Variables.ESPs)
						for _,Spawn in Variables.ScrapSpawns:GetChildren() do
							local Descendants = Spawn:GetDescendants()
							if 0 < #Descendants then
								for _,Scrap in Descendants do
									if Valid.Instance(Scrap,"BasePart") then
										Variables:CreateESP(Scrap,"Scrap")
										break
									end
								end
							end
						end
						if workspace:FindFirstChild"Rake" then
							Variables:CreateESP(WaitForSequence(workspace,"Rake","HumanoidRootPart"),"Rake")
						end
						if workspace:FindFirstChild"FlareGunPickup" then
							Variables:CreateESP(WaitForSequence(workspace,"FlareGunPickup","FlareGun"),"FlareGun")
						end
					end
				end)
				AddConnections{Variables.Connection}
			else
				RemoveConnections{Variables.Connection}
				Destroy(Variables.ESPs)
			end
		end,
		Toggles = "SensoryPerception_sensoryp_sperception_sp_unextrasensoryperception_unextrasensoryp_unesperception_unextrasp_unesp_uesp",
		ToggleCheck = true,
		Variables = {
			ESPs = {},
			ScrapSpawns = WaitForSequence(workspace,"Filter","ScrapSpawns"),
			CreateESP = function(Variables,Object,Role)
				local LargestAxis = math.max(Object.Size.X,Object.Size.Y,Object.Size.Z)
				table.insert(Variables.ESPs,Create{
					{
						Name = "ESPHolder",
						Parent = Gui.Holder,
						ClassName = "BillboardGui",
						Properties = {
							Active = false,
							Adornee = Object,
							AlwaysOnTop = true,
							LightInfluence = 0,
							ResetOnSpawn = false,
							Size = UDim2.new(LargestAxis,0,LargestAxis,0)
						}
					},
					{
						Name = "Main",
						Parent = "ESPHolder",
						ClassName = "Frame",
						Properties = {
							Size = UDim2.new(1,0,1,0),
							BackgroundColor3 = ({
								Rake = Color3.new(1,0,0),
								Scrap = Color3.new(0,1,0),
								FlareGun = Color3.new(.5,0,1)
							})[Role]
						}
					},
					{
						Name = "Gradient",
						Parent = "Main",
						ClassName = "UIGradient",
						Properties = {
							Rotation = 90,
							Transparency = NumberSequence.new(0,1)
						}
					},
					{
						Name = "Corner",
						Parent = "Main",
						ClassName = "UICorner",
						Properties = {CornerRadius = UDim.new(.5,0)}
					}
				})
			end
		},
		Description = "Locates the Rake, all scraps, and the flare gun"
	},
	AutoFarm_autoplay_autop_autof_farm_af = {
		Function = function(Variables,Enabled)
			if Enabled then
				RunCommand"AntiAFK"
				Variables.Debounce = false
				workspace.FallenPartsDestroyHeight = 0/0
				Variables.Waypoints,Variables.Index = {},2
				Variables.SoldScraps = Variables.Night.Value
				Variables.Delta,Variables.LastFrame = 0,os.clock()
				Variables.Position = workspace.CurrentCamera.Focus.Position
				Variables.Connection = Connect(Service"Run".Heartbeat,function()
					Variables:FireHeartbeat()
				end)
				Variables.NightChanged = Connect(Variables.Night:GetPropertyChangedSignal"Value",function()
					Variables.SoldScraps = Variables.Night.Value
				end)
				AddConnections{Variables.Connection}
			else
				RunCommand"AllowAFK"
				RemoveConnections{Variables.Connection}
				workspace.FallenPartsDestroyHeight = Variables.DestroyHeight
			end
		end,
		Toggles = "Unfarm_unautofarm_unautoplay_stopplaying_unautp_stopp_unautof_unf_uaf_uf",
		ToggleCheck = true,
		Variables = {
			DestroyHeight = workspace.FallenPartsDestroyHeight,
			RayParams = (function()
				local RayParams = RaycastParams.new()
				RayParams.IgnoreWater = true
				RayParams.RespectCanCollide = true
				return RayParams
			end)(),
			ScrapSpawns = WaitForSequence(workspace,"Filter","ScrapSpawns"),
			Path = Service"Pathfinding":CreatePath{
				AgentCanJump = true,
				WaypointSpacing = 3,
				AgentCanClimb = true
			},
			MoveTo = function(Variables,Position)
				Variables.Path:ComputeAsync(Variables.Position,Position)
				if Variables.Path.Status == Enum.PathStatus.Success then
					Variables.Waypoints,Variables.Index = Variables.Path:GetWaypoints(),2
				end
			end,
			Night = Service"ReplicatedStorage":WaitForChild"Night",
			ShopPart = WaitForSequence(workspace,"Map","Shack","ShopPart"),
			ShopEvent = Service"ReplicatedStorage":WaitForChild"ShopEvent",
			FireHeartbeat = function(Variables,DistanceLeft)
				if not DistanceLeft then
					Variables.Delta,Variables.LastFrame = math.min(os.clock()-Variables.LastFrame,1/15)*60,os.clock()
				end
				if not Character then
					return
				end
				if 3 < ((Variables.Position-Character:GetPivot().Position)*Vector3.new(1,0,1)).Magnitude then
					Variables.Position = Character:GetPivot().Position
					Variables.Waypoints,Variables.Index = {},2
				end
				local Waypoint = Variables.Waypoints[Variables.Index]
				if Waypoint and Variables.Target and Variables.Target:IsDescendantOf(workspace) then
					Waypoint = Waypoint.Position
					DistanceLeft = DistanceLeft or Variables.Delta*(25/60)
					local Travel = math.min(DistanceLeft,((Variables.Position-Waypoint)*Vector3.new(1,0,1)).Magnitude)
					DistanceLeft -= Travel
					Variables.Position = CFrame.lookAt(Variables.Position,Waypoint*Vector3.new(1,0,1)+Variables.Position*Vector3.yAxis)*CFrame.new(0,0,-Travel).Position
					for _,BasePart in Character:GetChildren() do
						if Valid.Instance(BasePart,"BasePart") then
							BasePart.AssemblyLinearVelocity = Vector3.zero
						end
					end
					Variables.RayParams.FilterDescendantsInstances = {Character}
					local Ceiling = workspace:Raycast(Variables.Position,Vector3.yAxis*1e3,Variables.RayParams)
					local Floor = workspace:Raycast(Ceiling and Ceiling.Position or Variables.Position+Vector3.yAxis*1e3,-Vector3.yAxis*5e3,Variables.RayParams)
					Character:PivotTo(Valid.CFrame(CFrame.new(Floor and Floor.Position+Vector3.yAxis*4.5 or Variables.Position)*CFrame.new(-Character:GetPivot().Position)*Character:GetPivot(),Character:GetPivot()))
					if 0 < DistanceLeft then
						Variables.Index += 1
						Variables:FireHeartbeat(DistanceLeft)
					end
				elseif not Variables.Debounce then
					Variables.Debounce = true
					Variables.Position = Character:GetPivot().Position
					local Closest,Distance = nil,math.huge
					for _,Spawn in Variables.ScrapSpawns:GetChildren() do
						local Descendants = Spawn:GetDescendants()
						if 0 < #Descendants then
							for _,Scrap in Descendants do
								if Valid.Instance(Scrap,"BasePart") then
									local Magnitude = (Scrap.Position-Variables.Position).Magnitude
									if Magnitude < Distance then
										Closest,Distance = Scrap,Magnitude
									end
									break
								end
							end
						end
					end
					if Closest then
						Variables.Target = Closest
						Variables:MoveTo(Closest.Position)
					end
					Variables.Debounce = false
				end
				if not Variables.SoldScraps and Variables.Target ~= Variables.ShopPart and Backpack and Backpack:IsDescendantOf(Owner) and Backpack:FindFirstChild"ScrapFolder" and Backpack.ScrapFolder:FindFirstChild"Points" and 0 < Backpack.ScrapFolder.Points.Value then
					Variables.Debounce = true
					Variables.Target = Variables.ShopPart
					Variables:MoveTo(Variables.ShopPart.Position)
					Variables.Debounce = false
				end
				if not Variables.SoldScraps and (Variables.Position-Variables.ShopPart.Position).Magnitude < 7 then
					Variables.Debounce = true
					for _,Values in {
						{"Open"},
						{"SellScraps","Scraps"},
						{"Close"}
					} do
						Variables.ShopEvent:FireServer(unpack(Values))
						Wait(.5)
					end
					Variables.SoldScraps = true
					Variables.Debounce = false
				end
				if workspace:FindFirstChild"Rake" and (workspace.Rake:FindFirstChild"TargetVal" and workspace.Rake.TargetVal.Value and workspace.Rake.TargetVal.Value:IsDescendantOf(Character) or (Variables.Position-workspace.Rake:GetPivot().Position).Magnitude < 75) and (not Variables.Target or Variables.Target.Parent ~= Variables.ScrapSpawns) then
					Variables.Debounce = true
					local Rake = workspace.Rake:GetPivot().Position
					local Farthest,Distance = nil,0
					for _,Spawn in Variables.ScrapSpawns:GetChildren() do
						local Magnitude = (Spawn.Position-Rake).Magnitude
						if Distance < Magnitude then
							Farthest,Distance = Spawn,Magnitude
						end
					end
					if Farthest then
						Variables.Target = Farthest
						Variables:MoveTo(Farthest.Position)
					end
					Variables.Debounce = false
				end
			end
		},
		Description = "Automatically collects scraps, but you'll need to manually sell them for points (for now)"
	}
}
