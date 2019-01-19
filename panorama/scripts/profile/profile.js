this.panels = [];
this.drop = "item";
var SPEED = 41
var ITEMS = 50
var RND = 0.1020

var treas_items = [
    "rulk_mask",
    "ghost_cataclysm",
    "out_mask",
    "joker_armor",
    "apocalypse_greatsword",
    "saitama_cape",
    "thor_helmet",
    "alpine_hat",
    "doomsday_adaptive_armor",
    "bolt_set",
    "axe_of_phractos",
    "loki_puppeteer",
    "enigma_bracers",
    "scarlet_weapon",
    "scarlet_armor",
]

function OpenPanel() {
    var panel = $("#FantasyHelpContainer")
    if (panel.BHasClass("Closed")) {
        panel.SetHasClass("Closed", false)
    } else {
        panel.SetHasClass("Closed", true)
    }
    ShowPrimaryTabPage()
}


function SetupReports() {
    var team = Game.GetPlayerIDsOnTeam(Players.GetTeam(Players.GetLocalPlayer()))
    $.Msg(team)
    for (var i in team) {
        var playerPanel = $.CreatePanel('Panel', $("#ReportPanel"), undefined);
        playerPanel.AddClass("players")
        playerPanel.user_id = team[i]

        var avatar = $.CreatePanel('DOTAAvatarImage', playerPanel, undefined);
        var playerInfo = Game.GetPlayerInfo(team[i]);
        avatar.AddClass("PlayerAvatar")
        avatar.steamid = playerInfo.player_steamid
        avatar.style.width = "100%";
        avatar.style.height = "100%";
        avatar.style.marginLeft = "-41%;"

        var playerHeroPanel = $.CreatePanel("Panel", playerPanel, undefined);
        playerHeroPanel.AddClass("ContainerName")

        var PlayerName = $.CreatePanel("Label", playerHeroPanel, undefined);
        PlayerName.AddClass("Name")
        PlayerName.text = playerInfo.player_name
        if (team[i] != Players.GetLocalPlayer()) {
            var Reportbutton = $.CreatePanel("Button", playerPanel, undefined)
            Reportbutton.AddClass("Reportbutton")
            var id = team[i]
            var steam_id = playerInfo.player_steamid

            var executeCapture = (function(id, steam_id, Reportbutton) {
                    return function() { SendReport(id, steam_id, Reportbutton) }
                }
                (id, steam_id, Reportbutton));

            this.panels.push(Reportbutton)

            Reportbutton.SetPanelEvent("onactivate", executeCapture);
        }
    }
}

function SendReport(id, steam_id, panel) {
    $.Msg("REPORT SENDED FROM: " + Players.GetLocalPlayer() + " TO: " + id);
    var data = {
        playerID: Game.GetLocalPlayerID(),
        victimID: id
    }
    GameEvents.SendCustomGameEventToServer("report_sended", data);
    panel.DeleteAsync(0);
    for (var i in this.panels) {
        $.Msg(this.panels[i])
        this.panels[i].DeleteAsync(0);
    }
    ShowReportMenu()
}

function ShowTextToltip(num) {
    var element = $("#Report")
    if (num == 1) {
        $.DispatchEvent("DOTAShowTextTooltip", element, $.Localize("#report"))
    } else {
        var element = $("#PlayerInventoryButton")
        $.DispatchEvent("DOTAShowTextTooltip", element, $.Localize("#DOTA_Inventory"))
    }
}

function EndTextToltip() {
    $.DispatchEvent("DOTAHideTextTooltip");
}

function ShowPrimaryTabPage(params) {
    if (params == 5) {
        $("#FantasyHelpOverview").LoadLayoutAsync("file://{resources}/layout/custom_game/profile/trades_offers.xml", false, true);
    }
}

function DisableContextMenu() {
    $("#Event").AddClass("Delete")
    if ($("#Tournament")) {
        $("#Tournament").AddClass("Delete")
    }
}

