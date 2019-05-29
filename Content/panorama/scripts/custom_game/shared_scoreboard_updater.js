"use strict";
var Lib = [];
Lib.Globals = [];
Lib.Globals.Inventory = [];

//=============================================================================
//=============================================================================
function _ScoreboardUpdater_SetTextSafe( panel, childName, textValue )
{
	if ( panel === null )
		return;
	var childPanel = panel.FindChildInLayoutFile( childName )
	if ( childPanel === null )
		return;

	childPanel.text = textValue;
}


//=============================================================================
//=============================================================================
function _ScoreboardUpdater_UpdatePlayerPanel( scoreboardConfig, playersContainer, playerId, localPlayerTeamId )
{
	var playerPanelName = "_dynamic_player_" + playerId;
	var playerPanel = playersContainer.FindChild( playerPanelName );
	if ( playerPanel === null )
	{
		playerPanel = $.CreatePanel( "Panel", playersContainer, playerPanelName );
		playerPanel.SetAttributeInt( "player_id", playerId );
		playerPanel.BLoadLayout( scoreboardConfig.playerXmlName, false, false );
	}

	playerPanel.SetHasClass( "is_local_player", ( playerId == Game.GetLocalPlayerID() ) );

	var ultStateOrTime = PlayerUltimateStateOrTime_t.PLAYER_ULTIMATE_STATE_HIDDEN; // values > 0 mean on cooldown for that many seconds
	var goldValue = -1;
	var isTeammate = false;

	var playerInfo = Game.GetPlayerInfo( playerId );
	if ( playerInfo )
	{
		isTeammate = ( playerInfo.player_team_id == localPlayerTeamId );
		if ( isTeammate )
		{
			ultStateOrTime = Game.GetPlayerUltimateStateOrTime( playerId );
		}
		goldValue = playerInfo.player_gold;

		playerPanel.SetHasClass( "player_dead", ( playerInfo.player_respawn_seconds >= 0 ) );
		playerPanel.SetHasClass( "local_player_teammate", isTeammate && ( playerId != Game.GetLocalPlayerID() ) );

		_ScoreboardUpdater_SetTextSafe( playerPanel, "RespawnTimer", ( playerInfo.player_respawn_seconds + 1 ) ); // value is rounded down so just add one for rounded-up
		_ScoreboardUpdater_SetTextSafe( playerPanel, "PlayerName", playerInfo.player_name );
		_ScoreboardUpdater_SetTextSafe( playerPanel, "Level", playerInfo.player_level );
		_ScoreboardUpdater_SetTextSafe( playerPanel, "Kills", playerInfo.player_kills );
		_ScoreboardUpdater_SetTextSafe( playerPanel, "Deaths", playerInfo.player_deaths );
		_ScoreboardUpdater_SetTextSafe( playerPanel, "Assists", playerInfo.player_assists );

		var playerPortrait = playerPanel.FindChildInLayoutFile( "HeroIcon" );

		if (playerPortrait)
		{
			var mouseOverCapture = (function(playerPanel, playerId) {
				return function() { OnInspectPlayer(playerPanel, playerId) }
			}
			(playerPanel, playerId));
	
			var mouseOutCapture = (function(playerPanel) {
				return function() { OnInspectPlayerEnd(playerPanel) }
			}
			(playerPanel));
	
			playerPanel.SetPanelEvent("onmouseover", mouseOverCapture);
			playerPanel.SetPanelEvent("onmouseout", mouseOutCapture);
		}

		var playerRating = playerPanel.FindChildInLayoutFile( "RatingContainer" );
		
		if (playerRating && serverHasData())
		{
			playerRating.style.backgroundImage = 'url("s2r://panorama/images/ranks/'+ getPlayerRank(playerId) +'_png.vtex")';	
		}

		var PrestigeContainer = playerPanel.FindChildInLayoutFile( "PrestigeContainer" );

		if (serverHasData() && getMedal(playerId) != 0 && PrestigeContainer)
		{
			if (getMedalIcon(getMedal(playerId)) != ""){
				PrestigeContainer.style.backgroundImage = 'url("s2r://panorama/images/econs/'+ getMedalIcon(getMedal(playerId)) +'_png.vtex")';
			}
		}

		if ( playerPortrait )
		{
			if ( playerInfo.player_selected_hero !== "" )
			{
				var hero_entindex = Players.GetPlayerHeroEntityIndex( playerId )
				if (playerInfo.player_selected_hero == "npc_dota_hero_templar_assassin" && hasModifier(hero_entindex, "modifier_neo_noir"))
				{
			    		playerPortrait.SetImage( "file://{images}/custom_game/heroes/neo_noir.png" );
				}
				else if (playerInfo.player_selected_hero == "npc_dota_hero_nyx_assassin" && hasModifier(hero_entindex, "modifier_the_firs_hunter"))
				{
			    		playerPortrait.SetImage( "file://{images}/custom_game/heroes/the_first_hunter.png" );
				}
				else if (playerInfo.player_selected_hero == "npc_dota_hero_nevermore" && hasModifier(hero_entindex, "modifier_dante"))
				{
			    		playerPortrait.SetImage( "file://{images}/custom_game/heroes/dante.png" );
				}
				else if (playerInfo.player_selected_hero == "npc_dota_hero_weaver" && hasModifier(hero_entindex, "modifier_doomsday_clock"))
				{
			    		playerPortrait.SetImage( "file://{images}/custom_game/heroes/reverse_flash_custommade.png" );
				}
				else if (playerInfo.player_selected_hero == "npc_dota_hero_razor" && hasModifier(hero_entindex, "modifier_zoom_kalyaska_gold"))
				{
			    		playerPortrait.SetImage( "file://{images}/custom_game/heroes/golden_wheelchair.png" );
				}
				else if (playerInfo.player_selected_hero == "npc_dota_hero_enchantress" && hasModifier(hero_entindex, "modifier_arcana"))
				{
			   	 	playerPortrait.SetImage( "file://{images}/custom_game/heroes/sombra.png" );
				}
				else if (playerInfo.player_selected_hero == "npc_dota_hero_dark_rider" && hasModifier(hero_entindex, "modifier_arcana"))
				{
			    		playerPortrait.SetImage( "file://{images}/custom_game/heroes/hit.png" );
				}
				else if (playerInfo.player_selected_hero == "npc_dota_hero_miraak" && hasModifier(hero_entindex, "modifier_arcana"))
				{
			    		playerPortrait.SetImage( "file://{images}/custom_game/heroes/megumin.png" );
				}
				else if (playerInfo.player_selected_hero == "npc_dota_hero_invoker" && hasModifier(hero_entindex, "modifier_alma"))
				{
			   	 	playerPortrait.SetImage( "file://{images}/custom_game/heroes/alma_collector.png" );
				}
				else if (playerInfo.player_selected_hero == "npc_dota_hero_bloodseeker" && hasModifier(hero_entindex, "modifier_flash_custom"))
				{
			    		playerPortrait.SetImage( "file://{images}/custom_game/heroes/flash_custom.png" );
				}
				else if (playerInfo.player_selected_hero == "npc_dota_hero_shredder" && hasModifier(hero_entindex, "modifier_nemesis"))
				{
			   	 	playerPortrait.SetImage( "file://{images}/custom_game/heroes/nemesis_custom.png" );
				}
				else if (playerInfo.player_selected_hero == "npc_dota_hero_dazzle" && hasModifier(hero_entindex, "modifier_joker_custom"))
				{
			    		playerPortrait.SetImage( "file://{images}/custom_game/heroes/joker_custom.png" );
				}
				else if (playerInfo.player_selected_hero == "npc_dota_hero_queenofpain" && hasModifier(hero_entindex, "modifier_voland_custom"))
				{
			    		playerPortrait.SetImage( "file://{images}/custom_game/heroes/voland_arcana.png" );
				}
				else if (playerInfo.player_selected_hero == "npc_dota_hero_rattletrap" && hasModifier(hero_entindex, "modifier_jeannie_arcana"))
				{
			    		playerPortrait.SetImage( "file://{images}/custom_game/heroes/jeanne_custom.png" );
				}
				else if (playerInfo.player_selected_hero == "npc_dota_hero_disruptor" && hasModifier(hero_entindex, "modifier_pugalo"))
				{
			    		playerPortrait.SetImage( "file://{images}/custom_game/heroes/pugalo.png" );
				}
				else if (playerInfo.player_selected_hero == "npc_dota_hero_spirit_breaker" && hasModifier(hero_entindex, "modifier_deadshot"))
				{
			    		playerPortrait.SetImage( "file://{images}/custom_game/heroes/deadshot.png" );
				}
				else if (playerInfo.player_selected_hero == "npc_dota_hero_grimskull" && hasModifier(hero_entindex, "modifier_custom_unique"))
				{
			    		playerPortrait.SetImage( "file://{images}/custom_game/heroes/psyloc_icon.png" );
				}
				else if (playerInfo.player_selected_hero == "npc_dota_hero_abyssal_underlord" && hasModifier(hero_entindex, "modifier_custom_unique"))
				{
			    		playerPortrait.SetImage( "file://{images}/custom_game/heroes/ciri_icon.png" );
				}
				else if (playerInfo.player_selected_hero == "npc_dota_hero_jetstream_sam" && hasModifier(hero_entindex, "modifier_custom_unique"))
				{
			    		playerPortrait.SetImage( "file://{images}/custom_game/heroes/ciri_icon.png" );
				}
				else if (playerInfo.player_selected_hero == "npc_dota_hero_shadow_demon" && hasModifier(hero_entindex, "modifier_sargeras_s7_custom"))
				{
			    		playerPortrait.SetImage( "file://{images}/custom_game/heroes/sargeras_devourer_of_words_icon.png" );
				}
				else if (playerInfo.player_selected_hero == "npc_dota_hero_magnataur" && hasModifier(hero_entindex, "modifier_nike"))
				{
			    		playerPortrait.SetImage( "file://{images}/custom_game/heroes/nike_icon.png" );
				}
				else
				{
					playerPortrait.SetImage( "file://{images}/custom_game/heroes/" + playerInfo.player_selected_hero + ".png" );
				}
			}
			else
			{
				playerPortrait.SetImage( "file://{images}/custom_game/unassigned.png" );
			}
		}

		if ( playerInfo.player_selected_hero_id == -1 )
		{
			_ScoreboardUpdater_SetTextSafe( playerPanel, "HeroName", $.Localize( "#DOTA_Scoreboard_Picking_Hero" ) )
		}
		else
		{
			_ScoreboardUpdater_SetTextSafe( playerPanel, "HeroName", $.Localize( "#"+playerInfo.player_selected_hero ) )
		}

		var heroNameAndDescription = playerPanel.FindChildInLayoutFile( "HeroNameAndDescription" );
		if ( heroNameAndDescription )
		{
			if ( playerInfo.player_selected_hero_id == -1 )
			{
				heroNameAndDescription.SetDialogVariable( "hero_name", $.Localize( "#DOTA_Scoreboard_Picking_Hero" ) );
			}
			else
			{
				heroNameAndDescription.SetDialogVariable( "hero_name", $.Localize( "#"+playerInfo.player_selected_hero ) );
			}
			heroNameAndDescription.SetDialogVariableInt( "hero_level",  playerInfo.player_level );
		}

		playerPanel.SetHasClass( "player_connection_abandoned", playerInfo.player_connection_state == DOTAConnectionState_t.DOTA_CONNECTION_STATE_ABANDONED );
		playerPanel.SetHasClass( "player_connection_failed", playerInfo.player_connection_state == DOTAConnectionState_t.DOTA_CONNECTION_STATE_FAILED );
		playerPanel.SetHasClass( "player_connection_disconnected", playerInfo.player_connection_state == DOTAConnectionState_t.DOTA_CONNECTION_STATE_DISCONNECTED );

		var playerAvatar = playerPanel.FindChildInLayoutFile( "AvatarImage" );
		if ( playerAvatar )
		{
			playerAvatar.steamid = playerInfo.player_steamid;
		}

		var playerColorBar = playerPanel.FindChildInLayoutFile( "PlayerColorBar" );
		if ( playerColorBar !== null )
		{
			if ( GameUI.CustomUIConfig().team_colors )
			{
				var teamColor = GameUI.CustomUIConfig().team_colors[ playerInfo.player_team_id ];
				if ( teamColor )
				{
					playerColorBar.style.backgroundColor = teamColor;
				}
			}
			else
			{
				var playerColor = "#000000";
				playerColorBar.style.backgroundColor = playerColor;
			}
		}
	}

	var playerItemsContainer = playerPanel.FindChildInLayoutFile( "PlayerItemsContainer" );
	if ( playerItemsContainer )
	{
		var playerItems = Game.GetPlayerItems( playerId );
		if ( playerItems )
		{
	//		$.Msg( "playerItems = ", playerItems );
			for ( var i = playerItems.inventory_slot_min; i < playerItems.inventory_slot_max; ++i )
			{
				var itemPanelName = "_dynamic_item_" + i;
				var itemPanel = playerItemsContainer.FindChild( itemPanelName );
				if ( itemPanel === null )
				{
					itemPanel = $.CreatePanel( "Image", playerItemsContainer, itemPanelName );
					itemPanel.AddClass( "PlayerItem" );
				}

				var itemInfo = playerItems.inventory[i];
				if ( itemInfo )
				{
					var item_image_name = "file://{images}/items/" + itemInfo.item_name.replace( "item_", "" ) + ".png"
					if ( itemInfo.item_name.indexOf( "recipe" ) >= 0 )
					{
						item_image_name = "file://{images}/items/recipe.png"
					}
					itemPanel.SetImage( item_image_name );
				}
				else
				{
					itemPanel.SetImage( "" );
				}
			}
		}
	}

	if ( isTeammate )
	{
		_ScoreboardUpdater_SetTextSafe( playerPanel, "TeammateGoldAmount", goldValue );
	}

	_ScoreboardUpdater_SetTextSafe( playerPanel, "PlayerGoldAmount", goldValue );

	playerPanel.SetHasClass( "player_ultimate_ready", ( ultStateOrTime == PlayerUltimateStateOrTime_t.PLAYER_ULTIMATE_STATE_READY ) );
	playerPanel.SetHasClass( "player_ultimate_no_mana", ( ultStateOrTime == PlayerUltimateStateOrTime_t.PLAYER_ULTIMATE_STATE_NO_MANA) );
	playerPanel.SetHasClass( "player_ultimate_not_leveled", ( ultStateOrTime == PlayerUltimateStateOrTime_t.PLAYER_ULTIMATE_STATE_NOT_LEVELED) );
	playerPanel.SetHasClass( "player_ultimate_hidden", ( ultStateOrTime == PlayerUltimateStateOrTime_t.PLAYER_ULTIMATE_STATE_HIDDEN) );
	playerPanel.SetHasClass( "player_ultimate_cooldown", ( ultStateOrTime > 0 ) );
	_ScoreboardUpdater_SetTextSafe( playerPanel, "PlayerUltimateCooldown", ultStateOrTime );
}


