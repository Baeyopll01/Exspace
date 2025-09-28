
local Service = {}
setmetatable(Service, {
    __index = function(_, key)
        local success, result = pcall(function()
            return cloneref(game:GetService(tostring(key)))
        end)
        return success and result or game:GetService(tostring(key))
    end
})

local Players = Service.Players
local LocalPlayer = Players.LocalPlayer
local Workspace = Service.Workspace
local LocalUserId = LocalPlayer.UserId
local HttpService = Service.HttpService
local ReplicatedStorage = Service.ReplicatedStorage
local RunService = Service.RunService
local VirtualUser = Service.VirtualUser
local VirtualInputManager = Service.VirtualInputManager
local UserInputService = Service.UserInputService
local TeleportService = Service.TeleportService
local GuiService = Service.GuiService
local TweenService = Service.TweenService


Config = Config or {}

local Ex_Function = {}

local SavePath = "Honey Piece"
local SaveFile = SavePath .. ".json"

function LoadSettings()
    if not (readfile and writefile and isfile and isfolder) then
        return warn("Executor Not Support Save System")
    end
    if not isfolder("Honey Piece") then makefolder("Honey Piece") end
    if not isfolder(SavePath) then makefolder(SavePath) end
    if not isfile(SaveFile) then
        writefile(SaveFile, HttpService:JSONEncode(Config))
        return
    end
    local success, data = pcall(function()
        return HttpService:JSONDecode(readfile(SaveFile))
    end)
    if success and type(data) == "table" then
        for k, v in next, data do
            Config[k] = v
        end
    end
end

function SaveSettings()
    if not (readfile and writefile and isfile and isfolder) then
        return warn("Executor Not Support Save System")
    end
    local encoded = HttpService:JSONEncode(Config)
    if not isfile(SaveFile) or encoded ~= readfile(SaveFile) then
        writefile(SaveFile, encoded)
    end
end

LoadSettings()

local function AddToggle(where, data)
    local defaultValue = Config[data.Title]
    if defaultValue == nil then
        defaultValue = data.Default or false
        Config[data.Title] = defaultValue
    end
    local toggle = where:AddToggle({
        Title = data.Title,
        Description = data.Desc or "",
        Default = defaultValue,
        Flag = data.Title
    })
    local threadRunning
    toggle:OnChanged(function(state)
        Config[data.Title] = state
        local fn = Ex_Function[data.Title]
        if fn then
            if state then
                threadRunning = task.spawn(fn)
            elseif threadRunning then
                task.cancel(threadRunning)
                threadRunning = nil
            end
        end
        if data.Callback then
            data.Callback(state)
        end
        SaveSettings()
    end)
    if defaultValue then
        local fn = Ex_Function[data.Title]
        if fn then
            threadRunning = task.spawn(fn)
        end
        if data.Callback then
            data.Callback(defaultValue)
        end
    end

    return toggle
end

function AddDropdown(where, data)
    data.Default = Config[data.Title] or (data.Multi and {} or {""})
    local dropdown = where:AddDropdown({
        Title = data.Title,
        Description = data.Desc or "",
        Values = data.Values or {},
        Multi = data.Multi or false,
        Default = data.Default,
        Flag = data.Title
    })
    dropdown:OnChanged(function(value)
        Config[data.Title] = value
        if data.Callback then data.Callback(value) end
        SaveSettings()
    end)
    return dropdown
end

function AddSlider(where, data)
    data.Default = Config[data.Title] or 0
    local slider = where:AddSlider({
        Title = data.Title,
        Description = data.Desc or data.Description or "",
        Min = data.Min or 0,
        Max = data.Max or 100,
        Decimal = data.Decimal or 0,
        Default = data.Default,
        Flags = data.Flags or data.Title
    })
    slider:OnChanged(function(value)
        Config[data.Title] = value
        if data.Callback then data.Callback(value) end
        SaveSettings()
    end)
    return slider
end

function AddTextbox(where, data)
    data.Default = Config[data.Title] or data.Default or ""
    local textbox = where:AddInput({
        Title = data.Title,
        Description = data.Desc or "",
        Placeholder = data.Placeholder or "",
        Default = data.Default,
        Flag = data.Title
    })
    textbox:OnChanged(function(text)
        Config[data.Title] = text
        if data.Callback then data.Callback(text) end
        SaveSettings()
    end)
    return textbox
end

for _, v in next, getconnections(LocalPlayer.Idled) do
    v:Disable()
end

