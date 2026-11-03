-- ============================================================
-- Blox Fruits NPC Teleporter (Fully English Version)
-- ============================================================

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

if not Rayfield then
    warn("[Blox Fruits TP] Error: Rayfield failed to load.")
    return
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
    Rayfield:Notify({
        Title = "Wrong Place",
        Content = "This script only works in Blox Fruits.",
        Duration = 8
    })
    return
end

print("[Blox Fruits TP] Detected Sea: " .. CurrentSea)

local Window = Rayfield:CreateWindow({
    Name = "Blox Fruits | NPC Teleporter",
    LoadingTitle = "Loading...",
    LoadingSubtitle = "by AI Assistant",
    ConfigurationSaving = { Enabled = false },
    KeySystem = false
})

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

local function TeleportTo(npcName)
    local player = game.Players.LocalPlayer
    if not player or not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
        Rayfield:Notify({ Title = "Error", Content = "Player character not found.", Duration = 5 })
        return
    end

    local foundNpcs = FindNPC(npcName)
    if #foundNpcs == 0 then
        Rayfield:Notify({
            Title = "NPC Not Found",
            Content = npcName .. " is not in this zone or has been renamed.",
            Duration = 6
        })
        print("[Blox Fruits TP] NPC Not Found: " .. npcName)
        return
    end

    local targetNpc = foundNpcs[1]
    local npcPos = targetNpc:GetPivot().Position
    -- Offset by 8 studs to avoid spawning inside the NPC
    local targetPos = npcPos + Vector3.new(0, 0, 8)

    player.Character.HumanoidRootPart.CFrame = CFrame.new(targetPos)
    
    Rayfield:Notify({
        Title = "Teleported",
        Content = "You are now next to " .. npcName,
        Duration = 4
    })
    print("[Blox Fruits TP] Teleported to " .. npcName)
end

local function CreateNPCTab(tabName, npcList)
    local Tab = Window:CreateTab(tabName, 4483362458)
    Tab:CreateSection("Teleport to NPC (Next to them)")

    for _, name in ipairs(npcList) do
        Tab:CreateButton({
            Name = "➡️ " .. name,
            Callback = function() TeleportTo(name) end
        })
    end
end

-- NPC Lists
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
    CreateNPCTab("First Sea", NPC1)
elseif CurrentSea == "Second Sea" then
    CreateNPCTab("Second Sea", NPC2)
elseif CurrentSea == "Third Sea" then
    CreateNPCTab("Third Sea", NPC3)
end

Rayfield:Notify({
    Title = "Script Loaded",
    Content = "NPC Teleporter is active for " .. CurrentSea,
    Duration = 5
})
print("[Blox Fruits TP] Script loaded successfully.")