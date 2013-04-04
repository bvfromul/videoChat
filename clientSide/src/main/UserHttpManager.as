package main
{
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.events.TimerEvent;
    import flash.utils.Timer;
    
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
        private var refreshConnectionTimer:Timer;
        private var errorString:String;

        public function UserHttpManager(webUrl:String, peer:String, nick:String)
        {
            webServerUrl = webUrl;
            peerID = peer;
            userNick = nick;

            doRegister();

            refreshConnectionTimer = new Timer(1000 * 90);
            refreshConnectionTimer.addEventListener(TimerEvent.TIMER, refreshConnection);
            refreshConnectionTimer.start();
        }

        public function get _peersList():Array
        {
            return peersList;
        }

        public function get _errorString():String
        {
            return errorString;
        }

        private function refreshConnection(event:TimerEvent):void
        {
            if (mHttpService)
            {
                var request:Object = {};
                request.username = userNick;
                request.identity = peerID;
                request.anticache = Math.random();
                mHttpService.cancel();
                mHttpService.send(request);
            }
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
            request.anticache = Math.random();
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

            if (refreshConnectionTimer)
            {
                refreshConnectionTimer.stop();
                refreshConnectionTimer = null;
            }
        }

        private function getAllPeers():void
        {
            if (mHttpService)
            {
                var request:Object = {};
                request.get_peers = 1;
                request.anticache = Math.random();
                mHttpService.cancel();
                mHttpService.send(request);
            }
        }

        private function httpResult(event:ResultEvent):void
        {
            var result:Object = event.result as Object;
            
            if (result.hasOwnProperty("result"))
            {
                if (result.result.update is Boolean)
                {
                    if (result.result.update == true)
                    {
                        dispatchEvent(new Event('SUCCESS_CONNECT'));
                        getAllPeers();
                    }
                    else
                    {
                        errorString = 'Ошибка соединения';
                        dispatchEvent(new Event('USERSHTTP_ERROR'));
                    }
                }
                else if (result.result.update is String)
                {
                    if (result.result.update == 'busy nickname')
                    {
                        errorString = 'Данный ник уже используется';
                        dispatchEvent(new Event('USERSHTTP_ERROR'));
                    }
                }
            }
            else if (result.hasOwnProperty("peers"))
            {
                peersList=[];

                for each (var strangerPeer:Object in result.peers)
                {
                    if (strangerPeer.length)
                    {
                        var key:String;
                        for (key in strangerPeer)
                        {
                            if (strangerPeer[key].id != peerID)
                            {
                                peersList.push(strangerPeer[key]);
                            }
                        }
                    }
                }

                dispatchEvent(new Event('SUCCESS_GET_PEERS'));
            }
            else
            {
                errorString = 'Ошибка соединения';
                dispatchEvent(new Event('USERSHTTP_ERROR'));
            }
        }

        private function httpFault(event:FaultEvent):void
        {
            errorString = 'Ошибка соединения';
            dispatchEvent(new Event('USERSHTTP_ERROR'));
        }
    }
}