var rating_table = [
    "silver_1",
    "silver_2",
    "silver_3",
    "silver_4",
    "silver_5",
    "silver_6",
    "nova_1",
    "nova_2",
    "nova_3",
    "nova_4",
    "master_1",
    "master_2",
    "master_3",
    "master_4",
    "eagle_1",
    "eagle_2",
    "general_master_1",
    "general_master_2",
    "supreme_master_1",
    "supreme_master_2",
];

(function() {
    SetupProfile()
})();

function OnInspectMedal(value, panel) {
    $.DispatchEvent("DOTAShowTextTooltip", panel, "#" + value);
}

function OnInspectMedalOver(value, panel) {
    $.DispatchEvent("DOTAHideTextTooltip", panel);
}

function ItemShowTooltip() {
    $.DispatchEvent("UIShowCustomLayoutTooltip", $("#ItemEcon"), "TestTooltip", "file://{resources}/layout/custom_game/tooltips/econ_tooltip.xml") ///Players.GetPlayerHeroEntityIndex( Players.GetLocalPlayer() ))
}

function ItemHideTooltip() {
    $.DispatchEvent("UIHideCustomLayoutTooltip", $("#ItemEcon"), "TestTooltip")
}


function OnInspect(value, panel) {
    $.DispatchEvent("DOTAShowTextTooltip", panel, "#" + value);
}

function OnInspectOver(value, panel) {
    $.DispatchEvent("DOTAHideTextTooltip", panel);
}

function OnInspectHeroStart(hero, panel) {
    $.DispatchEvent("DOTAShowTitleImageTextTooltip", panel, "#new_" + hero, "file://{images}/custom_game/heroes/" + hero + ".png", "#new_" + hero + "_hype");
}

function OnInspectHeroOver(hero, panel) {
    $.DispatchEvent("DOTAHideTitleImageTextTooltip", panel);
}

function OnTooltipStart(name, panel) {
    $.DispatchEvent("DOTAShowAbilityTooltip", panel, name)
}

function OnTooltipOver(name, panel) {
    $.DispatchEvent("DOTAHideAbilityTooltip", panel);
}

function SetupProfile() {
    $("#PlayerName").text = Players.GetPlayerName(Players.GetLocalPlayer())
    $("#Rank").style.backgroundImage = 'url("s2r://panorama/images/ranks/' + getRatingIcon(getRating(Players.GetLocalPlayer())) + '_png.vtex")';
    var rank = getRatingName(getRating(Players.GetLocalPlayer()))
    $("#RankName").text = $.Localize(rank)
    if (getPrestige(Players.GetLocalPlayer()) != 0 && getPrestige(Players.GetLocalPlayer()) != null) {
        var PlayerMedal = $("#Medal")
        PlayerMedal.style.backgroundImage = 'url("s2r://panorama/images/prestige/' + getPrestigeIcon(getPrestige(Players.GetLocalPlayer())) + '_png.vtex")';
        var medal = "DOTA_Prestige_" + getPrestige(Players.GetLocalPlayer())
        $("#avatar").AddClass("rank_" + getPrestigeIcon(getPrestige(Players.GetLocalPlayer())))
        var mouseOverCapture = (function(medal, PlayerMedal) {
                return function() { OnInspect(medal, PlayerMedal) }
            }
            (medal, PlayerMedal));


        var mouseOutCapture = (function(medal, PlayerMedal) {
                return function() { OnInspectOver(medal, PlayerMedal) }
            }
            (medal, PlayerMedal));


        PlayerMedal.SetPanelEvent("onmouseover", mouseOverCapture);
        PlayerMedal.SetPanelEvent("onmouseout", mouseOutCapture);
    }
    $("#Games").text = $.Localize("#games_played") + getGames(Players.GetLocalPlayer())
    for (var v = 0; v < $("#RanksList").GetChildCount(); v++) {
        $("#RanksList").GetChild(v).DeleteAsync(0)
    }
    for (var i = 0; i < 20; i++) {
        var name = rating_table[i]
        var ListRatingPanel = $.CreatePanel("Panel", $("#RanksList"), name);
        ListRatingPanel.AddClass("RanksAll")
        ListRatingPanel.style.backgroundImage = 'url("s2r://panorama/images/ranks/' + name + '_png.vtex")';
        if (name == getRatingIcon(getRating(Players.GetLocalPlayer()))) {
            ListRatingPanel.AddClass("RankNow")
        }
        var mouseOverCapture = (function(name, ListRatingPanel) {
                return function() { OnInspect(name, ListRatingPanel) }
            }
            (name, ListRatingPanel));


        var mouseOutCapture = (function(name, ListRatingPanel) {
                return function() { OnInspectOver(name, ListRatingPanel) }
            }
            (name, ListRatingPanel));


        ListRatingPanel.SetPanelEvent("onmouseover", mouseOverCapture);
        ListRatingPanel.SetPanelEvent("onmouseout", mouseOutCapture);
    }
    if (rank != "silver_0") {
        if ($("#RankLeft")) { $("#RankLeft").style.backgroundImage = 'url("s2r://panorama/images/ranks/' + getRatingIcon(getRating(Players.GetLocalPlayer())) + '_png.vtex")'; }
        var ex = getEXToReachNextRank(getRating(Players.GetLocalPlayer()))
        ex = Number(ex)
        var curr_xp = (getCurrentEXP(getRating(Players.GetLocalPlayer())) / 500) * 100
        $("#XP").style.width = curr_xp + "%";
        var curr = Number(getRating(Players.GetLocalPlayer()))
        ex = ex + curr
        var prestige = getPrestige(Players.GetLocalPlayer())
        var next_prestige = getNextPrestigeRank(prestige)
        if (getRating(Players.GetLocalPlayer()) >= 9500 && (prestige != null && next_prestige != null)) {
            if ($("#RankRight")) { $("#RankRight").style.width = "8%";
                $("#RankRight").style.backgroundImage = 'url("s2r://panorama/images/prestige/' + next_prestige + '_png.vtex")'; }
        } else {
            if ($("#RankRight")) { $("#RankRight").style.backgroundImage = 'url("s2r://panorama/images/ranks/' + getRatingIcon(ex) + '_png.vtex")'; }
        }
    }
    var playerId = Game.GetLocalPlayerID()
    var playerInfo = Game.GetPlayerInfo(playerId);
}

function GetPlayerStatus(id, steamid) {
    if (steamid == 76561198047935884 || steamid == 76561198008916676 || steamid == 76561198118793322 || steamid == 76561198064739000) {
        return true
    }
    return false
}