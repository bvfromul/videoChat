package main
{
	public class ApplicationData
	{
		private var cirrusURL:String 			= 'rtmfp://p2p.rtmfp.net/';
		private var cirrusDeveloperKey:String 	= 'ee460bd53e12fcdeb6e9d986-7b07fa96424d';
		private var userNick:String;
		private var webServerUrl:String;
		private var peerID:String;

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
	}
}