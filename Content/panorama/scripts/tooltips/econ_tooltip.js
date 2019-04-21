function OnTooltipLoad() {
    ///var PlayerTables = GameUI.CustomUIConfig().PlayerTables;
    var econs = GameUI.CustomUIConfig().Items

    var def_id = $.GetContextPanel().GetAttributeString("item", "not found")
    var quality = $.GetContextPanel().GetAttributeString("quality", "not found")
    var rarity = $.GetContextPanel().GetAttributeString("rarity", "not found")
    var hero = econs[def_id]['hero']
    var slot = "SLOT_" + econs[def_id]['slot']
    var HeroLoc = $.Localize("ECON_Tooltip_Hero")
    var QualityLoc = $.Localize("ECON_Tooltip_Quality")
    var SlotLoc = $.Localize("ECON_Tooltip_Slot")
    if (hero == "") {
        var image = econs[def_id]['item']
        $("#HeroIcon").SetImage("file://{images}/econs/" + image + ".png")
        $("#HeroName").text = ""
    } else {
        $("#HeroIcon").SetImage("file://{images}/custom_game/heroes/" + hero + ".png")
        $("#HeroName").text = HeroLoc + $.Localize(hero) + " || " + SlotLoc + $.Localize(slot)
    }
    $("#Name").text = $.Localize(econs[def_id]['item'])
    $("#Rarity").text = $.Localize(rarity)
    if (quality != "default") { $("#Slot").text = QualityLoc + $.Localize(quality) } else { $("#Slot").text = "" }

    $("#RarityStripe").SetHasClass("ItemRarity_common", false)
    $("#RarityStripe").SetHasClass("ItemRarity_uncommon", false)
    $("#RarityStripe").SetHasClass("ItemRarity_rare", false)
    $("#RarityStripe").SetHasClass("ItemRarity_mythical", false)
    $("#RarityStripe").SetHasClass("ItemRarity_legendary", false)
    $("#RarityStripe").SetHasClass("ItemRarity_immortal", false)
    $("#RarityStripe").SetHasClass("ItemRarity_arcana", false)
    $("#RarityStripe").SetHasClass("ItemRarity_ethernal", false)
    $("#RarityStripe").SetHasClass("ItemRarity_extraordinary", false)
    $("#RarityStripe").SetHasClass("ItemRarity_custom", false)

    $("#RarityStripe").SetHasClass("ItemRarity_" + rarity, true)
    $("#Description").text = $.Localize(econs[def_id]['item'] + "_lore")
    var type = "is_item"
    if (econs[def_id]['is_treasure'] == 1) {
        type = "is_treasure"
    } else if (econs[def_id]['is_treasure'] == 2) {
        type = "is_contract"
    } else if (econs[def_id]['is_treasure'] == 3) {
        type = "unreleased_treassure"
    } else if (econs[def_id]['is_medal'] == 1) {
        type = "is_medal"
    } else if (econs[def_id]['is_compendium'] == 1) {
        type = "is_compendium"
    } else if (econs[def_id]['is_music'] == 1) {
        type = "is_music"
    }

    $("#Set").text = $.Localize("type") + $.Localize(type)
}