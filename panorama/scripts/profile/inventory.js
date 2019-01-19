var INVENTORY = 1
var QUEST = 2
this.data = [];
var RESULT_DROP

var rarities = {
    1: "mythical",
    2: "legendary",
    3: "ancient",
    4: "immortal",
    5: "arcana",
    6: "ethernal",
    7: "extraordinary"
};


function SetupInventory() {
    for (var v = 0; v < $("#Inventory").GetChildCount(); v++) {
        $("#Inventory").GetChild(v).DeleteAsync(0)
    }

    GetInventoryItems()
}

function GetInventoryItems()
{
    for (var v = 0; v < $("#Inventory").GetChildCount(); v++) {
        $("#Inventory").GetChild(v).DeleteAsync(0)
    }
    
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
                CreateInventoryItem(item)
            }
        }
    });
}

function CreateInventoryItem(object) {
    var panel = $("#Inventory")
    var item_id = object["id"]
    var def_id = object["def_id"]
    var rarity = object["rarity"]
    var quality = object["quality"]
    var tradeable = object["tradeable"]
    var is_treasure = object["is_treasure"]
    var is_medal = object["is_medal"]
    var state = object["state"]
    var holder = object["steam_id"]
    var item = this.Globals.econs[def_id]["item"]
    var hero = this.Globals.econs[def_id]["hero"]
    quality = this.Globals.qualities[quality]["name"]
    rarity = this.Globals.rarities[rarity]["name"]

    var item_panel = $.CreatePanel("Panel", panel, item);
    item_panel.AddClass("item")
    item_panel.item = item
    item_panel.hero = hero
    item_panel.value = state
    item_panel.def_id = def_id
    item_panel.steam_id = holder
    item_panel.medal = is_medal
    item_panel.item_id = item_id
    item_panel.rarity = object["rarity"]
    item_panel.quality = object["quality"]
    item_panel.style.backgroundImage = 'url("s2r://panorama/images/econs/' + item + '_png.vtex")';
    item_panel.AddClass(quality)

    var item_selection = $.CreatePanel("Panel", item_panel, "selection_" + item);
    item_selection.AddClass("item_selection")
    item_selection.AddClass("Disabled")

    if (state == 1) { item_selection.RemoveClass("Disabled") }

    var item_rarity = $.CreatePanel("Panel", item_panel, undefined);
    item_rarity.AddClass(rarity)

    var item_name = $.CreatePanel("Label", item_rarity, undefined);
    item_name.AddClass("item_name")
    item_name.text = $.Localize(item)

    if (is_treasure == 1) {
        var contextTreasure = (function(item_id, item, item_panel, hero, state) {
                return function() { OpenTreasure(item_id, item, item_panel, hero, state) }
            }
            (item_id, item, item_panel, hero, state));
        item_panel.SetPanelEvent("onmouseactivate", contextTreasure);

        var mouseOverCapture = (function(item, rarity, quality, item_panel, hero) {
                return function() { OnInspectItem(item, rarity, quality, item_panel, hero, is_treasure) }
            }
            (item, rarity, quality, item_panel, hero));

        var mouseOutCapture = (function(item, rarity, quality, item_panel, hero) {
                return function() { OnInspectItemEnd(item, rarity, quality, item_panel, hero) }
            }
            (item, rarity, quality, item_panel, hero));
        item_panel.SetPanelEvent("onmouseover", mouseOverCapture);
        item_panel.SetPanelEvent("onmouseout", mouseOutCapture);
    } else if (is_treasure == 2) {
        var contextTreasure = (function(item_id, item, item_panel, hero, state) {
                return function() { OpenContractMenu(item_id, item, item_panel, hero, state) }
            }
            (item_id, item, item_panel, hero, state));
        item_panel.SetPanelEvent("onmouseactivate", contextTreasure);

        var mouseOverCapture = (function(item, rarity, quality, item_panel, hero) {
                return function() { OnInspectItem(item, rarity, quality, item_panel, hero, is_treasure) }
            }
            (item, rarity, quality, item_panel, hero));

        var mouseOutCapture = (function(item, rarity, quality, item_panel, hero) {
                return function() { OnInspectItemEnd(item, rarity, quality, item_panel, hero) }
            }
            (item, rarity, quality, item_panel, hero));
        item_panel.SetPanelEvent("onmouseover", mouseOverCapture);
        item_panel.SetPanelEvent("onmouseout", mouseOutCapture);
    } else if (is_treasure == 3) {
        var mouseOverCapture = (function(item, rarity, quality, item_panel, hero) {
                return function() { OnInspectItem(item, rarity, quality, item_panel, hero) }
            }
            (item, rarity, quality, item_panel, hero));
        var mouseOutCapture = (function(item, rarity, quality, item_panel, hero) {
                return function() { OnInspectItemEnd(item, rarity, quality, item_panel, hero) }
            }
            (item, rarity, quality, item_panel, hero));
        item_panel.SetPanelEvent("onmouseover", mouseOverCapture);
        item_panel.SetPanelEvent("onmouseout", mouseOutCapture);
    } else if (is_medal == 1) {
        var mouseOverCapture = (function(item, rarity, quality, item_panel, hero) {
                return function() { OnInspectItem(item, rarity, quality, item_panel, hero) }
            }
            (item, rarity, quality, item_panel, hero));
        var mouseOutCapture = (function(item, rarity, quality, item_panel, hero) {
                return function() { OnInspectItemEnd(item, rarity, quality, item_panel, hero) }
            }
            (item, rarity, quality, item_panel, hero));
        var context = (function(item, item_panel, hero, state, def_id, item_id) {
                return function() { RightClickItem(item, item_panel, hero, state, def_id, item_id) }
            }
            (item, item_panel, hero, state, def_id, item_id));
        item_panel.SetPanelEvent("onmouseactivate", context);
        item_panel.SetPanelEvent("onmouseover", mouseOverCapture);
        item_panel.SetPanelEvent("onmouseout", mouseOutCapture);
    } else {
        var mouseOverCapture = (function(item, rarity, quality, item_panel, hero) {
                return function() { OnInspectItem(item, rarity, quality, item_panel, hero) }
            }
            (item, rarity, quality, item_panel, hero));


        var mouseOutCapture = (function(item, rarity, quality, item_panel, hero) {
                return function() { OnInspectItemEnd(item, rarity, quality, item_panel, hero) }
            }
            (item, rarity, quality, item_panel, hero));

        var context = (function(item, item_panel, hero, state, def_id, item_id) {
                return function() { RightClickItem(item, item_panel, hero, state, def_id, item_id) }
            }
            (item, item_panel, hero, state, def_id, item_id));
        item_panel.SetPanelEvent("onmouseactivate", context);
        item_panel.SetPanelEvent("onmouseover", mouseOverCapture);
        item_panel.SetPanelEvent("onmouseout", mouseOutCapture);
    }

}

