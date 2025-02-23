
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
setfpscap(360)
wait(9)
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
        Title = "Meat",
        Content = "Auto farm meat resources"
    })
    
    local Toggle = Tabs.Main:AddToggle("AutoFarmAppleToggle", {Title = "Auto Farm Apple", Default = false })
    local Input = Tabs.Main:AddInput("AppleSize", {
        Title = "Apple Size", 
        Default = "",
        Placeholder = "Enter apple size (1-100)",
        Numeric = true,
        Finished = true,
        Callback = function(Value)
            local size = math.clamp(tonumber(Value) or 4, 1, 100)
            local apples = workspace:FindFirstChild("Farm") and workspace.Farm:FindFirstChild("Apple") and workspace.Farm.Apple:FindFirstChild("FarmItem") and workspace.Farm.Apple.FarmItem:GetChildren()
            if apples then
                for _, appleModel in ipairs(apples) do
                    if appleModel:IsA("Model") and appleModel.Name == "Apple" then
                        for _, part in pairs(appleModel:GetDescendants()) do
                            if part:IsA("BasePart") then
                                part.Size = Vector3.new(size, size, size)
                            end
                        end
                    end
                end
            end
        end
    })

    Tabs.Main:AddButton({
        Title = "Reset Apple Size",
        Description = "Reset apples to original size",
        Callback = function()
            Window:Dialog({
                Title = "Reset Apple Size",
                Content = "Are you sure you want to reset all apples to their original size?",
                Buttons = {
                    {
                        Title = "Confirm",
                        Callback = function()
                            local apples = workspace:FindFirstChild("Farm") and workspace.Farm:FindFirstChild("Apple") and workspace.Farm.Apple:FindFirstChild("FarmItem") and workspace.Farm.Apple.FarmItem:GetChildren()
                            if apples then
                                for _, appleModel in ipairs(apples) do
                                    if appleModel:IsA("Model") and appleModel.Name == "Apple" then
                                        for _, part in pairs(appleModel:GetDescendants()) do
                                            if part:IsA("BasePart") then
                                                part.Size = Vector3.new(2.387, 2.387, 2.387) -- Reset to fixed size
                                            end
                                        end
                                    end
                                end
                            end
                            Options.AppleSize:SetValue("4")
                        end
                    },
                    {
                        Title = "Cancel",
                        Callback = function()
                            print("Apple size reset cancelled")
                        end
                    }
                }
            })
        end
    })

    local isRunning = false
    
    Toggle:OnChanged(function()
        if Options.AutoFarmAppleToggle.Value then
            if isRunning then return end
            isRunning = true
            
            spawn(function()
                while Options.AutoFarmAppleToggle.Value do
                    local character = game.Players.LocalPlayer.Character
                    if not character then task.wait(1) continue end
                    
                    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                    if not humanoidRootPart then task.wait(1) continue end
                    
                    local apples = workspace:FindFirstChild("Farm") and workspace.Farm:FindFirstChild("Apple") and workspace.Farm.Apple:FindFirstChild("FarmItem") and workspace.Farm.Apple.FarmItem:GetChildren()
                    if not apples then task.wait(1) continue end
                    
                    local function findNearestApple()
                        local nearestApple = nil
                        local shortestDistance = math.huge
                        
                        for _, appleModel in ipairs(apples) do
                            if appleModel:IsA("Model") and appleModel.Name == "Apple" and appleModel.PrimaryPart then
                                local distance = (appleModel.PrimaryPart.Position - humanoidRootPart.Position).Magnitude
                                if distance < shortestDistance then
                                    shortestDistance = distance
                                    nearestApple = appleModel
                                end
                            end
                        end
                        
                        return nearestApple
                    end
                    
                    local currentApple = findNearestApple()
                    while currentApple and Options.AutoFarmAppleToggle.Value do
                        local player = game:GetService("Players").LocalPlayer
                        
                        if player.Status.Hunger.Value <= 10 then
                            if player.Inventory.Bread.Value <= 0 then
                                game:GetService("ReplicatedStorage"):WaitForChild("Remote"):WaitForChild("Shop"):FireServer("BuyCash", "Bread", 1)
                                task.wait(0.5)
                            end
                            game:GetService("ReplicatedStorage"):WaitForChild("Remote"):WaitForChild("Inventory"):FireServer("Use", "Bread")
                            task.wait(0.5)
                        end
                        
                        if player.Status.Thirsty.Value <= 10 then
                            if player.Inventory.Water.Value <= 0 then
                                game:GetService("ReplicatedStorage"):WaitForChild("Remote"):WaitForChild("Shop"):FireServer("BuyCash", "Water", 1)
                                task.wait(0.5)
                            end
                            game:GetService("ReplicatedStorage"):WaitForChild("Remote"):WaitForChild("Inventory"):FireServer("Use", "Water")
                            task.wait(0.5)
                        end

                        if not currentApple.Parent then
                            currentApple = findNearestApple()
                            if not currentApple then break end
                        end
                        
                        pcall(function()
                            local targetPos = currentApple.PrimaryPart.Position + Vector3.new(0, 5, 0)
                            humanoidRootPart.CFrame = CFrame.new(targetPos)
                            
                            for i = 1, 20 do
                                local lerpPos = targetPos:Lerp(currentApple.PrimaryPart.Position + Vector3.new(0, 1.5, 0), i/20)
                                humanoidRootPart.CFrame = CFrame.new(lerpPos)
                                task.wait(0.05)
                            end
                            
                            humanoidRootPart.Anchored = true
                        end)

                        pcall(function()
                            if player and player:FindFirstChild("Inventory") and player.Inventory:FindFirstChild("Apple") then
                                if player.Inventory.Apple.Value >= 60 then
                                    game:GetService("ReplicatedStorage"):WaitForChild("Remote"):WaitForChild("Economy"):FireServer("Sell", "Apple", "60")
                                    task.wait(0.5)
                                end
                            end
                        end)

                        humanoidRootPart.CFrame = CFrame.new(3516.57373, 5.05937386, 1878.59692, -0.997351348, -8.00149849e-08, -0.0727347434, -8.58965237e-08, 1, 7.77348532e-08, 0.0727347434, 8.37766194e-08, -0.997351348)
                        task.wait(1.5)
                        
                        task.wait(0.2)
                    end
                    
                    task.wait()
                end
                isRunning = false
            end)
        else
            pcall(function()
                if game.Players.LocalPlayer and 
                   game.Players.LocalPlayer.Character and 
                   game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = false
                end
            end)
        end
    end)

    Options.AutoFarmAppleToggle:SetValue(false)

    Tabs.Main:AddButton({
        Title = "Button",
        Description = "Very important button",
        Callback = function()
            Window:Dialog({
                Title = "Title",
                Content = "This is a dialog",
                Buttons = {
                    {
                        Title = "Confirm",
                        Callback = function()
                            local character = game.Players.LocalPlayer.Character.HumanoidRootPart
                            local targetPosition = CFrame.new(-356.306305, 6.52519417, 82.2841263)

                            -- Teleport the character to the target position
                            character.CFrame = targetPosition
                        end
                    },
                    {
                        Title = "Cancel",
                        Callback = function()
                            print("Cancelled the dialog.")
                        end
                    }
                }
            })
        end
    })
    
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
