package main
{
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.events.NetStatusEvent;
    import flash.net.NetConnection;
    import flash.net.NetStream;

    public class NetStreamManager extends EventDispatcher
    {
        private var peerId:String;
        private var netConnection:NetConnection;
        private var sendStream:NetStream;
        private var recvStreams:Array;

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
            dispatchEvent(new Event('PEERID_READY'));
        }

        public function get _peerId():String
        {
            return peerId;
        }

        public function initStreams(strangerPeers:Array, isNewConnecion:Boolean):void
        {
            if (isNewConnecion)
            {
                initSendStream();
            }
            initRecvStreams(strangerPeers);
        }

        private function initSendStream():void
        {
            sendStream = new NetStream(netConnection, NetStream.DIRECT_CONNECTIONS);
            sendStream.publish("media");

            var sendStreamClient:Object = {};

            sendStreamClient.onPeerConnect = function(callerns:NetStream):Boolean{
                return true;
            }

            sendStream.client = sendStreamClient;
        }

        private function initRecvStreams(strangerPeers:Array):void
        {
            recvStreams = [];
            var key:String;

            for (key in strangerPeers)
            {
                var recvStream:NetStream = new NetStream(netConnection, strangerPeers[key].id);
                recvStream.play("media");
                recvStream.client = this;
                recvStreams[key] = recvStream;
            }
        }
    }
}