function OpenTreasure(item_id, item, item_panel, hero, state) {
    var Treasure = $("#TreasurePanel")
    $("#BackgroundFXWindow").style.opacity = "0";

    Treasure.treasure = item
    Treasure.item_id = item_id
    Treasure.item_panel = item_panel
    var def = item_panel.def_id

    $("#BackgroundFXWindow").style.opacity = "0";
    $("#BackgroundFXWindow").SetHasClass("PopupItemReceived_rare", false)
    $("#BackgroundFXWindow").SetHasClass("PopupItemReceived_mythical", false)
    $("#BackgroundFXWindow").SetHasClass("PopupItemReceived_legendary", false)
    $("#BackgroundFXWindow").SetHasClass("PopupItemReceived_ancient", false)
    $("#BackgroundFXWindow").SetHasClass("PopupItemReceived_immortal", false)
    $("#BackgroundFXWindow").SetHasClass("PopupItemReceived_arcana", false)
    $("#BackgroundFXWindow").SetHasClass("PopupItemReceived_ethernal", false)
    $("#BackgroundFXWindow").SetHasClass("PopupItemReceived_extraordinary", false)

    $("#TreasureImage").style.backgroundImage = 'url("s2r://panorama/images/econs/' + item + '_png.vtex")';
    $("#TresName").text = $.Localize(item)

    $("#DropResultPanel").SetHasClass("Disabled", true)

    $("#DropRarity").SetHasClass("rare", false)
    $("#DropRarity").SetHasClass("mythical", false)
    $("#DropRarity").SetHasClass("legendary", false)
    $("#DropRarity").SetHasClass("ancient", false)
    $("#DropRarity").SetHasClass("immortal", false)
    $("#DropRarity").SetHasClass("arcana", false)
    $("#DropRarity").SetHasClass("ethernal", false)
    $("#DropRarity").SetHasClass("extraordinary", false)

    var panel = $("#Contain")
    $("#OpenTreasure").hittest = true;
    Treasure.RemoveClass("Off")
    for (var v = 0; v < panel.GetChildCount(); v++) {
        panel.GetChild(v).DeleteAsync(0)
    }
    for (var j = 0; j < $("#ContainItem").GetChildCount(); j++) {
        $("#ContainItem").GetChild(j).DeleteAsync(0)
    }
    var value = this.Globals.econs[def]['contains']
    var elements = value
    for (var j in elements["common"]) {
        var item = elements["common"][j]
        var name = this.Globals.econs[item]["item"]
        var rarity = this.Globals.econs[item]["rarity"]
        var quality = this.Globals.econs[item]["quality"]
        var hero = this.Globals.econs[item]["hero"]
        quality = this.Globals.qualities[quality]["name"]
        rarity = this.Globals.rarities[rarity]["name"]

        var item_panel = $.CreatePanel("Panel", panel, undefined);
        item_panel.AddClass("item")
        item_panel.item = item
        item_panel.def_id = item
        item_panel.style.backgroundImage = 'url("s2r://panorama/images/econs/' + name + '_png.vtex")';
        item_panel.AddClass(quality)

        var item_rarity = $.CreatePanel("Panel", item_panel, undefined);
        item_rarity.AddClass(rarity)

        var item_name = $.CreatePanel("Label", item_rarity, undefined);
        item_name.AddClass("item_name")
        item_name.text = $.Localize(this.Globals.econs[item]["item"])

        var mouseOverCapture = (function(name, rarity, quality, item_panel, hero) {
                return function() { OnInspectItem(name, rarity, quality, item_panel, hero) }
            }
            (name, rarity, quality, item_panel, hero));


        var mouseOutCapture = (function(name, rarity, quality, item_panel, hero) {
                return function() { OnInspectItemEnd(name, rarity, quality, item_panel, hero) }
            }
            (name, rarity, quality, item_panel, hero));

        item_panel.SetPanelEvent("onmouseover", mouseOverCapture);
        item_panel.SetPanelEvent("onmouseout", mouseOutCapture);
    }
    for (var j in elements["rare"]) {
        var item = elements["rare"][j]
        var name = this.Globals.econs[item]["item"]
        var rarity = this.Globals.econs[item]["rarity"]
        var quality = this.Globals.econs[item]["quality"]
        var hero = this.Globals.econs[item]["hero"]
        quality = this.Globals.qualities[quality]["name"]
        rarity = this.Globals.rarities[rarity]["name"]

        var item_panel = $.CreatePanel("Panel", panel, undefined);
        item_panel.AddClass("item")
        item_panel.item = item
        item_panel.def_id = item
        item_panel.style.backgroundImage = 'url("s2r://panorama/images/econs/' + name + '_png.vtex")';
        item_panel.AddClass(quality)

        var item_rarity = $.CreatePanel("Panel", item_panel, undefined);
        item_rarity.AddClass(rarity)

        var item_name = $.CreatePanel("Label", item_rarity, undefined);
        item_name.AddClass("item_name")
        item_name.text = $.Localize(this.Globals.econs[item]["item"])

        var mouseOverCapture = (function(name, rarity, quality, item_panel, hero) {
                return function() { OnInspectItem(name, rarity, quality, item_panel, hero) }
            }
            (name, rarity, quality, item_panel, hero));


        var mouseOutCapture = (function(name, rarity, quality, item_panel, hero) {
                return function() { OnInspectItemEnd(name, rarity, quality, item_panel, hero) }
            }
            (name, rarity, quality, item_panel, hero));

        item_panel.SetPanelEvent("onmouseover", mouseOverCapture);
        item_panel.SetPanelEvent("onmouseout", mouseOutCapture);
    }
    for (var j in elements["very_rare"]) {
        var item = elements["very_rare"][j]
        var name = this.Globals.econs[item]["item"]
        var rarity = this.Globals.econs[item]["rarity"]
        var quality = this.Globals.econs[item]["quality"]
        var hero = this.Globals.econs[item]["hero"]
        quality = this.Globals.qualities[quality]["name"]
        rarity = this.Globals.rarities[rarity]["name"]

        var item_panel = $.CreatePanel("Panel", panel, undefined);
        item_panel.AddClass("item")
        item_panel.item = item
        item_panel.def_id = item
        item_panel.style.backgroundImage = 'url("s2r://panorama/images/econs/' + name + '_png.vtex")';
        item_panel.AddClass(quality)

        var item_rarity = $.CreatePanel("Panel", item_panel, undefined);
        item_rarity.AddClass(rarity)

        var item_name = $.CreatePanel("Label", item_rarity, undefined);
        item_name.AddClass("item_name")
        item_name.text = $.Localize(this.Globals.econs[item]["item"])

        var mouseOverCapture = (function(name, rarity, quality, item_panel, hero) {
                return function() { OnInspectItem(name, rarity, quality, item_panel, hero) }
            }
            (name, rarity, quality, item_panel, hero));


        var mouseOutCapture = (function(name, rarity, quality, item_panel, hero) {
                return function() { OnInspectItemEnd(name, rarity, quality, item_panel, hero) }
            }
            (name, rarity, quality, item_panel, hero));

        item_panel.SetPanelEvent("onmouseover", mouseOverCapture);
        item_panel.SetPanelEvent("onmouseout", mouseOutCapture);
    }
    for (var j in elements["extr_rare"]) {
        var item = elements["extr_rare"][j]
        var name = this.Globals.econs[item]["item"]
        var rarity = this.Globals.econs[item]["rarity"]
        var quality = this.Globals.econs[item]["quality"]
        var hero = this.Globals.econs[item]["hero"]
        quality = this.Globals.qualities[quality]["name"]
        rarity = this.Globals.rarities[rarity]["name"]

        var item_panel = $.CreatePanel("Panel", $("#ContainItem"), undefined);
        item_panel.AddClass("item")
        item_panel.item = item
        item_panel.def_id = item
        item_panel.style.backgroundImage = 'url("s2r://panorama/images/econs/' + name + '_png.vtex")';
        item_panel.AddClass(quality)
        item_panel.AddClass(rarity + "_anim")

        var item_rarity = $.CreatePanel("Panel", item_panel, undefined);
        item_rarity.AddClass(rarity)

        var item_name = $.CreatePanel("Label", item_rarity, undefined);
        item_name.AddClass("item_name")
        item_name.text = $.Localize(this.Globals.econs[item]["item"])

        var mouseOverCapture = (function(name, rarity, quality, item_panel, hero) {
                return function() { OnInspectItem(name, rarity, quality, item_panel, hero) }
            }
            (name, rarity, quality, item_panel, hero));


        var mouseOutCapture = (function(name, rarity, quality, item_panel, hero) {
                return function() { OnInspectItemEnd(name, rarity, quality, item_panel, hero) }
            }
            (name, rarity, quality, item_panel, hero));

        item_panel.SetPanelEvent("onmouseover", mouseOverCapture);
        item_panel.SetPanelEvent("onmouseout", mouseOutCapture);
    }
}

