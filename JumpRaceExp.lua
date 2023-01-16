--Created by ParoVchiK
--Experimental Version--
--Could work incorrectly--

--Getting Non Donate Eggs--

local eggs = game.Players.LocalPlayer.PlayerGui.Eggs:GetChildren()
local possible_eggs = {}
for i=1, #(eggs) do --Getting all possible eggs
    if i > 3 then
        local tprace = eggs[i].Frame.EggHatch.Price.TextLabel.Text
        possible_eggs[i-2] = {eggname = eggs[i].Name, price = tprace}
    end
end
local non_donate_eggs = {{eggname = "None", price = 0}}
function SymbToNum(valStr) --Function for getting actual number
    local alph = {"K", "M", "B", "T"}
    local symb = valStr:sub(-1,-1)
    if tonumber(valStr) == nil then
        local numb = valStr:sub(1,-2)
        for i, v in pairs(alph) do
            if v == symb then
                return (numb*(1000^i))
            end
        end
    else
        return valStr
    end
end
--print(SymbToNum("1T"))
for i, v in pairs(possible_eggs) do --Sorting out Non Donate Eggs
    local nVal = tonumber(SymbToNum(v.price))
    if nVal >= 1000 then
        non_donate_eggs[#(non_donate_eggs)+1] = {eggname = v.eggname, price = nVal}
    end
end
table.sort(non_donate_eggs, function (k1, k2) return k1.price < k2.price end ) --Sort by price
--local egg_types = {"None","Starter Egg", "Striped Egg", "Royal Egg", "Space Egg", "Shadow Egg", "Coral Egg", "Atlantis Egg", "Heaven Egg", "Rainbow Egg", "Hell Egg", "Magma Egg"}
--local studs = {0, 10000, 100000, 1000000, 10000000, 50000000, 250000000, 1500000000, 7500000000, 30000000000, 100000000000, 500000000000}
local need_studs_id = 0 --Egg ID that currently farming. If 0 then nothing is farming.
local active_eggs = {}
local egg_types = {}
for i=1, #(non_donate_eggs) do --Another array for Dropdown names
    egg_types[i] = non_donate_eggs[i].eggname
end
for i=1, #(egg_types) do --Adding (isFarming?) bool for every egg
    active_eggs[i] = false
end

--Getting all worlds

local possible_worlds = {}
local wData = game:GetService("Workspace"):GetChildren()
for i, v in pairs(wData) do
    local wDataCheck = v:GetChildren()
    for i1, v1 in pairs(wDataCheck) do --Getting All Worlds
        if v1.Name == "Ground" then
            possible_worlds[#(possible_worlds)+1] = {worldname = v.Name, cfr_pos = v1.CFrame.Position}
            break
        end
    end
end
possible_worlds[#(possible_worlds)+1]=possible_worlds[2] --Swapping Space and Underwater in array for correct display
possible_worlds[2] = possible_worlds[3]
possible_worlds[3] = possible_worlds[#possible_worlds]
table.remove(possible_worlds)

--local worlds = {"Main", "Space", "Underwater", "Heaven", "Underworld"}
--local worlds_position = {game:GetService("Workspace").Earth.Ground.CFrame.Position, game:GetService("Workspace").Space.Ground.CFrame.Position, game:GetService("Workspace").Underwater.Ground.CFrame.Position, game:GetService("Workspace").Heaven.Ground.CFrame.Position, game:GetService("Workspace").Underworld.Ground.CFrame.Position}

--Is function active now?--

local is_active_auto_pets = false
local is_active_auto_rebirth = false

--Getting Possible Upgrades--

local upgrades = game.Players.LocalPlayer.PlayerGui.Upgrades.Upgrades.ScrollingFrame:GetChildren()
local possible_upgrades = {}
for i=1, #(upgrades) do --Getting All Upgrades
    if i > 3 then
        possible_upgrades[i-3] = upgrades[i].Name
    end
end
table.sort(possible_upgrades) --Sorting
--local possible_upgrades = {"Walk Faster", "Pet Storage", "More Studs", "More Jump", "More Gems", "Better Chest Rewards", "Keep Jump On Rebirth", "Pet Storage II", "More Gems II", "Walk Faster II", "Pet Luck II", "More Gems III", "Better Chest Rewards II", "Keep Jump On Rebirth II"}

--Player Info--

local player_studs = game.Players.LocalPlayer.extrastats.Studs.Value
local player_rebirths = game.Players.LocalPlayer.leaderstats.Rebirths.Value
local player_location = nil

--Gui--

local Lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/bloodball/-back-ups-for-libs/main/dirt",true))()
local Table = {}
local eggs_window = Lib:CreateWindow("Main functions")
local location_window = Lib:CreateWindow("TP")
local upgrades_window = Lib:CreateWindow("Upgrades")

--Main Functions(Menu)--

eggs_window:Dropdown("Dropdown",{location = Table,flag = "Dropdown", list = egg_types} ,function()
    for _,bl in pairs(active_eggs) do
        active_eggs[_] = false
    end
   if Table["Dropdown"] == "None" then
   else
    for _,v in pairs(egg_types) do
        if v == Table["Dropdown"] then
            need_studs_id = _
        break
        end
    end
    active_eggs[need_studs_id] = true
    Egg(Table["Dropdown"], non_donate_eggs[need_studs_id].price, need_studs_id)
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

for _, world_name in pairs(possible_worlds) do
    location_window:Button(possible_worlds[_].worldname,function()
        TeleportTo(_,possible_worlds[_].cfr_pos)
     end)
end

--Upgrades--

 for _, upgr in pairs(possible_upgrades) do
    upgrades_window:Button(upgr,function()
        UpgradeFunc(upgr)
     end)
end

--Functions--

function Egg(egg_type, need_studs, egg_id)
    player_studs = game.Players.LocalPlayer.extrastats.Studs.Value
    if player_studs >= need_studs then
        local Event = game:GetService("ReplicatedStorage").Events.HatchPet
        Event:FireServer(egg_type, 1) 
    else
        print("Not Enough Studs")
    end
    while wait(4) do
        if not active_eggs[egg_id] then
            break
        else
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
    local Event = game:GetService("ReplicatedStorage").Events.EquipBestPets
    Event:InvokeServer()
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
    player_studs = game.Players.LocalPlayer.extrastats.Studs.Value
    if player_studs >= ((player_rebirths * 10000000) + 10000000) then
        local Event = game:GetService("ReplicatedStorage").Events.Rebirth
        Event:FireServer()
    else
        print("Not Enough Studs")
    end
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