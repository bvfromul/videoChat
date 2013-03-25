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
	import spark.components.TextInput;
	
	public class UserInterface extends Group
	{
		private var hostURL:String;
		private var userNick:String;
		private var hostsArray:Array;
		
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
	}
}