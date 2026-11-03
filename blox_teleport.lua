-- ============================================================
-- Blox Fruits NPC Teleporter (Universal Notify Fix)
-- ============================================================

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

if not Rayfield then
    warn("[Blox Fruits TP] Ошибка: Rayfield не загрузился.")
    return
end

-- Универсальная функция уведомлений (решает ошибку Description/Content)
local function ShowNotify(title, text, duration)
    local success = pcall(function()
        Rayfield:Notify({
            Title = title,
            Content = text, -- Стандартное поле
            Duration = duration or 5,
        })
    end)
    
    if not success then
        -- Если не сработало, пробуем поле Description
        pcall(function()
            Rayfield:Notify({
                Title = title,
                Description = text, 
                Duration = duration or 5,
            })
        end)
    end
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
    ShowNotify("Неверное место", "Скрипт работает только в Blox Fruits.", 8)
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
        ShowNotify("Ошибка", "Ваш персонаж не найден.", 5)
        return
    end

    local foundNpcs = FindNPC(npcName)
    if #foundNpcs == 0 then
        ShowNotify("NPC не найден", "«" .. npcName .. "» отсутствует в этой зоне.", 6)
        print("[Blox Fruits TP] NPC не найден: " .. npcName)
        return
    end

    local targetNpc = foundNpcs[1]
    local npcPos = targetNpc:GetPivot().Position
    local targetPos = npcPos + Vector3.new(0, 0, 8)

    player.Character.HumanoidRootPart.CFrame = CFrame.new(targetPos)
    
    ShowNotify("Телепорт выполнен", "Вы перемещены к «" .. npcName .. "».", 4)
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

ShowNotify("Скрипт загружен", "Телепорт к NPC активен для «" .. CurrentSea .. "».", 5)
print("[Blox Fruits TP] Скрипт успешно запущен.")