//=============================================================================
//=============================================================================
function _ScoreboardUpdater_UpdateTeamPanel( scoreboardConfig, containerPanel, teamDetails, teamsInfo )
{
	if ( !containerPanel )
		return;

	var teamId = teamDetails.team_id;
//	$.Msg( "_ScoreboardUpdater_UpdateTeamPanel: ", teamId );

	var teamPanelName = "_dynamic_team_" + teamId;
	var teamPanel = containerPanel.FindChild( teamPanelName );
	if ( teamPanel === null )
	{
//		$.Msg( "UpdateTeamPanel.Create: ", teamPanelName, " = ", scoreboardConfig.teamXmlName );
		teamPanel = $.CreatePanel( "Panel", containerPanel, teamPanelName );
		teamPanel.SetAttributeInt( "team_id", teamId );
		teamPanel.BLoadLayout( scoreboardConfig.teamXmlName, false, false );

		var logo_xml = GameUI.CustomUIConfig().team_logo_xml;
		if ( logo_xml )
		{
			var teamLogoPanel = teamPanel.FindChildInLayoutFile( "TeamLogo" );
			if ( teamLogoPanel )
			{
				teamLogoPanel.SetAttributeInt( "team_id", teamId );
				teamLogoPanel.BLoadLayout( logo_xml, false, false );
			}
		}
	}

	var localPlayerTeamId = -1;
	var localPlayer = Game.GetLocalPlayerInfo();
	if ( localPlayer )
	{
		localPlayerTeamId = localPlayer.player_team_id;
	}
	teamPanel.SetHasClass( "local_player_team", localPlayerTeamId == teamId );
	teamPanel.SetHasClass( "not_local_player_team", localPlayerTeamId != teamId );

	var teamPlayers = Game.GetPlayerIDsOnTeam( teamId )
	var playersContainer = teamPanel.FindChildInLayoutFile( "PlayersContainer" );
	if ( playersContainer )
	{
		for ( var playerId of teamPlayers )
		{
			_ScoreboardUpdater_UpdatePlayerPanel( scoreboardConfig, playersContainer, playerId, localPlayerTeamId )
		}
	}

	teamPanel.SetHasClass( "no_players", (teamPlayers.length == 0) )
	teamPanel.SetHasClass( "one_player", (teamPlayers.length == 1) )

	if ( teamsInfo.max_team_players < teamPlayers.length )
	{
		teamsInfo.max_team_players = teamPlayers.length;
	}

	_ScoreboardUpdater_SetTextSafe( teamPanel, "TeamScore", teamDetails.team_score )
	_ScoreboardUpdater_SetTextSafe( teamPanel, "TeamName", $.Localize( teamDetails.team_name ) )

	if ( GameUI.CustomUIConfig().team_colors )
	{
		var teamColor = GameUI.CustomUIConfig().team_colors[ teamId ];
		var teamColorPanel = teamPanel.FindChildInLayoutFile( "TeamColor" );

		if (teamColor && teamColorPanel)
		{
			teamColor = teamColor.replace( ";", "" );

			if ( teamColorPanel )
			{
				teamNamePanel.style.backgroundColor = teamColor + ";";
			}

			var teamColor_GradentFromTransparentLeft = teamPanel.FindChildInLayoutFile( "TeamColor_GradentFromTransparentLeft" );
			if ( teamColor_GradentFromTransparentLeft )
			{
				var gradientText = 'gradient( linear, 0% 0%, 800% 0%, from( #00000000 ), to( ' + teamColor + ' ) );';
	//			$.Msg( gradientText );
				teamColor_GradentFromTransparentLeft.style.backgroundColor = gradientText;
			}
		}
	}

	return teamPanel;
}

