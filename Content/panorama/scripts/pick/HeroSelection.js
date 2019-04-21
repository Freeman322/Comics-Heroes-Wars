var countdown = 60
var PREMIUM = ["npc_dota_hero_drow_ranger", "npc_dota_hero_ogre_magi", "npc_dota_hero_grimskull", "npc_dota_hero_warboss", "npc_dota_hero_jetstream_sam"];

function RebuildUI() {
    var radiant = Game.GetPlayerIDsOnTeam(DOTATeam_t.DOTA_TEAM_GOODGUYS);
    var dire = Game.GetPlayerIDsOnTeam(DOTATeam_t.DOTA_TEAM_BADGUYS);
    
    if (radiant) 
    {
        for (var i in radiant) {
            var pID = radiant[i]
            var playerPanel = $.CreatePanel("Panel", $("#RadiantPlayers"), "Player_" + pID);
            playerPanel.AddClass("PlayerPanel")

            var mouseOverCapture = (function(playerPanel, pID) {
                return function() { OnInspectPlayer(playerPanel, pID) }
            }
            (playerPanel, pID));

            var mouseOutCapture = (function(playerPanel) {
                return function() { OnInspectPlayerEnd(playerPanel) }
            }
            (playerPanel));

            playerPanel.SetPanelEvent("onmouseover", mouseOverCapture);
            playerPanel.SetPanelEvent("onmouseout", mouseOutCapture);

            var MainHero = $.CreatePanel("Panel", playerPanel, "PlayerHero_" + pID);
            MainHero.AddClass("HeroSelectionIcon")

            MainHero.style.backgroundImage = 'url("s2r://panorama/images/dummy_png.vtex")';

            var PlayerName = $.CreatePanel("Label", playerPanel, "PlayerName_" + pID);
            PlayerName.AddClass("PlayerName")
            PlayerName.text = Players.GetPlayerName(pID)

            var PlayerRank = $.CreatePanel("Label", MainHero, "PlayerRank_" + pID);
            PlayerRank.AddClass("PlayerRank")

            PlayerRank.text = getPlayerRankValueForPick(pID) 

            var pColor = Players.GetPlayerColor(pID)

            var PlayerColor = $.CreatePanel("Panel", playerPanel, "PlayerColor_" + pID);
            PlayerColor.AddClass("PlayerColorPanel")
            PlayerColor.style.backgroundColor = ToColor(pColor)
        }
    }
    if (dire) 
    {
        for (var i in dire) {
            var pID = dire[i]
            var playerPanel = $.CreatePanel("Panel", $("#DirePlayers"), "Player_" + pID);
            playerPanel.AddClass("PlayerPanel")

            var mouseOverCapture = (function(playerPanel, pID) {
                return function() { OnInspectPlayer(playerPanel, pID) }
            }
            (playerPanel, pID));

            var mouseOutCapture = (function(playerPanel) {
                return function() { OnInspectPlayerEnd(playerPanel) }
            }
            (playerPanel));

            playerPanel.SetPanelEvent("onmouseover", mouseOverCapture);
            playerPanel.SetPanelEvent("onmouseout", mouseOutCapture);

            var MainHero = $.CreatePanel("Panel", playerPanel, "PlayerHero_" + pID);
            MainHero.AddClass("HeroSelectionIcon")

            MainHero.style.backgroundImage = 'url("s2r://panorama/images/dummy_png.vtex")';

            var PlayerName = $.CreatePanel("Label", playerPanel, "PlayerName_" + pID);
            PlayerName.AddClass("PlayerName")
            PlayerName.text = Players.GetPlayerName(pID)

            var PlayerRank = $.CreatePanel("Label", MainHero, "PlayerRank_" + pID);
            PlayerRank.AddClass("PlayerRank")
            PlayerRank.text = getPlayerRankValueForPick(pID)

            var pColor = Players.GetPlayerColor(pID)

            var PlayerColor = $.CreatePanel("Panel", playerPanel, "PlayerColor_" + pID);
            PlayerColor.AddClass("PlayerColorPanel")
            PlayerColor.style.backgroundColor = ToColor(pColor)
        }
    }


    $("#RadiantRating").text = getAverageRating(DOTATeam_t.DOTA_TEAM_GOODGUYS)
    $("#DireRating").text = getAverageRating(DOTATeam_t.DOTA_TEAM_BADGUYS) 
    

    var info = Game.GetMapInfo()
    var heroes = CustomNetTables.GetTableValue("heroes", "heroes")
    var stats = GameUI.CustomUIConfig().PlayerTables.GetTableValue("heroes", "heroes")

    for (var hero in heroes)
    {
        var attribute = heroes[hero]

        var panel = $("#HeroesStr")
        if (attribute == "DOTA_ATTRIBUTE_AGILITY") panel = $("#HeroesAgi")
        if (attribute == "DOTA_ATTRIBUTE_INTELLECT") panel = $("#HeroesInt")

        var Hero = $.CreatePanel("Panel", panel, hero);
        Hero.AddClass("HeroIcon")
        Hero.style.backgroundImage = 'url("s2r://panorama/images/custom_game/heroes/' + hero + '_png.vtex")';
        Hero.hittest = true;
        Hero.heroname = hero

        var fBtPress = (function(hero, Hero) {
                return function() {
                    OnHeroSelected(hero, Hero)
                }
            }
            (hero, Hero));
        Hero.SetPanelEvent('onactivate', fBtPress)

        var mouseOverCapture = (function(hero, Hero) {
                return function() {
                    OnInspectHeroStart(hero, Hero)
                }
            }
            (hero, Hero));


        var mouseOutCapture = (function(hero, Hero) {
                return function() {
                    OnInspectHeroOver(hero, Hero)
                }
            }
            (hero, Hero));


        Hero.SetPanelEvent("onmouseover", mouseOverCapture);
        Hero.SetPanelEvent("onmouseout", mouseOutCapture);
        
        if (stats != null && stats != undefined){
            if (getPlusSubscribe(Players.GetLocalPlayer()) && stats[hero] != null){
                var winrate = $.CreatePanel("Label", Hero, undefined);
                winrate.AddClass("Plus_Winrate")
                winrate.text = (Math.floor((Number(stats[hero].wins) / Number(stats[hero].picks)) * 100)) + "%"
    
                if (((Number(stats[hero].wins) / Number(stats[hero].picks)) * 100 ) >= 60) { Hero.AddClass("Plus_Shine") }
    
                var trend = $.CreatePanel("Label", Hero, undefined);
                trend.AddClass("Plus_Trend")
                trend.text = "HTV: " + (Number(stats[hero].picks) / Number(getTotalGames())).toFixed(3)
            }
        }
    }

    if (getClientStatus(Players.GetLocalPlayer()) < 1) return;
    
    for(var index in PREMIUM)
    {
        var panel = $("#HeroesAgi")
        var hero = PREMIUM[index]

        var Hero = $.CreatePanel("Panel", panel, hero);
        Hero.AddClass("HeroIcon")
        Hero.style.backgroundImage = 'url("s2r://panorama/images/custom_game/heroes/' + hero + '_png.vtex")';
        Hero.hittest = true;
        Hero.heroname = hero

        var fBtPress = (function(hero, Hero) {
                return function() {
                    OnHeroSelected(hero, Hero)
                }
            }
            (hero, Hero));
        Hero.SetPanelEvent('onactivate', fBtPress)

        var mouseOverCapture = (function(hero, Hero) {
                return function() {
                    OnInspectHeroStart(hero, Hero)
                }
            }
            (hero, Hero));


        var mouseOutCapture = (function(hero, Hero) {
                return function() {
                    OnInspectHeroOver(hero, Hero)
                }
            }
            (hero, Hero));


        Hero.SetPanelEvent("onmouseover", mouseOverCapture);
        Hero.SetPanelEvent("onmouseout", mouseOutCapture);
    }
}

