package easel.components;

import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.text.FlxBitmapText;
import flixel.graphics.frames.FlxBitmapFont;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.FlxG;
import easel.animations.TypewriterAnimation;

typedef TypewriterOptions = {
	?font:String,
	?fontSize:Int,
	?fontColor:FlxColor,
	?bitmapFont:FlxBitmapFont,
	?soundAsset:String,
	?autoHandleInput:Bool,
	?onComplete:Void->Void,
	?fieldWidth:Float
}

class Typewriter extends FlxSpriteGroup {
	public var message(default, null):String;
	public var messageTime(default, null):Float;
	public var hasAnimation(default, null):Bool;
	public var options(default, null):TypewriterOptions;
	public var isComplete(default, null):Bool = false;

	private var _singleText:FlxText;
	private var _singleBitmapText:FlxBitmapText;

	private var _currentIndex:Int = 0;
	private var _timer:FlxTimer;
	private var _currentX:Float = 0;

	public function new(X:Float, Y:Float, message:String, messageTime:Float, hasAnimation:Bool = false, ?options:TypewriterOptions) {
		super(X, Y);

		this.message = message;
		this.messageTime = messageTime;
		this.hasAnimation = hasAnimation;
		
		// Set default options
		this.options = options != null ? options : {};
		if (this.options.fontSize == null) this.options.fontSize = 16;
		if (this.options.fontColor == null) this.options.fontColor = FlxColor.WHITE;
		if (this.options.autoHandleInput == null) this.options.autoHandleInput = true;

		startTyping();
	}

	public function startTyping():Void {
		// Clean up previous run if any
		clear();
		_singleText = null;
		_singleBitmapText = null;
		_currentIndex = 0;
		_currentX = 0;
		isComplete = false;
		
		if (_timer != null) {
			_timer.cancel();
		}

		if (message == null || message.length == 0) return;

		if (!hasAnimation) {
			if (options.bitmapFont != null) {
				_singleBitmapText = new FlxBitmapText(options.bitmapFont);
				_singleBitmapText.color = options.fontColor;
				_singleBitmapText.x = 0;
				_singleBitmapText.y = 0;
				if (options.fieldWidth != null) _singleBitmapText.fieldWidth = Std.int(options.fieldWidth);
				add(_singleBitmapText);
			} else {
				var fw = options.fieldWidth != null ? options.fieldWidth : 0;
				_singleText = new FlxText(0, 0, fw, "", options.fontSize);
				_singleText.color = options.fontColor;
				if (options.font != null) _singleText.font = options.font;
				else if (easel.Easel.defaultFont != null) _singleText.font = easel.Easel.defaultFont;
				add(_singleText);
			}
		}

		var interval = messageTime / message.length;
		_timer = new FlxTimer().start(interval, onTimerTick, message.length);
	}

	private function onTimerTick(timer:FlxTimer):Void {
		if (_currentIndex >= message.length) return;

		var char = message.charAt(_currentIndex);
		
		if (!hasAnimation) {
			if (_singleBitmapText != null) {
				_singleBitmapText.text = message.substring(0, _currentIndex + 1);
			} else if (_singleText != null) {
				_singleText.text = message.substring(0, _currentIndex + 1);
			}
			
			if (options.soundAsset != null) {
				FlxG.sound.play(options.soundAsset);
			}
			
			_currentIndex++;
		} else {
			var textChar:flixel.FlxSprite;
			
			if (options.bitmapFont != null) {
				var bText = new FlxBitmapText(options.bitmapFont);
				bText.text = char;
				bText.color = options.fontColor;
				bText.x = _currentX;
				bText.y = 0;
				textChar = bText;
			} else {
				var tText = new FlxText(_currentX, 0, 0, char, options.fontSize);
				tText.color = options.fontColor;
				if (options.font != null) {
					tText.font = options.font;
				} else if (easel.Easel.defaultFont != null) {
					tText.font = easel.Easel.defaultFont;
				}
				textChar = tText;
			}
			
			add(textChar);

			TypewriterAnimation.playImpact(textChar);

			if (options.soundAsset != null) {
				FlxG.sound.play(options.soundAsset);
			}

			// Advance X position based on character width
			_currentX += textChar.width;
			_currentIndex++;
		}
		
		if (_currentIndex >= message.length) {
			isComplete = true;
			if (options.onComplete != null) options.onComplete();
		}
	}
	public function skipTyping():Void {
		if (_timer == null) return;
		
		_timer.cancel();
		_timer = null;

		// Save current states so we don't spam sound/animations on skip
		var oldAnim = hasAnimation;
		var oldSound = options.soundAsset;
		
		hasAnimation = false;
		options.soundAsset = null;

		while (_currentIndex < message.length) {
			onTimerTick(null);
		}

		hasAnimation = oldAnim;
		options.soundAsset = oldSound;
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);
		
		// Skip if any key or mouse is pressed
		if (options.autoHandleInput && !isComplete && (FlxG.keys.firstJustPressed() != -1 || FlxG.mouse.justPressed)) {
			skipTyping();
		}
	}
	
	override public function destroy():Void {
		if (_timer != null) {
			_timer.cancel();
			_timer.destroy();
			_timer = null;
		}
		super.destroy();
	}
}
