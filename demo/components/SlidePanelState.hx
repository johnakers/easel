package components;

import flixel.FlxState;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import easel.inputs.Button;
import easel.components.SlidePanel;
import easel.components.Card;

import utils.DemoUtils;
import easel.Easel;

class SlidePanelState extends FlxState {
	override public function create():Void {
		super.create();
		
		add(DemoUtils.createHeader("Home / Components / SlidePanel", function() { FlxG.switchState(ComponentsState.new); }));
		
		// Create a slide panel acting purely as a transparent layout container
		var myPanel = new SlidePanel(FlxG.width / 2, FlxG.height / 2 - 100, {
			width: 300,
			height: 400,
			slideFrom: "RIGHT",
			slideDuration: 0.6,
			backgroundColor: FlxColor.TRANSPARENT,
			borderColor: FlxColor.TRANSPARENT
		});
		
		// Add a Card to it
		var title = new FlxText(0, 0, 0, "Hello World", 22);
		title.color = FlxColor.YELLOW;
		var desc = new FlxText(0, 0, 260, "This card is inside a SlidePanel container that can slide anywhere!", 16);
		
		var myCard = new Card(0, 0, {
			width: 300,
			header: title,
			content: desc,
			padding: 20,
			gap: 15,
			backgroundColor: 0xFF1A1A1A,
			borderColor: 0xFF444444
		});
		myPanel.add(myCard);
		// Wait to add myPanel until the end so it renders on top
		
		// Control buttons
		var btnY = 80;
		var slideInBtn = new Button(20, btnY, "Slide In", {
			backgroundColor: 0xFF222222,
			hoverBackgroundColor: 0xFF444444,
			onClick: function() { myPanel.show(); } // Uses the constructor's slideFrom default
		});
		add(slideInBtn);
		btnY += 50;
		
		var outLeftBtn = new Button(20, btnY, "Slide Out (Left)", {
			backgroundColor: 0xFF222222,
			hoverBackgroundColor: 0xFF444444,
			onClick: function() { myPanel.hide("LEFT"); }
		});
		add(outLeftBtn);
		btnY += 50;
		
		var outRightBtn = new Button(20, btnY, "Slide Out (Right)", {
			backgroundColor: 0xFF222222,
			hoverBackgroundColor: 0xFF444444,
			onClick: function() { myPanel.hide("RIGHT"); }
		});
		add(outRightBtn);
		btnY += 50;
		
		var outTopBtn = new Button(20, btnY, "Slide Out (Top)", {
			backgroundColor: 0xFF222222,
			hoverBackgroundColor: 0xFF444444,
			onClick: function() { myPanel.hide("TOP"); }
		});
		add(outTopBtn);
		btnY += 50;
		
		var outBottomBtn = new Button(20, btnY, "Slide Out (Bottom)", {
			backgroundColor: 0xFF222222,
			hoverBackgroundColor: 0xFF444444,
			onClick: function() { myPanel.hide("BOTTOM"); }
		});
		add(outBottomBtn);
		btnY += 60; // Extra gap for restart demo
		
		var restartBtn = new Button(FlxG.width - 150, 60, "Restart Demo", {
			borderColor: 0xFFFFFFFF,
			padding: 10,
			onClick: function() {
				FlxG.switchState(SlidePanelState.new);
			}
		});
		add(restartBtn);
		
		add(DemoUtils.createUsageBox(
"var myPanel = new SlidePanel(100, 100, {
    width: 300, height: 400,
    slideFrom: \"BOTTOM\", startHidden: true
});

myPanel.add(new Card(...));
add(myPanel);

// Show and hide dynamically
myPanel.show(\"RIGHT\");
myPanel.hide(\"LEFT\");", "source/easel/components/SlidePanel.hx"
		));
		
		// Add myPanel last so it renders on top of the CodeBox when sliding!
		add(myPanel);
	}
}
