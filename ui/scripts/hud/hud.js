
var playerData = {}

function OnDiscovered(data)
{
    $("#DiscoverText").SetHasClass("Hidden", false)
    $("#DiscoverText").AddClass("animation")
    
    $("#DiscoverText").text = $.Localize("Event_Discovered") + data.area

    Game.EmitSound("Event.AreaDiscovered")

    $.Schedule( 5, function() {
        $("#DiscoverText").SetHasClass("Hidden", true)
        $("#DiscoverText").RemoveClass("animation")
    });
}

function OnExpUpdated(data)
{
    $("#ExpText").text = $.Localize("Event_Exp") + data.exp
}

function OnEscape(data)
{
    var time = data.time;

    $("#EscapeText").SetHasClass("Hidden", false)
    $("#EscapeText").AddClass("animationEscape")
    
    $("#EscapeText").text = $.Localize("Event_Escape") + time + " sec"

    $.Schedule( 0.85, function() {
        $("#EscapeText").SetHasClass("Hidden", true)
        $("#EscapeText").RemoveClass("animation")
    });
}

function OnEscapeDone()
{
    $("#EscapeText").SetHasClass("Hidden", false)
    
    $("#EscapeText").text = $.Localize("Event_EscapeDone")

    $.Schedule( 5, function() {
        $("#EscapeText").SetHasClass("Hidden", true)
    });
}

function OnEventStateChanged(table_name, key, data) {
    var exp = data[Game.GetLocalPlayerID()]["exp"] || 0

    $("#ExpText").text = $.Localize("Event_Exp") + exp
}

function OnBossKilled(data)
{
    var bossName = data.name;

    $.Msg(bossName)

    $("#EscapeText").SetHasClass("Hidden", false)
    
    $("#EscapeText").text = $.Localize(bossName) + " is dead!"

    $.Schedule( 5, function() {
        $("#EscapeText").SetHasClass("Hidden", true)
    });
}

function UpdatePickState() {
    var data = CustomNetTables.GetTableValue("event", "players")
    var exp = data[Game.GetLocalPlayerID()]["exp"]

    $("#ExpText").text = $.Localize("Event_Exp") + exp
}

function OnOpenBook()
{
    $("#Book").SetHasClass("Hidden", !$("#Book").BHasClass("Hidden"))
}

function GetPlayerData()
{
    var player = Game.GetPlayerInfo( Game.GetLocalPlayerID() )

    $("#PlayerName").text = player.player_name
    $("#PlayerAvatar").steamid = player.player_steamid

    ///{"player_id":0,"player_name":"Freeman","player_connection_state":2,"player_steamid":"76561198047935884","player_kills":0,"player_deaths":0,"player_assists":0,"player_selected_hero_id":201,"player_selected_hero":"npc_dota_hero_thief","player_selected_hero_entity_index":353,"possible_hero_selection":"","player_level":1,"player_respawn_seconds":-1,"player_gold":600,"player_team_id":2,"player_is_local":true,"player_has_host_privileges":true}
}

function OnBuyHero(id)
{
    GameEvents.SendCustomGameEventToServer("on_buy_hero", {hero_id: id});
}

(function()
{
    GameEvents.Subscribe( "on_area_discovered", OnDiscovered );
    GameEvents.Subscribe( "on_exp_updated", OnExpUpdated );
    GameEvents.Subscribe( "on_escape", OnEscape );
    GameEvents.Subscribe( "on_escape_done", OnEscapeDone );
    GameEvents.Subscribe( "on_boss_killed", OnBossKilled );


    CustomNetTables.SubscribeNetTableListener("event", OnEventStateChanged);

    GetPlayerData();
})();
