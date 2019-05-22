var STATUS = [];

STATUS.GAME_BAN = "GameBan"
STATUS.TEMP_BAN = "TempBan"

var COOLDOWN_TEXT = "Temporally Cooldown"

function Verify() {
     if(serverHasData())
     {
          if (getClientStatus(Players.GetLocalPlayer()) == -1)
          {
               $("#TopPanel").SetHasClass(STATUS.GAME_BAN, true)

               $("#BanText").text = "Global Cooldown"
          }
          else if (getClientUnban(Players.GetLocalPlayer()) > 0)
          {
               $("#TopPanel").SetHasClass(STATUS.TEMP_BAN, true)

               var time_seconds = getClientUnban(Players.GetLocalPlayer()) - (Date.now() / 1000)
               var time = formatDateTime(Math.floor(time_seconds))

               $("#BanText").text = (COOLDOWN_TEXT + " " + time).toUpperCase()

               OnBanCount()
          }
     }
}

(function() { Verify(); })()

function serverHasData()
{
     var value = CustomNetTables.GetTableValue("players", "stats")

     return value != null
}

function getClientStatus(pID)
{
     var table = CustomNetTables.GetTableValue("players", "stats")

     if (table[pID])
     {
          return Number(table[pID].status) 
     }

     return 0
}

function OnBanCount()
{
     var time_seconds = getClientUnban(Players.GetLocalPlayer()) - (Date.now() / 1000)

     if (time_seconds <= 0) 
     {
          $("#BanScreen").style.visibility = 'collapse;'
          $("#TopPanel").style.visibility = 'collapse;'
     }

     var time = formatDateTime(Math.floor(time_seconds))

     $("#BanText").text = (COOLDOWN_TEXT + " " + time).toUpperCase()

     $.Schedule( 0.2, OnBanCount );
}

function getClientUnban(pID)
{
     var table = CustomNetTables.GetTableValue("players", "stats")

     if (table[pID])
     {
          return Number(table[pID].likes) 
     }

     return 0
}

function formatDateTime(input) 
{
    var seconds = Number(input);
    var d = Math.floor(seconds / (3600*24));
    var h = Math.floor(seconds % (3600*24) / 3600);
    var m = Math.floor(seconds % 3600 / 60);
    var s = Math.floor(seconds % 3600 % 60);
    
    var dDisplay = d > 0 ? d + (d == 1 ? " day " : " days ") : "";
    var hDisplay = h > 0 ? h + (h == 1 ? " hour " : " hours ") : "";
    var mDisplay = m > 0 ? m + (m == 1 ? " minute " : " minutes ") : "";
    var sDisplay = s > 0 ? s + (s == 1 ? " second" : " seconds") : "";
    
    return dDisplay + hDisplay + mDisplay + sDisplay;
}
