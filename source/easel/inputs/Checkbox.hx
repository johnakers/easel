package easel.inputs;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;
import easel.Easel;

typedef CheckboxOptions = {
	?checked:Bool,
	?label:String,
	?font:String,
	?fontSize:Int,
	?fontColor:FlxColor,
	?boxColor:FlxColor,
	?checkColor:FlxColor,
	?boxSize:Float,
	?bgAsset:String,
	?bgAssetFrameWidth:Int,
	?bgAssetFrameHeight:Int,
	?checkAsset:String,
	?onToggle:Bool->Void
}

class Checkbox extends FlxSpriteGroup {
	public var checked(default, null):Bool;
	public var options(default, null):CheckboxOptions;

	private var _bg:FlxSprite;
	private var _check:FlxSprite;
	private var _labelTxt:FlxText;

	public function new(X:Float, Y:Float, ?options:CheckboxOptions) {
		super(X, Y);

		this.options = options != null ? options : {};
		
		checked = this.options.checked != null ? this.options.checked : false;
		
		var bSize = this.options.boxSize != null ? this.options.boxSize : 20.0;
		var bColor = this.options.boxColor != null ? this.options.boxColor : 0xFF2A2A2A;
		var cColor = this.options.checkColor != null ? this.options.checkColor : FlxColor.WHITE;

		// 1. Box Background
		_bg = new FlxSprite(0, 0);
		if (this.options.bgAsset != null) {
			if (this.options.bgAssetFrameWidth != null && this.options.bgAssetFrameHeight != null) {
				_bg.loadGraphic(this.options.bgAsset, true, this.options.bgAssetFrameWidth, this.options.bgAssetFrameHeight);
				_bg.animation.add("unchecked", [0], 1, false);
				_bg.animation.add("checked", [1], 1, false);
				_bg.animation.play(checked ? "checked" : "unchecked");
			} else {
				_bg.loadGraphic(this.options.bgAsset);
			}
			bSize = _bg.width;
		} else {
			_bg.makeGraphic(Std.int(bSize), Std.int(bSize), FlxColor.TRANSPARENT);
			FlxSpriteUtil.drawRoundRect(_bg, 0, 0, bSize, bSize, 6, 6, FlxColor.WHITE, { color: 0xFF555555, thickness: 1 });
		}
		add(_bg);

		// 2. Checkmark
		_check = new FlxSprite(0, 0);
		if (this.options.bgAsset != null && this.options.bgAssetFrameWidth != null) {
			// Do not add primitive checkmark if using spritesheet
			_check.visible = false;
		} else if (this.options.checkAsset != null) {
			_check.loadGraphic(this.options.checkAsset);
			_check.visible = checked;
			_check.x = (_bg.width - _check.width) / 2;
			_check.y = (_bg.height - _check.height) / 2;
			add(_check);
		} else {
			_check.makeGraphic(Std.int(bSize * 0.6), Std.int(bSize * 0.6), FlxColor.GREEN);
			_check.visible = checked;
			_check.x = (_bg.width - _check.width) / 2;
			_check.y = (_bg.height - _check.height) / 2;
			add(_check);
		}

		// 3. Label
		if (this.options.label != null) {
			var fSize = this.options.fontSize != null ? this.options.fontSize : 16;
			var fColor = this.options.fontColor != null ? this.options.fontColor : FlxColor.WHITE;
			
			_labelTxt = new FlxText(_bg.width + 10, 0, 0, this.options.label, fSize);
			_labelTxt.color = fColor;
			
			if (this.options.font != null) _labelTxt.font = this.options.font;
			else if (Easel.defaultFont != null) _labelTxt.font = Easel.defaultFont;
			
			// Vertically center label with box
			_labelTxt.y = (_bg.height - _labelTxt.height) / 2;
			add(_labelTxt);
		}
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);

		// Toggling on click
		if (FlxG.mouse.justPressed) {
			var overlaps = FlxG.mouse.x >= _bg.x && FlxG.mouse.x <= _bg.x + _bg.width && FlxG.mouse.y >= _bg.y && FlxG.mouse.y <= _bg.y + _bg.height;
			if (overlaps) {
				checked = !checked;
				
				if (this.options.bgAsset != null && this.options.bgAssetFrameWidth != null) {
					_bg.animation.play(checked ? "checked" : "unchecked");
				} else if (this.options.checkAsset != null) {
					_check.visible = checked;
				} else {
					_check.visible = checked;
				}
				
				if (options.onToggle != null) {
					options.onToggle(checked);
				}
			}
		}
	}
}
