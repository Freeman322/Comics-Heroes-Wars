function OnGetTrade(params) {
  var data = params["result"]
  $.Msg("OnGetTrade")
  $.Msg(data)

  for (var i = 0; i < $("#RootTrades").GetChildCount(); i++) {
    $("#RootTrades").GetChild(i).DeleteAsync(0)
  }

  var TradePanel = $.CreatePanel( "Panel", $("#RootTrades"), undefined );
  TradePanel.AddClass("TradeOffer")

  var TradeFromU = $.CreatePanel( "Panel", TradePanel, undefined );
  TradeFromU.AddClass("TradeFromU")
  var TradeToU = $.CreatePanel( "Panel", TradePanel, undefined );
  TradeToU.AddClass("TradeToU")

  for (var i in data){
    var arg = data[i]
    var to = arg["TO"]
    var from = arg["FROM"]
    var def_id = arg["def_id"]
    if (from == Players.GetLocalPlayer()){
      var hero = this.Globals.econs[def_id]["hero"]
      var item = this.Globals.econs[def_id]["item"]
      var rarity = this.Globals.econs[def_id]["rarity"]
      var quality = this.Globals.econs[def_id]["quality"]
      quality = this.Globals.qualities[quality]["name"]
      rarity = this.Globals.rarities[rarity]["name"]

      var item_panel = $.CreatePanel( "Panel", TradeFromU ,  item );
      item_panel.AddClass("item_small")
      item_panel.item = item
      item_panel.style.backgroundImage = 'url("s2r://panorama/images/econs/'+ item +'_png.vtex")';
      item_panel.AddClass(quality)

      var item_rarity = $.CreatePanel( "Panel", item_panel , undefined );
      item_rarity.AddClass(rarity)

      var item_name = $.CreatePanel( "Label", item_rarity , undefined );
      item_name.AddClass("item_name")
      item_name.text = $.Localize(item)
    }else{
      var hero = this.Globals.econs[def_id]["hero"]
      var item = this.Globals.econs[def_id]["item"]
      var rarity = this.Globals.econs[def_id]["rarity"]
      var quality = this.Globals.econs[def_id]["quality"]
      quality = this.Globals.qualities[quality]["name"]
      rarity = this.Globals.rarities[rarity]["name"]

      var item_panel = $.CreatePanel( "Panel", TradeToU ,  item );
      item_panel.AddClass("item_small")
      item_panel.item = item
      item_panel.style.backgroundImage = 'url("s2r://panorama/images/econs/'+ item +'_png.vtex")';
      item_panel.AddClass(quality)

      var item_rarity = $.CreatePanel( "Panel", item_panel , undefined );
      item_rarity.AddClass(rarity)

      var item_name = $.CreatePanel( "Label", item_rarity , undefined );
      item_name.AddClass("item_name")
      item_name.text = $.Localize(item)
    }
  }

  var TradeImage = $.CreatePanel( "Panel", TradePanel , undefined );
  TradeImage.AddClass("TradeImage")

  var Apply = $.CreatePanel( "Panel", TradePanel, undefined );
  Apply.AddClass("Apply")
  var Apply_Label = $.CreatePanel( "Label", Apply , undefined );
  Apply_Label.text = "APPLY"

  var NotApply = $.CreatePanel( "Panel", TradePanel, undefined );
  NotApply.AddClass("NotApply")
  var NotApply_Label = $.CreatePanel( "Label", NotApply , undefined );
  NotApply_Label.text = "DISMISS"

  var to = arg["TO"]
  var from = arg["FROM"]

  var NameLeft = $.CreatePanel( "Label", TradePanel , undefined );
  NameLeft.AddClass("NameLeft")
  NameLeft.text = Players.GetPlayerName( Number(from) )

  var NameRight = $.CreatePanel( "Label", TradePanel , undefined );
  NameRight.AddClass("NameRight")
  NameRight.text = Players.GetPlayerName( Number(to) )

  var contextApply  = (function(params) { return function()
  {  OnApply(params)  } }
  (params) );

  var contextDosmiss  = (function(params) { return function()
  {  OnDismiss(params)  } }
  (params) );

  Apply.SetPanelEvent("onmouseactivate", contextApply);
  NotApply.SetPanelEvent("onmouseactivate", contextDosmiss);
}

function OnDismiss(data) {
  for (var i = 0; i < $("#RootTrades").GetChildCount(); i++) {
    $("#RootTrades").GetChild(i).DeleteAsync(0)
  }
}

function OnApply(data) {
  $.Msg(data)
  GameEvents.SendCustomGameEventToServer( "apply_trade", data);
  for (var i = 0; i < $("#RootTrades").GetChildCount(); i++) {
    $("#RootTrades").GetChild(i).DeleteAsync(0)
  }
}

(function(){
    GameEvents.Subscribe( "get_trade", OnGetTrade );
})()
