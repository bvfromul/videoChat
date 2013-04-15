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
            netStreamManager = new NetStreamManager(applicationData.cirrusURL, applicationData.cirrusDeveloperKey);
            netStreamManager.addEventListener('PEERID_READY', pickupPeerId);
            netStreamManager.addEventListener('INCOMING_MESSAGE', sendTextareaMessagetoUI);

            createConnectionUi();
        }

        private function createConnectionUi():void
        {
            userInterface = new UserInterface(applicationData.hostList);
            userInterface.addEventListener('NICK_AND_HOST_READY', allDataReady);
            userInterface.addEventListener('OUTCOMING_MESSAGE', sendMessage);

            addElement(userInterface);
        }

        private function pickupPeerId(event:Event):void
        {
            applicationData.peerID = netStreamManager.peerId;
        }

        private function allDataReady(event:Event):void
        {
            applicationData.userNick = userInterface.userNick;
            applicationData.webServerUrl = userInterface.hostURL;

            userHttpManger = new UserHttpManager(applicationData.webServerUrl, applicationData.peerID, applicationData.userNick);
            userHttpManger.addEventListener('SUCCESS_CONNECT', connectionIsReady);
            userHttpManger.addEventListener(UserHttpManagerEvents.SUCCESS_GET_PEERS, peersIsReady);
            userHttpManger.addEventListener(UserHttpManagerEvents.USERS_HTTP_ERROR, userHttpError);
        }

        private function userHttpError(event:UserHttpManagerEvents):void
        {
            userInterface.showError(event.customEventData as String);
        }

        private function connectionIsReady(event:Event):void
        {
            applicationData.saveHost(userInterface.currentHostsList);
        }

        private function peersIsReady(event:UserHttpManagerEvents):void
        {
            var isNewConnecion:Boolean;
            if (applicationData.peerList.length)
            {
                isNewConnecion = false;
            }
            else
            {
                isNewConnecion = true;
            }

            applicationData.peerList = event.customEventData as Array;
            if (isNewConnecion)
            {
                showVideoAndChatUi(applicationData.peerList.length);
            }
            netStreamManager.initStreams(applicationData.peerList, isNewConnecion);
        }

        private function showVideoAndChatUi(peersCount:int):void
        {
            userInterface.showVideoAndChatUi(peersCount);
        }

        private function sendTextareaMessagetoUI(event:Event):void
        {
            userInterface.addStrangerChatMessage(netStreamManager.textareaMessage);
        }

        private function sendMessage(event:Event):void
        {
            netStreamManager.sendSomeData('text', userInterface.outcomingMessage);
        }
    }
}