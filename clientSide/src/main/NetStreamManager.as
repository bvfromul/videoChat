package main
{
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.events.NetStatusEvent;
    import flash.net.NetConnection;
    import flash.net.NetStream;

    public class NetStreamManager extends EventDispatcher
    {
        private var textareaMessage:String;
        private var peerId:String;
        private var netConnection:NetConnection;
        private var sendStream:NetStream;
        private var recvStreams:Object = {};

        public function NetStreamManager(cirrusUrl:String, developerKey:String)
        {
            initNetConnection(cirrusUrl, developerKey);
        }

        private function initNetConnection(cirrusUrl:String, developerKey:String):void
        {
            netConnection = new NetConnection();
            netConnection.addEventListener(NetStatusEvent.NET_STATUS, netConnectionStatus);
            netConnection.connect(cirrusUrl + developerKey);
        }

        private function netConnectionStatus(event:NetStatusEvent):void
        {
            if (event.info.code == 'NetConnection.Connect.Success')
            {
                peerId = netConnection.nearID;
                dispatchEvent(new Event('PEERID_READY'));
            }
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
            sendStream.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
            sendStream.publish("media");
        }

        private function initRecvStreams(strangerPeers:Array):void
        {
            var key:String;

            for (key in strangerPeers)
            {
                if (recvStreams[strangerPeers[key].id])
                {
                    recvStreams[strangerPeers[key].id].isUpdate = 1;
                }
                else
                {
                    recvStreams[strangerPeers[key].id] = {}

                    recvStreams[strangerPeers[key].id].recvStream = new NetStream(netConnection, strangerPeers[key].id);
                    recvStreams[strangerPeers[key].id].recvStream.play("media");
                    recvStreams[strangerPeers[key].id].recvStream.client = this;
                    recvStreams[strangerPeers[key].id].recvStream.addEventListener(NetStatusEvent.NET_STATUS,netStatusHandler);

                    recvStreams[strangerPeers[key].id].nick = strangerPeers[key].nick;
                    recvStreams[strangerPeers[key].id].isConnected = 0;
                    recvStreams[strangerPeers[key].id].isUpdate = 1;
                }
            }
            deleteOldStreams();
            sendSomeData('/ping ' + peerId);
        }

        private function netStatusHandler(event:NetStatusEvent):void{
            trace(event.info.code);
        }

        private function deleteOldStreams():void
        {
            var key:String;

            for (key in recvStreams)
            {
                if (recvStreams[key].isUpdate == 0)
                {
                    recvStreams.splice(recvStreams.indexOf(recvStreams[key]),1);
                }
                else
                {
                    recvStreams[key].isUpdate == 0;
                }
            }
        }

        public function receiveSomeData(message:String):void
        {
            textareaMessage = '';

            switch (message.substring(0, 5))
            {
                case '/ping':
                    var peer:String = message.substr(6, message.length);
                    if (recvStreams[peer])
                    {
                        recvStreams[peer].isConnected = 1;
                        textareaMessage = recvStreams[peer].nick + ' connected';
                    }
                break;
            }

            if (textareaMessage.length)
            {
                dispatchEvent(new Event('TEXTAREA_MESSAGE_IS_READY'));
            }
        }

        public function sendSomeData(message:String):void
        {
            sendStream.send("receiveSomeData", message);
        }

        public function get _textareaMessage():String
        {
            return textareaMessage;
        }
    }
}