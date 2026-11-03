-- ============================================================
-- Blox Fruits Ultimate Hub (Fly + Auto Farm + Auto Respawn)
-- ============================================================

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

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

if PlaceId == 2753915549 then CurrentSea = "First Sea"
elseif PlaceId == 4442272183 then CurrentSea = "Second Sea"
elseif PlaceId == 7449423635 then CurrentSea = "Third Sea"
else SafeNotify("Wrong Place", "This script only works in Blox Fruits.", 8) end

local Window = Rayfield:CreateWindow({
    Name = "Blox Fruits | Ultimate Hub",
    LoadingTitle = "Loading...",
    LoadingSubtitle = "Auto Farm + Respawn",
    ConfigurationSaving = { Enabled = false },
    KeySystem = false
})

-- ============================================================
-- 1. ЛОГИКА СВОБОДНОГО ПОЛЕТА (FREE FLY)
-- ============================================================
local isFlying = false
local flySpeed = 100
local flyConnection = nil
local bodyVelocity = nil
local bodyGyro = nil

local function StopFly()
    isFlying = false
    if flyConnection then flyConnection:Disconnect() flyConnection = nil end
    if bodyVelocity then bodyVelocity:Destroy() bodyVelocity = nil end
    if bodyGyro then bodyGyro:Destroy() bodyGyro = nil end
    local player = Players.LocalPlayer
    if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
    end
end

local function StartFly()
    local player = Players.LocalPlayer
    if not player or not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end
    if isFlying then StopFly() end
    isFlying = true
    local hrp = player.Character.HumanoidRootPart

    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
    bodyVelocity.Velocity = Vector3.zero
    bodyVelocity.Parent = hrp

    bodyGyro = Instance.new("BodyGyro")
    bodyGyro.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
    bodyGyro.P = 1000
    bodyGyro.D = 50
    bodyGyro.Parent = hrp

    flyConnection = RunService.RenderStepped:Connect(function()
        if not isFlying or not hrp or not hrp.Parent then
            if isFlying then StopFly() end
            return
        end
        local cam = workspace.CurrentCamera
        local moveDir = Vector3.zero

        if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - cam.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + cam.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0, 1, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveDir = moveDir - Vector3.new(0, 1, 0) end

        if moveDir.Magnitude > 0 then
            bodyVelocity.Velocity = moveDir.Unit * flySpeed
        else
            bodyVelocity.Velocity = Vector3.zero
        end
        bodyGyro.CFrame = cam.CFrame
    end)
end

local FlyTab = Window:CreateTab("Free Fly", 4483362458)
FlyTab:CreateSection("Flight Controls")
FlyTab:CreateToggle({
    Name = "Enable Fly", CurrentValue = false, Flag = "FlyToggle",
    Callback = function(Value) if Value then StartFly() else StopFly() end end,
})
FlyTab:CreateSlider({
    Name = "Fly Speed", Range = {50, 300}, Increment = 10, Suffix = " studs/s",
    CurrentValue = 100, Flag = "FlySpeedSlider",
    Callback = function(Value) flySpeed = Value end,
})

-- ============================================================
-- 2. AUTO FARM + AUTO RESPAWN + AUTO EQUIP
-- ============================================================
local isFarming = false
local farmConnection = nil
local player = Players.LocalPlayer

-- Функция: Надеть оружие (если пусто)
local function EquipWeapon()
    if not player or not player.Character then return end
    local char = player.Character
    local backpack = player:FindFirstChild("Backpack")
    local humanoid = char:FindFirstChildOfClass("Humanoid")

    if humanoid and backpack then
        -- Если в руках нет оружия, ищем его в рюкзаке
        if not char:FindFirstChildOfClass("Tool") then
            for _, item in pairs(backpack:GetChildren()) do
                if item:IsA("Tool") then
                    humanoid:EquipTool(item)
                    break
                end
            end
        end
    end
end

-- Функция: Сбор предметов (Сундуки и Фрукты)
local function CollectItems()
    if not player or not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end
    for _, obj in ipairs(workspace:GetChildren()) do
        if obj:IsA("Model") and (obj.Name == "Chest" or obj.Name:lower():find("fruit")) then
            local hrp = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("Handle")
            if hrp then
                player.Character.HumanoidRootPart.CFrame = hrp.CFrame
                task.wait(0.3)
            end
        end
    end
end

-- Обработка возрождения персонажа
player.CharacterAdded:Connect(function(newChar)
    -- Ждем загрузки персонажа
    newChar:WaitForChild("HumanoidRootPart", 5)
    task.wait(1)
    if isFarming then
        SafeNotify("Respawn", "Character respawned. Resuming farm...", 3)
        EquipWeapon() -- Сразу надеваем оружие после респавна
    end
end)

