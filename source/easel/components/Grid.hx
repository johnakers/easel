package easel.components;

import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;
import flixel.FlxG;

typedef GridOptions = {
	?width:Float,
	?height:Float,
	?cellSize:Int,
	?showGrid:Bool
}

class Grid extends FlxSpriteGroup {
	public var options(default, null):GridOptions;
	private var _gridOverlay:FlxSprite;
	private var _isGridDrawn:Bool = false;
	
	public function new(X:Float = 0, Y:Float = 0, ?options:GridOptions) {
		super(X, Y);
		
		this.options = options != null ? options : {};
		var w = this.options.width != null ? this.options.width : FlxG.width;
		var h = this.options.height != null ? this.options.height : FlxG.height;
		var show = this.options.showGrid != null ? this.options.showGrid : false;
		
		_gridOverlay = new FlxSprite(0, 0);
		_gridOverlay.makeGraphic(Std.int(w), Std.int(h), FlxColor.TRANSPARENT, true);
		add(_gridOverlay);
		
		if (show) {
			drawGridLines();
		}
	}
	
	public function addAt(child:FlxSprite, col:Int, row:Int):Void {
		var size = this.options.cellSize != null ? this.options.cellSize : 8;
		child.x = col * size;
		child.y = row * size;
		add(child);
	}
	
	public function toggleGrid(show:Bool):Void {
		if (show && !_isGridDrawn) {
			drawGridLines();
		}
		_gridOverlay.visible = show;
	}
	
	private function drawGridLines():Void {
		if (_isGridDrawn) return;
		
		var w = this.options.width != null ? this.options.width : FlxG.width;
		var h = this.options.height != null ? this.options.height : FlxG.height;
		var size = this.options.cellSize != null ? this.options.cellSize : 8;
		
		var lineStyle:flixel.util.FlxSpriteUtil.LineStyle = { color: 0x88444444, thickness: 1 };
		
		// Draw vertical lines
		var currentX = 0;
		while (currentX <= w) {
			FlxSpriteUtil.drawLine(_gridOverlay, currentX, 0, currentX, h, lineStyle);
			currentX += size;
		}
		
		// Draw horizontal lines
		var currentY = 0;
		while (currentY <= h) {
			FlxSpriteUtil.drawLine(_gridOverlay, 0, currentY, w, currentY, lineStyle);
			currentY += size;
		}
		
		_isGridDrawn = true;
	}
}
