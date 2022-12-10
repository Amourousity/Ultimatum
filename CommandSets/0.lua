return {
	Close = {
		Function = function()
			--- @diagnostic disable-next-line undefined-global
			pcall(CloseUltimatum)
		end,
		Decription = "Closes Ultimatum (\u{2639})"
	},
	Exit_leave = {
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
					"Yes",
					"Most likely",
					"Outlook good",
					"It is certain",
					"Very doubtful",
					"My reply is no",
					"Yes definitely",
					"Ask again later",
					"Without a doubt",
					"As I see it, yes",
					"Don't count on it",
					"My sources say no",
					"Cannot predict now",
					"It is decidedly so",
					"Signs point to yes",
					"You may rely on it",
					"Outlook not so good",
					"Reply hazy, try again",
					"Better not tell you now",
					"Concentrate and ask again"
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
				if not Success then
					warn(Valid.String(Result,"An unknown error has occurred"))
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
				if not HumanoidRootPart or Humanoid.RigType.Name == "R6" then
					return
				end
				local LowerTorso = Character:FindFirstChild"LowerTorso"
				if not LowerTorso then
					return
				end
				local Root = LowerTorso:FindFirstChild"Root"
				if not Root then
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
		Variables = {},
		Toggles = "unantiafk_allowafk_afk",
		ToggleCheck = true,
		Description = "Stops Roblox from disconnecting you for being AFK"
	},
	FullBrightness_fullbright_bright_fb_nightvision_nightvis_nightv_nvision_nv_fullvision = {
		Function = function(Variables,Enabled)
			if Enabled then
				Variables.Connection = Connect(Service"Run".RenderStepped,function()
					for Name,Value in {
						Brightness = 0,
						FogEnd = math.huge,
						FogStart = math.huge,
						GlobalShadows = false,
						ExposureCompensation = 0,
						EnvironmentDiffuseScale = 0,
						EnvironmentSpecularScale = 0,
						Ambient = Color3.new(1,1,1),
						OutdoorAmbient = Color3.new(1,1,1)
					} do
						Service"Lighting"[Name] = Value
					end
					Variables.Check(Service"Lighting")
					Variables.Check(workspace.CurrentCamera)
				end)
				AddConnections{Variables.Connection}
			else
				RemoveConnections{Variables.Connection}
			end
		end,
		Variables = {
			Check = function(Parent)
				for _,Object in Parent:GetChildren() do
					if Valid.Instance(Object,"PostEffect") then
						Object.Enabled = false
					elseif Object.ClassName == "Atmosphere" then
						Object.Density = 0
					end
				end
			end
		},
		Toggles = "NoBrightness_unfullbrightness_nofullbrightness_nofullbright_unfullbright_unfb_unnightvision_nonightvision_novision_nonightvis_unnightvis_nonightv_unnightv_nonvision_unnvision_unnv_nonv_nov",
		ToggleCheck = true,
		Description = "Removes all lighting effects/properties that can possibly affect your visibility"
	},
	SpoofWalkDirection_antishiftlock_antisl_asl_noshiftlock_nosl_nsl_spoofwd_swd = {
		Function = function(Variables,Enabled)
			if Enabled then
				Variables.Delta,Variables.LastFrame = 0,os.clock()
				Variables.Connection = Connect(Service"Run".Heartbeat,function()
					Variables.Delta,Variables.LastFrame = math.min(os.clock()-Variables.LastFrame,1/15)*60,os.clock()
					if Character then
						local Humanoid = GetHumanoid(Character,.1)
						if 0 < Humanoid.MoveDirection.Magnitude then
							Humanoid.AutoRotate = false
							local Pivot = Character:GetPivot()
							Character:PivotTo(DeltaLerp(Pivot,CFrame.lookAt(Pivot.Position,Pivot.Position+Humanoid.MoveDirection),math.pi/20,Variables.Delta))
						end
					end
				end)
			else
				RemoveConnections{Variables.Connection}
				Variables.Connection = nil
			end
		end,
		Variables = {},
		Toggles = "UnspoofWalkDirection_unspoofwd_allowwd_awd_uwd_unwd",
		ToggleCheck = true,
		Description = "Your character will always face the direction you're walking. Useful for ESP, so that it doesn't look like you're staring at/through walls"
	}
}
