local ScreenGui = Instance.new("ScreenGui")
local TextLabel = Instance.new("TextLabel")

ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

TextLabel.Parent = ScreenGui
TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.BackgroundTransparency = 1.000
TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextLabel.BorderSizePixel = 0
TextLabel.Size = UDim2.new(1, 0, 1, 0)
TextLabel.Font = Enum.Font.SourceSans
TextLabel.Text = "Test"
TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.TextSize = 100.000

local function KYLDZQY_fake_script() -- ScreenGui.LocalScript 
	local script = Instance.new('LocalScript', ScreenGui)

	script.Parent.TextLabel.Text = "Loading script Biezel.z Hub"
	wait(3)
	script.Parent.TextLabel.Text = "Loading lincense !!!"
	wait(3)
	script.Parent.TextLabel.Text = "Loaded Script"
	wait(3)
	script.Parent.TextLabel.Text = ""
	
end
coroutine.wrap(KYLDZQY_fake_script)()
wait(9)
setfpscap(360)
local Fluent = loadstring(game:HttpGet("https://raw.githubusercontent.com/Kataporn/Kataporn/refs/heads/main/biezel.z.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Biezel.z" .. Fluent.Version,
    SubTitle = "by my self ",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true, 
    Theme = "AMOLED",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Main = Window:AddTab({ Title = "Start Farm", Icon = "" }),
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
                    if player.Character and player.Character:FindFirstChild("Humanoid") then
                        player.Character.Humanoid.WalkSpeed = math.clamp(Value, 0, 200) -- Ensure value is within bounds
                        print(string.format("%s's ความเร็วในการเดินเปลี่ยนเป็น: %d", player.Name, Value))
                    end
                end
            end
        end
    })

    WalkSpeedSlider:OnChanged(function(Value)
        print(string.format("ความเร็วในการเดินสไลเดอร์เปลี่ยนเป็น: %d", Value))
        if WalkSpeedToggle.Value then
            for _, player in pairs(game.Players:GetPlayers()) do
                if player.Character and player.Character:FindFirstChild("Humanoid") then
                    player.Character.Humanoid.WalkSpeed = math.clamp(Value, 0, 200) -- Ensure value is within bounds
                    print(string.format("%s's ความเร็วในการเดินอัปเดตเป็น: %d", player.Name, Value))
                end
            end
        end
    end)

    WalkSpeedSlider:SetValue(16)

    WalkSpeedToggle:OnChanged(function()
        local defaultWalkSpeed = 16
        for _, player in pairs(game.Players:GetPlayers()) do
            if player.Character and player.Character:FindFirstChild("Humanoid") then
                if not WalkSpeedToggle.Value then
                    player.Character.Humanoid.WalkSpeed = defaultWalkSpeed
                    print(string.format("%s's ความเร็วในการเดินรีเซ็ตเป็นค่าเริ่มต้น: %d", player.Name, defaultWalkSpeed))
                else
                    local currentSliderValue = WalkSpeedSlider.Value
                    player.Character.Humanoid.WalkSpeed = math.clamp(currentSliderValue, 0, 200) -- Ensure value is within bounds
                    print(string.format("%s's ความเร็วในการเดินตั้งเป็นค่าจากสไลเดอร์: %d", player.Name, currentSliderValue))
                end
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
                    if player.Character and player.Character:FindFirstChild("Humanoid") then
                        player.Character.Humanoid.JumpPower = math.clamp(Value, 0, 200) -- Ensure value is within bounds
                        print(string.format("%s's Jump Power เปลี่ยนเป็น: %d", player.Name, Value))
                    end
                end
            end
        end
    })

    JumpPowerSlider:OnChanged(function(Value)
        print(string.format("Jump Power สไลเดอร์เปลี่ยนเป็น: %d", Value))
        if JumpPowerToggle.Value then
            for _, player in pairs(game.Players:GetPlayers()) do
                if player.Character and player.Character:FindFirstChild("Humanoid") then
                    player.Character.Humanoid.JumpPower = math.clamp(Value, 0, 200) -- Ensure value is within bounds
                    print(string.format("%s's Jump Power อัปเดตเป็น: %d", player.Name, Value))
                end
            end
        end
    end)

    JumpPowerSlider:SetValue(50)

    JumpPowerToggle:OnChanged(function()
        local defaultJumpPower = 50
        for _, player in pairs(game.Players:GetPlayers()) do
            if player.Character and player.Character:FindFirstChild("Humanoid") then
                if not JumpPowerToggle.Value then
                    player.Character.Humanoid.JumpPower = defaultJumpPower
                    print(string.format("%s's Jump Power รีเซ็ตเป็นค่าเริ่มต้น: %d", player.Name, defaultJumpPower))
                else
                    local currentSliderValue = JumpPowerSlider.Value
                    player.Character.Humanoid.JumpPower = math.clamp(currentSliderValue, 0, 200) -- Ensure value is within bounds
                    print(string.format("%s's Jump Power ตั้งเป็นค่าจากสไลเดอร์: %d", player.Name, currentSliderValue))
                end
            end
        end
        print(string.format("การเปลี่ยนแปลงการเปิด/ปิด Jump Power: %s", tostring(JumpPowerToggle.Value)))
    end)
    
    InterfaceManager:SetLibrary(Fluent)
    InterfaceManager:SetFolder("FluentScriptHub")
    InterfaceManager:BuildInterfaceSection(Tabs.Settings)
    Window:SelectTab(1)

    Fluent:Notify({
        Title = "Script Loaded",
        Content = "Auto Farm Ready!",
        Duration = 2
    })

    SaveManager:LoadAutoloadConfig()
end
