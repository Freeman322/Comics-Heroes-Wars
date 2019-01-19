function VerifyClient() {
    if (getClientStatus(Players.GetLocalPlayer()) == CLIENT_STATUS_RESTRICTED)
    {
        $("#GlobalPanel").BLoadLayout("file://{resources}/layout/custom_game/ban.xml", false, false);
    }
}

function OnStatsStateChanged(table_name, key, data)
{
    if (key == "stats") { VerifyClient() }
}

(function() {
    CustomNetTables.SubscribeNetTableListener("players", OnStatsStateChanged);

    VerifyClient()
})()