function OpenTreasureStart() {
    var Treasure = $("#TreasurePanel")

    if (!Treasure.treasure || !Treasure.item_id || !Treasure.item_panel) { return null; }

    $("#OpenTreasure").hittest = false;
    Treasure.item_panel.hittest = false;

    var item = Treasure.treasure
    var def = Treasure.item_panel.def_id
    var value = this.Globals.econs[def]['contains']
    var elements = value

    var steam_id = Treasure.item_panel.steam_id

    var common_items = new Array();
    var rare = new Array();
    var extr_rare = new Array();
    var unque = new Array();

    for (var key in elements["common"]) {
        common_items.push(elements["common"][key]);
    }
    for (var key in elements["rare"]) {
        rare.push(elements["rare"][key]);
    }
    for (var key in elements["very_rare"]) {
        extr_rare.push(elements["very_rare"][key]);
    }
    for (var key in elements["extr_rare"]) {
        unque.push(elements["extr_rare"][key]);
    }

    var chance = getRandomArbitrary(1, 101)
    chance = Math.floor(chance)
    var drop = "34";
    
    if (chance <= 70) {
        drop = common_items[Math.floor(Math.random() * common_items.length)];
    } else if (chance > 70 && chance <= 85) {
        drop = rare[Math.floor(Math.random() * rare.length)];
    } else if (chance > 85 && chance <= 98) {
        drop = extr_rare[Math.floor(Math.random() * extr_rare.length)];
    } else if (chance > 98) {
        drop = unque[Math.floor(Math.random() * unque.length)];
    }

    var rarity = this.Globals.econs[drop]["rarity"]
    var quality = this.Globals.econs[drop]["quality"]
    var item = this.Globals.econs[drop]["item"]
    var data = {
        playerID: Game.GetLocalPlayerID(),
        treasure: Treasure.item_id,
        player: steam_id,
        item: drop
    }
    GameEvents.SendCustomGameEventToServer("item_dropped", data);

    rarity = this.Globals.rarities[rarity]["name"]
    Game.EmitSound("item_drop." + rarity)

    $("#DropResultPanel").SetHasClass("Disabled", false)

    $("#BackgroundFXWindow").style.opacity = "1";
    $("#BackgroundFXWindow").SetHasClass("PopupItemReceived_rare", false)
    $("#BackgroundFXWindow").SetHasClass("PopupItemReceived_mythical", false)
    $("#BackgroundFXWindow").SetHasClass("PopupItemReceived_legendary", false)
    $("#BackgroundFXWindow").SetHasClass("PopupItemReceived_ancient", false)
    $("#BackgroundFXWindow").SetHasClass("PopupItemReceived_immortal", false)

    $("#DropResult").SetHasClass("rare_anim", false)
    $("#DropResult").SetHasClass("mythical_anim", false)
    $("#DropResult").SetHasClass("legendary_anim", false)
    $("#DropResult").SetHasClass("ancient_anim", false)
    $("#DropResult").SetHasClass("immortal_anim", false)
    $("#DropResult").SetHasClass("arcana_anim", false)

    $("#BackgroundFXWindow").SetHasClass("PopupItemReceived_" + rarity, true)

    $("#DropResult").style.backgroundImage = 'url("s2r://panorama/images/econs/' + item + '_png.vtex")';
    $("#DropRarity").SetHasClass(rarity, true)
    $("#DropItemName").text = $.Localize(item)
    $("#DropRarityImage").SetImage("file://{images}/drop/image_" + rarity + ".png");
    $("#DropResult").AddClass(rarity + "_anim", true)

    var Treasure = $("#TreasurePanel")
    Treasure.item_panel.DeleteAsync(0)
    Treasure.treasure = null;
    Treasure.item_id = null;
    Treasure.item_panel = null;
}

