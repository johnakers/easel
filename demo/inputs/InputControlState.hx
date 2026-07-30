package inputs;

import flixel.FlxState;
import flixel.FlxG;
import flixel.util.FlxColor;
import easel.inputs.InputControl;
import easel.inputs.Slider;
import easel.inputs.Checkbox;
import utils.DemoUtils;
import easel.Easel;

class InputControlState extends FlxState {
	override public function create():Void {
		super.create();
		
		add(DemoUtils.createHeader("Home / Inputs / InputControl", function() { FlxG.switchState(InputsState.new); }));
		
		// 1. Two-Column Layout (e.g. Settings Menu)
		var s1 = new Slider(0, 0, { min: 0, max: 100, value: 75, width: 250 });
		var control1 = new InputControl(50, 120, "Master Volume", s1, {
			layout: TWO_COLUMN,
			width: 600, // pushes slider 600px to the right of the label's X position
			gap: 0 // gap ignored since we use width
		});
		add(control1);
		
		var c1 = new Checkbox(0, 0, { checked: true });
		var control2 = new InputControl(50, 180, "Enable Fullscreen", c1, {
			layout: TWO_COLUMN,
			width: 600
		});
		add(control2);
		
		// 2. Stacked Layout
		var s2 = new Slider(0, 0, { min: 0, max: 100, value: 50, width: 400 });
		var control3 = new InputControl(50, 280, "Microphone Sensitivity", s2, {
			layout: STACKED,
			gap: 15
		});
		add(control3);
		
		var c2 = new Checkbox(0, 0, { label: "I accept the EULA", checked: false });
		var control4 = new InputControl(50, 380, "Legal Terms", c2, {
			layout: STACKED,
			gap: 15
		});
		add(control4);
		
		add(utils.DemoUtils.createUsageBox(
"var mySlider = new Slider(0, 0, { width: 200 });
var myControl = new InputControl(x, y, \"Volume\", mySlider, {
    layout: TWO_COLUMN,
    width: 400, // Pins slider to right edge
    gap: 15
});
add(myControl);", "source/easel/inputs/InputControl.hx"
		));
	}
}
