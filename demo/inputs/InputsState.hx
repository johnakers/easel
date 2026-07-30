package inputs;

import flixel.FlxState;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import easel.inputs.Button;

import utils.DemoUtils;

class InputsState extends FlxState {
	override public function create():Void {
		super.create();
		
		add(DemoUtils.createHeader("Home / Inputs", function() { FlxG.switchState(PlayState.new); }));
		
		var items:Array<utils.DemoUtils.MenuItem> = [
			{ title: "Button", desc: "Highly customizable interactive button.", onClick: function() { FlxG.switchState(ButtonState.new); } },
			{ title: "Carousel", desc: "Cycle through items with arrows.", onClick: function() { FlxG.switchState(CarouselState.new); } },
			{ title: "Checkbox", desc: "Toggleable checkbox with optional label.", onClick: function() { FlxG.switchState(CheckboxState.new); } },
			{ title: "InputControl", desc: "Layout wrapper pairing a label with an input.", onClick: function() { FlxG.switchState(InputControlState.new); } },
			{ title: "Slider", desc: "Draggable range input slider.", onClick: function() { FlxG.switchState(SliderState.new); } }
		];
		
		add(DemoUtils.createMenu(items));
	}
}
