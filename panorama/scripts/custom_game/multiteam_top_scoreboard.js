"use strict";

var g_ScoreboardHandle = null;

function UpdateScoreboard()
{
	ScoreboardUpdater_SetScoreboardActive( g_ScoreboardHandle, true );
	var time = Game.GetDOTATime( false, false )
	if ($("#Minutes") && $("#Seconds")){
		$("#Minutes").text = (Math.ceil(time / 60))
		$("#Seconds").text = Math.ceil(time % 60)
	}

	$.Schedule( 0.2, UpdateScoreboard );
}

function OnTimeChanged(data) {
	var time = data['time']

	if($("#TimeLeft")) { $("#TimeLeft").text = time }
}

(function()
{
	var shouldSort = true;

	if ( GameUI.CustomUIConfig().multiteam_top_scoreboard )
	{
		var cfg = GameUI.CustomUIConfig().multiteam_top_scoreboard;
		if ( cfg.LeftInjectXMLFile )
		{
			$( "#LeftInjectXMLFile" ).BLoadLayout( cfg.LeftInjectXMLFile, false, false );
		}
		if ( typeof(cfg.shouldSort) !== 'undefined')
		{
			shouldSort = cfg.shouldSort;
		}
	}

	if ( ScoreboardUpdater_InitializeScoreboard === null ) { $.Msg( "WARNING: This file requires shared_scoreboard_updater.js to be included." ); }

	var scoreboardConfig =
	{
		"teamXmlName" : "file://{resources}/layout/custom_game/multiteam_top_scoreboard_team.xml",
		"playerXmlName" : "file://{resources}/layout/custom_game/multiteam_top_scoreboard_player.xml",
		"shouldSort" : shouldSort
	};

	g_ScoreboardHandle = ScoreboardUpdater_InitializeScoreboard( scoreboardConfig, $( "#MultiteamScoreboard" ) );

	UpdateScoreboard();
})();
