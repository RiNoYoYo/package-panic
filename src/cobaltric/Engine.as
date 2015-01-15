﻿package cobaltric
{
	import flash.automation.StageCapture;
	import flash.display.MovieClip;
	import flash.display.StageQuality;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.net.SharedObject;
	
	/** 
	 * Primary game loop event firer and state machine.
	 * 
	 * @author Alexander Huynh
	 */
	public class Engine extends MovieClip
	{
		private var gameState:int;				// 0:Intro, 1:Game, 2:Outro
		private var container:ABST_Container;	// the currently active container
		
		// save data
		public const SAVE_DATA:String = "PACK_PAN";
		public var saveData:SharedObject = SharedObject.getLocal(SAVE_DATA, "/");
		
		public function Engine()
		{
			trace("OK");
			
			// try to load save data
			/*if (saveData.data.sd_isValid)
			{
				scoreData = [];
				for (var i:int = 0; i < 8; i++)
				{
					scoreData.push([saveData.data.sd_name[i],
									saveData.data.sd_day[i],
									saveData.data.sd_money[i]]);
				}
			}
			else
				newGame();*/
				
			gameState = 0;
			
			container = new ContainerIntro(this);
			addChild(container);

			// center the container
			container.x = 0;//stage.width * .5;
			container.y = 0;//stage.height * .5;
			
			addEventListener(Event.ENTER_FRAME, step);
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			//SoundPlayer.playBGM(true);
			
		}
		
		/*public function newGame():void
		{
			save();
			// new data here
		}*/
		
		/**
		 * Primary game loop event firer. Steps the current container, and advances
		 * to the next one if the current container is complete.
		 * 
		 * @param	e	the captured Event, unused
		 */
		public function step(e:Event):void
		{
			if (!container.step())		// step the current container, quit if it's not done
				return;
				
			removeChild(container);		// remove the current, completed container
			
			switch (gameState)			// determine which new container to go to next
			{
				case 0:
					container = new ABST_ContainerGame(this);
					gameState++;
					//SoundPlayer.stopBGM();
				break;
				case 1:
					container = new ContainerIntro(this);
					gameState = 0;
				break;
			}
			
			addChild(container);		// add the new container
			
		}
		
		/**
		 * Helper to init the global keyboard listener (quality buttons)
		 * 
		 * @param	e	the captured Event, unused
		 */
		private function onAddedToStage(e:Event):void
		{
			container.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			container.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyPress);
		}
		
		/**
		 * Global keyboard listener, used to listen for quality buttons
		 * 
		 * @param	e	the captured KeyboardEvent, used to find the pressed key
		 */
		private function onKeyPress(e:KeyboardEvent):void
		{
			if (!container.stage)
				return;
			if (e.keyCode == 76)		// -- 1
				container.stage.quality = StageQuality.LOW;
			else if (e.keyCode == 77)	// -- 2
				container.stage.quality = StageQuality.MEDIUM;
			else if (e.keyCode == 72)	// -- 3
				container.stage.quality = StageQuality.HIGH;
		}
		
		/*public function save(scoreData:Array = null):void
		{ 
			saveData.clear();
			if (!scoreData)
				// init new score Data
			saveData.data.sd_isValid = true;
			saveData.flush();
		}*/
	}
	
}