function getRandomArbitrary(min, max) {
    return Math.random() * (max - min) + min;
}

function CloseTreasure() {
    var Treasure = $("#TreasurePanel")
    Treasure.AddClass("Off")
}

function RightClickItem(item, panel, hero, isPutOn, def_id, item_id) {
    var contextMenu = $.CreatePanel("ContextMenuScript", $.GetContextPanel(), "");
    contextMenu.AddClass("ContextMenu_NoArrow");
    contextMenu.AddClass("ContextMenu_NoBorder");

    contextMenu.GetContentsPanel().item = item;
    contextMenu.GetContentsPanel().value = isPutOn
    contextMenu.GetContentsPanel().parent = panel
    contextMenu.GetContentsPanel().medal = panel.medal
    contextMenu.GetContentsPanel().def_id = def_id
    contextMenu.GetContentsPanel().item_id = item_id
    contextMenu.GetContentsPanel().core_panel = $("#Inventory")

    contextMenu.GetContentsPanel().BLoadLayout("file://{resources}/layout/custom_game/profile/inventory_context_menu.xml", false, false);
}

function OnInspectItem(item, rarity, quality, panel, hero, is_treasure) {
    var def_id = panel.def_id
    $.DispatchEvent("UIShowCustomLayoutParametersTooltip", panel, "ItemTooltip", "file://{resources}/layout/custom_game/tooltips/econ_tooltip.xml", "item=" + def_id + "&rarity=" + rarity + "&quality=" + quality);
}