function CloseVotePanel() {
    var panel = $("#Surrender")
    if (panel.BHasClass("VoteClosed")) {
        panel.SetHasClass("VoteClosed", false)
    } else {
        panel.SetHasClass("VoteClosed", true)
    }
}

function Surrender() {
    var data = {
        pID: Game.GetLocalPlayerID(),
        team: Players.GetTeam(Players.GetLocalPlayer())
    }
    GameEvents.SendCustomGameEventToServer("vote_get", data);
    DisableVoteMenu()
    Game.EmitSound("UI.Vote");
}

function DisableVoteMenu() {
    var button = $("#SurrenderButton")
    button.hittest = false
}

function SetUpVote() {
    var panel = $("#SurrenderPanel")

    var team = Game.GetPlayerIDsOnTeam(Players.GetTeam(Players.GetLocalPlayer()))
    for (var i in team) {
        var playerPanel = $.CreatePanel('Panel', panel, undefined);
        playerPanel.AddClass("SHeroPanel")
        playerPanel.player_id = team[i]

        var avatar = $.CreatePanel('DOTAAvatarImage', playerPanel, "VoteAvatar_" + team[i]);
        var playerInfo = Game.GetPlayerInfo(team[i]);
        avatar.steamid = playerInfo.player_steamid.toString();
        avatar.style.width = "100%";
        avatar.style.height = "100%";

        var SHeroVote = $.CreatePanel("Panel", playerPanel, "VoteAvatarResult_" + team[i]);
        SHeroVote.AddClass("SHeroVote")
        SHeroVote.AddClass("Not_Visible")
    }
}

function OnVoteGet(table_name, key, data) {
    var pID = Players.GetLocalPlayer()
    var team = Players.GetTeam(pID)
    if (key == "votes") {
        for (var i in data[team]) {
            var panel = $("#VoteAvatarResult_" + i)
            if (panel.BHasClass("Not_Visible")) {
                panel.RemoveClass("Not_Visible")
                Game.EmitSound("UI.Vote");
            }
        }
    }
}

function OnMessageRecived(args) {
    var fontRitites = {}
    fontRitites[0] = null
    fontRitites[1] = "#B0C3D9"
    fontRitites[2] = "#5E98D9"
    fontRitites[3] = "#4B69FF"
    fontRitites[4] = "#8847FF"
    fontRitites[5] = "#D32CE6"
    fontRitites[6] = "#EB4B4B"
    fontRitites[7] = "#E4AE33"
    fontRitites[8] = "#476291"
    fontRitites[9] = "#ADE55C"
    fontRitites[10] = "#A50F79"

    var pID = args["pID"]
    var reason = args["reason"]
    var label = $.CreatePanel("Label", $("#ConsoleMessegeRoot"), undefined);
    label.AddClass("ConsoleText")

    if (reason == 0) {
        label.html = true;

        var concat = Players.GetPlayerName(pID) + "<b><font color=\"red\"> has been forever denied access to the official servers (VAC ban) </font></b>"
        label.text = concat
        label.DeleteAsync(6)
    } else if (reason == 1) {
        var item = args["item"]
        var color = args["color"]

        var econs = GameUI.CustomUIConfig().Items
        var name = $.Localize(econs[item]["item"])
        var rarity = econs[item]['rarity']
        var itemName = $.Localize(econs[item]['item'])
        label.html = true;

        var concat = "<b><font color=\"" + fontRitites[rarity] + "\"> " + itemName + " </font></b>"

        var result = Players.GetPlayerName(pID) + " recived a " + concat + " from treasure!"
        label.text = result
        label.DeleteAsync(6)
    } else if (reason == 2) {
        label.html = true;

        var concat = "<b><font color=\"orange\"> (Server kick) </font></b>"

        var result = Players.GetPlayerName(pID) + " has been kicked. " + concat;
        label.text = result
        label.DeleteAsync(6)
      } else if (reason == 5) {
          label.html = true;
          var result = "<b><font color=\"orange\"> "+ pID +" </font></b>"
          label.text = result
          label.DeleteAsync(6)
      }
}

