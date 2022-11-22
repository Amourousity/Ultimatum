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
				Variables.Connection = Connect(Service"Run".Stepped,function()
					if not Character then
						return
					end
					if not Variables.Debounce then
						Variables.Debounce = true
						if not Valid.Instance(Variables.Tycoon,"Folder") then
							Variables.Tycoon = Owner.RespawnLocation.Parent
							Variables.Rats = Variables.Tycoon:WaitForChild"Rats"
							Variables.Buttons = Variables.Tycoon:WaitForChild"Buttons"
						end
						if not Variables.Wall.CanCollide then
							Variables:MoveTo(Vector3.yAxis*55)
							Wait(.2)
						end
						local Wash = false
						for _,Rat in Variables.Rats:GetChildren() do
							Wash = true
							Variables.CollectRat:FireServer(tonumber(Rat.Name))
						end
						if Wash then
							Variables.SellRats:FireServer()
						end
						local LowestPrice,ChosenButton = math.huge,nil
						for _,Button in Variables.Buttons:GetChildren() do
							if Button:GetAttribute"Enabled" and not Button:GetAttribute"Gamepass" then
								if Button:GetAttribute"Price" <= Variables.Cash.Value and Button:GetAttribute"Price" < LowestPrice then
									LowestPrice,ChosenButton = Button:GetAttribute"Price",Button
								end
							end
						end
						if ChosenButton then
							Variables:MoveTo(ChosenButton:WaitForChild"Hitbox".Position)
							Variables.PurchaseButton:FireServer(ChosenButton.Name)
							Wait(.2)
						end
						Variables.Debounce = false
					end
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
			Cash = WaitForSequence(Owner,"leaderstats","Cash"),
			Rebirth = WaitForSequence(Owner,"leaderstats","Rebirth"),
			Wall = WaitForSequence(workspace,"Obby","Sign","Forcefield","Wall"),
			SellRats = WaitForSequence(Service"ReplicatedStorage","Knit","Services","TycoonService","RE","SellRats"),
			CollectRat = WaitForSequence(Service"ReplicatedStorage","Knit","Services","TycoonService","RE","CollectRat"),
			PurchaseButton = WaitForSequence(Service"ReplicatedStorage","Knit","Services","TycoonService","RE","PurchaseButton"),
			MoveTo = function(_,Position)
				Character:PivotTo(typeof(Position) == "Vector3" and CFrame.new(Position) or Position)
			end
		}
	}
}