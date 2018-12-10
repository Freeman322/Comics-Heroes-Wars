var has_hero_data_plus = false

PAGE_ID_HERO = 1
PAGE_ID_PLAYER = 2
PAGE_ID_QUESTS = 3

function OnPlusOpen(){
    if (!serverHasData()) return;
    if (getPlusSubscribe(Players.GetLocalPlayer()) == false) return; 
    
    if ($("#PlusMain").BHasClass("Closed")){ $("#PlusMain").SetHasClass("Closed", false); if (has_hero_data_plus == false) { RequestDataForHero(); has_hero_data_plus = true; } } else { $("#PlusMain").SetHasClass("Closed", true) }
}
function RequestDataForHero()
{
    var player_hero = Players.GetPlayerSelectedHero( Players.GetLocalPlayer() )
    $("#PlusInject").LoadLayoutAsync("file://{resources}/layout/custom_game/plus/hero_stats.xml", false, true);

    GetHeroData(player_hero)

    var time_seconds = getUNIXTime(Players.GetLocalPlayer()) - (Date.now() / 1000)
    var time = formatDateTime(Math.floor(time_seconds))
    $("#PlusExpire").text = "EXPIRE IN: " + time.toUpperCase();
}
function OnPageSelected(id)
{
    if (id == PAGE_ID_HERO) RequestDataForHero(); else if (id == PAGE_ID_PLAYER) LoadPlayerStats(); else if (id == PAGE_ID_QUESTS) LoadQuests();
}
function LoadPlayerStats()
{
    $("#PlusInject").LoadLayoutAsync("file://{resources}/layout/custom_game/plus/player_stats.xml", false, true);
    var localPlayer = Players.GetLocalPlayer();

    $("#Username").text = Players.GetPlayerName(localPlayer)

    var rank = getPlayerRank(localPlayer)
    $("#RankPanel").style.backgroundImage = 'url("s2r://panorama/images/ranks/' + rank + '_png.vtex")';
    $("#RankPanel").style.backgroundSize = 'cover';

    $("#RankName").text = $.Localize(rank)

    var prestige = getPlayerPrestigeIcon(localPlayer)
    var prestige_name = getPlayerPrestigeNumber(localPlayer)

    if (prestige != 0 && prestige_name != "")
    {
        $("#Prestige").style.backgroundImage = 'url("s2r://panorama/images/prestige/' + prestige + '_png.vtex")';
        $("#Prestige").style.backgroundSize = 'cover';

        $("#PrestigeTextLabel").text = $.Localize("DOTA_" + prestige)
    }

    var stats = getPlayerAVGStats(localPlayer)

    if (stats != null)
    {
        $("#Player_Winrate").text = getWinrate(localPlayer)
        $("#Player_Deaths").text = Math.floor(stats["deaths"])
        $("#Player_Kills").text = Math.floor(stats["kills"])
        $("#Player_LH").text = Math.floor(stats["last_hits"])
        $("#Player_Level").text = getPlayerRankValue(localPlayer)
        $("#Player_NW").text = Math.floor(stats["net_worth"])
    }

    LoadLastGame()
}
function GetHeroData(heroname)
{
    var payload = {
        type: 9,
        data: heroname
    };

    $.AsyncWebRequest('http://82.146.43.107', {
        type: 'POST',
        data: { payload: JSON.stringify(payload) },
        success: function(data) {
            var data = JSON.parse(data)

            var hero = data
            var items = new Array()
    
            var picks = hero.picks
            var hero_id = hero.hero_id
            var wins = hero.wins
            var level = hero.level
            var games = hero.games
            var net_worth = hero.net_worth
            var last_hits = hero.last_hits
            var kills = hero.kills
            var deaths = hero.deaths
            var total_games = data["total_games"]
    
    
            $("#Hero_Winrate").text = Math.floor((Number(wins) / Number(games)) * 100) + "%";
            $("#Hero_Deaths").text = deaths;
            $("#Hero_Kills").text = kills;
            $("#Hero_LH").text = last_hits;
            $("#Hero_Level").text = level;
            $("#Hero_NW").text = net_worth;
            $("#Hero_TP").text = (Number(picks) / Number(total_games)).toFixed(4)
    
            for(var hero_data in hero)
            {
                if (hero_data.indexOf("item_") !== -1)
                {
                    items.push([hero_data, Number(hero[hero_data])])          
                }
            }
    
            items.sort(function(a, b) { 
                return a[1] < b[1] ? 1 : -1;
            });
    
            for(var i in items)
            {
                AddItem(items[i][0], items[i][1], games)
            }
    
            $("#ThisHero").heroname = heroname
            $("#HeroName").text = $.Localize(heroname)
            $("#HeroLore").text = $.Localize(heroname + "_hype")
        }
    });
}
function LoadLastGame()
{
    var payload = {
        type: 3,
        data: {
            id: getSteamID32(),
        }
    };

    $.AsyncWebRequest('http://82.146.43.107', {
        type: 'POST',
        data: { payload: JSON.stringify(payload) },
        success: function(data) {
            var result = JSON.parse(data)

            var id = result["id"]
            var version = result["server_version"]
            var map = result["map"]
            var time = result["time"]
            var dota_time = result["dota_time"]

            var key = getKeyByValue(result, getSteamID32())
            var player_data = JSON.parse(result[key + "_Data"])

            $("#LastHero").heroname = player_data["hero"]
            $("#HeroName").text = $.Localize(player_data["hero"])
            $("#GameMode").text = map

            $("#kda").text = player_data['kda'].replace('|', '/').replace('|', '/')
            $("#GameDuration").text = formatDateTime(Math.floor(dota_time))

            $("#Win").visible = true
            $("#Winner").text = Number(result["winner"]) == 2 ? "Radiant Lost" : "Dire Lost"

            $("#Date").text = time

            var items = player_data["items"]

            for (var item in items) {
                $.CreatePanel("DOTAItemImage", $("#PlayerItems"), items[item]).itemname = items[item];
            }

            for(var i = 0; i <= 9; i++)
            {
                var player = result["player" + i]
                if (player != null && player != undefined)
                {
                    var userdata = JSON.parse(result["player" + i + "_Data"])
                    if(userdata)
                    {
                        var items = userdata["items"]

                        var PlayerPanel = $.CreatePanel("Panel", $("#LastGameOthers"), "player" + i);
                        PlayerPanel.AddClass("PlayerMatchContainer")
                    
                        var HeroImage = $.CreatePanel("DOTAHeroImage", PlayerPanel, undefined);
                        HeroImage.AddClass("MatchHero")
                        HeroImage.heroname = userdata["hero"]
                    
                        var PlayerName = $.CreatePanel("DOTAUserName", PlayerPanel, undefined);
                        PlayerName.AddClass("PlayerName")
                        PlayerName.steamid = player;
                        
                        var KDA = $.CreatePanel("Label", PlayerPanel, undefined);
                        KDA.AddClass("PlayerMathKDA")
                        KDA.text = userdata['kda'].replace('|', '/').replace('|', '/')

                        for (var item in items) {
                            var img = $.CreatePanel("DOTAItemImage", PlayerPanel, items[item])
                            img.itemname = items[item];
                            img.AddClass("ItemPlayerIcon")
                        }
                    }
                }
            }
        }
    });
}
function Schedule()
{
    var time_seconds = getUNIXTime(Players.GetLocalPlayer()) - (Date.now() / 1000)

    var time = formatDateTime(Math.floor(time_seconds))

    $("#PlusExpire").text = "EXPIRE IN: " + time.toUpperCase();

    $.Schedule( 0.2, Schedule );
}
function AddItem(item, value, picks) 
{
    var percent = Math.floor((Number(value) / Number(picks)) * 100)

    if (percent <= 0) return;

    var ItemPanel = $.CreatePanel("Panel", $("#Items"), item);
    ItemPanel.AddClass("Item")

    var Item = $.CreatePanel("DOTAItemImage", ItemPanel, undefined);
    Item.itemname = item

    var ItemLabel = $.CreatePanel("Label", ItemPanel, undefined);
    ItemLabel.AddClass("ItemLabel")
    ItemLabel.text = percent + "%";

    if (percent >= 80)
    {
        ItemPanel.AddClass("BestItem")
    }
}
function LoadQuests()
{
    $("#PlusInject").LoadLayoutAsync("file://{resources}/layout/custom_game/plus/quests.xml", false, true);
}

