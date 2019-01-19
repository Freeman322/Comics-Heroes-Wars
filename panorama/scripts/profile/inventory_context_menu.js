"use strict";
var Globals = [];
var HTTP_CONTEXT_PUTON = 0;
var HTTP_CONTEXT_REMOVE = 1;
var HTTP_CONTEXT_DELETE = 2;

function OnPutOn() {
    var context = $.GetContextPanel()
    var item = context.item
    var item_id = context.item_id
    var hero = context.hero
    var steam_id = GetSteamID32()
    var isPutUp = context.value
    var isMedal = context.medal
    var parent = context.parent
    var core = context.core_panel
    var def_id = context.def_id
    if (isPutUp == 0) {
        var child = parent.FindChildrenWithClassTraverse("item_selection")
        child[0].RemoveClass("Disabled")
        SendHTTPRequest(item_id, steam_id, isPutUp, HTTP_CONTEXT_PUTON, isMedal, def_id)
    }
    $.DispatchEvent("DismissAllContextMenus")

    CheckConflicts(core, def_id, item_id)
}

function CheckConflicts(panel, thisItem, thisItemID) {
    var econs = GameUI.CustomUIConfig().Items
    var steam_id = GetSteamID32()

    for (var v = 0; v < panel.GetChildCount(); v++) {
        var item = panel.GetChild(v)
        var item_id = item.item_id
        var def_id = item.def_id
        var is_medal = item.medal
        var isPutUp = item.value
        if (item_id != thisItemID) {
            if ((econs[def_id]['hero'] == econs[thisItem]['hero'] && (econs[def_id]['slot'] == econs[thisItem]['slot'] || (econs[thisItem]['slot'] == "global" || econs[def_id]['slot'] == "global"))) || (def_id == thisItem)) {
                SendHTTPRequest(item_id, steam_id, isPutUp, HTTP_CONTEXT_REMOVE, is_medal, def_id)
            }
        }
    }
}

function OnRemove() {
    var context = $.GetContextPanel()
    var item = context.item
    var item_id = context.item_id
    var hero = context.hero
    var isMedal = context.medal
    var steam_id = GetSteamID32()
    var isPutUp = context.value
    var parent = context.parent
    var def_id = context.def_id
    if (isPutUp == 1) {
        var child = parent.FindChildrenWithClassTraverse("item_selection")
        child[0].AddClass("Disabled")
        SendHTTPRequest(item_id, steam_id, isPutUp, HTTP_CONTEXT_REMOVE, isMedal, def_id)
    }
    $.DispatchEvent("DismissAllContextMenus")
}

function OnDelete() {
    var context = $.GetContextPanel()
    var item = context.item
    var item_id = context.item_id
    var hero = context.hero
    var steam_id = GetSteamID32()
    var isPutUp = context.value
    var parent = context.parent
    var def_id = context.def_id
    var rarity = Globals.econs[def_id]['rarity']

    if (rarity <= 7){
      var data = [item_id]
      GameEvents.SendCustomGameEventToServer("on_item_deleted", data);
    }else {
        GameEvents.SendEventClientSide("dota_hud_error_message", {
            "splitscreenplayer": 0,
            "reason": 80,
            "message": "You cannot delete item of that kind rarity!"
        })
    }
    $.DispatchEvent("DismissAllContextMenus")
}

function GetSteamID32() {
    var playerInfo = Game.GetPlayerInfo(Game.GetLocalPlayerID());

    var steamID64 = playerInfo.player_steamid,
        steamIDPart = Number(steamID64.substring(3)),
        steamID32 = String(steamIDPart - 61197960265728);

    return steamID32;
}

function SendHTTPRequest(item, steam_id, isPutUp, requesType, isMedal, def_id) {
    var payload = {
        type: 6,
        data: [requesType, steam_id, item, isMedal, def_id]
    };

    $.AsyncWebRequest('http://82.146.43.107', {
        type: 'POST',
        data: { payload: JSON.stringify(payload) },
        success: function(data) { $.Msg(data) }
    });

    $.Msg(isMedal)

    var item_data = {
        "item": item,
        "isRemove": !!requesType,
        "steam_id": steam_id
    }
    GameEvents.SendCustomGameEventToServer("on_cosmetic_item_changed", item_data);
}

(function() {
    var PlayerTables = GameUI.CustomUIConfig().PlayerTables;
    var econs = PlayerTables.GetTableValue("globals", "econs")
    Globals.econs = econs
})();
