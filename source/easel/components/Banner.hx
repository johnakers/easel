package easel.components;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;

enum BannerLayout {
	LEFT;
	RIGHT;
	CENTER;
	SPACE_EVENLY;
	SPACE_BETWEEN;
}

typedef BannerOptions = {
	?width:Float,
	?height:Float,
	?backgroundColor:FlxColor,
	?padding:Float,
	?gap:Float,
	?layout:BannerLayout,
	?bgAsset:String,
	?slice:flixel.math.FlxRect
}

class Banner extends FlxSpriteGroup {
	public var options(default, null):BannerOptions;
	private var _bg:FlxSprite;
	
	public function new(X:Float = 0, Y:Float = 0, items:Array<FlxSprite>, ?options:BannerOptions) {
		super(X, Y);
		
		this.options = options != null ? options : {};
		
		var bgColor = this.options.backgroundColor != null ? this.options.backgroundColor : 0xFF2A2A2A;
		var padding = this.options.padding != null ? this.options.padding : 16.0;
		var gap = this.options.gap != null ? this.options.gap : 16.0;
		var layout = this.options.layout != null ? this.options.layout : LEFT;
		
		// 1. Calculate items total width and max height
		var totalItemWidth:Float = 0;
		var maxItemHeight:Float = 0;
		
		for (item in items) {
			totalItemWidth += item.width;
			if (item.height > maxItemHeight) maxItemHeight = item.height;
		}
		
		// 2. Determine final dimensions
		var finalWidth = this.options.width != null ? this.options.width : FlxG.width;
		var finalHeight = this.options.height != null ? this.options.height : (maxItemHeight + padding * 2);
		
		// 3. Draw Background
		if (this.options.bgAsset != null) {
			if (this.options.slice != null) {
				_bg = new flixel.addons.display.FlxSliceSprite(this.options.bgAsset, this.options.slice, finalWidth, finalHeight);
			} else {
				_bg = new FlxSprite(0, 0);
				_bg.loadGraphic(this.options.bgAsset);
				if (this.options.width == null) finalWidth = _bg.width;
				if (this.options.height == null) finalHeight = _bg.height;
				_bg.setGraphicSize(Std.int(finalWidth), Std.int(finalHeight));
				_bg.updateHitbox();
			}
		} else {
			_bg = new FlxSprite(0, 0);
			_bg.makeGraphic(Std.int(finalWidth), Std.int(finalHeight), bgColor);
		}
		add(_bg);
		
		if (items.length == 0) return;
		
		// 4. Layout Math
		var currentX:Float = padding;
		var activeGap:Float = gap;
		
		switch (layout) {
			case LEFT:
				currentX = padding;
				activeGap = gap;
			case RIGHT:
				var totalWidthWithGaps = totalItemWidth + (items.length - 1) * gap;
				currentX = finalWidth - padding - totalWidthWithGaps;
				activeGap = gap;
			case CENTER:
				var totalWidthWithGaps = totalItemWidth + (items.length - 1) * gap;
				currentX = (finalWidth - totalWidthWithGaps) / 2;
				activeGap = gap;
			case SPACE_BETWEEN:
				currentX = padding;
				var availableSpace = finalWidth - (padding * 2) - totalItemWidth;
				activeGap = items.length > 1 ? availableSpace / (items.length - 1) : 0;
			case SPACE_EVENLY:
				var availableSpace = finalWidth - totalItemWidth;
				activeGap = availableSpace / (items.length + 1);
				currentX = activeGap; // First element starts at one gap length
		}
		
		// 5. Apply positions
		for (item in items) {
			item.x = currentX;
			// Vertically center inside the final height
			item.y = (finalHeight - item.height) / 2;
			
			currentX += item.width + activeGap;
			add(item);
		}
	}
}
