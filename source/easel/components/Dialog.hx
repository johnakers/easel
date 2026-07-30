package easel.components;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxColor;
import easel.components.Card;
import easel.inputs.Button;

typedef DialogOptions = {
	?title:String,
	?description:String,
	?confirmText:String,
	?onConfirm:Void->Void,
	?cancelText:String,
	?onCancel:Void->Void,
	?maskColor:FlxColor,
	?cardWidth:Float,
	?cardBgAsset:String,
	?font:String,
	?content:FlxSprite
}

class Dialog extends FlxSpriteGroup {
	public var options(default, null):DialogOptions;
	private var _mask:FlxSprite;
	private var _card:Card;

	public function new(?options:DialogOptions) {
		super(0, 0);

		this.options = options != null ? options : {};

		var maskColor = this.options.maskColor != null ? this.options.maskColor : 0x88000000;
		var confirmText = this.options.confirmText != null ? this.options.confirmText : "OK";

		// Draw mask
		_mask = new FlxSprite(0, 0);
		_mask.makeGraphic(FlxG.width, FlxG.height, maskColor);
		add(_mask);

		// Build Footer buttons
		var footerGroup = new FlxSpriteGroup();
		var currentBtnX:Float = 0;
		
		if (this.options.cancelText != null) {
			var cancelBtn = new Button(currentBtnX, 0, this.options.cancelText, {
				onClick: function() {
					if (this.options.onCancel != null) this.options.onCancel();
					hide();
				},
				backgroundColor: 0xFF555555,
				hoverBackgroundColor: 0xFF777777,
				padding: 10
			});
			footerGroup.add(cancelBtn);
			currentBtnX += cancelBtn.width + 10;
		}

		var confirmBtn = new Button(currentBtnX, 0, confirmText, {
			onClick: function() {
				if (this.options.onConfirm != null) this.options.onConfirm();
				hide();
			},
			backgroundColor: 0xFF007BFF, // Blue
			hoverBackgroundColor: 0xFF3399FF,
			padding: 10
		});
		footerGroup.add(confirmBtn);

		var cardOpts:CardOptions = {
			title: this.options.title,
			description: this.options.description,
			content: this.options.content,
			footer: footerGroup,
			width: this.options.cardWidth != null ? this.options.cardWidth : 350,
			bgAsset: this.options.cardBgAsset,
			font: this.options.font,
			padding: 20
		};

		_card = new Card(0, 0, cardOpts);
		
		// Center the card on the screen
		_card.x = (FlxG.width - _card.width) / 2;
		_card.y = (FlxG.height - _card.height) / 2;
		add(_card);
	}

	public function show():Void {
		this.visible = true;
		this.active = true;
	}

	public function hide():Void {
		this.visible = false;
		this.active = false;
	}
}
