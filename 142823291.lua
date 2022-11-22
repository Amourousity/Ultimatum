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
				Variables.Time,Variables.Connection = os.clock(),Connect(Service"Run".Heartbeat,function()
					if not Variables.Calculating and 1 < os.clock()-Variables.Time or 5 < os.clock()-Variables.Time then
						Variables.Time,Variables.Calculating = os.clock(),true
						local PlayerData = Variables.PlayerDataRemote:InvokeServer()
						if not Variables.Enabled then
							return
						end
						Destroy(Variables.ExtrasensoryPerceptions)
						if workspace:FindFirstChild"GunDrop" then
							Variables:CreatESP(workspace.GunDrop,"Gun")
						end
						for _,Player in Service"Players":GetPlayers() do
							local Data = PlayerData[Player.Name]
							if Data and not Data.Dead and Player.Name ~= Owner.Name then
								Variables:CreatESP(Player.Character:FindFirstChild"HumanoidRootPart" or Player.Character:FindFirstChildWhichIsA"BasePart",Data.Role)
							end
						end
						Variables.Calculating = false
					end
				end)
				AddConnections{Variables.Connection}
			else
				RemoveConnections{Variables.Connection}
				Destroy(Variables.ExtrasensoryPerceptions)
			end
		end,
		Toggles = "SensoryPerception_sensoryp_sperception_sp_unextrasensoryperception_unextrasensoryp_unesperception_unextrasp_unesp_uesp",
		ToggleCheck = true,
		Variables = game.PlaceId == 142823291 and {
			ExtrasensoryPerceptions = {},
			PlayerDataRemote = WaitForSequence(Service"ReplicatedStorage","Remotes","Extras","GetPlayerData"),
			CreateExtrasensoryPerception = function(Variables,Object,Role)
				local LargestAxis = math.max(Object.Size.X,Object.Size.Y,Object.Size.Z)
				table.insert(Variables.ExtrasensoryPerceptions,Create{
					{
						Name = "ExtrasensoryPerceptionHolder",
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
						Parent = "ExtrasensoryPerceptionHolder",
						ClassName = "Frame",
						Properties = {
							Size = UDim2.new(1,0,1,0),
							BackgroundColor3 = ({
								Gun = Color3.new(.5,0,1),
								Hero = Color3.new(1,1,0),
								Sheriff = Color3.new(0,0,1),
								Zombie = Color3.new(0,.5,0),
								Innocent = Color3.new(0,1,0),
								Murderer = Color3.new(1,0,0),
								Survivor = Color3.new(0,0,1)
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
				Variables.Delta,Variables.LastFrame,Variables.Coins,Variables.IgnoreCoins,Variables.Position = 0,os.clock(),{},{},workspace.CurrentCamera.Focus.Position
				Variables.CoinAdded = Connect(workspace.DescendantAdded,function(Coin)
					if Coin:IsA"BasePart" and Coin.Name == "Coin_Server" then
						table.insert(Variables.Coins,Coin)
						local Connection
						Connection = Connect(Coin.AncestryChanged,function()
							if not Coin:IsDescendantOf(workspace) then
								table.remove(Variables.Coins,table.find(Variables.Coins,Coin))
								RemoveConnections{Connection}
							end
						end)
						AddConnections{Connection}
					end
				end)
				Variables.CharacterAdded = Connect(Owner.CharacterAdded,function(Character)
					Variables.Collecting = true
					Variables.Position = Character:GetPivot().Position
					Wait(5)
					Variables.Collecting = false
					RunCommand"Invisible"
					Wait(WaitForSequence(PlayerGui,"MainGUI","Game","CashBag","Full"):GetPropertyChangedSignal"Visible")
					Character:BreakJoints()
				end)
				Variables.Stepped = Connect(Service"Run".Stepped,function()
					if not Variables.FoundCoin then
						return
					end
					for _,BasePart in Valid.Table(Character and Character:GetChildren()) do
						if Valid.Instance(BasePart,"BasePart") then
							BasePart.AssemblyLinearVelocity,BasePart.CanCollide,BasePart.CanTouch,BasePart.CanQuery = Vector3.zero,BasePart.Name == "HumanoidRootPart" and Variables.Collecting,Variables.Collecting,Variables.Collecting
						end
					end
				end)
				Variables.Connection = Connect(Service"Run".Heartbeat,function()
					Variables.Delta,Variables.LastFrame = math.min(os.clock()-Variables.LastFrame,1/15)*60,os.clock()
					for Coin,Time in Variables.IgnoreCoins do
						if not Coin:IsDescendantOf(workspace) or 3 < Variables.LastFrame-Time then
							Variables.IgnoreCoins[Coin] = nil
						end
					end
					Variables.FoundCoin = false
					if not Variables.Collecting then
						local Distance,Coin = math.huge,nil
						for _,NewCoin in Variables.Coins do
							local Magnitude = (NewCoin.Position-Variables.Position).Magnitude
							if not Variables.IgnoreCoins[NewCoin] and not NewCoin:FindFirstChildWhichIsA"Model" and NewCoin:FindFirstChild"Coin" and Magnitude < Distance then
								Coin,Distance = NewCoin,Magnitude
							end
						end
						if Coin and Distance < 250 and Variables.Position ~= Coin.Position then
							Variables.FoundCoin = true
							Variables.Position = CFrame.lookAt(Variables.Position,Coin.Position)*CFrame.new(0,0,-math.min(25*Variables.Delta/60,Distance)).Position
							Character:PivotTo(CFrame.new(Variables.Position-Vector3.yAxis*2)*CFrame.Angles(math.pi/2,0,0))
							if (Variables.Position-Coin.Position).Magnitude < .01 then
								Variables.Collecting = true
								Variables.IgnoreCoins[Coin] = os.clock()
								repeat
									Wait()
									Character:PivotTo(CFrame.new(Variables.Position)*CFrame.Angles(math.pi/2,0,0))
								until .25 < os.clock()-Variables.IgnoreCoins[Coin]
								Variables.Collecting = false
							end
						else
							Variables.Position = Character:GetPivot().Position
						end
					end
				end)
				AddConnections{
					Variables.Stepped,
					Variables.CoinAdded,
					Variables.Connection,
					Variables.CharacterAdded
				}
			else
				RunCommand"AllowAFK"
				RemoveConnections{
					Variables.Stepped,
					Variables.CoinAdded,
					Variables.Connection,
					Variables.CharacterAdded
				}
			end
		end,
		Toggles = "Unfarm_unautofarm_unautoplay_stopplaying_unautp_stopp_unautof_unf_uaf_uf",
		ToggleCheck = true,
		Variables = {}
	}
}