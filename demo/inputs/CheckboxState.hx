package inputs;

import flixel.FlxState;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import easel.inputs.Checkbox;
import utils.DemoUtils;
import easel.Easel;

class CheckboxState extends FlxState {
	override public function create():Void {
		super.create();
		
		add(DemoUtils.createHeader("Home / Inputs / Checkbox", function() { FlxG.switchState(InputsState.new); }));
		
		var cb1 = new Checkbox(50, 100, {
			label: "Primitive Checkbox",
			checked: false
		});
		add(cb1);
		
		var cb2 = new Checkbox(50, 150, {
			label: "Sprite Asset Checkbox",
			checked: true,
			bgAsset: "assets/images/checkbox/checkbox_spritesheet.png",
			bgAssetFrameWidth: 32,
			bgAssetFrameHeight: 32
		});
		add(cb2);
		
		add(utils.DemoUtils.createUsageBox(
"var myCheckbox = new Checkbox(x, y, {
    label: \"Remember Me\",
    checked: true,
    boxColor: 0xFF222222,
    checkColor: 0xFF00FF00,
    onToggle: function(isChecked) { trace(\"Checked: \" + isChecked); }
});
add(myCheckbox);", "source/easel/inputs/Checkbox.hx"
		));
	}
}
