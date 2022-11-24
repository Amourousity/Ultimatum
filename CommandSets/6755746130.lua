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
				Service"StarterGui":SetCoreGuiEnabled("Backpack",false)
				Variables.Connection = Connect(Service"Run".Heartbeat,function()
					if not Character then
						return
					end
					local Toucher = Character:FindFirstChildWhichIsA"BasePart"
					if not Toucher then
						return
					end
					Character:PivotTo(Variables.Position)
					for _,BasePart in Character:GetChildren() do
						if Valid.Instance(BasePart,"BasePart") then
							BasePart.AssemblyLinearVelocity = Vector3.zero
						end
					end
					if PlayerGui:FindFirstChild"HintGui" then
						PlayerGui.HintGui.Enabled = false
					end
					for _,BasePart in Variables.Ignored:GetDescendants() do
						if Valid.Instance(BasePart,"BasePart") then
							BasePart.LocalTransparencyModifier = 1
						end
					end
					if not Variables.Debounce then
						Variables.Debounce = true
						if not Valid.Instance(Variables.OwnedTycoon.Value,"Model") then
							for _,Tycoon in Variables.Tycoons:GetChildren() do
								if not Valid.Instance(Tycoon:WaitForChild"Owner".Value,"Player") then
									FireTouchInterest(Toucher,WaitForSequence(Tycoon,"Essentials","Entrance"))
									Wait(1)
									break
								end
							end
						end
						if not Valid.Instance(Variables.Tycoon,"Model") then
							Variables.Tycoon = Variables.OwnedTycoon.Value
							Variables.Essentials = Variables.Tycoon:WaitForChild"Essentials"
							local PromptAttachment = WaitForSequence(Variables.Essentials,"JuiceMaker","AddFruitButton","PromptAttachment")
							Variables.Position = CFrame.new(PromptAttachment.WorldPosition-Vector3.yAxis*8)*CFrame.Angles(math.pi/2,0,0)
							Variables.AddPrompt = PromptAttachment:WaitForChild"AddPrompt"
							Variables.Drops = Variables.Tycoon:WaitForChild"Drops"
							Variables.Buttons = Variables.Tycoon:WaitForChild"Buttons"
							Variables.Purchased = Variables.Tycoon:WaitForChild"Purchased"
							Variables.Spawn = Variables.Essentials:WaitForChild"SpawnLocation"
						end
						if Variables.Purchased:FindFirstChild"Golden Tree Statue" then
							Variables.RequestPrestige:FireServer()
							Variables.Tycoon = nil
							Wait(3)
						end
						if Backpack then
							for _,Tool in Backpack:GetChildren() do
								Tool.Parent = Character
							end
							local Collect
							for _,Drop in Variables.Drops:GetChildren() do
								if not Drop:GetAttribute"Collected" then
									Collect = true
									Drop:SetAttribute("Collected",true)
									Variables.CollectFruit:FireServer(Drop)
								end
							end
							if Collect then
								if fireproximityprompt then
									fireproximityprompt(Variables.AddPrompt)
								elseif keypress then
									keypress(69)
									task.defer(keyrelease,69)
								end
							end
						end
						if Toucher and PlayerGui:FindFirstChild"ObbyInfoBillBoard" and PlayerGui.ObbyInfoBillBoard:FindFirstChild"TopText" and PlayerGui.ObbyInfoBillBoard.TopText.Text == "Start Obby" then
							FireTouchInterest(Toucher,Variables.VictoryPart)
							Wait(1)
						end
						local LowestPrice,ChosenButton = math.huge,nil
						for _,Button in Variables.Buttons:GetDescendants() do
							if Valid.Instance(Button,"BasePart") and 0 < #Button:GetChildren() and Button.Name ~= "AutoCollect" then
								local Price = tonumber((WaitForSequence(Button,"ButtonLabel","CostLabel").Text:gsub("%D",""))) or 0
								if Price <= Variables.Money.Value and Price < LowestPrice then
									LowestPrice,ChosenButton = Price,Button
								end
							end
						end
						if ChosenButton and Toucher then
							FireTouchInterest(Toucher,ChosenButton)
						end
						Variables.Debounce = false
					end
				end)
				Variables.RenderStepped = Connect(Service"Run".RenderStepped,function()
					if Variables.Spawn then
						workspace.CurrentCamera.Focus,workspace.CurrentCamera.CFrame = Variables.Spawn.CFrame,Variables.Spawn.CFrame*CFrame.Angles(-math.pi/4,0,0)*CFrame.new(0,0,75)
					end
				end)
				AddConnections{
					Variables.Connection,
					Variables.RenderStepped
				}
			else
				RunCommand"AllowAFK"
				if Character and Backpack then
					for _,Tool in Character:GetChildren() do
						if Valid.Instance(Tool,"Tool") then
							Tool.Parent = Backpack
						end
					end
				end
				Character:PivotTo(Variables.Spawn.CFrame*CFrame.new(0,3.5,0))
				Service"StarterGui":SetCoreGuiEnabled("Backpack",true)
				RemoveConnections{
					Variables.Connection,
					Variables.RenderStepped
				}
			end
		end,
		Toggles = "Unfarm_unautofarm_unautoplay_stopplaying_unautp_stopp_unautof_unf_uaf_uf",
		ToggleCheck = true,
		Variables = {
			Position = workspace.CurrentCamera.Focus,
			Ignored = workspace:WaitForChild"Ignored",
			Tycoons = workspace:WaitForChild"Tycoons",
			HeldFruits = Owner:WaitForChild"HeldFruits",
			OwnedTycoon = Owner:WaitForChild"OwnedTycoon",
			Money = WaitForSequence(Owner,"leaderstats","Money"),
			Prestige = WaitForSequence(Owner,"leaderstats","Prestige"),
			VictoryPart = WaitForSequence(workspace,"ObbyParts","VictoryPart"),
			CollectFruit = Service"ReplicatedStorage":WaitForChild"CollectFruit",
			RequestPrestige = Service"ReplicatedStorage":WaitForChild"RequestPrestige"
		},
		Description = "Automatically collects and sells fruit, buys upgrades, activates frenzy and prestiges"
	}
}