//=============================================================================
//=============================================================================
function _ScoreboardUpdater_ReorderTeam( scoreboardConfig, teamsParent, teamPanel, teamId, newPlace, prevPanel )
{
//	$.Msg( "UPDATE: ", GameUI.CustomUIConfig().teamsPrevPlace );
	var oldPlace = null;
	if ( GameUI.CustomUIConfig().teamsPrevPlace.length > teamId )
	{
		oldPlace = GameUI.CustomUIConfig().teamsPrevPlace[ teamId ];
	}
	GameUI.CustomUIConfig().teamsPrevPlace[ teamId ] = newPlace;

	if ( newPlace != oldPlace )
	{
//		$.Msg( "Team ", teamId, " : ", oldPlace, " --> ", newPlace );
		teamPanel.RemoveClass( "team_getting_worse" );
		teamPanel.RemoveClass( "team_getting_better" );
		if ( newPlace > oldPlace )
		{
			teamPanel.AddClass( "team_getting_worse" );
		}
		else if ( newPlace < oldPlace )
		{
			teamPanel.AddClass( "team_getting_better" );
		}
	}

	teamsParent.MoveChildAfter( teamPanel, prevPanel );
}

// sort / reorder as necessary
function compareFunc( a, b ) // GameUI.CustomUIConfig().sort_teams_compare_func;
{
	if ( a.team_score < b.team_score )
	{
		return 1; // [ B, A ]
	}
	else if ( a.team_score > b.team_score )
	{
		return -1; // [ A, B ]
	}
	else
	{
		return 0;
	}
};

