return {
	AutoFarm_autoplay_autop_autof_farm_af = {
		Function = function(Variables, Enabled)
			if Enabled then
				runCommand("AntiAFK")
				Variables.Debounce = false
				Variables.CurrentStep = 1
				Variables.Position = workspace.CurrentCamera.Focus.Position - Vector3.yAxis * 10
				Variables.CurrentCharacter = character
				Variables.Delta, Variables.LastFrame = 0, os.clock()
				Variables.Heartbeat = connect(service("Run").Heartbeat, function()
					Variables.Delta, Variables.LastFrame =
						math.min(os.clock() - Variables.LastFrame, 1 / 15) * 60, os.clock()
					if not character then
						return
					end
					for _, BasePart in character:GetChildren() do
						if valid.instance(BasePart, "BasePart") then
							BasePart.AssemblyLinearVelocity = Vector3.zero
						end
					end
					if not Variables.Debounce then
						Variables.Debounce = true
						if character ~= Variables.CurrentCharacter then
							wait(2)
							Variables.CurrentStep = 1
							Variables.CameraPosition = workspace.CurrentCamera.CFrame
							Variables.Position = workspace.CurrentCamera.Focus.Position - Vector3.yAxis * 10
							Variables.CurrentCharacter = character
						end
						local Target = ({
							Vector3.new(-56, -28, 1150),
							Vector3.new(-56, -28, 8500),
							Vector3.new(-56, -370, 8510),
							Vector3.new(-56, -370, 9490),
							Vector3.new(-56, -360, 9490),
						})[Variables.CurrentStep]
						if Target then
							Variables.OldPosition = Variables.Position
							Variables.Position = CFrame.lookAt(Variables.Position, Target)
								* CFrame.new(
									0,
									0,
									-math.min(Variables.Delta * (35 / 6), (Variables.Position - Target).Magnitude)
								).Position
							character:PivotTo(CFrame.new(Variables.Position) * CFrame.Angles(math.pi / 2, 0, 0))
							if (Variables.Position - Target).Magnitude < 0.01 then
								Variables.CurrentStep += 1
							end
						else
							Variables.OldPosition, Variables.Position =
								Vector3.new(-56, 0.7, 9463.3), Vector3.new(-56, 0, 9464)
						end
						Variables.Debounce = false
					end
				end)
				Variables.Stepped = connect(service("Run").Stepped, function()
					if not character then
						return
					end
					for _, BasePart in character:GetDescendants() do
						if valid.instance(BasePart, "BasePart") then
							local Variable = 5 < Variables.CurrentStep
							BasePart.CanCollide, BasePart.CanTouch, BasePart.CanQuery = Variable, Variable, Variable
						end
					end
				end)
				Variables.RenderStepped = connect(service("Run").RenderStepped, function()
					if Variables.OldPosition and Variables.Position then
						local Y = workspace:Raycast(Variables.Position * Vector3.new(1, 0, 1), -Vector3.yAxis * 1e3)
						Y = if Y
							then Y.Position * Vector3.yAxis + Vector3.yAxis * 20
							else Variables.Position * Vector3.yAxis + Vector3.yAxis * 25
						local LookDirection = CFrame.lookAt(Variables.OldPosition, Variables.Position)
						Variables.CameraPosition = (
							CFrame.new(Variables.Position * Vector3.new(1, 0, 1) + Y)
							* CFrame.new(-LookDirection.Position)
							* LookDirection
						):Lerp(
							CFrame.new(
								Variables.Position * Vector3.new(1, 0, 1) + Vector3.yAxis * Variables.CameraPosition.Y
							)
								* CFrame.new(-Variables.CameraPosition.Position)
								* Variables.CameraPosition,
							0.9 ^ Variables.Delta
						)
						workspace.CurrentCamera.CFrame = Variables.CameraPosition
					end
					for _, BasePart in character:GetDescendants() do
						if valid.instance(BasePart, "BasePart") then
							BasePart.LocalTransparencyModifier = 1
						end
					end
				end)
				addConnections({
					Variables.Stepped,
					Variables.Heartbeat,
					Variables.RenderStepped,
				})
			else
				runCommand("AllowAFK")
				removeConnections({
					Variables.Stepped,
					Variables.Heartbeat,
					Variables.RenderStepped,
				})
				for _, BasePart in character:GetChildren() do
					if valid.instance(BasePart, "BasePart") then
						BasePart.CanCollide, BasePart.CanTouch, BasePart.CanQuery = true, true, true
					end
				end
			end
		end,
		Toggles = "Unfarm_unautofarm_unautoplay_stopplaying_unautp_stopp_unautof_unf_uaf_uf",
		ToggleCheck = true,
		Variables = { CameraPosition = CFrame.new() },
		Description = "Automatically collects gold coins/blocks",
	},
}
