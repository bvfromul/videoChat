package main
{
	
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	
	import spark.components.Button;
	import spark.components.ComboBox;
	import spark.components.Group;
	import spark.components.Label;
	import spark.components.TextInput;
	
	public class UserInterface extends Group
	{
		public function UserInterface()
		{
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
			addElement(connectButton);
			
			trace('init connection interface');
		}
		
		private function insertDefaultNick(target:TextInput):void
		{
			target.text = 'nick_random' + (Math.round(Math.random() * 98) + 1).toString();			
		}
	}
}