function TP(P)
    local Root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart") 
    if Root then 
        Root.CFrame = P 
    end 
end 

function SendKey(Key)
    VirtualInputManager:SendKeyEvent(true,Key, false, LocalPlayer.Character.HumanoidRootPart)
    VirtualInputManager:SendKeyEvent(false,Key, false, LocalPlayer.Character.HumanoidRootPart)
    wait(0.3)
end 

EquipWeapon = (function(...)
	local Get = {...}
	if Get[1] and Get[1] ~= "" then
		if LocalPlayer.Backpack:FindFirstChild(tostring(Get[1])) then
			local tool = LocalPlayer.Backpack:FindFirstChild(tostring(Get[1]))
			task.wait()
			LocalPlayer.Character.Humanoid:EquipTool(tool)
		end
	end
end)

function ProximityPrompt(Folder)
	pcall(function()
		for i, v in next, Folder:GetDescendants() do
			if (v.ClassName == "ProximityPrompt") then
				fireproximityprompt(v, 30)
			end
		end
	end)
end


local interactduplicated = false

local ClickGui = function(path)
    if interactduplicated then return end
    interactduplicated = true
    xpcall(function()
        if typeof(path) ~= "Instance" or not path:IsA("GuiObject") then
            interactduplicated = false
            return
        end
        repeat
            task.wait()
            GuiService.SelectedObject = path
        until GuiService.SelectedObject == path or not path:IsDescendantOf(game)
        task.wait(0.03)
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
        task.wait(0.01)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
        task.wait(0.01)
        repeat
            task.wait()
            GuiService.SelectedObject = nil
        until GuiService.SelectedObject == nil
        interactduplicated = false
    end, function(err)
        warn("ClickGui Error:", err)
        interactduplicated = false
    end)
end

MonList = {}

for _, folder in next, workspace.Mon_Folder.Mon:GetChildren() do
	if folder:IsA("Folder") then
		for _, v in next, folder:GetChildren() do
			if v:IsA("Model") and v.Name ~= "" then
				if not table.find(MonList, v.Name) then
					table.insert(MonList, v.Name)
				end
			end
		end
	end
end

CodeList = {}
for i, v in next, LocalPlayer.CodesFolder:GetChildren() do
	if v.Name ~= "" then
		if not table.find(CodeList, v.Name) then
			table.insert(CodeList, v.Name)
		end
	end
end

ItemListx = {}
for i, v in next, LocalPlayer.ItemList:GetChildren() do
	if v.Name ~= "" then
		if not table.find(ItemListx, v.Name) then
			table.insert(ItemListx, v.Name)
		end
	end
end


BossListx = {}
for i, v in next, ReplicatedStorage.Mon_Storage.Boss:GetChildren() do
	if v:IsA("Model") and v.Name ~= "" then
		if not table.find(BossListx, v.Name) then
			table.insert(BossListx, v.Name)
		end
	end
end


for i,v in next, CodeList do 
    ReplicatedStorage.RemotesFolder.CodeRedeemed:FireServer(v)
end

Ex_Function["Auto Farm Mon"] = function()
    while Config["Auto Farm Mon"] and task.wait() do 
        pcall(function()
            for _, folder in next, workspace.Mon_Folder.Mon:GetChildren() do
                if folder:IsA("Folder") then
                    for _, v in next, folder:GetChildren() do
                        if table.find(Config["Select Mon"], v.Name) and v.Humanoid.Health > 0 then 
                    TP(v.HumanoidRootPart.CFrame * CFrame.new(0, Config["Distance Farm"], 0) * CFrame.Angles(math.rad(-90), 0, 0))
                        end
                    end
                end 
            end 
        end)
    end
end

Ex_Function["Auto Farm Boss"] = function()
    while Config["Auto Farm Boss"] and task.wait() do 
        pcall(function() 
            for i,v in next, workspace.Mon_Folder.Boss:GetChildren() do 
                if table.find(Config["Select Boss"], v.Name) and v.Humanoid.Health > 0 then 
                    TP(v.HumanoidRootPart.CFrame * CFrame.new(0, Config["Distance Farm"], 0) * CFrame.Angles(math.rad(-90), 0, 0)) 
                end 
            end 
        end) 
    end 
end

