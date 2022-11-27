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
				Variables.CurrentStep = 1
				Variables.Position = workspace.CurrentCamera.Focus.Position-Vector3.yAxis*10
				Variables.CurrentCharacter = Character
				Variables.Delta,Variables.LastFrame = 0,os.clock()
				Variables.Heartbeat = Connect(Service"Run".Heartbeat,function()
					Variables.Delta,Variables.LastFrame = math.min(os.clock()-Variables.LastFrame,1/15)*60,os.clock()
					if not Character then
						return
					end
					for _,BasePart in Character:GetChildren() do
						if Valid.Instance(BasePart,"BasePart") then
							BasePart.AssemblyLinearVelocity = Vector3.zero
						end
					end
					if not Variables.Debounce then
						Variables.Debounce = true
						if Character ~= Variables.CurrentCharacter then
							Wait(2)
							Variables.CurrentStep = 1
							Variables.CameraPosition = workspace.CurrentCamera.CFrame
							Variables.Position = workspace.CurrentCamera.Focus.Position-Vector3.yAxis*10
							Variables.CurrentCharacter = Character
						end
						local Target = ({
							Vector3.new(-56,-28,1150),
							Vector3.new(-56,-28,8500),
							Vector3.new(-56,-370,8510),
							Vector3.new(-56,-370,9490),
							Vector3.new(-56,-360,9490)
						})[Variables.CurrentStep]
						if Target then
							Variables.OldPosition = Variables.Position
							Variables.Position = CFrame.lookAt(Variables.Position,Target)*CFrame.new(0,0,-math.min(Variables.Delta*(35/6),(Variables.Position-Target).Magnitude)).Position
							Character:PivotTo(CFrame.new(Variables.Position)*CFrame.Angles(math.pi/2,0,0))
							if (Variables.Position-Target).Magnitude < .01 then
								Variables.CurrentStep += 1
							end
						else
							Variables.OldPosition,Variables.Position = Vector3.new(-56,.7,9463.3),Vector3.new(-56,0,9464)
						end
						Variables.Debounce = false
					end
				end)
				Variables.Stepped = Connect(Service"Run".Stepped,function()
					if not Character then
						return
					end
					for _,BasePart in Character:GetDescendants() do
						if Valid.Instance(BasePart,"BasePart") then
							local Variable = 5 < Variables.CurrentStep
							BasePart.CanCollide,BasePart.CanTouch,BasePart.CanQuery = Variable,Variable,Variable
						end
					end
				end)
				Variables.RenderStepped = Connect(Service"Run".RenderStepped,function()
					if Variables.OldPosition and Variables.Position then
						local Y = workspace:Raycast(Variables.Position*Vector3.new(1,0,1),-Vector3.yAxis*1e3)
						Y = if Y then Y.Position*Vector3.yAxis+Vector3.yAxis*20 else Variables.Position*Vector3.yAxis+Vector3.yAxis*25
						local LookDirection = CFrame.lookAt(Variables.OldPosition,Variables.Position)
						Variables.CameraPosition = (CFrame.new(Variables.Position*Vector3.new(1,0,1)+Y)*CFrame.new(-LookDirection.Position)*LookDirection):Lerp(CFrame.new(Variables.Position*Vector3.new(1,0,1)+Vector3.yAxis*Variables.CameraPosition.Y)*CFrame.new(-Variables.CameraPosition.Position)*Variables.CameraPosition,.9^Variables.Delta)
						workspace.CurrentCamera.CFrame = Variables.CameraPosition
					end
					for _,BasePart in Character:GetDescendants() do
						if Valid.Instance(BasePart,"BasePart") then
							BasePart.LocalTransparencyModifier = 1
						end
					end
				end)
				AddConnections{
					Variables.Stepped,
					Variables.Heartbeat,
					Variables.RenderStepped
				}
			else
				RunCommand"AllowAFK"
				RemoveConnections{
					Variables.Stepped,
					Variables.Heartbeat,
					Variables.RenderStepped
				}
				for _,BasePart in Character:GetChildren() do
					if Valid.Instance(BasePart,"BasePart") then
						BasePart.CanCollide,BasePart.CanTouch,BasePart.CanQuery = true,true,true
					end
				end
			end
		end,
		Toggles = "Unfarm_unautofarm_unautoplay_stopplaying_unautp_stopp_unautof_unf_uaf_uf",
		ToggleCheck = true,
		Variables = {CameraPosition = CFrame.new()},
		Description = "Automatically collects gold coins/blocks"
	}
}