package components;

import flixel.FlxState;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import easel.inputs.Button;

import utils.DemoUtils;

class ComponentsState extends FlxState {
	override public function create():Void {
		super.create();
		
		add(DemoUtils.createHeader("Home / Components", function() { FlxG.switchState(PlayState.new); }));
		
		var items:Array<utils.DemoUtils.MenuItem> = [
			{ title: "Typewriter", desc: "A fully functional typewriter component.", onClick: function() { FlxG.switchState(TypewriterState.new); } },
			{ title: "Card", desc: "Modular card wrapper with title and description.", onClick: function() { FlxG.switchState(CardState.new); } },
			{ title: "Banner", desc: "Flexbox style navigation banner.", onClick: function() { FlxG.switchState(BannerState.new); } },
			{ title: "ChatBox", desc: "Sequential message dialog box.", onClick: function() { FlxG.switchState(ChatBoxState.new); } },
			{ title: "SlidePanel", desc: "Animated slide-in container.", onClick: function() { FlxG.switchState(SlidePanelState.new); } },
			{ title: "Grid", desc: "8x8px layout alignment grid.", onClick: function() { FlxG.switchState(GridState.new); } },
			{ title: "Dialog", desc: "Modal dialog with a mask and confirmation buttons.", onClick: function() { FlxG.switchState(DialogState.new); } }
		];
		
		add(DemoUtils.createMenu(items));
	}
}
