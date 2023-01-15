local active_eggs = {false, false, false, false, false, false}
local is_active_auto_pets = false
local is_active_auto_rebirth = false
local egg_types = {"None","Starter Egg", "Striped Egg", "Royal Egg", "Space Egg", "Shadow Egg", "Coral Egg", "Atlantis Egg", "Heaven Egg", "Rainbow Egg", "Hell Egg", "Magma Egg"}
local possible_upgrades = {"Walk Faster", "Pet Storage", "More Studs", "More Jump", "More Gems", "Better Chest Rewards", "Keep Jump On Rebirth", "Pet Storage II", "More Gems II", "Walk Faster II", "Pet Luck II", "More Gems III", "Better Chest Rewards II", "Keep Jump On Rebirth II"}
local worlds = {"Main", "Space", "Underwater", "Heaven", "Underworld"}
local worlds_position = {game:GetService("Workspace").Earth.Ground.CFrame.Position, game:GetService("Workspace").Space.Ground.CFrame.Position, game:GetService("Workspace").Underwater.Ground.CFrame.Position, game:GetService("Workspace").Heaven.Ground.CFrame.Position, game:GetService("Workspace").Underworld.Ground.CFrame.Position}
local studs = {0, 10000, 100000, 1000000, 10000000, 50000000, 250000000, 1500000000, 7500000000, 30000000000, 100000000000, 500000000000}
local need_studs_id = 0
local player_studs = game.Players.LocalPlayer.extrastats.Studs.Value
local player_rebirths = game.Players.LocalPlayer.leaderstats.Rebirths.Value
local player_location = nil
local Lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/bloodball/-back-ups-for-libs/main/dirt",true))()
local Table = {}
local eggs_window = Lib:CreateWindow("Main functions")
local location_window = Lib:CreateWindow("TP")
local upgrades_window = Lib:CreateWindow("Upgrades")

--Main Functions(Menu)--

eggs_window:Dropdown("Dropdown",{location = Table,flag = "Dropdown", list = {"None","Starter Egg", "Striped Egg", "Royal Egg", "Space Egg", "Shadow Egg", "Coral Egg", "Atlantis Egg", "Heaven Egg", "Rainbow Egg", "Hell Egg", "Magma Egg"}} ,function()
    for _,bl in pairs(active_eggs) do
        active_eggs[_] = false
    end
   if Table["Dropdown"] == "None" then
    print("None")
   else
    for _,v in pairs(egg_types) do
        if v == Table["Dropdown"] then
            need_studs_id = _
        break
        end
    end
    active_eggs[need_studs_id] = true
    Egg(Table["Dropdown"], studs[need_studs_id], need_studs_id)
   end
end)

eggs_window:Toggle("Auto Best Pets",{location = Table, flag = "Toggle"},function()
    is_active_auto_pets = Table["Toggle"]
    AutoBestPets()
end)
eggs_window:Toggle("Auto Rebirth",{location = Table, flag = "Toggle"},function()
    is_active_auto_rebirth = Table["Toggle"]
    AutoRebirth()
end)

--Teleportation--

for _, world_name in pairs(worlds) do
    location_window:Button(world_name,function()
        TeleportTo(_, worlds_position[_])
     end)
end

--Upgrades--

 for _, upgr in pairs(possible_upgrades) do
    upgrades_window:Button(upgr,function()
        UpgradeFunc(upgr)
     end)
end

upgrades_window:Button("Upgrade All One Time",function()
    for _, upgr in pairs(possible_upgrades) do
        UpgradeFunc(upgr)
    end
 end)
--Functions--

function Egg(egg_type, need_studs, egg_id)
    while wait(4) do
        if not active_eggs[egg_id] then
            print("break")
            break
        else
            print(egg_id)
            print(active_eggs[egg_id])
            player_studs = game.Players.LocalPlayer.extrastats.Studs.Value
            if player_studs >= need_studs then
                local Event = game:GetService("ReplicatedStorage").Events.HatchPet
                Event:FireServer(egg_type, 1) 
            else
                print("Not Enough Studs")
            end
        end
     end
end

function AutoBestPets()
    while wait(10) do
        if not is_active_auto_pets then
            break
        else
            local Event = game:GetService("ReplicatedStorage").Events.EquipBestPets
            Event:InvokeServer()
        end
    end
end

function AutoRebirth()
    while wait(10) do
        if not is_active_auto_rebirth then
            break
        else
            player_studs = game.Players.LocalPlayer.extrastats.Studs.Value
            if player_studs >= ((player_rebirths * 10000000) + 10000000) then
                local Event = game:GetService("ReplicatedStorage").Events.Rebirth
                Event:FireServer()
            else
                print("Not Enough Studs")
            end
        end
    end
end

function TeleportTo(_id, _cfr)
    player_location = game.Players.LocalPlayer.Character
    player_location:MoveTo(_cfr)
    local Event = game:GetService("ReplicatedStorage").Events.UpdateWorld
    Event:FireServer(_id)
end

function UpgradeFunc(_name)
    local Event = game:GetService("ReplicatedStorage").Events.BuyUpgrade
    Event:FireServer(_name)
end
