function VerifyClient() {
     if(serverHasData() && (getClientStatus(Players.GetLocalPlayer()) == -1 || getClientUnban(Players.GetLocalPlayer()) > (Date.now() / 1000)))
     {
         $("#GlobalPanel").BLoadLayout("file://{resources}/layout/custom_game/ban.xml", false, false);
     }
 }
 
 (function() {
     VerifyClient()
 })()
 
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
 
 function getClientUnban(pID)
 {
     var table = CustomNetTables.GetTableValue("players", "stats")
 
     if (table[pID])
     {
         return Number(table[pID].likes) 
     }
 
     return 0
 }