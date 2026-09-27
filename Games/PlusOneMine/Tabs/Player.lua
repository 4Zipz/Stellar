--// +1 Mine - Player

local Player = {}

function Player:Load(Tab)

    Tab:Button("Reset Character", function()

        local Players = game:GetService("Players")
        local Character = Players.LocalPlayer.Character

        if not Character then
            return
        end

        local Humanoid =
            Character:FindFirstChildOfClass("Humanoid")

        if Humanoid then
            Humanoid.Health = 0
        end

    end)

end

return Player