function OnHeroSelected(name, panel) {
    previewHero(name);
}

function previewHero(hero) {
    $("#HeroContainer").BCreateChildren('<DOTAHeroInspect id="HeroInspect" class="BioTabVisible InspectingHero InspectHeroIntelligence InspectHeroComplexity3" tabindex="auto" selectionpos="auto" heroid="'+ Heroes.GetHeroID(hero) +'"/>');

    $("#PickButton").selectedhero = hero
}

function PickHero() {
    var hero = $("#PickButton").selectedhero
    if (hero) {
        var data = {
            playerID: Game.GetLocalPlayerID(),
            hero: hero
        }
        GameEvents.SendCustomGameEventToServer("hero_picked", data);
    }else{
        var data = {
            playerID: Game.GetLocalPlayerID(),
            hero: "npc_dota_hero_antimage"
        }
        GameEvents.SendCustomGameEventToServer("hero_picked", data);
    }

    CheckState()
}

function PickRandomHero() {
    var id = Players.GetLocalPlayer()
    var data = {
        playerID: id
    }
    GameEvents.SendCustomGameEventToServer("random_hero", data);

    CheckState()
}

function CheckState()
{
    var time = CustomNetTables.GetTableValue("pick", "timer")
    if (time) {
        var timer = time['time']
        if ((timer <= 0 || timer == undefined || timer == null)) {
            EndPick();
        }
    } else {
        EndPick()
    }
}