Ex_Function["Auto Store Item"] = function()
    while Config["Auto Store Item"] and task.wait() do 
        pcall(function()
            if not LocalPlayer.PlayerGui:FindFirstChild("KeepGui") then
                for i,v in next, LocalPlayer.Backpack:GetChildren() do 
                    if v:IsA("Tool") and table.find(Config["Select Store Item"], v.Name) then 
                        EquipWeapon(v.Name)
                        task.wait(0.20)
                    end 
                end 
            else 
                for i,v in next, LocalPlayer.Character:GetChildren() do 
                    if v:IsA("Tool") and table.find(Config["Select Store Item"], v.Name) then
                        ClickGui(LocalPlayer.PlayerGui.KeepGui.Frame.Store)
                    end 
                end
            end 
        end) 
    end 
end

Ex_Function["Auto Spawn Goku"] = function()
    while Config["Auto Spawn Goku"] and task.wait() do 
        pcall(function()
            if workspace.Mon_Folder.Boss:FindFirstChild("Goku(Mui) [Boss]") then 
                for i,v in next, workspace.Mon_Folder.Boss:GetChildren() do 
                    if v.Name == "Goku(Mui) [Boss]" and v.Humanoid.Health > 0 then 
                        TP(v.HumanoidRootPart.CFrame * CFrame.new(0, Config["Distance Farm"], 0) * CFrame.Angles(math.rad(-90), 0, 0)) 
                    end 
                end 
            else 
                TP(workspace.NPCS["SummonGoku(Mui)"].CFrame)
                task.wait(1)
                ReplicatedStorage.RemotesFolder.TakeoutEvent:FireServer("Meat")
                task.wait(1)
                EquipWeapon("Meat")
                task.wait(1)
                ProximityPrompt(workspace.NPCS["SummonGoku(Mui)"])
                task.wait(1)
            end 
        end) 
    end 
end

Ex_Function["Auto Skill"] = function()
    while Config["Auto Skill"] and task.wait() do 
        pcall(function()
            for i,v in next, Config["Select Skill"] do 
                SendKey(v)
                task.wait(0.1) 
            end 
        end) 
    end 
end

Ex_Function["Automatic Farm Mon / Rock / Join Dungeon"] = function() 
    while Config["Automatic Farm Mon / Rock / Join Dungeon"] and game.PlaceId == 88448392840247 and task.wait() do 
       pcall(function()
            if workspace.NPCS.SummonShadowDungeon.DestroyV.Value ~= 25 and workspace.NPCS.SummonShadowDungeon.Defeat.Value ~= 100 and not workspace.NPCS:FindFirstChild("ShadowDungeon") then 
                for i,v in ipairs(workspace.StonesSpawnPosition.StonesFolder:GetChildren()) do 
                    if v.Name == "Rock" then 
                        TP(v.CFrame * CFrame.new(0,0,5))
                        ProximityPrompt(workspace.StonesSpawnPosition.StonesFolder)
                        task.wait(0.1)
                    end 
                end 
            elseif workspace.NPCS.SummonShadowDungeon.DestroyV.Value == 25 and workspace.NPCS.SummonShadowDungeon.Defeat.Value ~= 100 and not workspace.NPCS:FindFirstChild("ShadowDungeon") then 
                for i,v in next, workspace.Mon_Folder.Mon.AtomicIsland:GetChildren() do 
                    if v:IsA("Model") and v.Humanoid.Health > 0 then 
                        TP(v.HumanoidRootPart.CFrame * CFrame.new(0, Config["Distance Farm"], 0) * CFrame.Angles(math.rad(-90), 0, 0))
                    end 
                end 
            elseif workspace.NPCS:FindFirstChild("ShadowDungeon") then 
                for i,v in next, workspace.NPCS.ShadowDungeon:GetChildren() do 
                    if v.Name == "Main" then 
                        TP(v.CFrame)
                        if workspace.NPCS.ShadowDungeon.Main.PlayerListGui.PlayerListFrame.TeleportTime.Text == "-" then 
                        ProximityPrompt(workspace.NPCS.ShadowDungeon)
                        task.wait(1)
                        end
                    end 
                end
            end 
       end) 
    end 
end

Ex_Function["Automatic Farm Dungeon"] = function() 
    while Config["Automatic Farm Dungeon"] and game.PlaceId == 133991229390546 and task.wait() do 
        pcall(function()
            for i,v in next, workspace.Mon_Folder.Mon:GetChildren() do 
                if v:IsA("Model") and v.Humanoid.Health > 0 then
                    TP(v.HumanoidRootPart.CFrame * CFrame.new(0, Config["Distance Farm"], 0) * CFrame.Angles(math.rad(-90), 0, 0))
                end 
            end 
        end) 
    end 
end 

