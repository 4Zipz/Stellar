--// Stellar - +1 Mine

local Module = {}

function Module:Init(UI)

    local ReplicatedStorage = game:GetService("ReplicatedStorage")

    local Remotes = ReplicatedStorage
        :WaitForChild("Remotes")
        :WaitForChild("Server")

    local ClickRemote = Remotes:WaitForChild("Click")
    local SellRemote = Remotes:WaitForChild("SellAllLoot")
    local RebirthRemote = Remotes:WaitForChild("Rebirth")

    local AutoClick = false
    local AutoSell = false
    local AutoRebirth = false

    local ClickDelay = 0.1
    local SellDelay = 1
    local RebirthDelay = 1

    local Window = UI:CreateWindow("+1 Mine")

    -- Automation
    local Automation = Window:AddTab("Automation")

    Automation:Toggle(
        "Auto Click",
        false,
        function(enabled)
            AutoClick = enabled
        end
    )

    Automation:Slider(
        "Click Speed",
        0.03,
        1,
        0.1,
        function(value)
            ClickDelay = value
        end
    )

    Automation:Toggle(
        "Auto Sell",
        false,
        function(enabled)
            AutoSell = enabled
        end
    )

    Automation:Slider(
        "Sell Delay",
        0.1,
        10,
        1,
        function(value)
            SellDelay = value
        end
    )

    Automation:Toggle(
        "Auto Rebirth",
        false,
        function(enabled)
            AutoRebirth = enabled
        end
    )

    Automation:Slider(
        "Rebirth Delay",
        0.1,
        10,
        1,
        function(value)
            RebirthDelay = value
        end
    )

    -- Player tab
    local PlayerTab = Window:AddTab("Player")

    PlayerTab:Button(
        "Reset Character",
        function()
            local character =
                game.Players.LocalPlayer.Character

            local humanoid =
                character and
                character:FindFirstChildOfClass("Humanoid")

            if humanoid then
                humanoid.Health = 0
            end
        end
    )

    Window:SelectTab("Automation")

    -- Auto Click
    task.spawn(function()
        while Window.Gui.Parent do

            if AutoClick then
                pcall(function()
                    ClickRemote:FireServer()
                end)

                task.wait(ClickDelay)
            else
                task.wait(0.1)
            end
        end
    end)

    -- Auto Sell
    task.spawn(function()
        while Window.Gui.Parent do

            if AutoSell then
                pcall(function()
                    SellRemote:FireServer()
                end)

                task.wait(SellDelay)
            else
                task.wait(0.1)
            end
        end
    end)

    -- Auto Rebirth
    task.spawn(function()
        while Window.Gui.Parent do

            if AutoRebirth then
                pcall(function()
                    local args = {
                        "Rebirth"
                    }

                    RebirthRemote:FireServer(unpack(args))
                end)

                task.wait(RebirthDelay)
            else
                task.wait(0.1)
            end
        end
    end)

end

return Module
