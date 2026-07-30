package components;

import flixel.FlxState;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import easel.inputs.Button;
import easel.components.Banner;

import utils.DemoUtils;
import easel.Easel;

class BannerState extends FlxState {
	override public function create():Void {
		super.create();
		
		add(DemoUtils.createHeader("Home / Components / Banner", function() { FlxG.switchState(ComponentsState.new); }));
		
		// 1. SPACE_BETWEEN Banner (Classic Navbar)
		var logo1 = new FlxText(0, 0, 0, "MyApp Logo", 16);
		logo1.color = FlxColor.WHITE;
		if (Easel.defaultFont != null) logo1.font = Easel.defaultFont;
		var link1 = new Button(0, 0, "Home");
		var link2 = new Button(0, 0, "About");
		var link3 = new Button(0, 0, "Contact");
		
		var banner1 = new Banner(0, 80, [logo1, link1, link2, link3], {
			layout: SPACE_BETWEEN,
			backgroundColor: 0xFF111111,
			height: 50
		});
		add(banner1);
		
		var desc1 = new FlxText(10, 135, 0, "SPACE_BETWEEN: Pins the first and last elements to the edges, spacing the rest evenly.", 14);
		desc1.color = 0xFFAAAAAA;
		if (Easel.defaultFont != null) desc1.font = Easel.defaultFont;
		add(desc1);
		
		// 2. SPACE_EVENLY Banner
		var btnA = new Button(0, 0, "Tab 1");
		var btnB = new Button(0, 0, "Tab 2");
		var btnC = new Button(0, 0, "Tab 3");
		
		var banner2 = new Banner(0, 180, [btnA, btnB, btnC], {
			layout: SPACE_EVENLY,
			backgroundColor: 0xFF222222,
			height: 50
		});
		add(banner2);
		
		var desc2 = new FlxText(10, 235, 0, "SPACE_EVENLY: Spreads all elements equally across the entire width, including the edges.", 14);
		desc2.color = 0xFFAAAAAA;
		if (Easel.defaultFont != null) desc2.font = Easel.defaultFont;
		add(desc2);
		
		// 3. CENTER Banner
		var textC = new FlxText(0, 0, 0, "Welcome to the Application", 14);
		if (Easel.defaultFont != null) textC.font = Easel.defaultFont;
		var btnD = new Button(0, 0, "Login", { backgroundColor: FlxColor.BLUE });
		
		var banner3 = new Banner(0, 280, [textC, btnD], {
			layout: CENTER,
			backgroundColor: 0xFF333333,
			gap: 40
		});
		add(banner3);
		
		var desc3 = new FlxText(10, 360, 0, "CENTER: Groups all elements perfectly in the center with a fixed gap between them.", 14);
		desc3.color = 0xFFAAAAAA;
		if (Easel.defaultFont != null) desc3.font = Easel.defaultFont;
		add(desc3);
		
		add(utils.DemoUtils.createUsageBox(
"var title = new FlxText(0, 0, 0, \"My App\", 22);
var button = new Button(0, 0, \"Settings\", { onClick: onSettings });

var myBanner = new Banner(x, y, [title, button], {
    width: 1000,
    height: 60,
    layout: SPACE_BETWEEN,
    backgroundColor: 0xFF222222,
    padding: 20
});
add(myBanner);", "source/easel/components/Banner.hx"
		));
	}
}
