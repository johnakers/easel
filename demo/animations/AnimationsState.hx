package animations;

import flixel.FlxState;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import easel.inputs.Button;

import utils.DemoUtils;

class AnimationsState extends FlxState {
	override public function create():Void {
		super.create();
		
		add(DemoUtils.createHeader("Home / Animations", function() { FlxG.switchState(PlayState.new); }));
		
		var items:Array<utils.DemoUtils.MenuItem> = [
			{ title: "DancingText", desc: "Balatro-style bouncing wave text effect.", onClick: function() { FlxG.switchState(DancingTextState.new); } },
			{ title: "TypewriterAnimation", desc: "Visual scaling impact effect for text characters.", onClick: function() { FlxG.switchState(TypewriterAnimationState.new); } }
		];
		
		add(DemoUtils.createMenu(items));
	}
}