(function(){
    if (!serverHasData()) return;
    if (getPlusSubscribe(Players.GetLocalPlayer()) == false) return; 
    Schedule()
})();

var CLIENT_STATUS_RESTRICTED = -1
var CLIENT_STATUS_UNRESTRICTED = 0
var CLIENT_STATUS_PREMIUM = 1
var CLIENT_STATUS_CREATOR = 2

var RANKS = {
    0: "silver_1",
    1: "silver_2",
    2: "silver_3",
    3: "silver_4",
    4: "silver_5",
    5: "silver_6",
    6: "nova_1",
    7: "nova_2",
    8: "nova_3",
    9: "nova_4",
    10: "master_1",
    11: "master_2",
    12: "master_3",
    13: "master_4",
    14: "eagle_1",
    15: "eagle_2",
    16: "general_master_1",
    17: "general_master_2",
    18: "supreme_master_1",
    19: "supreme_master_2",
    20: "the_lord_inqusitor",
};

var PRESTIGES = {
    0: "",
    1: "I",
    2: "II",
    3: "III",
    4: "IV",
    5: "V",
    6: "VI",
    7: "VII",
    8: "IIX",
    9: "IX",
    10: "X",
    11: "XI",
    12: "XII",
    13: "IIXV",
    14: "IXV",
    15: "XV",
    16: "XVI",
    17: "XVII",
    18: "IIXX",
    19: "IXX",
    20: "XX",
};

function serverHasData()
{
    var value = CustomNetTables.GetTableValue("players", "stats")

    return value != null
}

function getPlayerRankValue(pID) {
    var value = CustomNetTables.GetTableValue("players", "stats")

    if (value[pID])
    {
        return value[pID].rating
    }

    return 
};

