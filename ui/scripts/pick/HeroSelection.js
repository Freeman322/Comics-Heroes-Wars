var countdown = 60

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

    $("#Arrow").style.backgroundImage = 'url("s2r://panorama/images/custom_game/heroes/npc_dota_hero_drow_ranger_png.vtex")';
    $("#Arrow").hittest = true;
    $("#PlayerName").text = Players.GetPlayerName( Game.GetLocalPlayerID() )
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
    }
    var time = CustomNetTables.GetTableValue("pick", "timer")
    if (time) {
        var timer = time['time']
        countdown = time['time']
        if ((timer <= 0 || timer == undefined || timer == null)) {
            EndPick();
            return null;
        }
    } else {
        EndPick()
    }
    Timer()
}

function Timer() {
    countdown = countdown - 1
    $.Msg(countdown)
    if ((countdown <= 0 || countdown == undefined || countdown == null)) {
        EndPick();
        return null;
    }
    $.Schedule(1, Timer)
}

function PickRandomHero() {
    var id = Players.GetLocalPlayer()
    var data = {
        playerID: id
    }
    GameEvents.SendCustomGameEventToServer("random_hero", data);

    var time = CustomNetTables.GetTableValue("pick", "timer")
    if (time) {
        var timer = time['time']
        if ((timer <= 0 || timer == undefined || timer == null)) {
            EndPick();
        }
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

(function() {
    RebuildUI()
    UpdatePickState()
    CustomNetTables.SubscribeNetTableListener("pick", OnPickStateChanged);
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

function ClosePremiumMenu()
{
    $("#MainContents").SetHasClass("Closed", true)
}

function OpenPremiumMenu()
{
    if (getPremiumStatus(Players.GetLocalPlayer())) {
        if ((Players.IsSpectator(Players.GetLocalPlayer()) == false) && getPremiumStatus(Players.GetLocalPlayer()) == 1) {
            $("#MainContents").SetHasClass("Closed", false)
        }
    }
}

function ForeClosePickMenu()
{
    EndPick()
}