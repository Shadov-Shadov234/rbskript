-- ============================================================
-- Blox Fruits NPC Teleporter (Максимально прямой метод)
-- ============================================================

-- Загрузка Rayfield ровно так, как в вашем рабочем тесте
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Дальше идёт наш основной код без изменений
local PlaceId = game.PlaceId
local ТекущееМоре = "Неизвестно"

if PlaceId == 2753915549 then
    ТекущееМоре = "Первое море"
elseif PlaceId == 4442272183 then
    ТекущееМоре = "Второе море"
elseif PlaceId == 7449423635 then
    ТекущееМоре = "Третье море"
else
    Rayfield:Notify({
        Title = "Неверное место";
        Content = "Скрипт работает только в Blox Fruits.";
        Duration = 8;
    })
    return
end
print("[Blox Fruits TP] Определено море: " .. ТекущееМоре)

-- Создание окна
local Окно = Rayfield:CreateWindow({
    Name = "Blox Fruits | Телепорт к NPC",
    LoadingTitle = "Загрузка...",
    LoadingSubtitle = "прямой метод",
    ConfigurationSaving = { Enabled = false },
    KeySystem = false
})

-- Функция поиска NPC
local function НайтиNPC(имяNPC)
    local найденные = {}
    for _, объект in ipairs(workspace:GetDescendants()) do
        if объект:IsA("Model") and объект.Name:lower():find(имяNPC:lower(), 1, true) then
            if объект:FindFirstChild("HumanoidRootPart") then
                table.insert(найденные, объект)
            end
        end
    end
    return найденные
end

-- Функция телепортации
local function Телепортироваться(имяNPC)
    local игрок = game.Players.LocalPlayer
    if not игрок or not игрок.Character or not игрок.Character:FindFirstChild("HumanoidRootPart") then
        Rayfield:Notify({ Title = "Ошибка"; Content = "Персонаж не найден."; Duration = 5 })
        return
    end

    local найденные = НайтиNPC(имяNPC)
    if #найденные == 0 then
        Rayfield:Notify({
            Title = "NPC не найден";
            Content = "«" .. имяNPC .. "» отсутствует в этой зоне или переименован.";
            Duration = 6
        })
        print("[Blox Fruits TP] NPC не найден: " .. имяNPC)
        return
    end

    local цель = найденные[1]
    local позицияNPC
    local ok, err = pcall(function()
        позицияNPC = цель:GetPivot().Position
    end)
    if not ok or not позицияNPC then
        позицияNPC = цель.HumanoidRootPart.Position
    end

    local точка = позицияNPC + Vector3.new(0, 0, 8)

    игрок.Character.HumanoidRootPart.CFrame = CFrame.new(точка)
    Rayfield:Notify({
        Title = "Телепорт выполнен";
        Content = "Вы рядом с «" .. имяNPC .. "».";
        Duration = 4
    })
    print("[Blox Fruits TP] Телепорт к " .. имяNPC .. " выполнен.")
end

-- Создание вкладки
local function СоздатьВкладку(название, список)
    local Вкладка = Окно:CreateTab(название, 4483362458)
    Вкладка:CreateSection("Телепорт к NPC (появитесь рядом)")

    for _, имя in ipairs(список) do
        Вкладка:CreateButton({
            Name = "➡️ " .. имя,
            Callback = function() Телепортироваться(имя) end
        })
    end
end

-- Списки NPC (для примера оставлены основные)
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

if ТекущееМоре == "Первое море" then
    СоздатьВкладку("Первое море", NPC1)
elseif ТекущееМоре == "Второе море" then
    СоздатьВкладку("Второе море", NPC2)
elseif ТекущееМоре == "Третье море" then
    СоздатьВкладку("Третье море", NPC3)
end

Rayfield:Notify({
    Title = "Готово";
    Content = "Телепорт к NPC активен для «" .. ТекущееМоре .. "».";
    Duration = 5
})
print("[Blox Fruits TP] Скрипт полностью загружен.")
