package components;

import flixel.FlxState;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import easel.inputs.Button;
import easel.components.ChatBox;

import utils.DemoUtils;
import easel.Easel;

class ChatBoxState extends FlxState {
	private var _chatBox:ChatBox;

	override public function create():Void {
		super.create();
		
		add(DemoUtils.createHeader("Home / Components / ChatBox", function() { FlxG.switchState(ComponentsState.new); }));
		
		var messages1 = [
			"Hello there! I am the new ChatBox component.",
			"I can present an array of messages sequentially.",
			"Here is an incredibly long message that will absolutely not fit on a single screen inside the ChatBox. In fact, this message is so monstrously huge that the brand new pagination system will have to aggressively step in, chop it up into chewable pieces, attach ellipses to the ends, and create entirely new pages out of thin air just to contain this ridiculous amount of text. It's truly a marvel of modern engineering to witness it dynamically flow across the bounds without spilling over the nice thick 9-sliced borders! Let's see if this successfully spawns into three or even four pages!"
		];

		_chatBox = new ChatBox(20, 110, messages1, {
			width: FlxG.width - 40,
			height: 120, // Increase height slightly to fit more text
			margin: 24, // Use margin to pull text safely inside thick borders
			backgroundAsset: "assets/images/panel.png",
			speaker: "Easel Developer",
			onComplete: function() {
				trace("ChatBox completed!");
			}
		});
		add(_chatBox);

		var restartBtn = new Button(FlxG.width - 150, 60, "Restart Demo", {
			borderColor: 0xFFFFFFFF,
			padding: 10,
			onClick: function() {
				FlxG.switchState(ChatBoxState.new);
			}
		});
		add(restartBtn);
		
		add(utils.DemoUtils.createUsageBox(
"var messages = [\"Hello!\", \"How are you today?\"];
var chat = new ChatBox(20, 100, messages, {
    width: FlxG.width - 40,
    speaker: \"Hero\",
    onComplete: function() { trace(\"Done chatting!\"); }
});
add(chat);"
		));
	}
}