Ex_Function["Auto Vote Start"] = function()
    while Config["Auto Vote Start"] and game.PlaceId == 133991229390546 and task.wait() do 
        pcall(function()
            if LocalPlayer.PlayerGui:FindFirstChild("VoteStart") then
                ReplicatedStorage.VoteStartEvent:FireServer(true)
                task.wait()
            end
        end) 
    end 
end 

Ex_Function["Auto Replay"] = function()
    while Config["Auto Replay"] and game.PlaceId == 133991229390546 and task.wait() do 
        pcall(function()
            if LocalPlayer.PlayerGui:FindFirstChild("RewardsGui") then
                ReplicatedStorage.ReplayEvent:FireServer()
                task.wait()
            end
        end) 
    end 
end 
            

local Library, ThemeController = loadstring(request({
    Url = "https://raw.githubusercontent.com/Baeyopll01/Xero-Hub/refs/heads/Secret4869/Xero.lua",
    Method = "GET"
}).Body)()

local ScreenGui1 = Instance.new("ScreenGui")
local ImageButton1 = Instance.new("ImageButton")
local UICorner1 = Instance.new("UICorner")

ScreenGui1.Name = "ImageButton"
ScreenGui1.Parent = game.CoreGui
ScreenGui1.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

ImageButton1.Parent = ScreenGui1
ImageButton1.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
ImageButton1.BackgroundTransparency = 0.5
ImageButton1.BorderSizePixel = 0
ImageButton1.AnchorPoint = Vector2.new(0.5, 0)
ImageButton1.Position = UDim2.new(0.5, 0, 0, 10)
ImageButton1.Size = UDim2.new(0, 50, 0, 50)
ImageButton1.Draggable = true
ImageButton1.Image = ""
ImageButton1.MouseButton1Down:Connect(function()
    Library:Toggle()
end)
UICorner1.CornerRadius = UDim.new(1, 0)
UICorner1.Parent = ImageButton1


local Window = Library:Window({
    Title = "Honey Piece",
    SubTitle = "      By.Smooth X Dev",
    TabWidth = 160,
    Size = UDim2.fromOffset(600, 380),
    MinimizeKey = Enum.KeyCode.LeftControl,
    Theme = "Snow",
    ExitCallback = function() end,
    Transparency = 0.85,
    FontFace = Font.new("rbxasset://fonts/families/FredokaOne.json")
})

local Tabs = {
    _Farm = Window:AddTab({Title = "Automatic", Icon = "component"}),
    _Settings = Window:AddTab({Title = "Settings", Icon = "settings"})
}

local  Farm = Tabs._Farm:AddSection({Title = "Mon + Boss + Fully"})

AddSlider(Farm, {
    Title = "Distance Farm",
    Description = "",
    Min = 0,
    Max = 100,
    Decimal = 1,
})

AddDropdown(Farm, {
    Title = "Select Skill",
    Desc = "",
    Values = {"Z","X","C","V"},
    Multi = true
})

AddToggle(Farm, {
    Title = "Auto Skill",
    Desc = "",
})

AddDropdown(Farm, {
    Title = "Select Store Item",
    Desc = "",
    Values = ItemListx,
    Multi = true
})

AddToggle(Farm, {
    Title = "Auto Store Item",
    Desc = "",
})

AddToggle(Farm, {
    Title = "Auto Vote Start",
    Desc = "",
})

AddToggle(Farm, {
    Title = "Auto Replay",
    Desc = "",
})

AddToggle(Farm, {
    Title = "Automatic Farm Mon / Rock / Join Dungeon",
    Desc = "",
})

AddToggle(Farm, {
    Title = "Automatic Farm Dungeon",
    Desc = "",
})

AddDropdown(Farm, {
    Title = "Select Mon",
    Desc = "",
    Values = MonList,
    Multi = true
})

AddToggle(Farm, {
    Title = "Auto Farm Mon",
    Desc = "",
})

AddDropdown(Farm, {
    Title = "Select Boss",
    Desc = "",
    Values = BossListx,
    Multi = true
})

AddToggle(Farm, {
    Title = "Auto Farm Boss",
    Desc = "",
})

AddToggle(Farm, {
    Title = "Auto Spawn Goku",
    Desc = "",
})

local Settings = Tabs._Settings:AddSection({Title = "Theme"})

AddDropdown(Settings, {
    Title = "Theme",
    Desc = "",
    Values = Library.ThemeList,
    Multi = false,
    Callback = function(v)
        ThemeController:SetTheme(v)
    end
})




