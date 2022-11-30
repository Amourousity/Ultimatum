local Notify,RunCommand,AddConnections,RemoveConnections,CreateWindow,FireTouchInterest,Gui,Character,Backpack,PlayerGui = select(3,...)
return {
	Exit_close_leave_shutdown = {
		Function = function()
			game:Shutdown()
		end,
		Description = "Leaves the current Roblox server"
	},
	CopyJoinScript_copyjoincode_copyjoin_copyjcode_copyjscript_copyj_cjoin_copyjs_cj_cjs_cjc = {
		Function = function()
			local JoinScript = ('javascript:Roblox.GameLauncher.joinGameInstance(%d,"%s")'):format(game.PlaceId,game.JobId)
			if setclipboard then
				setclipboard(JoinScript)
				Notify{
					Title = "Successfully Copied",
					Text = "Paste the copied script into your brower's URL bar and press Enter"
				}
			else
				Notify{
					Title = "Copy to Clipboard",
					Text = ("%s\nPaste the above script into your brower's URL bar and press Enter"):format(JoinScript)
				}
			end
		end,
		Description = setclipboard and "Copies JavaScript to your clipboard used to join the same server" or "Notifies JavaScript to be copied to your clipboard used to join the same server"
	},
	EnableRendering_enablerender_erendering_erender_er_rendering_render = {
		Function = function(Enabled)
			Service"Run":Set3dRenderingEnabled(Enabled)
		end,
		Toggles = "disablerendering_disablerender_drendering_derender_drender_dr_norendering_norender",
		Description = "Enables/disables 3D rendering (everything except for GUIs are invisible), boosting FPS. Usually used with auto-farms to improve their efficiency"
	},
	Rejoin_rejoinserver_rejoingame_rej_rj = {
		Function = function()
			if 1 < #Service"Players":GetPlayers() then
				pcall(Service"Teleport".TeleportToPlaceInstance,Service"Teleport",game.PlaceId,game.JobId)
			else
				Owner:Kick()
				RunCommand"CloseRobloxMessage"
				task.delay(2,pcall,Service"Teleport".Teleport,Service"Teleport",game.PlaceId)
			end
		end,
		Description = "Rejoins the current server you're in"
	},
	CloseRobloxMessage_closerobloxerror_closemessage_closeerror_cmessage_cerror_closermessage_closererror_crobloxmessage_crobloxerror_clearrobloxmessage_clearrobloxerror_clearrerror_clearrmessage_clearmessage_clearerror_cm_crm_cre_ce_closekickmessage_clearkickmessage_clearkick_closekick_ckm_ck_closekickerror_clearkickerror_cke = {
		Function = function()
			Service"Gui":ClearError()
		end,
		Description = "Closes any messages/errors (the grey containers with the blurred background) displayed by Roblox"
	},
	WalkSpeed_speed_wspeed_walks_runspeed_rspeed_runs_spoofwalkspeed_spoofspeed_spoofwspeed_spoofwalks_spoofrunspeed_spoofrspeed_spoofruns_swalkspeed_sspeed_swspeed_swalks_srunspeed_srspeed_sruns_fakewalkspeed_fakewspeed_fakewalks_fakerunspeed_fakerspeed_fakeruns_ws_frs_srs = {
		Function = function(Variables,Speed)
			Variables.Speed = Speed
			if not Variables.Enabled then
				if not Character then
					return
				end
				local Humanoid = GetHumanoid(Character,5)
				if not Humanoid then
					return
				end
				Variables.Connection = Connect(Service"Run".Heartbeat,function(Delta)
					if not Character:IsDescendantOf(workspace) or Humanoid:GetState().Name == "Dead" then
						RemoveConnections{Variables.Connection}
						Variables.Enabled,Variables.Connection = false,nil
					end
					if 0 < Humanoid.MoveDirection.Magnitude and table.find({
						"Landed",
						"Jumping",
						"Running",
						"Freefall",
						"Swimming"
					},Humanoid:GetState().Name) then
						Character:TranslateBy(Humanoid.MoveDirection*math.min(Delta,1/15)*(Variables.Speed-Humanoid.WalkSpeed))
					end
				end)
				AddConnections{Variables.Connection}
				Variables.Enabled = true
			end
		end,
		Arguments = {
			{
				Name = "Speed",
				Type = "Number",
				Substitute = 16
			}
		},
		Variables = {},
		Description = "Changes the speed you walk at. Allows negative numbers, but you walk backwards. Your walking animation speed doesn't change"
	},
	Magic8Ball_8ball_magicball_magic8_8b_m8b_m8_8_magiceightball_eightball_meb_mb_eightballpu_eightballpr = {
		Function = function()
			Notify{
				Title = "Magic 8 Ball",
				Text = ({
					"Yes.",
					"Most likely.",
					"Outlook good.",
					"It is certain.",
					"Very doubtful.",
					"My reply is no.",
					"Yes definitely.",
					"Ask again later.",
					"Without a doubt.",
					"As I see it, yes.",
					"Don't count on it.",
					"My sources say no.",
					"Cannot predict now.",
					"It is decidedly so.",
					"Signs point to yes.",
					"You may rely on it.",
					"Outlook not so good.",
					"Reply hazy, try again.",
					"Better not tell you now.",
					"Concentrate and ask again."
				})[math.random(20)]
			}
		end,
		Description = "Notifies the Magic 8 Ball's response to your yes-or-no question"
	},
	ServerHop_serverh_sh_hopserver_hops_hserver_newserver_nserver_ns_news_shop = {
		Function = function()
			Notify{
				Title = "Searching for Servers",
				Text = "You will be teleported shortly..."
			}
			local Page,UnfilteredServers,Servers,Start,ServerCount,ViableServerCount = "",{},{},os.clock(),0,0
			while #Servers < 1 do
				local Success,Result = pcall(game.HttpGet,game,("https://games.roblox.com/v1/games/%s/servers/Public?limit=100%s%s"):format(game.PlaceId,0 < #Page and "&cursor=" or "",Page),true)
				if not Assert(Success,Valid.String(Result,"An unknown error has occurred")) then
					return
				end
				Result = Service"Http":JSONDecode(Result)
				Page,UnfilteredServers = Result.nextPageCursor,Result.data
				Servers = {}
				for _,ServerInfo in UnfilteredServers do
					ServerCount += 1
					if ServerInfo.playing < ServerInfo.maxPlayers and 0 < ServerInfo.playing and ServerInfo.id ~= game.JobId then
						table.insert(Servers,ServerInfo)
						ViableServerCount += 1
					end
				end
				if #UnfilteredServers < 1 or #Servers < 1 and not Valid.String(Page) then
					local Players = Service"Players":GetPlayers()
					table.remove(Players,table.find(Players,Owner))
					Destroy(Players)
					RunCommand"Rejoin"
					return
				end
			end
			local Server = Servers[math.random(#Servers)]
			Notify{
				Title = "Joining Server",
				Text = ("Took %s to search %d servers (%d viable). Server <i>%s</i> has %d/%d players"):format(ConvertTime(os.clock()-Start),ServerCount,ViableServerCount,Server.id,Server.playing,Server.maxPlayers)
			}
			task.delay(2,Service"Teleport".TeleportToPlaceInstance,Service"Teleport",game.PlaceId,Server.id)
		end,
		Description = "Joins a random server that you weren't previously in"
	},
	Invisible_invis_iv = {
		Function = function(Variables)
			if not Variables.Enabled then
				if not Character then
					return
				end
				local Humanoid = GetHumanoid(Character,5)
				if not Humanoid then
					return
				end
				local HumanoidRootPart = Character:FindFirstChild"HumanoidRootPart"
				if not Assert(HumanoidRootPart,"Player does not have a HumanoidRootPart") then
					return
				end
				local R6 = Humanoid.RigType.Name == "R6"
				if not Assert(not R6,"R6 invisibility is not supported yet") then
					return
				end
				local LowerTorso = Character:FindFirstChild"LowerTorso"
				if not Assert(LowerTorso,"Player does not have a LowerTorso") then
					return
				end
				local Root = LowerTorso:FindFirstChild"Root"
				if not Assert(Root,"Player does not have a Root") then
					return
				end
				local OldCFrame,NewRoot = HumanoidRootPart.CFrame,Root:Clone()
				HumanoidRootPart.Parent,Character.PrimaryPart = workspace,HumanoidRootPart
				Character:MoveTo(Vector3.new(OldCFrame.X,9e9,OldCFrame.Z))
				HumanoidRootPart.Parent = Character
				task.delay(.5,function()
					NewRoot.Parent,HumanoidRootPart.CFrame = LowerTorso,OldCFrame
				end)
				Variables.Connection = Connect(Service"Run".RenderStepped,function()
					if not Character:IsDescendantOf(workspace) or Humanoid:GetState().Name == "Dead" then
						RemoveConnections{Variables.Connection}
						Variables.Enabled,Variables.Connection = false,nil
						return
					end
					for _,Object in Character:GetDescendants() do
						if not Object:IsDescendantOf(HumanoidRootPart) then
							for Types,Properties in {
								BasePart_Decal = {LocalTransparencyModifier = 1},
								LayerCollector_Fire_Sparkles_ParticleEmitter = {
									Enabled = false
								},
								Sound = {
									RollOffMaxDistance = 0,
									RollOffMinDistance = 0
								},
								Decal = {Transparency = 1}
							} do
								for _,Type in Types:split"_" do
									if Object:IsA(Type) then
										for Property,Value in Properties do
											pcall(function()
												Object[Property] = Value
											end)
										end
									end
								end
							end
						end
					end
				end)
				AddConnections{Variables.Connection}
				Variables.Enabled = true
			end
		end,
		Variables = {},
		Description = "Makes you invisible to other players (R15 only)"
	},
	AntiAFK_noafk_unafk = {
		Function = function(Variables,Enabled)
			if Enabled then
				Variables.Connection = Connect(Owner.Idled,function()
					Service"VirtualUser":Button2Down(Vector2.zero,CFrame.new())
					task.defer(Service"VirtualUser".Button2Up,Service"VirtualUser",Vector2.zero,CFrame.new())
				end)
				AddConnections{Variables.Connection}
			else
				RemoveConnections{Variables.Connection}
			end
		end,
		Toggles = "unantiafk_allowafk_afk",
		ToggleCheck = true,
		Variables = {},
		Description = "Stops Roblox from disconnecting you for being AFK"
	}
}