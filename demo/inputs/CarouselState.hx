package inputs;

import flixel.FlxState;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import easel.inputs.Carousel;
import utils.DemoUtils;
import easel.Easel;

class CarouselState extends FlxState {
	override public function create():Void {
		super.create();
		
		FlxG.autoPause = false;
		
		add(DemoUtils.createHeader("Home / Inputs / Carousel", function() { FlxG.switchState(InputsState.new); }));
		
		var statusText = new FlxText(50, 100, 0, "Selected: Red", 22);
		statusText.color = FlxColor.RED;
		var b1 = new FlxSprite().makeGraphic(80, 80, FlxColor.RED);
		var b2 = new FlxSprite().makeGraphic(80, 80, FlxColor.GREEN);
		var b3 = new FlxSprite().makeGraphic(80, 80, FlxColor.BLUE);
		
		var carousel1 = new Carousel(50, 100, [b1, b2, b3], {
			wrapAround: true,
			gap: 20,
			arrowAsset: "assets/images/arrow_spritesheet.png"
		});
		add(carousel1);
		
		var box1 = new FlxSprite().makeGraphic(80, 80, FlxColor.MAGENTA);
		var box2 = new FlxSprite().makeGraphic(80, 80, FlxColor.ORANGE);
		var box3 = new FlxSprite().makeGraphic(80, 80, FlxColor.WHITE);
		var box4 = new FlxSprite().makeGraphic(80, 80, FlxColor.BROWN);
		
		var carousel2 = new Carousel(50, 250, [box1, box2, box3, box4], {
			wrapAround: false,
			gap: 20,
			arrowAsset: "assets/images/arrow_spritesheet.png"
		});
		add(carousel2);
		
		add(utils.DemoUtils.createUsageBox(
"var myCarousel = new Carousel(x, y, [sprite1, sprite2, sprite3], {
    wrapAround: true,
    width: 300,
    gap: 20,
    onChange: function(index, sprite) { trace(\"Selected: \" + index); }
});
add(myCarousel);", "source/easel/inputs/Carousel.hx"
		));
	}
}
