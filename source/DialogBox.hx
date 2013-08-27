package;

using StringTools;

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
	public var dialogContainer:FlxSprite;
	public var text:Array<String>;
	public var textbox:FlxText;
	public var nextText:Int = 0;
	public var speakerTxt:FlxText;

	public function new() {
		super();

		this.dialogContainer = new FlxSprite(100, 150);
		add(dialogContainer);

		textbox = new FlxText(180, 170, FlxG.width - 340, "", 16);
		textbox.useShadow = true;

		this.add(textbox);

		speakerTxt = new FlxText(125, 273, 150, "", 10);
		speakerTxt.useShadow = true;
		this.add(speakerTxt);

		this.visible = false;

		this.transformChildren(function(c:FlxSprite, theHaxeFlixelTeamDontUnderstandClosures:Dynamic) {
			c.scrollFactor.x = 0;
			c.scrollFactor.y = 0;
		});
	}

	public function display(text:Array<String>) {
		this.text = text;
		this.visible = true;
		next();
	}

	public function next() {
		if (nextText >= text.length) {
			nextText++;
			return;
		}

		var speaker:String = text[nextText];
		dialogContainer.loadGraphic('images/dialog-$speaker.png');
		nextText++;

		if (speaker.startsWith("you")) speaker = "You";
		if (speaker.startsWith("randomnpc")) speaker = "Some random person";
		if (speaker.startsWith("prof")) speaker = "Professor";

		speakerTxt.text = speaker;

		if (nextText < text.length) {
			textbox.text = text[nextText];
			trace(textbox.text);
		} else {
			textbox.text = "";
		}

		nextText++;
	}

	public function backToNormal() {
		nextText = 0;
		this.visible = false;
	}

	public function done():Bool {
		return nextText > text.length;
	}
}