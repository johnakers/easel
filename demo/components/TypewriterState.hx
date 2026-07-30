package components;

import flixel.FlxState;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import easel.inputs.Button;
import easel.components.Typewriter;
import utils.DemoUtils;
import easel.Easel;

class TypewriterState extends FlxState {
	override public function create():Void {
		super.create();

		add(DemoUtils.createHeader("Home / Components / Typewriter", function() {
			FlxG.switchState(ComponentsState.new);
		}));

		var typewriter = new Typewriter(50, 100, "Hello Easel Typewriter!\n(Press any key to skip)", 2.0, true, {
			fontSize: 16,
			soundAsset: "assets/sounds/typewriter.wav"
		});
		add(typewriter);

		var restartBtn = new Button(FlxG.width - 150, 60, "Restart Demo", {
			borderColor: 0xFFFFFFFF,
			padding: 10,
			onClick: function() {
				typewriter.startTyping();
			}
		});
		add(restartBtn);
		
		add(utils.DemoUtils.createUsageBox(
"var myTypewriter = new Typewriter(x, y, \"Hello World!\", 2.0, true, {
    fontSize: 16,
    soundAsset: \"assets/sounds/typewriter.wav\",
    onComplete: function() { trace(\"Done typing!\"); }
});
add(myTypewriter);
// Call myTypewriter.startTyping() to run the effect.", "source/easel/components/Typewriter.hx"
		));
	}
}
