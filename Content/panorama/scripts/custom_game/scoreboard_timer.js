"use strict";

function UpdateTimer()
{
	var timerValue = Game.GetDOTATime( false, false );

	var sec = Math.floor( timerValue % 60 );
	var min = Math.floor( timerValue / 60 );

	var timerText = "";
	if ( min < 10 )
	{
		timerText += "0";
	}
	
	timerText += min;
	timerText += ":";

	if ( sec < 10 )
	{
		timerText += "0";
	}
	timerText += sec;

	$( "#Timer" ).text = timerText;

	$.Schedule( 0.1, UpdateTimer );
}

(function()
{
	UpdateTimer();
})();
