package main
{
	import flash.events.Event;
	
	import mx.events.FlexEvent;
	
	import spark.components.Application;
	
	public class VideoChatApplication extends Application
	{
		private var applicationData:ApplicationData;
		private var netStreamManager:NetStreamManager;
		
		public function VideoChatApplication() 
		{
			addEventListener(FlexEvent.CREATION_COMPLETE, init);
		}
		
		private function init(event:FlexEvent):void
		{
			applicationData = new ApplicationData();
			netStreamManager = new NetStreamManager(applicationData._cirrusURL, applicationData._cirrusDeveloperKey);
			netStreamManager.addEventListener('PEERID_READY', pickupPeerId);

			createUi();
		}

		private function createUi():void
		{
			var userInterface:UserInterface = new UserInterface();

			userInterface.x = 0;
			userInterface.y = 0;
			userInterface.percentWidth = 100;
			userInterface.percentHeight = 100;

			addElement(userInterface);
		}
		
		private function pickupPeerId(event:Event):void
		{
			applicationData._peerID = netStreamManager._peerId;
		}
		
	}
}