function OnInspectItemEnd(item, rarity, quality, panel, hero) {
    $.DispatchEvent("UIHideCustomLayoutTooltip", panel, "ItemTooltip");
}

function GetSteamID32() {
    var playerInfo = Game.GetPlayerInfo(Game.GetLocalPlayerID());

    var steamID64 = playerInfo.player_steamid,
        steamIDPart = Number(steamID64.substring(3)),
        steamID32 = String(steamIDPart - 61197960265728);

    return steamID32;
}

function OpenContractMenu(item_id, item, item_panel, hero, state) {
    $.Msg("CONTRACT_ID: " + item_id + " ITEM_NAME: " + item + " STATE: " + state)
    for (var v = 0; v < $("#LeftSideContract").GetChildCount(); v++) {
        $("#LeftSideContract").GetChild(v).DeleteAsync(0)
    }
    $("#ContractPanel").SetHasClass("ContractClosed", false)
    $("#ContractItemAnimation").style.opacity = "0";
    $("#ContractYes").hittest = true
    $("#ContractDropResult").style.opacity = "0";
    $("#ContractItemAnimation").SetHasClass("PopupItemReceived_rare", false)
    $("#ContractItemAnimation").SetHasClass("PopupItemReceived_mythical", false)
    $("#ContractItemAnimation").SetHasClass("PopupItemReceived_legendary", false)
    $("#ContractItemAnimation").SetHasClass("PopupItemReceived_ancient", false)
    $("#ContractItemAnimation").SetHasClass("PopupItemReceived_immortal", false)

    $("#ContractDropRarity").SetHasClass("rare", false)
    $("#ContractDropRarity").SetHasClass("mythical", false)
    $("#ContractDropRarity").SetHasClass("legendary", false)
    $("#ContractDropRarity").SetHasClass("ancient", false)
    $("#ContractDropRarity").SetHasClass("immortal", false)
    $("#ContractDropRarity").SetHasClass("arcana", false)
    $("#ContractDropItemName").text = "Item"

    $("#ContractPanel").contract_id = item_id
    var inventory;
    var payload = {
        steamID32: GetSteamID(Players.GetLocalPlayer()),
    };

    /*$.AsyncWebRequest('http://82.146.43.107', {
        type: 'POST',
        data: { payload: JSON.stringify(payload) },
        success: function(data) {
            ///  $.Msg('GDS Reply: ', data)
            var inventory = JSON.parse(data)
            for (var i in inventory) {
                var object = inventory[i]
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
                if (is_treasure != 1 && is_treasure != 2) {
                    var item_panel = $.CreatePanel("Panel", $("#LeftSideContract"), item + "_contract");
                    item_panel.AddClass("ContractItemIcon")
                    item_panel.item = item
                    item_panel.item_id = item_id
                    item_panel.def_id = def_id
                    item_panel.player_id = Players.GetLocalPlayer()
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
                    var Int_rar = object["rarity"]
                    var context = (function(tradeable, item_id, item, item_panel, Int_rar) {
                            return function() { PutItemInContract(tradeable, item_id, item, item_panel, Int_rar) }
                        }
                        (tradeable, item_id, item, item_panel, Int_rar));
                    item_panel.SetPanelEvent("onmouseover", mouseOverCapture);
                    item_panel.SetPanelEvent("onmouseout", mouseOutCapture);
                    item_panel.SetPanelEvent("onmouseactivate", context);
                }
            }
        }
    });*/
}