-- Таблица прогрессии NPC по уровням
local npcLevels = {
    {min = 1, max = 15, name = "Bandit", quest = "BanditQuest"},
    {min = 15, max = 30, name = "Monkey", quest = "JungleQuest"},
    {min = 30, max = 40, name = "Gorilla", quest = "JungleQuest"},
    {min = 40, max = 60, name = "Pirate", quest = "PirateQuest"},
    {min = 60, max = 75, name = "Brute", quest = "BruteQuest"},
    {min = 75, max = 90, name = "Desert Bandit", quest = "DesertQuest"},
    {min = 90, max = 105, name = "Desert Officer", quest = "DesertQuest"},
    {min = 105, max = 120, name = "Snow Bandit", quest = "SnowQuest"},
    {min = 120, max = 135, name = "Snowman", quest = "SnowQuest"},
    {min = 135, max = 150, name = "Chief Petty Officer", quest = "MarineFortressQuest"},
    {min = 150, max = 200, name = "Sky Bandit", quest = "SkyQuest"},
    {min = 200, max = 225, name = "Dark Master", quest = "SkyQuest"},
    {min = 225, max = 250, name = "Prisoner", quest = "PrisonQuest"},
    {min = 250, max = 275, name = "Dangerous Prisoner", quest = "PrisonQuest"},
    {min = 275, max = 300, name = "Toga Warrior", quest = "ColosseumQuest"},
    {min = 300, max = 325, name = "Gladiator", quest = "ColosseumQuest"},
    {min = 325, max = 350, name = "Military Soldier", quest = "MagmaVillageQuest"},
    {min = 350, max = 400, name = "Fishman Warrior", quest = "FishmanQuest"},
    {min = 400, max = 450, name = "Fishman Commando", quest = "FishmanQuest"},
    {min = 450, max = 475, name = "God's Guard", quest = "SkyExpQuest"},
    {min = 475, max = 500, name = "Shanda", quest = "SkyExpQuest"},
    {min = 500, max = 525, name = "Warden", quest = "ImpelDownQuest"},
    {min = 525, max = 550, name = "Chief Warden", quest = "ImpelDownQuest"},
    {min = 550, max = 600, name = "Swan Pirate", quest = "SwanPirateQuest"},
    {min = 600, max = 650, name = "Factory Staff", quest = "FactoryQuest"},
}

local function GetPlayerLevel()
    local stats = player:FindFirstChild("leaderstats")
    return stats and stats:FindFirstChild("Level") and stats.Level.Value or 1
end

local function GetTargetNPC()
    local myLevel = GetPlayerLevel()
    for _, npcInfo in ipairs(npcLevels) do
        if myLevel >= npcInfo.min and myLevel <= npcInfo.max then
            return npcInfo.name, npcInfo.quest
        end
    end
    return "Bandit", "BanditQuest"
end

local function GetClosestMob(npcName)
    local closestMob, shortestDist = nil, math.huge
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return nil end
    local myPos = player.Character.HumanoidRootPart.Position

    for _, mob in ipairs(workspace:GetChildren()) do
        if mob:IsA("Model") and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
            if mob.Name:lower():find(npcName:lower()) then
                local hrp = mob:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local dist = (hrp.Position - myPos).Magnitude
                    if dist < shortestDist then
                        shortestDist = dist
                        closestMob = mob
                    end
                end
            end
        end
    end
    return closestMob
end

local function ClaimQuest(questName)
    local questNPC = workspace:FindFirstChild(questName)
    if questNPC and questNPC:FindFirstChild("HumanoidRootPart") and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.CFrame = questNPC.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
        task.wait(0.5)
        -- Нажимаем на кнопку "Accept" (в Blox Fruits кнопки называются по-разному, но обычно это просто прокликивание)
        -- Для простоты мы просто телепортируемся, часто квест берется автоматически или через пару секунд.
    end
end

local function StartAutoFarm()
    isFarming = true
    SafeNotify("Auto Farm", "Started! Monitoring for death...", 3)
    
    farmConnection = task.spawn(function()
        while isFarming do
            pcall(function()
                -- Проверка на смерть / отсутствие персонажа
                if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
                    task.wait(2)
                    return
                end
                
                local humanoid = player.Character:FindFirstChild("Humanoid")
                if humanoid and humanoid.Health <= 0 then
                    -- Если мертвы, ждем респавна (скрипт сам подхватит нового персонажа)
                    task.wait(2)
                    return
                end

                -- 1. Надеваем оружие (если пусто)
                EquipWeapon()

                -- 2. Ищем цель
                local targetNPC, targetQuest = GetTargetNPC()
                
                -- 3. Берем квест
                ClaimQuest(targetQuest)
                
                -- 4. Фармим мобов
                local mob = GetClosestMob(targetNPC)
                if mob and mob:FindFirstChild("HumanoidRootPart") then
                    local mobPos = mob.HumanoidRootPart.Position
                    local newPos = mobPos + mob.HumanoidRootPart.CFrame.LookVector * -3
                    player.Character.HumanoidRootPart.CFrame = CFrame.new(newPos)
                    
                    task.wait(0.1)
                    local tool = player.Character:FindFirstChildOfClass("Tool")
                    if tool then
                        tool:Activate()
                    end
                else
                    -- Если мобов нет, собираем сундуки/фрукты
                    CollectItems()
                end
            end)
            task.wait(0.5) -- Пауза между циклами
        end
    end)