function stableCompareFunc( a, b )
{
	var unstableCompare = compareFunc( a, b );
	if ( unstableCompare != 0 )
	{
		return unstableCompare;
	}

	if ( GameUI.CustomUIConfig().teamsPrevPlace.length <= a.team_id )
	{
		return 0;
	}

	if ( GameUI.CustomUIConfig().teamsPrevPlace.length <= b.team_id )
	{
		return 0;
	}

//			$.Msg( GameUI.CustomUIConfig().teamsPrevPlace );

	var a_prev = GameUI.CustomUIConfig().teamsPrevPlace[ a.team_id ];
	var b_prev = GameUI.CustomUIConfig().teamsPrevPlace[ b.team_id ];
	if ( a_prev < b_prev ) // [ A, B ]
	{
		return -1; // [ A, B ]
	}
	else if ( a_prev > b_prev ) // [ B, A ]
	{
		return 1; // [ B, A ]
	}
	else
	{
		return 0;
	}
};

//=============================================================================
//=============================================================================
function _ScoreboardUpdater_UpdateAllTeamsAndPlayers( scoreboardConfig, teamsContainer )
{
//	$.Msg( "_ScoreboardUpdater_UpdateAllTeamsAndPlayers: ", scoreboardConfig );

	var teamsList = [];
	for ( var teamId of Game.GetAllTeamIDs() )
	{
		teamsList.push( Game.GetTeamDetails( teamId ) );
	}

	// update/create team panels
	var teamsInfo = { max_team_players: 0 };
	var panelsByTeam = [];
	for ( var i = 0; i < teamsList.length; ++i )
	{
		var teamPanel = _ScoreboardUpdater_UpdateTeamPanel( scoreboardConfig, teamsContainer, teamsList[i], teamsInfo );
		if ( teamPanel )
		{
			panelsByTeam[ teamsList[i].team_id ] = teamPanel;
		}
	}

	if ( teamsList.length > 1 )
	{
//		$.Msg( "panelsByTeam: ", panelsByTeam );

		// sort
		if ( scoreboardConfig.shouldSort )
		{
			teamsList.sort( stableCompareFunc );
		}

//		$.Msg( "POST: ", teamsAndPanels );

		// reorder the panels based on the sort
		var prevPanel = panelsByTeam[ teamsList[0].team_id ];
		for ( var i = 0; i < teamsList.length; ++i )
		{
			var teamId = teamsList[i].team_id;
			var teamPanel = panelsByTeam[ teamId ];
			_ScoreboardUpdater_ReorderTeam( scoreboardConfig, teamsContainer, teamPanel, teamId, i, prevPanel );
			prevPanel = teamPanel;
		}
//		$.Msg( GameUI.CustomUIConfig().teamsPrevPlace );
	}

//	$.Msg( "END _ScoreboardUpdater_UpdateAllTeamsAndPlayers: ", scoreboardConfig );
}

