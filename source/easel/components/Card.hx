package easel.components;

import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;

typedef CardOptions = {
	?width:Float,
	?backgroundColor:FlxColor,
	?borderColor:FlxColor,
	?padding:Float,
	?gap:Float,
	?bgAsset:String,
	?font:String,
	?title:String,
	?description:String,
	?header:FlxSprite,
	?content:FlxSprite,
	?footer:FlxSprite
}

class Card extends FlxSpriteGroup {
	public var options(default, null):CardOptions;
	private var _bg:FlxSprite;
	
	public function new(X:Float = 0, Y:Float = 0, ?options:CardOptions) {
		super(X, Y);
		
		this.options = options != null ? options : {};
		
		var bgColor = this.options.backgroundColor != null ? this.options.backgroundColor : 0xFF1E1E1E; // Dark gray
		var borderColor = this.options.borderColor != null ? this.options.borderColor : 0xFF333333; // Light gray
		var padding = this.options.padding != null ? this.options.padding : 16.0;
		var gap = this.options.gap != null ? this.options.gap : 16.0;
		
		var currentY = padding;
		var maxWidth:Float = 0;
		
		var maxTextW = 0.0;
		if (this.options.width != null) {
			maxTextW = this.options.width - (padding * 2);
		}
		
		var elements:Array<FlxSprite> = [];
		
		// Title
		if (this.options.title != null) {
			var titleText = new FlxText(padding, currentY, maxTextW, this.options.title, 22);
			titleText.color = FlxColor.WHITE; 
			if (this.options.font != null) titleText.font = this.options.font;
			else if (easel.Easel.defaultFont != null) titleText.font = easel.Easel.defaultFont;
			elements.push(titleText);
			
			if (titleText.width > maxWidth) maxWidth = titleText.width;
			currentY += titleText.height;
			
			// If no description, add standard gap. Description adds its own gap.
			if (this.options.description == null) currentY += gap;
		}
		
		// Description
		if (this.options.description != null) {
			// small gap between title and description
			if (this.options.title != null) currentY += 4; 
			
			var descText = new FlxText(padding, currentY, maxTextW, this.options.description, 14);
			descText.color = 0xFFAAAAAA; // Gray text
			if (this.options.font != null) descText.font = this.options.font;
			else if (easel.Easel.defaultFont != null) descText.font = easel.Easel.defaultFont;
			elements.push(descText);
			
			if (descText.width > maxWidth) maxWidth = descText.width;
			currentY += descText.height + gap;
		}
		
		// Custom Header
		if (this.options.header != null) {
			this.options.header.x = padding;
			this.options.header.y = currentY;
			elements.push(this.options.header);
			
			if (this.options.header.width > maxWidth) maxWidth = this.options.header.width;
			currentY += this.options.header.height + gap;
		}
		
		// Content
		if (this.options.content != null) {
			this.options.content.x = padding;
			this.options.content.y = currentY;
			elements.push(this.options.content);
			
			if (this.options.content.width > maxWidth) maxWidth = this.options.content.width;
			currentY += this.options.content.height + gap;
		}
		
		// Footer
		if (this.options.footer != null) {
			this.options.footer.x = padding;
			this.options.footer.y = currentY;
			elements.push(this.options.footer);
			
			if (this.options.footer.width > maxWidth) maxWidth = this.options.footer.width;
			currentY += this.options.footer.height + gap;
		}
		
		// Calculate final dimensions
		var finalHeight = currentY - gap + padding;
		if (elements.length == 0) finalHeight = padding * 2; // empty card
		
		var finalWidth = this.options.width != null ? this.options.width : (maxWidth + padding * 2);
		if (finalWidth < padding * 2) finalWidth = padding * 2;

		// Draw background
		_bg = new FlxSprite(0, 0);
		
		if (this.options.bgAsset != null) {
			_bg.loadGraphic(this.options.bgAsset);
			_bg.setGraphicSize(Std.int(finalWidth), Std.int(finalHeight));
			_bg.updateHitbox();
		} else {
			_bg.makeGraphic(Std.int(finalWidth), Std.int(finalHeight), FlxColor.TRANSPARENT, true);
			// Draw rounded rectangle
			FlxSpriteUtil.drawRoundRect(_bg, 0, 0, finalWidth, finalHeight, 10, 10, bgColor, { color: borderColor, thickness: 1 });
		}
		
		add(_bg);
		
		// Add elements (FlxSpriteGroup automatically offsets them by X and Y)
		for (el in elements) {
			add(el);
		}
	}
}
