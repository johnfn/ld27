package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.tile.FlxTilemap;
import flixel.group.FlxSpriteGroup;
import flixel.FlxObject;
import flixel.text.FlxText;

class DialogBox extends FlxSpriteGroup {
	public var text:Array<String>;
	public var textbox:FlxText;
	public var nextText:Int = 0;

	public function new(text:Array<String>) {
		super();

		this.text = text;
		textbox = new FlxText(0, FlxG.width / 2, 100, "");

		this.add(textbox);
		next();
	}

	public function next() {
		if (nextText < text.length) {
			textbox.text = text[nextText];
		} else {
			textbox.text = "";
		}

		nextText++;
	}

	public function done():Bool {
		return nextText > text.length;
	}
}