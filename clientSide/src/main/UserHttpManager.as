package main
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	
	public class UserHttpManager extends EventDispatcher
	{
		private var mHttpService:HTTPService;
		private var webServerUrl:String;
		private var peerID:String;
		private var userNick:String;
		private var peersList:Array;
		
		public function UserHttpManager(webUrl:String, peer:String, nick:String)
		{
			webServerUrl = webUrl;
			peerID = peer;
			userNick = nick;

			doRegister();
		}
		
		private function doRegister():void
		{
			mHttpService = new HTTPService();
			mHttpService.url = webServerUrl;
			mHttpService.method = 'GET';
			mHttpService.addEventListener("result", httpResult);
			mHttpService.addEventListener("fault", httpFault);
			
			var request:Object = {};
			request.username = userNick;
			request.identity = peerID;
			mHttpService.cancel();
			mHttpService.send(request);
		}
		
		private function doUnregister():void
		{
			if (mHttpService)
			{
				var request:Object = {};
				request.username = userNick;
				request.identity = "0";
				mHttpService.cancel();
				mHttpService.send(request);
			}
		}
		
		private function getAllPeers():void
		{
			if (mHttpService)
			{
				var request:Object = {};
				request.get_peers = 1;
				mHttpService.cancel();
				mHttpService.send(request);
			}
		}
		
		private function httpResult(event:ResultEvent):void
		{
			var result:Object = event.result as Object;
			
			if (result.hasOwnProperty("result"))
			{
				if (result.result.update == true)
				{
					dispatchEvent(new Event('SUCCESS_CONNECT'));
					getAllPeers();
				}
				else
				{
					trace('fail');
				}
			}
			else if (result.hasOwnProperty("peers"))
			{
				peersList=[];

				for each (var strangerPeer:Object in result.peers)
				{
					if (strangerPeer.id != peerID)
					{
						peersList.push(strangerPeer);
					}
				}
			}
			else
			{
				trace('fail');
			}
		}
		
		private function httpFault(event:FaultEvent):void
		{
			trace('fail');
		}
	}
}