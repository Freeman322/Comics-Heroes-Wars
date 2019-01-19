"use strict";

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

