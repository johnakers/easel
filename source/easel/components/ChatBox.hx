package easel.components;

import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.text.FlxBitmapText;
import flixel.graphics.frames.FlxBitmapFont;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.FlxG;
import easel.Easel;
import easel.components.Typewriter;

typedef ChatBoxOptions = {
	?width:Float,
	?height:Float,
	?screenMargin:Float,
	?margin:Float,
	?padding:Float,
	?textMarginLeft:Float,
	?textMarginTop:Float,
	?backgroundColor:FlxColor,
	?backgroundAsset:String,
	?speaker:String,
	
	?useTypewriter:Bool,
	?typewriterSpeed:Float,
	?font:String,
	?fontSize:Int,
	?fontColor:FlxColor,
	?bitmapFont:FlxBitmapFont,
	?soundAsset:String,
	
	?onComplete:Void->Void,
	?onMessageComplete:Void->Void
}

class ChatBox extends FlxSpriteGroup {
	public var messages(default, null):Array<String>;
	public var options(default, null):ChatBoxOptions;
	
	private var _currentIndex:Int = 0;
	private var _bg:FlxSprite;
	private var _speakerText:FlxText;
	private var _speakerBitmapText:FlxBitmapText;
	private var _typewriter:Typewriter;
	private var _staticText:FlxText;
	private var _staticBitmapText:FlxBitmapText;
	private var _indicator:FlxSprite;

	private var _isTyping:Bool = false;

	public function new(X:Float, Y:Float, messages:Array<String>, ?options:ChatBoxOptions) {
		super(X, Y);
		
		this.messages = messages != null ? messages : [];
		this.options = options != null ? options : {};
		
		// Defaults
		if (this.options.screenMargin == null) this.options.screenMargin = 8;
		if (this.options.margin == null) this.options.margin = 8;
		if (this.options.width == null) this.options.width = FlxG.width - (this.options.screenMargin * 2);
		if (this.options.height == null) this.options.height = 60;
		if (this.options.padding == null) this.options.padding = 8;
		if (this.options.textMarginLeft == null) this.options.textMarginLeft = 0;
		if (this.options.textMarginTop == null) this.options.textMarginTop = 0;
		if (this.options.backgroundColor == null) this.options.backgroundColor = 0xFF888888;
		if (this.options.useTypewriter == null) this.options.useTypewriter = true;
		if (this.options.typewriterSpeed == null) this.options.typewriterSpeed = 2.0;
		if (this.options.fontSize == null) this.options.fontSize = 16;
		if (this.options.fontColor == null) this.options.fontColor = FlxColor.WHITE;
		
		buildBackground();
		buildSpeaker();
		buildIndicator();
		
		showMessage();
	}

	private function buildBackground():Void {
		_bg = new FlxSprite(0, 0);
		if (options.backgroundAsset != null) {
			_bg.loadGraphic(options.backgroundAsset);
			_bg.setGraphicSize(Std.int(options.width), Std.int(options.height));
			_bg.updateHitbox();
		} else {
			_bg.makeGraphic(Std.int(options.width), Std.int(options.height), options.backgroundColor);
		}
		add(_bg);
	}

	private function buildSpeaker():Void {
		if (options.speaker == null || options.speaker.length == 0) return;
		
		if (options.bitmapFont != null) {
			_speakerBitmapText = new FlxBitmapText(options.bitmapFont);
			_speakerBitmapText.text = options.speaker + ":";
			_speakerBitmapText.color = options.fontColor;
			_speakerBitmapText.x = options.margin + options.textMarginLeft;
			_speakerBitmapText.y = options.margin + options.textMarginTop;
			add(_speakerBitmapText);
		} else {
			_speakerText = new FlxText(options.margin + options.textMarginLeft, options.margin + options.textMarginTop, 0, options.speaker + ":", options.fontSize);
			_speakerText.color = options.fontColor;
			if (options.font != null) _speakerText.font = options.font;
			else if (Easel.defaultFont != null) _speakerText.font = Easel.defaultFont;
			add(_speakerText);
		}
	}

	private function buildIndicator():Void {
		_indicator = new FlxSprite();
		
		if (openfl.Assets.exists("assets/images/chatbox-continue.png")) {
			_indicator.loadGraphic("assets/images/chatbox-continue.png");
		} else {
			_indicator.makeGraphic(10, 10, FlxColor.WHITE);
		}
		
		_indicator.x = options.width - _indicator.width - options.margin;
		_indicator.y = options.height - _indicator.height - options.margin;
		_indicator.visible = false;
		add(_indicator);
	}

	private function updateIndicator():Void {
		if (_indicator != null) {
			_indicator.visible = !_isTyping && (_currentIndex < messages.length - 1);
		}
	}
	
