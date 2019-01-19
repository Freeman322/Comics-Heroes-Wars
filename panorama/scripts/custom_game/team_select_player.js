"use strict";

function GetPlayerStatus(id, steamid) {
    var value = CustomNetTables.GetTableValue("rating", "rating_pre_game")
    $.Msg(id)
    if (value && value[id]) {
        if (value[id]["premium"] == 0) {
            return ["", "user"]
        } else if (value[id]["premium"] == 1) {
            return [" Premium", "premium"]
        } else if (value[id]["premium"] == 10) {
            return ["  ☆The Creator", "creator"]
        } else if (value[id]["premium"] == -1) {
            return [" Banned", "ban"]
        }
    } else {
        return ["", "user"]
    }
}
//--------------------------------------------------------------------------------------------------
// Handeler for when the unssigned players panel is clicked that causes the player to be reassigned
// to the unssigned players team
//--------------------------------------------------------------------------------------------------
function OnLeaveTeamPressed() {
    Game.PlayerJoinTeam(5); // 5 == unassigned ( DOTA_TEAM_NOTEAM )
}


//--------------------------------------------------------------------------------------------------
// Update the contents of the player panel when the player information has been modified.
//--------------------------------------------------------------------------------------------------
function OnPlayerDetailsChanged() {
    var playerId = $.GetContextPanel().GetAttributeInt("player_id", -1);
    var playerInfo = Game.GetPlayerInfo(playerId);
    if (!playerInfo)
        return;
    var hTable = GetPlayerStatus(playerId, playerInfo.player_steamid)
    $("#PlayerName").text = playerInfo.player_name;
    $("#PlayerName").AddClass("user")
    $("#PlayerAvatar").steamid = playerInfo.player_steamid;

    $.GetContextPanel().SetHasClass("player_is_local", playerInfo.player_is_local);
    $.GetContextPanel().SetHasClass("player_has_host_privileges", playerInfo.player_has_host_privileges);
}


//--------------------------------------------------------------------------------------------------
// Entry point, update a player panel on creation and register for callbacks when the player details
// are changed.
//--------------------------------------------------------------------------------------------------
(function() {
    $.Schedule(0.35, OnPlayerDetailsChanged)
    $.RegisterForUnhandledEvent("DOTAGame_PlayerDetailsChanged", OnPlayerDetailsChanged);
})();