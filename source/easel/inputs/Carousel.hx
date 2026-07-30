package easel.inputs;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;
import easel.Easel;

typedef CarouselOptions = {
	?width:Float,
	?gap:Float,
	?arrowAsset:String,
	?arrowColor:FlxColor,
	?arrowSize:Float,
	?startIndex:Int,
	?wrapAround:Bool,
	?onChange:Int->FlxSprite->Void
}

class Carousel extends FlxSpriteGroup {
	public var currentIndex(default, null):Int;
	public var options(default, null):CarouselOptions;
	
	private var _items:Array<FlxSprite>;
	private var _leftArrow:FlxSprite;
	private var _rightArrow:FlxSprite;
	private var _wrapAround:Bool;

	public function new(X:Float, Y:Float, items:Array<FlxSprite>, ?options:CarouselOptions) {
		super(X, Y);

		this.options = options != null ? options : {};
		
		_items = items;
		if (_items == null) _items = [];
		
		currentIndex = this.options.startIndex != null ? this.options.startIndex : 0;
		if (currentIndex < 0) currentIndex = 0;
		if (currentIndex >= _items.length) currentIndex = _items.length - 1;
		
		_wrapAround = this.options.wrapAround != null ? this.options.wrapAround : true;
		
		var arrSize = this.options.arrowSize != null ? this.options.arrowSize : 30.0;
		var aColor = this.options.arrowColor != null ? this.options.arrowColor : FlxColor.WHITE;
		var gap = this.options.gap != null ? this.options.gap : 20.0;
		var cWidth = this.options.width != null ? this.options.width : 200.0;
		
		// 1. Create Arrows
		if (this.options.arrowAsset != null) {
			var temp = new FlxSprite(0, 0);
			temp.loadGraphic(this.options.arrowAsset);
			var frameW = Std.int(temp.width / 2);
			var frameH = Std.int(temp.height);
			
			_leftArrow = new FlxSprite(0, 0);
			_leftArrow.loadGraphic(this.options.arrowAsset, true, frameW, frameH);
			_leftArrow.animation.frameIndex = 0;
			
			_rightArrow = new FlxSprite(0, 0);
			_rightArrow.loadGraphic(this.options.arrowAsset, true, frameW, frameH);
			_rightArrow.animation.frameIndex = 1;
			
			temp.destroy();
		} else {
			var lText = new flixel.text.FlxText(0, 0, 0, "<", Std.int(arrSize));
			lText.color = aColor;
			if (Easel.defaultFont != null) lText.font = Easel.defaultFont;
			_leftArrow = lText;
			
			var rText = new flixel.text.FlxText(0, 0, 0, ">", Std.int(arrSize));
			rText.color = aColor;
			if (Easel.defaultFont != null) rText.font = Easel.defaultFont;
			_rightArrow = rText;
		}
		
		// 2. Layout
		// Assuming all items are the same size per rules
		var itemWidth = _items.length > 0 ? _items[0].width : 0;
		var itemHeight = _items.length > 0 ? _items[0].height : 0;
		
		var maxHeight = Math.max(itemHeight, arrSize);
		
		// Position at 0, 0 relative to the group
		_leftArrow.x = 0;
		_leftArrow.y = (maxHeight - _leftArrow.height) / 2;
		add(_leftArrow);
		
		if (this.options.width != null) {
			_rightArrow.x = cWidth - _rightArrow.width;
		} else {
			_rightArrow.x = _leftArrow.width + gap + itemWidth + gap;
			cWidth = _rightArrow.x + _rightArrow.width;
		}
		_rightArrow.y = (maxHeight - _rightArrow.height) / 2;
		add(_rightArrow);
		
		// We can use the already-added coordinates since they have the group offset applied.
		// So we calculate center space using their absolute coordinates.
		var centerSpaceX = _leftArrow.x + _leftArrow.width;
		var centerSpaceW = _rightArrow.x - centerSpaceX;
		
		for (i in 0..._items.length) {
			var item = _items[i];
			// item.x needs to be relative BEFORE we add it. 
			// Wait, centerSpaceX has the offset. So relative X = centerSpaceX - this.x
			var relCenterX = _leftArrow.width;
			var relCenterW = _rightArrow.x - _leftArrow.x - _leftArrow.width;
			
			item.x = relCenterX + (relCenterW - item.width) / 2;
			item.y = (maxHeight - item.height) / 2;
			item.visible = (i == currentIndex);
			add(item);
		}
		
		updateArrows();
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);

		var lOverlaps = false;
		var rOverlaps = false;
		
		if (_leftArrow != null && _leftArrow.visible) {
			lOverlaps = FlxG.mouse.x >= _leftArrow.x && FlxG.mouse.x <= _leftArrow.x + _leftArrow.width && FlxG.mouse.y >= _leftArrow.y && FlxG.mouse.y <= _leftArrow.y + _leftArrow.height;
			_leftArrow.alpha = lOverlaps ? 0.7 : 1.0;
		}
		
		if (_rightArrow != null && _rightArrow.visible) {
			rOverlaps = FlxG.mouse.x >= _rightArrow.x && FlxG.mouse.x <= _rightArrow.x + _rightArrow.width && FlxG.mouse.y >= _rightArrow.y && FlxG.mouse.y <= _rightArrow.y + _rightArrow.height;
			_rightArrow.alpha = rOverlaps ? 0.7 : 1.0;
		}

		if (FlxG.mouse.justPressed) {
			if (lOverlaps) {
				changeIndex(-1);
			} else if (rOverlaps) {
				changeIndex(1);
			}
		}
	}
	
	private function changeIndex(delta:Int):Void {
		var newIndex = currentIndex + delta;
		
		if (newIndex < 0) {
			if (_wrapAround) newIndex = _items.length - 1;
			else newIndex = 0;
		} else if (newIndex >= _items.length) {
			if (_wrapAround) newIndex = 0;
			else newIndex = _items.length - 1;
		}
		
		if (newIndex != currentIndex) {
			if (_items[currentIndex] != null) _items[currentIndex].visible = false;
			currentIndex = newIndex;
			if (_items[currentIndex] != null) _items[currentIndex].visible = true;
			
			updateArrows();
			
			if (options.onChange != null && _items.length > 0) {
				options.onChange(currentIndex, _items[currentIndex]);
			}
		}
	}
	
	private function updateArrows():Void {
		if (!_wrapAround) {
			_leftArrow.visible = currentIndex > 0;
			_rightArrow.visible = currentIndex < _items.length - 1;
		} else {
			_leftArrow.visible = true;
			_rightArrow.visible = true;
		}
	}
}
