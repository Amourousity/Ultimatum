local Global,Type,Nil = getgenv and getgenv() or shared,typeof,{}
pcall(Global.Ultimatum)
if not game:IsLoaded() then
	game.Loaded:Wait()
end
local Services = setmetatable({},{__index = function(Services,ServiceName)
	assert(pcall(game.GetService,game,ServiceName),"Invalid ServiceName")
	if not rawget(Services,ServiceName) or rawget(Services,ServiceName) ~= game:GetService(ServiceName) then
		rawset(Services,ServiceName,game:GetService(ServiceName))
	end
	return rawget(Services,ServiceName)
end,__newindex = function()
end,__metatable = "nil"})
local function EscapeTable(Value,Escape)
	if not Escape and Value == Nil then
		return nil
	elseif Escape and Value == nil then
		return Nil
	end
	return Value
end
local Valid
Valid = {String = function(String,Substitute)
	return Type(String) == "string" and String or Type(Substitute) == "string" and Substitute or ""
end,Instance = function(Instance_,ClassName)
	return Type(Instance_) == "Instance" and select(2,pcall(game.IsA,Instance_,Valid.String(ClassName,"Instance"))) == true and Instance_ or nil
end,Number = function(Number,Substitute)
	return tonumber(Number) == tonumber(Number) and tonumber(Number) or tonumber(Substitute) == tonumber(Substitute) and tonumber(Substitute) or 0
end,Table = function(Table,Substitute)
	Table = Type(Table) == "table" and Table or {}
	for Index,Value in pairs(Type(Substitute) == "table" and Substitute or {}) do
		Table[Index] = Type(Table[Index]) == Type(Value) and Table[Index] or Value
	end
	return Table
end}
table.freeze(Valid)
local Random = {String = function(Settings)
	Settings = Valid.Table(Settings,{Length = math.random(5,99),CharacterSet = {NumberRange.new(48,57),NumberRange.new(65,90),NumberRange.new(97,122)},Format = "\0%s"})
	return Settings.Format:format(("A"):rep(Settings.Length):gsub(".",function(Character)
		local Range = Settings.CharacterSet[math.random(1,#Settings.CharacterSet)]
		return string.char(math.random(Range.Min,Range.Max))
	end))
end,Bool = function(Chance)
	return math.random(1,1/Valid.Number(Chance,.5)) == 1
end}
table.freeze(Random)
local function NewInstance(ClassName,Parent,Properties)
	local NewInstance = select(2,pcall(Instance.new,ClassName))
	if Type(ClassName) == "Instance" then
		Properties = Valid.Table(Properties,{Archivable = Random.Bool(),Name = Random.String()})
		for Property,Value in pairs(Properties) do
			pcall(function()
				NewInstance[Property] = EscapeTable(Value)
			end)
		end
		NewInstance.Parent = Type(Parent) == "Instance" and Parent or nil
		return NewInstance
	end
end
local function Create(Data)
	local Instances = {Destroy = function(Instances,Name)
		if Type(Name) == "string" then
			pcall(game.Destroy,Instances[Name])
			Instances[Name] = nil
		else
			for _,Instance_ in pairs(Instances) do
				pcall(game.Destroy,Instance_)
			end
			table.clear(Instances)
		end
	end}
	for _,InstanceData in pairs(Data) do
		Instances[InstanceData.Name] = NewInstance(InstanceData.ClassName,Type(InstanceData.Parent) == "string" and Instances[InstanceData.Parent] or InstanceData.Parent,InstanceData.Properties)
	end
	return Instances
end
local Gui = NewInstance("ScreenGui")
if not is_sirhurt_closure and (syn and syn.protect_gui or protect_gui) then 
	(syn.protect_gui or protect_gui)(Gui)
	Gui.Parent = Services.CoreGui
else
	Gui.Parent = get_hidden_gui and get_hidden_gui() or gethui and gethui() or Services.CoreGui
end
local Connections = {}
function Global.Ultimatum()
	for _,Connection in pairs(Connections) do
		pcall(Connection.Disconnect,Connection)
	end
	Gui:Destroy()
	Global.Ultimatum = nil
end
