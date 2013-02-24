package main
{
	import flash.events.Event;
	
	import mx.events.FlexEvent;
	
	import spark.components.Application;
	
	public class VideoChatApplication extends Application
	{
		private var applicationData:ApplicationData;
		private var netStreamManager:NetStreamManager;
		private var userInterface:UserInterface;
		private var userHttpManger:UserHttpManager;
		
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
			userInterface = new UserInterface(applicationData._hostList);
			userInterface.addEventListener('NICK_AND_HOST_READY', allDataReady);

			addElement(userInterface);
		}
		
		private function pickupPeerId(event:Event):void
		{
			applicationData._peerID = netStreamManager._peerId;
		}

		private function allDataReady(event:Event):void
		{
			applicationData._userNick = userInterface._userNick;
			applicationData._webServerUrl = userInterface._hostURL;

			userHttpManger = new UserHttpManager(applicationData._webServerUrl, applicationData._peerID, applicationData._userNick);
			userHttpManger.addEventListener('SUCCESS_CONNECT', connectionIsReady);
		}
		
		private function connectionIsReady(event:Event):void
		{
			applicationData.saveHost(userInterface._currentHostsList);
		}
	}
}