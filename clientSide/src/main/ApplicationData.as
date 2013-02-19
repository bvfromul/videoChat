package main
{
	import flash.net.SharedObject;

	public class ApplicationData
	{
		private var cirrusURL:String 			= 'rtmfp://p2p.rtmfp.net/';
		private var cirrusDeveloperKey:String 	= 'ee460bd53e12fcdeb6e9d986-7b07fa96424d';
		private var userNick:String;
		private var webServerUrl:String;
		private var peerID:String;
		private var sharedObject:SharedObject;
		private var hostList:Array;

		public function ApplicationData()
		{
			hostList = [];
			sharedObject = SharedObject.getLocal('videoChat');
			
			if (sharedObject.data.hostList != null)
			{
				hostList = sharedObject.data.hostList;
			}
		}
		
		public function set _userNick(nick:String):void
		{
			userNick = nick;
		}

		public function get _userNick():String
		{
			return userNick;
		}
		
		public function set _webServerUrl(url:String):void
		{
			webServerUrl = url;
		}
		
		public function get _webServerUrl():String
		{
			return webServerUrl;
		}
		
		public function set _peerID(peer:String):void
		{
			peerID = peer;
		}
		
		public function get _peerID():String
		{
			return peerID;
		}
		
		public function get _cirrusURL():String
		{
			return cirrusURL;
		}
		
		public function get _cirrusDeveloperKey():String
		{
			return cirrusDeveloperKey;
		}
		
		public function saveHost():void
		{
			if (hostList.length)
			{
				for(var count:int=0; count < hostList.length; count++)
				{
					if (hostList[count] != webServerUrl)
					{
						writeHostInSO(webServerUrl);
					}
					else
					{
						break;
					}
				}
			}
			else
			{
				writeHostInSO(webServerUrl);
			}
		}

		private function writeHostInSO(host:String):void
		{
			hostList.push(host);
			sharedObject.data.hostList = hostList;
			sharedObject.flush();
		}
		
		public function get _hostList():Array
		{
			return hostList;
		}
	}
}