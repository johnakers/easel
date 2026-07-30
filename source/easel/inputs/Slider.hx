package easel.inputs;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;
import flixel.math.FlxMath;

typedef SliderOptions = {
	?min:Float,
	?max:Float,
	?step:Float,
	?value:Float,
	?width:Float,
	?height:Float, // Thickness of the track
	?trackColor:FlxColor,
	?fillColor:FlxColor,
	?thumbColor:FlxColor,
	?trackAsset:String,
	?fillAsset:String,
	?thumbAsset:String,
	?thumbAssetFrameWidth:Int,
	?thumbAssetFrameHeight:Int,
	?onChange:Float->Void
}

class Slider extends FlxSpriteGroup {
	public var value(default, null):Float;
	public var options(default, null):SliderOptions;

	private var _track:FlxSprite;
	private var _fill:FlxSprite;
	private var _thumb:FlxSprite;

	private var _isDragging:Bool = false;
	private var _min:Float;
	private var _max:Float;
	private var _step:Float;
	
	private var _sliderWidth:Float;
	private var _usableWidth:Float;

	public function new(X:Float, Y:Float, ?options:SliderOptions) {
		super(X, Y);

		this.options = options != null ? options : {};
		
		_min = this.options.min != null ? this.options.min : 0;
		_max = this.options.max != null ? this.options.max : 100;
		_step = this.options.step != null ? this.options.step : 0; // 0 means continuous
		value = this.options.value != null ? this.options.value : _min;
		
		_sliderWidth = this.options.width != null ? this.options.width : 200;
		var trackHeight = this.options.height != null ? this.options.height : 6;
		
		var tColor = this.options.trackColor != null ? this.options.trackColor : 0xFF333333;
		var fColor = this.options.fillColor != null ? this.options.fillColor : FlxColor.WHITE;
		var thColor = this.options.thumbColor != null ? this.options.thumbColor : FlxColor.WHITE;

		// 1. Create Track
		_track = new FlxSprite(0, 0);
		if (this.options.trackAsset != null) {
			_track.loadGraphic(this.options.trackAsset);
			_sliderWidth = _track.width;
			trackHeight = _track.height;
		} else {
			_track.makeGraphic(Std.int(_sliderWidth), Std.int(trackHeight), FlxColor.TRANSPARENT);
			FlxSpriteUtil.drawRoundRect(_track, 0, 0, _sliderWidth, trackHeight, trackHeight, trackHeight, tColor);
		}
		add(_track);

		// 2. Create Fill
		_fill = new FlxSprite(0, 0);
		if (this.options.fillAsset != null) {
			_fill.loadGraphic(this.options.fillAsset);
		} else {
			_fill.makeGraphic(Std.int(_sliderWidth), Std.int(trackHeight), FlxColor.TRANSPARENT);
			FlxSpriteUtil.drawRoundRect(_fill, 0, 0, _sliderWidth, trackHeight, trackHeight, trackHeight, fColor);
		}
		// We will use clipRect to show only the active portion of the fill
		_fill.clipRect = new flixel.math.FlxRect(0, 0, 0, trackHeight);
		add(_fill);

		// 3. Create Thumb
		_thumb = new FlxSprite(0, 0);
		if (this.options.thumbAsset != null) {
			if (this.options.thumbAssetFrameWidth != null && this.options.thumbAssetFrameHeight != null) {
				_thumb.loadGraphic(this.options.thumbAsset, true, this.options.thumbAssetFrameWidth, this.options.thumbAssetFrameHeight);
				_thumb.animation.add("normal", [0], 1, false);
				_thumb.animation.add("hover", [1], 1, false);
				_thumb.animation.add("dragged", [2], 1, false);
				_thumb.animation.play("normal");
			} else {
				_thumb.loadGraphic(this.options.thumbAsset);
			}
		} else {
			var thumbRadius = trackHeight * 1.5;
			if (thumbRadius < 8) thumbRadius = 8;
			var thumbSize = Std.int(thumbRadius * 2);
			_thumb.makeGraphic(thumbSize, thumbSize, FlxColor.TRANSPARENT);
			FlxSpriteUtil.drawCircle(_thumb, thumbRadius, thumbRadius, thumbRadius, thColor);
		}
		add(_thumb);
		
		// Vertically align track and thumb
		_track.y = this.y + (_thumb.height - _track.height) / 2;
		_fill.y = _track.y;
		
		_usableWidth = _sliderWidth - _thumb.width;
		
		updateVisuals();
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);

		var overlapsThumb = FlxG.mouse.x >= _thumb.x && FlxG.mouse.x <= _thumb.x + _thumb.width && FlxG.mouse.y >= _thumb.y && FlxG.mouse.y <= _thumb.y + _thumb.height;

		if (FlxG.mouse.justPressed && overlapsThumb) {
			_isDragging = true;
		}

		if (FlxG.mouse.justReleased) {
			_isDragging = false;
		}

		if (_isDragging) {
			// Calculate new handle X based on mouse
			var localMouseX = FlxG.mouse.x - this.x;
			var targetThumbX = localMouseX - (_thumb.width / 2);
			
			// Clamp thumb X to bounds
			if (targetThumbX < 0) targetThumbX = 0;
			if (targetThumbX > _usableWidth) targetThumbX = _usableWidth;
			
			// Calculate raw value
			var percentage = targetThumbX / _usableWidth;
			var rawValue = _min + percentage * (_max - _min);
			
			// Apply stepping if required
			if (_step > 0) {
				var steps = Math.round((rawValue - _min) / _step);
				value = _min + steps * _step;
				// Re-clamp value just in case floating point math pushes it slightly over
				if (value > _max) value = _max;
				if (value < _min) value = _min;
			} else {
				value = rawValue;
			}
			
			var changed = updateVisuals();
			if (changed && options.onChange != null) {
				options.onChange(value);
			}
		}

		if (options.thumbAsset != null && options.thumbAssetFrameWidth != null) {
			if (_isDragging) {
				_thumb.animation.play("dragged");
			} else if (overlapsThumb) {
				_thumb.animation.play("hover");
			} else {
				_thumb.animation.play("normal");
			}
		}
	}
	
	private function updateVisuals():Bool {
		var oldX = _thumb.x;
		
		var percentage = (value - _min) / (_max - _min);
		_thumb.x = this.x + percentage * _usableWidth;
		
		// Update fill clip
		var fillW = (_thumb.x - this.x) + (_thumb.width / 2);
		_fill.clipRect = new flixel.math.FlxRect(0, 0, fillW, _fill.height);
		
		return oldX != _thumb.x;
	}
}
