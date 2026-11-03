-- ============================================================
-- Blox Fruits NPC Teleporter (с телепортом по островам)
-- ============================================================

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

if not Rayfield then
    warn("[Blox Fruits TP] Error: Rayfield failed to load.")
    return
end

local function SafeNotify(title, text, duration)
    print("[" .. title .. "] " .. text)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = title,
            Text = text,
            Duration = duration or 5
        })
    end)
end

local PlaceId = game.PlaceId
local CurrentSea = "Unknown"

if PlaceId == 2753915549 then
    CurrentSea = "First Sea"
elseif PlaceId == 4442272183 then
    CurrentSea = "Second Sea"
elseif PlaceId == 7449423635 then
    CurrentSea = "Third Sea"
else
    SafeNotify("Wrong Place", "This script only works in Blox Fruits.", 8)
end

local Window = Rayfield:CreateWindow({
    Name = "Blox Fruits | NPC Teleporter",
    LoadingTitle = "Loading...",
    LoadingSubtitle = "by AI Assistant",
    ConfigurationSaving = { Enabled = false },
    KeySystem = false
})

-- ФУНКЦИЯ ТЕЛЕПОРТА НА КООРДИНАТЫ (для островов)
local function TeleportToCoords(pos)
    local player = game.Players.LocalPlayer
    if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.CFrame = CFrame.new(pos)
        return true
    end
    return false
end

-- ФУНКЦИЯ ПОИСКА NPC
local function FindNPC(npcName)
    local foundNpcs = {}
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and obj.Name:lower():find(npcName:lower(), 1, true) then
            if obj:FindFirstChild("HumanoidRootPart") then
                table.insert(foundNpcs, obj)
            end
        end
    end
    return foundNpcs
end

-- ФУНКЦИЯ ТЕЛЕПОРТА К NPC
local function TeleportTo(npcName)
    local player = game.Players.LocalPlayer
    if not player or not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
        SafeNotify("Error", "Player character not found.", 5)
        return
    end

    local foundNpcs = FindNPC(npcName)
    if #foundNpcs == 0 then
        SafeNotify("NPC Not Found", npcName .. " is not loaded. Teleport to its Island first!", 6)
        return
    end

    local targetNpc = foundNpcs[1]
    local npcPos = targetNpc:GetPivot().Position
    local targetPos = npcPos + Vector3.new(0, 0, 8)

    player.Character.HumanoidRootPart.CFrame = CFrame.new(targetPos)
    SafeNotify("Teleported", "You are now next to " .. npcName, 4)
end

-- ============================================================
-- 1. ВКЛАДКА С ОСТРОВАМИ (Чтобы NPC прогружались)
-- ============================================================
if CurrentSea == "First Sea" then
    local IslandTab = Window:CreateTab("Islands (Click First)", 4483362458)
    IslandTab:CreateSection("Teleport to Island first, wait 2s, then click NPC")
    
    local islands = {
        ["Starter Island"] = Vector3.new(0, 15, 0),
        ["Marine Fortress"] = Vector3.new(-1000, 15, -400),
        ["Middle Town"] = Vector3.new(-200, 15, 800),
        ["Jungle"] = Vector3.new(-1400, 15, 100),
        ["Pirate Village"] = Vector3.new(-500, 15, 1500),
        ["Desert"] = Vector3.new(100, 15, 2000),
        ["Frozen Village"] = Vector3.new(-1000, 15, 2000),
        ["Skylands"] = Vector3.new(-1500, 500, 1500),
        ["Prison"] = Vector3.new(5000, 15, 1000),
        ["Colosseum"] = Vector3.new(-1500, 15, 200),
        ["Magma Village"] = Vector3.new(-5000, 15, 1000),
        ["Underwater City"] = Vector3.new(-4000, -200, 1000),
        ["Fountain City"] = Vector3.new(9000, 200, 3000)
    }

    for iName, iPos in pairs(islands) do
        IslandTab:CreateButton({
            Name = "🏝️ " .. iName,
            Callback = function()
                if TeleportToCoords(iPos) then
                    SafeNotify("Teleported", "Arrived at " .. iName, 4)
                end
            end
        })
    end
end

-- ============================================================
-- 2. ВКЛАДКА С NPC
-- ============================================================
local function CreateNPCTab(tabName, npcList)
    local Tab = Window:CreateTab(tabName, 4483362458)
    Tab:CreateSection("Teleport to NPC")

    for _, name in ipairs(npcList) do
        Tab:CreateButton({
            Name = "➡️ " .. name,
            Callback = function() TeleportTo(name) end
        })
    end
end

local NPC1 = {
    "Boat Dealer", "Blox Fruit Dealer", "Weapon Dealer", "Home Point",
    "Sword Dealer", "Pirate Recruiter", "Marine Recruiter",
    "Quest Giver", "Cousin", "Sword Dealer of the West", "Rich Man",
    "Hasan", "Sick Man", "Ability Teacher", "Sword Dealer of the East",
    "Parlus", "Advanced Weapon Dealer", "Mad Scientist", "Master Sword Dealer",
    "Yoshi", "Remove Blox Fruit", "Military Detective", "Living Skeleton",
    "Mayor", "Water Kung Fu Teacher", "Freezeburg"
}

local NPC2 = {
    "Legendary Sword Dealer", "Aura Editor", "Chess Board", "Nerd", "Tort",
    "Cafe Manager", "Title Specialist", "Awakening Expert", "Trevor",
    "Alchemist", "Master of Aura", "Rip_indra", "Crew Captain",
    "Martial Arts Master", "Mysterious Scientist", "Arithmetic",
    "Guashiem", "El Admin", "El Rodolfo", "El Perro", "Exparimic",
    "Phoeyu The Reformed", "Daigrock The Sharkman"
}

local NPC3 = {
    "Box Fruit Dealer", "Boat Dealer", "Master of Auras", "Crew Captain",
    "Citizen", "Horned Man", "Hungry Man", "Previous Hero",
    "Pirate Recruiter", "Marine Recruiter", "Home Point", "Blox Fruit Dealer",
    "Bounty Expert", "Portal", "Player Hunter", "Elite Hunter", "Tacomura",
    "Blox Fruit Remover", "Lunoven", "Plokster", "Butler", "Erin",
    "Death King", "Uzoth", "Gravestone", "Ghost", "Weird Machine",
    "Peanut", "Ice Cream", "Cake", "Chocolate", "Candy Cane",
    "Sick Scientist", "Cake Scientist", "Drip_mama", "Sweet Crafter",
    "Spy", "Beast Hunter", "Shark Hunter", "Shafi",
    "Dragon Talon Sage", "Shipwright Teacher"
}

if CurrentSea == "First Sea" then
    CreateNPCTab("First Sea NPCs", NPC1)
elseif CurrentSea == "Second Sea" then
    CreateNPCTab("Second Sea NPCs", NPC2)
elseif CurrentSea == "Third Sea" then
    CreateNPCTab("Third Sea NPCs", NPC3)
end

SafeNotify("Script Loaded", "Use the Islands tab first!", 5)