function getPlayerRank(pID) {
    var table = CustomNetTables.GetTableValue("players", "stats")

    if (table[pID])
    {
        var value = table[pID].rating 

        if (value == 0 || isCalibrated(pID) == false) { return "silver_0" }

        var rank = Math.floor(value / 500);

        return RANKS[rank]
    }

    return "silver_0"
}

function getPlayerPrestige(pID) {
    var table = CustomNetTables.GetTableValue("players", "stats")

    if (table[pID])
    {
        return table[pID].prestige 
    }

    return 0
}

function getPlayerPrestigeIcon(pID) {
    var table = CustomNetTables.GetTableValue("players", "stats")

    if (table[pID])
    {
        return "prestige_" + table[pID].prestige 
    }

    return null
}

function getPlayerPrestigeNumber(pID) {
    var table = CustomNetTables.GetTableValue("players", "stats")

    if (table[pID])
    {
        return PRESTIGES[table[pID].prestige]
    }

    return ""
}

function getMedal(pID) {
    var table = CustomNetTables.GetTableValue("players", "stats")

    if (table[pID])
    {
        return table[pID].displayed_medal 
    }

    return 0
}

function getMedalIcon(medal) 
{
    if (GameUI.CustomUIConfig().Items)
    {
        return GameUI.CustomUIConfig().Items[medal]["item"]
    }

    return ""
}


function getWinrate(pID) 
{
    var table = CustomNetTables.GetTableValue("players", "stats")

    if (table[pID])
    {
        var rate = (table[pID].wins / table[pID].games) * 100
        if (rate == NaN || rate == Infinity || rate == null) rate = 0

        return Math.floor(rate) + "%"
    }

    return "0%"
}

function getPlusSubscribe(pID) 
{
    var table = CustomNetTables.GetTableValue("players", "stats")

    if (table[pID])
    {
        return (table[pID].is_using_plus == 1)
    }

    return false
}

function getGames(pID) 
{
    var table = CustomNetTables.GetTableValue("players", "stats")

    if (table[pID])
    {
        return table[pID].games
    }

    return 0
}

function getHeroes(pID) 
{
    return CustomNetTables.GetTableValue("players", "heroes")
}

function getAverageRating(teamID) {
    var table = CustomNetTables.GetTableValue("players", "stats")
    var value = 1
    var count = 0

    for(var pID in table)
    {
        if (teamID == Players.GetTeam( Number(pID) ))
        {
            value += Number(table[pID].rating)
            count++;
        }
    }

    return count > 0 ? Math.floor(value / count) : "Unknown"
}

function isCalibrated(pID) {
    var table = CustomNetTables.GetTableValue("players", "stats")

    if (table[pID])
    {
        return table[pID].calibrated == 1
    }

    return false
}

function getUNIXTime(pID)
{
    var table = CustomNetTables.GetTableValue("players", "stats")

    if (table[pID])
    {
        return Number(table[pID].plus_expire)
    }

    return Date.now() / 1000 | 0
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

function getSteamID32() {
    var playerInfo = Game.GetPlayerInfo(Game.GetLocalPlayerID());

    var steamID64 = playerInfo.player_steamid,
        steamIDPart = Number(steamID64.substring(3)),
        steamID32 = String(steamIDPart - 61197960265728);

    return steamID32;
}

function isPremium(pID)
{
    var table = CustomNetTables.GetTableValue("players", "stats")

    if (table[pID])
    {
        return Number(table[pID].status) > 0 
    }

    return false
}

function getPlayerAVGStats(pID)
{
    var table = CustomNetTables.GetTableValue("players", "stats")

    if (table[pID])
    {
        var result = new Array()

        result["kills"] = Number(table[pID].kills) / Number(table[pID].games)
        result["deaths"] = Number(table[pID].deaths) / Number(table[pID].games)
        result["last_hits"] = Number(table[pID].last_hits) / Number(table[pID].games)
        result["net_worth"] = Number(table[pID].net_worth) / Number(table[pID].games)
        result["rating"] = Number(table[pID].rating)

        return result
    }

    return null
}

function getTotalGames() {
    var value = 1
    var stats = CustomNetTables.GetTableValue("players", "heroes")

    for(var hero in stats)
    {
        value += Number(stats[hero].picks)
    }

    return Number(value)
};

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

function getKeyByValue(array, value ) {
    for( var prop in array ) {
        if( array.hasOwnProperty( prop ) ) {
             if( array[ prop ] === value )
                 return prop;
        }
    }
}

function ShowPlusTooltip(value, panel) {
    if (!serverHasData()) return;
    if (getPlusSubscribe(Players.GetLocalPlayer()) == true) return; 

    $.DispatchEvent("DOTAShowTextTooltip", $("#PlusButton"), $.Localize("plus_info"));
}

function HidePlusTooltip(value, panel) {
    if (!serverHasData()) return;
    if (getPlusSubscribe(Players.GetLocalPlayer()) == true) return; 

    $.DispatchEvent("DOTAHideTextTooltip", $("#PlusButton"));
}