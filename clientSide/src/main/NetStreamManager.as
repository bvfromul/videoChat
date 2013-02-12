package main
{
	import flash.events.NetStatusEvent;
	import flash.net.NetConnection;

	public class NetStreamManager
	{
		private var peerId:String;
		private var netConnection:NetConnection;
		
		public function NetStreamManager(cirrusUrl:String, developerKey:String)
		{
			initNetConnection(cirrusUrl, developerKey);
		}

		private function initNetConnection(cirrusUrl:String, developerKey:String):void
		{
			netConnection = new NetConnection();
			netConnection.addEventListener(NetStatusEvent.NET_STATUS,netConnectionStatus);
			netConnection.connect(cirrusUrl + developerKey);
		}

		private function netConnectionStatus(event:NetStatusEvent):void
		{
			peerId = netConnection.nearID;
		}
			
		public function get _peerId():String
		{
			return peerId;
		}
	}
}