	private function paginateText(msg:String, fw:Float, maxH:Float):String {
		var isBmp = options.bitmapFont != null;
		var tempText:FlxText = null;
		var tempBmp:FlxBitmapText = null;
		
		if (isBmp) {
			tempBmp = new FlxBitmapText(options.bitmapFont);
			tempBmp.fieldWidth = Std.int(fw);
		} else {
			tempText = new FlxText(0, 0, fw, "", options.fontSize);
			if (options.font != null) tempText.font = options.font;
			else if (Easel.defaultFont != null) tempText.font = Easel.defaultFont;
		}
		
		var testHeight = function(testStr:String):Float {
			if (isBmp) {
				tempBmp.text = testStr;
				return tempBmp.height;
			} else {
				tempText.text = testStr;
				return tempText.height;
			}
		}
		
		if (testHeight(msg) <= maxH) {
			if (tempText != null) tempText.destroy();
			if (tempBmp != null) tempBmp.destroy();
			return msg;
		}
		
		var words = msg.split(" ");
		var currentStr = "";
		
		for (i in 0...words.length) {
			var w = words[i];
			var testStr = currentStr == "" ? w + "..." : currentStr + " " + w + "...";
			
			if (testHeight(testStr) > maxH) {
				if (currentStr == "") {
					currentStr = w;
					var rest = words.slice(i + 1).join(" ");
					messages.insert(_currentIndex + 1, rest);
					break;
				}
				
				var rest = words.slice(i).join(" ");
				messages.insert(_currentIndex + 1, rest);
				currentStr = currentStr + "...";
				break;
			} else {
				currentStr = currentStr == "" ? w : currentStr + " " + w;
			}
		}
		
		if (tempText != null) tempText.destroy();
		if (tempBmp != null) tempBmp.destroy();
		
		return currentStr;
	}

	private function showMessage():Void {
		if (_currentIndex >= messages.length) {
			if (options.onComplete != null) options.onComplete();
			visible = false; 
			return;
		}
		
		var msg = messages[_currentIndex];
		
		var showSpeaker = (_currentIndex == 0);
		if (_speakerText != null) _speakerText.visible = showSpeaker;
		if (_speakerBitmapText != null) _speakerBitmapText.visible = showSpeaker;

		var textY = options.margin + options.textMarginTop;
		if (showSpeaker && options.speaker != null && options.speaker.length > 0) {
			var speakerHeight = (_speakerText != null) ? _speakerText.height : _speakerBitmapText.height;
			textY += speakerHeight + 4;
		}
		
		var fw = options.width - (options.margin * 2) - options.textMarginLeft;
		var maxH = options.height - textY - options.margin; // Calculate remaining height from textY
		
		msg = paginateText(msg, fw, maxH);
		
		if (_typewriter != null) {
			remove(_typewriter);
			_typewriter.destroy();
			_typewriter = null;
		}
		if (_staticText != null) {
			remove(_staticText);
			_staticText.destroy();
			_staticText = null;
		}
		if (_staticBitmapText != null) {
			remove(_staticBitmapText);
			_staticBitmapText.destroy();
			_staticBitmapText = null;
		}
		
		if (options.useTypewriter) {
			_isTyping = true;
			updateIndicator();
			
			_typewriter = new Typewriter(options.margin + options.textMarginLeft, textY, msg, options.typewriterSpeed, false, {
				font: options.font,
				fontSize: options.fontSize,
				fontColor: options.fontColor,
				bitmapFont: options.bitmapFont,
				soundAsset: options.soundAsset,
				autoHandleInput: false,
				fieldWidth: fw,
				onComplete: function() {
					_isTyping = false;
					updateIndicator();
					if (options.onMessageComplete != null) options.onMessageComplete();
				}
			});
			add(_typewriter);
		} else {
			_isTyping = false;
			updateIndicator();
			
			if (options.bitmapFont != null) {
				_staticBitmapText = new FlxBitmapText(options.bitmapFont);
				_staticBitmapText.text = msg;
				_staticBitmapText.color = options.fontColor;
				_staticBitmapText.x = options.margin + options.textMarginLeft;
				_staticBitmapText.y = textY;
				_staticBitmapText.fieldWidth = Std.int(fw);
				add(_staticBitmapText);
			} else {
				_staticText = new FlxText(options.margin + options.textMarginLeft, textY, fw, msg, options.fontSize);
				_staticText.color = options.fontColor;
				if (options.font != null) _staticText.font = options.font;
				else if (Easel.defaultFont != null) _staticText.font = Easel.defaultFont;
				add(_staticText);
			}
			if (options.onMessageComplete != null) options.onMessageComplete();
		}
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);
		
		if (!visible) return;
		
		if (FlxG.keys.firstJustPressed() != -1 || FlxG.mouse.justPressed) {
			advance();
		}
	}
	
	public function advance():Void {
		if (options.useTypewriter && _typewriter != null && _isTyping) {
			_typewriter.skipTyping();
			_isTyping = false;
			updateIndicator();
		} else {
			_currentIndex++;
			showMessage();
		}
	}
}
