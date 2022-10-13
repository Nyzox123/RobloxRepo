repeat task.wait() until.GameId ~= 0

if Tayronne and Tayronne.Loaded then
    Tayronne.Utilities.UI:Notification({
        Title = "🎃 Tayronne Hub",
        Description = "Script already running!",
        Duration = 5
    }) return
end

local PlayerService = game:GetService("Players")
repeat task.wait() until PlayerService.LocalPlayer
local LocalPlayer = PlayerService.LocalPlayer
local LoadArgs = {...}

local function GetSupportedGame() local Game
    for Id,Info in pairs(Tayronne.Games) do
        if tostring(game.GameId) == Id then
            Game = Info break
        end
    end

    if not Game then
        return Tayronne.Games.Universal
    end return Game
end

local function Concat(Table,Separator) local String = ""
    for Index,Value in pairs(Table) do
        String = Index == #Table and String .. tostring(Value)
        or String .. tostring(Value) .. Separator
    end return String
end

local function GetScript(Script)
    return Tayronne.Debug and readfile("Tayronne/" .. Script .. ".lua")
    or game:HttpGetAsync(("%s/%s.lua"):format(Tayronne.Domain,Script))
end

local function LoadScript(Script)
    return loadstring(Tayronne.Debug and readfile("Tayronne/" .. Script .. ".lua")
    or game:HttpGetAsync(("%s/%s.lua"):format(Tayronne.Domain,Script)))()
end

getgenv().Tayronne = {
    Domain = "https://raw.githubusercontent.com/Nyzox123/RobloxRepo/main",
    Debug = LoadArgs[1],Game = "None",Loaded = false,Utilities = {},
    Games = {
        ["358276974"] = {
            Name = "Apocalypse Rising 2",
            Script = "Games/AR2"
        }
    }
}

Tayronne.Utilities.Misc = LoadScript("Utilities/Misc")
Tayronne.Utilities.UI = LoadScript("Utilities/UI")
Tayronne.Utilities.Drawing = LoadScript("Utilities/Drawing")

LocalPlayer.OnTeleport:Connect(function(State)
    if State == Enum.TeleportState.Started then
        local QueueOnTeleport = (syn and syn.queue_on_teleport) or queue_on_teleport
        QueueOnTeleport(([[local LoadArgs = {%s}
        loadstring(LoadArgs[1] and readfile("Tayronne/Loader.lua") or
        game:HttpGetAsync("%s/Loader.lua"))(unpack(LoadArgs))
        ]]):format(Concat(LoadArgs,","),Tayronne.Domain))
    end
end)

local SupportedGame = GetSupportedGame()
if SupportedGame then
    Tayronne.Game = SupportedGame.Name
    LoadScript(SupportedGame.Script)
    Tayronne.Utilities.UI:Notification({
        Title = "🎃 Tayronne Hub",
        Description = Tayronne.Game .. " loaded!",
        Duration = LoadArgs[2]
    }) Tayronne.Loaded = true
end