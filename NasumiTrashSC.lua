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
    Player = Window:AddTab({ Title = "Player Manager", Icon = "user" }),
    Main = Window:AddTab({ Title = "Farm Stone", Icon = "" }),
    Main2 = Window:AddTab({ Title = "Farm Strastrawberry", Icon = "" }),
    Main3 = Window:AddTab({ Title = "Farm Apple", Icon = "" }),
    Main4 = Window:AddTab({ Title = "Farm Banana", Icon = "" }),
    Main5 = Window:AddTab({ Title = "Farm Cabbage", Icon = "" }),
    Main6 = Window:AddTab({ Title = "Farm Orange", Icon = "" }),
    Main7 = Window:AddTab({ Title = "Farm Meat", Icon = "" }),
    Main8 = Window:AddTab({ Title = "Farm Scrap", Icon = "" }),
    Main9 = Window:AddTab({ Title = "Farm Plastic", Icon = "" }),
    Main10 = Window:AddTab({ Title = "Farm Wood", Icon = "" }),
    Main11 = Window:AddTab({ Title = "Farm Watermelon", Icon = "" }),
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
    local Section = Tabs.Main:AddSection("Auto Farm Stone")

    Tabs.Main:AddParagraph({
        Title = "Stone",
        Content = "Auto farm stone resources"
    })
    
    local Toggle = Tabs.Main:AddToggle("AutoFarmStoneToggle", {Title = "Auto Farm Stone", Default = false })
    local Input = Tabs.Main:AddInput("StoneSize", {
        Title = "Stone Size", 
        Default = "",
        Placeholder = "Enter stone size (1-100)",
        Numeric = true,
        Finished = true,
        Callback = function(Value)
            -- Apply fixed size to all stones
            local size = math.clamp(tonumber(Value) or 4, 1, 100) -- Already allows up to 100
            local stones = workspace:FindFirstChild("Farm") and workspace.Farm:FindFirstChild("Stone") and workspace.Farm.Stone:FindFirstChild("FarmItem") and workspace.Farm.Stone.FarmItem:GetChildren()
            if stones then
                for _, stoneModel in ipairs(stones) do
                    if stoneModel:IsA("Model") and stoneModel.Name == "Stone" then
                        for _, part in pairs(stoneModel:GetDescendants()) do
                            if part:IsA("BasePart") then
                                -- Allow size up to 100x100x100
                                part.Size = Vector3.new(size, size, size)
                            end
                        end
                    end
                end
            end
        end
    })

    -- Add reset stone size button
    Tabs.Main:AddButton({
        Title = "Reset Stone Size",
        Description = "Reset stones to original size",
        Callback = function()
            Window:Dialog({
                Title = "Reset Stone Size",
                Content = "Are you sure you want to reset all stones to their original size?",
                Buttons = {
                    {
                        Title = "Confirm",
                        Callback = function()
                            local stones = workspace:FindFirstChild("Farm") and workspace.Farm:FindFirstChild("Stone") and workspace.Farm.Stone:FindFirstChild("FarmItem") and workspace.Farm.Stone.FarmItem:GetChildren()
                            if stones then
                                for _, stoneModel in ipairs(stones) do
                                    if stoneModel:IsA("Model") and stoneModel.Name == "Stone" then
                                        for _, part in pairs(stoneModel:GetDescendants()) do
                                            if part:IsA("BasePart") then
                                                part.Size = Vector3.new(4.029999732971191, 2.101872682571411, 4.251217842102051) -- Reset to fixed size
                                            end
                                        end
                                    end
                                end
                            end
                            Options.StoneSize:SetValue("4")
                        end
                    },
                    {
                        Title = "Cancel",
                        Callback = function()
                            print("Stone size reset cancelled")
                        end
                    }
                }
            })
        end
    })

    local isRunning = false
    
    Toggle:OnChanged(function()
        if Options.AutoFarmStoneToggle.Value then
            if isRunning then return end
            isRunning = true
            
            spawn(function()
                while Options.AutoFarmStoneToggle.Value do
                    local character = game.Players.LocalPlayer.Character
                    if not character then task.wait(1) continue end
                    
                    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                    if not humanoidRootPart then task.wait(1) continue end
                    
                    local stones = workspace:FindFirstChild("Farm") and workspace.Farm:FindFirstChild("Stone") and workspace.Farm.Stone:FindFirstChild("FarmItem") and workspace.Farm.Stone.FarmItem:GetChildren()
                    if not stones then task.wait(1) continue end
                    
                    local function findNearestStone()
                        local nearestStone = nil
                        local shortestDistance = math.huge
                        
                        for _, stoneModel in ipairs(stones) do
                            if stoneModel:IsA("Model") and stoneModel.Name == "Stone" and stoneModel.PrimaryPart then
                                local distance = (stoneModel.PrimaryPart.Position - humanoidRootPart.Position).Magnitude
                                if distance < shortestDistance then
                                    shortestDistance = distance
                                    nearestStone = stoneModel
                                end
                            end
                        end
                        
                        return nearestStone
                    end
                    
                    local currentStone = findNearestStone()
                    while currentStone and Options.AutoFarmStoneToggle.Value do
                        -- Check hunger and thirst levels
                        local player = game:GetService("Players").LocalPlayer
                        
                        -- Check and manage bread
                        if player.Status.Hunger.Value <= 10 then
                            -- Check if we have bread in inventory
                            if player.Inventory.Bread.Value <= 0 then
                                -- Buy bread if none available
                                game:GetService("ReplicatedStorage"):WaitForChild("Remote"):WaitForChild("Shop"):FireServer("BuyCash", "Bread", 1)
                                task.wait(0.5)
                            end
                            -- Use bread
                            game:GetService("ReplicatedStorage"):WaitForChild("Remote"):WaitForChild("Inventory"):FireServer("Use", "Bread")
                            task.wait(0.5)
                        end
                        
                        -- Check and manage water
                        if player.Status.Thirsty.Value <= 10 then
                            -- Check if we have water in inventory
                            if player.Inventory.Water.Value <= 0 then
                                -- Buy water if none available
                                game:GetService("ReplicatedStorage"):WaitForChild("Remote"):WaitForChild("Shop"):FireServer("BuyCash", "Water", 1)
                                task.wait(0.5)
                            end
                            -- Use water
                            game:GetService("ReplicatedStorage"):WaitForChild("Remote"):WaitForChild("Inventory"):FireServer("Use", "Water")
                            task.wait(0.5)
                        end

                        if not currentStone.Parent then
                            currentStone = findNearestStone()
                            if not currentStone then break end
                        end
                        
                        pcall(function()
                            -- Calculate position 10 studs above the stone
                            local targetPos = currentStone.PrimaryPart.Position + Vector3.new(0, 10, 0)
                            humanoidRootPart.CFrame = CFrame.new(targetPos)
                            
                            -- Smoothly move down to the stone
                            for i = 1, 20 do
                                local lerpPos = targetPos:Lerp(currentStone.PrimaryPart.Position + Vector3.new(0, 1.5, 0), i/20)
                                humanoidRootPart.CFrame = CFrame.new(lerpPos)
                                task.wait(0.05)
                            end
                            
                            humanoidRootPart.Anchored = true
                        end)
                        
                        pcall(function()
                            local player = game:GetService("Players").LocalPlayer
                            if player and player:FindFirstChild("Inventory") and player.Inventory:FindFirstChild("Stone") then
                                if player.Inventory.Stone.Value >= 60 then
                                    game:GetService("ReplicatedStorage"):WaitForChild("Remote"):WaitForChild("Economy"):FireServer("Sell", "Stone", "30")
                                    task.wait(0.5)
                                end
                            end
                        end)
                        
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

    Options.AutoFarmStoneToggle:SetValue(false)

    local Section = Tabs.Main2:AddSection("Auto Farm Strawberry")

    Tabs.Main2:AddParagraph({
        Title = "Strawberry",
        Content = "Auto farm strawberry resources"
    })
    
    local Toggle = Tabs.Main2:AddToggle("AutoFarmStrawberryToggle", {Title = "Auto Farm Strawberry", Default = false })
    local Input = Tabs.Main2:AddInput("StrawberrySize", {
        Title = "Strawberry Size", 
        Default = "",
        Placeholder = "Enter strawberry size (1-100)",
        Numeric = true,
        Finished = true,
        Callback = function(Value)
            -- Apply fixed size to all strawberries
            local size = math.clamp(tonumber(Value) or 4, 1, 100) -- Already allows up to 100
            local strawberries = workspace:FindFirstChild("Farm") and workspace.Farm:FindFirstChild("Strawberry") and workspace.Farm.Strawberry:FindFirstChild("FarmItem") and workspace.Farm.Strawberry.FarmItem:GetChildren()
            if strawberries then
                for _, strawberryModel in ipairs(strawberries) do
                    if strawberryModel:IsA("Model") and strawberryModel.Name == "Strawberry" then
                        for _, part in pairs(strawberryModel:GetDescendants()) do
                            if part:IsA("BasePart") then
                                -- Allow size up to 100x100x100
                                part.Size = Vector3.new(size, size, size)
                            end
                        end
                    end
                end
            end
        end
    })

    -- Add reset strawberry size button
    Tabs.Main2:AddButton({
        Title = "Reset Strawberry Size",
        Description = "Reset strawberries to original size",
        Callback = function()
            Window:Dialog({
                Title = "Reset Strawberry Size",
                Content = "Are you sure you want to reset all strawberries to their original size?",
                Buttons = {
                    {
                        Title = "Confirm",
                        Callback = function()
                            local strawberries = workspace:FindFirstChild("Farm") and workspace.Farm:FindFirstChild("Strawberry") and workspace.Farm.Strawberry:FindFirstChild("FarmItem") and workspace.Farm.Strawberry.FarmItem:GetChildren()
                            if strawberries then
                                for _, strawberryModel in ipairs(strawberries) do
                                    if strawberryModel:IsA("Model") and strawberryModel.Name == "Strawberry" then
                                        for _, part in pairs(strawberryModel:GetDescendants()) do
                                            if part:IsA("BasePart") then
                                                part.Size = Vector3.new(2.7812604904174805, 2.3333098888397217, 2.996256113052368) -- Reset to fixed size
                                            end
                                        end
                                    end
                                end
                            end
                            Options.StrawberrySize:SetValue("4")
                        end
                    },
                    {
                        Title = "Cancel",
                        Callback = function()
                            print("Strawberry size reset cancelled")
                        end
                    }
                }
            })
        end
    })

    local isRunning = false
    
    Toggle:OnChanged(function()
        if Options.AutoFarmStrawberryToggle.Value then
            if isRunning then return end
            isRunning = true
            
            spawn(function()
                while Options.AutoFarmStrawberryToggle.Value do
                    local character = game.Players.LocalPlayer.Character
                    if not character then task.wait(1) continue end
                    
                    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                    if not humanoidRootPart then task.wait(1) continue end
                    
                    local strawberries = workspace:FindFirstChild("Farm") and workspace.Farm:FindFirstChild("Strawberry") and workspace.Farm.Strawberry:FindFirstChild("FarmItem") and workspace.Farm.Strawberry.FarmItem:GetChildren()
                    if not strawberries then task.wait(1) continue end
                    
                    local function findNearestStrawberry()
                        local nearestStrawberry = nil
                        local shortestDistance = math.huge
                        
                        for _, strawberryModel in ipairs(strawberries) do
                            if strawberryModel:IsA("Model") and strawberryModel.Name == "Strawberry" and strawberryModel.PrimaryPart then
                                local distance = (strawberryModel.PrimaryPart.Position - humanoidRootPart.Position).Magnitude
                                if distance < shortestDistance then
                                    shortestDistance = distance
                                    nearestStrawberry = strawberryModel
                                end
                            end
                        end
                        
                        return nearestStrawberry
                    end
                    
                    local currentStrawberry = findNearestStrawberry()
                    while currentStrawberry and Options.AutoFarmStrawberryToggle.Value do
                        -- Check hunger and thirst levels
                        local player = game:GetService("Players").LocalPlayer
                        
                        -- Check and manage bread
                        if player.Status.Hunger.Value <= 10 then
                            -- Check if we have bread in inventory
                            if player.Inventory.Bread.Value <= 0 then
                                -- Buy bread if none available
                                game:GetService("ReplicatedStorage"):WaitForChild("Remote"):WaitForChild("Shop"):FireServer("BuyCash", "Bread", 1)
                                task.wait(0.5)
                            end
                            -- Use bread
                            game:GetService("ReplicatedStorage"):WaitForChild("Remote"):WaitForChild("Inventory"):FireServer("Use", "Bread")
                            task.wait(0.5)
                        end
                        
                        -- Check and manage water
                        if player.Status.Thirsty.Value <= 10 then
                            -- Check if we have water in inventory
                            if player.Inventory.Water.Value <= 0 then
                                -- Buy water if none available
                                game:GetService("ReplicatedStorage"):WaitForChild("Remote"):WaitForChild("Shop"):FireServer("BuyCash", "Water", 1)
                                task.wait(0.5)
                            end
                            -- Use water
                            game:GetService("ReplicatedStorage"):WaitForChild("Remote"):WaitForChild("Inventory"):FireServer("Use", "Water")
                            task.wait(0.5)
                        end

                        if not currentStrawberry.Parent then
                            currentStrawberry = findNearestStrawberry()
                            if not currentStrawberry then break end
                        end
                        
                        pcall(function()
                            -- Calculate position 10 studs above the strawberry
                            local targetPos = currentStrawberry.PrimaryPart.Position + Vector3.new(0, 10, 0)
                            humanoidRootPart.CFrame = CFrame.new(targetPos)
                            
                            -- Smoothly move down to the strawberry
                            for i = 1, 20 do
                                local lerpPos = targetPos:Lerp(currentStrawberry.PrimaryPart.Position + Vector3.new(0, 1.5, 0), i/20)
                                humanoidRootPart.CFrame = CFrame.new(lerpPos)
                                task.wait(0.05)
                            end
                            
                            humanoidRootPart.Anchored = true
                        end)
                        
                        pcall(function()
                            local player = game:GetService("Players").LocalPlayer
                            if player and player:FindFirstChild("Inventory") and player.Inventory:FindFirstChild("Strawberry") then
                                if player.Inventory.Strawberry.Value >= 60 then
                                    game:GetService("ReplicatedStorage"):WaitForChild("Remote"):WaitForChild("Economy"):FireServer("Sell", "Strawberry", "30")
                                    task.wait(0.5)
                                end
                            end
                        end)
                        
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

    Options.AutoFarmStrawberryToggle:SetValue(false)

    local Section = Tabs.Main3:AddSection("Auto Farm Apple")
    
    Tabs.Main3:AddParagraph({
        Title = "Apple",
        Content = "Auto farm apple resources"
    })
    
    local Toggle = Tabs.Main3:AddToggle("AutoFarmAppleToggle", {Title = "Auto Farm Apple", Default = false })
    local Input = Tabs.Main3:AddInput("AppleSize", {
        Title = "Apple Size", 
        Default = "",
        Placeholder = "Enter apple size (1-100)",
        Numeric = true,
        Finished = true,
        Callback = function(Value)
            -- Apply fixed size to all apples
            local size = math.clamp(tonumber(Value) or 4, 1, 100) -- Already allows up to 100
            local apples = workspace:FindFirstChild("Farm") and workspace.Farm:FindFirstChild("Apple") and workspace.Farm.Apple:FindFirstChild("FarmItem") and workspace.Farm.Apple.FarmItem:GetChildren()
            if apples then
                for _, appleModel in ipairs(apples) do
                    if appleModel:IsA("Model") and appleModel.Name == "Apple" then
                        for _, part in pairs(appleModel:GetDescendants()) do
                            if part:IsA("BasePart") then
                                -- Allow size up to 100x100x100
                                part.Size = Vector3.new(size, size, size)
                            end
                        end
                    end
                end
            end
        end
    })

    -- Add reset apple size button
    Tabs.Main3:AddButton({
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
                                                part.Size = Vector3.new(2.9208621978759766, 3.5744853019714355, 3.0281105041503906) -- Reset to fixed size
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
                        -- Check hunger and thirst levels
                        local player = game:GetService("Players").LocalPlayer
                        
                        -- Check and manage bread
                        if player.Status.Hunger.Value <= 10 then
                            -- Check if we have bread in inventory
                            if player.Inventory.Bread.Value <= 0 then
                                -- Buy bread if none available
                                game:GetService("ReplicatedStorage"):WaitForChild("Remote"):WaitForChild("Shop"):FireServer("BuyCash", "Bread", 1)
                                task.wait(0.5)
                            end
                            -- Use bread
                            game:GetService("ReplicatedStorage"):WaitForChild("Remote"):WaitForChild("Inventory"):FireServer("Use", "Bread")
                            task.wait(0.5)
                        end
                        
                        -- Check and manage water
                        if player.Status.Thirsty.Value <= 10 then
                            -- Check if we have water in inventory
                            if player.Inventory.Water.Value <= 0 then
                                -- Buy water if none available
                                game:GetService("ReplicatedStorage"):WaitForChild("Remote"):WaitForChild("Shop"):FireServer("BuyCash", "Water", 1)
                                task.wait(0.5)
                            end
                            -- Use water
                            game:GetService("ReplicatedStorage"):WaitForChild("Remote"):WaitForChild("Inventory"):FireServer("Use", "Water")
                            task.wait(0.5)
                        end

                        if not currentApple.Parent then
                            currentApple = findNearestApple()
                            if not currentApple then break end
                        end
                        
                        pcall(function()
                            -- Calculate position 10 studs above the apple
                            local targetPos = currentApple.PrimaryPart.Position + Vector3.new(0, 10, 0)
                            humanoidRootPart.CFrame = CFrame.new(targetPos)
                            
                            -- Smoothly move down to the apple
                            for i = 1, 20 do
                                local lerpPos = targetPos:Lerp(currentApple.PrimaryPart.Position + Vector3.new(0, 1.5, 0), i/20)
                                humanoidRootPart.CFrame = CFrame.new(lerpPos)
                                task.wait(0.05)
                            end
                            
                            humanoidRootPart.Anchored = true
                        end)
                        
                        pcall(function()
                            local player = game:GetService("Players").LocalPlayer
                            if player and player:FindFirstChild("Inventory") and player.Inventory:FindFirstChild("Apple") then
                                if player.Inventory.Apple.Value >= 60 then
                                    game:GetService("ReplicatedStorage"):WaitForChild("Remote"):WaitForChild("Economy"):FireServer("Sell", "Apple", "30")
                                    task.wait(0.5)
                                end
                            end
                        end)
                        
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

    local Section = Tabs.Main4:AddSection("Auto Farm Banana")
    
    Tabs.Main4:AddParagraph({
        Title = "Banana",
        Content = "Auto farm banana resources"
    })
    
    local Toggle = Tabs.Main4:AddToggle("AutoFarmBananaToggle", {Title = "Auto Farm Banana", Default = false })
    local Input = Tabs.Main4:AddInput("BananaSize", {
        Title = "Banana Size", 
        Default = "",
        Placeholder = "Enter banana size (1-100)",
        Numeric = true,
        Finished = true,
        Callback = function(Value)
            -- Apply fixed size to all bananas
            local size = math.clamp(tonumber(Value) or 4, 1, 100) -- Already allows up to 100
            local bananas = workspace:FindFirstChild("Farm") and workspace.Farm:FindFirstChild("Banana") and workspace.Farm.Banana:FindFirstChild("FarmItem") and workspace.Farm.Banana.FarmItem:GetChildren()
            if bananas then
                for _, bananaModel in ipairs(bananas) do
                    if bananaModel:IsA("Model") and bananaModel.Name == "Banana" then
                        for _, part in pairs(bananaModel:GetDescendants()) do
                            if part:IsA("BasePart") then
                                -- Allow size up to 100x100x100
                                part.Size = Vector3.new(size, size, size)
                            end
                        end
                    end
                end
            end
        end
    })

    -- Add reset banana size button
    Tabs.Main4:AddButton({
        Title = "Reset Banana Size",
        Description = "Reset bananas to original size",
        Callback = function()
            Window:Dialog({
                Title = "Reset Banana Size",
                Content = "Are you sure you want to reset all bananas to their original size?",
                Buttons = {
                    {
                        Title = "Confirm",
                        Callback = function()
                            local bananas = workspace:FindFirstChild("Farm") and workspace.Farm:FindFirstChild("Banana") and workspace.Farm.Banana:FindFirstChild("FarmItem") and workspace.Farm.Banana.FarmItem:GetChildren()
                            if bananas then
                                for _, bananaModel in ipairs(bananas) do
                                    if bananaModel:IsA("Model") and bananaModel.Name == "Banana" then
                                        for _, part in pairs(bananaModel:GetDescendants()) do
                                            if part:IsA("BasePart") then
                                                part.Size = Vector3.new(2.617002010345459, 0.8266671299934387, 3.482895612716675) -- Reset to fixed size
                                            end
                                        end
                                    end
                                end
                            end
                            Options.BananaSize:SetValue("4")
                        end
                    },
                    {
                        Title = "Cancel",
                        Callback = function()
                            print("Banana size reset cancelled")
                        end
                    }
                }
            })
        end
    })

    local isRunning = false
    
    Toggle:OnChanged(function()
        if Options.AutoFarmBananaToggle.Value then
            if isRunning then return end
            isRunning = true
            
            spawn(function()
                while Options.AutoFarmBananaToggle.Value do
                    local character = game.Players.LocalPlayer.Character
                    if not character then task.wait(1) continue end
                    
                    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                    if not humanoidRootPart then task.wait(1) continue end
                    
                    local bananas = workspace:FindFirstChild("Farm") and workspace.Farm:FindFirstChild("Banana") and workspace.Farm.Banana:FindFirstChild("FarmItem") and workspace.Farm.Banana.FarmItem:GetChildren()
                    if not bananas then task.wait(1) continue end
                    
                    local function findNearestBanana()
                        local nearestBanana = nil
                        local shortestDistance = math.huge
                        
                        for _, bananaModel in ipairs(bananas) do
                            if bananaModel:IsA("Model") and bananaModel.Name == "Banana" and bananaModel.PrimaryPart then
                                local distance = (bananaModel.PrimaryPart.Position - humanoidRootPart.Position).Magnitude
                                if distance < shortestDistance then
                                    shortestDistance = distance
                                    nearestBanana = bananaModel
                                end
                            end
                        end
                        
                        return nearestBanana
                    end
                    
                    local currentBanana = findNearestBanana()
                    while currentBanana and Options.AutoFarmBananaToggle.Value do
                        -- Check hunger and thirst levels
                        local player = game:GetService("Players").LocalPlayer
                        
                        -- Check and manage bread
                        if player.Status.Hunger.Value <= 10 then
                            -- Check if we have bread in inventory
                            if player.Inventory.Bread.Value <= 0 then
                                -- Buy bread if none available
                                game:GetService("ReplicatedStorage"):WaitForChild("Remote"):WaitForChild("Shop"):FireServer("BuyCash", "Bread", 1)
                                task.wait(0.5)
                            end
                            -- Use bread
                            game:GetService("ReplicatedStorage"):WaitForChild("Remote"):WaitForChild("Inventory"):FireServer("Use", "Bread")
                            task.wait(0.5)
                        end
                        
                        -- Check and manage water
                        if player.Status.Thirsty.Value <= 10 then
                            -- Check if we have water in inventory
                            if player.Inventory.Water.Value <= 0 then
                                -- Buy water if none available
                                game:GetService("ReplicatedStorage"):WaitForChild("Remote"):WaitForChild("Shop"):FireServer("BuyCash", "Water", 1)
                                task.wait(0.5)
                            end
                            -- Use water
                            game:GetService("ReplicatedStorage"):WaitForChild("Remote"):WaitForChild("Inventory"):FireServer("Use", "Water")
                            task.wait(0.5)
                        end

                        if not currentBanana.Parent then
                            currentBanana = findNearestBanana()
                            if not currentBanana then break end
                        end
                        
                        pcall(function()
                            -- Calculate position 10 studs above the banana
                            local targetPos = currentBanana.PrimaryPart.Position + Vector3.new(0, 10, 0)
                            humanoidRootPart.CFrame = CFrame.new(targetPos)
                            
                            -- Smoothly move down to the banana
                            for i = 1, 20 do
                                local lerpPos = targetPos:Lerp(currentBanana.PrimaryPart.Position + Vector3.new(0, 1.5, 0), i/20)
                                humanoidRootPart.CFrame = CFrame.new(lerpPos)
                                task.wait(0.05)
                            end
                            
                            humanoidRootPart.Anchored = true
                        end)
                        
                        pcall(function()
                            local player = game:GetService("Players").LocalPlayer
                            if player and player:FindFirstChild("Inventory") and player.Inventory:FindFirstChild("Banana") then
                                if player.Inventory.Banana.Value >= 60 then
                                    game:GetService("ReplicatedStorage"):WaitForChild("Remote"):WaitForChild("Economy"):FireServer("Sell", "Banana", "30")
                                    task.wait(0.5)
                                end
                            end
                        end)
                        
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

    Options.AutoFarmBananaToggle:SetValue(false)

    local Section = Tabs.Main5:AddSection("Auto Farm Cabbage")
    
    Tabs.Main5:AddParagraph({
        Title = "Cabbage",
        Content = "Auto farm cabbage resources"
    })
    
    local Toggle = Tabs.Main5:AddToggle("AutoFarmCabbageToggle", {Title = "Auto Farm Cabbage", Default = false })
    local Input = Tabs.Main5:AddInput("CabbageSize", {
        Title = "Cabbage Size", 
        Default = "",
        Placeholder = "Enter cabbage size (1-100)",
        Numeric = true,
        Finished = true,
        Callback = function(Value)
            -- Apply fixed size to all cabbages
            local size = math.clamp(tonumber(Value) or 4, 1, 100) -- Already allows up to 100
            local cabbages = workspace:FindFirstChild("Farm") and workspace.Farm:FindFirstChild("Cabbage") and workspace.Farm.Cabbage:FindFirstChild("FarmItem") and workspace.Farm.Cabbage.FarmItem:GetChildren()
            if cabbages then
                for _, cabbageModel in ipairs(cabbages) do
                    if cabbageModel:IsA("Model") and cabbageModel.Name == "Cabbage" then
                        for _, part in pairs(cabbageModel:GetDescendants()) do
                            if part:IsA("BasePart") then
                                -- Allow size up to 100x100x100
                                part.Size = Vector3.new(size, size, size)
                            end
                        end
                    end
                end
            end
        end
    })

    -- Add reset cabbage size button
    Tabs.Main5:AddButton({
        Title = "Reset Cabbage Size",
        Description = "Reset cabbages to original size",
        Callback = function()
            Window:Dialog({
                Title = "Reset Cabbage Size",
                Content = "Are you sure you want to reset all cabbages to their original size?",
                Buttons = {
                    {
                        Title = "Confirm",
                        Callback = function()
                            local cabbages = workspace:FindFirstChild("Farm") and workspace.Farm:FindFirstChild("Cabbage") and workspace.Farm.Cabbage:FindFirstChild("FarmItem") and workspace.Farm.Cabbage.FarmItem:GetChildren()
                            if cabbages then
                                for _, cabbageModel in ipairs(cabbages) do
                                    if cabbageModel:IsA("Model") and cabbageModel.Name == "Cabbage" then
                                        for _, part in pairs(cabbageModel:GetDescendants()) do
                                            if part:IsA("BasePart") then
                                                part.Size = Vector3.new(2.280379056930542, 1.7137346267700195, 2.3871309757232666) -- Reset to fixed size
                                            end
                                        end
                                    end
                                end
                            end
                            Options.CabbageSize:SetValue("4")
                        end
                    },
                    {
                        Title = "Cancel",
                        Callback = function()
                            print("Cabbage size reset cancelled")
                        end
                    }
                }
            })
        end
    })

    local isRunning = false
    
    Toggle:OnChanged(function()
        if Options.AutoFarmCabbageToggle.Value then
            if isRunning then return end
            isRunning = true
            
            spawn(function()
                while Options.AutoFarmCabbageToggle.Value do
                    local character = game.Players.LocalPlayer.Character
                    if not character then task.wait(1) continue end
                    
                    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                    if not humanoidRootPart then task.wait(1) continue end
                    
                    local cabbages = workspace:FindFirstChild("Farm") and workspace.Farm:FindFirstChild("Cabbage") and workspace.Farm.Cabbage:FindFirstChild("FarmItem") and workspace.Farm.Cabbage.FarmItem:GetChildren()
                    if not cabbages then task.wait(1) continue end
                    
                    local function findNearestCabbage()
                        local nearestCabbage = nil
                        local shortestDistance = math.huge
                        
                        for _, cabbageModel in ipairs(cabbages) do
                            if cabbageModel:IsA("Model") and cabbageModel.Name == "Cabbage" and cabbageModel.PrimaryPart then
                                local distance = (cabbageModel.PrimaryPart.Position - humanoidRootPart.Position).Magnitude
                                if distance < shortestDistance then
                                    shortestDistance = distance
                                    nearestCabbage = cabbageModel
                                end
                            end
                        end
                        
                        return nearestCabbage
                    end
                    
                    local currentCabbage = findNearestCabbage()
                    while currentCabbage and Options.AutoFarmCabbageToggle.Value do
                        -- Check hunger and thirst levels
                        local player = game:GetService("Players").LocalPlayer
                        
                        -- Check and manage bread
                        if player.Status.Hunger.Value <= 10 then
                            -- Check if we have bread in inventory
                            if player.Inventory.Bread.Value <= 0 then
                                -- Buy bread if none available
                                game:GetService("ReplicatedStorage"):WaitForChild("Remote"):WaitForChild("Shop"):FireServer("BuyCash", "Bread", 1)
                                task.wait(0.5)
                            end
                            -- Use bread
                            game:GetService("ReplicatedStorage"):WaitForChild("Remote"):WaitForChild("Inventory"):FireServer("Use", "Bread")
                            task.wait(0.5)
                        end
                        
                        -- Check and manage water
                        if player.Status.Thirsty.Value <= 10 then
                            -- Check if we have water in inventory
                            if player.Inventory.Water.Value <= 0 then
                                -- Buy water if none available
                                game:GetService("ReplicatedStorage"):WaitForChild("Remote"):WaitForChild("Shop"):FireServer("BuyCash", "Water", 1)
                                task.wait(0.5)
                            end
                            -- Use water
                            game:GetService("ReplicatedStorage"):WaitForChild("Remote"):WaitForChild("Inventory"):FireServer("Use", "Water")
                            task.wait(0.5)
                        end

                        if not currentCabbage.Parent then
                            currentCabbage = findNearestCabbage()
                            if not currentCabbage then break end
                        end
                        
                        pcall(function()
                            -- Calculate position 10 studs above the cabbage
                            local targetPos = currentCabbage.PrimaryPart.Position + Vector3.new(0, 10, 0)
                            humanoidRootPart.CFrame = CFrame.new(targetPos)
                            
                            -- Smoothly move down to the cabbage
                            for i = 1, 20 do
                                local lerpPos = targetPos:Lerp(currentCabbage.PrimaryPart.Position + Vector3.new(0, 1.5, 0), i/20)
                                humanoidRootPart.CFrame = CFrame.new(lerpPos)
                                task.wait(0.05)
                            end
                            
                            humanoidRootPart.Anchored = true
                        end)
                        
                        pcall(function()
                            local player = game:GetService("Players").LocalPlayer
                            if player and player:FindFirstChild("Inventory") and player.Inventory:FindFirstChild("Cabbage") then
                                if player.Inventory.Cabbage.Value >= 60 then
                                    game:GetService("ReplicatedStorage"):WaitForChild("Remote"):WaitForChild("Economy"):FireServer("Sell", "Cabbage", "30")
                                    task.wait(0.5)
                                end
                            end
                        end)
                        
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

    Options.AutoFarmCabbageToggle:SetValue(false)

    local Section = Tabs.Main6:AddSection("Auto Farm Orange")
    
    Tabs.Main6:AddParagraph({
        Title = "Orange",
        Content = "Auto farm orange resources"
    })
    
    local Toggle = Tabs.Main6:AddToggle("AutoFarmOrangeToggle", {Title = "Auto Farm Orange", Default = false })
    local Input = Tabs.Main6:AddInput("OrangeSize", {
        Title = "Orange Size", 
        Default = "",
        Placeholder = "Enter orange size (1-100)",
        Numeric = true,
        Finished = true,
        Callback = function(Value)
            -- Apply fixed size to all oranges
            local size = math.clamp(tonumber(Value) or 4, 1, 100) -- Already allows up to 100
            local oranges = workspace:FindFirstChild("Farm") and workspace.Farm:FindFirstChild("Orange") and workspace.Farm.Orange:FindFirstChild("FarmItem") and workspace.Farm.Orange.FarmItem:GetChildren()
            if oranges then
                for _, orangeModel in ipairs(oranges) do
                    if orangeModel:IsA("Model") and orangeModel.Name == "Orange" then
                        for _, part in pairs(orangeModel:GetDescendants()) do
                            if part:IsA("BasePart") then
                                -- Allow size up to 100x100x100
                                part.Size = Vector3.new(size, size, size)
                            end
                        end
                    end
                end
            end
        end
    })

    -- Add reset orange size button
    Tabs.Main6:AddButton({
        Title = "Reset Orange Size",
        Description = "Reset oranges to original size",
        Callback = function()
            Window:Dialog({
                Title = "Reset Orange Size",
                Content = "Are you sure you want to reset all oranges to their original size?",
                Buttons = {
                    {
                        Title = "Confirm",
                        Callback = function()
                            local oranges = workspace:FindFirstChild("Farm") and workspace.Farm:FindFirstChild("Orange") and workspace.Farm.Orange:FindFirstChild("FarmItem") and workspace.Farm.Orange.FarmItem:GetChildren()
                            if oranges then
                                for _, orangeModel in ipairs(oranges) do
                                    if orangeModel:IsA("Model") and orangeModel.Name == "Orange" then
                                        for _, part in pairs(orangeModel:GetDescendants()) do
                                            if part:IsA("BasePart") then
                                                part.Size = Vector3.new(2.3870253562927246, 2.3870253562927246, 2.3870253562927246) -- Reset to fixed size
                                            end
                                        end
                                    end
                                end
                            end
                            Options.OrangeSize:SetValue("4")
                        end
                    },
                    {
                        Title = "Cancel",
                        Callback = function()
                            print("Orange size reset cancelled")
                        end
                    }
                }
            })
        end
    })

    local isRunning = false
    
    Toggle:OnChanged(function()
        if Options.AutoFarmOrangeToggle.Value then
            if isRunning then return end
            isRunning = true
            
            spawn(function()
                while Options.AutoFarmOrangeToggle.Value do
                    local character = game.Players.LocalPlayer.Character
                    if not character then task.wait(1) continue end
                    
                    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                    if not humanoidRootPart then task.wait(1) continue end
                    
                    local oranges = workspace:FindFirstChild("Farm") and workspace.Farm:FindFirstChild("Orange") and workspace.Farm.Orange:FindFirstChild("FarmItem") and workspace.Farm.Orange.FarmItem:GetChildren()
                    if not oranges then task.wait(1) continue end
                    
                    local function findNearestOrange()
                        local nearestOrange = nil
                        local shortestDistance = math.huge
                        
                        for _, orangeModel in ipairs(oranges) do
                            if orangeModel:IsA("Model") and orangeModel.Name == "Orange" and orangeModel.PrimaryPart then
                                local distance = (orangeModel.PrimaryPart.Position - humanoidRootPart.Position).Magnitude
                                if distance < shortestDistance then
                                    shortestDistance = distance
                                    nearestOrange = orangeModel
                                end
                            end
                        end
                        
                        return nearestOrange
                    end
                    
                    local currentOrange = findNearestOrange()
                    while currentOrange and Options.AutoFarmOrangeToggle.Value do
                        -- Check hunger and thirst levels
                        local player = game:GetService("Players").LocalPlayer
                        
                        -- Check and manage bread
                        if player.Status.Hunger.Value <= 10 then
                            -- Check if we have bread in inventory
                            if player.Inventory.Bread.Value <= 0 then
                                -- Buy bread if none available
                                game:GetService("ReplicatedStorage"):WaitForChild("Remote"):WaitForChild("Shop"):FireServer("BuyCash", "Bread", 1)
                                task.wait(0.5)
                            end
                            -- Use bread
                            game:GetService("ReplicatedStorage"):WaitForChild("Remote"):WaitForChild("Inventory"):FireServer("Use", "Bread")
                            task.wait(0.5)
                        end
                        
                        -- Check and manage water
                        if player.Status.Thirsty.Value <= 10 then
                            -- Check if we have water in inventory
                            if player.Inventory.Water.Value <= 0 then
                                -- Buy water if none available
                                game:GetService("ReplicatedStorage"):WaitForChild("Remote"):WaitForChild("Shop"):FireServer("BuyCash", "Water", 1)
                                task.wait(0.5)
                            end
                            -- Use water
                            game:GetService("ReplicatedStorage"):WaitForChild("Remote"):WaitForChild("Inventory"):FireServer("Use", "Water")
                            task.wait(0.5)
                        end

                        if not currentOrange.Parent then
                            currentOrange = findNearestOrange()
                            if not currentOrange then break end
                        end
                        
                        pcall(function()
                            -- Calculate position 10 studs above the orange
                            local targetPos = currentOrange.PrimaryPart.Position + Vector3.new(0, 10, 0)
                            humanoidRootPart.CFrame = CFrame.new(targetPos)
                            
                            -- Smoothly move down to the orange
                            for i = 1, 20 do
                                local lerpPos = targetPos:Lerp(currentOrange.PrimaryPart.Position + Vector3.new(0, 1.5, 0), i/20)
                                humanoidRootPart.CFrame = CFrame.new(lerpPos)
                                task.wait(0.05)
                            end
                            
                            humanoidRootPart.Anchored = true
                        end)
                        
                        pcall(function()
                            local player = game:GetService("Players").LocalPlayer
                            if player and player:FindFirstChild("Inventory") and player.Inventory:FindFirstChild("Orange") then
                                if player.Inventory.Orange.Value >= 60 then
                                    game:GetService("ReplicatedStorage"):WaitForChild("Remote"):WaitForChild("Economy"):FireServer("Sell", "Orange", "30")
                                    task.wait(0.5)
                                end
                            end
                        end)
                        
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

    Options.AutoFarmOrangeToggle:SetValue(false)

    local Section = Tabs.Main7:AddSection("Auto Farm Meat")
    
    Tabs.Main7:AddParagraph({
        Title = "Meat",
        Content = "Auto farm meat resources"
    })
    
    local Toggle = Tabs.Main7:AddToggle("AutoFarmMeatToggle", {Title = "Auto Farm Meat", Default = false })
    local Input = Tabs.Main7:AddInput("MeatSize", {
        Title = "Meat Size", 
        Default = "",
        Placeholder = "Enter meat size (1-100)",
        Numeric = true,
        Finished = true,
        Callback = function(Value)
            -- Apply fixed size to all meats
            local size = math.clamp(tonumber(Value) or 4, 1, 100) -- Already allows up to 100
            local meats = workspace:FindFirstChild("Farm") and workspace.Farm:FindFirstChild("Meat") and workspace.Farm.Meat:FindFirstChild("FarmItem") and workspace.Farm.Meat.FarmItem:GetChildren()
            if meats then
                for _, meatModel in ipairs(meats) do
                    if meatModel:IsA("Model") and meatModel.Name == "Meat" then
                        for _, part in pairs(meatModel:GetDescendants()) do
                            if part:IsA("BasePart") then
                                -- Allow size up to 100x100x100
                                part.Size = Vector3.new(size, size, size)
                            end
                        end
                    end
                end
            end
        end
    })

    -- Add reset meat size button
    Tabs.Main7:AddButton({
        Title = "Reset Meat Size",
        Description = "Reset meats to original size",
        Callback = function()
            Window:Dialog({
                Title = "Reset Meat Size",
                Content = "Are you sure you want to reset all meats to their original size?",
                Buttons = {
                    {
                        Title = "Confirm",
                        Callback = function()
                            local meats = workspace:FindFirstChild("Farm") and workspace.Farm:FindFirstChild("Meat") and workspace.Farm.Meat:FindFirstChild("FarmItem") and workspace.Farm.Meat.FarmItem:GetChildren()
                            if meats then
                                for _, meatModel in ipairs(meats) do
                                    if meatModel:IsA("Model") and meatModel.Name == "Meat" then
                                        for _, part in pairs(meatModel:GetDescendants()) do
                                            if part:IsA("BasePart") then
                                                part.Size = Vector3.new(2.3870253562927246, 2.3870253562927246, 2.3870253562927246) -- Reset to fixed size
                                            end
                                        end
                                    end
                                end
                            end
                            Options.MeatSize:SetValue("4")
                        end
                    },
                    {
                        Title = "Cancel",
                        Callback = function()
                            print("Meat size reset cancelled")
                        end
                    }
                }
            })
        end
    })

    local isRunning = false
    
    Toggle:OnChanged(function()
        if Options.AutoFarmMeatToggle.Value then
            if isRunning then return end
            isRunning = true
            
            spawn(function()
                while Options.AutoFarmMeatToggle.Value do
                    local character = game.Players.LocalPlayer.Character
                    if not character then task.wait(1) continue end
                    
                    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                    if not humanoidRootPart then task.wait(1) continue end
                    
                    local meats = workspace:FindFirstChild("Farm") and workspace.Farm:FindFirstChild("Meat") and workspace.Farm.Meat:FindFirstChild("FarmItem") and workspace.Farm.Meat.FarmItem:GetChildren()
                    if not meats then task.wait(1) continue end
                    
                    local function findNearestMeat()
                        local nearestMeat = nil
                        local shortestDistance = math.huge
                        
                        for _, meatModel in ipairs(meats) do
                            if meatModel:IsA("Model") and meatModel.Name == "Meat" and meatModel.PrimaryPart then
                                local distance = (meatModel.PrimaryPart.Position - humanoidRootPart.Position).Magnitude
                                if distance < shortestDistance then
                                    shortestDistance = distance
                                    nearestMeat = meatModel
                                end
                            end
                        end
                        
                        return nearestMeat
                    end
                    
                    local currentMeat = findNearestMeat()
                    while currentMeat and Options.AutoFarmMeatToggle.Value do
                        -- Check hunger and thirst levels
                        local player = game:GetService("Players").LocalPlayer
                        
                        -- Check and manage bread
                        if player.Status.Hunger.Value <= 10 then
                            -- Check if we have bread in inventory
                            if player.Inventory.Bread.Value <= 0 then
                                -- Buy bread if none available
                                game:GetService("ReplicatedStorage"):WaitForChild("Remote"):WaitForChild("Shop"):FireServer("BuyCash", "Bread", 1)
                                task.wait(0.5)
                            end
                            -- Use bread
                            game:GetService("ReplicatedStorage"):WaitForChild("Remote"):WaitForChild("Inventory"):FireServer("Use", "Bread")
                            task.wait(0.5)
                        end
                        
                        -- Check and manage water
                        if player.Status.Thirsty.Value <= 10 then
                            -- Check if we have water in inventory
                            if player.Inventory.Water.Value <= 0 then
                                -- Buy water if none available
                                game:GetService("ReplicatedStorage"):WaitForChild("Remote"):WaitForChild("Shop"):FireServer("BuyCash", "Water", 1)
                                task.wait(0.5)
                            end
                            -- Use water
                            game:GetService("ReplicatedStorage"):WaitForChild("Remote"):WaitForChild("Inventory"):FireServer("Use", "Water")
                            task.wait(0.5)
                        end

                        if not currentMeat.Parent then
                            currentMeat = findNearestMeat()
                            if not currentMeat then break end
                        end
                        
                        pcall(function()
                            -- Calculate position 5 studs above the meat (adjusted height)
                            local targetPos = currentMeat.PrimaryPart.Position + Vector3.new(0, 5, 0)
                            humanoidRootPart.CFrame = CFrame.new(targetPos)
                            
                            -- Smoothly move down to the meat
                            for i = 1, 20 do
                                local lerpPos = targetPos:Lerp(currentMeat.PrimaryPart.Position + Vector3.new(0, 1.5, 0), i/20)
                                humanoidRootPart.CFrame = CFrame.new(lerpPos)
                                task.wait(0.05)
                            end
                            
                            humanoidRootPart.Anchored = true
                        end)
                        
                        pcall(function()
                            local player = game:GetService("Players").LocalPlayer
                            if player and player:FindFirstChild("Inventory") and player.Inventory:FindFirstChild("Meat") then
                                if player.Inventory.Meat.Value >= 60 then
                                    game:GetService("ReplicatedStorage"):WaitForChild("Remote"):WaitForChild("Economy"):FireServer("Sell", "Meat", "30")
                                    task.wait(0.5)
                                end
                            end
                        end)
                        
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

    Options.AutoFarmMeatToggle:SetValue(false)

    local Section = Tabs.Main8:AddSection("Auto Farm Scrap")
    
    Tabs.Main8:AddParagraph({
        Title = "Scrap",
        Content = "Auto farm scrap resources"
    })
    
    local Toggle = Tabs.Main8:AddToggle("AutoFarmScrapToggle", {Title = "Auto Farm Scrap", Default = false })
    local Input = Tabs.Main8:AddInput("ScrapSize", {
        Title = "Scrap Size", 
        Default = "",
        Placeholder = "Enter scrap size (1-100)",
        Numeric = true,
        Finished = true,
        Callback = function(Value)
            -- Apply fixed size to all scraps
            local size = math.clamp(tonumber(Value) or 4, 1, 100) -- Already allows up to 100
            local scraps = workspace:FindFirstChild("Farm") and workspace.Farm:FindFirstChild("Scrap") and workspace.Farm.Scrap:FindFirstChild("FarmItem") and workspace.Farm.Scrap.FarmItem:GetChildren()
            if scraps then
                for _, scrapModel in ipairs(scraps) do
                    if scrapModel:IsA("Model") and scrapModel.Name == "Scrap" then
                        for _, part in pairs(scrapModel:GetDescendants()) do
                            if part:IsA("BasePart") then
                                -- Allow size up to 100x100x100
                                part.Size = Vector3.new(size, size, size)
                            end
                        end
                    end
                end
            end
        end
    })

    -- Add reset scrap size button
    Tabs.Main8:AddButton({
        Title = "Reset Scrap Size",
        Description = "Reset scraps to original size",
        Callback = function()
            Window:Dialog({
                Title = "Reset Scrap Size",
                Content = "Are you sure you want to reset all scraps to their original size?",
                Buttons = {
                    {
                        Title = "Confirm",
                        Callback = function()
                            local scraps = workspace:FindFirstChild("Farm") and workspace.Farm:FindFirstChild("Scrap") and workspace.Farm.Scrap:FindFirstChild("FarmItem") and workspace.Farm.Scrap.FarmItem:GetChildren()
                            if scraps then
                                for _, scrapModel in ipairs(scraps) do
                                    if scrapModel:IsA("Model") and scrapModel.Name == "Scrap" then
                                        for _, part in pairs(scrapModel:GetDescendants()) do
                                            if part:IsA("BasePart") then
                                                part.Size = Vector3.new(2.3870253562927246, 2.3870253562927246, 2.3870253562927246) -- Reset to fixed size
                                            end
                                        end
                                    end
                                end
                            end
                            Options.ScrapSize:SetValue("4")
                        end
                    },
                    {
                        Title = "Cancel",
                        Callback = function()
                            print("Scrap size reset cancelled")
                        end
                    }
                }
            })
        end
    })

    local isRunning = false
    
    Toggle:OnChanged(function()
        if Options.AutoFarmScrapToggle.Value then
            if isRunning then return end
            isRunning = true
            
            spawn(function()
                while Options.AutoFarmScrapToggle.Value do
                    local character = game.Players.LocalPlayer.Character
                    if not character then task.wait(1) continue end
                    
                    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                    if not humanoidRootPart then task.wait(1) continue end
                    
                    local scraps = workspace:FindFirstChild("Farm") and workspace.Farm:FindFirstChild("Scrap") and workspace.Farm.Scrap:FindFirstChild("FarmItem") and workspace.Farm.Scrap.FarmItem:GetChildren()
                    if not scraps then task.wait(1) continue end
                    
                    local function findNearestScrap()
                        local nearestScrap = nil
                        local shortestDistance = math.huge
                        
                        for _, scrapModel in ipairs(scraps) do
                            if scrapModel:IsA("Model") and scrapModel.Name == "Scrap" and scrapModel.PrimaryPart then
                                local distance = (scrapModel.PrimaryPart.Position - humanoidRootPart.Position).Magnitude
                                if distance < shortestDistance then
                                    shortestDistance = distance
                                    nearestScrap = scrapModel
                                end
                            end
                        end
                        
                        return nearestScrap
                    end
                    
                    local currentScrap = findNearestScrap()
                    while currentScrap and Options.AutoFarmScrapToggle.Value do
                        -- Check hunger and thirst levels
                        local player = game:GetService("Players").LocalPlayer
                        
                        -- Check and manage bread
                        if player.Status.Hunger.Value <= 10 then
                            -- Check if we have bread in inventory
                            if player.Inventory.Bread.Value <= 0 then
                                -- Buy bread if none available
                                game:GetService("ReplicatedStorage"):WaitForChild("Remote"):WaitForChild("Shop"):FireServer("BuyCash", "Bread", 1)
                                task.wait(0.5)
                            end
                            -- Use bread
                            game:GetService("ReplicatedStorage"):WaitForChild("Remote"):WaitForChild("Inventory"):FireServer("Use", "Bread")
                            task.wait(0.5)
                        end
                        
                        -- Check and manage water
                        if player.Status.Thirsty.Value <= 10 then
                            -- Check if we have water in inventory
                            if player.Inventory.Water.Value <= 0 then
                                -- Buy water if none available
                                game:GetService("ReplicatedStorage"):WaitForChild("Remote"):WaitForChild("Shop"):FireServer("BuyCash", "Water", 1)
                                task.wait(0.5)
                            end
                            -- Use water
                            game:GetService("ReplicatedStorage"):WaitForChild("Remote"):WaitForChild("Inventory"):FireServer("Use", "Water")
                            task.wait(0.5)
                        end

                        if not currentScrap.Parent then
                            currentScrap = findNearestScrap()
                            if not currentScrap then break end
                        end
                        
                        pcall(function()
                            -- Calculate position 10 studs above the scrap
                            local targetPos = currentScrap.PrimaryPart.Position + Vector3.new(0, 10, 0)
                            humanoidRootPart.CFrame = CFrame.new(targetPos)
                            
                            -- Smoothly move down to the scrap
                            for i = 1, 20 do
                                local lerpPos = targetPos:Lerp(currentScrap.PrimaryPart.Position + Vector3.new(0, 1.5, 0), i/20)
                                humanoidRootPart.CFrame = CFrame.new(lerpPos)
                                task.wait(0.05)
                            end
                            
                            humanoidRootPart.Anchored = true
                        end)
                        
                        pcall(function()
                            local player = game:GetService("Players").LocalPlayer
                            if player and player:FindFirstChild("Inventory") and player.Inventory:FindFirstChild("Scrap") then
                                if player.Inventory.Scrap.Value >= 60 then
                                    game:GetService("ReplicatedStorage"):WaitForChild("Remote"):WaitForChild("Economy"):FireServer("Sell", "Scrap", "30")
                                    task.wait(0.5)
                                end
                            end
                        end)
                        
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

    Options.AutoFarmScrapToggle:SetValue(false)

    local Section = Tabs.Main9:AddSection("Auto Farm Plastic")
    
    Tabs.Main9:AddParagraph({
        Title = "Plastic",
        Content = "Auto farm plastic resources"
    })
    
    local Toggle = Tabs.Main9:AddToggle("AutoFarmPlasticToggle", {Title = "Auto Farm Plastic", Default = false })
    local Input = Tabs.Main9:AddInput("PlasticSize", {
        Title = "Plastic Size", 
        Default = "",
        Placeholder = "Enter plastic size (1-100)",
        Numeric = true,
        Finished = true,
        Callback = function(Value)
            -- Apply fixed size to all plastics
            local size = math.clamp(tonumber(Value) or 4, 1, 100) -- Already allows up to 100
            local plastics = workspace:FindFirstChild("Farm") and workspace.Farm:FindFirstChild("Plastic") and workspace.Farm.Plastic:FindFirstChild("FarmItem") and workspace.Farm.Plastic.FarmItem:GetChildren()
            if plastics then
                for _, plasticModel in ipairs(plastics) do
                    if plasticModel:IsA("Model") and plasticModel.Name == "Plastic" then
                        for _, part in pairs(plasticModel:GetDescendants()) do
                            if part:IsA("BasePart") then
                                -- Allow size up to 100x100x100
                                part.Size = Vector3.new(size, size, size)
                            end
                        end
                    end
                end
            end
        end
    })

    -- Add reset plastic size button
    Tabs.Main9:AddButton({
        Title = "Reset Plastic Size",
        Description = "Reset plastics to original size",
        Callback = function()
            Window:Dialog({
                Title = "Reset Plastic Size",
                Content = "Are you sure you want to reset all plastics to their original size?",
                Buttons = {
                    {
                        Title = "Confirm",
                        Callback = function()
                            local plastics = workspace:FindFirstChild("Farm") and workspace.Farm:FindFirstChild("Plastic") and workspace.Farm.Plastic:FindFirstChild("FarmItem") and workspace.Farm.Plastic.FarmItem:GetChildren()
                            if plastics then
                                for _, plasticModel in ipairs(plastics) do
                                    if plasticModel:IsA("Model") and plasticModel.Name == "Plastic" then
                                        for _, part in pairs(plasticModel:GetDescendants()) do
                                            if part:IsA("BasePart") then
                                                part.Size = Vector3.new(1.5,1.5,1.5) -- Reset to fixed size
                                            end
                                        end
                                    end
                                end
                            end
                            Options.PlasticSize:SetValue("4")
                        end
                    },
                    {
                        Title = "Cancel",
                        Callback = function()
                            print("Plastic size reset cancelled")
                        end
                    }
                }
            })
        end
    })

    local isRunning = false
    
    Toggle:OnChanged(function()
        if Options.AutoFarmPlasticToggle.Value then
            if isRunning then return end
            isRunning = true
            
            spawn(function()
                while Options.AutoFarmPlasticToggle.Value do
                    local character = game.Players.LocalPlayer.Character
                    if not character then task.wait(1) continue end
                    
                    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                    if not humanoidRootPart then task.wait(1) continue end
                    
                    local plastics = workspace:FindFirstChild("Farm") and workspace.Farm:FindFirstChild("Plastic") and workspace.Farm.Plastic:FindFirstChild("FarmItem") and workspace.Farm.Plastic.FarmItem:GetChildren()
                    if not plastics then task.wait(1) continue end
                    
                    local function findNearestPlastic()
                        local nearestPlastic = nil
                        local shortestDistance = math.huge
                        
                        for _, plasticModel in ipairs(plastics) do
                            if plasticModel:IsA("Model") and plasticModel.Name == "Plastic" and plasticModel.PrimaryPart then
                                local distance = (plasticModel.PrimaryPart.Position - humanoidRootPart.Position).Magnitude
                                if distance < shortestDistance then
                                    shortestDistance = distance
                                    nearestPlastic = plasticModel
                                end
                            end
                        end
                        
                        return nearestPlastic
                    end
                    
                    local currentPlastic = findNearestPlastic()
                    while currentPlastic and Options.AutoFarmPlasticToggle.Value do
                        -- Check hunger and thirst levels
                        local player = game:GetService("Players").LocalPlayer
                        
                        -- Check and manage bread
                        if player.Status.Hunger.Value <= 10 then
                            -- Check if we have bread in inventory
                            if player.Inventory.Bread.Value <= 0 then
                                -- Buy bread if none available
                                game:GetService("ReplicatedStorage"):WaitForChild("Remote"):WaitForChild("Shop"):FireServer("BuyCash", "Bread", 1)
                                task.wait(0.5)
                            end
                            -- Use bread
                            game:GetService("ReplicatedStorage"):WaitForChild("Remote"):WaitForChild("Inventory"):FireServer("Use", "Bread")
                            task.wait(0.5)
                        end
                        
                        -- Check and manage water
                        if player.Status.Thirsty.Value <= 10 then
                            -- Check if we have water in inventory
                            if player.Inventory.Water.Value <= 0 then
                                -- Buy water if none available
                                game:GetService("ReplicatedStorage"):WaitForChild("Remote"):WaitForChild("Shop"):FireServer("BuyCash", "Water", 1)
                                task.wait(0.5)
                            end
                            -- Use water
                            game:GetService("ReplicatedStorage"):WaitForChild("Remote"):WaitForChild("Inventory"):FireServer("Use", "Water")
                            task.wait(0.5)
                        end

                        if not currentPlastic.Parent then
                            currentPlastic = findNearestPlastic()
                            if not currentPlastic then break end
                        end
                        
                        pcall(function()
                            -- Calculate position 10 studs above the plastic
                            local targetPos = currentPlastic.PrimaryPart.Position + Vector3.new(0, 10, 0)
                            humanoidRootPart.CFrame = CFrame.new(targetPos)
                            
                            -- Smoothly move down to the plastic
                            for i = 1, 20 do
                                local lerpPos = targetPos:Lerp(currentPlastic.PrimaryPart.Position + Vector3.new(0, 1.5, 0), i/20)
                                humanoidRootPart.CFrame = CFrame.new(lerpPos)
                                task.wait(0.05)
                            end
                            
                            humanoidRootPart.Anchored = true
                        end)
                        
                        pcall(function()
                            local player = game:GetService("Players").LocalPlayer
                            if player and player:FindFirstChild("Inventory") and player.Inventory:FindFirstChild("Plastic") then
                                if player.Inventory.Plastic.Value >= 60 then
                                    game:GetService("ReplicatedStorage"):WaitForChild("Remote"):WaitForChild("Economy"):FireServer("Sell", "Plastic", "30")
                                    task.wait(0.5)
                                end
                            end
                        end)
                        
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

    Options.AutoFarmPlasticToggle:SetValue(false)

    local Section = Tabs.Main10:AddSection("Auto Farm Wood")
    
    Tabs.Main10:AddParagraph({
        Title = "Wood",
        Content = "Auto farm wood resources"
    })
    
    local Toggle = Tabs.Main10:AddToggle("AutoFarmWoodToggle", {Title = "Auto Farm Wood", Default = false })
    local Input = Tabs.Main10:AddInput("WoodSize", {
        Title = "Wood Size", 
        Default = "",
        Placeholder = "Enter wood size (1-100)",
        Numeric = true,
        Finished = true,
        Callback = function(Value)
            -- Apply fixed size to all woods
            local size = math.clamp(tonumber(Value) or 4, 1, 100) -- Already allows up to 100
            local woods = workspace:FindFirstChild("Farm") and workspace.Farm:FindFirstChild("Wood") and workspace.Farm.Wood:FindFirstChild("FarmItem") and workspace.Farm.Wood.FarmItem:GetChildren()
            if woods then
                for _, woodModel in ipairs(woods) do
                    if woodModel:IsA("Model") and woodModel.Name == "Wood" then
                        for _, part in pairs(woodModel:GetDescendants()) do
                            if part:IsA("BasePart") then
                                -- Allow size up to 100x100x100
                                part.Size = Vector3.new(size, size, size)
                            end
                        end
                    end
                end
            end
        end
    })

    -- Add reset wood size button
    Tabs.Main10:AddButton({
        Title = "Reset Wood Size",
        Description = "Reset woods to original size",
        Callback = function()
            Window:Dialog({
                Title = "Reset Wood Size",
                Content = "Are you sure you want to reset all woods to their original size?",
                Buttons = {
                    {
                        Title = "Confirm",
                        Callback = function()
                            local woods = workspace:FindFirstChild("Farm") and workspace.Farm:FindFirstChild("Wood") and workspace.Farm.Wood:FindFirstChild("FarmItem") and workspace.Farm.Wood.FarmItem:GetChildren()
                            if woods then
                                for _, woodModel in ipairs(woods) do
                                    if woodModel:IsA("Model") and woodModel.Name == "Wood" then
                                        for _, part in pairs(woodModel:GetDescendants()) do
                                            if part:IsA("BasePart") then
                                                part.Size = Vector3.new(1.5,1.5,1.5) -- Reset to fixed size
                                            end
                                        end
                                    end
                                end
                            end
                            Options.WoodSize:SetValue("4")
                        end
                    },
                    {
                        Title = "Cancel",
                        Callback = function()
                            print("Wood size reset cancelled")
                        end
                    }
                }
            })
        end
    })

    local isRunning = false
    
    Toggle:OnChanged(function()
        if Options.AutoFarmWoodToggle.Value then
            if isRunning then return end
            isRunning = true
            
            spawn(function()
                while Options.AutoFarmWoodToggle.Value do
                    local character = game.Players.LocalPlayer.Character
                    if not character then task.wait(1) continue end
                    
                    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                    if not humanoidRootPart then task.wait(1) continue end
                    
                    local woods = workspace:FindFirstChild("Farm") and workspace.Farm:FindFirstChild("Wood") and workspace.Farm.Wood:FindFirstChild("FarmItem") and workspace.Farm.Wood.FarmItem:GetChildren()
                    if not woods then task.wait(1) continue end
                    
                    local function findNearestWood()
                        local nearestWood = nil
                        local shortestDistance = math.huge
                        
                        for _, woodModel in ipairs(woods) do
                            if woodModel:IsA("Model") and woodModel.Name == "Wood" and woodModel.PrimaryPart then
                                local distance = (woodModel.PrimaryPart.Position - humanoidRootPart.Position).Magnitude
                                if distance < shortestDistance then
                                    shortestDistance = distance
                                    nearestWood = woodModel
                                end
                            end
                        end
                        
                        return nearestWood
                    end
                    
                    local currentWood = findNearestWood()
                    while currentWood and Options.AutoFarmWoodToggle.Value do
                        -- Check hunger and thirst levels
                        local player = game:GetService("Players").LocalPlayer
                        
                        -- Check and manage bread
                        if player.Status.Hunger.Value <= 10 then
                            -- Check if we have bread in inventory
                            if player.Inventory.Bread.Value <= 0 then
                                -- Buy bread if none available
                                game:GetService("ReplicatedStorage"):WaitForChild("Remote"):WaitForChild("Shop"):FireServer("BuyCash", "Bread", 1)
                                task.wait(0.5)
                            end
                            -- Use bread
                            game:GetService("ReplicatedStorage"):WaitForChild("Remote"):WaitForChild("Inventory"):FireServer("Use", "Bread")
                            task.wait(0.5)
                        end
                        
                        -- Check and manage water
                        if player.Status.Thirsty.Value <= 10 then
                            -- Check if we have water in inventory
                            if player.Inventory.Water.Value <= 0 then
                                -- Buy water if none available
                                game:GetService("ReplicatedStorage"):WaitForChild("Remote"):WaitForChild("Shop"):FireServer("BuyCash", "Water", 1)
                                task.wait(0.5)
                            end
                            -- Use water
                            game:GetService("ReplicatedStorage"):WaitForChild("Remote"):WaitForChild("Inventory"):FireServer("Use", "Water")
                            task.wait(0.5)
                        end

                        if not currentWood.Parent then
                            currentWood = findNearestWood()
                            if not currentWood then break end
                        end
                        
                        pcall(function()
                            -- Calculate position 10 studs above the wood
                            local targetPos = currentWood.PrimaryPart.Position + Vector3.new(0, 10, 0)
                            humanoidRootPart.CFrame = CFrame.new(targetPos)
                            
                            -- Smoothly move down to the wood
                            for i = 1, 20 do
                                local lerpPos = targetPos:Lerp(currentWood.PrimaryPart.Position + Vector3.new(0, 1.5, 0), i/20)
                                humanoidRootPart.CFrame = CFrame.new(lerpPos)
                                task.wait(0.05)
                            end
                            
                            humanoidRootPart.Anchored = true
                        end)
                        
                        pcall(function()
                            local player = game:GetService("Players").LocalPlayer
                            if player and player:FindFirstChild("Inventory") and player.Inventory:FindFirstChild("Wood") then
                                if player.Inventory.Wood.Value >= 60 then
                                    game:GetService("ReplicatedStorage"):WaitForChild("Remote"):WaitForChild("Economy"):FireServer("Sell", "Wood", "30")
                                    task.wait(0.5)
                                end
                            end
                        end)
                        
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

    Options.AutoFarmWoodToggle:SetValue(false)

    local Section = Tabs.Main11:AddSection("Auto Farm Watermelon")
    
    Tabs.Main11:AddParagraph({
        Title = "Watermelon",
        Content = "Auto farm watermelon resources"
    })
    
    local Toggle = Tabs.Main11:AddToggle("AutoFarmWatermelonToggle", {Title = "Auto Farm Watermelon", Default = false })
    local Input = Tabs.Main11:AddInput("WatermelonSize", {
        Title = "Watermelon Size", 
        Default = "",
        Placeholder = "Enter watermelon size (1-100)",
        Numeric = true,
        Finished = true,
        Callback = function(Value)
            -- Apply fixed size to all watermelons
            local size = math.clamp(tonumber(Value) or 4, 1, 100) -- Already allows up to 100
            local watermelons = workspace:FindFirstChild("Farm") and workspace.Farm:FindFirstChild("Watermelon") and workspace.Farm.Watermelon:FindFirstChild("FarmItem") and workspace.Farm.Watermelon.FarmItem:GetChildren()
            if watermelons then
                for _, watermelonModel in ipairs(watermelons) do
                    if watermelonModel:IsA("Model") and watermelonModel.Name == "Watermelon" then
                        for _, part in pairs(watermelonModel:GetDescendants()) do
                            if part:IsA("BasePart") then
                                -- Allow size up to 100x100x100
                                part.Size = Vector3.new(size, size, size)
                            end
                        end
                    end
                end
            end
        end
    })

    -- Add reset watermelon size button
    Tabs.Main11:AddButton({
        Title = "Reset Watermelon Size",
        Description = "Reset watermelons to original size",
        Callback = function()
            Window:Dialog({
                Title = "Reset Watermelon Size",
                Content = "Are you sure you want to reset all watermelons to their original size?",
                Buttons = {
                    {
                        Title = "Confirm",
                        Callback = function()
                            local watermelons = workspace:FindFirstChild("Farm") and workspace.Farm:FindFirstChild("Watermelon") and workspace.Farm.Watermelon:FindFirstChild("FarmItem") and workspace.Farm.Watermelon.FarmItem:GetChildren()
                            if watermelons then
                                for _, watermelonModel in ipairs(watermelons) do
                                    if watermelonModel:IsA("Model") and watermelonModel.Name == "Watermelon" then
                                        for _, part in pairs(watermelonModel:GetDescendants()) do
                                            if part:IsA("BasePart") then
                                                part.Size = Vector3.new(1.5,1.5,1.5) -- Reset to fixed size
                                            end
                                        end
                                    end
                                end
                            end
                            Options.WatermelonSize:SetValue("4")
                        end
                    },
                    {
                        Title = "Cancel",
                        Callback = function()
                            print("Watermelon size reset cancelled")
                        end
                    }
                }
            })
        end
    })

    local isRunning = false
    
    Toggle:OnChanged(function()
        if Options.AutoFarmWatermelonToggle.Value then
            if isRunning then return end
            isRunning = true
            
            spawn(function()
                while Options.AutoFarmWatermelonToggle.Value do
                    local character = game.Players.LocalPlayer.Character
                    if not character then task.wait(1) continue end
                    
                    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                    if not humanoidRootPart then task.wait(1) continue end
                    
                    local watermelons = workspace:FindFirstChild("Farm") and workspace.Farm:FindFirstChild("Watermelon") and workspace.Farm.Watermelon:FindFirstChild("FarmItem") and workspace.Farm.Watermelon.FarmItem:GetChildren()
                    if not watermelons then task.wait(1) continue end
                    
                    local function findNearestWatermelon()
                        local nearestWatermelon = nil
                        local shortestDistance = math.huge
                        
                        for _, watermelonModel in ipairs(watermelons) do
                            if watermelonModel:IsA("Model") and watermelonModel.Name == "Watermelon" and watermelonModel.PrimaryPart then
                                local distance = (watermelonModel.PrimaryPart.Position - humanoidRootPart.Position).Magnitude
                                if distance < shortestDistance then
                                    shortestDistance = distance
                                    nearestWatermelon = watermelonModel
                                end
                            end
                        end
                        
                        return nearestWatermelon
                    end
                    
                    local currentWatermelon = findNearestWatermelon()
                    while currentWatermelon and Options.AutoFarmWatermelonToggle.Value do
                        -- Check hunger and thirst levels
                        local player = game:GetService("Players").LocalPlayer
                        
                        -- Check and manage bread
                        if player.Status.Hunger.Value <= 10 then
                            -- Check if we have bread in inventory
                            if player.Inventory.Bread.Value <= 0 then
                                -- Buy bread if none available
                                game:GetService("ReplicatedStorage"):WaitForChild("Remote"):WaitForChild("Shop"):FireServer("BuyCash", "Bread", 1)
                                task.wait(0.5)
                            end
                            -- Use bread
                            game:GetService("ReplicatedStorage"):WaitForChild("Remote"):WaitForChild("Inventory"):FireServer("Use", "Bread")
                            task.wait(0.5)
                        end
                        
                        -- Check and manage water
                        if player.Status.Thirsty.Value <= 10 then
                            -- Check if we have water in inventory
                            if player.Inventory.Water.Value <= 0 then
                                -- Buy water if none available
                                game:GetService("ReplicatedStorage"):WaitForChild("Remote"):WaitForChild("Shop"):FireServer("BuyCash", "Water", 1)
                                task.wait(0.5)
                            end
                            -- Use water
                            game:GetService("ReplicatedStorage"):WaitForChild("Remote"):WaitForChild("Inventory"):FireServer("Use", "Water")
                            task.wait(0.5)
                        end

                        if not currentWatermelon.Parent then
                            currentWatermelon = findNearestWatermelon()
                            if not currentWatermelon then break end
                        end
                        
                        pcall(function()
                            -- Calculate position 10 studs above the watermelon
                            local targetPos = currentWatermelon.PrimaryPart.Position + Vector3.new(0, 10, 0)
                            humanoidRootPart.CFrame = CFrame.new(targetPos)
                            
                            -- Smoothly move down to the watermelon
                            for i = 1, 20 do
                                local lerpPos = targetPos:Lerp(currentWatermelon.PrimaryPart.Position + Vector3.new(0, 1.5, 0), i/20)
                                humanoidRootPart.CFrame = CFrame.new(lerpPos)
                                task.wait(0.05)
                            end
                            
                            humanoidRootPart.Anchored = true
                        end)
                        
                        pcall(function()
                            local player = game:GetService("Players").LocalPlayer
                            if player and player:FindFirstChild("Inventory") and player.Inventory:FindFirstChild("Watermelon") then
                                if player.Inventory.Watermelon.Value >= 60 then
                                    game:GetService("ReplicatedStorage"):WaitForChild("Remote"):WaitForChild("Economy"):FireServer("Sell", "Watermelon", "30")
                                    task.wait(0.5)
                                end
                            end
                        end)
                        
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

    Options.AutoFarmWatermelonToggle:SetValue(false)

-- Addon -- 
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