end

local function StopAutoFarm()
    isFarming = false
    if farmConnection then
        task.cancel(farmConnection)
        farmConnection = nil
    end
    SafeNotify("Auto Farm", "Stopped.", 3)
end

local FarmTab = Window:CreateTab("Auto Farm", 4483362458)
FarmTab:CreateSection("Level Farming")
FarmTab:CreateToggle({
    Name = "Enable Auto Farm (Auto Equip & Respawn)", 
    CurrentValue = false, 
    Flag = "AutoFarmToggle",
    Callback = function(Value)
        if Value then StartAutoFarm() else StopAutoFarm() end
    end,
})

-- ============================================================
-- 3. ТЕЛЕПОРТ К NPC
-- ============================================================
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

local function TeleportToNPC(npcName)
    if not player or not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end

    local foundNpcs = FindNPC(npcName)
    if #foundNpcs == 0 then
        SafeNotify("NPC Not Found", npcName .. " is not loaded.", 5)
        return
    end

    local targetNpc = foundNpcs[1]
    local targetPos = targetNpc:GetPivot().Position + Vector3.new(0, 0, 8)
    player.Character.HumanoidRootPart.CFrame = CFrame.new(targetPos)
    SafeNotify("Teleported", "You are next to " .. npcName, 3)
end

local function CreateNPCTab(tabName, npcList)
    local Tab = Window:CreateTab(tabName, 4483362458)
    Tab:CreateSection("Instant TP (If Loaded)")
    for _, name in ipairs(npcList) do
        Tab:CreateButton({
            Name = "➡️ " .. name,
            Callback = function() TeleportToNPC(name) end
        })
    end
end

local NPC1 = {
    "Boat Dealer", "Blox Fruit Dealer", "Weapon Dealer", "Home Point", "Sword Dealer",
    "Pirate Recruiter", "Marine Recruiter", "Quest Giver", "Cousin",
    "Sword Dealer of the West", "Rich Man", "Hasan", "Sick Man", "Ability Teacher",
    "Sword Dealer of the East", "Parlus", "Mad Scientist", "Master Sword Dealer",
    "Yoshi", "Remove Blox Fruit", "Living Skeleton", "Mayor", "Water Kung Fu Teacher", "Freezeburg"
}
local NPC2 = {
    "Legendary Sword Dealer", "Aura Editor", "Chess Board", "Nerd", "Tort", "Cafe Manager",
    "Title Specialist", "Awakening Expert", "Trevor", "Alchemist", "Master of Aura",
    "Rip_indra", "Crew Captain", "Martial Arts Master", "Mysterious Scientist", "Arithmetic",
    "Guashiem", "El Admin", "El Rodolfo", "El Perro", "Exparimic", "Phoeyu The Reformed", "Daigrock The Sharkman"
}
local NPC3 = {
    "Box Fruit Dealer", "Boat Dealer", "Master of Auras", "Crew Captain", "Citizen", "Horned Man",
    "Hungry Man", "Previous Hero", "Pirate Recruiter", "Marine Recruiter", "Home Point",
    "Blox Fruit Dealer", "Bounty Expert", "Portal", "Player Hunter", "Elite Hunter", "Tacomura",
    "Blox Fruit Remover", "Lunoven", "Plokster", "Butler", "Erin", "Death King", "Uzoth",
    "Gravestone", "Ghost", "Weird Machine", "Peanut", "Ice Cream", "Cake", "Chocolate",
    "Candy Cane", "Sick Scientist", "Cake Scientist", "Drip_mama", "Sweet Crafter", "Spy",
    "Beast Hunter", "Shark Hunter", "Shafi", "Dragon Talon Sage"
}

if CurrentSea == "First Sea" then
    CreateNPCTab("First Sea NPCs", NPC1)
elseif CurrentSea == "Second Sea" then
    CreateNPCTab("Second Sea NPCs", NPC2)
elseif CurrentSea == "Third Sea" then
    CreateNPCTab("Third Sea NPCs", NPC3)
end

SafeNotify("Script Loaded", "Ultimate Hub Ready. Auto Farm + Respawn active.", 5)
