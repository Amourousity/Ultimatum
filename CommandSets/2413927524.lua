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
								Scrap = Color3.new(1,.5,0),
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
		}
	},
	AutoFarm_autoplay_autop_autof_farm_af = {
		Function = function(Variables,Enabled)
			if Enabled then
				RunCommand"AntiAFK"
				Variables.Debounce = false
				Variables.Waypoints,Variables.Index = {},2
				Variables.Delta,Variables.LastFrame = 0,os.clock()
				Variables.Position = workspace.CurrentCamera.Focus.Position
				Variables.Connection = Connect(Service"Run".Heartbeat,function()
					Variables:FireHeartbeat()
				end)
				AddConnections{Variables.Connection}
			else
				RunCommand"AllowAFK"
				RemoveConnections{Variables.Connection}
			end
		end,
		Toggles = "Unfarm_unautofarm_unautoplay_stopplaying_unautp_stopp_unautof_unf_uaf_uf",
		ToggleCheck = true,
		Variables = {
			RayParams = (function()
				local RayParams = RaycastParams.new()
				RayParams.IgnoreWater = true
				RayParams.RespectCanCollide = true
				return RayParams
			end)(),
			ScrapSpawns = WaitForSequence(workspace,"Filter","ScrapSpawns"),
			Path = Service"Pathfinding":CreatePath{
				AgentCanJump = true,
				WaypointSpacing = 1,
				AgentCanClimb = true
			},
			MoveTo = function(Variables,Position)
				RemoveConnections{Variables.Blocked}
				Variables.Path:ComputeAsync(Variables.Position,Position)
				if Variables.Path.Status == Enum.PathStatus.Success then
					Variables.Waypoints,Variables.Index = Variables.Path:GetWaypoints(),2
					Variables.Blocked = Connect(Variables.Path.Blocked,function(BlockedIndex)
						if Variables.Index <= BlockedIndex then
							Variables.Waypoints,Variables.Index = {},2
							RemoveConnections{Variables.Blocked}
						end
					end)
					AddConnections{Variables.Blocked}
				end
			end,
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
				if Waypoint and Variables.Target and Variables.Target:IsDescendantOf(Variables.ScrapSpawns) then
					Waypoint = Waypoint.Position
					DistanceLeft = DistanceLeft or Variables.Delta/2
					local Travel = math.min(DistanceLeft,((Variables.Position-Waypoint)*Vector3.new(1,0,1)).Magnitude)
					DistanceLeft -= Travel
					Variables.Position = CFrame.lookAt(Variables.Position,Waypoint*Vector3.new(1,0,1)+Variables.Position*Vector3.yAxis)*CFrame.new(0,0,-Travel).Position
					for _,BasePart in Character:GetChildren() do
						if Valid.Instance(BasePart,"BasePart") then
							BasePart.AssemblyLinearVelocity = Vector3.zero
						end
					end
					if 0 < DistanceLeft then
						Variables.Index += 1
						Variables:FireHeartbeat(DistanceLeft)
					end
					Variables.RayParams.FilterDescendantsInstances = {Character}
					local Ceiling = workspace:Raycast(Variables.Position,Vector3.yAxis*1e3,Variables.RayParams)
					local Floor = workspace:Raycast(Ceiling and Ceiling.Position or Variables.Position+Vector3.yAxis*1e3,-Vector3.yAxis*5e3,Variables.RayParams)
					Character:PivotTo(CFrame.new(Floor and Floor+Vector3.yAxis*3 or Variables.Position)*CFrame.new(-Character:GetPivot().Position)*Character:GetPivot())
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
			end
		}
	}
}