function ToColor(num) {
    num >>>= 0;
    var b = num & 0xFF,
        g = (num & 0xFF00) >>> 8,
        r = (num & 0xFF0000) >>> 16,
        a = ((num & 0xFF000000) >>> 24) / 255;
    return "#" + componentToHex(r) + componentToHex(g) + componentToHex(b);
}

function componentToHex(c) {
    var hex = c.toString(16);
    return hex.length == 1 ? "0" + hex : hex;
}

function OnPickStateChanged(table_name, key, data) {
    if (key == "timer") {
        if ($("#Time")) {
            var time = data.time || 0      
            $("#Time").text = time;
            if (time >= 50)
            {
                $("#Type").text = "BANS";
            }
            else
            {
                $("#Type").text = "PICKS";
            }
        }
        if (time <= 0 && Entities.GetUnitName(Players.GetPlayerHeroEntityIndex(Players.GetLocalPlayer())) != "npc_dota_hero_wisp") {
            EndPick();
        }
    }
    if (key == "bans") {
       for(var i in data[2])
       {
            if ($("#" + data[2][i])) {
                $("#" + data[2][i]).SetHasClass("Banned", true);
                $("#" + data[2][i]).hittest = false;
            }
       }
       for(var i in data[3])
       {
            if ($("#" + data[3][i])) {
                $("#" + data[3][i]).SetHasClass("Banned", true);
                $("#" + data[3][i]).hittest = false;
            }
       }
       $("#BanCount").text = "BANS: " + data['TOTAL']
    }
    if (key == "heroes") {
        for (var i in data) {
            var name = data[i]["hero"]
            var pID = data[i]["playerid"]
            if ($("#PlayerHero_" + pID)) {
                $("#PlayerHero_" + pID).style.backgroundImage = 'url("s2r://panorama/images/custom_game/heroes/' + name + '_png.vtex")';
            }
            if ($("#" + name)) {
                $("#" + name).SetHasClass("Picked", true);
                $("#" + name).hittest = false;
            }
            if (pID == Players.GetLocalPlayer()) {
                previewHero(name)
                DisablePickMenu()
            }
        }
    }
}

function UpdatePickState() {
    var data = CustomNetTables.GetTableValue("pick", "heroes")
    var timer = CustomNetTables.GetTableValue("pick", "timer")
    if (timer) {
        var time = timer.time || 0

        if (time <= 0 && Entities.GetUnitName(Players.GetPlayerHeroEntityIndex(Players.GetLocalPlayer())) != "npc_dota_hero_wisp") {
            EndPick();
        }
    }
    if (data) {
        for (var i in data) {
            var name = data[i]["hero"]
            var pID = data[i]["playerid"]

            if ($("#PlayerHero_" + pID)) {
                $("#PlayerHero_" + pID).style.backgroundImage = 'url("s2r://panorama/images/custom_game/heroes/' + name + '_png.vtex")';
            }
            if ($("#" + name)) {
                $("#" + name).SetHasClass("Picked", true);
                $("#" + name).hittest = false;
            }

            if (pID == Players.GetLocalPlayer()) {
                previewHero(name)
                DisablePickMenu();
            }
        }
    }
}

function EndPick() {
    $("#PickScreen").style.visibility = "collapse;"
    $("#PickScreen").enabled = false;
    $("#PickScreen").hittest = false;
}