function hasModifier(entity, modifier_name) {
	var num = Entities.GetNumBuffs( entity )
	
    for (var i = 0; i <= num; i++) {
        if (Buffs.GetName( entity, i ) == modifier_name)
        {
            return true
        }
    }
    return false
}

//=============================================================================
//=============================================================================
function ScoreboardUpdater_InitializeScoreboard( scoreboardConfig, scoreboardPanel )
{
	GameUI.CustomUIConfig().teamsPrevPlace = [];
	if ( typeof(scoreboardConfig.shouldSort) === 'undefined')
	{
		// default to true
		scoreboardConfig.shouldSort = true;
	}
	_ScoreboardUpdater_UpdateAllTeamsAndPlayers( scoreboardConfig, scoreboardPanel );
	return { "scoreboardConfig": scoreboardConfig, "scoreboardPanel":scoreboardPanel }
}


//=============================================================================
//=============================================================================
function ScoreboardUpdater_SetScoreboardActive( scoreboardHandle, isActive )
{
	if ( scoreboardHandle.scoreboardConfig === null || scoreboardHandle.scoreboardPanel === null )
	{
		return;
	}

	if ( isActive )
	{
		_ScoreboardUpdater_UpdateAllTeamsAndPlayers( scoreboardHandle.scoreboardConfig, scoreboardHandle.scoreboardPanel );
	}
}

