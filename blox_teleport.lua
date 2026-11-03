-- ============================================================
-- Blox Fruits NPC Teleporter (Финальная версия для GitHub)
-- Телепортация к NPC с безопасным смещением
-- ============================================================

-- Загрузка интерфейса Rayfield
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

if not Rayfield then
    warn("[Blox Fruits TP] Ошибка: Rayfield не загрузился.")
    return
end

-- Определение текущего моря
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

-- Создание главного окна
local Окно = Rayfield:CreateWindow({
    Name = "Blox Fruits | Телепорт к NPC",
    LoadingTitle = "Загрузка...",
    LoadingSubtitle = "финальная версия",
    ConfigurationSaving = { Enabled = false },
    KeySystem = false
})

-- Функция поиска NPC (ищет модель с HumanoidRootPart)
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
        Rayfield:Notify({ Title = "Ошибка"; Content = "Ваш персонаж не найден (возможно, вы мертвы)."; Duration = 5 })
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

    -- Берем первый найденный объект
    local цель = найденные[1]
    local позицияNPC = цель:GetPivot().Position

    -- Смещение: 8 стадов по оси Z, чтобы не заспавниться внутри NPC
    local точка = позицияNPC + Vector3.new(0, 0, 8)

    -- Выполняем телепорт
    игрок.Character.HumanoidRootPart.CFrame = CFrame.new(точка)
    
    Rayfield:Notify({
        Title = "Телепорт выполнен";
        Content = "Вы перемещены к «" .. имяNPC .. "».";
        Duration = 4
    })
    print("[Blox Fruits TP] Телепорт к " .. имяNPC .. " выполнен.")
end

-- Функция создания вкладки
local function СоздатьВкладку(название, список)
    local Вкладка = Окно:CreateTab(название, 4483362458)
    Вкладка:CreateSection("Телепорт к NPC (рядом с персонажем)")

    for _, имя in ipairs(список) do
        Вкладка:CreateButton({
            Name = "➡️ " .. имя,
            Callback = function() Телепортироваться(имя) end
        })
    end
end

-- ============================================================
-- СПИСКИ NPC
-- ============================================================

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

-- Создание вкладки для текущего моря
if ТекущееМоре == "Первое море" then
    СоздатьВкладку("Первое море", NPC1)
elseif ТекущееМоре == "Второе море" then
    СоздатьВкладку("Второе море", NPC2)
elseif ТекущееМоре == "Третье море" then
    СоздатьВкладку("Третье море", NPC3)
end

-- Уведомление об успешной загрузке
Rayfield:Notify({
    Title = "Скрипт загружен";
    Content = "Телепорт к NPC активен для «" .. ТекущееМоре .. "».";
    Duration = 5
})
print("[Blox Fruits TP] Скрипт успешно запущен через GitHub.")