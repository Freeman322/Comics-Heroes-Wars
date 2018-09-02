var BUTTON_BECAME_CAPTAIN = 0;
var BUTTON_SELECT_HERO = 1;
var BUTTON_PICK_HERO = 2;

var HEROES_PANELS = [];
var CURRENT_STAGE = -1;
var PLAYER_TEAM = -1;
var PLAYER_ID = -1;

var TEAMS_DATA = []
TEAMS_DATA[0] = "RadiantBan_";
TEAMS_DATA[1] = "DireBan_";
TEAMS_DATA[2] = "RadiantPick_";
TEAMS_DATA[3] = "DirePick_";

var BUTTONS = [];

function RebuildUI() {
    var radiant = Game.GetPlayerIDsOnTeam(2);
    var dire = Game.GetPlayerIDsOnTeam(3);
    if (radiant) {
        for (var i in radiant) {
            var pID = radiant[i]
            var playerPanel = $.CreatePanel("Panel", $("#RadiantPlayers"), "Player_" + pID);
            playerPanel.AddClass("PlayerPanel")

            var MainHero = $.CreatePanel("Panel", playerPanel, "PlayerHero_" + pID);
            MainHero.AddClass("HeroSelectionIcon")

            var PlayerRank = $.CreatePanel("Panel", playerPanel, "PlayerRank_" + pID);
            PlayerRank.AddClass("PlayerRankIcon")

            if (getRating(pID) && getRatingIcon(getRating(pID))) {
                PlayerRank.style.backgroundImage = 'url("s2r://panorama/images/ranks/' + getRatingIcon(getRating(pID)) + '_png.vtex")';
            }

            var PlayerName = $.CreatePanel("Label", playerPanel, "PlayerName_" + pID);
            PlayerName.AddClass("PlayerName")
            PlayerName.text = Players.GetPlayerName(pID)

            var pColor = Players.GetPlayerColor(pID)

            var PlayerColor = $.CreatePanel("Panel", playerPanel, "PlayerColor_" + pID);
            PlayerColor.AddClass("PlayerColorPanel")
            PlayerColor.style.backgroundColor = ToColor(pColor)

            if (getPrestige(pID) && getPrestige(pID) != 0) {
                PlayerName.AddClass(getPrestigeIcon(getPrestige(pID)))
                PlayerRank.AddClass("rank_" + getPrestigeIcon(getPrestige(pID)))

                var prestigeIcon = getPrestigeIcon(getPrestige(pID))
                if (prestigeIcon) {
                    var PlayerMedal = $.CreatePanel("Panel", playerPanel, undefined);
                    PlayerMedal.AddClass("PlayerMedalIcon")
                    PlayerMedal.style.backgroundImage = 'url("s2r://panorama/images/prestige/' + prestigeIcon + '_png.vtex")';

                    var medal = "DOTA_Prestige_" + getPrestige(pID)

                    var mouseOverCapture = (function(medal, PlayerMedal) {
                            return function() {
                                OnInspectMedal(medal, PlayerMedal)
                            }
                        }
                        (medal, PlayerMedal));


                    var mouseOutCapture = (function(medal, PlayerMedal) {
                            return function() {
                                OnInspectMedalOver(medal, PlayerMedal)
                            }
                        }
                        (medal, PlayerMedal));


                    PlayerMedal.SetPanelEvent("onmouseover", mouseOverCapture);
                    PlayerMedal.SetPanelEvent("onmouseout", mouseOutCapture);

                    /*var previewPanel = $.CreatePanel("Panel", playerPanel, undefined);
                    previewPanel.BLoadLayoutFromString('<root><Panel><DOTAScenePanel style="width: 100%; height: 100%;" hittest="false" map="scenes/sparkles" camera="shot_camera"/></Panel></root>', false, false);
                    previewPanel.hittest = false
                    previewPanel.AddClass("scene_" + getPrestigeIcon(getPrestige(pID)))*/
                }
            }

            var rating = getRating(pID)
            if (rating) {
                var rank = getRatingIcon(getRating(pID))
                if (rank) {
                    var mouseOverCapture = (function(rank, PlayerRank) {
                            return function() {
                                OnInspectRank(rank, PlayerRank)
                            }
                        }
                        (rank, PlayerRank));

                    var mouseOutCapture = (function(rank, PlayerRank) {
                            return function() {
                                OnInspectRankOver(rank, PlayerRank)
                            }
                        }
                        (rank, PlayerRank));

                    PlayerRank.SetPanelEvent("onmouseover", mouseOverCapture);
                    PlayerRank.SetPanelEvent("onmouseout", mouseOutCapture);
                }
            }
        }
    }
    if (dire) {
        for (var i in dire) {
            var pID = dire[i]
            var playerPanel = $.CreatePanel("Panel", $("#DirePlayers"), "Player_" + pID);
            playerPanel.AddClass("PlayerPanel")

            var MainHero = $.CreatePanel("Panel", playerPanel, "PlayerHero_" + pID);
            MainHero.AddClass("HeroSelectionIcon")

            var PlayerRank = $.CreatePanel("Panel", playerPanel, "PlayerRank_" + pID);
            PlayerRank.AddClass("PlayerRankIcon")

            if (getRating(pID) && getRatingIcon(getRating(pID))) {
                PlayerRank.style.backgroundImage = 'url("s2r://panorama/images/ranks/' + getRatingIcon(getRating(pID)) + '_png.vtex")';
            }

            var PlayerName = $.CreatePanel("Label", playerPanel, "PlayerName_" + pID);
            PlayerName.AddClass("PlayerName")
            PlayerName.text = Players.GetPlayerName(pID)

            var pColor = Players.GetPlayerColor(pID)

            var PlayerColor = $.CreatePanel("Panel", playerPanel, "PlayerColor_" + pID);
            PlayerColor.AddClass("PlayerColorPanel")
            PlayerColor.style.backgroundColor = ToColor(pColor)

            if (getPrestige(pID) && getPrestige(pID) != 0) {
                PlayerName.AddClass(getPrestigeIcon(getPrestige(pID)))
                PlayerRank.AddClass("rank_" + getPrestigeIcon(getPrestige(pID)))

                var prestigeIcon = getPrestigeIcon(getPrestige(pID))
                if (prestigeIcon) {
                    var PlayerMedal = $.CreatePanel("Panel", playerPanel, undefined);
                    PlayerMedal.AddClass("PlayerMedalIcon")
                    PlayerMedal.style.backgroundImage = 'url("s2r://panorama/images/prestige/' + prestigeIcon + '_png.vtex")';

                    var medal = "DOTA_Prestige_" + getPrestige(pID)

                    var mouseOverCapture = (function(medal, PlayerMedal) {
                            return function() {
                                OnInspectMedal(medal, PlayerMedal)
                            }
                        }
                        (medal, PlayerMedal));


                    var mouseOutCapture = (function(medal, PlayerMedal) {
                            return function() {
                                OnInspectMedalOver(medal, PlayerMedal)
                            }
                        }
                        (medal, PlayerMedal));


                    PlayerMedal.SetPanelEvent("onmouseover", mouseOverCapture);
                    PlayerMedal.SetPanelEvent("onmouseout", mouseOutCapture);

                    /*var previewPanel = $.CreatePanel("Panel", playerPanel, undefined);
                    previewPanel.BLoadLayoutFromString('<root><Panel><DOTAScenePanel style="width: 100%; height: 100%;" hittest="false" map="scenes/sparkles" camera="shot_camera"/></Panel></root>', false, false);
                    previewPanel.hittest = false
                    previewPanel.AddClass("scene_" + getPrestigeIcon(getPrestige(pID)))*/
                }
            }

            var rating = getRating(pID)
            if (rating) {
                var rank = getRatingIcon(getRating(pID))
                if (rank) {
                    var mouseOverCapture = (function(rank, PlayerRank) {
                            return function() {
                                OnInspectRank(rank, PlayerRank)
                            }
                        }
                        (rank, PlayerRank));

                    var mouseOutCapture = (function(rank, PlayerRank) {
                            return function() {
                                OnInspectRankOver(rank, PlayerRank)
                            }
                        }
                        (rank, PlayerRank));

                    PlayerRank.SetPanelEvent("onmouseover", mouseOverCapture);
                    PlayerRank.SetPanelEvent("onmouseout", mouseOutCapture);
                }
            }
        }
    }
    var radiantMMR = getAverageRating(2)
    var DireMMR = getAverageRating(3)
    if (radiantMMR) {
        $("#RadiantRating").text = radiantMMR
    }
    if (DireMMR) {
        $("#DireRating").text = DireMMR //
    }
    var info = Game.GetMapInfo()
    var heroes_str = CustomNetTables.GetTableValue("heroes", "CS_heroes_str")
    var heroes_agi = CustomNetTables.GetTableValue("heroes", "CS_heroes_agi")
    var heroes_int = CustomNetTables.GetTableValue("heroes", "CS_heroes_int")
    var heroes_disabled = CustomNetTables.GetTableValue("heroes", "cm_mode_disabled")

    for (var hero in heroes_str["1"]) {
        var Hero = $.CreatePanel("Panel", $("#HeroesStr"), hero);
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
    for (var hero in heroes_agi["1"]) {
        var Hero = $.CreatePanel("Panel", $("#HeroesAgi"), hero);
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
    for (var hero in heroes_int["1"]) {
        var Hero = $.CreatePanel("Panel", $("#HeroesInt"), hero);
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
    Game.EmitSound("announcer_dlc_crystal_maiden_cm_ann_ancient_attack_follow_up_04")

    BUTTONS.push($("#CaptainsModeBecomeCaptainButton")); BUTTONS.push($("#CaptainsModeSelectHero")); BUTTONS.push($("#PickButton"))

    for(var hero_id in heroes_disabled) {if ($("#" + heroes_disabled[hero_id])) { $("#" + heroes_disabled[hero_id]).enabled = false;  $("#" + heroes_disabled[hero_id]).hittest = false;  $("#" + heroes_disabled[hero_id]).SetHasClass("Picked", true);} }
}

function OnHeroSelected(hero, panel)
{
    SelectHero(hero, panel)
}

function PickOrBanHero()
{
    var hero = GetSelectedHero();
    if (!hero) return;

    var data = {
        playerID: PLAYER_ID,
        team: PLAYER_TEAM,
        hero: hero
    }
    GameEvents.SendCustomGameEventToServer("hero_selected", data);
}

function PickHero()
{
    var hero = GetSelectedHero()
    if (!hero) return;

    var data = {
        playerID: PLAYER_ID,
        team: PLAYER_TEAM,
        hero: hero
    }

    GameEvents.SendCustomGameEventToServer("selected_hero_picked", data);
}


function OnStateChanged(table_name, key, data) {
    if (key == "timer") UpdateTimerValue(data);
    if (key == "captains"){
        if (data == undefined || data[PLAYER_TEAM] == undefined)
        {
            BUTTONS[BUTTON_BECAME_CAPTAIN].SetHasClass("hidden", false);
        }
        else 
        {
            for (var captain in data) {
                $("#PlayerHero_" + data[captain]).SetHasClass("Captain", true)
            }
            BUTTONS[BUTTON_BECAME_CAPTAIN].SetHasClass("hidden", true); BUTTONS[BUTTON_SELECT_HERO].SetHasClass("hidden", true);
            if(data[PLAYER_TEAM] == PLAYER_ID){
                BUTTONS[BUTTON_SELECT_HERO].SetHasClass("hidden", false);
            }
        }
    }
    if (key == "heroes")
    {
        for(var hero in data){ ////heroes{"npc_dota_hero_zuus":{"number":1,"isUsed":1,"IsPick":0,"team":2},"npc_dota_hero_rattletrap":{"number":1,"isUsed":1,"IsPick":1,"team":2},"npc_dota_hero_jakiro":{"number":2,"isUsed":1,"IsPick":0,"team":2}}
            var heroParams = data[hero]

            if (heroParams.IsPick == 0){
                var panel =  $("#" + TEAMS_DATA[heroParams.team - 2] + heroParams.number); panel.style.backgroundImage = 'url("s2r://panorama/images/custom_game/heroes/' + hero + '_png.vtex")';           
                panel.style.backgroundSize = '100%';
            }else {
                var panel = $("#" + TEAMS_DATA[heroParams.team] + heroParams.number); panel.style.backgroundImage = 'url("s2r://panorama/images/custom_game/heroes/' + hero + '_png.vtex")';           
                panel.style.backgroundSize = '100%';
            }
        }
    }
    if (key == "picked_players"){
        for(var player in data) {
            if (data[player].team == PLAYER_TEAM){
                if (data[player].IsPicked){
                    $("#" + data[player].hero).enabled = false;  $("#" + data[player].hero).hittest = true;  $("#" + data[player].hero).SetHasClass("Picked", false);
                }
            }
        }
        if (data[PLAYER_ID] && data[PLAYER_ID].IsPicked){
            EndPick()
        }
    }
}

function UpdateState()
{
    var data = CustomNetTables.GetTableValue("captains_mode", "timer")
    var captains = CustomNetTables.GetTableValue("captains_mode", "captains")
    var heroes = CustomNetTables.GetTableValue("captains_mode", "heroes")
    var players = CustomNetTables.GetTableValue("captains_mode", "picked_players")
    if (captains == undefined || captains[PLAYER_TEAM] == undefined)
    {
        BUTTONS[BUTTON_BECAME_CAPTAIN].SetHasClass("hidden", false);
    }
    else 
    {
        for (var captain in captains) {
            $("#PlayerHero_" + captains[captain]).SetHasClass("Captain", true)
        }
        BUTTONS[BUTTON_BECAME_CAPTAIN].SetHasClass("hidden", true); BUTTONS[BUTTON_SELECT_HERO].SetHasClass("hidden", true);
        if(captains[PLAYER_TEAM] == PLAYER_ID){
            BUTTONS[BUTTON_SELECT_HERO].SetHasClass("hidden", false);
        }
    }
    if (heroes)
    {
        for(var hero in heroes){ 
            var heroParams = heroes[hero]

            if (heroParams.IsPick == 0){
                var panel =  $("#" + TEAMS_DATA[heroParams.team - 2] + heroParams.number); panel.style.backgroundImage = 'url("s2r://panorama/images/custom_game/heroes/' + hero + '_png.vtex")';           
                panel.style.backgroundSize = '100%';
            }else {
                var panel = $("#" + TEAMS_DATA[heroParams.team] + heroParams.number); panel.style.backgroundImage = 'url("s2r://panorama/images/custom_game/heroes/' + hero + '_png.vtex")';           
                panel.style.backgroundSize = '100%';
            }
        }
    }
    if (data)
    {
        if (data.pick_stage >= 21){
            OnPickHeroes()
        }
    }
    if (players){
        for(var player in players) {
            if (players[player].team == PLAYER_TEAM){
                if (players[player].IsPicked){
                    $("#" + players[player].hero).enabled = false;  $("#" + players[player].hero).hittest = true;  $("#" + players[player].hero).SetHasClass("Picked", false);
                }
            }
        }
        if (players[PLAYER_ID] && players[PLAYER_ID].IsPicked){
            EndPick()
        }
    }
}

function BecomeCaptain()
{
    var player = Players.GetLocalPlayer()
    var data = {
        playerID: PLAYER_ID,
        team: PLAYER_TEAM
    }
    GameEvents.SendCustomGameEventToServer("captain_selected", data);
}

(function() {
    HEROES_PANELS = GetAllStagePanels(); PLAYER_TEAM = Players.GetTeam(Players.GetLocalPlayer()); PLAYER_ID = Players.GetLocalPlayer();

    RebuildUI()
    UpdateState()

    CustomNetTables.SubscribeNetTableListener("captains_mode", OnStateChanged);
    GameEvents.Subscribe("on_chat_new_mess", OnChatUpdated);
})()

function OnInspectHeroStart(hero, panel) {
    $.DispatchEvent("DOTAShowTitleImageTextTooltip", panel, "#new_" + hero, "file://{images}/custom_game/heroes/" + hero + ".png", "#new_" + hero + "_hype");
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

function OnPickHeroes(heroes)
{
    Disableheroes();

    var heroes = CustomNetTables.GetTableValue("captains_mode", "heroes")

    for(var hero in heroes){ 
        var heroParams = heroes[hero]

        if (heroParams.IsPick && heroParams.team == PLAYER_TEAM)
        {
            $("#" + hero).enabled = true; $("#" + hero).hittest = true; $("#" + hero).SetHasClass("Picked", false);
        }
    }

    for(var buttun in BUTTONS) BUTTONS[buttun].SetHasClass("hidden", true)
    BUTTONS[BUTTON_PICK_HERO].SetHasClass("hidden", false);
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

function UpdateTimerValue(params) {
    $("#Time").text = params.time;
    var lable = $("#Type")
    global_stage = params.pick_stage
    var text;
    var IsFirstTime
    if (global_stage == 1) {
        text = "Ban Radiant"
    } else if (global_stage == 2) {
        text = "Ban Dire"
    } else if (global_stage == 3) {
        text = "Ban Radiant"
    } else if (global_stage == 4) {
        text = "Ban Dire"
    } else if (global_stage == 5) {
        text = "Pick Radiant"
    } else if (global_stage == 6) {
        text = "Pick Dire"
    } else if (global_stage == 7) {
        text = "Pick Dire"
    } else if (global_stage == 8) {
        text = "Pick Radiant"
    } else if (global_stage == 9) {
        text = "Ban Radiant"
    } else if (global_stage == 10) {
        text = "Ban Dire"
    } else if (global_stage == 11) {
        text = "Ban Radiant"
    } else if (global_stage == 12) {
        text = "Ban Dire"
    } else if (global_stage == 13) {
        text = "Pick Dire"
    } else if (global_stage == 14) {
        text = "Pick Radiant"
    } else if (global_stage == 15) {
        text = "Pick Dire"
    } else if (global_stage == 16) {
        text = "Pick Radiant"
    } else if (global_stage == 17) {
        text = "Ban Dire"
    } else if (global_stage == 18) {
        text = "Ban Radiant"
    } else if (global_stage == 19) {
        text = "Pick Dire"
    } else if (global_stage == 20) {
        text = "Pick Radiant"
    } else {
        text = "-=-"
    }
    lable.text = text

    if (global_stage != CURRENT_STAGE) 
    {
        CURRENT_STAGE = global_stage;

        for(var panel in HEROES_PANELS)
        {
            HEROES_PANELS[panel].RemoveClass("NexStage")
        }

        if (CURRENT_STAGE >= 21) {
            OnPickHeroes();

            return;
        }

        if (params.stage_data.pick == false)
            $("#" + TEAMS_DATA[params.stage_data.team - 2] + params.stage_data.number).SetHasClass("NexStage", true)
        else 
            $("#" + TEAMS_DATA[params.stage_data.team] + params.stage_data.number).SetHasClass("NexStage", true)
    }
}

function GetAllStagePanels()
{
    var panels = []
    var radiant = $("#BanPicksRadiant")
    var dire = $("#BanPicksDire")
    var i = 0;
    while (i < radiant.GetChildCount()) {
        panels.push(radiant.GetChild(i))
        i++;
    }
    var b = 0;
    while (b < dire.GetChildCount()) {
        panels.push(dire.GetChild(b))
        b++;
    }

    return panels;
}

function GetAllHeroesPanel() {
    var heroes = []

    var HeroesStr = $("#HeroesStr")
    var HeroesAgi = $("#HeroesAgi")
    var HeroesInt = $("#HeroesInt")

    var i = 0;
    while (i < HeroesStr.GetChildCount()) {
        heroes.push(HeroesStr.GetChild(i))
        i++;
    }
    var b = 0;
    while (b < HeroesAgi.GetChildCount()) {
        heroes.push(HeroesAgi.GetChild(b))
        b++;
    }
    var c = 0;
    while (c < HeroesInt.GetChildCount()) {
        heroes.push(HeroesInt.GetChild(c))
        c++;
    }

    return heroes;
}

function GetSelectedHero()
{
    var heroes = GetAllHeroesPanel()
    for (var panel in heroes)
    {
        if (heroes[panel].isSelected == true) return heroes[panel].heroname
    }

    return null;
}

function Clean()
{
    var heroes = GetAllHeroesPanel()
    for (var panel in heroes)
    {
        heroes[panel].isSelected = false; heroes[panel].SetHasClass("Selected", false)
    }

}

function SelectHero(hero, panel)
{
    Clean(); panel.isSelected = true; panel.SetHasClass("Selected", true)
}

function Disableheroes()
{
    var heroes = GetAllHeroesPanel() 
    for(var hero in heroes)
    {
        heroes[hero].enabled = false; heroes[hero].hittest = false; heroes[hero].SetHasClass("Picked", true);
    }
}

function EndPick() {
    $("#PickScreen").style.visibility = "collapse;"
    $("#PickScreen").enabled = false;
    $("#PickScreen").hittest = false;
}

function ForeClosePickMenu()
{
    EndPick()
}