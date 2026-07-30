package;

import flixel.FlxState;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import easel.inputs.Button;

import animations.AnimationsState;
import components.ComponentsState;
import inputs.InputsState;

import utils.DemoUtils;

class PlayState extends FlxState {
	override public function create():Void {
		super.create();
		
		FlxG.autoPause = false;
		
		add(DemoUtils.createHeader("Home", null));
		
		var items:Array<utils.DemoUtils.MenuItem> = [
			{ title: "Animations", desc: "Visual tweens and effects.", onClick: function() { FlxG.switchState(AnimationsState.new); } },
			{ title: "Components", desc: "Pre-built modular UI components.", onClick: function() { FlxG.switchState(ComponentsState.new); } },
			{ title: "Fonts", desc: "Preview all available custom fonts.", onClick: function() { FlxG.switchState(fonts.FontsState.new); } },
			{ title: "Inputs", desc: "Interactive UI controls and fields.", onClick: function() { FlxG.switchState(inputs.InputsState.new); } }
		];
		
		add(DemoUtils.createMenu(items));
		
		var logo = new flixel.FlxSprite(0, 0, "assets/images/easel.png");
		logo.scale.set(4, 4);
		logo.updateHitbox();
		logo.x = FlxG.width - logo.width - 10;
		logo.y = FlxG.height - logo.height - 10;
		add(logo);
	}
}
