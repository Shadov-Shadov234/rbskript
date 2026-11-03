-- ============================================================
-- Телепорт к NPC в Blox Fruits (Delta Executor)
-- Весь интерфейс на русском языке
-- Телепортация происходит РЯДОМ с NPC, а не внутрь него
-- ============================================================

-- Загрузка интерфейсной библиотеки Rayfield
local success, Rayfield = pcall(function()
    return loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
end)

if not success then
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Ошибка";
        Text = "Не удалось загрузить библиотеку интерфейса.";
        Duration = 5;
    })
    return
end

-- Определяем, в каком море находится игрок
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
        Duration = 5;
    })
    return
end

-- Создаём главное окно
local Окно = Rayfield:CreateWindow({
    Name = "Blox Fruits | Телепорт к NPC",
    LoadingTitle = "Загрузка...",
    LoadingSubtitle = "на русском языке",
    ConfigurationSaving = {
        Enabled = false,
    },
    KeySystem = false
})

-- Функция, которая создаёт вкладку со списком кнопок для NPC
local function СоздатьВкладкуNPC(названиеМоря, списокNPC)
    local Вкладка = Окно:CreateTab(названиеМоря, 4483362458)
    Вкладка:CreateSection("Телепорт к NPC (появитесь рядом с персонажем)")

    for _, имяNPC in ipairs(списокNPC) do
        Вкладка:CreateButton({
            Name = "➡️ " .. имяNPC,
            Callback = function()
                -- Ищем NPC в рабочей области по частичному совпадению имени
                local цель = nil
                for _, объект in ipairs(workspace:GetDescendants()) do
                    if объект:IsA("Model") and объект.Name:lower():find(имяNPC:lower(), 1, true) then
                        if объект:FindFirstChild("HumanoidRootPart") then
                            цель = объект
                            break
                        end
                    end
                end

                if not цель then
                    Rayfield:Notify({
                        Title = "NPC не найден";
                        Content = "Не удалось найти «" .. имяNPC .. "» в текущем море.";
                        Duration = 5
                    })
                    return
                end

                -- Получаем позицию NPC
                local позицияNPC = цель:GetPivot().Position

                -- Смещение: появляемся в 8 стадах от NPC, чтобы не застрять в модели
                local смещение = Vector3.new(0, 0, 8)
                local точкаТелепорта = позицияNPC + смещение

                -- Телепортируем персонажа игрока
                local игрок = game.Players.LocalPlayer
                if игрок and игрок.Character and игрок.Character:FindFirstChild("HumanoidRootPart") then
                    игрок.Character.HumanoidRootPart.CFrame = CFrame.new(точкаТелепорта)
                    Rayfield:Notify({
                        Title = "Телепорт выполнен";
                        Content = "Вы перемещены к «" .. имяNPC .. "».";
                        Duration = 3
                    })
                else
                    Rayfield:Notify({
                        Title = "Ошибка";
                        Content = "Персонаж игрока не найден.";
                        Duration = 5
                    })
                end
            end
        })
    end
end

-- ============================================================
-- СПИСКИ NPC ПО МОРЯМ
-- (имена оставлены на английском, чтобы поиск работал)
-- ============================================================

local NPCПервоеМоре = {
    "Boat Dealer", "Luxury Boat Dealer", "Blox Fruit Dealer", "Weapon Dealer",
    "Home Point", "Santa Claws", "Magic Elf", "Experienced Captain", "Robotmega",
    "Advanced Marine Boat Dealer", "Marine Boat Dealer", "Sword Dealer", "Pirate Recruiter",
    "Bandit Quest Giver", "Marine Recruiter",
    "Quest Giver", "Cousin",
    "Sword Dealer of the West", "Rich Man",
    "Hasan",
    "Sick Man", "Dog House", "Ability Teacher", "Sword Dealer of the East",
    "Parlus", "Advanced Weapon Dealer",
    "Mad Scientist", "Master Sword Dealer", "Yoshi",
    "Remove Blox Fruit", "Military Detective",
    "Living Skeleton",
    "Mayor",
    "Water Kung Fu Teacher",
    "Freezeburg"
}

local NPCВтороеМоре = {
    "Legendary Sword Dealer", "Aura Editor",
    "Chess Board", "Nerd", "Tort", "Cafe Manager", "Customer",
    "Title Specialist", "Awakening Expert", "Colors Specialist",
    "Trevor", "Usoap",
    "Alchemist", "Master of Aura",
    "Rip_indra", "Crew Captain",
    "Martial Arts Master",
    "Mysterious Scientist", "Arithmetic", "Master of Auras",
    "Guashiem", "El Admin", "El Rodolfo", "El Perro", "Exparimic",
    "Phoeyu The Reformed",
    "Daigrock The Sharkman"
}

local NPCТретьеМоре = {
    "Box Fruit Dealer", "Boat Dealer", "Luxury Boat Dealer",
    "Master of Auras", "Crew Captain",
    "Citizen", "Horned Man", "Hungry Man", "Previous Hero", "The Master of Aura",
    "Pirate Recruiter", "Marine Recruiter",
    "Home Point", "Blox Fruit Dealer", "Blox Fruits Gacha", "Bounty Expert",
    "Portal", "Chess Board",
    "Player Hunter", "Elite Hunter", "Tacomura", "Luxury Boar Dealer",
    "Blox Fruit Remover", "Lunoven", "Plokster", "Butler", "Erin",
    "Sabi", "Dark Step Teacher",
    "Death King", "Uzoth", "Gravestone", "Ghost", "Weird Machine",
    "Peanut", "Ice Cream", "Cake", "Chocolate", "Candy Cane",
    "Sick Scientist", "Cake Scientist", "Drip_mama", "Sweet Crafter",
    "Spy", "Beast Hunter", "Shark Hunter", "Shafi",
    "Dragon Talon Sage", "Shipwright Teacher"
}

-- ============================================================
-- СОЗДАНИЕ ВКЛАДКИ ДЛЯ ТЕКУЩЕГО МОРЯ
-- ============================================================

if ТекущееМоре == "Первое море" then
    СоздатьВкладкуNPC("Первое море", NPCПервоеМоре)
elseif ТекущееМоре == "Второе море" then
    СоздатьВкладкуNPC("Второе море", NPCВтороеМоре)
elseif ТекущееМоре == "Третье море" then
    СоздатьВкладкуNPC("Третье море", NPCТретьеМоре)
end

-- Финальное уведомление
Rayfield:Notify({
    Title = "Скрипт загружен";
    Content = "Телепорт к NPC активен для «" .. ТекущееМоре .. "».";
    Duration = 5
})