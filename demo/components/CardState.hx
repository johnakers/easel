package components;

import flixel.FlxState;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import easel.inputs.Button;
import easel.components.Typewriter;
import easel.components.Card;

import utils.DemoUtils;
import easel.Easel;

class CardState extends FlxState {
	override public function create():Void {
		super.create();
		
		add(DemoUtils.createHeader("Home / Components / Card", function() { FlxG.switchState(ComponentsState.new); }));
		
		// Let's build a highly modular card!
		
		var customHeader = new Typewriter(0, 0, "BREAKING NEWS!", 1.0, true, {
			fontSize: 16,
			fontColor: FlxColor.RED,
			soundAsset: "assets/sounds/typewriter.wav"
		});
		
		var contentText = new FlxText(0, 0, 360, "The new Easel UI library is now supporting modular composition!\nYou can nest buttons and typewriters inside cards effortlessly.", 14);
		if (Easel.defaultFont != null) contentText.font = Easel.defaultFont;
		
		var footerBtn = new Button(0, 0, "Acknowledge", {
			backgroundColor: FlxColor.GREEN,
			onClick: function() { trace("Card acknowledged!"); }
		});
		
		var demoCard = new Card(50, 100, {
			width: 400, // Explicit width, but the height will dynamically size to the stacked items!
			header: customHeader,
			content: contentText,
			footer: footerBtn,
			backgroundColor: 0xFF2A2A2A,
			borderColor: 0xFF555555,
			gap: 20
		});
		
		add(demoCard);
		
		var simpleHeader = new FlxText(0, 0, 0, "Asset Card", 22);
		simpleHeader.color = FlxColor.WHITE;
		
		var simpleContent = new FlxText(0, 0, 360, "This card dynamically stretches the 'panel.png' asset to match its dimensions!", 14);
		
		var assetCard = new Card(500, 100, {
			width: 400,
			header: simpleHeader,
			content: simpleContent,
			bgAsset: "assets/images/panel.png",
			gap: 20
		});
		add(assetCard);
		
		add(utils.DemoUtils.createUsageBox(
"var title = new FlxText(0, 0, 0, \"Item Profile\", 18);
var desc = new FlxText(0, 0, 0, \"This is a description\", 14);

var myCard = new Card(x, y, {
    header: title,
    content: desc,
    width: 300,
    gap: 10,
    padding: 20,
    backgroundColor: 0xFF1E1E1E,
    borderColor: 0xFF444444
});
add(myCard);"
		));
	}
}
