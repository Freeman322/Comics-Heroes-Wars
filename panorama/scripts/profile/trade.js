function SetupPlayers() {
    var pIDs = Game.GetAllPlayerIDs()

    for (var i in pIDs) {
        var playerPanel = $.CreatePanel('Panel', $("#Players"), undefined);
        playerPanel.AddClass("Player")
        playerPanel.user_id = pIDs[i]

        var avatar = $.CreatePanel('DOTAAvatarImage', playerPanel, undefined);
        var playerInfo = Game.GetPlayerInfo(pIDs[i]);
        avatar.AddClass("PlayerAvatar")
        avatar.steamid = playerInfo.player_steamid
        avatar.style.width = "100%";
        avatar.style.height = "100%";
        avatar.style.marginLeft = "-41%;"

        var PlayerName = $.CreatePanel("Label", playerPanel, undefined);
        PlayerName.text = playerInfo.player_name

        var id = pIDs[i]
        if (Players.GetLocalPlayer() != id) {
            var select = (function(id, playerPanel) {
                    return function() { SelectTradePartner(id, playerPanel) }
                }
                (id, playerPanel));

            playerPanel.SetPanelEvent("onmouseactivate", select)
        }
    }
}

function SelectTradePartner(pID, panel) {
    var inventory = $("#RightSide")
    var players = $("#Players")
    ClearPanels()

    panel.AddClass("Selected")
    CreateUserInventory(pID)
    CreatePlayerTradeInventory()
}

function CreateUserInventory(id) {
    $.Msg("PARTNER: " + id)
    var inventory;

    var payload = {
        type: 4,
        data: {
            steam_id: GetSteamID(id),
        }
    };

    $.AsyncWebRequest('http://82.146.43.107', {
        type: 'POST',
        data: { payload: JSON.stringify(payload) },
        success: function(data) {
            $.Msg('GDS Reply: ', data)
            var inventory = JSON.parse(data)
            for (var i in inventory) {
                var item = inventory[i]
                CreateInventoryItemTradePartner(item, id)
            }
        }
    });
}

function CreatePlayerTradeInventory() {
    var id = Players.GetLocalPlayer()
    var inventory;

    var payload = {
        type: 4,
        data: {
            steam_id: getSteamID32(),
        }
    };

    $.AsyncWebRequest('http://82.146.43.107', {
        type: 'POST',
        data: { payload: JSON.stringify(payload) },
        success: function(data) {
            $.Msg('GDS Reply: ', data)
            var inventory = JSON.parse(data)
            for (var i in inventory) {
                var item = inventory[i]
                CreateInventoryItemTradePlayer(item, id)
            }
        }
    });
}

function CreateInventoryItemTradePlayer(object, id) {
    var item_id = object["id"]
    var def_id = object["def_id"]
    var rarity = object["rarity"]
    var quality = object["quality"]
    var tradeable = object["tradeable"]
    var is_treasure = object["is_treasure"]
    var is_medal = object["is_medal"]
    var state = object["state"]
    var hero = this.Globals.econs[def_id]["hero"]
    var item = this.Globals.econs[def_id]["item"]
    quality = this.Globals.qualities[quality]["name"]
    rarity = this.Globals.rarities[rarity]["name"]
    if (tradeable == 1) {
        var item_panel = $.CreatePanel("Panel", $("#LeftSide"), item + "_trade");
        item_panel.AddClass("item_medium")
        item_panel.item = item
        item_panel.item_id = item_id
        item_panel.def_id = def_id
        item_panel.player_id = id
        item_panel.style.backgroundImage = 'url("s2r://panorama/images/econs/' + item + '_png.vtex")';
        item_panel.AddClass(quality)


        var item_rarity = $.CreatePanel("Panel", item_panel, undefined);
        item_rarity.AddClass(rarity)

        var item_name = $.CreatePanel("Label", item_rarity, undefined);
        item_name.AddClass("item_name")
        item_name.text = $.Localize(item)

        var mouseOverCapture = (function(item, rarity, quality, item_panel, hero) {
                return function() { OnInspectItem(item, rarity, quality, item_panel, hero) }
            }
            (item, rarity, quality, item_panel, hero));


        var mouseOutCapture = (function(item, rarity, quality, item_panel, hero) {
                return function() { OnInspectItemEnd(item, rarity, quality, item_panel, hero) }
            }
            (item, rarity, quality, item_panel, hero));

        var context = (function(tradeable, item_id, item, item_panel) {
                return function() { OnItemSelected(tradeable, item_id, item, item_panel) }
            }
            (tradeable, item_id, item, item_panel));


        item_panel.SetPanelEvent("onmouseover", mouseOverCapture);
        item_panel.SetPanelEvent("onmouseout", mouseOutCapture);
        item_panel.SetPanelEvent("onmouseactivate", context);
    }
}

