if Reports == nil then
  Reports = {}
  Reports.__index = Reports
end

REPORTED = {}

function Reports:OnInit()
    CustomGameEventManager:RegisterListener("report_sended", Dynamic_Wrap(Reports, 'OnSendReport'))

    Convars:RegisterCommand( "try_send_reports", Dynamic_Wrap(Reports, 'OnTestReport'), "Test", FCVAR_CHEAT )
    Convars:RegisterCommand( "try_get_reports", Dynamic_Wrap(Reports, 'OnTestReportGet'), "Test", FCVAR_CHEAT )
end

function Reports:OnSendReport(params)
    local emiter = params["playerID"]
    local target = params["victimID"]
    if REPORTED[emiter] then
        return 
    end
    REPORTED[emiter] = true
    local steam_id = PlayerResource:GetSteamAccountID(target)
    if PlayerResource:IsValidPlayerID(target) and steam_id ~= 0 then
        _G.REPORTS[target] = ( _G.REPORTS[target] or {})
        _G.REPORTS[target].steam_id = _G.REPORTS[target].steam_id or steam_id
        _G.REPORTS[target].reports = (_G.REPORTS[target].reports or 0) + 1
    end
end

function Reports:OnTestReport(params)
    Stats:SendReportsData()
end

function Reports:OnTestReportGet(params)
    DeepPrintTable(_G.REPORTS)
end