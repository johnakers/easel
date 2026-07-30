package animations;

import flixel.FlxState;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import easel.inputs.Button;
import easel.animations.TypewriterAnimation;

import utils.DemoUtils;
import easel.Easel;

class TypewriterAnimationState extends FlxState {
	private var _demoText:FlxText;
	
	override public function create():Void {
		super.create();
		
		add(DemoUtils.createHeader("Home / Animations / Typewriter", function() { FlxG.switchState(AnimationsState.new); }));
		
		_demoText = new FlxText(50, 150, 0, "A", 48);
		if (Easel.defaultFont != null) _demoText.font = Easel.defaultFont;
		add(_demoText);
		
		var playBtn = new Button(50, 250, "Play Impact Animation", {
			onClick: function() { TypewriterAnimation.playImpact(_demoText, 0.2); }
		});
		add(playBtn);
	}
}
