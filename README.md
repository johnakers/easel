# Easel - HaxeFlixel UI Library

Welcome to Easel, a highly modular, shadcn-inspired UI component library built for HaxeFlixel.

![Easel](assets/images/easel.png)

> [!WARNING]  
> **Buyer Beware:** This project is actively in development. APIs are subject to change, and bugs may be present. Use in production at your own risk!

## Usage

Below are quick-start examples for how to instantiate and use each component in the library.

### DancingText
A fun, Balatro-style text component that applies a bouncing wave animation to its characters. You can customize the wave's speed, height, frequency, and letter spacing.
```haxe
var wavy = new DancingText(x, y, "Hello!", {
    fontSize: 24,
    waveSpeed: 5.0,
    waveHeight: 8.0
});
add(wavy);
```

### Button
A customizable, interactive button component with support for text and bitmap fonts, flat colors, or 9-sliced sprite assets. It automatically centers its label and includes built-in hover and pressed states.
```haxe
var myButton = new Button(x, y, "Click Me", {
    width: 200,
    backgroundColor: 0xFF333333,
    textColor: 0xFFFFFFFF,
    onClick: function() { trace("Clicked!"); }
});
add(myButton);
```

### Carousel
A horizontally scrolling selector perfect for character selection or item galleries. It supports infinite wrap-around, custom spacing, and automatic keyboard navigation.
```haxe
var myCarousel = new Carousel(x, y, [sprite1, sprite2, sprite3], {
    wrapAround: true,
    width: 300,
    gap: 20,
    onChange: function(index, sprite) { trace("Selected: " + index); }
});
add(myCarousel);
```

### ChatBox
An RPG-style dialogue box that sequentially displays an array of text messages. It supports typewriter effects, custom margins for safe text boundaries, and automatic message pagination for overly long strings.
```haxe
var messages = ["Hello!", "How are you today?"];
var chat = new ChatBox(20, 100, messages, {
    width: FlxG.width - 40,
    margin: 24,
    speaker: "Hero",
    onComplete: function() { trace("Done chatting!"); }
});
add(chat);
```

### Checkbox
A standard toggleable checkbox with a label. It seamlessly supports either custom sprite assets for the box/check or fallback flat colored primitives.
```haxe
var myCheckbox = new Checkbox(x, y, {
    label: "Remember Me",
    checked: true,
    boxColor: 0xFF222222,
    checkColor: 0xFF00FF00,
    onToggle: function(isChecked) { trace("Checked: " + isChecked); }
});
add(myCheckbox);
```

### CodeBox
A multi-line text container specifically formatted for displaying code snippets. It includes horizontal and vertical scrolling with visual scrollbars.
```haxe
var codeSnippet = "var x = 10;\nvar y = 20;";
var codeBox = new CodeBox(0, 0, codeSnippet, {
    width: 400,
    height: 150
});
add(codeBox);
```

### InputControl
A flex-layout wrapper that pairs a text label with any other Easel component (like a Slider or Checkbox). It automatically manages spacing and alignment between the label and the control.
```haxe
var mySlider = new Slider(0, 0, { width: 200 });
var myControl = new InputControl(x, y, "Volume", mySlider, {
    layout: TWO_COLUMN,
    width: 400, // Pins slider to right edge
    gap: 15
});
add(myControl);
```

### Slider
An interactive horizontal range slider that allows users to pick a value between a minimum and maximum. Supports custom steps, track colors, and fill colors.
```haxe
var mySlider = new Slider(x, y, {
    width: 300,
    min: 0,
    max: 100,
    step: 5,
    fillColor: 0xFF00FF00,
    onChange: function(val) { trace("Volume: " + val); }
});
add(mySlider);
```

### Banner
A top-level navigation bar typically used as a header. It automatically spaces out a list of elements (like a title, breadcrumbs, and a back button) across its full width.
```haxe
var title = new FlxText(0, 0, 0, "My App", 22);
var button = new Button(0, 0, "Settings", { onClick: onSettings });

var myBanner = new Banner(x, y, [title, button], {
    width: 1000,
    height: 60,
    layout: SPACE_BETWEEN,
    backgroundColor: 0xFF222222,
    padding: 20
});
add(myBanner);
```

### Card
A highly composable container module consisting of an optional header, content area, and footer. It serves as the standard building block for larger UI modals and menus.
```haxe
var title = new FlxText(0, 0, 0, "Item Profile", 18);
var desc = new FlxText(0, 0, 0, "This is a description", 14);

var myCard = new Card(x, y, {
    header: title,
    content: desc,
    width: 300,
    gap: 10,
    padding: 20,
    backgroundColor: 0xFF1E1E1E,
    borderColor: 0xFF444444
});
add(myCard);
```

### Typewriter
An animated text component that types out a string character-by-character. It includes audio hookups for typing sound effects and callbacks when the animation finishes.
```haxe
var myTypewriter = new Typewriter(x, y, "Hello World!", 2.0, true, {
    fontSize: 16,
    soundAsset: "assets/sounds/typewriter.wav",
    onComplete: function() { trace("Done typing!"); }
});
add(myTypewriter);
// Call myTypewriter.startTyping() to run the effect.
```

### SlidePanel
An off-screen container that smoothly animates into view from a designated edge of the screen. Perfect for settings menus or slide-out sidebars.
```haxe
var myPanel = new SlidePanel(100, 100, {
    width: 300,
    height: 400,
    slideFrom: "BOTTOM",
    slideDuration: 0.5,
    startHidden: true,
    backgroundColor: 0xFF2A2A2A
});

var txt = new FlxText(20, 20, 0, "Hello World", 16);
myPanel.add(txt);
add(myPanel);

// Show and hide it
myPanel.show();
myPanel.hide();
```

### Grid
An absolute grid snapping system that enforces pixel-perfect alignment for child elements based on a unified cell size.
```haxe
var myGrid = new Grid(0, 0, {
    width: 600,
    height: 400,
    cellSize: 16, // Default is 8
    showGrid: true // Draws debug grid lines
});

var btn = new Button(0, 0, "Submit");
// Snap button to column 10, row 5
// Automatically computes x = 160, y = 80
myGrid.addAt(btn, 10, 5);

add(myGrid);
```

### Dialog
A high-level prompt modal built out of the `Card` component. It abstracts away the layout logic for presenting a title, description, and confirm/cancel buttons.
```haxe
var myDialog = new Dialog({
    title: "Confirm Action",
    description: "Are you sure you want to proceed?",
    confirmText: "Yes",
    cancelText: "No",
    onConfirm: function() { trace("Dialog Confirmation"); }
});
add(myDialog);
myDialog.show();
```

## Assets Needed
To take this library to the next level and swap out our generic primitive color boxes for real UI sprites, please provide the following custom assets (ideal sizes included):

- **Banner:** `banner_bg.png` *(Ideal size: 1000x60 or 9-slice scalable. Currently using `panel.png` as a 9-slice!)*
- **ChatBox:** `chatbox_bg.png` *(Ideal size: 800x120)*

## Notes on 9-Slicing
Easel uses `flixel-addons` under the hood to support 9-slicing for its components (like Banner, Card, etc.). 
To 9-slice an asset:
1. Provide a `slice: new flixel.math.FlxRect(x, y, width, height)` property in the component's options.
2. The `FlxRect` defines the **center region** of your sprite that is allowed to stretch. 
3. The corners (everything outside the `x, y` and `width, height` of your rect) will remain their original un-stretched size, ensuring your borders look crisp no matter how large the component scales!
