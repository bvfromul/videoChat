package main
{
	import mx.events.FlexEvent;
	
	import spark.components.Application;
	
	public class VideoChatApplication extends Application
	{
		public var test:String = 'eee';
		
		public function VideoChatApplication() 
		{
			addEventListener(FlexEvent.CREATION_COMPLETE, init);
		}
		
		private function init(event:FlexEvent):void
		{
			var applicationData:ApplicationData = new ApplicationData();
			var netStreamManaher:NetStreamManager = new NetStreamManager(applicationData._cirrusURL, applicationData._cirrusDeveloperKey);
			
			//applicationData._peerID();
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
		
	}
}