package inputs;

import flixel.FlxState;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import easel.inputs.Slider;
import utils.DemoUtils;
import easel.Easel;

class SliderState extends FlxState {
	override public function create():Void {
		super.create();
		
		add(DemoUtils.createHeader("Home / Inputs / Slider", function() { FlxG.switchState(InputsState.new); }));
		
		// 1. Default Smooth Slider
		var defaultLabel = new FlxText(50, 100, 0, "Volume: 50.0", 16);
		if (Easel.defaultFont != null) defaultLabel.font = Easel.defaultFont;
		add(defaultLabel);
		
		var slider1 = new Slider(50, 130, {
			min: 0,
			max: 100,
			value: 50,
			width: 300,
			onChange: function(val) {
				defaultLabel.text = "Volume: " + Math.round(val * 10) / 10;
			}
		});
		add(slider1);
		
		// 2. Stepped Custom Slider
		var stepLabel = new FlxText(50, 220, 0, "Difficulty: 2", 16);
		if (Easel.defaultFont != null) stepLabel.font = Easel.defaultFont;
		add(stepLabel);
		
		var slider2 = new Slider(50, 250, {
			min: 1,
			max: 5,
			step: 1,
			value: 2,
			width: 200,
			height: 10,
			trackColor: 0xFF222222,
			fillColor: FlxColor.RED,
			thumbColor: FlxColor.YELLOW,
			onChange: function(val) {
				stepLabel.text = "Difficulty: " + val;
			}
		});
		add(slider2);
		
		// 3. Asset Slider
		var assetLabel = new FlxText(400, 100, 0, "Asset Slider: 0.0", 16);
		if (Easel.defaultFont != null) assetLabel.font = Easel.defaultFont;
		add(assetLabel);
		
		var slider3 = new Slider(400, 130, {
			min: 0,
			max: 100,
			value: 0,
			trackAsset: "assets/images/slider/slide_track.png",
			thumbAsset: "assets/images/slider/slider_handle_spritesheet.png",
			thumbAssetFrameWidth: 16,
			thumbAssetFrameHeight: 24,
			onChange: function(val) {
				assetLabel.text = "Asset Slider: " + Math.round(val * 10) / 10;
			}
		});
		add(slider3);
		
		add(utils.DemoUtils.createUsageBox(
"var mySlider = new Slider(x, y, {
    width: 300,
    min: 0,
    max: 100,
    step: 5,
    fillColor: 0xFF00FF00,
    onChange: function(val) { trace(\"Volume: \" + val); }
});
add(mySlider);"
		));
	}
}
