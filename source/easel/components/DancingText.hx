package easel.components;

import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.text.FlxBitmapText;
import flixel.graphics.frames.FlxBitmapFont;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import easel.Easel;

typedef DancingTextOptions = {
	?font:String,
	?fontSize:Int,
	?fontColor:FlxColor,
	?letterSpacing:Float,
	?waveSpeed:Float,
	?waveHeight:Float,
	?waveFrequency:Float,
	?bitmapFont:FlxBitmapFont
}

class DancingText extends FlxSpriteGroup {
	public var text(default, set):String;
	public var options(default, null):DancingTextOptions;
	
	private var _playTime:Float = 0;
	private var _chars:Array<FlxSprite> = [];
	
	public function new(X:Float, Y:Float, text:String, ?options:DancingTextOptions) {
		super(X, Y);
		
		this.options = options != null ? options : {};
		
		// Set defaults
		if (this.options.fontSize == null) this.options.fontSize = 16;
		if (this.options.fontColor == null) this.options.fontColor = FlxColor.WHITE;
		if (this.options.letterSpacing == null) this.options.letterSpacing = 2;
		if (this.options.waveSpeed == null) this.options.waveSpeed = 6.0;
		if (this.options.waveHeight == null) this.options.waveHeight = 6.0;
		if (this.options.waveFrequency == null) this.options.waveFrequency = 0.5;
		
		this.text = text;
	}
	
	private function set_text(val:String):String {
		text = val;
		rebuildText();
		return val;
	}
	
	private function rebuildText():Void {
		// Clear existing characters
		for (c in _chars) {
			remove(c);
			c.destroy();
		}
		_chars = [];
		
		var curX:Float = 0;
		
		for (i in 0...text.length) {
			var char = text.charAt(i);
			
			if (char == " ") {
				// Add space width based on font size roughly
				curX += (options.fontSize * 0.4) + options.letterSpacing;
				continue;
			}
			
			var spr:FlxSprite = null;
			
			if (options.bitmapFont != null) {
				var bText = new FlxBitmapText(options.bitmapFont);
				bText.text = char;
				bText.color = options.fontColor;
				bText.x = curX;
				spr = bText;
				curX += bText.width + options.letterSpacing;
			} else {
				var tText = new FlxText(curX, 0, 0, char, options.fontSize);
				tText.color = options.fontColor;
				if (options.font != null) tText.font = options.font;
				else if (Easel.defaultFont != null) tText.font = Easel.defaultFont;
				spr = tText;
				curX += tText.textField.textWidth + options.letterSpacing;
			}
			
			_chars.push(spr);
			add(spr);
		}
	}
	
	override public function update(elapsed:Float):Void {
		super.update(elapsed);
		_playTime += elapsed;
		
		var idx = 0;
		for (t in _chars) {
			if (t != null) {
				t.offset.y = Math.sin(_playTime * options.waveSpeed + (idx * options.waveFrequency)) * options.waveHeight;
				idx++;
			}
		}
	}
}
