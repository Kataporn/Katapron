setfpscap(240)
local Fluent = loadstring(game:HttpGet("https://raw.githubusercontent.com/Kataporn/Kataporn/refs/heads/main/NasumiTrash.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Nasumi Hub" .. Fluent.Version,
    SubTitle = "by v4",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true, -- The blur may be detectable, setting this to false disables blur entirely
    Theme = "Sapphire",
    MinimizeKey = Enum.KeyCode.LeftControl -- Used when theres no MinimizeKeybind
})

--Fluent provides Lucide Icons https://lucide.dev/icons/ for the tabs, icons are optional
local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

local Options = Fluent.Options

do
    Fluent:Notify({
        Title = "Notification",
        Content = "This is a notification",
        SubContent = "SubContent", -- Optional
        Duration = 5 -- Set to nil to make the notification not disappear
    })


    Tabs.Main:AddParagraph({
        Title = "Tween To PTP",
        Content = ""
    })


-- Tween --
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character, rootPart, humanoid

local selectedPlayerName = nil -- เก็บค่าชื่อของผู้เล่นที่เลือก
local isTweenEnabled = false -- เก็บสถานะของ Toggle
local followConnection -- เก็บการเชื่อมต่อของ RunService

-- เพิ่มตัวแปรสำหรับเก็บค่า offset
local xOffset, yOffset, zOffset = 0, 0, 0

-- ฟังก์ชันสำหรับอัปเดตตัวละครและ rootPart
local function updateCharacterReferences()
    character = player.Character or player.CharacterAdded:Wait()
    rootPart = character:WaitForChild("HumanoidRootPart")
    humanoid = character:WaitForChild("Humanoid")
end

-- เรียกใช้ฟังก์ชันครั้งแรก
updateCharacterReferences()

-- ติดตามเมื่อตัวละครเกิดใหม่
player.CharacterAdded:Connect(function()
    updateCharacterReferences()
    if isTweenEnabled and selectedPlayerName then
        startFollowing(selectedPlayerName)
    end
end)

-- สร้าง Dropdown สำหรับเลือกผู้เล่น
local Dropdown = Tabs.Main:AddDropdown("Dropdown", {
    Title = "Select Player",
    Values = {},
    Multi = false,
    Default = nil,
})

-- สร้าง Toggle สำหรับเปิด/ปิด Tween
local Toggle = Tabs.Main:AddToggle("MyToggle", {Title = "Enable Follow", Default = false})

-- ฟังก์ชันอัปเดตรายชื่อผู้เล่นใน Dropdown
local function updateDropdown()
    local playerList = {}
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= player then
            table.insert(playerList, plr.Name)
        end
    end
    Dropdown:SetValues(playerList)
end

-- อัปเดต Dropdown เมื่อมีผู้เล่นเข้า/ออก
Players.PlayerAdded:Connect(updateDropdown)
Players.PlayerRemoving:Connect(updateDropdown)
updateDropdown()

-- ฟังก์ชันเริ่มติดตามเป้าหมาย
local function startFollowing(targetPlayerName)
    if followConnection then followConnection:Disconnect() end

    followConnection = RunService.Heartbeat:Connect(function()
        if not character or not rootPart or not humanoid then return end

        local targetPlayer = Players:FindFirstChild(targetPlayerName)
        if targetPlayer and targetPlayer.Character then
            local targetRoot = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
            if targetRoot then
                local targetPosition = targetRoot.Position + Vector3.new(xOffset, yOffset, zOffset)
                local currentPosition = rootPart.Position
                
                local newPosition = Vector3.new(
                    currentPosition.X + (targetPosition.X - currentPosition.X) * 0.1,
                    targetPosition.Y,
                    currentPosition.Z + (targetPosition.Z - currentPosition.Z) * 0.1
                )
                
                rootPart.CFrame = CFrame.new(newPosition)
                rootPart.Velocity = Vector3.new(0, 0, 0)
                rootPart.CanCollide = false

                local lookAt = CFrame.new(rootPart.Position, Vector3.new(targetRoot.Position.X, rootPart.Position.Y, targetRoot.Position.Z))
                rootPart.CFrame = CFrame.new(rootPart.Position, lookAt.LookVector + rootPart.Position)
            end
        end
    end)
end

-- ฟังก์ชันหยุดติดตาม
local function stopFollowing()
    if followConnection then
        followConnection:Disconnect()
        followConnection = nil
    end
    if rootPart then
        rootPart.CanCollide = true
    end
end

-- เมื่อเลือกชื่อใน Dropdown
Dropdown:OnChanged(function(value)
    selectedPlayerName = value
    print("Selected player:", selectedPlayerName)

    if isTweenEnabled then
        startFollowing(selectedPlayerName)
    end
end)

-- เมื่อ Toggle ถูกเปิด/ปิด
Toggle:OnChanged(function(value)
    isTweenEnabled = value

    if value then
        if selectedPlayerName then
            print("Following:", selectedPlayerName)
            startFollowing(selectedPlayerName)
        else
            print("Please select a player first!")
            Toggle:SetValue(false)
        end
    else
        stopFollowing()
        print("Stopped following!")
    end
end)


-- Addons:
-- SaveManager (Allows you to have a configuration system)
-- InterfaceManager (Allows you to have a interface managment system)

-- Hand the library over to our managers
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)

-- Ignore keys that are used by ThemeManager.
-- (we dont want configs to save themes, do we?)
SaveManager:IgnoreThemeSettings()

-- You can add indexes of elements the save manager should ignore
SaveManager:SetIgnoreIndexes({})

-- use case for doing it this way:
-- a script hub could have themes in a global folder
-- and game configs in a separate folder per game
InterfaceManager:SetFolder("FluentScriptHub")
SaveManager:SetFolder("FluentScriptHub/specific-game")

InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)


Window:SelectTab(1)

Fluent:Notify({
    Title = "Fluent",
    Content = "The script has been loaded.",
    Duration = 8
})

-- You can use the SaveManager:LoadAutoloadConfig() to load a config
-- which has been marked to be one that auto loads!
SaveManager:LoadAutoloadConfig()
end
