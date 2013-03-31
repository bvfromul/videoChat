package main
{
    import flash.events.Event;

    import mx.events.FlexEvent;

    import spark.components.Application;

    public class VideoChatApplication extends Application
    {
        private var applicationData:ApplicationData;
        private var netStreamManager:NetStreamManager;
        private var userInterface:UserInterface;
        private var userHttpManger:UserHttpManager;

        public function VideoChatApplication() 
        {
            addEventListener(FlexEvent.CREATION_COMPLETE, init);
        }

        private function init(event:FlexEvent):void
        {
            applicationData = new ApplicationData();
            netStreamManager = new NetStreamManager(applicationData._cirrusURL, applicationData._cirrusDeveloperKey);
            netStreamManager.addEventListener('PEERID_READY', pickupPeerId);

            createconnectionUi();
        }

        private function createconnectionUi():void
        {
            userInterface = new UserInterface(applicationData._hostList);
            userInterface.addEventListener('NICK_AND_HOST_READY', allDataReady);

            addElement(userInterface);
        }

        private function pickupPeerId(event:Event):void
        {
            applicationData._peerID = netStreamManager._peerId;
        }

        private function allDataReady(event:Event):void
        {
            applicationData._userNick = userInterface._userNick;
            applicationData._webServerUrl = userInterface._hostURL;

            userHttpManger = new UserHttpManager(applicationData._webServerUrl, applicationData._peerID, applicationData._userNick);
            userHttpManger.addEventListener('SUCCESS_CONNECT', connectionIsReady);
            userHttpManger.addEventListener('SUCCESS_GET_PEERS', peersIsReady);
            userHttpManger.addEventListener('USERSHTTP_ERROR', userHttpError);
        }

        private function userHttpError(event:Event):void
        {
            userInterface.showError(userHttpManger._errorString);
        }

        private function connectionIsReady(event:Event):void
        {
            applicationData.saveHost(userInterface._currentHostsList);
        }

        private function peersIsReady(event:Event):void
        {
            applicationData._peerList = userHttpManger._peersList;
            initPeersConnection(applicationData._peerList);
        }

        private function initPeersConnection(peers:Array):void
        {

        }
    }
}