//=============================================================================
//=============================================================================
function ScoreboardUpdater_GetTeamPanel( scoreboardHandle, teamId )
{
	if ( scoreboardHandle.scoreboardPanel === null )
	{
		return;
	}

	var teamPanelName = "_dynamic_team_" + teamId;
	return scoreboardHandle.scoreboardPanel.FindChild( teamPanelName );
}

//=============================================================================
//=============================================================================
function ScoreboardUpdater_GetSortedTeamInfoList( scoreboardHandle )
{
	var teamsList = [];
	for ( var teamId of Game.GetAllTeamIDs() )
	{
		teamsList.push( Game.GetTeamDetails( teamId ) );
	}

	if ( teamsList.length > 1 )
	{
		teamsList.sort( stableCompareFunc );
	}

	return teamsList;
}

function serverHasData()
{
    var value = CustomNetTables.GetTableValue("players", "stats")

    return value != null
}

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

function OnInspectPlayer(panel, pID) {
    $.DispatchEvent("UIShowCustomLayoutParametersTooltip", panel, "PlayerTooltip", "file://{resources}/layout/custom_game/tooltips/player_tooltip.xml", "player=" + pID);
}

function OnInspectPlayerEnd(panel) {
    $.DispatchEvent("UIHideCustomLayoutTooltip", panel, "PlayerTooltip");
}