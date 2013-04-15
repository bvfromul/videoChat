package main
{
    import flash.net.SharedObject;

    public class ApplicationData
    {
        private var _cirrusURL:String            = 'rtmfp://p2p.rtmfp.net/';
        private var _cirrusDeveloperKey:String   = 'ee460bd53e12fcdeb6e9d986-7b07fa96424d';
        private var _userNick:String;
        private var _webServerUrl:String;
        private var _peerID:String;
        private var sharedObject:SharedObject;
        private var _hostList:Array;
        private var _peerList:Array;

        public function ApplicationData()
        {
            _hostList = [];
            _peerList = [];
            sharedObject = SharedObject.getLocal('videoChat');

            if (sharedObject.data.hostList != null)
            {
                _hostList = sharedObject.data.hostList;
            }
        }

        public function set userNick(nick:String):void
        {
            _userNick = nick;
        }

        public function get userNick():String
        {
            return _userNick;
        }

        public function set webServerUrl(url:String):void
        {
            _webServerUrl = url;
        }

        public function get webServerUrl():String
        {
            return _webServerUrl;
        }

        public function set peerID(peer:String):void
        {
            _peerID = peer;
        }

        public function get peerID():String
        {
            return _peerID;
        }

        public function set peerList(peers:Array):void
        {
            _peerList = peers;
        }

        public function get peerList():Array
        {
            return _peerList;
        }

        public function get cirrusURL():String
        {
            return _cirrusURL;
        }

        public function get cirrusDeveloperKey():String
        {
            return _cirrusDeveloperKey;
        }

        public function saveHost(hosts:Array):void
        {
            if (hosts.length)
            {
                if (checkUrl(hosts))
                {
                    writeHostInSO(hosts, webServerUrl);
                }
            }
            else
            {
                writeHostInSO(hosts, webServerUrl);
            }
        }

        private function checkUrl(hosts:Array):Boolean
        {
            for(var count:int=0; count < hosts.length; count++)
            {
                if (hosts[count] == webServerUrl)
                {
                    return false;
                }
            }

            return true;
        }

        private function writeHostInSO(hosts:Array, host:String):void
        {
            hosts.push(host);
            sharedObject.data.hostList = hosts;
            sharedObject.flush();
        }

        public function get hostList():Array
        {
            return _hostList;
        }
    }
}