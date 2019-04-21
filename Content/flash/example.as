package  {

	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import scaleform.clik.motion.Tween;
	import fl.transitions.easing.None;
	import flash.utils.Timer;
	import flash.events.TimerEvent;

	public class HoldoutLose extends MovieClip
	{
		// element details filled out by game engine
		public var gameAPI:Object;
		public var globals:Object;
		public var elementName:String;
		public var currentVote:int;

		public var voteTween:Tween;

		private var initialDelayTimer:Timer;

		public function HoldoutLose() { }

		// called by the game engine when this .swf has finished loading
		public function onLoaded():void
		{
			anim.holdoutLose.exitGameButton.addEventListener( MouseEvent.CLICK, onExitGameClicked );
			anim.holdoutLose.restartGameButton.addEventListener( MouseEvent.CLICK, onRestartGameClicked );

			gameAPI.SubscribeToGameEvent( "holdout_victory_message", onHoldoutVictory );
			gameAPI.SubscribeToGameEvent( "holdout_end", onHoldoutEnd );
			gameAPI.SubscribeToGameEvent( "holdout_restart_vote", onHoldoutRestartVote );
			gameAPI.SubscribeToGameEvent( "holdout_restart_vote_end", onHoldoutRestartVoteEnd );

			trace( "OnLoad:" );
		}
	}
}
