package easel.animations;

import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;

class TypewriterAnimation {
	/**
	 * Plays a quick pop/shrink animation on a text character.
	 */
	public static function playImpact(text:flixel.FlxSprite, duration:Float = 0.1):Void {
		// Set initial scale to be larger
		text.scale.set(1.5, 1.5);
		
		// Tween back to normal size
		FlxTween.tween(text.scale, { x: 1.0, y: 1.0 }, duration, { ease: FlxEase.quadOut });
	}
}