function PutItemInContract(tradeable, item_id, item, item_panel, rarity) {
    var contract = $("#LeftSideContract")
    var contractPanel = $("#RightSideContract")
    var items = getContractElements()
    $.Msg("ITEM_ID: " + item_id + " ITEM_NAME: " + item + " tradeable: " + tradeable)
    if (item_panel.BHasClass("ContractItemSelected")) {
        item_panel.SetParent(contract)
        item_panel.RemoveClass("ContractItemSelected")
    } else {
        if (rarity > 6) { return null; }
        if (items > 9) { return null; }
        item_panel.SetParent(contractPanel)
        item_panel.AddClass("ContractItemSelected")
    }
}

function SubmitContract() {
    var contract_panel = $("#ContractPanel")
    var items_count = getContractElements()
    if (!contract_panel.contract_id) { DismissContract(); return null; }
    if (items_count < 10) { DismissContract(); return null; }
    $.Schedule(0.75, function() {
        RefreshInventory()
    })
    $("#ContractYes").hittest = false
    $.Msg("CONTRACT: " + contract_panel.contract_id)
    var result = new Array()
    var contractPanel = $("#RightSideContract")
    for (var j = 0; j < contractPanel.GetChildCount(); j++) {
        var item = contractPanel.GetChild(j)
        result.push({
            "item_id": item.item_id,
            "def_id": item.def_id
        })
        item.DeleteAsync(0);
    }
    var data = {
        items: result,
        treasure: contract_panel.contract_id,
        player_id: Players.GetLocalPlayer()
    }
    $.Msg(data)
    GameEvents.SendCustomGameEventToServer("on_contract_submitted", data);
}

