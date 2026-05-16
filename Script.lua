local function s()
    repeat task.wait() until game:IsLoaded()

    local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

    local plr = game:GetService("Players").LocalPlayer
    local playerGui = plr:WaitForChild("PlayerGui")
    local hotbar = playerGui:WaitForChild("PlayerMain"):WaitForChild("Dark"):WaitForChild("Hotbar")

    local autokill = false
    local autoGTBB = false
    local autoCODE = false
    local autoFarmLoop = false
    local antiAFK = false
    local HealPercent = 30
    local slotModes = {}
    local attackPriority = {}
    local healPriority = {}
    local currentTheme = "Default"

    local lastUseTime = {}
    for i = 1, 8 do
        slotModes[i] = "Attack"
        lastUseTime[i] = 0
    end

    local SPAWN_POS = CFrame.new(-24.3, 128, 101.3)

    local function teleportToSafePosition()
        pcall(function()
            if not plr.Character then return end
            local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            hrp.CFrame = SPAWN_POS
        end)
    end

    local function getToolInHotbar(slot)
        local function scan(container)
            for _, tool in pairs(container:GetChildren()) do
                if tool:IsA("Tool") and tool:FindFirstChild("Hotbar") then
                    if tool.Hotbar.Value == slot then return tool end
                end
            end
            return nil
        end
        return scan(plr.Backpack) or (plr.Character and scan(plr.Character))
    end

    local function isReady(slot)
        local ui = hotbar:FindFirstChild(tostring(slot))
        if not ui then return false end
        local tl = ui:FindFirstChild("TextLabel")
        if not tl then return false end
        local c = tl.TextColor3
        return c.R > 0.9 and c.G > 0.9 and c.B > 0.9
    end

    local function getArena()
        for _, v in pairs(workspace.ActiveBosses:GetChildren()) do
            if v:IsA("Folder") and v:FindFirstChild("Tags") and v.Tags:FindFirstChild(plr.Name) then return v end
        end
    end

    local function getLowest(f)
        local l = math.huge
        for _, v in pairs(f:GetChildren()) do
            local n = tonumber(v.Name)
            local m = v:FindFirstChildWhichIsA("Model")
            if n and m and m:FindFirstChild("Enemy") and m.Enemy.Health > 0 and n < l then l = n end
        end
        return l ~= math.huge and l or nil
    end

    local function usePortal(name)
        pcall(function()
            local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            local portals = workspace:FindFirstChild("Portals")
            if portals and portals:FindFirstChild(name) and portals[name]:FindFirstChild("Head") then
                hrp.CFrame = portals[name].Head.CFrame
            end
        end)
    end

    local function getBBTR()
        pcall(function()
            local lv = plr:WaitForChild("leaderstats"):WaitForChild("LV").Value
            local rt = plr.leaderstats:FindFirstChild("Reset") and plr.leaderstats.Reset.Value or 0
            if lv >= 5500 then usePortal("outersans tel")
            elseif lv >= 4900 then usePortal("Hyperdustsans tel")
            elseif lv >= 3985 then usePortal("Bob tel")
            elseif lv >= 3545 then usePortal("Dog tel")
            elseif lv >= 3045 then usePortal("Temmie tel")
            elseif lv >= 1600 and rt >= 5 then usePortal("Ultraundyne tel")
            elseif lv >= 305 and rt >= 7 then usePortal("Sus tel")
            elseif lv >= 200 and rt >= 1 then usePortal("Errorsans tel")
            elseif lv >= 175 then usePortal("UFUndyne tel")
            elseif lv >= 150 then usePortal("UFPapyrus tel")
            elseif lv >= 125 then usePortal("UFMettaton tel")
            elseif lv >= 100 then usePortal("UFToriel tel")
            elseif lv >= 90 then usePortal("Frisk tel")
            elseif lv >= 80 then usePortal("Omega flowey tel")
            elseif lv >= 65 then usePortal("Chara tel")
            elseif lv >= 50 then usePortal("Asriel tel")
            elseif lv >= 10 then usePortal("Undying Undyne tel")
            elseif lv >= 5 then usePortal("Papyrus tel")
            elseif lv >= 2 then usePortal("Toriel tel")
            elseif lv >= 1 then usePortal("Flowey tel")
            end
        end)
    end

    local function useSlot(slot)
        local tool = getToolInHotbar(slot)
        if not tool then return false end
        if not isReady(slot) then return false end

        local character = plr.Character
        if not character then return false end
        local humanoid = character:FindFirstChild("Humanoid")
        if not humanoid then return false end

        humanoid:EquipTool(tool)
        tool:Activate()
        humanoid:UnequipTools()
        lastUseTime[slot] = tick()
        return true
    end

    task.wait(1)

    local Window = Rayfield:CreateWindow({
        Name = "Unweavering Soul Script",
        Icon = 0,
        LoadingTitle = "Loading...",
        LoadingSubtitle = "By Sbadt",
        Theme = currentTheme,
        DisableRayfieldPrompts = false,
        DisableBuildWarnings = false,

        ConfigurationSaving = {
            Enabled = true,
            FolderName = "1Custom",
            FileName = "Config"
        },

        Discord = {
            Enabled = false,
            Invite = "",
            RememberJoins = true
        },

        KeySystem = false,
        KeySettings = {
            Title = "Untitled",
            Subtitle = "Key System",
            Note = "No method of obtaining the key is provided",
            FileName = "Key",
            SaveKey = true,
            GrabKeyFromSite = false,
            Key = {"Hello"}
        }
    })

    local AutoFarmTab = Window:CreateTab("AutoFarm")
    local StuffTab = Window:CreateTab("Stuff")
    local SettingsTab = Window:CreateTab("Settings")

    Rayfield:Notify({
        Title = "Script Loaded",
        Content = "V.0.5 - Slot wait + Spawn Fix",
        Duration = 2.5,
        Image = "rewind",
    })

    local StatusLabel
    pcall(function() StatusLabel = AutoFarmTab:CreateLabel("Status: Idle", "rewind") end)

    AutoFarmTab:CreateToggle({
        Name = "Autokill",
        CurrentValue = false,
        Flag = "Autokill",
        Callback = function(Value)
            autokill = Value
            if StatusLabel then StatusLabel:Set("Status: " .. (Value and "Farming" or "Idle"), "rewind") end
            if not Value then
                teleportToSafePosition()
            end
        end,
    })

    AutoFarmTab:CreateToggle({
        Name = "Auto GTBB",
        CurrentValue = false,
        Flag = "AutoGTBB",
        Callback = function(Value) autoGTBB = Value end,
    })

    AutoFarmTab:CreateToggle({
        Name = "Auto C.O.D.E",
        CurrentValue = false,
        Flag = "AutoCODE",
        Callback = function(Value) autoCODE = Value end,
    })

    AutoFarmTab:CreateToggle({
        Name = "Anti-AFK",
        CurrentValue = false,
        Flag = "AntiAFK",
        Callback = function(Value) antiAFK = Value end,
    })

    AutoFarmTab:CreateToggle({
        Name = "Auto Farm Loop",
        CurrentValue = false,
        Flag = "AutoFarmLoop",
        Callback = function(Value) autoFarmLoop = Value end,
    })

    AutoFarmTab:CreateSlider({
        Name = "Heal At Percent",
        Range = {1, 100},
        Increment = 1,
        Suffix = "%",
        CurrentValue = 30,
        Flag = "HealPercent",
        Callback = function(Value) HealPercent = Value end,
    })

    for i = 1, 8 do
        AutoFarmTab:CreateDropdown({
            Name = "Slot " .. i .. " Mode",
            Options = {"Disabled", "Attack", "Heal"},
            CurrentOption = {"Attack"},
            Flag = "SlotMode" .. i,
            Callback = function(selected)
                slotModes[i] = selected[1]
            end,
        })
    end

    AutoFarmTab:CreateLabel("Attack Priority (örnek: 1,2,3,4,5,6,7,8)", "rewind")
    pcall(function()
        AutoFarmTab:CreateInput({
            Name = "Attack Priority",
            CurrentValue = "1,2,3,4,5,6,7,8",
            RemoveTextAfterFocusLost = false,
            Flag = "AttackPriority",
            Callback = function(Text)
                attackPriority = {}
                for num in Text:gmatch("%d+") do
                    table.insert(attackPriority, tonumber(num))
                end
            end,
        })
    end)

    AutoFarmTab:CreateLabel("Heal Priority (örnek: 4,5)", "rewind")
    pcall(function()
        AutoFarmTab:CreateInput({
            Name = "Heal Priority",
            CurrentValue = "4,5",
            RemoveTextAfterFocusLost = false,
            Flag = "HealPriority",
            Callback = function(Text)
                healPriority = {}
                for num in Text:gmatch("%d+") do
                    table.insert(healPriority, tonumber(num))
                end
            end,
        })
    end)

    local StatsLabel, BossLabel
    pcall(function()
        StatsLabel = StuffTab:CreateLabel("LV: -- | Reset: -- | Farm Time: 0m 00s", "rewind")
        BossLabel = StuffTab:CreateLabel("Current Boss: None", "rewind")
    end)

    local Themes = {
        ["Default"] = "Default",
        ["Amber Glow"] = "AmberGlow",
        ["Amethyst"] = "Amethyst",
        ["Bloom"] = "Bloom",
        ["Dark Blue"] = "DarkBlue",
        ["Green"] = "Green",
        ["Light"] = "Light",
        ["Ocean"] = "Ocean",
        ["Serenity"] = "Serenity"
    }

    pcall(function()
        SettingsTab:CreateDropdown({
            Name = "Change Theme",
            Options = {"Default", "Amber Glow", "Amethyst", "Bloom", "Dark Blue", "Green", "Light", "Ocean", "Serenity"},
            CurrentOption = currentTheme,
            Flag = "ThemeSelection",
            Callback = function(Selected)
                local ident = Themes[Selected[1]]
                Window.ModifyTheme(ident)
                currentTheme = Selected[1]
            end,
        })
    end)

    pcall(function()
        SettingsTab:CreateButton({
            Name = "Unload the Script",
            Callback = function()
                Rayfield:Destroy()
            end,
        })
    end)

    task.spawn(function()
        local farmTime = 0
        while true do
            task.wait(1)
            pcall(function()
                local lv = plr.leaderstats:FindFirstChild("LV")
                local rt = plr.leaderstats:FindFirstChild("Reset")
                local lvVal = lv and lv.Value or 0
                local rtVal = rt and rt.Value or 0

                local content = string.format("LV: %d\nReset: %d\nFarm Time: %dm %02ds",
                    lvVal, rtVal, math.floor(farmTime / 60), farmTime % 60)

                if StatsLabel then StatsLabel:Set(content, "rewind") end

                if antiAFK then farmTime = farmTime + 1 end

                local arena = getArena()
                if arena and arena:FindFirstChild("Bosses") then
                    local bid = getLowest(arena.Bosses)
                    if BossLabel then BossLabel:Set(bid and ("Current Boss: #" .. bid) or "Current Boss: None", "rewind") end
                else
                    if BossLabel then BossLabel:Set("Current Boss: None", "rewind") end
                end
            end)
        end
    end)

    task.spawn(function()
        while task.wait(8) do
            if antiAFK and plr.Character then
                local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    hrp.CFrame = hrp.CFrame * CFrame.new(0, 0.1, 0)
                    task.wait(0.1)
                    hrp.CFrame = hrp.CFrame * CFrame.new(0, -0.1, 0)
                end
            end
        end
    end)

    game:GetService("RunService").Heartbeat:Connect(function()
        if not plr.Character then return end
        local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
        local humanoid = plr.Character:FindFirstChild("Humanoid")
        if not hrp or not humanoid then return end

        if autoGTBB then
            pcall(function()
                if plr.Character:FindFirstChild("OnCombat") and plr.Character.OnCombat.Value == false then
                    getBBTR()
                end
            end)
        end

        if autoCODE then
            pcall(function()
                if plr.Backpack:FindFirstChild("C.O.D.E") and not plr.Character:FindFirstChild("C.O.D.E Boosts") then
                    humanoid:UnequipTools()
                    task.wait(1)
                    local tool = plr.Backpack["C.O.D.E"]
                    humanoid:EquipTool(tool)
                    task.wait(0.1)
                    tool:Activate()
                    humanoid:UnequipTools()
                end
            end)
        end

        if autokill then
            local arena = getArena()
            if not arena or not arena:FindFirstChild("Bosses") then return end
            local bossId = getLowest(arena.Bosses)
            if not bossId then return end
            local bossFolder = arena.Bosses:FindFirstChild(tostring(bossId))
            if not bossFolder then return end
            local boss = bossFolder:FindFirstChildWhichIsA("Model")
            if not boss or not boss.PrimaryPart then return end

            local targetPos = boss.PrimaryPart.Position + Vector3.new(8, 3, 8)
            hrp.CFrame = CFrame.lookAt(targetPos, boss.PrimaryPart.Position)
        end
    end)

    task.spawn(function()
        while task.wait() do
            while autokill do
                local arena = getArena()
                if not arena or not arena:FindFirstChild("Bosses") then
                    if autoFarmLoop then
                        getBBTR()
                        task.wait(5)
                    else
                        task.wait(1)
                    end
                    continue
                end

                local bossId = getLowest(arena.Bosses)
                if not bossId then
                    task.wait(1)
                    continue
                end

                local character = plr.Character
                local humanoid = character and character:FindFirstChild("Humanoid")
                if not humanoid then task.wait(0.5); continue end

                local needHeal = humanoid.Health <= (humanoid.MaxHealth / 100) * HealPercent

                if needHeal then
                    local healOrder = {}
                    if #healPriority > 0 then
                        healOrder = healPriority
                    else
                        for s = 1, 8 do
                            if slotModes[s] == "Heal" then table.insert(healOrder, s) end
                        end
                    end

                    for _, slot in ipairs(healOrder) do
                        if not autokill then break end
                        if slotModes[slot] ~= "Heal" then continue end

                        local waited = 0
                        while autokill and not isReady(slot) and waited < 1 do
                            task.wait(0.1)
                            waited = waited + 0.1
                        end
                        if not autokill then break end
                        if not isReady(slot) then continue end

                        useSlot(slot)
                        task.wait(0.15)
                        break
                    end
                end

                local order = #attackPriority > 0 and attackPriority or {1, 2, 3, 4, 5, 6, 7, 8}

                for _, slot in ipairs(order) do
                    if not autokill then break end
                    if slotModes[slot] ~= "Attack" then continue end

                    local waited = 0
                    local maxWait = 0.5 + math.random() * 0.5
                    while autokill and not isReady(slot) and waited < maxWait do
                        task.wait(0.1)
                        waited = waited + 0.1
                    end
                    if not autokill then break end
                    if not isReady(slot) then continue end

                    useSlot(slot)
                    task.wait(0.15)
                end

                if not autoFarmLoop then break end
                task.wait(2)
            end
        end
    end)

    Rayfield:LoadConfiguration()
end

s()
