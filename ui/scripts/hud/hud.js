
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

    UpdateBookData()
}

function UpdateBookData() {
    var payload = {
        "type": 3,
        "data": GetPlayerSteamID3()
    }
    $.AsyncWebRequest('http://pggames.pw/games/chw/src/Event/Event.php', {
        type: 'POST',
        data: { payload: JSON.stringify(payload) },
        success: function(data) {
            var respounce = JSON.parse(data)
            
            $("#PlayerExp").text = $.Localize("Event_Points") + respounce.exp
            $("#PlayerWins").text = $.Localize("Event_Wins") + respounce.wins
            $("#PlayerDeaths").text = $.Localize("Event_Deaths") + respounce.death
        }
    });
}


function OnBooksCombined()
{
    Game.EmitSound("Event.Escaped")

    $("#EscapeText").SetHasClass("Hidden", false)
    
    $("#EscapeText").text = $.Localize("Event_Books_Combined")

    $.Schedule( 5, function() {
        $("#EscapeText").SetHasClass("Hidden", true)
    });
}

function GetPlayerData()
{
    var player = Game.GetPlayerInfo( Game.GetLocalPlayerID() )

    $("#PlayerName").text = player.player_name
    $("#PlayerAvatar").steamid = player.player_steamid
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
    GameEvents.Subscribe( "on_books_combined", OnBooksCombined );

    CustomNetTables.SubscribeNetTableListener("event", OnEventStateChanged);

    GetPlayerData();
})();
