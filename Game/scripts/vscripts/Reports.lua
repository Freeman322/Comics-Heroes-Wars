if Reports == nil then
    Reports = {}
    Reports.__index = Reports
end

REPORTED = {}

function Reports:OnInit()
    CustomGameEventManager:RegisterListener("player_reported", Dynamic_Wrap(Reports, 'OnSendReport'))
end

function Reports:OnSendReport(params)
    local emiter = params["playerID"]
    local target = params["reportedPlayerID"]

    if REPORTED[emiter] then
        return 
    end

    REPORTED[emiter] = true

    local steam_id = PlayerResource:GetSteamAccountID(target)

    if PlayerResource:IsValidPlayerID(target) and steam_id ~= 0 then
       stats.send_report(steam_id, target)

       local playerName = tostring(PlayerResource:GetPlayerName(tonumber(target)))
       
       local msg =  playerName .. " has been reported! (Thanks for keeping order)"
       GameRules:SendCustomMessage(msg, 0, 0)
    end
end

Reports:OnInit()