function getContractElements() {
    var contractPanel = $("#RightSideContract")
    var count = contractPanel.GetChildCount()
    return count;
}

function DismissContract() {
    ClearContractPanels()
    $("#ContractPanel").SetHasClass("ContractClosed", true)
}

function ClearContractPanels() {
    var contract = $("#LeftSideContract")
    var contractPanel = $("#RightSideContract")
    $("#ContractDropResult").style.opacity = "0";

    for (var i = 0; i < contract.GetChildCount(); i++) {
        contract.GetChild(i).DeleteAsync(0)
    }
    for (var j = 0; j < contractPanel.GetChildCount(); j++) {
        contractPanel.GetChild(j).DeleteAsync(0)
    }
}

function OnContractSucseed(data) {
    var drop = data['item']
    var rarity = data['rarity']
    rarity = this.Globals.rarities[rarity]["name"]
    var item = this.Globals.econs[drop]["item"]

    $("#ContractDropResult").style.opacity = "1";

    Game.EmitSound("item_drop." + rarity)

    $("#BackgroundFXWindow").style.opacity = "1";
    $("#BackgroundFXWindow").SetHasClass("PopupItemReceived_rare", false)
    $("#BackgroundFXWindow").SetHasClass("PopupItemReceived_mythical", false)
    $("#BackgroundFXWindow").SetHasClass("PopupItemReceived_legendary", false)
    $("#BackgroundFXWindow").SetHasClass("PopupItemReceived_ancient", false)
    $("#BackgroundFXWindow").SetHasClass("PopupItemReceived_immortal", false)

    $("#BackgroundFXWindow").SetHasClass("PopupItemReceived_" + rarity, true)

    $("#ContractDropResult").style.backgroundImage = 'url("s2r://panorama/images/econs/' + item + '_png.vtex")';
    $("#ContractDropRarity").SetHasClass(rarity, true)
    $("#ContractDropItemName").text = $.Localize(item)
}

