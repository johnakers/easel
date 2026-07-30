package easel.components;

import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.FlxG;
import flixel.util.FlxSpriteUtil;

typedef SlidePanelOptions = {
	?width:Float,
	?height:Float,
	?backgroundColor:FlxColor,
	?borderColor:FlxColor,
	?bgAsset:String,
	?slideFrom:String, // "TOP", "BOTTOM", "LEFT", "RIGHT"
	?slideDuration:Float,
	?startHidden:Bool
}

class SlidePanel extends FlxSpriteGroup {
	public var options(default, null):SlidePanelOptions;
	public var isShowing(default, null):Bool;
	
	private var _bg:FlxSprite;
	private var _tween:FlxTween;
	
	private var onscreenX:Float;
	private var onscreenY:Float;
	private var offscreenX:Float;
	private var offscreenY:Float;
	
	public function new(X:Float = 0, Y:Float = 0, ?options:SlidePanelOptions) {
		super(X, Y);
		
		this.options = options != null ? options : {};
		var w = this.options.width != null ? this.options.width : 300;
		var h = this.options.height != null ? this.options.height : 400;
		var bgCol = this.options.backgroundColor != null ? this.options.backgroundColor : 0xFF2A2A2A;
		var borderCol = this.options.borderColor != null ? this.options.borderColor : 0xFF555555;
		var dir = this.options.slideFrom != null ? this.options.slideFrom.toUpperCase() : "BOTTOM";
		var hidden = this.options.startHidden != null ? this.options.startHidden : true;
		
		_bg = new FlxSprite(0, 0);
		if (this.options.bgAsset != null) {
			_bg.loadGraphic(this.options.bgAsset);
			// auto-size if width/height not provided but asset is
			if (this.options.width == null) w = _bg.width;
			if (this.options.height == null) h = _bg.height;
			
			_bg.setGraphicSize(Std.int(w), Std.int(h));
			_bg.updateHitbox();
		} else {
			_bg.makeGraphic(Std.int(w), Std.int(h), FlxColor.TRANSPARENT, true);
			FlxSpriteUtil.drawRoundRect(_bg, 0, 0, w, h, 10, 10, bgCol, { color: borderCol, thickness: 1 });
		}
		add(_bg);
		
		onscreenX = X;
		onscreenY = Y;
		
		// Calculate offscreen coordinates
		offscreenX = X;
		offscreenY = Y;
		
		if (dir == "TOP") offscreenY = -h;
		else if (dir == "BOTTOM") offscreenY = FlxG.height;
		else if (dir == "LEFT") offscreenX = -w;
		else if (dir == "RIGHT") offscreenX = FlxG.width;
		
		isShowing = !hidden;
		if (hidden) {
			this.x = offscreenX;
			this.y = offscreenY;
		}
	}
	
	public function toggle():Void {
		if (isShowing) hide();
		else show();
	}
	
	public function show(?slideFrom:String):Void {
		if (isShowing) return;
		isShowing = true;
		
		if (_tween != null) _tween.cancel();
		
		if (slideFrom != null) {
			var dir = slideFrom.toUpperCase();
			var w = _bg.width;
			var h = _bg.height;
			
			if (dir == "TOP") { this.x = onscreenX; this.y = -h; }
			else if (dir == "BOTTOM") { this.x = onscreenX; this.y = FlxG.height; }
			else if (dir == "LEFT") { this.x = -w; this.y = onscreenY; }
			else if (dir == "RIGHT") { this.x = FlxG.width; this.y = onscreenY; }
		}
		
		var duration = this.options.slideDuration != null ? this.options.slideDuration : 0.5;
		_tween = FlxTween.tween(this, { x: onscreenX, y: onscreenY }, duration, { ease: FlxEase.quadOut });
	}
	
	public function hide(?slideTo:String):Void {
		if (!isShowing) return;
		isShowing = false;
		
		if (_tween != null) _tween.cancel();
		
		var targetX = onscreenX;
		var targetY = onscreenY;
		
		var dir = slideTo != null ? slideTo.toUpperCase() : (this.options.slideFrom != null ? this.options.slideFrom.toUpperCase() : "BOTTOM");
		var w = _bg.width;
		var h = _bg.height;
		
		if (dir == "TOP") targetY = -h;
		else if (dir == "BOTTOM") targetY = FlxG.height;
		else if (dir == "LEFT") targetX = -w;
		else if (dir == "RIGHT") targetX = FlxG.width;
		
		var duration = this.options.slideDuration != null ? this.options.slideDuration : 0.4;
		_tween = FlxTween.tween(this, { x: targetX, y: targetY }, duration, { ease: FlxEase.quadIn });
	}
}