function DisablePickMenu() {
    var HeroesStr = $("#HeroesStr")
    var HeroesAgi = $("#HeroesAgi")
    var HeroesInt = $("#HeroesInt")

    var i = 0;
    while (i < HeroesStr.GetChildCount()) {
        var hero = HeroesStr.GetChild(i)
        var hero_name = HeroesStr.GetChild(i).id
        hero.AddClass("Disabled")
        hero.hittest = false
        i++;
    }
    var b = 0;
    while (b < HeroesAgi.GetChildCount()) {
        var hero = HeroesAgi.GetChild(b)
        var hero_name = HeroesAgi.GetChild(b).id
        hero.AddClass("Disabled")
        hero.hittest = false
        b++;
    }
    var c = 0;
    while (c < HeroesInt.GetChildCount()) {
        var hero = HeroesInt.GetChild(c)
        var hero_name = HeroesInt.GetChild(c).id
        hero.AddClass("Disabled")
        hero.hittest = false
        c++;
    }
    $("#RandomButton").hittest = false
    $("#RandomButton").AddClass("Disabled")

    $("#PickButton").hittest = false
    $("#PickButton").AddClass("Disabled")
}

function OnChatSubmitted() {
    var playerId = Game.GetLocalPlayerID()
    var playerInfo = Game.GetPlayerInfo(playerId);
    var hero = Players.GetPlayerHeroEntityIndex(playerId)
    var text = $("#ChatInputField").text
    if (text == "")
        return;

    var data = {
        pID: playerId,
        text: text
    }
    GameEvents.SendCustomGameEventToServer("on_chat_recived", data);
    $("#ChatInputField").text = "";
}

function OnChatUpdated(data) {
    var pID = data["pID"]
    var text = data["text"]
    var color = ToColor(Players.GetPlayerColor(pID))
    var name = "<font color=\"" + color + "\"> " + Players.GetPlayerName(pID) + " </font>"
    var result = name + " :  " + text

    var label = $.CreatePanel("Label", $("#ChatTextField"), undefined);
    label.AddClass("ChatText")
    label.html = true;
    label.text = result
}

function OnBan(argument) {
   var hero = $("#PickButton").selectedhero
    if (hero) {
        var data = {
            playerID: Game.GetLocalPlayerID(),
            hero: hero
        }
        GameEvents.SendCustomGameEventToServer("hero_banned", data);

        $("#BanButton").hittest = false;
    }
}

function OnInspectPlayer(panel, pID) {
    if (serverHasData()) $.DispatchEvent("UIShowCustomLayoutParametersTooltip", panel, "PlayerTooltip", "file://{resources}/layout/custom_game/tooltips/player_tooltip.xml", "player=" + pID);
}

function OnInspectPlayerEnd(panel) {
    if (serverHasData()) $.DispatchEvent("UIHideCustomLayoutTooltip", panel, "PlayerTooltip");
}

(function() {
    RebuildUI()
    UpdatePickState()
    CustomNetTables.SubscribeNetTableListener("pick", OnPickStateChanged);
    GameEvents.Subscribe("on_chat_new_mess", OnChatUpdated);
})()

function OnInspectHeroStart(hero, panel) {
    $.DispatchEvent("DOTAShowTitleImageTextTooltip", panel, "#" + hero, "file://{images}/custom_game/heroes/" + hero + ".png", "#" + hero + "_hype");
}

function OnInspectHeroOver(hero, panel) {
    $.DispatchEvent("DOTAHideTitleImageTextTooltip", panel);
}

function OnTooltipStartTree(hero_id, Tree) {
    $.DispatchEvent("DOTAHUDShowHeroStatBranchTooltip", Tree, hero_id);
}

function OnTooltipOverTree(hero_id, Tree) {
    $.DispatchEvent("DOTAHUDHideStatBranchTooltip", Tree);
}

function OnTooltipStartTree(hero_id, Tree) {
    $.DispatchEvent("DOTAHUDShowHeroStatBranchTooltip", Tree, hero_id);
}

function OnTooltipOverTree(hero_id, Tree) {
    $.DispatchEvent("DOTAHUDHideStatBranchTooltip", Tree);
}

function OnTooltipStart(name, panel) {
    $.DispatchEvent("DOTAShowAbilityTooltip", panel, name)
}

function OnTooltipOver(name, panel) {
    $.DispatchEvent("DOTAHideAbilityTooltip", panel);
}

