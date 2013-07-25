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
            applicationData  = new ApplicationData();
            netStreamManager = new NetStreamManager(applicationData.cirrusURL, applicationData.cirrusDeveloperKey);

            netStreamManager.addEventListener(ApplicationEvents.PEERID_READY,       pickupPeerId);
            netStreamManager.addEventListener(ApplicationEvents.INCOMING_MESSAGE,   sendTextareaMessagetoUI);
            netStreamManager.addEventListener(ApplicationEvents.NO_ACTIVE_STREAM,   disableChat);

            createConnectionUi();
        }

        private function createConnectionUi():void
        {
            userInterface = new UserInterface(applicationData.hostList);

            userInterface.addEventListener(ApplicationEvents.NICK_AND_HOST_READY,   allDataReady);
            userInterface.addEventListener(ApplicationEvents.OUTCOMING_MESSAGE,     sendMessage);

            addElement(userInterface);
        }

        private function disableChat(event:ApplicationEvents):void
        {
            userInterface.disableChat();
        }

        private function pickupPeerId(event:ApplicationEvents):void
        {
            applicationData.peerID = event.customEventData as String;
        }

        private function allDataReady(event:ApplicationEvents):void
        {
            applicationData.userNick     = event.customEventData.nick;
            applicationData.webServerUrl = event.customEventData.host;

            userHttpManger = new UserHttpManager(applicationData.webServerUrl, applicationData.peerID, applicationData.userNick);

            userHttpManger.addEventListener(ApplicationEvents.SUCCESS_CONNECTED,    connectionIsReady);
            userHttpManger.addEventListener(ApplicationEvents.SUCCESS_GET_PEERS,    peersIsReady);
            userHttpManger.addEventListener(ApplicationEvents.USERS_HTTP_ERROR,     userHttpError);
        }

        private function userHttpError(event:ApplicationEvents):void
        {
            userInterface.showError(event.customEventData as String);
        }

        private function connectionIsReady(event:ApplicationEvents):void
        {
            applicationData.saveHost(userInterface.currentHostsList);
        }

        private function peersIsReady(event:ApplicationEvents):void
        {
            var isNewConnecion:Boolean = !Boolean(applicationData.peerList.length);
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

        private function sendTextareaMessagetoUI(event:ApplicationEvents):void
        {
            userInterface.addStrangerChatMessage(event.customEventData);
        }

        private function sendMessage(event:ApplicationEvents):void
        {
            netStreamManager.sendSomeData('text', event.customEventData as String);
        }
    }
}