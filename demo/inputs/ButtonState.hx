package inputs;

import flixel.FlxState;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import easel.inputs.Button;

import utils.DemoUtils;

class ButtonState extends FlxState {
	override public function create():Void {
		super.create();
		
		add(DemoUtils.createHeader("Home / Inputs / Button", function() { FlxG.switchState(InputsState.new); }));
		
		var customBtn = new Button(50, 100, "Primitive", {
			fontSize: 16,
			backgroundColor: FlxColor.BLUE,
			borderColor: FlxColor.WHITE,
			padding: 12,
			onClick: function() { trace("Primitive button clicked!"); }
		});
		add(customBtn);
		
		var assetBtn = new Button(200, 100, "Sprite Asset", {
			fontSize: 16,
			fontColor: FlxColor.WHITE,
			bgAsset: "assets/images/button/button_spritesheet.png",
			bgAssetFrameWidth: 96,
			bgAssetFrameHeight: 32,
			padding: 8,
			onClick: function() { trace("Asset button clicked!"); }
		});
		add(assetBtn);
		
		add(utils.DemoUtils.createUsageBox(
"var myButton = new Button(x, y, \"Click Me\", {
    width: 200,
    backgroundColor: 0xFF333333,
    textColor: 0xFFFFFFFF,
    onClick: function() { trace(\"Clicked!\"); }
});
add(myButton);", "source/easel/inputs/Button.hx"
		));
		
		var transparentBtn = new Button(350, 100, "Transparent", {
			onClick: function() { trace("Transparent button clicked!"); }
		});
		add(transparentBtn);
	}
}
