function getPlayerInventory(pID) {
  var steam_id = GetSteamID32()
  var inventory = new Array();
  var payload = {
      steamID32: steam_id,
  };

  $.AsyncWebRequest('http://94.250.251.65/games/chw/test/inventory.php',
  {
    type: 'POST',
    data: {payload: JSON.stringify(payload)},
    success: function (data) {
        JSON.parse(data)
      }
    });
}


(function()
{
  var econs = CustomNetTables.GetTableValue( "globals", "econs" )
})();


function GetSteamID32(id) {
    var playerInfo = undefined
    if(id){
      playerInfo = Game.GetPlayerInfo(id);
    }else {
      playerInfo = Game.GetPlayerInfo(Game.GetLocalPlayerID());
    }
    var steamID64 = playerInfo.player_steamid,
        steamIDPart = Number(steamID64.substring(3)),
        steamID32 = String(steamIDPart - 61197960265728);

    return steamID32;
}