function ShowInventoryMenu() {
    var panel = $("#PlayerInventory")
    if (panel.BHasClass("Deleted")) {
        panel.SetHasClass("Deleted", false)
        SetupInventory()
    } else {
        panel.SetHasClass("Deleted", true)
    }
}

function RefreshInventory() {
    SetupInventory()
}

function SelectFilterRarity(rarity) {
    var panel = $("#Inventory")
    for (var i = 0; i < panel.GetChildCount(); i++) {
        var item = panel.GetChild(i)
        item.RemoveClass("FilterDisabled")
    }

    for (var v = 0; v < panel.GetChildCount(); v++) {
        var item = panel.GetChild(v)
        if (item && item.rarity) {
            if (item.rarity != rarity) {
                item.AddClass("FilterDisabled")
            }
        }
    }
}

function ClearFilter() {
    var panel = $("#Inventory")
    for (var v = 0; v < panel.GetChildCount(); v++) {
        var item = panel.GetChild(v)
        item.RemoveClass("FilterDisabled")
    }
}

function SelectFilterQuality(data) {
    var string = $("#Quality").GetSelected().id
    var quallity = getRatityNum(string)

    var panel = $("#Inventory")
    for (var i = 0; i < panel.GetChildCount(); i++) {
        var item = panel.GetChild(i)
        item.RemoveClass("FilterDisabled")
    }

    for (var v = 0; v < panel.GetChildCount(); v++) {
        var item = panel.GetChild(v)
        if (item && item.quality) {
            if (item.quality != quallity) {
                item.AddClass("FilterDisabled")
            }
        }
    }
}

function getRatityNum(args) {
    for (var i in this.Globals.qualities) {
        if (args == this.Globals.qualities[i]['name']) { return i; }
    }
}

function RefreshOnTrade() {
    for (var v = 0; v < $("#Inventory").GetChildCount(); v++) {
        $("#Inventory").GetChild(v).DeleteAsync(0)
    }
    RefreshInventory()
}
(function() {
    var econs = GameUI.CustomUIConfig().Items
    this.Globals.econs = econs

    var qualities = CustomNetTables.GetTableValue("globals", "qualities")
    this.Globals.qualities = qualities

    var rarities = CustomNetTables.GetTableValue("globals", "rarities")
    this.Globals.rarities = rarities

    GameEvents.Subscribe("on_contract_sucseed", OnContractSucseed);
    GameEvents.Subscribe("update_inventory", RefreshOnTrade);
    GameEvents.Subscribe("on_auth_sucseed", GetInventoryItems);

    GameUI.CustomUIConfig().RefreshInventory = function() {
        SetupInventory()
    }
})();

function Sort(arr, comp_func) {
    for (var i in arr)
        for (var j in arr)
            if (i != j)
                if (comp_func(arr[i], arr[j])) {
                    var temp = arr[i];
                    arr[i] = arr[j];
                    arr[j] = arr[i];
                }
}

function GetRar(element) {
    return 1
}

function sorting_function(value1, value2) {
    if (GetRar(value1) > GetRar(value2))
        return true
    else
        return false
}