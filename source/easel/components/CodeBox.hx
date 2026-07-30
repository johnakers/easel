package easel.components;

import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.math.FlxRect;
import flixel.math.FlxMath;

typedef CodeBoxOptions = {
	?width:Float,
	?height:Float,
	?backgroundColor:FlxColor,
	?font:String,
	?fontSize:Int,
	?padding:Float
}

class CodeBox extends FlxSpriteGroup {
	public var code(default, null):String;
	public var options(default, null):CodeBoxOptions;
	
	private var _bg:FlxSprite;
	private var _text:FlxText;
	
	private var _scrollY:Float = 0;
	private var _maxScroll:Float = 0;
	private var _padding:Float;
	
	public function new(X:Float = 0, Y:Float = 0, code:String, ?options:CodeBoxOptions) {
		super(X, Y);
		this.code = code;
		this.options = options != null ? options : {};
		
		var w = this.options.width != null ? this.options.width : 400;
		var h = this.options.height != null ? this.options.height : 160;
		var bgCol = this.options.backgroundColor != null ? this.options.backgroundColor : 0xFF222222;
		var fSize = this.options.fontSize != null ? this.options.fontSize : 14;
		_padding = this.options.padding != null ? this.options.padding : 10;
		
		_bg = new FlxSprite(x, y).makeGraphic(Std.int(w), Std.int(h), bgCol);
		add(_bg);
		
		var textW = w - (_padding * 2);
		_text = new FlxText(x + _padding, y + _padding, textW, code, fSize);
		
		if (this.options.font != null) {
			_text.font = this.options.font;
		} else if (easel.Easel.defaultMonospaceFont != null) {
			_text.font = easel.Easel.defaultMonospaceFont;
		} else if (easel.Easel.defaultFont != null) {
			_text.font = easel.Easel.defaultFont;
		}
		
		// Apply formatting BEFORE height calculations because it might affect bounds
		applySyntaxHighlighting();
		
		// Setup scrolling if text exceeds height
		var contentHeight = _text.height;
		var visibleHeight = h - (_padding * 2);
		
		if (contentHeight > visibleHeight) {
			_maxScroll = contentHeight - visibleHeight;
			_text.clipRect = new FlxRect(0, 0, _text.width, visibleHeight);
		}
		
		add(_text);
	}
	
	override public function update(elapsed:Float):Void {
		super.update(elapsed);
		
		if (_maxScroll > 0 && FlxG.mouse.wheel != 0) {
			// Check if mouse is hovering over the CodeBox
			if (FlxG.mouse.x >= x && FlxG.mouse.x <= x + _bg.width &&
				FlxG.mouse.y >= y && FlxG.mouse.y <= y + _bg.height) {
				
				_scrollY -= FlxG.mouse.wheel * 30; // 30 pixels per notch
				_scrollY = FlxMath.bound(_scrollY, 0, _maxScroll);
				
				// Move text up locally
				_text.y = this.y + _padding - _scrollY;
				
				// Shift the clip rect down locally by the same amount so it stays fixed relative to the background
				var clip = _text.clipRect;
				clip.y = _scrollY;
				_text.clipRect = clip; // trigger setter
			}
		}
	}
	
	private function applySyntaxHighlighting():Void {
		var kwColor:FlxColor = 0xFF569CD6; // Blue keywords
		var typeColor:FlxColor = 0xFF4EC9B0; // Teal types
		var strColor:FlxColor = 0xFFCE9178; // Orange strings
		var commentColor:FlxColor = 0xFF6A9955; // Green comments
		var defaultColor:FlxColor = 0xFFD4D4D4; // Light gray default
		
		_text.color = defaultColor;
		
		// Helper function to apply color to matches
		var applyRegex = function(regexStr:String, color:FlxColor) {
			var r = new EReg(regexStr, "gm");
			var searchStr = code;
			var offset = 0;
			
			while (r.match(searchStr)) {
				var pos = r.matchedPos();
				var startIdx = offset + pos.pos;
				var endIdx = startIdx + pos.len;
				_text.addFormat(new flixel.text.FlxText.FlxTextFormat(color), startIdx, endIdx);
				
				// Advance
				searchStr = searchStr.substring(pos.pos + pos.len);
				offset += pos.pos + pos.len;
			}
		};
		
		// Haxe Keywords (whole words)
		var keywords = ["var", "function", "new", "class", "package", "import", "public", "private", "override", "true", "false", "null", "if", "else", "for", "while", "return", "extends", "implements", "interface", "typedef", "macro", "static", "inline"];
		applyRegex("\\b(" + keywords.join("|") + ")\\b", kwColor);
		
		// Common Types (capitalized words usually)
		var types = ["Int", "Float", "String", "Bool", "Void", "Array", "Dynamic", "FlxSprite", "FlxText", "FlxColor", "FlxG", "FlxSpriteGroup", "Card", "Typewriter", "Button", "Banner", "Carousel", "Checkbox", "Slider", "ChatBox"];
		applyRegex("\\b(" + types.join("|") + ")\\b", typeColor);
		
		// Strings (anything inside "")
		applyRegex("\"[^\"]*\"", strColor);
		
		// Comments (// to end of line)
		applyRegex("//.*", commentColor);
	}
}
