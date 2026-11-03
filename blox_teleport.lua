-- ============================================================
-- Blox Fruits NPC Teleporter (Fixed Variables)
-- ============================================================

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

if not Rayfield then
    warn("[Blox Fruits TP] Ошибка: Rayfield не загрузился.")
    return
end

local PlaceId = game.PlaceId
local CurrentSea = "Неизвестно"

if PlaceId == 2753915549 then
    CurrentSea = "Первое море"
elseif PlaceId == 4442272183 then
    CurrentSea = "Второе море"
elseif PlaceId == 7449423635 then
    CurrentSea = "Третье море"
else
    Rayfield:Notify({
        Title = "Неверное место";
        Content = "Скрипт работает только в Blox Fruits.";
        Duration = 8;
    })
    return
end
print("[Blox Fruits TP] Определено море: " .. CurrentSea)

local Window = Rayfield:CreateWindow({
    Name = "Blox Fruits | Телепорт к NPC",
    LoadingTitle = "Загрузка...",
    LoadingSubtitle = "финальная версия",
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
        Rayfield:Notify({ Title = "Ошибка"; Content = "Ваш персонаж не найден."; Duration = 5 })
        return
    end

    local foundNpcs = FindNPC(npcName)
    if #foundNpcs == 0 then
        Rayfield:Notify({
            Title = "NPC не найден";
            Content = "«" .. npcName .. "» отсутствует в этой зоне.";
            Duration = 6
        })
        print("[Blox Fruits TP] NPC не найден: " .. npcName)
        return
    end

    local targetNpc = foundNpcs[1]
    local npcPos = targetNpc:GetPivot().Position
    local targetPos = npcPos + Vector3.new(0, 0, 8)

    player.Character.HumanoidRootPart.CFrame = CFrame.new(targetPos)
    
    Rayfield:Notify({
        Title = "Телепорт выполнен";
        Content = "Вы перемещены к «" .. npcName .. "».";
        Duration = 4
    })
    print("[Blox Fruits TP] Телепорт к " .. npcName .. " выполнен.")
end

local function CreateNPCTab(tabName, npcList)
    local Tab = Window:CreateTab(tabName, 4483362458)
    Tab:CreateSection("Телепорт к NPC (рядом с персонажем)")

    for _, name in ipairs(npcList) do
        Tab:CreateButton({
            Name = "➡️ " .. name,
            Callback = function() TeleportTo(name) end
        })
    end
end

-- Списки NPC
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

if CurrentSea == "Первое море" then
    CreateNPCTab("Первое море", NPC1)
elseif CurrentSea == "Второе море" then
    CreateNPCTab("Второе море", NPC2)
elseif CurrentSea == "Третье море" then
    CreateNPCTab("Третье море", NPC3)
end

Rayfield:Notify({
    Title = "Скрипт загружен";
    Content = "Телепорт к NPC активен для «" .. CurrentSea .. "».";
    Duration = 5
})
print("[Blox Fruits TP] Скрипт успешно запущен.")