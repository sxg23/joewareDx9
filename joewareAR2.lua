local Workspace = dx9.FindFirstChildOfClass(dx9.GetDatamodel(), "Workspace")
local Map = dx9.FindFirstChild(Workspace, "Map")
local Corpses = dx9.FindFirstChild(Workspace, "Corpses")
local Characters = dx9.FindFirstChild(Workspace, "Characters")
local Vehicles = dx9.FindFirstChild(Workspace, "Vehicles")
local Players = dx9.FindFirstChildOfClass(dx9.GetDatamodel(), "Players")
local LocalPlayer = dx9.get_localplayer()
local LocalCharacter = dx9.GetCharacter(dx9.FindFirstChild(dx9.FindFirstChildOfClass(dx9.GetDatamodel(), "Players"), dx9.get_localplayer().Info.Name))
local Mouse = dx9.GetMouse()
local Looktarget = dx9.GetTarget()

--// Library
local Lib = loadstring(dx9.Get("https://raw.githubusercontent.com/soupg/DXLibUI/main/main.lua"))()

--// Making UI
local Window = Lib:CreateWindow({Title = "joeware | AR2", Size = {500,500}, Resizable = true, ToggleKey = "[F2]", AccentColor = {100, 55, 255}, OutlineColor = {100, 100, 255}, FooterRGB = false, FooterMouseCoords = false })

--/ Tabs
local Tab1 = Window:AddTab("player esp")
local Tab2 = Window:AddTab("zombie esp")
local Tab3 = Window:AddTab("misc")

--// FirstRun
if Lib.FirstRun then
    Tab1:Focus()
end

--/ Groupboxes
local Groupbox1 = Tab1:AddLeftGroupbox("vehicle esp")
local Groupbox2 = Tab1:AddRightGroupbox("player esp")
local Groupbox3 = Tab2:AddLeftGroupbox("zombie esp") 
local Groupbox4 = Tab3:AddLeftGroupbox("aimbot settings")
local Groupbox5 = Tab3:AddRightGroupbox("server info")

local aimbot_range = Groupbox4:AddSlider({Default = 2000, Text = "aimbot range", Min = 0, Max = 3000}):OnChanged(function(value)
    if value then dx9.SetAimbotValue("range", value) end
end)

local aimbot_fov = Groupbox4:AddSlider({Default = 120, Text = "fov size", Min = 0, Max = 300}):OnChanged(function(value)
    if value then dx9.SetAimbotValue("fov", value) end
end)

--// Player ESP Tab
local vehicle_esp = Groupbox1:AddToggle({Default = false, Text = "vehicle esp"}):OnChanged(function(value)
    if value then Lib:Notify("Vehicle ESP Enabled", 1) else Lib:Notify("Vehicle ESP Disabled", 1) end
end)

local vehicle_dist_limit = Groupbox1:AddSlider({Default = 1000, Text = "vehicle esp range", Min = 0, Max = 4000}).Value

local held_esp = Groupbox2:AddToggle({Default = true, Text = "held item esp"}):OnChanged(function(value)
    if value then Lib:Notify("held item ESP Enabled", 1) else Lib:Notify("held item ESP Disabled", 1) end
end)

local corpse_esp = Groupbox2:AddToggle({Default = false, Text = "corpse esp"}):OnChanged(function(value)
    if value then Lib:Notify("Corpse ESP Enabled", 1) else Lib:Notify("Corpse ESP Disabled", 1) end
end)

local corpse_dist_limit = Groupbox2:AddSlider({Default = 1000, Text = "corpse esp range", Min = 0, Max = 4000}).Value

--// Zombie ESP Tab

local zombie_esp = Groupbox3:AddToggle({Default = false, Text = "zombie esp"}):OnChanged(function(value)
    if value then Lib:Notify("Zombie ESP Enabled", 1) else Lib:Notify("Zombie ESP Disabled", 1) end
end)

local random_event_esp = Groupbox3:AddToggle({Default = false, Text = "random event esp"}):OnChanged(function(value)
    if value then Lib:Notify("random event esp enabled", 1) else Lib:Notify("random event esp disabled", 1) end
end)

zombie_esp:AddTooltip("fps destroyer")

local zombie_dist_limit = Groupbox3:AddSlider({Default = 100, Text = "zombie esp range", Min = 0, Max = 175}).Value

--// Misc Tab

local function GetCharacterCount()
    local chars = dx9.FindFirstChild(Workspace, "Characters") or Characters
    if not chars then return 0 end
    local count = 0
    for _, _ in next, dx9.GetChildren(chars) do
        count = count + 1
    end
    return count
end

Groupbox5:AddLabel("players spawned: "..GetCharacterCount().."", {255,255,255})

--// Funcs
function DistFromPlr(v)
    local v1 = LocalPlayer.Position
    local v2 = dx9.GetPosition(v)
    local a = (v1.x-v2.x)*(v1.x-v2.x)
    local b = (v1.y-v2.y)*(v1.y-v2.y)
    local c = (v1.z-v2.z)*(v1.z-v2.z)
    return math.floor(math.sqrt(a+b+c)+0.5)
end

