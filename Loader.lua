-- =============================================
-- [ VEYRA HUB ] – INTERFACE MODERNE & TRANSPARENTE
-- =============================================
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")

-- ===== VARIABLES =====
local protectionActive = false
local adminList = {
    ["DragonTalon11111111"] = true,
    ["GachaGuyyy"] = true,
    ["RIPINDRA"] = true,
    ["KingofRedHair2"] = true,
    ["Wenlocktoad"] = true,
    ["rip_fud"] = true,
    ["0krvs"] = true,
    ["Krossful"] = true,
    ["baconbungz"] = true,
}

-- ===== FONCTION POUR QUITTER LE SERVEUR =====
local function LeaveServer()
    if protectionActive then
        print("[VEYRA HUB] 🚨 ADMIN DÉTECTÉ - DÉCONNEXION...")
        -- Option 1: Kick via TeleportService (rejoint un serveur privé)
        pcall(function()
            TeleportService:TeleportToPrivateServer(game.PlaceId, 0, {})
        end)
        
        -- Option 2: Quitter complètement (si le téléport échoue)
        wait(0.5)
        game:Shutdown()
    end
end

-- ===== DÉTECTION DES ADMINS =====
local function CheckForAdmins()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= Player then
            local isAdmin = false
            
            -- Vérifie si le joueur a des permissions admin
            if player:IsInGroup(1) then -- Roblox Admin Group
                isAdmin = true
            end
            
            -- Vérifie si le joueur est dans la liste des admins connus
            if adminList[player.Name] then
                isAdmin = true
            end
            
            if isAdmin and protectionActive then
                print("[VEYRA HUB] ⚠️ Admin détecté: " .. player.Name)
                print("[VEYRA HUB] 🚨 ADMIN DÉTECTÉ - DÉCONNEXION IMMÉDIATE!")
                LeaveServer()
                return
            elseif isAdmin then
                print("[VEYRA HUB] ⚠️ Admin détecté: " .. player.Name)
            end
        end
    end
end

-- ===== PANNEAU GUI =====
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "VeyraHub_GUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = Player:WaitForChild("PlayerGui")

-- ===== FOND DU PANNEAU =====
local MainFrame = Instance.new("Frame")
MainFrame.Name = "VeyraHub_Frame"
MainFrame.Size = UDim2.new(0, 220, 0, 100)
MainFrame.Position = UDim2.new(0.5, -110, 0.5, -50)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
MainFrame.BackgroundTransparency = 0.2
MainFrame.BorderSizePixel = 0
MainFrame.Active = true

-- Arrondir les coins
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

-- Bordure violette
local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(170, 0, 255)
UIStroke.Transparency = 0.5
UIStroke.Thickness = 1
UIStroke.Parent = MainFrame

MainFrame.Parent = ScreenGui

-- ===== TITRE =====
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "VeyraHub_Title"
TitleLabel.Size = UDim2.new(1, 0, 0, 25)
TitleLabel.Position = UDim2.new(0, 0, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "✦ VEYRA HUB ✦"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 16
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextTransparency = 0.1
TitleLabel.Parent = MainFrame

-- ===== LIGNE SÉPARATRICE =====
local Separator = Instance.new("Frame")
Separator.Name = "Separator"
Separator.Size = UDim2.new(0.9, 0, 0, 1)
Separator.Position = UDim2.new(0.05, 0, 0.3, 0)
Separator.BackgroundColor3 = Color3.fromRGB(170, 0, 255)
Separator.BackgroundTransparency = 0.3
Separator.BorderSizePixel = 0
Separator.Parent = MainFrame

-- ===== BOUTON UNIQUE ON/OFF =====
local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "VeyraHub_Toggle"
ToggleButton.Size = UDim2.new(0.7, 0, 0.4, 0)
ToggleButton.Position = UDim2.new(0.15, 0, 0.45, 0)
ToggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
ToggleButton.BackgroundTransparency = 0.3
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.Text = "OFF"
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.TextSize = 14
ToggleButton.AutoButtonColor = false
ToggleButton.Parent = MainFrame

-- Arrondir les coins du bouton
local ButtonCorner = Instance.new("UICorner")
ButtonCorner.CornerRadius = UDim.new(0, 8)
ButtonCorner.Parent = ToggleButton

-- Bordure du bouton
local ButtonStroke = Instance.new("UIStroke")
ButtonStroke.Color = Color3.fromRGB(255, 255, 255)
ButtonStroke.Transparency = 0.8
ButtonStroke.Thickness = 1
ButtonStroke.Parent = ToggleButton

-- ===== EFFET CLIGNOTANT =====
local ToggleState = false
local ToggleHighlight = Instance.new("Highlight")
ToggleHighlight.Name = "VeyraHub_Highlight"
ToggleHighlight.FillColor = Color3.fromRGB(170, 0, 255)
ToggleHighlight.FillTransparency = 0.6
ToggleHighlight.OutlineTransparency = 1
ToggleHighlight.Parent = ToggleButton

-- ===== LOGIQUE DU BOUTON UNIQUE =====
local function ToggleFunction()
    ToggleState = not ToggleState
    protectionActive = ToggleState

    if ToggleState then
        ToggleButton.Text = "ON"
        ToggleHighlight.Enabled = true
        ToggleButton.BackgroundColor3 = Color3.fromRGB(170, 0, 255)
        ToggleButton.BackgroundTransparency = 0.2
        print("[VEYRA HUB] – ACTIVÉ (Auto-Quit si Admin)")
    else
        ToggleButton.Text = "OFF"
        ToggleHighlight.Enabled = false
        ToggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
        ToggleButton.BackgroundTransparency = 0.3
        print("[VEYRA HUB] – DÉSACTIVÉ (Auto-Quit OFF)")
    end
end
ToggleButton.MouseButton1Click:Connect(ToggleFunction)

-- ===== DÉPLACEMENT DU PANNEAU =====
local dragging = false
local dragInput
local dragStart
local startPos

local function update(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
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

MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 and dragging then
        dragging = false
    end
end)

-- ===== RACCOURCI H =====
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.H then
        ScreenGui.Enabled = not ScreenGui.Enabled
    end
end)

-- ===== DÉTECTION DES JOUEURS QUI REJOIGNENT =====
Players.PlayerAdded:Connect(function(player)
    if player ~= Player then
        print("[VEYRA HUB] 👤 Joueur rejoint: " .. player.Name)
        CheckForAdmins()
    end
end)

-- ===== VÉRIFICATION PÉRIODIQUE DES ADMINS =====
spawn(function()
    while wait(5) do
        CheckForAdmins()
    end
end)

-- ===== FIN DU SCRIPT (VEYRA HUB) =====