function OnRoundStart(data) {
    var round_tittle = data['tittle']
    var Units = data['expected_units']
    var wave_image = data['image']
    var panel = $("#EventWaveImage")
    panel.style.opacity = "1;"

    panel.style.backgroundImage = 'url("s2r://panorama/images/darkest_night/rounds/' + wave_image + '_png.vtex")';
    panel.RemoveClass("ImageClosed")
    Game.EmitSound("DOTA_Item.SoulRing.Activate")
    $("#RoundName").text = $.Localize(round_tittle)
    $.Schedule(5, function() {
        Game.EmitSound("DOTA_Item.Buckler.Activate")
        panel.AddClass("ImageClosed")
    })
}

function OnConsolePrint(data) {
    var playerId = Game.GetLocalPlayerID()
    var playerInfo = Game.GetPlayerInfo(playerId);

    var text = data['text']

    var label = $.CreatePanel("Label", $("#ConsoleField"), undefined);
    label.AddClass("ConsoleText")
    label.text = text
    label.DeleteAsync(6)
}


function OnWaveDuring(data) {
    var creepsLeft = data['remains']
    var creepsKilled = data['killed']
    var totalCreeps = data['total']
    var IsInWave = data['isWarmUp']
    var panel = $("#CreepsLeftLabel")
    var progressBar = $("#CreepsLeft")

    if (IsInWave != 1 || IsInWave != true) {
        var percent = (creepsKilled * 100) / totalCreeps
        panel.text = Math.floor(creepsKilled) + " / " + totalCreeps
        progressBar.value = Math.floor(percent)
    } else {
        panel.text = "30 seconds respite!";
        progressBar.value = 0
    }
}

function OnErrorOccupied(argument) {
    if (argument != null) 
    {
        $.Msg(argument["data"])
    }
}

function OnBossSpawn(data) {
    var image = data['image']
    var localize = data['localize']

    var panel = $("#EventWaveImage")
    panel.style.opacity = "1;"

    panel.style.backgroundImage = 'url("s2r://panorama/images/bosses/' + image + '_psd.vtex")';
    panel.RemoveClass("ImageClosed")
    Game.EmitSound("DOTA_Item.SoulRing.Activate")
    $("#RoundName").text = $.Localize(localize)
    $.Schedule(5, function() {
        Game.EmitSound("DOTA_Item.Buckler.Activate")
        panel.AddClass("ImageClosed")
    })
}

(function() {
    var value = CustomNetTables.GetTableValue("globals", "items")
    this.Globals = [];
    this.Globals.items = value
    OpenPanel()
    SetUpVote()

    $("#FantasyHelpOverview").LoadLayoutAsync("file://{resources}/layout/custom_game/profile/trades_offers.xml", false, true);
    
    var votes = CustomNetTables.GetTableValue("globals", "votes")
    if (votes && votes[Players.GetTeam(Players.GetLocalPlayer())] && votes[Players.GetTeam(Players.GetLocalPlayer())][Players.GetLocalPlayer()]) {
        DisableVoteMenu()
    }

    CustomNetTables.SubscribeNetTableListener("globals", OnVoteGet);
    GameEvents.Subscribe("create_error_message", function(data) {
        GameEvents.SendEventClientSide("dota_hud_error_message", {
            "splitscreenplayer": 0,
            "reason": data.reason || 80,
            "message": data.message
        })
    })
    GameEvents.Subscribe("round_start", OnRoundStart)
    GameEvents.Subscribe("on_boss_spawn", OnBossSpawn)
    GameEvents.Subscribe("create_custom_message", OnMessageRecived)
    GameEvents.Subscribe("print_to_console", OnConsolePrint)

    GameEvents.Subscribe("wave_counter", OnWaveDuring)
    GameEvents.Subscribe("OnErrorOccupied", OnErrorOccupied)
})();


function randomFloatBetween(minValue, maxValue, precision) {
    if (typeof(precision) == 'undefined') {
        precision = 2;
    }
    return parseFloat(Math.min(minValue + (Math.random() * (maxValue - minValue)), maxValue).toFixed(precision));
}
