package components;

import flixel.FlxState;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import easel.inputs.Button;
import easel.components.Dialog;
import utils.DemoUtils;

class DialogState extends FlxState {
	private var dialog:Dialog;

	override public function create():Void {
		super.create();

		// Add background pattern or color to demonstrate mask
		var bg = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, 0xFF333333);
		add(bg);
		
		add(DemoUtils.createHeader("Components / Dialog", function() { FlxG.switchState(ComponentsState.new); }));

		// Button to trigger the dialog
		var triggerBtn = new Button(0, 0, "Show Dialog", {
			onClick: function() {
				dialog.show();
			},
			backgroundColor: 0xFF222222,
			hoverBackgroundColor: 0xFF555555,
			padding: 15
		});
		triggerBtn.x = (FlxG.width - triggerBtn.width) / 2;
		triggerBtn.y = 200;
		add(triggerBtn);

		var usageCode = "var myDialog = new Dialog({\n" +
			"    title: \"Confirm Action\",\n" +
			"    description: \"Are you sure you want to proceed?\",\n" +
			"    confirmText: \"Yes\",\n" +
			"    cancelText: \"No\",\n" +
			"    onConfirm: function() { trace(\"Dialog Confirmation\"); }\n" +
			"});\n" +
			"add(myDialog);\n" +
			"myDialog.show();";

		add(DemoUtils.createUsageBox(usageCode));

		// Create the dialog
		dialog = new Dialog({
			title: "Confirm Action",
			description: "Are you sure you want to proceed?",
			confirmText: "Yes",
			cancelText: "No",
			onConfirm: function() {
				trace("Dialog Confirmation");
			}
		});
		
		// Hide it initially
		dialog.hide();
		
		// Dialog should be added last so it's on top of everything
		add(dialog);
	}
}
