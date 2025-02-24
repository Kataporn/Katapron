setfpscap(360)
local Fluent = loadstring(game:HttpGet("https://raw.githubusercontent.com/Kataporn/Kataporn/refs/heads/main/biezel.z.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Biezel.z" .. Fluent.Version,
    SubTitle = "by my self ",
    TabWidth = 120,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true, 
    Theme = "AMOLED",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Main = Window:AddTab({ Title = "Start Farm", Icon = "House" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

local Options = Fluent.Options

do
    Fluent:Notify({
        Title = "Biezel.z Hub",
        Content = "biezel.z loaded",
        SubContent = "Welcome!",
        Duration = 5
    })
    
    Tabs.Main:AddParagraph({
        Title = "การปรับความเร็วในการเดิน",
        Content = ""
    })

    local function updateWalkSpeed(player, value)
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.WalkSpeed = math.clamp(value, 0, 200)
            print(string.format("%s's ความเร็วในการเดินเปลี่ยนเป็น: %d", player.Name, value))
        end
    end

    local function updateJumpPower(player, value)
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.JumpPower = math.clamp(value, 0, 200)
            print(string.format("%s's Jump Power เปลี่ยนเป็น: %d", player.Name, value))
        end
    end

    local WalkSpeedToggle = Tabs.Main:AddToggle("WalkSpeedToggle", {
        Title = "เปิด/ปิด ความเร็วในการเดิน",
        Default = false,
        Description = "เปิดหรือปิดการปรับความเร็วในการเดิน"
    })

    local WalkSpeedSlider = Tabs.Main:AddSlider("WalkSpeedSlider", {
        Title = "ความเร็วในการเดิน",
        Description = "ปรับความเร็วในการเดินของผู้เล่น",
        Default = 16,
        Min = 0,
        Max = 200,
        Rounding = 1,
        Callback = function(Value)
            if WalkSpeedToggle.Value then
                for _, player in pairs(game.Players:GetPlayers()) do
                    updateWalkSpeed(player, Value)
                end
            end
        end
    })

    WalkSpeedSlider:OnChanged(function(Value)
        print(string.format("ความเร็วในการเดินสไลเดอร์เปลี่ยนเป็น: %d", Value))
        if WalkSpeedToggle.Value then
            for _, player in pairs(game.Players:GetPlayers()) do
                updateWalkSpeed(player, Value)
            end
        end
    end)

    WalkSpeedSlider:SetValue(16)

    WalkSpeedToggle:OnChanged(function()
        local defaultWalkSpeed = 16
        for _, player in pairs(game.Players:GetPlayers()) do
            if not WalkSpeedToggle.Value then
                updateWalkSpeed(player, defaultWalkSpeed)
            else
                updateWalkSpeed(player, WalkSpeedSlider.Value)
            end
        end
        print(string.format("การเปลี่ยนแปลงการเปิด/ปิดความเร็วในการเดิน: %s", tostring(WalkSpeedToggle.Value)))
    end)

    -- JumpPower --

    local JumpPowerToggle = Tabs.Main:AddToggle("JumpPowerToggle", {
        Title = "เปิด/ปิด Jump Power",
        Default = false,
        Description = "เปิดหรือปิดการปรับ Jump Power"
    })

    local JumpPowerSlider = Tabs.Main:AddSlider("JumpPowerSlider", {
        Title = "Jump Power",
        Description = "ปรับ Jump Power ของผู้เล่น",
        Default = 50,
        Min = 0,
        Max = 200,
        Rounding = 1,
        Callback = function(Value)
            if JumpPowerToggle.Value then
                for _, player in pairs(game.Players:GetPlayers()) do
                    updateJumpPower(player, Value)
                end
            end
        end
    })

    JumpPowerSlider:OnChanged(function(Value)
        print(string.format("Jump Power สไลเดอร์เปลี่ยนเป็น: %d", Value))
        if JumpPowerToggle.Value then
            for _, player in pairs(game.Players:GetPlayers()) do
                updateJumpPower(player, Value)
            end
        end
    end)

    JumpPowerSlider:SetValue(50)

    JumpPowerToggle:OnChanged(function()
        local defaultJumpPower = 50
        for _, player in pairs(game.Players:GetPlayers()) do
            if not JumpPowerToggle.Value then
                updateJumpPower(player, defaultJumpPower)
            else
                updateJumpPower(player, JumpPowerSlider.Value)
            end
        end
        print(string.format("การเปลี่ยนแปลงการเปิด/ปิด Jump Power: %s", tostring(JumpPowerToggle.Value)))
    end)
end
    InterfaceManager:SetLibrary(Fluent)
    InterfaceManager:SetFolder("FluentScriptHub")
    InterfaceManager:BuildInterfaceSection(Tabs.Settings)
    Window:SelectTab(1)

    Fluent:Notify({
        Title = "Script Loaded",
        Content = "Universary  Ready!",
        Duration = 2
    })

    SaveManager:LoadAutoloadConfig()
