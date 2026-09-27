local Games = {
    -- +1 Mine
    [74193805629461] = "PlusOneMine",

    -- BedWars
    [6872265039] = "BedWars",
}

local GameName = Games[game.PlaceId]

if not GameName then
    warn("[Stellar] This game is not supported.")
    return
end

print("[Stellar] Loading: " .. GameName)

local URL =
    "https://raw.githubusercontent.com/4Zipz/Stellar/main/Games/"
    .. GameName
    .. ".lua"

local Success, Result = pcall(function()
    return loadstring(game:HttpGet(URL))()
end)

if not Success then
    warn("[Stellar] Failed to load " .. GameName)
    warn(Result)
end
