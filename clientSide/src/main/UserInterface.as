package main
{
    import flash.display.DisplayObjectContainer;
    import flash.events.Event;
    import flash.events.KeyboardEvent;
    import flash.events.MouseEvent;
    import flash.text.TextField;
    import flash.text.TextFormat;
    
    import mx.collections.ArrayCollection;
    import mx.controls.Alert;
    import mx.controls.VScrollBar;
    import mx.core.UIComponent;
    import mx.events.ScrollEvent;
    
    import spark.components.Button;
    import spark.components.ComboBox;
    import spark.components.Group;
    import spark.components.Label;
    import spark.components.TextArea;
    import spark.components.TextInput;
    import spark.components.VideoDisplay;

    public class UserInterface extends Group
    {
        private var _hostsArray:Array;

        private var sendButton:Button;
        private var reconnectButton:Button;
        private var playButton:Button;
        private var pauseButton:Button;
        private var videoStatusLabel:Label;
        private var chatStatusLabel:Label;
        private var chat:TextField;
        private var defaultChatTextFormat:TextFormat;
        private var outcomingMessageTextArea:TextArea;
        private var scrollBar:VScrollBar;

        public function UserInterface(hosts:Array)
        {
            this.x = 0;
            this.y = 0;
            this.percentWidth = 100;
            this.percentHeight = 100;

            _hostsArray = hosts;
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
            hostList.dataProvider = new ArrayCollection(_hostsArray);
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
            _hostsArray.splice(event.currentTarget.selectedIndex, 1);
            event.currentTarget.dataProvider = new ArrayCollection(_hostsArray);
        }

        private function insertDefaultNick(target:TextInput):void
        {
            target.text = 'nick_' + (Math.round(Math.random() * 98) + 1).toString();
        }

        private function initConnection(event:MouseEvent):void
        {
            var hostURL:String = (this.getChildAt(1) as ComboBox).textInput.text;
            var userNick:String = (this.getChildAt(3) as TextInput).text;

            if (userNick.length > 0 && hostURL.length > 0)
            {
                var eventData:Object = {};
                eventData.host = hostURL;
                eventData.nick = userNick;
                dispatchEvent(new ApplicationEvents('nickAndHostReady', eventData));
            }
        }

        public function get currentHostsList():Array
        {
            return _hostsArray;
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
            videoStatusLabel.text = 'waiting connection';
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

            var container:UIComponent = new UIComponent();
            addElement(container);
            chat = new TextField();
            chat.x = 531;
            chat.y = 61;
            chat.width = 361;
            chat.height = 356;
            chat.border = true;
            container.addChild(chat);
            defaultChatTextFormat = chat.getTextFormat();

            outcomingMessageTextArea = new TextArea();
            outcomingMessageTextArea.x = 531;
            outcomingMessageTextArea.y = 442;
            outcomingMessageTextArea.width = 361;
            outcomingMessageTextArea.height = 108;
            outcomingMessageTextArea.id = 'message';
            addElement(outcomingMessageTextArea);

            sendButton = new Button();
            sendButton.x = 820;
            sendButton.y = 572;
            sendButton.label = 'send';
            sendButton.id = 'sendButton';
            sendButton.enabled = false;
            addElement(sendButton);
        }

        public function addStrangerChatMessage(message:Object):void
        {
            chat.appendText(message.nick + message.text + "\n");

            var nickFormat:TextFormat = defaultChatTextFormat;
            nickFormat.color = '0x' + message.nickColor;
            chat.setTextFormat(nickFormat, chat.text.lastIndexOf(message.nick), chat.text.lastIndexOf(message.nick) + message.nick.length);
            nickFormat.color = 0x000000;
            chat.setTextFormat(nickFormat, chat.text.lastIndexOf(message.text), chat.text.lastIndexOf(message.text) + message.text.length);

            if (!sendButton.enabled)
            {
                sendButton.enabled = true;
                sendButton.addEventListener(MouseEvent.CLICK, sendTextMessage);
                chatStatusLabel.text = 'connected';
                outcomingMessageTextArea.addEventListener(KeyboardEvent.KEY_UP, outcomingMessageTextAreaKeyUp);
            }

            addChatScroll();
        }

        public function disableChat():void
        {
            sendButton.enabled = false;
            sendButton.removeEventListener(MouseEvent.CLICK, sendTextMessage);
            chatStatusLabel.text = 'waiting connection';
            outcomingMessageTextArea.removeEventListener(KeyboardEvent.KEY_UP, outcomingMessageTextAreaKeyUp);
        }

        private function addMyChatMessage(message:String):void
        {
            chat.appendText('you');

            var nickFormat:TextFormat = defaultChatTextFormat;
            nickFormat.bold = true;
            chat.setTextFormat(nickFormat, chat.text.lastIndexOf('you'), chat.text.lastIndexOf('you') + 3);

            chat.appendText(': ' + message + "\n");
            nickFormat.bold = false;
            chat.setTextFormat(nickFormat, chat.text.lastIndexOf(': ' + message), chat.text.lastIndexOf(': ' + message) + (': ' + message).length);

            addChatScroll();
        }

        private function outcomingMessageTextAreaKeyUp(event:KeyboardEvent):void
        {
            if (event.keyCode == 13 && event.ctrlKey)
            {
                sendTextMessage();
            }
        }

        private function addChatScroll():void
        {
            if (chat.textHeight > chat.height)
            {
                if (!scrollBar)
                {
                    scrollBar = new VScrollBar();

                    scrollBar.height = chat.height;
                    scrollBar.move(chat.x + chat.width, chat.y);
                    scrollBar.minScrollPosition = 0;
                    scrollBar.lineScrollSize = 500;
                    scrollBar.pageScrollSize = 100;
                    scrollBar.addEventListener(ScrollEvent.SCROLL, scrollingChat);
                    addElement(scrollBar);
                }
                scrollBar.maxScrollPosition = chat.textHeight - chat.height;
                scrollBar.scrollPosition = chat.textHeight - chat.height;
                chat.scrollV = chat.maxScrollV;
            }
        }

        private function scrollingChat(event:ScrollEvent):void
        {
            chat.scrollV = event.currentTarget.scrollPosition;
        }

        private function sendTextMessage(event:Event = null):void
        {
            var outcomingMessage:String = outcomingMessageTextArea.text;
            dispatchEvent(new ApplicationEvents('outcomingMessage', outcomingMessage));
            addMyChatMessage(outcomingMessage);
            outcomingMessageTextArea.text = '';
        }
    }
}