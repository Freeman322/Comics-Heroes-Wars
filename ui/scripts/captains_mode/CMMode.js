var current_selected;
var current_picked_selected;
var heroes = [
    "npc_dota_hero_antimage",
    "npc_dota_hero_lycan",
    "npc_dota_hero_tidehunter",
    "npc_dota_hero_zuus",
    "npc_dota_hero_omniknight",
    "npc_dota_hero_chaos_knight",
    "npc_dota_hero_silencer",
    "npc_dota_hero_centaur",
    "npc_dota_hero_invoker",
    "npc_dota_hero_storm_spirit",
    "npc_dota_hero_elder_titan",
    "npc_dota_hero_crystal_maiden",
    "npc_dota_hero_enigma",
    "npc_dota_hero_arc_warden",
    "npc_dota_hero_terrorblade",
    "npc_dota_hero_skeleton_king",
    "npc_dota_hero_bloodseeker",
    "npc_dota_hero_beastmaster",
    "npc_dota_hero_axe",
    "npc_dota_hero_rubick",
    "npc_dota_hero_brewmaster",
    "npc_dota_hero_juggernaut",
    "npc_dota_hero_earth_spirit",
    "npc_dota_hero_ember_spirit",
    "npc_dota_hero_oracle",
    "npc_dota_hero_lina",
    "npc_dota_hero_pudge",
    "npc_dota_hero_rattletrap",
    "npc_dota_hero_dazzle",
    "npc_dota_hero_meepo",
    "npc_dota_hero_necrolyte",
    "npc_dota_hero_obsidian_destroyer",
    "npc_dota_hero_dark_seer",
    "npc_dota_hero_sniper",
    "npc_dota_hero_faceless_void",
    "npc_dota_hero_shadow_demon",
    "npc_dota_hero_night_stalker",
    "npc_dota_hero_pugna",
    "npc_dota_hero_treant",
    "npc_dota_hero_life_stealer",
    "npc_dota_hero_lone_druid",
    "npc_dota_hero_kunkka",
    "npc_dota_hero_sven",
    "npc_dota_hero_ursa",
    "npc_dota_hero_ancient_apparition",
    "npc_dota_hero_templar_assassin",
    "npc_dota_hero_spectre",
    "npc_dota_hero_alchemist",
    ////"npc_dota_hero_clinkz",
    "npc_dota_hero_weaver",
    "npc_dota_hero_gyrocopter",
    "npc_dota_hero_venomancer",
    "npc_dota_hero_troll_warlord",
    "npc_dota_hero_razor",
    ///"npc_dota_hero_tinker",
    "npc_dota_hero_vengefulspirit",
    "npc_dota_hero_legion_commander",
    "npc_dota_hero_tusk",
    "npc_dota_hero_skywrath_mage",
    "npc_dota_hero_nevermore",
    "npc_dota_hero_dragon_knight",
    "npc_dota_hero_viper",
    "npc_dota_hero_bane",
    "npc_dota_hero_slark",
    "npc_dota_hero_spirit_breaker",
    "npc_dota_hero_doom_bringer",
    "npc_dota_hero_undying",
    "npc_dota_hero_windrunner",
    "npc_dota_hero_magnataur",
    "npc_dota_hero_riki",
    "npc_dota_hero_furion",
    "npc_dota_hero_sand_king",
    "npc_dota_hero_lich",
    "npc_dota_hero_phantom_lancer",
    "npc_dota_hero_visage",
    "npc_dota_hero_slardar",
    "npc_dota_hero_phantom_assassin",
    "npc_dota_hero_shredder",
    "npc_dota_hero_shadow_shaman",
    "npc_dota_hero_enchantress",
    "npc_dota_hero_abyssal_underlord",
    "npc_dota_hero_lion",
    "npc_dota_hero_earthshaker",
    "npc_dota_hero_abaddon",
    "npc_dota_hero_death_prophet",
    ///"npc_dota_hero_morphling",
    "npc_dota_hero_monkey_king",
    "npc_dota_hero_bounty_hunter",
    "npc_dota_hero_warlock",
    "npc_dota_hero_jakiro",
    "npc_dota_hero_disruptor",
    "npc_dota_hero_bristleback",
    "npc_dota_hero_pangolier",
    "npc_dota_hero_batrider",
    "npc_dota_hero_nyx_assassin"
]