function CreateInventoryItemTradePartner(object, id) {
    if (id == Players.GetLocalPlayer()) { return null; }
    var item_id = object["id"]
    var def_id = object["def_id"]
    var rarity = object["rarity"]
    var quality = object["quality"]
    var tradeable = object["tradeable"]
    var is_treasure = object["is_treasure"]
    var is_medal = object["is_medal"]
    var state = object["state"]
    var hero = this.Globals.econs[def_id]["hero"]
    var item = this.Globals.econs[def_id]["item"]
    quality = this.Globals.qualities[quality]["name"]
    rarity = this.Globals.rarities[rarity]["name"]
    if (tradeable == 1) {
        var item_panel = $.CreatePanel("Panel", $("#RightSide"), item);
        item_panel.AddClass("item_medium")
        item_panel.item = item
        item_panel.item_id = item_id
        item_panel.def_id = def_id
        item_panel.player_id = id
        item_panel.style.backgroundImage = 'url("s2r://panorama/images/econs/' + item + '_png.vtex")';
        item_panel.AddClass(quality)


        var item_rarity = $.CreatePanel("Panel", item_panel, undefined);
        item_rarity.AddClass(rarity)

        var item_name = $.CreatePanel("Label", item_rarity, undefined);
        item_name.AddClass("item_name")
        item_name.text = $.Localize(item)

        var mouseOverCapture = (function(item, rarity, quality, item_panel, hero) {
                return function() { OnInspectItem(item, rarity, quality, item_panel, hero) }
            }
            (item, rarity, quality, item_panel, hero));


        var mouseOutCapture = (function(item, rarity, quality, item_panel, hero) {
                return function() { OnInspectItemEnd(item, rarity, quality, item_panel, hero) }
            }
            (item, rarity, quality, item_panel, hero));

        var context = (function(tradeable, item_id, item, item_panel) {
                return function() { OnItemSelected(tradeable, item_id, item, item_panel) }
            }
            (tradeable, item_id, item, item_panel));


        item_panel.SetPanelEvent("onmouseover", mouseOverCapture);
        item_panel.SetPanelEvent("onmouseout", mouseOutCapture);
        item_panel.SetPanelEvent("onmouseactivate", context);
    }
}

function OnItemSelected(tradeable, item_id, item, panel) {
    ///$.Msg("ID: " + item_id + " ITEM: " + item + " PANEL_ID: " + panel.player_id)
    if (tradeable == 1) {
        if (panel.BHasClass("ItemSelected")) {
            panel.RemoveClass("ItemSelected")
        } else {
            panel.AddClass("ItemSelected")
        }
    } else { return null; }
}

function ClearPanels() {
    var inventory = $("#RightSide")
    var inventoryPlayer = $("#LeftSide")
    var players = $("#Players")
    for (var v = 0; v < inventory.GetChildCount(); v++) {
        inventory.GetChild(v).DeleteAsync(0)
    }
    for (var i = 0; i < players.GetChildCount(); i++) {
        players.GetChild(i).RemoveClass("Selected")
    }
    for (var j = 0; j < inventoryPlayer.GetChildCount(); j++) {
        inventoryPlayer.GetChild(j).DeleteAsync(0)
    }
}

