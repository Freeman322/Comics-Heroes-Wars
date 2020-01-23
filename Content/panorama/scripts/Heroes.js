"use strict";

var Heroes = {}

Heroes.list = {
    "heroes": [{
            "name": "npc_dota_hero_antimage",
            "id": 1,
        },
        {
            "name": "npc_dota_hero_axe",
            "id": 2,
        },
        {
            "name": "npc_dota_hero_bane",
            "id": 3,
        },
        {
            "name": "npc_dota_hero_bloodseeker",
            "id": 4,
        },
        {
            "name": "npc_dota_hero_crystal_maiden",
            "id": 5,
        },
        {
            "name": "npc_dota_hero_drow_ranger",
            "id": 6,
        },
        {
            "name": "npc_dota_hero_earthshaker",
            "id": 7,
        },
        {
            "name": "npc_dota_hero_juggernaut",
            "id": 8,
        },
        {
            "name": "npc_dota_hero_mirana",
            "id": 9,
        },
        {
            "name": "npc_dota_hero_nevermore",
            "id": 11,
        },
        {
            "name": "npc_dota_hero_carnange",
            "id": 10,
        },
        {
            "name": "npc_dota_hero_phantom_lancer",
            "id": 12,
        },
        {
            "name": "npc_dota_hero_puck",
            "id": 13,
        },
        {
            "name": "npc_dota_hero_pudge",
            "id": 14,
        },
        {
            "name": "npc_dota_hero_razor",
            "id": 15,
        },
        {
            "name": "npc_dota_hero_sand_king",
            "id": 16,
        },
        {
            "name": "npc_dota_hero_storm_spirit",
            "id": 17,
        },
        {
            "name": "npc_dota_hero_sven",
            "id": 18,
        },
        {
            "name": "npc_dota_hero_tiny",
            "id": 19,
        },
        {
            "name": "npc_dota_hero_vengefulspirit",
            "id": 20,
        },
        {
            "name": "npc_dota_hero_windrunner",
            "id": 21,
        },
        {
            "name": "npc_dota_hero_zuus",
            "id": 22,
        },
        {
            "name": "npc_dota_hero_kunkka",
            "id": 23,
        },
        {
            "name": "npc_dota_hero_lina",
            "id": 25,
        },
        {
            "name": "npc_dota_hero_lich",
            "id": 31,
        },
        {
            "name": "npc_dota_hero_lion",
            "id": 26,
        },
        {
            "name": "npc_dota_hero_shadow_shaman",
            "id": 27,
        },
        {
            "name": "npc_dota_hero_slardar",
            "id": 28,
        },
        {
            "name": "npc_dota_hero_tidehunter",
            "id": 29,
        },
        {
            "name": "npc_dota_hero_witch_doctor",
            "id": 30,
        },
        {
            "name": "npc_dota_hero_riki",
            "id": 32,
        },
        {
            "name": "npc_dota_hero_enigma",
            "id": 33,
        },
        {
            "name": "npc_dota_hero_tinker",
            "id": 34,
        },
        {
            "name": "npc_dota_hero_sniper",
            "id": 35,
        },
        {
            "name": "npc_dota_hero_necrolyte",
            "id": 36,
        },
        {
            "name": "npc_dota_hero_warlock",
            "id": 37,
        },
        {
            "name": "npc_dota_hero_beastmaster",
            "id": 38,
        },
        {
            "name": "npc_dota_hero_queenofpain",
            "id": 39,
        },
        {
            "name": "npc_dota_hero_venomancer",
            "id": 40,
        },
        {
            "name": "npc_dota_hero_faceless_void",
            "id": 41,
        },
        {
            "name": "npc_dota_hero_skeleton_king",
            "id": 42,
        },
        {
            "name": "npc_dota_hero_death_prophet",
            "id": 43,
        },
        {
            "name": "npc_dota_hero_phantom_assassin",
            "id": 44,
        },
        {
            "name": "npc_dota_hero_pugna",
            "id": 45,
        },
        {
            "name": "npc_dota_hero_templar_assassin",
            "id": 46,
        },
        {
            "name": "npc_dota_hero_viper",
            "id": 47,
        },
        {
            "name": "npc_dota_hero_luna",
            "id": 48,
        },
        {
            "name": "npc_dota_hero_dragon_knight",
            "id": 49,
        },
        {
            "name": "npc_dota_hero_dazzle",
            "id": 50,
        },
        {
            "name": "npc_dota_hero_rattletrap",
            "id": 51,
        },
        {
            "name": "npc_dota_hero_leshrac",
            "id": 52,
        },
        {
            "name": "npc_dota_hero_furion",
            "id": 53,
        },
        {
            "name": "npc_dota_hero_life_stealer",
            "id": 54,
        },
        {
            "name": "npc_dota_hero_dark_seer",
            "id": 55,
        },
        {
            "name": "npc_dota_hero_clinkz",
            "id": 56,
        },
        {
            "name": "npc_dota_hero_omniknight",
            "id": 57,
        },
        {
            "name": "npc_dota_hero_enchantress",
            "id": 58,
        },
        {
            "name": "npc_dota_hero_huskar",
            "id": 59,
        },
        {
            "name": "npc_dota_hero_night_stalker",
            "id": 60,
        },
        {
            "name": "npc_dota_hero_broodmother",
            "id": 61,
        },
        {
            "name": "npc_dota_hero_bounty_hunter",
            "id": 62,
        },
        {
            "name": "npc_dota_hero_weaver",
            "id": 63,
        },
        {
            "name": "npc_dota_hero_jakiro",
            "id": 64,
        },
        {
            "name": "npc_dota_hero_batrider",
            "id": 65,
        },
        {
            "name": "npc_dota_hero_chen",
            "id": 66,
        },
        {
            "name": "npc_dota_hero_spectre",
            "id": 67,
        },
        {
            "name": "npc_dota_hero_doom_bringer",
            "id": 69,
        },
        {
            "name": "npc_dota_hero_ancient_apparition",
            "id": 68,
        },
        {
            "name": "npc_dota_hero_ursa",
            "id": 70,
        },
        {
            "name": "npc_dota_hero_spirit_breaker",
            "id": 71,
        },
        {
            "name": "npc_dota_hero_gyrocopter",
            "id": 72,
        },
        {
            "name": "npc_dota_hero_alchemist",
            "id": 73,
        },
        {
            "name": "npc_dota_hero_invoker",
            "id": 74,
        },
        {
            "name": "npc_dota_hero_silencer",
            "id": 75,
        },
        {
            "name": "npc_dota_hero_obsidian_destroyer",
            "id": 76,
        },
        {
            "name": "npc_dota_hero_lycan",
            "id": 77,
        },
        {
            "name": "npc_dota_hero_brewmaster",
            "id": 78,
        },
        {
            "name": "npc_dota_hero_shadow_demon",
            "id": 79,
        },
        {
            "name": "npc_dota_hero_lone_druid",
            "id": 80,
        },
        {
            "name": "npc_dota_hero_chaos_knight",
            "id": 81,
        },
        {
            "name": "npc_dota_hero_meepo",
            "id": 82,
        },
        {
            "name": "npc_dota_hero_treant",
            "id": 83,
        },
        {
            "name": "npc_dota_hero_ogre_magi",
            "id": 84,
        },
        {
            "name": "npc_dota_hero_undying",
            "id": 85,
        },
        {
            "name": "npc_dota_hero_rubick",
            "id": 86,
        },
        {
            "name": "npc_dota_hero_disruptor",
            "id": 87,
        },
        {
            "name": "npc_dota_hero_nyx_assassin",
            "id": 88,
        },
        {
            "name": "npc_dota_hero_naga_siren",
            "id": 89,
        },
        {
            "name": "npc_dota_hero_keeper_of_the_light",
            "id": 90,
        },
        {
            "name": "npc_dota_hero_wisp",
            "id": 91,
        },
        {
            "name": "npc_dota_hero_visage",
            "id": 92,
        },
        {
            "name": "npc_dota_hero_slark",
            "id": 93,
        },
        {
            "name": "npc_dota_hero_medusa",
            "id": 94,
        },
        {
            "name": "npc_dota_hero_troll_warlord",
            "id": 95,
        },
        {
            "name": "npc_dota_hero_centaur",
            "id": 96,
        },
        {
            "name": "npc_dota_hero_magnataur",
            "id": 97,
        },
        {
            "name": "npc_dota_hero_shredder",
            "id": 98,
        },
        {
            "name": "npc_dota_hero_bristleback",
            "id": 99,
        },
        {
            "name": "npc_dota_hero_tusk",
            "id": 100,
        },
        {
            "name": "npc_dota_hero_skywrath_mage",
            "id": 101,
        },
        {
            "name": "npc_dota_hero_abaddon",
            "id": 102,
        },
        {
            "name": "npc_dota_hero_elder_titan",
            "id": 103,
        },
        {
            "name": "npc_dota_hero_legion_commander",
            "id": 104,
        },
        {
            "name": "npc_dota_hero_ember_spirit",
            "id": 106,
        },
        {
            "name": "npc_dota_hero_earth_spirit",
            "id": 107,
        },
        {
            "name": "npc_dota_hero_abyssal_underlord",
            "id": 108,
        },
        {
            "name": "npc_dota_hero_terrorblade",
            "id": 109,
        },
        {
            "name": "npc_dota_hero_phoenix",
            "id": 110,
        },
        {
            "name": "npc_dota_hero_techies",
            "id": 105,
        },
        {
            "name": "npc_dota_hero_oracle",
            "id": 111,
        },
        {
            "name": "npc_dota_hero_winter_wyvern",
            "id": 112,
        },
        {
            "name": "npc_dota_hero_arc_warden",
            "id": 113,
        },
        {
            "name": "npc_dota_hero_monkey_king",
            "id": 114,
        },
        {
            "name": "npc_dota_hero_pangolier",
            "id": 120,
        },
        {
            "name": "npc_dota_hero_dark_willow",
            "id": 119,
        },
        {
            "name": "npc_dota_hero_grimstroke",
            "id": 121,
        },
        {
            "name": "npc_dota_hero_miraak",
            "id": 200,
        },
        {
            "name": "npc_dota_hero_godspeed",
            "id": 202,
        },
        {
            "name": "npc_dota_hero_savitar",
            "id": 203,
        },
        {
            "name": "npc_dota_hero_ghost",
            "id": 201,
        },
        {
            "name": "npc_dota_hero_superman",
            "id": 204,
        },
        {
            "name": "npc_dota_hero_molag_bal",
            "id": 205,
        },
        {
            "name": "npc_dota_hero_doctor_fate",
            "id": 206,
        },
        {
            "name": "npc_dota_hero_mercer",
            "id": 207,
        },
        {
            "name": "npc_dota_hero_ezekyle",
            "id": 208,
        },
        {
            "name": "npc_dota_hero_kyloren",
            "id": 209,
        },
        {
            "name": "npc_dota_hero_mercy",
            "id": 210,
        },
        {
            "name": "npc_dota_hero_dark_rider",
            "id": 211,
        },
        {
            "name": "npc_dota_hero_grimskull",
            "id": 212,
        },
        {
            "name": "npc_dota_hero_kratos",
            "id": 213,
        },
        {
            "name": "npc_dota_hero_warboss",
            "id": 214,
        },
        {
            "name": "npc_dota_hero_cosmos",
            "id": 215,
        },
        {
            "name": "npc_dota_hero_jetstream_sam",
            "id": 216,
        },
        {
            "name": "npc_dota_hero_raiden",
            "id": 217,
        },
        {
            "name": "npc_dota_hero_misterio",
            "id": 218,
        },
        {
            "name": "npc_dota_hero_shazam",
            "id": 219,
        },
        {
            "name": "npc_dota_hero_ogre",
            "id": 220,
        },
        {
            "name": "npc_dota_hero_baane",
            "id": 221,
        },
        {
            "name": "npc_dota_hero_officer",
            "id": 222,
        },
        {
            "name": "npc_dota_hero_mod",
            "id": 223,
        },
        {
            "name": "npc_dota_hero_valkorion",
            "id": 224,
        },
        {
            "name": "npc_dota_hero_pennywise",
            "id": 227,
        },
        {
            "name": "npc_dota_hero_chaos_king",
            "id": 331,
        },
        {
            "name": "npc_dota_hero_aqua_man",
            "id": 232,
        },
        {
            "name": "npc_dota_hero_gorr",
            "id": 233,
        }
    ]
}

Heroes.GetHeroID = function(hero_name) {
    for (var i = 0; i < Heroes.list.heroes.length; i++) {
        if (Heroes.list.heroes[i].name == hero_name) {
            return Heroes.list.heroes[i].id;
        }
    }

    return 1
}


Heroes.GetAbilities = function(hero_name) {
    var abils = GameUI.CustomUIConfig().PlayerTables.GetTableValue("heroes_abilities", "abilities")

    if (abils != null && abils != undefined)
    {
        return abils[hero_name]
    }

    return []
}