function AssingPlayers() {
    var radiant = Game.GetPlayerIDsOnTeam(2);
    var dire = Game.GetPlayerIDsOnTeam(3);
    if (radiant) {
        for (var i in radiant) {
            var playerPanel = $.CreatePanel("Panel", $("#RadiantPlayers"), radiant[i] + "Main");
            playerPanel.AddClass("PlayerPanel")

            var MainHero = $.CreatePanel("Panel", playerPanel, radiant[i] + "MainHero");
            MainHero.AddClass("HeroPickedIcon")

            var PlayerRank = $.CreatePanel("Panel", playerPanel, radiant[i] + "_rank");
            PlayerRank.AddClass("PlayerRankIcon")
            PlayerRank.style.backgroundImage = 'url("s2r://panorama/images/ranks/' + getRatingIcon(getRating(radiant[i])) + '_png.vtex")';

            var PlayerName = $.CreatePanel("Label", playerPanel, radiant[i] + "_playerName");
            PlayerName.AddClass("PlayerName")
            PlayerName.text = Players.GetPlayerName(radiant[i])

            if (getPrestige(radiant[i]) != null) {
                var PlayerMedal = $.CreatePanel("Panel", playerPanel, undefined);
                PlayerMedal.AddClass("PlayerMedal")
                PlayerMedal.style.backgroundImage = 'url("s2r://panorama/images/prestige/' + getPrestigeIcon(getPrestige(radiant[i])) + '_png.vtex")';

                var medal = "DOTA_Prestige_" + getPrestige(radiant[i])

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
            }

            var PlayerCaptain = $.CreatePanel("Panel", playerPanel, "CM_" + radiant[i]);
            PlayerCaptain.AddClass("PlayerCaptain")

            var rank = getRatingIcon(getRating(radiant[i]))

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
    if (dire) {
        for (var i in dire) {
            var playerPanel = $.CreatePanel("Panel", $("#DirePlayer"), dire[i] + "Main");
            playerPanel.AddClass("PlayerPanel")

            var MainHero = $.CreatePanel("Panel", playerPanel, dire[i] + "MainHero");
            MainHero.AddClass("HeroPickedIcon")

            var PlayerRank = $.CreatePanel("Panel", playerPanel, dire[i] + "_rank");
            PlayerRank.AddClass("PlayerRankIcon")
            PlayerRank.style.backgroundImage = 'url("s2r://panorama/images/ranks/' + getRatingIcon(getRating(dire[i])) + '_png.vtex")';

            var PlayerName = $.CreatePanel("Label", playerPanel, dire[i] + "_playerName");
            PlayerName.AddClass("PlayerName")
            PlayerName.text = Players.GetPlayerName(dire[i])


            if (getPrestige(dire[i]) != null) {
                var PlayerMedal = $.CreatePanel("Panel", playerPanel, undefined);
                PlayerMedal.AddClass("PlayerMedal")
                PlayerMedal.style.backgroundImage = 'url("s2r://panorama/images/prestige/' + getPrestigeIcon(getPrestige(dire[i])) + '_png.vtex")';

                var medal = "DOTA_Prestige_" + getPrestige(dire[i])

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
            }

            var PlayerCaptain = $.CreatePanel("Panel", playerPanel, "CM_" + dire[i]);
            PlayerCaptain.AddClass("PlayerCaptain")

            var rank = getRatingIcon(getRating(dire[i]))

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
    Game.EmitSound("announcer_dlc_crystal_maiden_cm_ann_ancient_attack_follow_up_04")
}

function OnInspectMedal(value, panel) {
    $.DispatchEvent("DOTAShowTextTooltip", panel, "#" + value);
}

function OnInspectMedalOver(value, panel) {
    $.DispatchEvent("DOTAHideTextTooltip", panel);
}

function OnInspectRank(value, panel) {
    $.DispatchEvent("DOTAShowTextTooltip", panel, "#" + value);
}

function OnInspectRankOver(value, panel) {
    $.DispatchEvent("DOTAHideTextTooltip", panel);
}

function RebuildHeroesUI() {
    for (var i in heroes) {
        var name = heroes[i]

        var Hero = $.CreatePanel("Panel", $("#HeroesRoot"), name);
        Hero.AddClass("HeroIcon")
        Hero.style.backgroundImage = 'url("s2r://panorama/images/custom_game/heroes/' + name + '_png.vtex")';
        Hero.hittest = false;

        var fBtPress = (function(hero, Hero) {
                return function() {
                    OnHeroSelected(hero, Hero)
                }
            }
            (name, Hero));
        Hero.SetPanelEvent('onactivate', fBtPress)

        var mouseOverCapture = (function(hero, Hero) {
                return function() {
                    OnInspectHeroStart(hero, Hero)
                }
            }
            (name, Hero));


        var mouseOutCapture = (function(hero, Hero) {
                return function() {
                    OnInspectHeroOver(hero, Hero)
                }
            }
            (name, Hero));


        Hero.SetPanelEvent("onmouseover", mouseOverCapture);
        Hero.SetPanelEvent("onmouseout", mouseOutCapture);
    }
}

function SetHeroesPickable() {
    var v = 0;
    while (v <  $("#HeroesRoot").GetChildCount()) {
        $("#HeroesRoot").GetChild(v).DeleteAsync(0)
        v++;
    }
    RebuildHeroesUI()
    UpdateOnConnection()
}

function OnInspectHeroStart(hero, panel) {
    $.DispatchEvent("DOTAShowTitleImageTextTooltip", panel, "#new_" + hero, "file://{images}/custom_game/heroes/" + hero + ".png", "#new_" + hero + "_hype");
}

function OnInspectHeroOver(hero, panel) {
    $.DispatchEvent("DOTAHideTitleImageTextTooltip", panel);
}

function UpdateTimerValue(params) {
    $("#TeamSelectTimer").text = params["time"];
    var lable = $("#Stage")
    global_stage = params["pick_stage"]
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
}

function BecameCaptain() {
    var player = Players.GetLocalPlayer()
    var data = {
        playerID: player,
        team: Players.GetTeam(player)
    }
    GameEvents.SendCustomGameEventToServer("captain_selected", data);
}

function OnHeroSelected(name, panel) {
    if (current_selected) {
        current_selected.SetHasClass("Selected", false)
    }
    if (current_selected == panel) {
        panel.SetHasClass("Selected", false)
    } else {
        current_selected = panel
        panel.SetHasClass("Selected", true)
    }
    if ($("#PickButton")) {
        var pick_button = $("#PickButton")
        pick_button.hero = name
    }
}

function OnSelectionPressed(panel) {
    var hero = panel.hero
    var player = Players.GetLocalPlayer()
    var data = {
        playerID: player,
        team: Players.GetTeam(player),
        hero: hero
    }
    $.Msg(panel, hero)
    GameEvents.SendCustomGameEventToServer("hero_selected", data);
}

function OnCMModeStateChanged(table_name, key, data) {
    ///$.Msg(table_name, key, data)
    if (key == "captains") {
        var team = Players.GetTeam(Players.GetLocalPlayer())
        for (var i in data) {
            var captain_id = data[i]
            if ($("#CM_" + captain_id)) {
                $("#CM_" + captain_id).style.backgroundImage = 'url("s2r://panorama/images/captains_mode/captain_psd.vtex")';
            }
            if (i == team) {
                if ($("#CaptainButton")) {
                    $("#CaptainButton").DeleteAsync(0)
                }
            }
            if (data[i] == Players.GetLocalPlayer()) {
                if ($("#PickButton")) {
                    $("#PickButton").DeleteAsync(0)
                }
                var PickButton = $.CreatePanel("Panel", $("#CoreRoot"), "PickButton");
                PickButton.AddClass("PickButton")

                var fBtPress = (function(PickButton) {
                        return function() {
                            OnSelectionPressed(PickButton)
                        }
                    }
                    (PickButton));
                PickButton.SetPanelEvent('onactivate', fBtPress)

                var Label = $.CreatePanel("Label", PickButton, "PickButtonLabel");
                Label.text = "SELECT HERO"
                SetHeroesPickable()
            }
        }
    }
    if (key == "stage") {}

    if (key == "heroes") {
        for (var i in data) {
            var name = i
            if ($("#" + name)) {
                $("#" + name).hittest = false;
                $("#" + name).SetHasClass("Selected", false);
                $("#" + name).SetHasClass("Picked", true);
            }
            var num = data[i]["number"]
            var IsPick = data[i]["IsPick"]
            var Team = data[i]["team"]
            if (Team == 2) {
                if (IsPick) {
                    var panel = $("#RadiantPick_" + num)
                    panel.style.backgroundImage = 'url("s2r://panorama/images/custom_game/heroes/' + name + '_png.vtex")';
                } else {
                    var panel = $("#RadiantBan_" + num)
                    panel.style.backgroundImage = 'url("s2r://panorama/images/custom_game/heroes/' + name + '_png.vtex")';
                }
            } else {
                if (IsPick) {
                    var panel = $("#DirePick_" + num)
                    panel.style.backgroundImage = 'url("s2r://panorama/images/custom_game/heroes/' + name + '_png.vtex")';
                } else {
                    var panel = $("#DireBan_" + num)
                    panel.style.backgroundImage = 'url("s2r://panorama/images/custom_game/heroes/' + name + '_png.vtex")';
                }
            }
        }
    }

    if (key == "end_pick") {
        var Heroes = $("#HeroesRoot")
        var v = 0;
        for (var v = 0; v < Heroes.GetChildCount(); v++) {
            var hero = Heroes.GetChild(v)
            var hero_name = Heroes.GetChild(v).id
            hero.hittest = false
            hero.AddClass("Picked")
            if (data[hero_name]) {
                var num = data[hero_name]["number"]
                var IsPick = data[hero_name]["IsPick"]
                var team = data[hero_name]["team"]

                if (team == Players.GetTeam(Players.GetLocalPlayer()) && IsPick == true) {
                    hero.hittest = true
                    hero.SetHasClass("Picked", false)
                    var fBtPress = (function(hero, hero_name) {
                            return function() {
                                OnPickedHeroSelected(hero, hero_name)
                            }
                        }
                        (hero, hero_name));
                    hero.SetPanelEvent('onactivate', fBtPress)
                }
            }
        }
        if ($("#CaptainButton")) {
            $("#CaptainButton").DeleteAsync(0)
        }
        if ($("#PickButton")) {
            $("#PickButton").DeleteAsync(0)
        }
        var HeroSelectionButton = $.CreatePanel("Panel", $("#CoreRoot"), "HeroSelectionButton");
        HeroSelectionButton.AddClass("PickButton")

        var fBtPress = (function(HeroSelectionButton) {
                return function() {
                    OnPick(HeroSelectionButton)
                }
            }
            (HeroSelectionButton));
        HeroSelectionButton.SetPanelEvent('onactivate', fBtPress)

        var Label = $.CreatePanel("Label", HeroSelectionButton, "PickButtonLabel");
        Label.text = "SELECT HERO"
    }

    if (key == "picked_players") {
        var pID = Players.GetLocalPlayer()
        for (var i in data) {
            var PickPanel = $("#" + i + "MainHero")
            PickPanel.style.backgroundImage = 'url("s2r://panorama/images/custom_game/heroes/' + data[i]["hero"] + '_png.vtex")';
            if (i == pID) {
                EndPick()
                break
            }
        }
    }

    if (key == "timer") {
        UpdateTimerValue(data)
    }

    if (key == "selected_heroes") {
        for (var i in data) {
            var name = i
            if ($("#" + i)) {
                $("#" + i).AddClass("Picked");
                $("#" + i).hittest = false
            }
        }
    }
}

function OnPickedHeroSelected(panel, hero) {
    if (current_picked_selected) {
        current_picked_selected.SetHasClass("Selected", false)
    }
    if (current_picked_selected == panel) {
        panel.SetHasClass("Selected", false)
    } else {
        current_picked_selected = panel
        panel.SetHasClass("Selected", true)
    }
    if ($("#HeroSelectionButton")) {
        var pick_button = $("#HeroSelectionButton")
        pick_button.hero = hero
    }
    $.Msg($("#HeroSelectionButton").hero)
}

function OnPick(panel) {
    var hero = panel.hero
    var player = Players.GetLocalPlayer()
    var data = {
        playerID: player,
        team: Players.GetTeam(player),
        hero: hero
    }
    $.Msg(data)
    GameEvents.SendCustomGameEventToServer("selected_hero_picked", data);
}

function EndPick() {
    if ($("#PickScreen")) {
        $("#PickScreen").AddClass("Delete")
    }
}

function UpdateOnConnection() {
    if ($("#PickButton")) {
        $("#PickButton").DeleteAsync(0)
    }
    var data_picks = CustomNetTables.GetTableValue("captains_mode", "picked_players")
    if (data_picks) {
        var pID = Players.GetLocalPlayer()
        for (var i in data_picks) {
            var PickPanel = $("#" + i + "MainHero")
            PickPanel.style.backgroundImage = 'url("s2r://panorama/images/custom_game/heroes/' + data_picks[i]["hero"] + '_png.vtex")';
            if (i == pID) {
                EndPick()
                return null;
            }
        }
    }
    var data_captains = CustomNetTables.GetTableValue("captains_mode", "captains")
    var team = Players.GetTeam(Players.GetLocalPlayer())
    if (data_captains) {
        for (var i in data_captains) {
            var captain_id = data_captains[i]
            if ($("#CM_" + captain_id)) {
                $("#CM_" + captain_id).style.backgroundImage = 'url("s2r://panorama/images/captains_mode/captain_psd.vtex")';
            }
            if (i == team) {
                if ($("#CaptainButton")) {
                    $("#CaptainButton").DeleteAsync(0)
                }
            }
            if (data_captains[i] == Players.GetLocalPlayer()) {
                var PickButton = $.CreatePanel("Panel", $("#CoreRoot"), "PickButton");
                PickButton.AddClass("PickButton")

                var fBtPress = (function(PickButton) {
                        return function() {
                            OnSelectionPressed(PickButton)
                        }
                    }
                    (PickButton));
                PickButton.SetPanelEvent('onactivate', fBtPress)

                var Label = $.CreatePanel("Label", PickButton, "PickButtonLabel");
                Label.text = "SELECT HERO"

                var Heroes = $("#HeroesRoot")

                var v = 0;
                while (v < Heroes.GetChildCount()) {
                    var hero = Heroes.GetChild(v)
                    var hero_name = Heroes.GetChild(v).id
                    hero.hittest = true
                    v++;
                }
            }
        }
    }
    var data_picks = CustomNetTables.GetTableValue("captains_mode", "heroes")
    if (data_picks) {
        for (var i in data_picks) {
            var name = i
            if ($("#" + name)) {
                $("#" + name).hittest = false;
                $("#" + name).SetHasClass("Selected", false);
                $("#" + name).SetHasClass("Picked", true);
            }
            var num = data_picks[i]["number"]
            var IsPick = data_picks[i]["IsPick"]
            var Team = data_picks[i]["team"]
            if (Team == 2) {
                if (IsPick) {
                    var panel = $("#RadiantPick_" + num)
                    panel.style.backgroundImage = 'url("s2r://panorama/images/custom_game/heroes/' + name + '_png.vtex")';
                } else {
                    var panel = $("#RadiantBan_" + num)
                    panel.style.backgroundImage = 'url("s2r://panorama/images/custom_game/heroes/' + name + '_png.vtex")';
                }
            } else {
                if (IsPick) {
                    var panel = $("#DirePick_" + num)
                    panel.style.backgroundImage = 'url("s2r://panorama/images/custom_game/heroes/' + name + '_png.vtex")';
                } else {
                    var panel = $("#DireBan_" + num)
                    panel.style.backgroundImage = 'url("s2r://panorama/images/custom_game/heroes/' + name + '_png.vtex")';
                }
            }
        }
    }
    var data_end = CustomNetTables.GetTableValue("captains_mode", "end_pick")
    if (data_end) {
        var Heroes = $("#HeroesRoot")
        var v = 0;
        for (var v = 0; v < Heroes.GetChildCount(); v++) {
            var hero = Heroes.GetChild(v)
            var hero_name = Heroes.GetChild(v).id
            hero.hittest = false
            hero.AddClass("Picked")
            if (data_end[hero_name]) {
                var num = data_end[hero_name]["number"]
                var IsPick = data_end[hero_name]["IsPick"]
                var team = data_end[hero_name]["team"]

                if (team == Players.GetTeam(Players.GetLocalPlayer()) && IsPick == true) {
                    hero.hittest = true
                    hero.SetHasClass("Picked", false)
                    var fBtPress = (function(hero, hero_name) {
                            return function() {
                                OnPickedHeroSelected(hero, hero_name)
                            }
                        }
                        (hero, hero_name));
                    hero.SetPanelEvent('onactivate', fBtPress)
                }
            }
        }
        if ($("#CaptainButton")) {
            $("#CaptainButton").DeleteAsync(0)
        }
        if ($("#PickButton")) {
            $("#PickButton").DeleteAsync(0)
        }
        var HeroSelectionButton = $.CreatePanel("Panel", $("#CoreRoot"), "HeroSelectionButton");
        HeroSelectionButton.AddClass("PickButton")

        var fBtPress = (function(HeroSelectionButton) {
                return function() {
                    OnPick(HeroSelectionButton)
                }
            }
            (HeroSelectionButton));
        HeroSelectionButton.SetPanelEvent('onactivate', fBtPress)

        var Label = $.CreatePanel("Label", HeroSelectionButton, "PickButtonLabel");
        Label.text = "SELECT HERO"
    }
    var data_selected = CustomNetTables.GetTableValue("captains_mode", "selected_heroes")
    if (data_selected) {
        for (var i in data) {
            var name = i
            $.Msg(name + "PANEL: " + $("#" + i))
            if ($("#" + i)) {
                $("#" + i).AddClass("Picked");
                $("#" + i).hittest = false
            }
        }
    }
}

(function() {
    AssingPlayers()
    RebuildHeroesUI()
    UpdateOnConnection()
    GameEvents.Subscribe("UpdateOnConnection", UpdateOnConnection);
    GameEvents.Subscribe("UpdateTimerValue", UpdateTimerValue);
    GameEvents.Subscribe("EndPick", EndPick);
    //GameEvents.Subscribe( "EnterGame", EnterGame );
    //// GameEvents.Subscribe( "random_hero_view", ViewRandomHero );

    //$("#HeroText").text = ""
    CustomNetTables.SubscribeNetTableListener("captains_mode", OnCMModeStateChanged);
})()