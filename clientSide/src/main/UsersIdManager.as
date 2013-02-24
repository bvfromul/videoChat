package main
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	
	public class UsersIdManager extends EventDispatcher
	{
		private var mHttpService:HTTPService;
		private var webServerUrl:String;
		private var peerID:String;
		private var userNick:String;
		
		public function UsersIdManager(webUrl:String, peer:String, nick:String)
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
			
		}
		
		private function httpResult(event:ResultEvent):void
		{
			var result:Object = event.result as Object;
			
			if (result.hasOwnProperty("result"))
			{
				if (result.result.update == true)
				{
					dispatchEvent(new Event('SUCCESS_CONNECT'));
				}
				else
				{
					trace('fail');
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