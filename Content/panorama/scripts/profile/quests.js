function SelectQuest(params) {
  var value = CustomNetTables.GetTableValue( "globals", "quests" )
  var hero = Players.GetPlayerHeroEntityIndex( Game.GetLocalPlayerID() )
  var name = Entities.GetUnitName( hero )
  var quests = CustomNetTables.GetTableValue( "globals", "quests" )
  var item = "item"
  if (quests && quests[params]) { item = quests[params]['item'] }
  $.Msg("IS HAVE: " + HasItem(item))
  if (HasItem(item)) {
    $("#QuestButton1").checked = false
    $("#QuestButton2").checked = false
    $("#QuestButton3").checked = false
    if (params == "quest1"){
      $("#QuestButton1").hittest = false
      $("#QuestCarry").hittest = false
      $("#QuestCarry").hittestchildren = false

      $("#QuestButton1").style.saturation = "0"
      $("#QuestCarry").style.saturation = "0"
      $("#QuestCarry").style.saturation = "0"
    }else if (params == "quest2") {
      $("#QuestButton2").hittest = false
      $("#QuestNuker").hittest = false
      $("#QuestNuker").hittestchildren = false

      $("#QuestButton2").style.saturation = "0"
      $("#QuestNuker").style.saturation = "0"
      $("#QuestNuker").style.saturation = "0"
    }else if (params == "quest3") {
      $("#QuestButton3").hittest = false
      $("#QuestSupport").hittest = false
      $("#QuestSupport").hittestchildren = false

      $("#QuestButton3").style.saturation = "0"
      $("#QuestSupport").style.saturation = "0"
      $("#QuestSupport").style.saturation = "0"
    }
    return null;
  }
  if (value[params]['hero'] == name){
    var data = {
      playerID: Game.GetLocalPlayerID(),
      quest : params
   }
   GameEvents.SendCustomGameEventToServer("select_quest", data );
    DisablePanels()
    $.Msg("SENDED: " + data)
  }else{
    $.Msg("NOT SENDED: " + params)

    $("#QuestButton1").checked = false
    $("#QuestButton2").checked = false
    $("#QuestButton3").checked = false
  }
}

function DisablePanels() {
  $("#QuestButton1").hittest = false
  $("#QuestButton2").hittest = false
  $("#QuestButton3").hittest = false

  $("#QuestButton1").style.saturation = "0"
  $("#QuestButton2").style.saturation = "0"
  $("#QuestButton3").style.saturation = "0"

  var panel = $("#CompendiumBody")

  for( var i = 0; i < panel.GetChildCount(); i++){
    panel.GetChild(i).style.saturation = "0"
    panel.GetChild(i).hittest = false
  }
  $("#TopBarWatch").hittest = false
  $("#TopBarWatch").style.saturation = "0"
}

function OnQuestSelected(data) {
  ///[   PanoramaScript ]: {"number":1000000,"hero":"npc_dota_hero_zuus","task":"damage","name":"Quest2","questID":"quest2"}
  $("#CurrentQuest").RemoveClass("Disabled")
  var name = "DOTA_" + data['name'] + "_Detail"
  $("#CurrentQuestName").text = $.Localize(name)
  $("#CurrentQuestParams").text = "0 / " + data['number']
}

function OnQuestUpdated(params) {
  var data = params['data']

  $("#CurrentQuest").RemoveClass("Disabled")
  var name = "DOTA_" + data['name'] + "_Detail"
  $("#CurrentQuestName").text = $.Localize(name)
  var progress = data['progress']
  $("#CurrentQuestParams").text = Math.floor(progress) + " / " + data['number']

  var perc = (Math.floor(progress) * 100) / data['number']
  $.Msg(perc)
  $("#CurrentQuestBar").value = perc

  $.Msg(params)
}

function UpdateOnConnected(params) {
  var pID = Players.GetLocalPlayer()
  if (params && params[pID]){
    var data = params[pID]
    DisablePanels()
    $("#CurrentQuest").RemoveClass("Disabled")
    var name = "DOTA_" + data['name'] + "_Detail"
    $("#CurrentQuestName").text = $.Localize(name)
    if (data['progress']) { $("#CurrentQuestParams").text = data['progress'] + " / " + data['number'] } else { $("#CurrentQuestParams").text = "0 / " + data['number'] }
    if (data['complite']){ $("#CurrentQuestCheck").RemoveClass("Disabled"); $("#CurrentQuest").AddClass("Compilite")  }
  }
}

function OnQuestEnd(params) {
  $.Msg(params)
  var data = params['data']
  $("#CurrentQuest").RemoveClass("Disabled")
  var name = "DOTA_" + data['name'] + "_Detail"
  $("#CurrentQuestName").text = $.Localize(name)
  var progress = data['progress']
  $("#CurrentQuestParams").text = data['number'] + " / " + data['number']

  $("#CurrentQuestBar").value = 100

  $("#CurrentQuestCheck").RemoveClass("Disabled")
  $("#CurrentQuest").AddClass("Compilite")
}

function HasItem(name) {
  /*var pID = String(Players.GetLocalPlayer())
  var items = CustomNetTables.GetTableValue( "globals", "inventory" )
  $.Msg(name)
  $.Msg(items)
  if (items && items[pID]){
    $.Msg(items[pID])
    $.Msg(name)
    if (items[pID][name] == "1"){
      return true
    }
  }*/
  return false
}

(function()
{
  var value = CustomNetTables.GetTableValue( "globals", "quests_current" )
  if (value){
    UpdateOnConnected(value)
  }
  $.Msg(value)
  GameEvents.Subscribe( "select_current_quest", OnQuestSelected );
  GameEvents.Subscribe( "update_current_quest", OnQuestUpdated);
  GameEvents.Subscribe( "end_quest", OnQuestEnd);
})();
