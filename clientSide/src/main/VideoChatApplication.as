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
            netStreamManager.addEventListener('INCOMING_MESSAGE', sendTextareaMessagetoUI);

            createConnectionUi();
        }

        private function createConnectionUi():void
        {
            userInterface = new UserInterface(applicationData._hostList);
            userInterface.addEventListener('NICK_AND_HOST_READY', allDataReady);
            userInterface.addEventListener('OUTCOMING_MESSAGE', sendMessage);

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
            var isNewConnecion:Boolean;
            if (applicationData._peerList.length)
            {
                isNewConnecion = false;
            }
            else
            {
                isNewConnecion = true;
            }

            applicationData._peerList = userHttpManger._peersList;
            if (isNewConnecion)
            {
                showVideoAndChatUi(applicationData._peerList.length);
            }
            netStreamManager.initStreams(applicationData._peerList, isNewConnecion);
        }

        private function showVideoAndChatUi(peersCount:int):void
        {
            userInterface.showVideoAndChatUi(peersCount);
        }

        private function sendTextareaMessagetoUI(event:Event):void
        {
            userInterface.addStrangerChatMessage(netStreamManager._textareaMessage);
        }

        private function sendMessage(event:Event):void
        {
            netStreamManager.sendSomeData('text', userInterface._outcomingMessage);
        }
    }
}