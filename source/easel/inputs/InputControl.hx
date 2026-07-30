package easel.inputs;

import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import easel.Easel;

enum InputControlLayout {
	TWO_COLUMN;
	STACKED;
}

typedef InputControlOptions = {
	?layout:InputControlLayout,
	?width:Float,
	?gap:Float,
	?font:String,
	?fontSize:Int,
	?fontColor:FlxColor
}

class InputControl extends FlxSpriteGroup {
	public var options(default, null):InputControlOptions;
	
	private var _labelTxt:FlxText;
	private var _input:FlxSprite;

	public function new(X:Float, Y:Float, labelText:String, input:FlxSprite, ?options:InputControlOptions) {
		super(X, Y);

		this.options = options != null ? options : {};
		
		var layout = this.options.layout != null ? this.options.layout : TWO_COLUMN;
		var gap = this.options.gap != null ? this.options.gap : 15.0;
		var fSize = this.options.fontSize != null ? this.options.fontSize : 16;
		var fColor = this.options.fontColor != null ? this.options.fontColor : FlxColor.WHITE;
		
		// 1. Create Label
		_labelTxt = new FlxText(0, 0, 0, labelText, fSize);
		_labelTxt.color = fColor;
		if (this.options.font != null) _labelTxt.font = this.options.font;
		else if (Easel.defaultFont != null) _labelTxt.font = Easel.defaultFont;
		
		_input = input;
		
		// 2. Layout Positioning
		if (layout == TWO_COLUMN) {
			_labelTxt.x = 0;
			
			if (this.options.width != null) {
				_input.x = this.options.width - _input.width;
			} else {
				_input.x = _labelTxt.width + gap;
			}
			
			// Vertically align
			if (_labelTxt.height > _input.height) {
				_labelTxt.y = 0;
				_input.y = (_labelTxt.height - _input.height) / 2;
			} else {
				_input.y = 0;
				_labelTxt.y = (_input.height - _labelTxt.height) / 2;
			}
		} 
		else if (layout == STACKED) {
			_labelTxt.x = 0;
			_labelTxt.y = 0;
			
			_input.x = 0;
			_input.y = _labelTxt.height + gap;
		}
		
		add(_labelTxt);
		add(_input);
	}
}
