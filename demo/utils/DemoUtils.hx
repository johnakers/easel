package utils;

import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import easel.Easel;
import easel.components.Banner;
import easel.inputs.Button;

typedef MenuItem = {
	title:String,
	desc:String,
	onClick:Void->Void
}

class DemoUtils {
	public static function createHeader(breadcrumbs:String, ?onBack:Void->Void):Banner {
		flixel.FlxG.camera.bgColor = 0xFF424242; // Force dark gray background globally
		
		var titleText = new FlxText(0, 0, 0, "Easel", 22);
		titleText.color = FlxColor.YELLOW;
		if (Easel.defaultFont != null) titleText.font = Easel.defaultFont;
		
		var breadText = new FlxText(0, 0, 0, breadcrumbs, 16);
		breadText.color = 0xFFCCCCCC;
		if (Easel.defaultFont != null) breadText.font = Easel.defaultFont;
		
		var rightItem:FlxSprite;
		
		if (onBack != null) {
			rightItem = new Button(0, 0, "Back", { 
				onClick: onBack, 
				fontColor: 0xFF424242,
				backgroundColor: FlxColor.TRANSPARENT,
				hoverFontColor: FlxColor.YELLOW
			});
		} else {
			rightItem = new FlxSprite().makeGraphic(50, 20, FlxColor.TRANSPARENT);
		}
		
		return new Banner(0, 0, [titleText, breadText, rightItem], {
			layout: SPACE_BETWEEN,
			height: 50,
			backgroundColor: 0xFF000000,
			padding: 20
		});
	}
	
	public static function createMenuItem(x:Float, y:Float, title:String, desc:String, onClick:Void->Void):FlxSpriteGroup {
		var grp = new FlxSpriteGroup(x, y);
		
		var btn = new Button(0, 0, title, {
			onClick: onClick,
			backgroundColor: 0xFF333333,
			hoverBackgroundColor: FlxColor.YELLOW
		});
		grp.add(btn);
		
		var descText = new FlxText(btn.width + 15, 0, 0, desc, 14);
		descText.color = 0xFFAAAAAA;
		if (Easel.defaultFont != null) descText.font = Easel.defaultFont;
		
		// Vertically center description next to button
		descText.y = (btn.height - descText.height) / 2;
		
		grp.add(descText);
		
		return grp;
	}
	
	public static function createMenu(items:Array<MenuItem>, startY:Float = 80):FlxSpriteGroup {
		var grp = new FlxSpriteGroup(0, 0);
		
		items.sort(function(a:MenuItem, b:MenuItem):Int {
			var aTitle = a.title.toLowerCase();
			var bTitle = b.title.toLowerCase();
			if (aTitle < bTitle) return -1;
			if (aTitle > bTitle) return 1;
			return 0;
		});
		
		var currentY = startY;
		for (item in items) {
			var btnGrp = createMenuItem(20, currentY, item.title, item.desc, item.onClick);
			grp.add(btnGrp);
			currentY += 50;
		}
		
		return grp;
	}
	
	public static function createUsageBox(usageCode:String, githubUrl:String = ""):FlxSpriteGroup {
		var grp = new FlxSpriteGroup(0, 0); 
		
		var codeBox = new easel.components.CodeBox(0, 0, usageCode, {
			width: 800,
			height: 200
		});
		
		var dialog = new easel.components.Dialog({
			title: "Usage Example",
			content: codeBox,
			confirmText: "Close",
			cardWidth: 840
		});
		dialog.hide();
		
		// Create the Usage button first to measure its height
		var usageBtn = new Button(0, 0, "Usage Details", {
			backgroundColor: 0xFF333333,
			hoverBackgroundColor: 0xFF555555,
			borderColor: 0xFF666666,
			padding: 10,
			onClick: function() {
				dialog.show();
			}
		});
		usageBtn.x = flixel.FlxG.width - usageBtn.width - 20;
		usageBtn.y = flixel.FlxG.height - usageBtn.height - 20;
		grp.add(usageBtn);
		
		// Create the GitHub button if a URL is provided
		if (githubUrl != "") {
			var fullUrl = "https://github.com/johnakers/easel/blob/master/" + githubUrl;
			var ghBtn = new Button(0, 0, "GitHub", {
				backgroundColor: 0xFF333333,
				hoverBackgroundColor: FlxColor.YELLOW,
				hoverFontColor: FlxColor.BLACK,
				borderColor: 0xFF666666,
				padding: 10,
				onClick: function() {
					flixel.FlxG.openURL(fullUrl, "_blank");
				}
			});
			ghBtn.x = flixel.FlxG.width - ghBtn.width - 20;
			ghBtn.y = usageBtn.y - ghBtn.height - 10;
			grp.add(ghBtn);
		}
		
		grp.add(dialog);
		
		return grp;
	}
}
