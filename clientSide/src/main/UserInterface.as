package main
{
    import flash.display.DisplayObjectContainer;
    import flash.events.Event;
    import flash.events.MouseEvent;
    
    import mx.collections.ArrayCollection;
    import mx.controls.Alert;
    
    import spark.components.Button;
    import spark.components.ComboBox;
    import spark.components.Group;
    import spark.components.Label;
    import spark.components.TextArea;
    import spark.components.TextInput;
    import spark.components.VideoDisplay;

    public class UserInterface extends Group
    {
        private var hostURL:String;
        private var userNick:String;
        private var hostsArray:Array;

        private var sendButton:Button;
        private var reconnectButton:Button;
        private var playButton:Button;
        private var pauseButton:Button;
        private var videoStatusLabel:Label;
        private var chatStatusLabel:Label;

        public function UserInterface(hosts:Array)
        {
            this.x = 0;
            this.y = 0;
            this.percentWidth = 100;
            this.percentHeight = 100;

            hostsArray = hosts;
            showConnectInterface();
        }

        private function showConnectInterface():void
        {
            var hostLabel:Label = new Label();
            hostLabel.x = 214;
            hostLabel.y = 203;
            hostLabel.text = 'host';
            hostLabel.id = 'hostLabel';
            addElement(hostLabel);

            var hostList:ComboBox = new ComboBox();
            hostList.x = 257;
            hostList.y = 192;
            hostList.id = 'hostList';
            hostList.dataProvider = new ArrayCollection(hostsArray);
            hostList.addEventListener(Event.CLEAR, testClear);
            addElement(hostList);

            var nickLabel:Label = new Label();
            nickLabel.x = 214;
            nickLabel.y = 245;
            nickLabel.text = 'nick';
            nickLabel.id = 'nickLabel';
            addElement(nickLabel);

            var userNickTextInput:TextInput = new TextInput();
            userNickTextInput.x = 257;
            userNickTextInput.y = 235;
            userNickTextInput.width = 146;
            userNickTextInput.id = 'userNick';
            insertDefaultNick(userNickTextInput);
            addElement(userNickTextInput);

            var connectButton:Button = new Button();
            connectButton.x = 292;
            connectButton.y = 276;
            connectButton.label = 'connect';
            connectButton.id = 'connectButton';
            connectButton.addEventListener(MouseEvent.CLICK, initConnection);
            addElement(connectButton);
        }

        private function testClear(event:Event):void
        {
            hostsArray.splice(event.currentTarget.selectedIndex, 1);
            event.currentTarget.dataProvider = new ArrayCollection(hostsArray);
        }

        private function insertDefaultNick(target:TextInput):void
        {
            target.text = 'nick_' + (Math.round(Math.random() * 98) + 1).toString();
        }

        private function initConnection(event:MouseEvent):void
        {
            hostURL = (this.getChildAt(1) as ComboBox).textInput.text;
            userNick = (this.getChildAt(3) as TextInput).text;

            if (userNick.length > 0 && hostURL.length > 0)
            {
                dispatchEvent(new Event('NICK_AND_HOST_READY'));
            }
        }

        public function get _userNick():String
        {
            return userNick;
        }

        public function get _hostURL():String
        {
            return hostURL;
        }

        public function get _currentHostsList():Array
        {
            return hostsArray;
        }

        public function showError(errorString:String):void
        {
            Alert.show(errorString, 'Произошла ошибка', Alert.OK, this);
        }

        public function showVideoAndChatUi(peersCount:int):void
        {
            removeAllElements();

            videoStatusLabel = new Label();
            videoStatusLabel.x = 217;
            videoStatusLabel.y = 41;
            videoStatusLabel.text = 'waiting  connection';
            videoStatusLabel.id = 'videoStatusLabel';
            addElement(videoStatusLabel);

            chatStatusLabel = new Label();
            chatStatusLabel.x = 695;
            chatStatusLabel.y = 41;
            chatStatusLabel.text = 'waiting connection';
            chatStatusLabel.id = 'chatStatusLabel';
            addElement(chatStatusLabel);

            var videoDisplay:VideoDisplay = new VideoDisplay();
            videoDisplay.width = 374;
            videoDisplay.height = 229;
            videoDisplay.x = 65;
            videoDisplay.y = 62;
            videoDisplay.id = 'videoDisplay';
            addElement(videoDisplay);

            reconnectButton = new Button();
            reconnectButton.x = 62;
            reconnectButton.y = 331;
            reconnectButton.label = 'reconnect';
            reconnectButton.id = 'reconnectButton';
            reconnectButton.enabled = false;
            addElement(reconnectButton);

            playButton = new Button();
            playButton.x = 217;
            playButton.y = 331;
            playButton.label = 'play';
            playButton.id = 'playButton';
            playButton.enabled = false;
            addElement(playButton);

            pauseButton = new Button();
            pauseButton.x = 366;
            pauseButton.y = 331;
            pauseButton.label = 'pause';
            pauseButton.id = 'pauseButton';
            pauseButton.enabled = false;
            addElement(pauseButton);

            var playList:ComboBox = new ComboBox();
            playList.x = 62;
            playList.y = 394;
            playList.width = 374;
            playList.id = 'palyList';
            addElement(playList);

            var chat:TextArea = new TextArea();
            chat.x = 531;
            chat.y = 61;
            chat.width = 361;
            chat.height = 356;
            chat.id = 'chat';
            chat.editable = false;
            addElement(chat);

            var message:TextArea = new TextArea();
            message.x = 531;
            message.y = 442;
            message.width = 361;
            message.height = 108;
            message.id = 'message';
            addElement(message);

            sendButton = new Button();
            sendButton.x = 820;
            sendButton.y = 572;
            sendButton.label = 'send';
            sendButton.id = 'sendButton';
            sendButton.enabled = false;
            addElement(sendButton);
        }
    }
}