function SubmitTradre() {
    var partner = GetPartner()
    var player = Players.GetLocalPlayer()
    var result = new Array()

    var inventory = $("#RightSide")
    var inventoryPlayer = $("#LeftSide")
    var players = $("#Players")

    for (var v = 0; v < inventory.GetChildCount(); v++) {
        var item = inventory.GetChild(v)
        if (item.BHasClass("ItemSelected") && item.item_id) {
            var id = item.item_id
            var def_id = item.def_id
            result.push({
                "FROM": partner,
                "TO": player,
                item_id: id,
                steam_id: GetSteamID(Players.GetLocalPlayer()),
                def_id: def_id
            })
        }
    }
    for (var j = 0; j < inventoryPlayer.GetChildCount(); j++) {
        var item = inventoryPlayer.GetChild(j)
        if (item.BHasClass("ItemSelected") && item.item_id) {
            var id = item.item_id
            var def_id = item.def_id
            if (GetPartner() != null && GetPartner() != undefined) {
                result.push({
                    "FROM": player,
                    "TO": partner,
                    item_id: id,
                    steam_id: GetSteamID(GetPartner()),
                    def_id: def_id
                })
            } else { return null; }
        }
    }
    ClearPanels()
    var data = {
        "result": result,
        "request": player,
        "target": partner
    }
    GameEvents.SendCustomGameEventToServer("trade_recive", data);
}

function GetPartner() {
    var partner;
    var players = $("#Players")
    for (var i = 0; i < players.GetChildCount(); i++) {
        var player = players.GetChild(i)
        if (player.BHasClass("Selected")) {
            partner = player.user_id
            break
        }
    }
    return partner;
}

function DismissTradre() {
    ClearPanels()
}

function ShowTradeMenu() {
    var panel = $("#Trade")
    if (panel.BHasClass("Off")) {
        panel.SetHasClass("Off", false)
    } else {
        panel.SetHasClass("Off", true)
    }
}

(function() {
    ///var PlayerTables = GameUI.CustomUIConfig().PlayerTables;
    var econs = GameUI.CustomUIConfig().Items
    this.Globals.econs = econs

    var qualities = CustomNetTables.GetTableValue("globals", "qualities")
    this.Globals.qualities = qualities
    var rarities = CustomNetTables.GetTableValue("globals", "rarities")
    this.Globals.rarities = rarities
    SetupPlayers()
})();

function GetSteamID(pID) {
    var playerInfo = Game.GetPlayerInfo(pID);

    var steamID64 = playerInfo.player_steamid,
        steamIDPart = Number(steamID64.substring(3)),
        steamID32 = String(steamIDPart - 61197960265728);

    return steamID32;
}


function OnInspectItem(item, rarity, quality, panel, hero) {
    if (quality == "default") {
        $.DispatchEvent("DOTAShowTitleImageTextTooltip", panel, $.Localize(quality) + " " + $.Localize(item), "file://{images}/custom_game/heroes/" + hero + ".png", "Rarity: " + $.Localize(rarity));
    } else {
        $.DispatchEvent("DOTAShowTitleImageTextTooltip", panel, $.Localize(quality) + " " + $.Localize(item), "file://{images}/custom_game/heroes/" + hero + ".png", "Rarity: " + $.Localize(rarity) + "<br> Quality: " + $.Localize(quality));
    }
}

function OnInspectItemEnd(item, rarity, quality, panel, hero) {
    $.DispatchEvent("DOTAHideTitleImageTextTooltip", panel);
}

function OnInspectMedal(item, rarity, quality, panel, hero) {
    $.DispatchEvent("DOTAShowTitleImageTextTooltip", panel, $.Localize(quality) + " " + $.Localize(item), "file://{images}/econs/" + item + ".png", "Rarity: " + $.Localize(rarity));
}

function OnInspectMedalEnd(item, rarity, quality, panel, hero) {
    $.DispatchEvent("DOTAHideTitleImageTextTooltip", panel);
}