function Filter(argument) {
    ResetFilter()
    
    var text = $("#SearchTextEntry").text

    var HeroesStr = $("#HeroesStr")
    var HeroesAgi = $("#HeroesAgi")
    var HeroesInt = $("#HeroesInt")

    var i = 0;
    while (i < HeroesStr.GetChildCount()) {
        var hero = HeroesStr.GetChild(i)
        var hero_name = HeroesStr.GetChild(i).id
        if (hero_name.indexOf(text) == -1)
        {
            hero.AddClass("NotFinded")
        }
        i++;
    }
    var b = 0;
    while (b < HeroesAgi.GetChildCount()) {
        var hero = HeroesAgi.GetChild(b)
        var hero_name = HeroesAgi.GetChild(b).id
         if (hero_name.indexOf(text) == -1)
        {
            hero.AddClass("NotFinded")
        }
        b++;
    }
    var c = 0;
    while (c < HeroesInt.GetChildCount()) {
        var hero = HeroesInt.GetChild(c)
        var hero_name = HeroesInt.GetChild(c).id
         if (hero_name.indexOf(text) == -1)
        {
            hero.AddClass("NotFinded")
        }
        c++;
    }
}

function ResetFilter() {
   var HeroesStr = $("#HeroesStr")
    var HeroesAgi = $("#HeroesAgi")
    var HeroesInt = $("#HeroesInt")

    var i = 0;
    while (i < HeroesStr.GetChildCount()) {
        var hero = HeroesStr.GetChild(i)
        var hero_name = HeroesStr.GetChild(i).id
        hero.RemoveClass("NotFinded")
        hero.RemoveClass("Finded")
        i++;
    }
    var b = 0;
    while (b < HeroesAgi.GetChildCount()) {
        var hero = HeroesAgi.GetChild(b)
        var hero_name = HeroesAgi.GetChild(b).id
        hero.RemoveClass("NotFinded")
        hero.RemoveClass("Finded")
        b++;
    }
    var c = 0;
    while (c < HeroesInt.GetChildCount()) {
        var hero = HeroesInt.GetChild(c)
        var hero_name = HeroesInt.GetChild(c).id
        hero.RemoveClass("NotFinded")
        hero.RemoveClass("Finded")
        c++;
    }
}


function ForeClosePickMenu()
{
    EndPick()
}

var CLIENT_STATUS_RESTRICTED = -1
var CLIENT_STATUS_UNRESTRICTED = 0
var CLIENT_STATUS_PREMIUM = 1
var CLIENT_STATUS_CREATOR = 2

var RANKS = {
    0: "silver_1",
    1: "silver_2",
    2: "silver_3",
    3: "silver_4",
    4: "silver_5",
    5: "silver_6",
    6: "nova_1",
    7: "nova_2",
    8: "nova_3",
    9: "nova_4",
    10: "master_1",
    11: "master_2",
    12: "master_3",
    13: "master_4",
    14: "eagle_1",
    15: "eagle_2",
    16: "general_master_1",
    17: "general_master_2",
    18: "supreme_master_1",
    19: "supreme_master_2",
    20: "the_lord_inqusitor",
};

var PRESTIGES = {
    0: "",
    1: "I",
    2: "II",
    3: "III",
    4: "IV",
    5: "V",
    6: "VI",
    7: "VII",
    8: "IIX",
    9: "IX",
    10: "X",
    11: "XI",
    12: "XII",
    13: "IIXV",
    14: "IXV",
    15: "XV",
    16: "XVI",
    17: "XVII",
    18: "IIXX",
    19: "IXX",
    20: "XX",
};

function serverHasData()
{
    var value = CustomNetTables.GetTableValue("players", "stats")

    return value != null
}

function getPlayerRankValue(pID) {
    var value = CustomNetTables.GetTableValue("players", "stats")

    if (value[pID])
    {
        return value[pID].rating
    }

    return 
};

function getPlayerRankValueForPick(pID)
{
    var value = CustomNetTables.GetTableValue("players", "stats")

    if (value && value[pID])
    {
        if (isCalibrated(pID))
        {
            return value[pID].rating
        }
        return "Unranked"
    }

    return "Unranked"
}

function getPlayerRank(pID) {
    var table = CustomNetTables.GetTableValue("players", "stats")

    if (table[pID])
    {
        var value = table[pID].rating 

        if (value == 0 || isCalibrated(pID) == false) { return "silver_0" }

        var rank = Math.floor(value / 500);

        return RANKS[rank]
    }

    return "silver_0"
}

