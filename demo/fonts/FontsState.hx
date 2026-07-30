package fonts;

import flixel.FlxState;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import utils.DemoUtils;
import easel.Easel;

class FontsState extends FlxState {
	override public function create():Void {
		super.create();
		
		FlxG.autoPause = false;
		
		add(DemoUtils.createHeader("Home / Fonts", function() { FlxG.switchState(PlayState.new); }));
		
		var testString = "the quick brown fox jumped over the lazy dog";
		
		var fontFiles = [
			"assets/fonts/04B_03/04B_03__.TTF",
			"assets/fonts/Altima/Altima.ttf",
			"assets/fonts/Kingdom/Kingdom_v1.4.ttf",
			"assets/fonts/Mistral Regular/Mistral Regular.ttf",
			"assets/fonts/mochibop/Mochibop-Demo.ttf",
			"assets/fonts/mochibop/MochibopBold-Demo.ttf"
		];
		
		var fontNames = [
			"04B 03",
			"Altima",
			"Kingdom",
			"Mistral",
			"Mochibop Demo",
			"Mochibop Bold"
		];
		
		var startY = 80;
		for (i in 0...fontFiles.length) {
			var label = new FlxText(20, startY, 0, fontNames[i] + ":", 14);
			label.color = FlxColor.YELLOW;
			if (Easel.defaultFont != null) label.font = Easel.defaultFont;
			add(label);
			
			var demoText = new FlxText(20, startY + 20, 0, testString, 28);
			demoText.font = fontFiles[i];
			add(demoText);
			
			startY += 90; // Add enough spacing for large font previews
		}
	}
}
