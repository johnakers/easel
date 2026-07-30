package animations;

import flixel.FlxState;
import flixel.FlxG;
import easel.components.DancingText;
import utils.DemoUtils;
import easel.inputs.Button;

class DancingTextState extends FlxState {
	override public function create():Void {
		super.create();
		
		add(DemoUtils.createHeader("Home / Animations / DancingText", function() { FlxG.switchState(AnimationsState.new); }));
		
		var animText = new DancingText(FlxG.width / 2 - 150, FlxG.height / 2 - 50, "WAVY TEXT!", {
			fontSize: 32,
			fontColor: 0xFF00FF00,
			waveSpeed: 6.0,
			waveHeight: 10.0,
			waveFrequency: 0.5
		});
		add(animText);
		
		var restartBtn = new Button(FlxG.width - 150, 60, "Restart Demo", {
			borderColor: 0xFFFFFFFF,
			padding: 10,
			onClick: function() {
				FlxG.switchState(DancingTextState.new);
			}
		});
		add(restartBtn);
		
		add(utils.DemoUtils.createUsageBox(
"var wavy = new DancingText(x, y, \"Hello!\", {
    fontSize: 24,
    waveSpeed: 5.0,
    waveHeight: 8.0
});
add(wavy);", "source/easel/components/DancingText.hx"
		));
	}
}
