--// Stellar Loader

local Games = {
    [74193805629461] = "PlusOneMine",
    [6872265039] = "BedWars",
}

local GameName = Games[game.PlaceId]

if not GameName then
    warn("[Stellar] Unsupported game: " .. tostring(game.PlaceId))
    return
end

local BaseURL =
    "https://raw.githubusercontent.com/4Zipz/Stellar/main/"

local function LoadFile(path)
    local url = BaseURL .. path

    local success, result = pcall(function()
        local source = game:HttpGet(url)
        local fn = loadstring(source)

        if not fn then
            error("loadstring failed for " .. path)
        end

        return fn()
    end)

    if not success then
        warn("[Stellar] Failed to load " .. path)
        warn(result)
        return nil
    end

    return result
end

-- Shared UI
local UI = LoadFile("UI.lua")

if not UI then
    return
end

-- Game module
local GameModule = LoadFile(
    "Games/" .. GameName .. "/Main.lua"
)

if not GameModule then
    return
end

GameModule:Init(UI)

print("[Stellar] Loaded " .. GameName)
