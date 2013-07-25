package main
{
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.events.TimerEvent;
    import flash.net.URLRequestMethod;
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

        public function UserHttpManager(webUrl:String, peer:String, nick:String)
        {
            webServerUrl = webUrl;
            peerID       = peer;
            userNick     = nick;

            doRegister();

            refreshConnectionTimer = new Timer(1000 * 10);
            refreshConnectionTimer.addEventListener(TimerEvent.TIMER, refreshConnection);
            refreshConnectionTimer.start();
        }

        private function refreshConnection(event:TimerEvent):void
        {
            if (mHttpService)
            {
                var request:Object = {
                    username:   userNick,
                    identity:   peerID,
                    anticache:  Math.random()
                };
                mHttpService.cancel();
                mHttpService.send(request);
            }
        }

        private function doRegister():void
        {
            mHttpService = new HTTPService();
            mHttpService.url = webServerUrl;
            mHttpService.method = URLRequestMethod.GET;
            mHttpService.addEventListener("result", httpResult);
            mHttpService.addEventListener("fault",  httpFault);

            var request:Object = {
                username:   userNick,
                identity:   peerID,
                anticache:  Math.random()
            };
            mHttpService.cancel();
            mHttpService.send(request);
        }

        private function doUnregister():void
        {
            if (mHttpService)
            {
                var request:Object = {
                    username: userNick,
                    identity: "0"
                };
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
                var request:Object = {
                    get_peers: 1,
                    anticache: Math.random()
                };
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
                    if (result.result.update)
                    {
                        dispatchEvent(new ApplicationEvents(ApplicationEvents.SUCCESS_CONNECTED));
                        getAllPeers();
                    }
                    else
                    {
                        dispatchEvent(new ApplicationEvents(ApplicationEvents.USERS_HTTP_ERROR, 'Ошибка соединения'));
                    }
                }
                else if (result.result.update is String)
                {
                    if (result.result.update == 'busy nickname')
                    {
                        dispatchEvent(new ApplicationEvents(ApplicationEvents.USERS_HTTP_ERROR, 'Данный ник уже используется'));
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
                dispatchEvent(new ApplicationEvents(ApplicationEvents.SUCCESS_GET_PEERS, peersList));
            }
            else
            {
                dispatchEvent(new ApplicationEvents(ApplicationEvents.USERS_HTTP_ERROR, 'Ошибка соединения'));
            }
        }

        private function httpFault(event:FaultEvent):void
        {
            dispatchEvent(new ApplicationEvents(ApplicationEvents.USERS_HTTP_ERROR, 'Ошибка соединения'));
        }
    }
}