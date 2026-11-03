-- ============================================================
-- Blox Fruits Free Fly & NPC Teleporter
-- ============================================================

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

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
    Name = "Blox Fruits | Fly & Teleport",
    LoadingTitle = "Loading...",
    LoadingSubtitle = "Free Fly Update",
    ConfigurationSaving = { Enabled = false },
    KeySystem = false
})

-- ============================================================
-- ЛОГИКА СВОБОДНОГО ПОЛЕТА
-- ============================================================
local isFlying = false
local flySpeed = 100
local flyConnection = nil
local bodyVelocity = nil
local bodyGyro = nil

local function StopFly()
    isFlying = false
    if flyConnection then flyConnection:Disconnect() end
    if bodyVelocity then bodyVelocity:Destroy() end
    if bodyGyro then bodyGyro:Destroy() end
    
    local player = game.Players.LocalPlayer
    if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
    end
    SafeNotify("Fly", "Flight Disabled", 3)
end

local function StartFly()
    local player = game.Players.LocalPlayer
    if not player or not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
        SafeNotify("Error", "Character not found.", 3)
        return
    end

    isFlying = true
    local hrp = player.Character.HumanoidRootPart

    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.Name = "FlyBV"
    bodyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
    bodyVelocity.Velocity = Vector3.zero
    bodyVelocity.Parent = hrp

    bodyGyro = Instance.new("BodyGyro")
    bodyGyro.Name = "FlyBG"
    bodyGyro.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
    bodyGyro.P = 1000
    bodyGyro.D = 50
    bodyGyro.Parent = hrp

    flyConnection = RunService.RenderStepped:Connect(function()
        if not isFlying then return end
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
    SafeNotify("Fly", "Flight Enabled! (WASD to move, Space/Shift for up/down)", 5)
end

-- Вкладка настроек полета
local FlyTab = Window:CreateTab("Free Fly", 4483362458)
FlyTab:CreateSection("Flight Controls")

FlyTab:CreateToggle({
    Name = "Enable Fly",
    CurrentValue = false,
    Flag = "FlyToggle",
    Callback = function(Value)
        if Value then StartFly() else StopFly() end
    end,
})

FlyTab:CreateSlider({
    Name = "Fly Speed",
    Range = [50, 300],
    Increment = 10,
    Suffix = " studs/s",
    CurrentValue = 100,
    Flag = "FlySpeedSlider",
    Callback = function(Value)
        flySpeed = Value
    end,
})

-- ============================================================
-- ТЕЛЕПОРТ К NPC (ОСТАВЛЯЕМ ДЛЯ УДОБСТВА)
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
    local player = game.Players.LocalPlayer
    if not player or not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end

    local foundNpcs = FindNPC(npcName)
    if #foundNpcs == 0 then
        SafeNotify("NPC Not Found", npcName .. " is not loaded. Use Free Fly to find it!", 5)
        return
    end

    local targetNpc = foundNpcs[1]
    local targetPos = targetNpc:GetPivot().Position + Vector3.new(0, 0, 8)
    player.Character.HumanoidRootPart.CFrame = CFrame.new(targetPos)
    SafeNotify("Teleported", "You are next to " .. npcName, 3)
end

local function CreateNPCTab(tabName, npcList)
    local Tab = Window:CreateTab(tabName, 4483362458)
    Tab:CreateSection("Instant TP to NPC (If Loaded)")

    for _, name in ipairs(npcList) do
        Tab:CreateButton({
            Name = "➡️ " .. name,
            Callback = function() TeleportToNPC(name) end
        })
    end
end

-- Списки NPC
local NPC1 = {
    "Boat Dealer", "Blox Fruit Dealer", "Weapon Dealer", "Home Point",
    "Sword Dealer", "Pirate Recruiter", "Marine Recruiter", "Quest Giver",
    "Cousin", "Sword Dealer of the West", "Rich Man", "Hasan", "Sick Man",
    "Ability Teacher", "Sword Dealer of the East", "Parlus", "Mad Scientist",
    "Master Sword Dealer", "Yoshi", "Remove Blox Fruit", "Living Skeleton",
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
    "Spy", "Beast Hunter", "Shark Hunter", "Shafi", "Dragon Talon Sage"
}

if CurrentSea == "First Sea" then
    CreateNPCTab("First Sea NPCs", NPC1)
elseif CurrentSea == "Second Sea" then
    CreateNPCTab("Second Sea NPCs", NPC2)
elseif CurrentSea == "Third Sea" then
    CreateNPCTab("Third Sea NPCs", NPC3)
end

SafeNotify("Script Loaded", "Free Fly mode is ready.", 5)
