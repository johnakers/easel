package easel.inputs;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.text.FlxBitmapText;
import flixel.graphics.frames.FlxBitmapFont;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;

typedef ButtonOptions = {
	?font:String,
	?fontSize:Int,
	?fontColor:FlxColor,
	?hoverFontColor:FlxColor,
	?backgroundColor:FlxColor,
	?hoverBackgroundColor:FlxColor,
	?borderColor:FlxColor,
	?onClick:Void->Void,
	?padding:Int,
	?bgAsset:String,
	?bgAssetFrameWidth:Int,
	?bgAssetFrameHeight:Int,
	?bitmapFont:FlxBitmapFont
}

class Button extends FlxSpriteGroup {
	public var text(default, null):String;
	public var options(default, null):ButtonOptions;

	private var _bg:FlxSprite;
	private var _label:FlxSprite; // Using FlxSprite to support both FlxText and FlxBitmapText

	public function new(X:Float, Y:Float, text:String, ?options:ButtonOptions) {
		super(X, Y);

		this.text = text;
		this.options = options != null ? options : {};
		
		// Set default options
		if (this.options.fontSize == null) this.options.fontSize = 16;
		if (this.options.fontColor == null) this.options.fontColor = FlxColor.WHITE;
		if (this.options.hoverFontColor == null) this.options.hoverFontColor = FlxColor.BLACK;
		if (this.options.backgroundColor == null) this.options.backgroundColor = FlxColor.TRANSPARENT;
		if (this.options.borderColor == null) this.options.borderColor = FlxColor.TRANSPARENT;
		if (this.options.padding == null) this.options.padding = 8;
		
		var pad = this.options.padding;

		// Create text first to measure it
		if (this.options.bitmapFont != null) {
			var bText = new FlxBitmapText(this.options.bitmapFont);
			bText.text = this.text;
			bText.color = this.options.fontColor;
			_label = bText;
		} else {
			var tText = new FlxText(0, 0, 0, this.text, this.options.fontSize);
			tText.color = this.options.fontColor;
			if (this.options.font != null) {
				tText.font = this.options.font;
			} else if (easel.Easel.defaultFont != null) {
				tText.font = easel.Easel.defaultFont;
			}
			_label = tText;
		}

		// Create background
		_bg = new FlxSprite(0, 0);
		
		if (this.options.bgAsset != null) {
			if (this.options.bgAssetFrameWidth != null && this.options.bgAssetFrameHeight != null) {
				_bg.loadGraphic(this.options.bgAsset, true, this.options.bgAssetFrameWidth, this.options.bgAssetFrameHeight);
				_bg.animation.add("normal", [0], 1, false);
				_bg.animation.add("hover", [1], 1, false);
				_bg.animation.add("pressed", [2], 1, false);
				_bg.animation.play("normal");
			} else {
				_bg.loadGraphic(this.options.bgAsset);
			}
			
			// Auto-scale background if text exceeds it
			var reqW = _label.width + (pad * 2);
			var reqH = _label.height + (pad * 2);
			if (reqW > _bg.width || reqH > _bg.height) {
				var finalW = Math.max(_bg.width, reqW);
				var finalH = Math.max(_bg.height, reqH);
				_bg.setGraphicSize(Std.int(finalW), Std.int(finalH));
				_bg.updateHitbox();
			}
		} else {
			var btnWidth = Std.int(_label.width) + (pad * 2);
			var btnHeight = Std.int(_label.height) + (pad * 2);
			_bg.makeGraphic(btnWidth, btnHeight, FlxColor.TRANSPARENT, true);

			// Draw background and border
			var lineStyle:flixel.util.FlxSpriteUtil.LineStyle = null;
			if (this.options.borderColor != FlxColor.TRANSPARENT) {
				lineStyle = { color: this.options.borderColor, thickness: 2 };
			}

			if (this.options.backgroundColor != FlxColor.TRANSPARENT || this.options.borderColor != FlxColor.TRANSPARENT) {
				FlxSpriteUtil.drawRect(_bg, 0, 0, btnWidth, btnHeight, this.options.backgroundColor, lineStyle);
			}
		}

		// Center the label inside the background precisely
		_label.x = (_bg.width - _label.width) / 2;
		_label.y = (_bg.height - _label.height) / 2;

		add(_bg);
		add(_label);
	}

	private var _isHovered:Bool = false;

	override public function update(elapsed:Float):Void {
		super.update(elapsed);

		var overlaps = FlxG.mouse.overlaps(_bg);

		if (overlaps != _isHovered) {
			_isHovered = overlaps;
			
			if (options.hoverFontColor != null) {
				_label.color = _isHovered ? options.hoverFontColor : options.fontColor;
			}
			
			if (options.hoverBackgroundColor != null && options.bgAsset == null) {
				var bgColor = _isHovered ? options.hoverBackgroundColor : options.backgroundColor;
				
				var pad = options.padding != null ? options.padding : 8;
				var btnWidth = Std.int(_label.width) + (pad * 2);
				var btnHeight = Std.int(_label.height) + (pad * 2);
				
				_bg.makeGraphic(btnWidth, btnHeight, FlxColor.TRANSPARENT, true);

				var lineStyle:flixel.util.FlxSpriteUtil.LineStyle = null;
				if (options.borderColor != FlxColor.TRANSPARENT) {
					lineStyle = { color: options.borderColor, thickness: 2 };
				}

				if (bgColor != FlxColor.TRANSPARENT || options.borderColor != FlxColor.TRANSPARENT) {
					FlxSpriteUtil.drawRect(_bg, 0, 0, btnWidth, btnHeight, bgColor, lineStyle);
				}
			}
		}

		if (options.bgAsset != null && options.bgAssetFrameWidth != null) {
			if (_isHovered) {
				if (FlxG.mouse.pressed) {
					_bg.animation.play("pressed");
				} else {
					_bg.animation.play("hover");
				}
			} else {
				_bg.animation.play("normal");
			}
		} else {
			if (options.hoverBackgroundColor == null || options.bgAsset != null) {
				if (_isHovered) {
					if (FlxG.mouse.pressed) {
						_bg.color = 0xFFAAAAAA;
					} else {
						_bg.color = 0xFFCCCCCC;
					}
				} else {
					_bg.color = FlxColor.WHITE;
				}
			}
		}

		if (FlxG.mouse.justPressed && overlaps) {
			if (options.onClick != null) {
				options.onClick();
			} else {
				trace(text + " was pressed");
			}
		}
	}
}
