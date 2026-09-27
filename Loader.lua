-- Veyra Hub v2 - Loader.lua
-- Anti double-execution UNIQUE (ne bloque pas les autres scripts)
if _G.VeyraHub_AntiDoubleExec_9f3k2m7x then
    return
end
_G.VeyraHub_AntiDoubleExec_9f3k2m7x = true

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Configuration
local Admins = {
    ["DragonTalon11111111"] = true,
    ["GachaGuyyy"] = true,
    ["RIPINDRA"] = true,
    ["KingofRedHair2"] = true,
    ["Wenlocktoad"] = true,
    ["rip_fud"] = true,
    ["0krvs"] = true,
    ["Krossful"] = true,
    ["baconbungz"] = true
}

-- Variables
local HubEnabled = false
local HubVisible = true
local dragging = false
local dragInput, dragStart, startPos

-- Création de l'écran
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "VeyraHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 300, 0, 190)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -95)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
MainFrame.BackgroundTransparency = 0.1
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Parent = ScreenGui

-- Arrondir les coins
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

-- Ombre
local Shadow = Instance.new("UIStroke")
Shadow.Color = Color3.fromRGB(147, 0, 255)
Shadow.Thickness = 2
Shadow.Transparency = 0.3
Shadow.Parent = MainFrame

-- Barre de titre
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
TitleBar.BackgroundTransparency = 0.2
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 12)
TitleCorner.Parent = TitleBar

-- Titre avec police stylée (GothamBlack)
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 1, 0)
Title.BackgroundTransparency = 1
Title.Text = "Veyra Hub"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 20
Title.Font = Enum.Font.GothamBlack
Title.Parent = TitleBar

-- Bouton toggle (AGGRANDI)
local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "ToggleButton"
ToggleButton.Size = UDim2.new(0, 140, 0, 50)
ToggleButton.Position = UDim2.new(0.5, -70, 0, 55)
ToggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
ToggleButton.BackgroundTransparency = 0.2
ToggleButton.BorderSizePixel = 0
ToggleButton.Text = "OFF"
ToggleButton.TextColor3 = Color3.fromRGB(255, 80, 80)
ToggleButton.TextSize = 18
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.Parent = MainFrame

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 10)
ToggleCorner.Parent = ToggleButton

-- Texte statut (EN ANGLAIS)
local StatusText = Instance.new("TextLabel")
StatusText.Size = UDim2.new(1, 0, 0, 30)
StatusText.Position = UDim2.new(0, 0, 0, 120)
StatusText.BackgroundTransparency = 1
StatusText.Text = "Status: Disabled"
StatusText.TextColor3 = Color3.fromRGB(200, 200, 200)
StatusText.TextSize = 14
StatusText.Font = Enum.Font.Gotham
StatusText.Parent = MainFrame

-- Fonction de drag
local function updateDrag(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

TitleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        updateDrag(input)
    end
end)

-- Fonction pour vérifier les admins
local function CheckAdmins()
    for _, player in ipairs(Players:GetPlayers()) do
        if Admins[player.Name] then
            LocalPlayer:Kick("Admin detected! Disconnecting...")
            return
        end
    end
end

-- Fonction pour activer/désactiver le hub
local function ToggleHub()
    HubEnabled = not HubEnabled
    
    if HubEnabled then
        ToggleButton.Text = "ON"
        ToggleButton.TextColor3 = Color3.fromRGB(80, 255, 80)
        StatusText.Text = "Status: Enabled"
        CheckAdmins()
        
        -- Boucle de vérification
        RunService.Heartbeat:Connect(function()
            if HubEnabled then
                CheckAdmins()
            end
        end)
    else
        ToggleButton.Text = "OFF"
        ToggleButton.TextColor3 = Color3.fromRGB(255, 80, 80)
        StatusText.Text = "Status: Disabled"
    end
end

-- Bouton toggle
ToggleButton.MouseButton1Click:Connect(ToggleHub)

-- Raccourci H
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.H then
        HubVisible = not HubVisible
        MainFrame.Visible = HubVisible
    end
end)

-- Notification (EN BLANC)
local Notification = Instance.new("TextLabel")
Notification.Size = UDim2.new(0, 200, 0, 40)
Notification.Position = UDim2.new(0.5, -100, 0.1, 0)
Notification.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
Notification.BackgroundTransparency = 0.3
Notification.BorderSizePixel = 0
Notification.Text = "Veyra Hub Loaded!"
Notification.TextColor3 = Color3.fromRGB(255, 255, 255) -- BLANC
Notification.TextSize = 14
Notification.Font = Enum.Font.GothamBold
Notification.Visible = true
Notification.Parent = ScreenGui

local NotificationCorner = Instance.new("UICorner")
NotificationCorner.CornerRadius = UDim.new(0, 8)
NotificationCorner.Parent = Notification

-- Animation de notification
task.wait(3)
TweenService:Create(Notification, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 1, TextTransparency = 1}):Play()
task.wait(1)
Notification:Destroy()
