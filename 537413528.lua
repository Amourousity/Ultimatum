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
		Function = function(Variables,Enabled)
			if Enabled then
				RunCommand"AntiAFK"
				Variables.Debounce = false
				Variables.CurrentStage = 0
				Variables.CurrentCharacter = Character
				Variables.Heartbeat = Connect(Service"Run".Heartbeat,function()
					if not Character then
						return
					end
					Character:PivotTo(Character ~= Variables.CurrentCharacter and CFrame.new(0,-50,0) or Variables.CFrame*CFrame.Angles(math.pi/2,0,0))
					for _,BasePart in Character:GetChildren() do
						if Valid.Instance(BasePart,"BasePart") then
							BasePart.AssemblyLinearVelocity = Vector3.zero
						end
					end
					if not Variables.Debounce then
						Variables.Debounce = true
						if Character ~= Variables.CurrentCharacter then
							Wait(2)
							task.spawn(getconnections(WaitForSequence(PlayerGui,"RiverResultsGui","Frame","BuyButton").MouseButton1Click)[1].Function)
							Wait(1)
							Variables.CurrentStage = 0
							Variables.CurrentCharacter = Character
						end
						Variables.CurrentStage += 1
						local DarknessPart = 10 < Variables.CurrentStage or WaitForSequence(Variables.Stages,("CaveStage%d"):format(Variables.CurrentStage),"DarknessPart")
						Variables.CFrame = 10 < Variables.CurrentStage and CFrame.new(-56,-360,9500) or DarknessPart.CFrame*CFrame.new(0,1-DarknessPart.Size.Y/2,0)
						Wait(2.5)
						Variables.Debounce = false
					end
				end)
				Variables.Stepped = Connect(Service"Run".Stepped,function()
					if not Character then
						return
					end
					for _,BasePart in Character:GetDescendants() do
						if Valid.Instance(BasePart,"BasePart") then
							local Variable = 10 < Variables.CurrentStage
							BasePart.CanCollide,BasePart.CanTouch,BasePart.CanQuery = Variable,Variable,Variable
						end
					end
				end)
				AddConnections{
					Variables.Stepped,
					Variables.Heartbeat
				}
			else
				RunCommand"AllowAFK"
				RemoveConnections{
					Variables.Stepped,
					Variables.Heartbeat
				}
			end
		end,
		Toggles = "Unfarm_unautofarm_unautoplay_stopplaying_unautp_stopp_unautof_unf_uaf_uf",
		ToggleCheck = true,
		Variables = {
			CurrentStage = -1,
			CFrame = workspace.CurrentCamera.Focus,
			Stages = WaitForSequence(workspace,"BoatStages","NormalStages")
		}
	}
}