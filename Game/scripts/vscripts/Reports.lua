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
       stats.send_report(steam_id)
    end
end

Reports:OnInit()