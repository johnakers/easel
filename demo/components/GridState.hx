package components;

import flixel.FlxState;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import easel.inputs.Button;
import easel.components.Grid;
import easel.components.Typewriter;

import utils.DemoUtils;
import easel.Easel;

class GridState extends FlxState {
	private var grid:Grid;
	private var isGridVisible:Bool = true;
	
	override public function create():Void {
		super.create();
		
		add(DemoUtils.createHeader("Home / Components / Grid", function() { FlxG.switchState(ComponentsState.new); }));
		
		// Create a grid taking up the central area
		grid = new Grid(20, 80, {
			width: 1240,
			height: 400,
			cellSize: 8,
			showGrid: true
		});
		
		// Add some components aligned strictly to the grid
		var btn = new Button(0, 0, "Aligned Button", { backgroundColor: FlxColor.BLUE });
		grid.addAt(btn, 10, 5); // x: 80, y: 40
		
		var txt = new FlxText(0, 0, 0, "I am perfectly snapped to the grid!", 16);
		if (Easel.defaultFont != null) txt.font = Easel.defaultFont;
		grid.addAt(txt, 10, 12); // x: 80, y: 96
		
		var typewriter = new Typewriter(0, 0, "Dynamic scaling components work too.", 1.5, true, {
			fontSize: 16,
			fontColor: FlxColor.YELLOW
		});
		grid.addAt(typewriter, 40, 20); // x: 320, y: 160
		
		add(grid);
		
		// Toggle button
		var toggleBtn = new Button(FlxG.width / 2 - 100, 490, "Toggle Debug Grid", {
			backgroundColor: 0xFF222222,
			hoverBackgroundColor: 0xFF444444,
			onClick: function() {
				isGridVisible = !isGridVisible;
				grid.toggleGrid(isGridVisible);
			}
		});
		add(toggleBtn);
		
		add(DemoUtils.createUsageBox(
"var myGrid = new Grid(0, 0, {
    width: 600,
    height: 400,
    cellSize: 16, // Default is 8
    showGrid: true // Draws debug grid lines
});

var btn = new Button(0, 0, \"Submit\");

// Snap button to column 10, row 5
// Automatically computes x = 160, y = 80
myGrid.addAt(btn, 10, 5);

add(myGrid);", "source/easel/components/Grid.hx"
		));
	}
}