--// Vehicle ESP
for _, p in next, dx9.GetChildren(dx9.FindFirstChild(Workspace, "Vehicles")) do

    if vehicle_esp.Value then
        for _, v in next, dx9.GetChildren(p) do
            local root = dx9.FindFirstChild(p, "Base")
            local pos = dx9.GetPosition(root)
            local dist = math.floor(DistFromPlr(root) / 3.5714285714286)
            local name = dx9.GetName(p)
            
            if dist < vehicle_dist_limit then 
                local wts = dx9.WorldToScreen({pos.x, pos.y, pos.z})

                if dx9.GetName(v) == "Base" and vehicle_esp.Value then
                    name = dx9.GetName(p)
                    color = {156, 156, 156}
                end

                if wts.x > 0 and wts.y > 0 and dx9.GetName(v) == "Base" and vehicle_esp.Value then
                    dx9.DrawCircle({wts.x, wts.y}, {0,0,0}, 3)
                    dx9.DrawCircle({wts.x, wts.y}, color, 1)
                    dx9.DrawString({wts.x + 5, wts.y - 13}, color, name.."\n["..dist.."m]")
                end
            end
        end
    end
end

--// Corpse Esp
for _, p in next, dx9.GetChildren(dx9.FindFirstChild(Workspace, "Corpses")) do
    if corpse_esp.Value then
        for _, v in next, dx9.GetChildren(p) do
            local root = dx9.FindFirstChild(p, "HumanoidRootPart")
            if not root then return end
            local pos = dx9.GetPosition(root)
            local dist = math.floor(DistFromPlr(root) / 3.5714285714286)
            local name = dx9.GetName(p) or ""
            local ignore = (string.match(name, "^(%S+)") or ""):lower()

            if dist < corpse_dist_limit then 
                local wts = dx9.WorldToScreen({pos.x, pos.y, pos.z})

                if dx9.GetName(v) == "HumanoidRootPart" and ignore ~= "infected" and corpse_esp.Value then
                    local color = {255, 0, 0}
                    if wts.x > 0 and wts.y > 0 then
                        dx9.DrawCircle({wts.x, wts.y}, {0,0,0}, 3)
                        dx9.DrawCircle({wts.x, wts.y}, color, 1)
                        dx9.DrawString({wts.x + 5, wts.y - 13}, color, name.."\n["..dist.."m]")
                    end
                end
            end
        end
    end
end

--// Zombie Esp
for _, p in next, dx9.GetChildren(dx9.FindFirstChild(Workspace, "Zombies")) do

    if zombie_esp.Value then
        for _, v in next, dx9.GetChildren(p) do
            local root = dx9.FindFirstChild(p, "HumanoidRootPart")
            local pos = dx9.GetPosition(root)
            local dist = math.floor(DistFromPlr(root) / 3.5714285714286)
            local name = dx9.GetName(p)
            local ignore = (string.match(name, "^(%S+)") or ""):lower()
            
            if dist < zombie_dist_limit then 
                local wts = dx9.WorldToScreen({pos.x, pos.y, pos.z})

                if dx9.GetName(v) == "HumanoidRootPart" and zombie_esp.Value then
                    name = dx9.GetName(p)
                    color = {255, 0, 0}
                end

                if wts.x > 0 and wts.y > 0 and dx9.GetName(v) == "HumanoidRootPart" and ignore == "unique" and zombie_esp.Value then
                    dx9.DrawCircle({wts.x, wts.y}, {0,0,0}, 3)
                    dx9.DrawCircle({wts.x, wts.y}, color, 1)
                    dx9.DrawString({wts.x + 5, wts.y - 13}, color, name.."\n["..dist.."m]")
                end
            end
        end
    end
end

--// Held Esp
for _, p in next, dx9.GetChildren(dx9.FindFirstChild(Workspace, "Characters")) do
    if held_esp.Value then
        local equipped = dx9.FindFirstChild(p, "Equipped")
        if equipped then
            local root = dx9.FindFirstChild(p, "HumanoidRootPart")
            if root then
                local pos = dx9.GetPosition(root)
                local dist = DistFromPlr(root)
                if dist < 1000 and dist > 5 then
                    local wts = dx9.WorldToScreen({pos.x, pos.y, pos.z})
                    if wts and wts.x > 0 and wts.y > 0 then
                        for _, item in next, dx9.GetChildren(equipped) do
                            local itemName = dx9.GetName(item) or "Unknown"
                            local color = {0, 255, 0}
                            dx9.DrawString({wts.x, wts.y}, color, "* " ..itemName.. " *")
                        end
                    end
                end
            end
        end
    end
end

--// Event ESP
for _, p in next, dx9.GetChildren(dx9.FindFirstChild(Map, "Elements")) do
    if random_event_esp.Value then
        local crashNames = {"SeahawkCrashsite01", "SpecialForcesCrash01", "RandomCrashCessna01", "CrashPrisonBus01"}
        for _, cname in next, crashNames do
            local crash = dx9.FindFirstChild(p, cname)
            if crash then
                local root = dx9.FindFirstChild(crash, "Base")
                if root then
                    local pos = dx9.GetPosition(root)
                    local dist = math.floor(DistFromPlr(root) / 3.5714285714286)
                    local name = dx9.GetName(p)

                    if dist < 10000 then 
                        local wts = dx9.WorldToScreen({pos.x, pos.y, pos.z})
                        if wts and wts.x > 0 and wts.y > 0 then
                            local color = {255, 255, 0}
                            dx9.DrawCircle({wts.x, wts.y}, {0,0,0}, 3)
                            dx9.DrawCircle({wts.x, wts.y}, color, 1)
                            dx9.DrawString({wts.x + 5, wts.y - 13}, color, name.."\n["..dist.."m]")
                        end
                    end
                end
            end
        end
    end
end