function getPlayerPrestige(pID) {
    var table = CustomNetTables.GetTableValue("players", "stats")

    if (table[pID])
    {
        return table[pID].prestige 
    }

    return 0
}

function getPlayerPrestigeIcon(pID) {
    var table = CustomNetTables.GetTableValue("players", "stats")

    if (table[pID])
    {
        return "prestige_" + table[pID].prestige 
    }

    return null
}

function getPlayerPrestigeNumber(pID) {
    var table = CustomNetTables.GetTableValue("players", "stats")

    if (table[pID])
    {
        return PRESTIGES[table[pID].prestige]
    }

    return ""
}

function getMedal(pID) {
    var table = CustomNetTables.GetTableValue("players", "stats")

    if (table[pID])
    {
        return table[pID].displayed_medal 
    }

    return 0
}

function getMedalIcon(medal) 
{
    if (GameUI.CustomUIConfig().Items)
    {
        return GameUI.CustomUIConfig().Items[medal]["item"]
    }

    return ""
}


function getWinrate(pID) 
{
    var table = CustomNetTables.GetTableValue("players", "stats")

    if (table[pID])
    {
        var rate = (table[pID].wins / table[pID].games) * 100
        if (rate == NaN || rate == Infinity || rate == null) rate = 0

        return Math.floor(rate) + "%"
    }

    return "0%"
}

function getPlusSubscribe(pID) 
{
    var table = CustomNetTables.GetTableValue("players", "stats")

    if (table[pID])
    {
        return (table[pID].is_using_plus == 1)
    }

    return false
}

function getGames(pID) 
{
    var table = CustomNetTables.GetTableValue("players", "stats")

    if (table[pID])
    {
        return table[pID].games
    }

    return 0
}

function getHeroes(pID) 
{
    return CustomNetTables.GetTableValue("players", "heroes")
}

function getAverageRating(teamID) {
    var table = CustomNetTables.GetTableValue("players", "stats")
    var value = 1
    var count = 0

    for(var pID in table)
    {
        if (teamID == Players.GetTeam( Number(pID) ))
        {
            value += Number(table[pID].rating)
            count++;
        }
    }

    return count > 0 ? Math.floor(value / count) : "Unknown"
}

function isCalibrated(pID) {
    var table = CustomNetTables.GetTableValue("players", "stats")

    if (table[pID])
    {
        return table[pID].calibrated == 1
    }

    return false
}

function getUNIXTime(pID)
{
    var table = CustomNetTables.GetTableValue("players", "stats")

    if (table[pID])
    {
        return Number(table[pID].plus_expire)
    }

    return Date.now() / 1000 | 0
}

function getClientStatus(pID)
{
    var table = CustomNetTables.GetTableValue("players", "stats")

    if (table[pID])
    {
        return Number(table[pID].status) 
    }

    return 0
}

function getSteamID32() {
    var playerInfo = Game.GetPlayerInfo(Game.GetLocalPlayerID());

    var steamID64 = playerInfo.player_steamid,
        steamIDPart = Number(steamID64.substring(3)),
        steamID32 = String(steamIDPart - 61197960265728);

    return steamID32;
}

function isPremium(pID)
{
    var table = CustomNetTables.GetTableValue("players", "stats")

    if (table[pID])
    {
        return Number(table[pID].status) > 0 
    }

    return false
}

function getPlayerAVGStats(pID)
{
    var table = CustomNetTables.GetTableValue("players", "stats")

    if (table[pID])
    {
        var result = new Array()

        result["kills"] = Number(table[pID].kills) / Number(table[pID].games)
        result["deaths"] = Number(table[pID].deaths) / Number(table[pID].games)
        result["last_hits"] = Number(table[pID].last_hits) / Number(table[pID].games)
        result["net_worth"] = Number(table[pID].net_worth) / Number(table[pID].games)
        result["rating"] = Number(table[pID].rating)

        return result
    }

    return null
}

function getTotalGames() {
    var value = 1
    var stats = GameUI.CustomUIConfig().PlayerTables.GetTableValue("heroes", "heroes")

    for(var hero in stats)
    {
        value = value + Number(stats[hero].picks)
    }

    return Number(value)
};

