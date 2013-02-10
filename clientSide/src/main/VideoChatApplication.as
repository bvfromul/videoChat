package main
{

	import mx.events.FlexEvent;	
	import spark.components.Application;
	
	public class VideoChatApplication extends Application
	{
		
		public function VideoChatApplication() 
		{
			addEventListener(FlexEvent.CREATION_COMPLETE, creationUiPanel);
		}
		
		private function creationUiPanel(event:FlexEvent):void 
		{
			var userInterface:UserInterface = new UserInterface();

			userInterface.x = 0;
			userInterface.y = 0;
			userInterface.percentWidth = 100;
			userInterface.percentHeight = 100;
			userInterface.title = "Ввод данных для соединения";
			
			addElement(userInterface);
		}
		
	}
}